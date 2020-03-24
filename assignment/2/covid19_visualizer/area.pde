class area {
  float x;
  float y;//situation
  float r;
  int time;


  area(float longitudeX, float latitudeY, int number) {
    x = longitudeX;
    y = latitudeY;//set position
    r = sqrt(number);
    time = 127;//time is count down
  }

  void update() {
    time -= 1;
    x = 0;
    y = 0;
    if (time < 1) {
      reset();
    }
  }
  void reset() {
  }
  void show() {
    fill(log(r), 0, 0);
    noStroke();
    circle(x, y, r);
  }
}
