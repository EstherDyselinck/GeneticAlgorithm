class Interval {
  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private int[] interval;

  //----------------------------------------------------------------------------------------------------------------------CONSTRUCTOR
  Interval() {
    interval = new int[2];
    interval[0]=round(random(0, gridDimension-1));
    interval[1]=round(random(0, gridDimension-1));
    interval = sort(interval);
  }

  //----------------------------------------------------------------------------------------------------------------------METHODS
  int[] getInterval() {
    return interval;
  }
  
  int getCoo(int number) {
    return interval[number];
  }
  
  void setCoo(int number, int coo) {
    interval[number]=coo;
  }
  
  void sortInterval() {
    interval = sort(interval);
  }
  
  void setNewIntervalI(Interval newIntervalI) {
    interval[0] = newIntervalI.getCoo(0);
    interval[1] = newIntervalI.getCoo(1);
  }
  
}