class Etoile {
  PVector position;
  int hauteur, largeur;
  float diametreContour;
  int type;
  PImage image;
  int puissance;
  
  Etoile() {
    //Position déterminée aléatoirement dans tout l'écran, sauf derrière let cockpit.
    float posX = random(width);
    float posY = random(height - hauteurCockpit);
    position = new PVector(posX, posY);
    
    //Détermination du type de l'étoie
    //0-Grande 1-Petite 2-Ronde
    type = determinerType();
    
    //En fonction du type déterminé aléatoirement selon les probabilités, 
    //les attributs associées au type sont accordées à l'étoile
    switch(type) {
      //Grande
      case 0 :
        largeur = 209;
        hauteur = 214;
        puissance = 15;
        diametreContour = 150;
        break;
      //Petite
      case 1 :
        largeur = 78;
        hauteur = 80;
        puissance = 10;
        diametreContour = 55;
        break;
      //Ronde
      case 2 :
        largeur = 70;
        hauteur = 69;
        puissance = 5;
        diametreContour = 45;
        break;
    }
    //Copie de l'image de référence pour le bon type 
    image = createImage(largeur, hauteur, ARGB);
    image.copy(etoilesRef[type], 0, 0, largeur, hauteur, 0, 0, largeur, hauteur);
  }
  
  int determinerType() {
    float probabilite = random(10);
    
    //10% de chance d'avoir un grande étoile
    if (probabilite > 9.0f)
      return 0;
    
    //40% de chance d'avoir une petite étoile
    else if (probabilite > 5.0)
      return 1;
    
    //50% de chance d'avoir une étoile ronde
    else
      return 2;
  }
  
  void render() {
    //Affichage de l'image associée à l'instance
    imageMode(CENTER);
    image(image, position.x, position.y);
  }
  
  boolean verifierSuperposition() {    
    //Pytagore pour déterminer la distance qui sépare le centre du cerlce de contour
    //de l'étoile et l'emplacement du clic
    float distance =  sqrt(sq(mouseX -position.x) + sq(mouseY - position.y));
   
    //On considère un contact lorsque la distance est inférieure ou égale au rayon
    //de cercle de l'attaque plus le rayon du cercle de comptour de l'étoile
    return (distance <= diametreAttraperEtoile / 2 + diametreContour / 2);
  }
  
}
