class Fee {
  //PVector position;
  Vector3D position = new Vector3D();
  int hauteur, largeur;
  //float diametreContour;
  int type;
  PImage imgPapillon, imgFond;
  float angleProportionFond;
  //float angleTranslation;
  Vector3D angleTranslation;
  
  
  //int puissance;
  
  Fee() {
    //Position déterminée aléatoirement dans tout l'écran, sauf derrière let cockpit.
    //float posX = random(width);
    //float posY = random(height - hauteurCockpit);
    position.set(centreX, centreY, 0); //new PVector(posX, posY);
    
    //Détermination du type de l'étoie
    //0-Grande 1-Petite 2-Ronde
    type = determinerType();
    
    //En fonction du type déterminé aléatoirement selon les probabilités, 
    //les attributs associées au type sont accordées à l'étoile
    switch(type) {
      //Grande
      case 1 :
        largeur = 136;
        hauteur = 139;
        //puissance = 15;
        //diametreContour = 150;
        break;
      //Petite
      /*case 1 :
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
        break;*/
    }
    //Copie de l'image de référence pour le bon type 
    imgPapillon = createImage(largeur, hauteur, ARGB);
    imgPapillon.copy(feeRef[type], 0, 0, feeRef[type].width, feeRef[type].height, 0, 0, largeur, hauteur);
    angleTranslation = new Vector3D( 0.0f, 0.0f, 0.0f);
    
    imgFond = createImage(largeur, hauteur, ARGB);
    imgFond.copy(feeRef[0], 0, 0, feeRef[0].width, feeRef[0].height, 0, 0, largeur, hauteur);
    angleProportionFond = 0.0f;
  }
  
  int determinerType() {
   return 1;
    /*float probabilite = random(10);
    
    //10% de chance d'avoir un grande étoile
    if (probabilite > 9.0f)
      return 0;
    
    //40% de chance d'avoir une petite étoile
    else if (probabilite > 5.0)
      return 1;
    
    //50% de chance d'avoir une étoile ronde
    else
      return 2;*/
  }
  
  void render() {
    //Affichage de l'image associée à l'instance
    imageMode(CENTER);
    
    //Transformation de la fée
    pushMatrix();
    
    //Déplacement du système de coordonnées à la position de la fée.
    translate(position.x, position.y);
    
    translationFee();
    
    //Redimension de l'image de fond de la fée
    pushMatrix();
    scale(proportionFond());
    image(imgFond, 0, 0);
    popMatrix();
    
    
    image(imgPapillon, 0, 0);
    
    popMatrix();
    
  }
  
  boolean verifierSuperposition() {    
    /*//Pytagore pour déterminer la distance qui sépare le centre du cerlce de contour
    //de l'étoile et l'emplacement du clic
    float distance =  sqrt(sq(mouseX -position.x) + sq(mouseY - position.y));
   
    //On considère un contact lorsque la distance est inférieure ou égale au rayon
    //de cercle de l'attaque plus le rayon du cercle de comptour de l'étoile
    return (distance <= diametreAttraperEtoile / 2 + diametreContour / 2);*/
    
    return false;
  }
  
  float proportionFond() {
    //Déterminer la proportion voulue
    float proportion;
    proportion = 1.5f + sin(radians(angleProportionFond)) * 0.5f;
    
    //Mise à jour de l'angle assiciée à l'intensité de la redimension 
    angleProportionFond = (angleProportionFond + 5.0) % 360;
    
    //Retour de la valeur de proportion calculée
    return proportion;
  }
  
  void translationFee() {
    
    //Intensité de la translation en X et en Y
    float translationX, translationY;
    translationX = sin(radians(angleTranslation.x)) * 100;
    translationY = sin(radians(angleTranslation.y)) * 50;
    
    //Mise à jour des angles assiciées à l'intensité de la translation 
    angleTranslation.x = (angleTranslation.x + 3.0f) % 360;
    angleTranslation.y = (angleTranslation.y + 6.0f) % 360;
    
    //Application de la translation
    translate(translationX, translationY); // translationY);
  }
  
}
