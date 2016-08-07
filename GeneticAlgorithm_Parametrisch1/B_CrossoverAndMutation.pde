//----------------------------------------------------------------------------------------------------------------------Crossover
DNA crossover(DNA mother, DNA father) {
  DNA child = new DNA();

  for (int y=0; y<gridDimension; y++) {                                        //Over alle GENOparts lopen
    for (int z=0; z<gridHeight; z++) {                                         //Over alle INTERVALLEN in het genopart lopen
      Interval childInterval = new Interval();
      int motherCoo = mother.getIntervalPT(y, z).getCoo(0);                    //Alle begins komen van de MOTHER
      int fatherCoo = father.getIntervalPT(y, z).getCoo(1);                    //Alle eindes komen van de FATHER
      childInterval.setCoo(0, motherCoo);
      childInterval.setCoo(1, fatherCoo);
      
      childInterval.sortInterval();
      child.setNewIntervalPT(y, z, childInterval);
    }
  }

  return child;
}

//----------------------------------------------------------------------------------------------------------------------Mutation
void mutate(DNA tower) {
  for (int y=0; y<gridDimension; y++) {                               // Loop over alle genoParts (de y-richting)
    for (int z=0; z<gridHeight; z++) {                                // Loop over alle intervallen in 1 genoPart (de z-richting)
      if (random(1) < mutationRate) {
        Interval newInterval = new Interval();
        tower.setNewIntervalPT(y, z, newInterval);
      }
    }
  }
}