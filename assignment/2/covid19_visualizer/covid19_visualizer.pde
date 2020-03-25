import com.nonstop.covid19.api.*;
import com.nonstop.covid19.geometry.*;
import java.util.*;

/**
 * The debug flag, set to true to print debug log
 */
private static final boolean DEBUG = true;

/**
 * VirusService performs http requst to the API.
 */
private VirusService service;

/**
 * Because the draw() method get called looply,
 * whose interval is uncertain and usually too short.
 * We need the Timer to count real-world time
 * and notify us when a certain time interval arrives.
 */
private Timer timer;

private List<Country> allCountries;
private List<Area> areas;

private boolean loadSuccessful = false;
private boolean firstDraw = true;

/**
 * Request api to get country data
 */
List<Country> initializeCountries() {
  try {
    return Countries.from(service.allCountries().execute().body());
  } catch (IOException e) {
    System.err.println("Error requesting api: " + e.getMessage());
    return new ArrayList<Country>();
  }
}

/**
 * Construct Area from Country.
 * Area is responsible to draw data in a Country.
 */
List<Area> initializeAreas(List<Country> countries) {
  ArrayList<Area> list = new ArrayList<Area>();
  for (Country c : countries) {
    list.add(new Area(c));
  }
  return list;
}

/**
 * Load and display the world map
 */
void initializeWorldMap() {
  PImage img = loadImage("res/map.png");
  imageMode(CENTER);
  image(img, 0, 0);
}

Timer initializeTimer(int tickCount) {
  return new Timer(tickCount);
}

void setup() {
  size(1024, 512);
  textSize(28);
  
  // move cursor to the center of the screen
  translate(width * 0.5, height * 0.5);
  
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
  
  // timer manages a counter from 0 to allCountries.size(),
  // and gets updated(counter increases) every 8 seconds.
  timer = initializeTimer(allCountries.size());
  
  // allCountries should not be empty,
  // otherwise, the http request failed.
  loadSuccessful = allCountries.size() > 0;
}

void draw() {
  // only do lazy setup at first time
  if (firstDraw) {
    debug("Lazy setup");
    lazySetup();
    firstDraw = false;
  }
  
  if (!loadSuccessful) {
    debug("Load data failed, skip drawing");
    return;
  }
  
  // move cursor to the center of the screen
  translate(width * 0.5, height * 0.5);
  
  // refresh every timer update
  if (timer.isUpdated()) {
    // draw areas
    for (Area a : areas) {
      a.update();
      a.show();
    }
  }
  
  // let the timer tick
  timer.tick();
}

void debug(Object fmt, Object ...args) {
  if (DEBUG) {
    System.out.println(String.format(fmt.toString(), args));
  }
}
