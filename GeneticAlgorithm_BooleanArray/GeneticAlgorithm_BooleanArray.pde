//----------------------------------------------------------------------------------------------------------------------PROPERTIES
import peasy.*;
PeasyCam cam;
Table tableFitness;
Table tableVolumeScore;

Population population;

int generations;                // Number of generations
int testNumber;                 // Number of current test
boolean testDone;               // Are the number of tests completed?
float mutationRate;             // Mutationrate changes with the number of generations
boolean finished;               // Are we finished evolving?
boolean pause;                  // Set a pause to the optimalisation
boolean saved;                  // Has the table been saved at the end of the optimalisation?
boolean start;                  // Sets button to start the optimalisation

float[][][] score;              // Work-array for temporary storage of scores
float[][][] colourRed;          // Arrays to store colour of best highrise in population
float[][][] colourGreen;
float[][][] colourBlue;

//The different sets of colour
String colourSet;
boolean structureColour;
boolean lightColour;
boolean freeSidesColour;
boolean groupingColour;
boolean greenColour;
boolean grayColour;
boolean opennessColour;

//Adaptable parameters
final int gridDimension = 10;
final int gridHeight = 36;
final int sizePopulation = 500;

final float rateOfFilling = 0.3;
final int desiredFreeSides = 2;

final float n1=1;                 //Weight of FITNESS STRUCTURE
final float n2=0;                 //Weight of FITNESS FREE SIDES
final float n3=0;                 //Weight of FITNESS RATE OF FILLING
final float n4=0;                 //Weight of FITNESS LIGHT
final float n5=0;                 //Weight of FITNESS GROUPING
final float n6=0;                 //Weight of FITNESS GREEN
final float n7=0;                 //Weight of FITNESS OPENNESS

final int maxGenerations=8000;    //Max. number of generations for tests
final int numberOfTests=5;         //Number of tests

//----------------------------------------------------------------------------------------------------------------------SETUP
void setup() {
  size(700, 700, P3D);

  //Properties cam
  cam=new PeasyCam(this, 2000);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(10000);

  //Initializing variables
  generations=0;
  testNumber=1;
  mutationRate=0.1;
  finished=false;
  testDone=false;
  pause=false;
  start=false;
  saved=false;
  structureColour=false;
  lightColour=false;
  freeSidesColour=false;
  groupingColour=false;
  greenColour=false;
  grayColour=true;
  opennessColour=false;

  score = new float [gridDimension][gridDimension][gridHeight];
  colourRed = new float [gridDimension][gridDimension][gridHeight];
  colourGreen = new float [gridDimension][gridDimension][gridHeight];
  colourBlue = new float [gridDimension][gridDimension][gridHeight];

  //Properties tableFitness
  tableFitness=new Table();
  tableFitness.addColumn("generation");
  for (int i=1; i<=numberOfTests; i++)      tableFitness.addColumn("best fitness"+i);
  for (int i=1; i<=numberOfTests; i++)      tableFitness.addColumn("worst fitness"+i);
  if (n1!=0) {
    for (int i=1; i<=numberOfTests; i++)    tableFitness.addColumn("fitnessStructure"+i);
  }
  if (n2!=0) { 
    for (int i=1; i<=numberOfTests; i++)    tableFitness.addColumn("fitnessFreeSides"+i);
  }
  if (n3!=0) {
    for (int i=1; i<=numberOfTests; i++)    tableFitness.addColumn("fitnessRateOfFilling"+i);
  }
  if (n4!=0) {
    for (int i=1; i<=numberOfTests; i++)    tableFitness.addColumn("fitnessLight"+i);
  }
  if (n5!=0) { 
    for (int i=1; i<=numberOfTests; i++)    tableFitness.addColumn("fitnessGrouping"+i);
  }
  if (n6!=0) { 
    for (int i=1; i<=numberOfTests; i++)    tableFitness.addColumn("fitnessGreen"+i);
  }
  if (n7!=0) { 
    for (int i=1; i<=numberOfTests; i++)    tableFitness.addColumn("fitnessOpenness"+i);
  }
  for (int i=1; i<=numberOfTests; i++)      tableFitness.addColumn("rate of filling"+i);
  for (int i=1; i<=numberOfTests; i++)      tableFitness.addColumn("number above 90%"+i);

  //Properties tabelVolumeScore
  tableVolumeScore=new Table();
  tableVolumeScore.addColumn("coordinatesX");
  tableVolumeScore.addColumn("coordinatesY");
  tableVolumeScore.addColumn("coordinatesZ");
  for (int i=1; i<=numberOfTests; i++) {
    tableVolumeScore.addColumn("T1 Volume"+i);
    if (n1!=0) tableVolumeScore.addColumn("T1 score Structure"+i);
    if (n2!=0) tableVolumeScore.addColumn("T1 score FreeSides"+i);
    if (n3!=0) tableVolumeScore.addColumn("T1 score OfFilling"+i);
    if (n4!=0) tableVolumeScore.addColumn("T1 score Light"+i);
    if (n5!=0) tableVolumeScore.addColumn("T1 score Grouping"+i);
    if (n6!=0) tableVolumeScore.addColumn("T1 score Green"+i);
    if (n7!=0) tableVolumeScore.addColumn("T1 score Openness"+i);

    tableVolumeScore.addColumn("T2 Volume"+i);
    if (n1!=0) tableVolumeScore.addColumn("T2 score Structure"+i);
    if (n2!=0) tableVolumeScore.addColumn("T2 score FreeSides"+i);
    if (n3!=0) tableVolumeScore.addColumn("T2 score OfFilling"+i);
    if (n4!=0) tableVolumeScore.addColumn("T2 score Light"+i);
    if (n5!=0) tableVolumeScore.addColumn("T2 score Grouping"+i);
    if (n6!=0) tableVolumeScore.addColumn("T2 score Green"+i);
    if (n7!=0) tableVolumeScore.addColumn("T2 score Openness"+i);

    tableVolumeScore.addColumn("T3 Volume"+i);
    if (n1!=0) tableVolumeScore.addColumn("T3 score Structure"+i);
    if (n2!=0) tableVolumeScore.addColumn("T3 score FreeSides"+i);
    if (n3!=0) tableVolumeScore.addColumn("T3 score OfFilling"+i);
    if (n4!=0) tableVolumeScore.addColumn("T3 score Light"+i);
    if (n5!=0) tableVolumeScore.addColumn("T3 score Grouping"+i);
    if (n6!=0) tableVolumeScore.addColumn("T3 score Green"+i);
    if (n7!=0) tableVolumeScore.addColumn("T3 score Openness"+i);
  }

  population = new Population();
  population.calculateFitnessAndNaturalSelection();
  population.writeTableFitness();
}

//----------------------------------------------------------------------------------------------------------------------DRAW
void draw() {

  if (structureColour)      colourSet = "STRUCTURE";
  else if (lightColour)     colourSet = "LIGHT";
  else if (freeSidesColour) colourSet = "FREE SIDES";
  else if (groupingColour)  colourSet = "GROUPING";
  else if (greenColour)     colourSet = "GREEN";
  else if (grayColour)      colourSet = "GRAY";
  else if (opennessColour)  colourSet = "OPENNESS";


  if (start && !testDone) {
    if (!finished && !pause) {
      population.generate();
      generations++;
      population.calculateFitnessAndNaturalSelection();
      population.writeTableFitness();
      checkIfFinished();
      if (generations >= 10) {
        mutationRate=1/ (float)generations;
      }
    }
  }

  population.displayBest();

  if (finished && testNumber<numberOfTests+1) {
    population.writeTableVolumeScore();
  }

  if (finished && !testDone) {
    testNumber++;
    checkNumberOfTests();
    if (!testDone) reset();
  }

  if (!saved && testDone) {
    saveTable(tableFitness, "FITNESS_grid."+gridDimension+"x"+gridHeight+".csv", "csv");
    saveTable(tableVolumeScore, "VOLUME&SCORE_grid."+gridDimension+"x"+gridHeight+".csv", "csv");
    saved=true;
  }
}

//----------------------------------------------------------------------------------------------------------------------ADDITIONAL METHODS

//1: set the buttons
void keyPressed() {
  if (key==' ') {
    pause=!pause;
  }
  if (key=='0') {
    start=true;
  }
  if (key=='t') {
    saveTable(tableFitness, "FITNESS_grid."+gridDimension+"x"+gridHeight+".csv", "csv");
    saveTable(tableVolumeScore, "VOLUME&SCORE_grid."+gridDimension+"x"+gridHeight+".csv", "csv");
  }
  if (key=='s') {
    structureColour=true;
    lightColour=false;
    freeSidesColour=false;
    groupingColour=false;
    greenColour=false;
    grayColour=false;
    opennessColour=false;
  }
  if (key=='l') {
    structureColour=false;
    lightColour=true;
    freeSidesColour=false;
    groupingColour=false;
    greenColour=false;
    grayColour=false;
    opennessColour=false;
  }
  if (key=='f') {
    structureColour=false;
    lightColour=false;
    freeSidesColour=true;
    groupingColour=false;
    greenColour=false;
    grayColour=false;
    opennessColour=false;
  }
  if (key=='o') {
    structureColour=false;
    lightColour=false;
    freeSidesColour=false;
    groupingColour=true;
    greenColour=false;
    grayColour=false;
    opennessColour=false;
  }
  if (key=='g') {
    structureColour=false;
    lightColour=false;
    freeSidesColour=false;
    groupingColour=false;
    greenColour=true;
    grayColour=false;
    opennessColour=false;
  }
  if (key=='a') {
    structureColour=false;
    lightColour=false;
    freeSidesColour=false;
    groupingColour=false;
    greenColour=false;
    grayColour=true;
    opennessColour=false;
  }
  if (key=='p') {
    structureColour=false;
    lightColour=false;
    freeSidesColour=false;
    groupingColour=false;
    greenColour=false;
    grayColour=false;
    opennessColour=true;
  }
}

//2: check if the genetic algorithm is finished
void checkIfFinished() {
  float perfectFitness=1;
  if (population.getBestFitness() == perfectFitness)      finished=true;
  else if (generations==maxGenerations)                   finished=true;
}

//3: check if the number of tests finished
void checkNumberOfTests() {
  if (testNumber == numberOfTests+1)      testDone=true;
}

//4: reset between tests
void reset() {
  generations=0;
  mutationRate=0.1;
  finished=false;
  pause=false;
  saved=false;
  population =new Population();
  population.calculateFitnessAndNaturalSelection();
  population.writeTableFitness();
}