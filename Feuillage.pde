
class Feuillage {
  
  int countFeuille = 10;
  
  int depthCurrent;
  int depthMax = 10;
  
  //ArrayList<Feuille> tabFeuilles;
  Feuille[] tabFeuilles;
  
  Feuillage() {
    depthCurrent = 2;
    
    //Ajout des feuilles contenues dans le feuillage dans le tableau permettant de les répertorier
    tabFeuilles = new Feuille[10];
    tabFeuilles[0] = new Feuille(938.0, 233.0, -1.920796, 16.0);
    tabFeuilles[1] = new Feuille(977.0, 220.0, 1.1692016, 15.0);
    tabFeuilles[2] = new Feuille(743.0, 203.0, -3.8407943, 21.0);
    tabFeuilles[3] = new Feuille(945.0, 231.0, -4.470805, 50.0);
    tabFeuilles[4] = new Feuille(849.0, 189.0, -2.4807956, 14.0);
    tabFeuilles[5] = new Feuille(121.0, 405.0, -0.5207974, 15.0);
    tabFeuilles[6] = new Feuille(79.0, 448.0, -1.930796, 50.0);
    tabFeuilles[7] = new Feuille(149.0, 286.0, -0.9907969, 18.0);
    tabFeuilles[8] = new Feuille(139.0, 324.0, -2.200796, 24.0);
    tabFeuilles[9] = new Feuille(835.0, 238.0, -4.1007967, 30.0);
    
    //Génération du système
    generate();
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
