import com.nonstop.covid19.api.*;
import com.nonstop.covid19.geometry.*;
import java.util.*;

private static final boolean DEBUG = true;

private VirusService service;
private Timer timer;
private List<Country> allCountries;
private List<Area> areas;

private boolean loadSuccessful = false;
private boolean firstDraw = true;

List<Country> initializeCountries() {
  try {
    return Countries.from(service.allCountries().execute().body());
  } catch (IOException e) {
    System.err.println("Error requesting api: " + e.getMessage());
    return new ArrayList<Country>();
  }
}

List<Area> initializeAreas(List<Country> countries) {
  ArrayList<Area> list = new ArrayList<Area>();
  for (Country c : countries) {
    list.add(new Area(c));
  }
  return list;
}

void initializeWorldMap() {
  PImage img = loadImage("res/map.png");
  translate(width * 0.5, height * 0.5);
  imageMode(CENTER);
  image(img, 0, 0);
}

Timer initializeTimer(int tickCount) {
  return new Timer(tickCount);
}

void setup() {
  size(1024, 512);
  textSize(28);
  
  service = VirusServices.create();
  initializeWorldMap();
}

/**
 * Put time-consuming operations out of the setup() method.
 * Let the user see the world map during the network request,
 * instead of just showing a gray background with nothing meaningful.
 */
void lazySetup() {
  allCountries = initializeCountries();
  areas = initializeAreas(allCountries);
  timer = initializeTimer(allCountries.size());
  
  loadSuccessful = allCountries.size() > 0;
}

void draw() {
  if (firstDraw) {
    debug("Lazy setup");
    lazySetup();
    firstDraw = false;
  }
  
  if (!loadSuccessful) {
    debug("Load data failed, skip drawing");
    return;
  }
  
  if (timer.isUpdated()) {
    int tick = timer.getCurrentTick();
    debug("tick: %d, country: %s", tick, allCountries.get(tick));
    for (Area a : areas) {
      a.update();
      a.show();
    }
  }
  
  timer.tick();
}

void debug(Object fmt, Object ...args) {
  if (DEBUG) {
    System.out.println(String.format(fmt.toString(), args));
  }
}
