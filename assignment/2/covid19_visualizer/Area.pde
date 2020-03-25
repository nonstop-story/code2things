import com.nonstop.covid19.geometry.*;

class Area {
  Country country;
  float x;
  float y;
  float r;
  float colorMix;
  int time;
  
  Area(Country country) {
    float longitude = (float) country.getLocation().getLongitude();
    float latitude = (float) country.getLocation().getLatitude();
    
    this.country = country;
    x = Map.toX(longitude);
    y = Map.toY(latitude);
    
    debug("Area: %s, longitude: %f, latitude: %f, x: %f, y: %f",
      country.getCountryName(), longitude, latitude, x, y);
    reset();
  }

  void update() {
    --time;
    if (time < 1) {
      reset();
    }
  }
  
  void reset() {
    time = 127;
    r = 0;
    colorMix = 0;
    
    List<Day> days = country.getDays();
    if (days.size() > 0) {
      int confirmed = days.get(days.size() - 1).getConfirmed();
      r = map(log(confirmed), 0, 5, 0, 40);
      colorMix = map(confirmed, 0, 100000, 0, 255);
    }
  }
  
  void show() {
    fill(255, colorMix, 0);
    noStroke();
    circle(x, y, r);
  }
}
