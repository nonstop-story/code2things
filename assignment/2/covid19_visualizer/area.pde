class area {
  float x;
  float y;
  float map;//situation
  int time;


  area(float longitudeX, float latitudeY) {
    x=longitudeX;
    y=latitudeY;//set position
    time = 127;//time is count down
  }

  void update() {
    time -=1;
    x=0;
    y=0;
    if (time<1) {
      reset();
    }
  }
  void reset() {
  }
}
