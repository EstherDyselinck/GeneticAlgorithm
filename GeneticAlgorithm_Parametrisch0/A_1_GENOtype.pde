class Geno {

  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private int[][] geno;

  //----------------------------------------------------------------------------------------------------------------------CONSTRUCTOR
  Geno() {
    geno = new int[numberOfTowers][4];

    for (int i=0; i<numberOfTowers; i++) {
      geno[i][0]=round(random(gridDimension-1));                          //x-coordinate
      geno[i][1]=round(random(gridDimension-1));                          //y-coordinate
      geno[i][2]=round(random(gridHeight-1));                             //z
      geno[i][3]=round(random((gridHeight-1)-geno[i][2]));                //h
    }
  }

  //----------------------------------------------------------------------------------------------------------------------METHODS
  int[][] getGenoArrayG() {
    return geno;
  }

  void setGenoArrayG(int[][] genoArrayG) {
    for (int i=0; i<numberOfTowers; i++) {
      geno[i][0]=genoArrayG[i][0];
      geno[i][1]=genoArrayG[i][1];
      geno[i][2]=genoArrayG[i][2];
      geno[i][3]=genoArrayG[i][3];
    }
  }
}