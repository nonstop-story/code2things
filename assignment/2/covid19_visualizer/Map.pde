static class Map {
  private static final int ZOOM_LEVEL = 1;
  
  public static float toX(float longitude) {
    return webMercatorX(longitude) - webMercatorX(0.0);
  }
  
  public static float toY(float latitude) {
    return webMercatorY(latitude) - webMercatorY(0.0);
  }
  
  private static float webMercatorX(float longitude){
    longitude = radians(longitude);
    float a = (256 / PI) * pow(2, ZOOM_LEVEL);
    float b = longitude + PI;
    return a * b;
  }

  private static float webMercatorY(float latitude){
      latitude = radians(latitude);
      float a = (256 / PI) * pow(2, ZOOM_LEVEL);
      float b = tan(PI / 4 + latitude / 2);
      float c = PI - log(b);
      return a * c;
  }
}
