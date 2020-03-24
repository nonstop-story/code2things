import com.nonstop.covid19.api.*;
area[] areas = new area[80];//country number
PImage img;
private static final int TEXT_SIZE = 28;
private static final int LINE_HEIGHT = 35;

VirusService service;

void setup() {
  size(1024, 512);
  textSize(TEXT_SIZE);
  service = VirusServices.create();

  img = loadImage("map.png");
  translate(width * 0.5, height * 0.5);
  imageMode(CENTER);
  image(img, 0, 0);
  translate(width * 0.5, height * 0.5);
  imageMode(CENTER);
}

void draw() {
  try {
    Day day = service.today().execute().body();
    fill(0);
    text("Date: " + day.getDate(), 10, 30);
    fill(#FF0000);
    text("Confirmed: " + day.getConfirmed(), 10, 30 + LINE_HEIGHT * 2);
    fill(0);
    text("Deaths:    " + day.getDeaths(), 10, 30 + LINE_HEIGHT * 3);
    fill(#0099FF);
    text("Recovered: " + day.getRecovered(), 10, 30 + LINE_HEIGHT * 4);
  } 
  catch (IOException e) {
    text(e.getMessage(), 10, 30);
  }
  for (int i = 0; i < areas.length; i++) {
    areas[i].update();
    areas[i].show();
  }
}
