class Feuillage {
  
  int countFeuille = 10;
  
  int depthCurrent;
  int depthMax = 10;
  
  //ArrayList<Feuille> tabFeuilles;
  Feuille[] tabFeuilles;
  
  Feuillage() {
    depthCurrent = 2;
    
    //Ajout des feuilles contenues dans le feuillage dans le tableau permettant de les répertorier
    ajouterFeuilles();
    
    //Génération du système
    generate();
  }
  
  void ajouterFeuilles() {
    float posX;
    float posY;
    float angle;
    float size;
    
    tabFeuilles = new Feuille[dataFeuilles.getRowCount()];
    
    for (int ligne = 0 ; ligne < dataFeuilles.getRowCount() ; ligne++) {
      posX = dataFeuilles.getFloat(ligne, 0);
      posY = dataFeuilles.getFloat(ligne, 1);
      angle = dataFeuilles.getFloat(ligne, 2);
      size = dataFeuilles.getFloat(ligne, 3);

      tabFeuilles[ligne] = new Feuille(posX, posY, angle, size);
    }
    
    
  }
  
  //Fonction permettant de générer le système de Lindenmayer de chacune des feuilles
  void generate() {
    
    for (Feuille feuille : tabFeuilles) {
      feuille.reset();
    
      for (int i = 0; i < depthCurrent; ++i)
      {
        feuille.compute();
      }
    }
  }
  
  //Fonction permettant d'afficher le feuillage
  void render() {
    for (Feuille feuille : tabFeuilles)
      afficherFeuille(feuille);
  }
  
  //Fonction permettant d'afficher une feuille du feuillage
  void afficherFeuille(Feuille feuille) {
    pushMatrix();
    translate(feuille.positionStartX, feuille.positionStartY);
    rotate(feuille.angleFeuille);
    feuille.render();      
    popMatrix();
  }
}
