use std::io;
use std::io::prelude::*;
use std::io::BufReader;
use std::net::TcpStream;
use std::sync::mpsc;
use std::thread;
use tui::backend::CrosstermBackend;
use tui::layout::{Constraint, Direction, Layout};
use tui::widgets::{Block, Borders, List, Text};
use tui::Terminal;

#[derive(Default)]
struct App {
    log: Vec<String>,
}

fn main() -> std::io::Result<()> {
    let server = "localhost:9999";
    let (tx, rx) = mpsc::channel();

    let stream = TcpStream::connect(server)?;
    let reader = BufReader::new(stream);

    thread::spawn(move || {
        reader
            .lines()
            .filter_map(|msg| match msg {
                Ok(msg) => Some(msg),
                Err(_) => None,
            })
            .for_each(|line| {
                tx.send(line).unwrap();
            });
    });

    let mut app = App::default();
    let stdout = io::stdout();
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    terminal.clear()?;
    terminal.hide_cursor()?;
    loop {
        match rx.recv() {
            Ok(log) => app.log.push(log),
            _ => (),
        };

        let _ = terminal.draw(|mut f| {
            let chunks = Layout::default()
                .direction(Direction::Vertical)
                .margin(1)
                .constraints([Constraint::Percentage(100)].as_ref())
                .split(f.size());

            let block = Block::default()
                .title("Danmaku Manager (connected to localhost:9999)")
                .borders(Borders::ALL);

            let items = app.log.iter().rev().map(|l| Text::raw(l));

            let list = List::new(items).block(block);

            f.render_widget(list, chunks[0]);
        });
    }
}
