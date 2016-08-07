class GenoPart {

  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private Interval[] genoPart;

  //----------------------------------------------------------------------------------------------------------------------CONSTRUCTOR
  GenoPart() {
    genoPart = new Interval[gridHeight];
    for (int i=0; i<gridHeight; i++) {
      genoPart[i]=new Interval();
    }
  }

  //----------------------------------------------------------------------------------------------------------------------METHODS
  Interval getInterval(int zG) {
    return genoPart[zG];
  }
  
  void setNewIntervalGP(int zGP, Interval newIntervalGP) {
    genoPart[zGP].setNewIntervalI(newIntervalGP);
  }

  //void drawGenoPart() {
  //  for (int i=0; i<gridHeight; i++) {
  //    int magnifier=20;
  //    int offsetX=200;
  //    int offsetY=800;
  //    stroke(0);
  //    fill(150);
  //    rect(offsetX+(genoPart[i].getCoo(0))*magnifier, offsetY-(i*magnifier), (genoPart[i].getCoo(1)-genoPart[i].getCoo(0))*magnifier, magnifier);
  //  }
  //}
  
}