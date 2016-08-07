class Geno {
  
  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private GenoPart[] geno;

  //----------------------------------------------------------------------------------------------------------------------CONSTRUCTOR
  Geno() {
    geno = new GenoPart[gridDimension];
    for (int i=0; i<gridDimension; i++) {
      geno[i] = new GenoPart();
    }
  }

  //----------------------------------------------------------------------------------------------------------------------METHODS
  GenoPart getGenoPart(int yGT) {
    return geno[yGT];
  }
  
  Interval getIntervalGT(int yGT, int zGT) {
    return geno[yGT].getInterval(zGT);
  }
  
  void setNewIntervalGT(int yGT, int zGT, Interval newIntervalGT) {
    geno[yGT].setNewIntervalGP(zGT, newIntervalGT);
  }
  
}