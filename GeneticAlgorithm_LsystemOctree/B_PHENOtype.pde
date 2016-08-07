class DNA {

  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private boolean[][][] genes;        // PHENOTYPE
  private Geno geno;                  // GENOTYPE

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
    geno = new Geno();

    boolean[][][] tempGenes;
    int pLevel = geno.getLevel();
    String pEmbry = geno.getEmbryogeny();

    //Make the temporary, cubical, ideal pheno-grid
    tempGenes = new boolean[int(pow(2, pLevel))][int(pow(2, pLevel))][int(pow(2, pLevel))];
    int[] order=generateOrder(pLevel);
    String pEmbryOrder = new String();

    for (int i=0; i<pEmbry.length(); i++) {
      pEmbryOrder += pEmbry.charAt(order[i]);
    }

    for (int z=0; z<pow(2, pLevel); z++) {
      for (int y=0; y<pow(2, pLevel); y++) {
        for (int x=0; x<pow(2, pLevel); x++) {
          int position = int(z*pow(2, pLevel)*pow(2, pLevel)+y*pow(2, pLevel)+x);
          if       (pEmbryOrder.charAt(position)=='A') {
            tempGenes[x][y][z]=true;
          }
          else if  (pEmbryOrder.charAt(position)=='B') {
            tempGenes[x][y][z]=false;
          }
        }
      }
    }

    //Convert ideal to desired pheno-grid
    for (int x1=0; x1<gridDimension; x1++) {                                        //Loop over the desired pheno-grid
      for (int y1=0; y1<gridDimension; y1++) {
        for (int z1=0; z1<gridHeight; z1++) {
          int x0=round( ((float)x1 / (float)gridDimension) * (pow(2, pLevel)-1));   //Corresponding coordinates of the ideal pheno-grid
          int y0=round( ((float)y1 / (float)gridDimension) * (pow(2, pLevel)-1));
          int z0=round( ((float)z1 / (float)gridHeight) * (pow(2, pLevel)-1));
          if (tempGenes[x0][y0][z0])       genes[x1][y1][z1]=true;
          else if (!tempGenes[x0][y0][z0]) genes[x1][y1][z1]=false;
        }
      }
    }
  }


  //----------------------------------------------------------------------------------------------------------------------METHODS

  //----------------------------------------------------------------------------------------------------------------------[GET the genes-array]
  boolean[][][] getGenes() {
    return genes;
  }

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

  //----------------------------------------------------------------------------------------------------------------------[SET the start]
  void setPStart(String pStart) {
    geno.setGStart(pStart);
  }

  //----------------------------------------------------------------------------------------------------------------------[SET the rules]
  void setPRule1(String pRule1) {
    geno.setGRule1(pRule1);
  }
  void setPRule2(String pRule2) {
    geno.setGRule2(pRule2);
  }

  //----------------------------------------------------------------------------------------------------------------------[GET the start]
  String getPStart() {
    return geno.getGStart();
  }

  //----------------------------------------------------------------------------------------------------------------------[GET the rules]
  String getPRule1() {
    return geno.getGRule1();
  }
  String getPRule2() {
    return geno.getGRule2();
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

  //----------------------------------------------------------------------------------------------------------------------[generate order]  
  int[] generateOrder(int numblevel) {

    int[] output= new int[int(pow(2, 3*numblevel))];
    int[][] list={{0, int(pow(2, numblevel)-1), 0, int(pow(2, numblevel)-1), 0, int(pow(2, numblevel)-1)}};

    for (int i=0; i<numblevel-1; i++) {
      list=divide3DGrid(list);
    }
    int count=0;
    for (int i=0; i<list.length; i++) {
      for (int z=list[i][4]; z<=list[i][5]; z++) {
        for (int y=list[i][2]; y<=list[i][3]; y++) {
          for (int x=list[i][0]; x<=list[i][1]; x++) {
            output[count]=int((z*pow(2, numblevel)*pow(2, numblevel))+(y*pow(2, numblevel))+x);
            count++;
          }
        }
      }
    }
    return output;
  } 

  //----------------------------------------------------------------------------------------------------------------------[divide 3D grid]
  int[][] divide3DGrid(int [][] inGrids) {

    int[][] outGrids=new int[inGrids.length*8][6];
    for (int i=0; i<inGrids.length; i++) {
      int xa=inGrids[i][0];
      int xb=inGrids[i][1];
      int ya=inGrids[i][2];
      int yb=inGrids[i][3];
      int za=inGrids[i][4];
      int zb=inGrids[i][5];

      outGrids[i*8][0]=xa;
      outGrids[i*8][1]=floor((xb-xa)/2)+xa;
      outGrids[i*8][2]=ya;
      outGrids[i*8][3]=floor((yb-ya)/2)+ya;
      outGrids[i*8][4]=za;
      outGrids[i*8][5]=floor((zb-za)/2)+za;

      outGrids[i*8+1][0]=floor((xb-xa)/2)+xa+1;
      outGrids[i*8+1][1]=xb;
      outGrids[i*8+1][2]=ya;
      outGrids[i*8+1][3]=floor((yb-ya)/2)+ya;
      outGrids[i*8+1][4]=za;
      outGrids[i*8+1][5]=floor((zb-za)/2)+za;

      outGrids[i*8+2][0]=xa;
      outGrids[i*8+2][1]=floor((xb-xa)/2)+xa;
      outGrids[i*8+2][2]=floor((yb-ya)/2)+ya+1;
      outGrids[i*8+2][3]=yb;
      outGrids[i*8+2][4]=za;
      outGrids[i*8+2][5]=floor((zb-za)/2)+za;

      outGrids[i*8+3][0]=floor((xb-xa)/2)+xa+1;
      outGrids[i*8+3][1]=xb;
      outGrids[i*8+3][2]=floor((yb-ya)/2)+ya+1;
      outGrids[i*8+3][3]=yb;
      outGrids[i*8+3][4]=za;
      outGrids[i*8+3][5]=floor((zb-za)/2)+za;

      outGrids[i*8+4][0]=xa;
      outGrids[i*8+4][1]=floor((xb-xa)/2)+xa;
      outGrids[i*8+4][2]=ya;
      outGrids[i*8+4][3]=floor((yb-ya)/2)+ya;
      outGrids[i*8+4][4]=floor((zb-za)/2)+za+1;
      outGrids[i*8+4][5]=zb;

      outGrids[i*8+5][0]=floor((xb-xa)/2)+xa+1;
      outGrids[i*8+5][1]=xb;
      outGrids[i*8+5][2]=ya;
      outGrids[i*8+5][3]=int((yb-ya)/2)+ya;
      outGrids[i*8+5][4]=floor((zb-za)/2)+za+1;
      outGrids[i*8+5][5]=zb;

      outGrids[i*8+6][0]=xa;
      outGrids[i*8+6][1]=floor((xb-xa)/2)+xa;
      outGrids[i*8+6][2]=floor((yb-ya)/2)+ya+1;
      outGrids[i*8+6][3]=yb;
      outGrids[i*8+6][4]=floor((zb-za)/2)+za+1;
      outGrids[i*8+6][5]=zb;

      outGrids[i*8+7][0]=floor((xb-xa)/2)+xa+1;
      outGrids[i*8+7][1]=xb;
      outGrids[i*8+7][2]=floor((yb-ya)/2)+ya+1;
      outGrids[i*8+7][3]=yb;
      outGrids[i*8+7][4]=floor((zb-za)/2)+za+1;
      outGrids[i*8+7][5]=zb;
    }

    return outGrids;
  }
}