class Geno {

  //----------------------------------------------------------------------------------------------------------------------PROPERTIES
  private int level;

  private String start;
  private String rule1;
  private String rule2;

  private String embryogeny;

  //----------------------------------------------------------------------------------------------------------------------CONSTRUCTOR
  Geno () {
    level = calculateLevel();

    start = str((char)round(random(65, 66)));
    rule1 = genRule();
    rule2 = genRule();

    embryogeny = generateEmbry();
  }

  //----------------------------------------------------------------------------------------------------------------------METHODS

  //----------------------------------------------------------------------------------------------------------------------[get the level]  
  int getLevel() {
    return level;
  }

  //----------------------------------------------------------------------------------------------------------------------[get the embryogeny]  
  String getEmbryogeny() {
    return embryogeny;
  }

  //----------------------------------------------------------------------------------------------------------------------[calculate the level closest to desired gridDimension]
  int calculateLevel() {
    int calculatedLevel=0;
    boolean done = false;
    int countLevel=1;
    int newDifference=0;
    int oldDifference=10000;
    while (!done) {
      int sizeLevel = int(pow(2, countLevel));
      newDifference = abs(gridDimension-sizeLevel);
      if (newDifference>oldDifference) {
        calculatedLevel = countLevel-1;
        done=true;
      } else {
        oldDifference = newDifference;
        countLevel++;
      }
    }
    return calculatedLevel;
  }

  //----------------------------------------------------------------------------------------------------------------------[generate a new rule]
  String genRule() {
    String ruleGen = new String();
    for (int i=0; i<8; i++) {
      ruleGen = ruleGen + (char)round(random(65, 66));
    }
    return ruleGen;
  }

  //----------------------------------------------------------------------------------------------------------------------[generate the embryogeny]
  String generateEmbry() {
    String gEmbry;
    String currentString=start;         //The current string starts with the start-character of the geno
    String newString;                   //newString temporarily saves the newly determined string of the next generation
    int count = 0;                      //Number of generations

    while (count < level) {
      newString = new String();         //Reset the newString

      //Look through the current string to replace the characters according to the rules
      for (int i=0; i<currentString.length(); i++) {
        char c = currentString.charAt(i);
        if      (c=='A') newString = newString + rule1;           //Replace A with rule1
        else if (c=='B') newString = newString + rule2;           //Replace B with rule2
      }

      // The current String is now the next one
      currentString = newString;
      count++;
    }
    gEmbry = currentString;
    return gEmbry;
  }
  
  //----------------------------------------------------------------------------------------------------------------------[SET the start]
  void setGStart(String gStart) {
    start = gStart;
  }
  
  //----------------------------------------------------------------------------------------------------------------------[SET the rules]
  void setGRule1(String gRule1) {
    rule1 = gRule1;
  }
  void setGRule2(String gRule2) {
    rule2 = gRule2;
  }
  
  //----------------------------------------------------------------------------------------------------------------------[GET the start]
  String getGStart() {
    return start;
  }
  
  //----------------------------------------------------------------------------------------------------------------------[GET the rules]
  String getGRule1() {
    return rule1;
  }
  String getGRule2() {
    return rule2;
  } 
}