//----------------------------------------------------------------------------------------------------------------------Crossover
DNA crossover(DNA mother, DNA father) {
  boolean[][][] genesMother = mother.getGenes();
  boolean[][][] genesFather = father.getGenes();
  DNA child = new DNA();
  boolean[][][] genesChild = child.getGenes();

  int splitpoint = int(random((gridDimension*gridDimension*gridHeight)-1));
  for (int k=0; k<gridDimension*gridDimension*gridHeight; k++) {
    if (k < splitpoint) {
      genesChild[int((k%(gridDimension*gridDimension))/gridDimension)][int((k%(gridDimension*gridDimension))%gridDimension)][int(k/(gridDimension*gridDimension))] = genesMother[int((k%(gridDimension*gridDimension))/gridDimension)][int((k%(gridDimension*gridDimension))%gridDimension)][int(k/(gridDimension*gridDimension))];                  //child.genes = partnerA.genes   (int() is naar onder afronden!)
    } else {
      genesChild[int((k%(gridDimension*gridDimension))/gridDimension)][int((k%(gridDimension*gridDimension))%gridDimension)][int(k/(gridDimension*gridDimension))] = genesFather[int((k%(gridDimension*gridDimension))/gridDimension)][int((k%(gridDimension*gridDimension))%gridDimension)][int(k/(gridDimension*gridDimension))];           //child.genes = partnerB.genes
    }
  }
  child.setGenes(genesChild);
  return child;
}

//----------------------------------------------------------------------------------------------------------------------Mutation
void mutate(DNA tower) {
  boolean[][][] genesTower = tower.getGenes();
  for (int i = 0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        if (random(1) < mutationRate) {
          int r = round(random(1));
          if (r==1)    genesTower[i][j][k]=true;
          else         genesTower[i][j][k]=false;
        }
      }
    }
  }
  tower.setGenes(genesTower);
}