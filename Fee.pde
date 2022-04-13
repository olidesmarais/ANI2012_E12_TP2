class Fee {
  //PVector position;
  Vector3D position = new Vector3D();
  int hauteur, largeur;
  //float diametreContour;
  int type;
  
  
  PImage imgPapillon, imgFond;
  
  //Proportion
  float angleProportionFond;
  
  //Rotation
  boolean attrapee;
  float angleRotation;
  
  //Translation
  Vector3D translationMax;
  Vector3D translationCourante;
  Vector3D angleTranslation;
  
  Fee() {
    //Position déterminée aléatoirement dans tout l'écran, sauf derrière let cockpit.
    //float posX = random(width);
    //float posY = random(height - hauteurCockpit);
    position.set(centreX, centreY, 0); //new PVector(posX, posY);
    
    //Détermination du type de fée
    type = determinerType();
    
    //En fonction du type déterminé aléatoirement selon les probabilités, 
    //les attributs associées au type sont accordées à la fée
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
    translationMax = new Vector3D( 100.0f, 50.0f, 0.0f);
    translationCourante = new Vector3D();
    
    imgFond = createImage(largeur, hauteur, ARGB);
    imgFond.copy(feeRef[0], 0, 0, feeRef[0].width, feeRef[0].height, 0, 0, largeur, hauteur);
    angleProportionFond = 0.0f;
    
    attrapee = false;
    angleRotation = 0;
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
    
    translate(translationCourante.x, translationCourante.y);
    rotate(angleRotation);
    
    //Redimension de l'image de fond de la fée
    pushMatrix();
    scale(proportionFond());
    image(imgFond, 0, 0);
    popMatrix();
    
    
    image(imgPapillon, 0, 0);
    
    popMatrix();
    
  }
  
  void update() {
    
    if(verifierSuperposition() && pressed)
      attrapee = true;
    else if (!pressed)
      attrapee = false;
    
    //Si la fée est attrapée, sa position devient celle de la pointe de la baguette, en conservant la translation courante.
    if (attrapee) {
      position.set(pointeBaguette.x - translationCourante.x, pointeBaguette.y - translationCourante.y, 0.0f);
      
      
      
    //Sinon, la translation se poursuit
    } else
      translationCourante.copy(translationFee());
  }
  
  boolean verifierSuperposition() {    

    //Vector3D emplacementActuel = new Vector3D();
    Vector3D coinImgActuelActuel = new Vector3D();
    Vector3D positionRelative = new Vector3D();
    
    //Position du coin de l'image de la fée
    coinImgActuelActuel.copy(determinerCoinImgActuel());
    
    //Position relative de la pointe de la baguette sur l'image
    positionRelative.set( pointeBaguette.x - coinImgActuelActuel.x, pointeBaguette.y - coinImgActuelActuel.y, 0);

    
    //Vérifier si la pointe de la baguette est dans le cadre de l'image
    if (positionRelative.x >= 0 && positionRelative.x <= imgPapillon.width && positionRelative.y >= 0 && positionRelative.y <= imgPapillon.height) {      
      
      //Index du pixel de l'image touché
      int idxPixel = imgPapillon.width * int(positionRelative.y) + int(positionRelative.x);
      
      //Charger l'image actuelle
      imgPapillon.loadPixels();
      
      //Si le pixel est dans le cadre de l'image
      if (idxPixel >= 0 && idxPixel < imgPapillon.pixels.length) {
        
        //On considère qu'il y a un contact si le pixel concerné n'est pas 
        //complètement transparent
        if (alpha(imgPapillon.pixels[idxPixel]) > alpha(0) ) {
          return true;
        } else
          return false;
      }
    }
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
  
  Vector3D translationFee() {
    
    //Intensité de la translation en X et en Y
    Vector3D translationCourante = new Vector3D( sin(radians(angleTranslation.x)) * translationMax.x, sin(radians(angleTranslation.y)) * translationMax.y, 0.0f);
    
    //Mise à jour des angles assiciées à l'intensité de la translation 
    angleTranslation.x = (angleTranslation.x + 3.0f) % 360;
    angleTranslation.y = (angleTranslation.y + 6.0f) % 360;
    
    //Application de la translation
    //translate(translationX, translationY);
    
    return translationCourante;
  }
  
  //Fonction retournant un Vector3D dont les propriétés indiquent la position courante de la fée, avec application de la translation.
  Vector3D determinerPositioActuelle() {
    Vector3D positionActuelle = new Vector3D( position.x + translationCourante.x, position.y + translationCourante.y, 0.0f);
    return positionActuelle;
  }
  
  Vector3D determinerCoinImgActuel() {
    
    Vector3D positionActuelle = new Vector3D();
    Vector3D coinActuel = new Vector3D();
    
    //Déterminer la position courante de la fée, avec l'effet de translation
    positionActuelle.copy(determinerPositioActuelle());
    
    //Déterminer et retourner l'emplacement du coin de l'image
    coinActuel.set(positionActuelle.x - imgPapillon.width / 2, positionActuelle.y - imgPapillon.height / 2, 0);
    
    return coinActuel;
  }
}
