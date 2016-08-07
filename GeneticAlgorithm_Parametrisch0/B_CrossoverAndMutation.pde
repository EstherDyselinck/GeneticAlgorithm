//----------------------------------------------------------------------------------------------------------------------Crossover
DNA crossover(DNA mother, DNA father) {

  int[][] arrayMother = mother.getGenoArrayF();
  int[][] arrayFather = father.getGenoArrayF();

  DNA child = new DNA();
  int[][] arrayChild = child.getGenoArrayF();

  int splitpoint = round(random(1, numberOfTowers-1));
  for (int k=0; k<numberOfTowers; k++) {
    if (k < splitpoint) {
      for (int i=0; i<4; i++) arrayChild[k][i]=arrayMother[k][i];
    } else {
      for (int i=0; i<4; i++) arrayChild[k][i]=arrayFather[k][i];
    }
  }
  child.setGenoArrayF(arrayChild);
  return child;
}

//----------------------------------------------------------------------------------------------------------------------Mutation
void mutate(DNA tower) {

  int[][] genoArray = tower.getGenoArrayF();
  for (int i=0; i<numberOfTowers; i++) {
    if (random(1)<mutationRate) {
      genoArray[i][0]=round(random(gridDimension-1));                          //x-coordinate
      genoArray[i][1]=round(random(gridDimension-1));                          //y-coordinate
      genoArray[i][2]=round(random(gridHeight-1));                             //z
      genoArray[i][3]=round(random((gridHeight-1)-genoArray[i][2]));           //h
    }
  }

  tower.setGenoArrayF(genoArray);
}