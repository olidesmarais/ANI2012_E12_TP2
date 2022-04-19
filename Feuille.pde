// ANI2012H22_LSystem/LSystem.pde
// Classe de type LSystem.

class Feuille
{
  int generation;

  int indexSequence;
  int indexRule;

  float size;

  float angle = 1.0646515;
  
  int couleur = color(200, 100, 200);
  
  float positionStartX;
  float positionStartY;
  float angleFeuille;

  float segment;

  char symbol;

  String axiom = "|X";
  String sequence;

  StringBuffer generationCurrent;
  StringBuffer generationNext;

  LSystemRule rule;

  ArrayList<LSystemRule> listRules;

  Feuille(float posX, float posY, float angle, float taille)
  {
    positionStartX = posX;
    positionStartY = posY;
    angleFeuille = angle;
    size = taille;
    
    generationCurrent = new StringBuffer();
    generationNext = new StringBuffer();
    
    listRules = new ArrayList<LSystemRule>();
    listRules.add(new LSystemRule('X', "[s-0][s+0][s|X]"));
  }

  // fonction qui réinitialise le système
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

      for (indexRule = 0; indexRule < listRules.size(); ++indexRule)
      {
        rule = listRules.get(indexRule);

        if (rule.input == symbol)
        {
          replace = rule.output;
          break;
        }
      }
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
        case '|':
          strokeWeight(3);
          line(0, 0, segment, 0);
          translate(segment, 0);
          strokeWeight(3);
          point(0, 0);
          break;

        case 'X':
          translate(segment, 0);
          strokeWeight(5);
          ellipse(0, 0, 2 * segment, segment / 2.5);
          break;
        
        case '0':
          translate(segment, 0);
          strokeWeight(5);
          ellipse(0, 0, 2 * segment, segment / 2.5);
          break;

        case '+':
          rotate(angle);
          break;

        case '-':
          rotate(-angle);
          break;

        case '[':
          pushMatrix();
          break;

        case ']':
          popMatrix();
          break;
          
        case 's':
          scale(0.7);
          break;

        default:
          println("unknow symbol: " + symbol);
      }
    }
  }
}
