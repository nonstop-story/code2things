class Timer {
  private static final float DEFAULT_INTERVAL = 8.0;
  
  // cut is an ID for single sequence out of whole length cycle.
  // cut corresponds to a table row 
  private int currentTick;
  private int totalTick;
  private boolean updated;

  // cycle is a counter to show how many cycle has been played
  // cut corresponds to a whole data table
  private int cycle;
  private int cycleDurationMS;
  private int cycleDuration;

  // interval is the duration of one single cut.
  private float intervalDuration;
  private int intervalDurationMS;
  
  public Timer(int ticks) {
    this(DEFAULT_INTERVAL, ticks);
  }

  public Timer(float duration, int ticks) {
    intervalDuration = 0;
    currentTick = 0;
    cycleDuration = 0;
    cycleDurationMS = 0;
    updated = false;
    totalTick = ticks;
    intervalDuration = duration;
    intervalDurationMS = int(intervalDuration * 1000);
    cycleDurationMS = intervalDurationMS * totalTick;
  }

  public void tick() {
    int lastTick = currentTick;
    if (millis() > 0) {
      // millis() returns negative when it exeeds interger boundry
      cycle = floor(millis() / cycleDurationMS);
      currentTick = floor ((millis() % cycleDurationMS) / intervalDurationMS);
    } else {
      // in case that millis returns negative after the huge amount of the time.  
      int ms = millis() - Integer.MAX_VALUE;
      cycle = floor(ms / cycleDurationMS);
      currentTick = floor ((ms % cycleDurationMS) / intervalDurationMS);
    }
    if (lastTick != currentTick) {
      updated = true;
    } else {
      updated = false;
    }
  }
  
  public boolean isUpdated() {
    return updated;
  }
  
  public int getCurrentTick() {
    return currentTick;
  }
}
