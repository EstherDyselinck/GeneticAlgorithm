class DNA {

  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private boolean[][][] genes;        // Array to store the genes of one DNA
  private float fitness;              // Total fitness of one DNA
  private float calcRateOfFilling;    // The calculated rate of filling in one DNA

  // The partial fitnesses
  private float fitnessStructure;
  private float fitnessFreeSides;
  private float fitnessRateOfFilling;
  private float fitnessLight;
  private float fitnessGrouping;
  private float fitnessGreen;
  private float fitnessOpenness;

  //----------------------------------------------------------------------------------------------------------------------CONSTRUCTOR
  DNA() {

    genes = new boolean[gridDimension][gridDimension][gridHeight];
    for (int i = 0; i<gridDimension; i++) {
      for (int j=0; j<gridDimension; j++) {
        for (int k=0; k<gridHeight; k++) {
          int r = round(random(1));
          if (r==1)   genes[i][j][k]=true;
          else        genes[i][j][k]=false;
        }
      }
    }
  }


  //----------------------------------------------------------------------------------------------------------------------METHODS

  //----------------------------------------------------------------------------------------------------------------------[Set the fitnesses]
  void setFitnesses() {
    if (n1!=0)  fitnessStructure     = calculateFitnessStructure(genes);
    if (n2!=0)  fitnessFreeSides     = calculateFitnessFreeSides(genes);
    if (n3!=0)  fitnessRateOfFilling = calculateFitnessRateOfFilling(genes);
    if (n4!=0)  fitnessLight         = calculateFitnessLight(genes);
    if (n5!=0)  fitnessGrouping      = calculateFitnessGrouping(genes);
    if (n6!=0)  fitnessGreen         = calculateFitnessGreen(genes);
    if (n7!=0)  fitnessOpenness      = calculateFitnessOpenness(genes);
  }

  //----------------------------------------------------------------------------------------------------------------------[Get total fitness]
  float getTotalFitness() {
    //Normalise the weights of the fitnesses
    float nn1=n1/(n1+n2+n3+n4+n5+n6+n7);
    float nn2=n2/(n1+n2+n3+n4+n5+n6+n7);
    float nn3=n3/(n1+n2+n3+n4+n5+n6+n7);
    float nn4=n4/(n1+n2+n3+n4+n5+n6+n7);
    float nn5=n5/(n1+n2+n3+n4+n5+n6+n7);
    float nn6=n6/(n1+n2+n3+n4+n5+n6+n7);
    float nn7=n7/(n1+n2+n3+n4+n5+n6+n7);
    //Calculate the total fitness
    fitness = nn1*fitnessStructure + nn2*fitnessFreeSides + nn3*fitnessRateOfFilling + nn4*fitnessLight + nn5*fitnessGrouping + nn6*fitnessGreen + nn7*fitnessOpenness;
    return fitness;
  }

  //----------------------------------------------------------------------------------------------------------------------Get the partial fitnesses
  float getFitnessStructure() {
    return fitnessStructure;
  }
  float getFitnessFreeSides() {
    return fitnessFreeSides;
  }
  float getFitnessRateOfFilling() {
    return fitnessRateOfFilling;
  }
  float getFitnessLight() {
    return fitnessLight;
  }
  float getFitnessGrouping() {
    return fitnessGrouping;
  }
  float getFitnessGreen() {
    return fitnessGreen;
  }
  float getFitnessOpenness() {
    return fitnessOpenness;
  }

  //----------------------------------------------------------------------------------------------------------------------Calculate and get the calcRateOfFilling
  float getCalcRateOfFilling() {
    int totalPosCells=0;
    int totalCells=gridDimension*gridDimension*gridHeight;
    for (int i = 0; i<gridDimension; i++) {
      for (int j=0; j<gridDimension; j++) {
        for (int k=0; k<gridHeight; k++) {
          if (genes[i][j][k]) totalPosCells++;
        }
      }
    }
    calcRateOfFilling = (float)totalPosCells/ (float)totalCells;
    return calcRateOfFilling;
  }

  //----------------------------------------------------------------------------------------------------------------------Calculate and get colours
  void calculateColours () {
    if (structureColour) {
      fitnessStructure     = calculateFitnessStructure(genes);
      for (int i = 0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            if (score[i][j][k]==0)  colourRed[i][j][k]=255;
            else                    colourRed[i][j][k]=0;
            if (score[i][j][k]==0)  colourGreen[i][j][k]=0;
            else                    colourGreen[i][j][k]=255*score[i][j][k];
            colourBlue[i][j][k]=0;
          }
        }
      }
    }
    if (freeSidesColour) {  
      fitnessFreeSides     = calculateFitnessFreeSides(genes);
      for (int i = 0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            if (score[i][j][k]==0)  colourRed[i][j][k]=255;
            else                    colourRed[i][j][k]=0;
            if (score[i][j][k]==0)  colourGreen[i][j][k]=0;
            else                    colourGreen[i][j][k]=255*score[i][j][k];
            colourBlue[i][j][k]=0;
          }
        }
      }
    }
    if (grayColour) {
      for (int i = 0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            colourRed[i][j][k]=200;
            colourGreen[i][j][k]=200;
            colourBlue[i][j][k]=200;
          }
        }
      }
    }
    if (lightColour) {
      fitnessLight         = calculateFitnessLight(genes);
      for (int i = 0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            if (score[i][j][k]==0)  colourRed[i][j][k]=255;
            else                    colourRed[i][j][k]=0;
            if (score[i][j][k]==0)  colourGreen[i][j][k]=0;
            else                    colourGreen[i][j][k]=255*score[i][j][k];
            colourBlue[i][j][k]=0;
          }
        }
      }
    }
    if (groupingColour) {
      fitnessGrouping      = calculateFitnessGrouping(genes);
      for (int i = 0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            if (score[i][j][k]==0)  colourRed[i][j][k]=255;
            else                    colourRed[i][j][k]=0;
            if (score[i][j][k]==0)  colourGreen[i][j][k]=0;
            else                    colourGreen[i][j][k]=255*score[i][j][k];
            colourBlue[i][j][k]=0;
          }
        }
      }
    }
    if (greenColour) { 
      fitnessGreen         = calculateFitnessGreen(genes);
      for (int i = 0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            if (score[i][j][k]==0)  colourRed[i][j][k]=255;
            else                    colourRed[i][j][k]=0;
            if (score[i][j][k]==0)  colourGreen[i][j][k]=0;
            else                    colourGreen[i][j][k]=255*score[i][j][k];
            colourBlue[i][j][k]=0;
          }
        }
      }
    }
    if (opennessColour) { 
      fitnessOpenness      = calculateFitnessOpenness(genes);
      for (int i = 0; i<gridDimension; i++) {
        for (int j=0; j<gridDimension; j++) {
          for (int k=0; k<gridHeight; k++) {
            if (score[i][j][k]==0)  colourRed[i][j][k]=255;
            else                    colourRed[i][j][k]=0;
            if (score[i][j][k]==0)  colourGreen[i][j][k]=0;
            else                    colourGreen[i][j][k]=255*score[i][j][k];
            colourBlue[i][j][k]=0;
          }
        }
      }
    }
  }

  //----------------------------------------------------------------------------------------------------------------------SET the genes-array
  void setGenes(boolean[][][] newGenes) {
    for (int i = 0; i<gridDimension; i++) {
      for (int j=0; j<gridDimension; j++) {
        for (int k=0; k<gridHeight; k++) {
          genes[i][j][k]=newGenes[i][j][k];
        }
      }
    }
  }

  //----------------------------------------------------------------------------------------------------------------------GET the genes-array
  boolean[][][] getGenes() {
    return genes;
  }
  
  //----------------------------------------------------------------------------------------------------------------------[GET cellValue]
  int getCellValue(int i, int j, int k) {
    if (genes[i][j][k])  return 1;
    else                 return 0;
  }
  //----------------------------------------------------------------------------------------------------------------------[GET cellScores]
  float getCellScoreStructure(int i, int j, int k) {
    fitnessStructure = calculateFitnessStructure(genes);
    return score[i][j][k];
  }
  float getCellScoreFreeSides(int i, int j, int k) {
    fitnessFreeSides = calculateFitnessFreeSides(genes);
    return score[i][j][k];
  }
  float getCellScoreLight(int i, int j, int k) {
    fitnessLight = calculateFitnessLight(genes);
    return score[i][j][k];
  }
  float getCellScoreGrouping(int i, int j, int k) {
    fitnessGrouping = calculateFitnessGrouping(genes);
    return score[i][j][k];
  }
  float getCellScoreGreen(int i, int j, int k) {
    fitnessGreen = calculateFitnessGreen(genes);
    return score[i][j][k];
  }
  float getCellScoreOpenness(int i, int j, int k) {
    fitnessOpenness = calculateFitnessOpenness(genes);
    return score[i][j][k];
  }
}