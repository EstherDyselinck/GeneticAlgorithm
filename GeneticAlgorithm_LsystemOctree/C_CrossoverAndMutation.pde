//----------------------------------------------------------------------------------------------------------------------Crossover
DNA crossover(DNA mother, DNA father) {
  DNA child = new DNA();

  //Start & rule 1 MOTHER + rule 2 FATHER
  child.setPStart(mother.getPStart());
  child.setPRule1(mother.getPRule1());
  child.setPRule2(father.getPRule2());

  return child;
}

//----------------------------------------------------------------------------------------------------------------------Mutation
void mutate(DNA tower) {
  float r;
  
  r=random(1);
  if (r<mutationRate) {
    String genRule = new String();
    for (int i=0; i<8; i++) {
      genRule = genRule + (char)round(random(65, 66));
    }
    tower.setPRule1(genRule);
  }
  r=random(1);
  if (r<mutationRate) {
    String genRule = new String();
    for (int i=0; i<8; i++) {
      genRule = genRule + (char)round(random(65, 66));
    }
    tower.setPRule2(genRule);
  }
}