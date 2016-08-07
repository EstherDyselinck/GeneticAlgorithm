class Population {

  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private DNA[] population;             // Array to hold the current population
  private ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"

  //Properties of the best highrise in the population
  private float bestFitness;
  private float secondBestFitness;
  private float thirdBestFitness;
  private float worstFitness;
  private int bestIndex;
  private int secondBestIndex;
  private int thirdBestIndex;
  private int worstIndex;
  private float bestCalcRateOfFilling;
  private int number90;

  private float bestFitnessStructure;
  private float bestFitnessFreeSides;
  private float bestFitnessRateOfFilling;
  private float bestFitnessLight;
  private float bestFitnessGrouping;
  private float bestFitnessGreen;
  private float bestFitnessOpenness;

  //----------------------------------------------------------------------------------------------------------------------CONSTRUCTOR
  Population() {

    population = new DNA[sizePopulation];
    for (int i=0; i<sizePopulation; i++) {
      population[i] = new DNA();
    }

    matingPool = new ArrayList<DNA>();
  }

  //----------------------------------------------------------------------------------------------------------------------METHODS

  //----------------------------------------------------------------------------------------------------------------------[Calculate fitness and execute natural selection: create a matingpool]
  void calculateFitnessAndNaturalSelection() {
    matingPool.clear();
    bestFitness=0;
    secondBestFitness=0;
    thirdBestFitness=0;
    worstFitness=1;
    bestIndex=0;
    secondBestIndex=0;
    thirdBestIndex=0;
    worstIndex=0;
    number90=0;

    for (int i=0; i<sizePopulation; i++) {
      population[i].setFitnesses();

      //search the best highrise and save the properties of this highrise
      if (population[i].getTotalFitness() > bestFitness) {
        bestFitness = population[i].getTotalFitness();
        bestIndex = i;

        bestFitnessStructure = population[i].getFitnessStructure();
        bestFitnessFreeSides = population[i].getFitnessFreeSides();
        bestFitnessRateOfFilling = population[i].getFitnessRateOfFilling();
        bestFitnessLight = population[i].getFitnessLight();
        bestFitnessGrouping = population[i].getFitnessGrouping();
        bestFitnessGreen = population[i].getFitnessGreen();
        bestFitnessOpenness = population[i].getFitnessOpenness();

        bestCalcRateOfFilling = population[i].getCalcRateOfFilling();
      }

      //search the worst highrise and save fitness      
      if (population[i].getTotalFitness() < worstFitness) {
        worstFitness = population[i].getTotalFitness();
        worstIndex=i;
      }

      //count number of towers with a fitness equal to or higher than 90%      
      if (population[i].getTotalFitness() >= 0.9) {
        number90++;
      }

      //create the mating pool
      int n = max(1, round(population[i].getTotalFitness() * 100));
      for (int j=0; j<n; j++) {
        matingPool.add(population[i]);
      }
    }
    
    //save the 2nd and 3rd best highrise
    for (int i=0; i<sizePopulation; i++) {
      if (i!=bestIndex && population[i].getTotalFitness()>secondBestFitness && population[i].getTotalFitness()<=bestFitness) secondBestIndex=i;
    }
    for (int i=0; i<sizePopulation; i++) {
      if (i!=secondBestIndex && population[i].getTotalFitness()>thirdBestFitness && population[i].getTotalFitness()<=secondBestFitness) thirdBestIndex=i;
    }
    
  }

  //----------------------------------------------------------------------------------------------------------------------[Generate: create a new generation]
  void generate() {
    // Refill the population with children from the mating pool
    for (int i=0; i<sizePopulation; i++) {
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));
      DNA partnerA = matingPool.get(a);
      DNA partnerB = matingPool.get(b);
      DNA child = crossover(partnerA, partnerB);
      mutate(child);
      population[i] = child;
    }
  }

  //----------------------------------------------------------------------------------------------------------------------[Display the best highrise of the population]
  void displayBest() {

    //display info
    //if (pause) {
    background(255);
    cam.beginHUD();
    fill(0);
    textSize(10);
    text("generations:", 10, 10);                            
    text(generations, 160, 10);
    text("mutation rate:", 10, 25);                          
    text(round(mutationRate * 100) + "%", 160, 25);
    text("best fitness per generation:", 10, 40);            
    text(bestFitness, 160, 40);
    if (n1!=0) {  
      text("fitnessStructure:", 10, 60);                       
      text(bestFitnessStructure, 160, 60);
    }
    if (n2!=0) {
      text("fitnessFreeSides:", 10, 75);                       
      text(bestFitnessFreeSides, 160, 75);
    }
    if (n3!=0) {
      text("fitnessRateOfFilling:", 10, 90);                   
      text(bestFitnessRateOfFilling, 160, 90);
    }
    if (n4!=0) {
      text("fitnessLight:", 10, 105);                          
      text(bestFitnessLight, 160, 105);
    }
    if (n5!=0) {
      text("fitnessGrouping:", 10, 120);                       
      text(bestFitnessGrouping, 160, 120);
    }
    if (n6!=0) {
      text("fitnessGreen:", 10, 135);                          
      text(bestFitnessGreen, 160, 135);
    }
    if (n7!=0) {
      text("fitnessOpenness:", 10, 155);                       
      text(bestFitnessOpenness, 160, 155);
    }

    text("rate of filling:", 10, 185);                       
    text(bestCalcRateOfFilling, 160, 185);

    text("colour: "+ colourSet, 10, 220);
    text("testNumber: "+ testNumber, 10, 235);
    cam.endHUD();
    //}

    //display image
    if (pause) {
      int offset = 500;
      population[bestIndex].calculateColours();
      for (int i=0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            if (population[bestIndex].getGenes()[i][j][k]) {
              pushMatrix();
              translate(30*i+offset, 30*j, 30*k);
              stroke(0);
              fill(colourRed[i][j][k], colourGreen[i][j][k], colourBlue[i][j][k]);
              box(30);
              popMatrix();
            }
          }
        }
      }
    }
  }

  //----------------------------------------------------------------------------------------------------------------------[Write properties of the best highrise in table]
  void writeTableFitness() {
    if (testNumber==1) {
      TableRow newRow = tableFitness.addRow();
      newRow.setInt("generation", generations);
      newRow.setFloat("best fitness"+testNumber, bestFitness);
      newRow.setFloat("worst fitness"+testNumber, worstFitness);
      if (n1!=0)    newRow.setFloat("fitnessStructure"+testNumber, bestFitnessStructure);
      if (n2!=0)    newRow.setFloat("fitnessFreeSides"+testNumber, bestFitnessFreeSides);
      if (n3!=0)    newRow.setFloat("fitnessRateOfFilling"+testNumber, bestFitnessRateOfFilling);
      if (n4!=0)    newRow.setFloat("fitnessLight"+testNumber, bestFitnessLight);
      if (n5!=0)    newRow.setFloat("fitnessGrouping"+testNumber, bestFitnessGrouping);
      if (n6!=0)    newRow.setFloat("fitnessGreen"+testNumber, bestFitnessGreen);
      if (n7!=0)    newRow.setFloat("fitnessOpenness"+testNumber, bestFitnessOpenness);
      newRow.setFloat("rate of filling"+testNumber, bestCalcRateOfFilling);
      newRow.setInt("number above 90%"+testNumber, number90);
    } else {
      tableFitness.setInt(generations, "generation", generations);
      tableFitness.setFloat(generations, "best fitness"+testNumber, bestFitness);
      tableFitness.setFloat(generations, "worst fitness"+testNumber, worstFitness);
      if (n1!=0)    tableFitness.setFloat(generations, "fitnessStructure"+testNumber, bestFitnessStructure);
      if (n2!=0)    tableFitness.setFloat(generations, "fitnessFreeSides"+testNumber, bestFitnessFreeSides);
      if (n3!=0)    tableFitness.setFloat(generations, "fitnessRateOfFilling"+testNumber, bestFitnessRateOfFilling);
      if (n4!=0)    tableFitness.setFloat(generations, "fitnessLight"+testNumber, bestFitnessLight);
      if (n5!=0)    tableFitness.setFloat(generations, "fitnessGrouping"+testNumber, bestFitnessGrouping);
      if (n6!=0)    tableFitness.setFloat(generations, "fitnessGreen"+testNumber, bestFitnessGreen);
      if (n7!=0)    tableFitness.setFloat(generations, "fitnessOpenness"+testNumber, bestFitnessOpenness);
      tableFitness.setFloat(generations, "rate of filling"+testNumber, bestCalcRateOfFilling);
      tableFitness.setFloat(generations, "number above 90%"+testNumber, number90);
    }
  }

  //----------------------------------------------------------------------------------------------------------------------[Save volumes & scores of the 3 best highrises]
  void writeTableVolumeScore() {
    int counter=0;
    for (int i=0; i<gridDimension; i++) {
      for (int j=0; j<gridDimension; j++) {
        for (int k=0; k<gridHeight; k++) {

          if (testNumber==1) {
            TableRow newRow = tableVolumeScore.addRow();
            newRow.setInt("coordinatesX", i);
            newRow.setInt("coordinatesY", j);
            newRow.setInt("coordinatesZ", k);
            //TOWER 1
            newRow.setInt("T1 Volume"+testNumber, population[bestIndex].getCellValue(i,j,k));
            if (n1!=0)    newRow.setFloat("T1 score Structure"+testNumber,     population[bestIndex].getCellScoreStructure(i,j,k));
            if (n2!=0)    newRow.setFloat("T1 score FreeSides"+testNumber,     population[bestIndex].getCellScoreFreeSides(i,j,k));
            if (n4!=0)    newRow.setFloat("T1 score Light"+testNumber,         population[bestIndex].getCellScoreLight(i,j,k));
            if (n5!=0)    newRow.setFloat("T1 score Grouping"+testNumber,      population[bestIndex].getCellScoreGrouping(i,j,k));
            if (n6!=0)    newRow.setFloat("T1 score Green"+testNumber,         population[bestIndex].getCellScoreGreen(i,j,k));
            if (n7!=0)    newRow.setFloat("T1 score Openness"+testNumber,      population[bestIndex].getCellScoreOpenness(i,j,k));
            //TOWER 2
            newRow.setInt("T2 Volume"+testNumber, population[secondBestIndex].getCellValue(i,j,k));
            if (n1!=0)    newRow.setFloat("T2 score Structure"+testNumber,     population[secondBestIndex].getCellScoreStructure(i,j,k));
            if (n2!=0)    newRow.setFloat("T2 score FreeSides"+testNumber,     population[secondBestIndex].getCellScoreFreeSides(i,j,k));
            if (n4!=0)    newRow.setFloat("T2 score Light"+testNumber,         population[secondBestIndex].getCellScoreLight(i,j,k));
            if (n5!=0)    newRow.setFloat("T2 score Grouping"+testNumber,      population[secondBestIndex].getCellScoreGrouping(i,j,k));
            if (n6!=0)    newRow.setFloat("T2 score Green"+testNumber,         population[secondBestIndex].getCellScoreGreen(i,j,k));
            if (n7!=0)    newRow.setFloat("T2 score Openness"+testNumber,      population[secondBestIndex].getCellScoreOpenness(i,j,k));
            //TOWER 3
            newRow.setInt("T3 Volume"+testNumber, population[thirdBestIndex].getCellValue(i,j,k));
            if (n1!=0)    newRow.setFloat("T3 score Structure"+testNumber,     population[thirdBestIndex].getCellScoreStructure(i,j,k));
            if (n2!=0)    newRow.setFloat("T3 score FreeSides"+testNumber,     population[thirdBestIndex].getCellScoreFreeSides(i,j,k));
            if (n4!=0)    newRow.setFloat("T3 score Light"+testNumber,         population[thirdBestIndex].getCellScoreLight(i,j,k));
            if (n5!=0)    newRow.setFloat("T3 score Grouping"+testNumber,      population[thirdBestIndex].getCellScoreGrouping(i,j,k));
            if (n6!=0)    newRow.setFloat("T3 score Green"+testNumber,         population[thirdBestIndex].getCellScoreGreen(i,j,k));
            if (n7!=0)    newRow.setFloat("T3 score Openness"+testNumber,      population[thirdBestIndex].getCellScoreOpenness(i,j,k));
          } 
          
          else {
            //TOWER 1
            tableVolumeScore.setInt(counter, "T1 Volume"+testNumber, population[bestIndex].getCellValue(i,j,k));
            if (n1!=0)    tableVolumeScore.setFloat(counter, "T1 score Structure"+testNumber,     population[bestIndex].getCellScoreStructure(i,j,k));
            if (n2!=0)    tableVolumeScore.setFloat(counter, "T1 score FreeSides"+testNumber,     population[bestIndex].getCellScoreFreeSides(i,j,k));
            if (n4!=0)    tableVolumeScore.setFloat(counter, "T1 score Light"+testNumber,         population[bestIndex].getCellScoreLight(i,j,k));
            if (n5!=0)    tableVolumeScore.setFloat(counter, "T1 score Grouping"+testNumber,      population[bestIndex].getCellScoreGrouping(i,j,k));
            if (n6!=0)    tableVolumeScore.setFloat(counter, "T1 score Green"+testNumber,         population[bestIndex].getCellScoreGreen(i,j,k));
            if (n7!=0)    tableVolumeScore.setFloat(counter, "T1 score Openness"+testNumber,      population[bestIndex].getCellScoreOpenness(i,j,k));
            //TOWER 2
            tableVolumeScore.setInt(counter, "T2 Volume"+testNumber, population[secondBestIndex].getCellValue(i,j,k));
            if (n1!=0)    tableVolumeScore.setFloat(counter, "T2 score Structure"+testNumber,     population[secondBestIndex].getCellScoreStructure(i,j,k));
            if (n2!=0)    tableVolumeScore.setFloat(counter, "T2 score FreeSides"+testNumber,     population[secondBestIndex].getCellScoreFreeSides(i,j,k));
            if (n4!=0)    tableVolumeScore.setFloat(counter, "T2 score Light"+testNumber,         population[secondBestIndex].getCellScoreLight(i,j,k));
            if (n5!=0)    tableVolumeScore.setFloat(counter, "T2 score Grouping"+testNumber,      population[secondBestIndex].getCellScoreGrouping(i,j,k));
            if (n6!=0)    tableVolumeScore.setFloat(counter, "T2 score Green"+testNumber,         population[secondBestIndex].getCellScoreGreen(i,j,k));
            if (n7!=0)    tableVolumeScore.setFloat(counter, "T2 score Openness"+testNumber,      population[secondBestIndex].getCellScoreOpenness(i,j,k));
            //TOWER 3
            tableVolumeScore.setInt(counter, "T3 Volume"+testNumber, population[thirdBestIndex].getCellValue(i,j,k));
            if (n1!=0)    tableVolumeScore.setFloat(counter, "T3 score Structure"+testNumber,     population[thirdBestIndex].getCellScoreStructure(i,j,k));
            if (n2!=0)    tableVolumeScore.setFloat(counter, "T3 score FreeSides"+testNumber,     population[thirdBestIndex].getCellScoreFreeSides(i,j,k));
            if (n4!=0)    tableVolumeScore.setFloat(counter, "T3 score Light"+testNumber,         population[thirdBestIndex].getCellScoreLight(i,j,k));
            if (n5!=0)    tableVolumeScore.setFloat(counter, "T3 score Grouping"+testNumber,      population[thirdBestIndex].getCellScoreGrouping(i,j,k));
            if (n6!=0)    tableVolumeScore.setFloat(counter, "T3 score Green"+testNumber,         population[thirdBestIndex].getCellScoreGreen(i,j,k));
            if (n7!=0)    tableVolumeScore.setFloat(counter, "T3 score Openness"+testNumber,      population[thirdBestIndex].getCellScoreOpenness(i,j,k));
          }
          counter++;
        }
      }
    }
  }

  //----------------------------------------------------------------------------------------------------------------------[Get fitness of best highrise]
  float getBestFitness() {
    return bestFitness;
  }
}