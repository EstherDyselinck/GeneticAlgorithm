//----------------------------------------------------------------------------------------------------------------------[Structure]
float calculateFitnessStructure(boolean[][][] genes) {

  //Resetting score-array
  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        score[i][j][k]=0;
      }
    }
  }

  float fitnessStructure=0;
  float oldFitnessStructure=0;

  boolean done=false;
  float totalScore=0;
  int totalPosCells=0;
  int totalFloatingCells=0;

  int counter=0;

  while (!done && counter<gridDimension*gridDimension*gridHeight) {

    //resetting the variables
    totalScore=0;
    totalPosCells=0;
    totalFloatingCells=0;

    for (int k=0; k<gridHeight; k++) {
      for (int j=0; j<gridDimension; j++) {
        for (int i=0; i<gridDimension; i++) {

          //give scores
          if (!genes[i][j][k])           score[i][j][k]=0;
          else if (k==0)                 score[i][j][k]=1;
          else if (score[i][j][k-1]>0)   score[i][j][k]=0.99*score[i][j][k-1];
          else {
            float maxvalue=0;
            if (i+1<gridDimension) {
              if (score[i+1][j][k]>maxvalue) maxvalue=score[i+1][j][k];
            }
            if (j+1<gridDimension) {
              if (score[i][j+1][k]>maxvalue) maxvalue=score[i][j+1][k];
            }
            if (i-1>=0) {
              if (score[i-1][j][k]>maxvalue) maxvalue=score[i-1][j][k];
            }
            if (j-1>=0) {
              if (score[i][j-1][k]>maxvalue) maxvalue=score[i][j-1][k];
            }
            score[i][j][k]=0.8*maxvalue;
          }

          //calculating the factors in the fitness-calculation
          totalScore+=score[i][j][k];                                          //totalScore
          if (genes[i][j][k]) totalPosCells++;                                 //totalPosCells
          if (genes[i][j][k] && score[i][j][k]==0) totalFloatingCells++;       //totalFloatingCells
        }
      }
    }
    fitnessStructure=((float)totalScore/((float)totalPosCells))*exp(-(float)totalFloatingCells/(gridDimension*gridDimension*gridHeight/50));
    if (oldFitnessStructure-0.01*oldFitnessStructure <= fitnessStructure && fitnessStructure <= oldFitnessStructure+0.01*oldFitnessStructure) done=true;
    else oldFitnessStructure=fitnessStructure;

    counter++;
  }

  return fitnessStructure;
}


//----------------------------------------------------------------------------------------------------------------------[Rate of Filling]
float calculateFitnessRateOfFilling(boolean[][][] genes) {

  float fitnessRateOfFilling;
  float totalPosCells=0;

  for (int i = 0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        if (genes[i][j][k]) totalPosCells++;
      }
    }
  }

  fitnessRateOfFilling=1-min(1, abs(totalPosCells-(rateOfFilling*gridDimension*gridDimension*gridHeight))/(0.5*gridDimension*gridDimension*gridHeight));

  return fitnessRateOfFilling;
}

//----------------------------------------------------------------------------------------------------------------------[Light]
float calculateFitnessLight(boolean[][][] genes) {

  //Resetting score-array
  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        score[i][j][k]=0;
      }
    }
  }

  float fitnessLight;
  int numberOfEnclosedCells=0;

  //VECTORS
  int numberOfVectors=11;
  int totalPosCells=0;
  float totalScore=0;

  PVector[] vectors = new PVector[numberOfVectors];
  vectors[0]= new PVector (-0.97, 0.26, 0.07);
  vectors[1]= new PVector (-0.87, 0.50, 0.24);
  vectors[2]= new PVector (-0.71, 0.71, 0.39);
  vectors[3]= new PVector (-0.50, 0.87, 0.52);
  vectors[4]= new PVector (-0.26, 0.97, 0.59);
  vectors[5]= new PVector (0.00, 1.00, 0.62);
  vectors[6]= new PVector (0.26, 0.97, 0.60);
  vectors[7]= new PVector (0.50, 0.87, 0.53);
  vectors[8]= new PVector (0.71, 0.71, 0.42);
  vectors[9]= new PVector (0.87, 0.50, 0.28);
  vectors[10]= new PVector (0.97, 0.26, 0.10);

  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        if (genes[i][j][k]) {

          totalPosCells++;
          int numberOfPosVectors=0;
          float cellScore=0;

          for (int s=0; s<numberOfVectors; s++) {
            //actual values of coordinate
            float x0=i;
            float y0=j;
            float z0=k;
            //rounded values of coordinate
            int x1;
            int y1;
            int z1;

            boolean done=false;
            while (!done) {
              x1=round(x0+vectors[s].x);
              y1=round(y0+vectors[s].y);
              z1=round(z0+vectors[s].z);
              if (x1<gridDimension && x1>=0 && y1<gridDimension && y1>=0 && z1<gridHeight && z1>=0) {
                if (genes[x1][y1][z1]) done=true;
                else {
                  x0=x0+vectors[s].x;
                  y0=y0+vectors[s].y;
                  z0=z0+vectors[s].z;
                }
              } else {
                done=true;
                numberOfPosVectors++;
              }
            }
          }

          cellScore=(float)numberOfPosVectors/ (float)numberOfVectors;
          if (cellScore==0) numberOfEnclosedCells++;
          score[i][j][k]=cellScore;
          totalScore+=cellScore;
        }
      }
    }
  }
  fitnessLight=(float)totalScore/ ((float)totalPosCells);
  return fitnessLight;
}

//----------------------------------------------------------------------------------------------------------------------[FreeSides]
float calculateFitnessFreeSides(boolean[][][] genes) {

  //Resetting score-array
  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        score[i][j][k]=0;
      }
    }
  }

  float fitnessFreeSides;
  float totalScore = 0;
  float totalPosCells = 0;

  for (int i = 0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        if (genes[i][j][k]) {

          float cellScore=0;
          totalPosCells++;
          int numberOfFreeSides=0;

          if (i+1<gridDimension) {
            if (!genes[i+1][j][k]) numberOfFreeSides++;
          } else numberOfFreeSides++;

          if (j+1<gridDimension) {
            if (!genes[i][j+1][k]) numberOfFreeSides++;
          } else numberOfFreeSides++;

          if (i-1>=0) {
            if (!genes[i-1][j][k]) numberOfFreeSides++;
          } else numberOfFreeSides++;

          if (j-1>=0) {
            if (!genes[i][j-1][k]) numberOfFreeSides++;
          } else numberOfFreeSides++;

          cellScore=1-min(1, (abs((float)numberOfFreeSides-(float)desiredFreeSides)/2));
          score[i][j][k]=cellScore;
          totalScore+=cellScore;
        }
      }
    }
  }
  fitnessFreeSides = (float)totalScore / (float)totalPosCells;
  return fitnessFreeSides;
}

//----------------------------------------------------------------------------------------------------------------------[Grouping]
float calculateFitnessGrouping(boolean[][][] genes) {

  //Resetting score-array
  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        score[i][j][k]=0;
      }
    }
  }

  float fitnessGrouping;
  float totalScore=0;
  int totalPosCells=0; 

  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {

        if (genes[i][j][k]) {

          float cellScore=0;
          int numberOfNeighbours=0;
          int numberOfPosNeighbours=0;

          for (int p=i-1; p<=i+1; p++) {
            for (int q=j-1; q<=j+1; q++) {
              for (int r=k-1; r<=k+1; r++) {
                if (p>=0 && p<gridDimension && q>=0 && q<gridDimension && r>=0 && r<gridHeight) {
                  if (p==0 && q==0 && r==0) numberOfNeighbours = numberOfNeighbours;
                  else                      numberOfNeighbours++;

                  if (p==0 && q==0 && r==0) numberOfPosNeighbours = numberOfPosNeighbours;
                  else if (genes[p][q][r])  numberOfPosNeighbours++;
                }
              }
            }
          }
          cellScore=(float)numberOfPosNeighbours/ (float)numberOfNeighbours;
          score[i][j][k]=cellScore;
          totalScore+=cellScore;
        } 
        
        else {

          float cellScore=0;
          int numberOfNeighbours=0;
          int numberOfNegNeighbours=0;

          for (int p=i-1; p<=i+1; p++) {
            for (int q=j-1; q<=j+1; q++) {
              for (int r=k-1; r<=k+1; r++) {
                if (p>=0 && p<gridDimension && q>=0 && q<gridDimension && r>=0 && r<gridHeight) {
                  if (p==0 && q==0 && r==0) numberOfNeighbours = numberOfNeighbours;
                  else                      numberOfNeighbours++;

                  if (p==0 && q==0 && r==0) numberOfNegNeighbours = numberOfNegNeighbours;
                  else if (!genes[p][q][r])  numberOfNegNeighbours++;
                }
              }
            }
          }
          cellScore=(float)numberOfNegNeighbours/ (float)numberOfNeighbours;
          score[i][j][k]=cellScore;
          totalScore+=cellScore;
        }
      }
    }
  }

  int totalCells = gridDimension*gridDimension*gridHeight;
  fitnessGrouping= (float)totalScore/ (float)totalCells;
  return fitnessGrouping;
}

//----------------------------------------------------------------------------------------------------------------------[Green]
float calculateFitnessGreen(boolean[][][] genes) {

  //Resetting score-array
  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        score[i][j][k]=0;
      }
    }
  }

  float fitnessGreen;
  int totalScore=0;
  int totalPosCells=0; 

  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {

        if (genes[i][j][k]) {
          totalPosCells++;
          int cellScore=0;
          //check if it has one side-terrace
          if (k==0)                                                               cellScore++;
          else if (i-1>=0 && !genes[i-1][j][k] && genes[i-1][j][k-1])             cellScore++;
          else if (i+1<gridDimension && !genes[i+1][j][k] && genes[i+1][j][k-1])  cellScore++;
          else if (j-1>=0 && !genes[i][j-1][k] && genes[i][j-1][k-1])             cellScore++;
          else if (j+1<gridDimension && !genes[i][j+1][k] && genes[i][j+1][k-1])  cellScore++;

          score[i][j][k]=cellScore;
          totalScore+=cellScore;
        }
      }
    }
  }
  fitnessGreen=(float)totalScore/ (float)totalPosCells;
  return fitnessGreen;
}

//----------------------------------------------------------------------------------------------------------------------[Openness]
float calculateFitnessOpenness(boolean[][][] genes) {

  //Resetting score-array
  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        score[i][j][k]=0;
      }
    }
  }

  float fitnessOpenness;
  int totalPosCells=0;
  float totalScore=0;
  int numberOfEnclosedCells=0;

  //VECTORSTART  
  //horizontal vectorStart is (0,0,0)
  //vectorStart for the upwards 45°
  PVector [] vectorStartUp = new PVector [4];
  vectorStartUp[0]= new PVector (-0.25, 0, -0.25);
  vectorStartUp[1]= new PVector (0.25, 0, -0.25);
  vectorStartUp[2]= new PVector (0, -0.25, -0.25);
  vectorStartUp[3]= new PVector (0, 0.25, -0.25);
  //vectorStart for the downwards 45°
  PVector [] vectorStartDown = new PVector [4];
  vectorStartDown[0]= new PVector (-0.25, 0, 0.25);
  vectorStartDown[1]= new PVector (0.25, 0, 0.25);
  vectorStartDown[2]= new PVector (0, -0.25, 0.25);
  vectorStartDown[3]= new PVector (0, 0.25, 0.25);

  //VECTOR
  //horizontal vector
  PVector [] vectorH = new PVector [4];
  vectorH[0]= new PVector (-1, 0, 0);
  vectorH[1]= new PVector (1, 0, 0);
  vectorH[2]= new PVector (0, -1, 0);
  vectorH[3]= new PVector (0, 1, 0);
  //vector for the upwards 45°  
  PVector [] vectorUp = new PVector [4];
  vectorUp[0]= new PVector (-0.5, 0, 0.5);
  vectorUp[1]= new PVector (0.5, 0, 0.5);
  vectorUp[2]= new PVector (0, -0.5, 0.5);
  vectorUp[3]= new PVector (0, 0.5, 0.5);
  //vector for the downwards 45°  
  PVector [] vectorDown = new PVector [4];
  vectorDown[0]= new PVector (-0.5, 0, -0.5);
  vectorDown[1]= new PVector (0.5, 0, -0.5);
  vectorDown[2]= new PVector (0, -0.5, -0.5);
  vectorDown[3]= new PVector (0, 0.5, -0.5);

  for (int i=0; i<gridDimension; i++) {
    for (int j=0; j<gridDimension; j++) {
      for (int k=0; k<gridHeight; k++) {
        if (genes[i][j][k]) {

          totalPosCells++;
          int [] vectorLengthH = new int[4];
          int [] vectorLengthUp = new int[4];
          int [] vectorLengthDown = new int[4];
          int vectorLengthMaxAngle=10;
          int vectorLengthMaxH=5;
          float [] vectorLengthNormalisedH = new float[4];
          float [] vectorLengthNormalisedUp = new float[4];
          float [] vectorLengthNormalisedDown = new float[4];

          float[] weightedVectorLengths = new float[4];

          for (int s=0; s<4; s++) {

            //actual values of coordinate
            float x0=i;
            float y0=j;
            float z0=k;
            //rounded values of coordinate
            int x1;
            int y1;
            int z1;

            //HORIZONTAL
            //Calculate the vectorLength
            boolean doneH=false;
            while (!doneH) {
              x1=round(x0+vectorH[s].x);
              y1=round(y0+vectorH[s].y);
              z1=round(z0+vectorH[s].z);
              if (x1<gridDimension && x1>=0 && y1<gridDimension && y1>=0 && z1<gridHeight && z1>=0) {
                if (genes[x1][y1][z1]) doneH=true;
                else {
                  vectorLengthH[s]++;
                  x0=x0+vectorH[s].x;
                  y0=y0+vectorH[s].y;
                  z0=z0+vectorH[s].z;
                }
              } else {
                doneH=true;
                vectorLengthH[s]=vectorLengthMaxH;
              }
            }
            vectorLengthNormalisedH[s]=(float)vectorLengthH[s]/ (float)vectorLengthMaxH;

            //UPWARDS 45°
            x0=i+vectorStartUp[s].x;
            y0=j+vectorStartUp[s].y;
            z0=k+vectorStartUp[s].z;
            //Calculate the vectorLength
            boolean doneUp=false;
            while (!doneUp) {
              x1=round(x0+vectorUp[s].x);
              y1=round(y0+vectorUp[s].y);
              z1=round(z0+vectorUp[s].z);
              if (x1<gridDimension && x1>=0 && y1<gridDimension && y1>=0 && z1<gridHeight && z1>=0) {
                if (genes[x1][y1][z1]) doneUp=true;
                else {
                  vectorLengthUp[s]++;
                  x0=x0+vectorUp[s].x;
                  y0=y0+vectorUp[s].y;
                  z0=z0+vectorUp[s].z;
                }
              } else {
                doneUp=true;
                vectorLengthUp[s]=vectorLengthMaxAngle;
              }
            }
            vectorLengthNormalisedUp[s]=(float)vectorLengthUp[s]/ (float)vectorLengthMaxAngle;

            //DOWNWARDS 45°
            x0=i+vectorStartDown[s].x;
            y0=j+vectorStartDown[s].y;
            z0=k+vectorStartDown[s].z;
            //Calculate the vectorLength
            boolean doneDown=false;
            while (!doneDown) {
              x1=round(x0+vectorDown[s].x);
              y1=round(y0+vectorDown[s].y);
              z1=round(z0+vectorDown[s].z);
              if (x1<gridDimension && x1>=0 && y1<gridDimension && y1>=0 && z1<gridHeight && z1>=0) {
                if (genes[x1][y1][z1]) doneDown=true;
                else {
                  vectorLengthDown[s]++;
                  x0=x0+vectorDown[s].x;
                  y0=y0+vectorDown[s].y;
                  z0=z0+vectorDown[s].z;
                }
              } else {
                doneDown=true;
                vectorLengthDown[s]=vectorLengthMaxAngle;
              }
            }
            vectorLengthNormalisedDown[s]=(float)vectorLengthDown[s]/ (float)vectorLengthMaxAngle;

            weightedVectorLengths[s]=(4*(float)vectorLengthNormalisedH[s]+2*(float)vectorLengthNormalisedUp[s]+(float)vectorLengthNormalisedDown[s])/7;
          }

          score[i][j][k]=((float)weightedVectorLengths[0]+(float)weightedVectorLengths[1]+(float)weightedVectorLengths[2]+(float)weightedVectorLengths[3])/4;
          totalScore+=score[i][j][k];
        }
      }
    }
  }
  fitnessOpenness=(float)totalScore/ (float)totalPosCells;
  return fitnessOpenness;
}