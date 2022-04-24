//Classe de type Feuille
//Utilise le système de Lindenmayer pour produire une feuille d'arbre
class Feuille
{
  //Propriétés visuelles
  float size;
  float angle = 1.0646515;
  int couleur = color(200, 100, 200);
  float segment;
  
  //Propriétés de positions
  float positionStartX;
  float positionStartY;
  float angleFeuille;
  
  //Propriétés du systèmede Lindenmayer
  int generation;
  int indexSequence;
  char symbol;
  String axiom = "|X";
  String sequence;
  StringBuffer generationCurrent;
  StringBuffer generationNext;
  int indexRule;
  LSystemRule rule;


  //Constructeur
  Feuille(float posX, float posY, float angle, float taille)
  {
    //Initialisation des proprietes
    positionStartX = posX;
    positionStartY = posY;
    angleFeuille = angle;
    size = taille;
    
    //Initialisation des StringBuffers
    generationCurrent = new StringBuffer();
    generationNext = new StringBuffer();

    //Initialisation de la règle qui gouverne le système
    rule = new LSystemRule('X', "[s-0][s+0][s|X]");
  }

  // Fonction permettant d'initialiser le système
  void reset()
  {
    generation = 1;
    segment = size;

    generationCurrent.delete(0, generationCurrent.length());
    generationNext.delete(0, generationNext.length());

    generationCurrent.append(axiom);
  }

  // fonction qui calcule la prochaine génération du système
  void compute()
  {
    if (generationNext.length() > 0)
      generationNext.delete(0, generationNext.length());

    for (indexSequence = 0; indexSequence < generationCurrent.length(); ++indexSequence)
    {
      symbol = generationCurrent.charAt(indexSequence);

      String replace = "" + symbol;
      
      if (rule.input == symbol)
        replace = rule.output;

      generationNext.append(replace);
    }

    if (generationCurrent.length() > 0)
      generationCurrent.delete(0, generationCurrent.length());

    generationCurrent.append(generationNext);
    ++generation;
  }

  // fonction qui dessine la génération courante du système
  void render()
  {
    stroke(couleur);
    fill(couleur);
    
    for (indexSequence = 0; indexSequence < generationCurrent.length(); ++indexSequence)
    {
      symbol = generationCurrent.charAt(indexSequence);

      switch (symbol)
      {
        //Tige
        case '|':
          strokeWeight(3);
          line(0, 0, segment, 0);
          translate(segment, 0);
          strokeWeight(3);
          break;

        //Feuille au sommet, qui sera remplacée à la prochaine génération
        case 'X':
          translate(segment, 0);
          strokeWeight(5);
          ellipse(0, 0, 2 * segment, segment / 2.5);
          break;
        
        //Feuille
        case '0':
          translate(segment, 0);
          strokeWeight(5);
          ellipse(0, 0, 2 * segment, segment / 2.5);
          break;

        //Rotations
        case '+':
          rotate(angle);
          break;
        case '-':
          rotate(-angle);
          break;

        //Modification du système de coordonnée
        case '[':
          pushMatrix();
          break;
        case ']':
          popMatrix();
          break;
        
        //Redimension
        case 's':
          scale(0.7);
          break;

        default:
          println("unknow symbol: " + symbol);
      }
    }
  }
}
