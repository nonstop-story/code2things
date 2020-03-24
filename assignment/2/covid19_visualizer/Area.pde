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
      r = sqrt(confirmed);
      colorMix = map(confirmed, 0, 500000, 0, 255);
    }
  }
  
  void show() {
    fill(255, colorMix, 0);
    noStroke();
    circle(x, y, r);
  }
}
