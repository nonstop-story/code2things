import com.nonstop.covid19.api.*;
import com.nonstop.covid19.geometry.*;
import java.util.*;

private static final int TEXT_SIZE = 28;
private static final int LINE_HEIGHT = 35;

private area[] areas = new area[80];//country number
private PImage worldMap;
private VirusService service;

private Timer timer;
private List<Country> allCountries;

List<Country> initializeCountries() {
  try {
    return Countries.from(service.allCountries().execute().body());
  } catch (IOException e) {
    return new ArrayList<Country>();
  }
}

PImage initializeWorldMap() {
  PImage img = loadImage("res/map.png");
  translate(width * 0.5, height * 0.5);
  imageMode(CENTER);
  image(img, 0, 0);
  translate(width * 0.5, height * 0.5);
  imageMode(CENTER);
  return img;
}

Timer initializeTimer(int tickCount) {
  return new Timer(tickCount);
}

void setup() {
  size(1024, 512);
  textSize(TEXT_SIZE);
  
  service = VirusServices.create();
  worldMap = initializeWorldMap();
  allCountries = initializeCountries();
  timer = initializeTimer(allCountries.size());
}

void draw() {
  // TODO: initialize areas or NullPointerException occurs
  //for (int i = 0; i < areas.length; i++) {
  //  areas[i].update();
  //  areas[i].show();
  //}
  
  if (timer.isUpdated()) {
    int tick = timer.getCurrentTick();
    println(String.format("tick: %d, country: %s", tick, allCountries.get(tick)));
  }
  
  timer.tick();
}
