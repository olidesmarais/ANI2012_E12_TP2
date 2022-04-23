//Classe de type Feuillage
//Elle permet de gérer la collection d'instances de la classe Feuille.
class Feuillage {
  
  //Nombre de feuilles.
  int countFeuille = 10;
  
  //Profondeur du système dynamique des feuilles.
  int depthCurrent;
  int depthMax = 10;
  
  //Collection de feuilles.
  Feuille[] tabFeuilles;
  
  //Constructeur.
  Feuillage() {
    depthCurrent = 2;
    
    //Ajout des feuilles contenues dans le feuillage dans le tableau permettant de les répertorier.
    ajouterFeuilles();
    
    //Génération du système dynamique.
    generate();
  }
  
  //Méthode permettant d'ajouter les feuilles à la collection. 
  //La construction de chacune des instances de feuille se fait grâce aux données contenues dans
  //un fichier CSV répertoriant la position en X et Y, l'angle et la taille de chacune d'elles.
  void ajouterFeuilles() {
    float posX;
    float posY;
    float angle;
    float size;
    
    //Création du tableau contenant la collection.
    tabFeuilles = new Feuille[dataFeuilles.getRowCount()];
    
    //Initialisation de chacune des instances de feuille.
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
  
  //Fonction permettant d'afficher le feuillage, c'est-à-dire d'afficher
  //chacune des feuilles qui le composent.
  void render() {
    for (Feuille feuille : tabFeuilles)
      afficherFeuille(feuille);
  }
  
  //Fonction permettant d'afficher une feuille du feuillage.
  void afficherFeuille(Feuille feuille) {
    //Modification du système de coodonnées.
    pushMatrix();
    //Déplacement du système de coordonnées à la position de la feuille.
    translate(feuille.positionStartX, feuille.positionStartY);
    //Rotation du système de coordonnées pour correspondre à celle de la feuille.
    rotate(feuille.angleFeuille);
    
    //Affichage de la feuille.
    feuille.render();  
    
    popMatrix();
  }
}
