import com.nonstop.covid19.api.*;

private static final int TEXT_SIZE = 28;
private static final int LINE_HEIGHT = 35;

VirusService service;

void setup() {
  size(680, 400);
  textSize(TEXT_SIZE);
  service = VirusServiceFactory.create();
}

void draw() {
  try {
    Day day = service.today().execute().body();
    text("Date: " + day.getDate(), 10, 30);
    text("Confirmed: " + day.getConfirmed(), 10, 30 + LINE_HEIGHT);
    text("Deaths:    " + day.getDeaths(), 10, 30 + LINE_HEIGHT * 2);
    text("Recovered: " + day.getRecovered(), 10, 30 + LINE_HEIGHT * 3);
  } catch (IOException e) {
    text(e.getMessage(), 10, 30);
  }
}
