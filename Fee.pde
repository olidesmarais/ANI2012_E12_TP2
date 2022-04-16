class Fee {
  final static int FEE_TYPE_BLEU  = 0;
  final static int FEE_TYPE_ROSE  = 1;
  final static int FEE_TYPE_JAUNE = 2;
  
  //PVector position;
  Vector3D position = new Vector3D();
  
  //int hauteur, largeur;
  int dimension;
  
  //float diametreContour;
  int type;
  
  PImage imgPapillon, imgFond;
  PImage[] tabImages;
  int idxImageCourante;
  
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
    println("type : " + type);
    
    //En fonction du type déterminé aléatoirement selon les probabilités, 
    //les attributs associées au type sont accordées à la fée
    
    tabImages = new PImage[3];
    dimension = 100;
    idxImageCourante = 0;
    
    switch(type) {
      case FEE_TYPE_BLEU :
        definirLesImages(feeRefBleu);
        println("case bleu");
        //tabImages = feeRefBleu;
        break;
      case FEE_TYPE_ROSE :
        definirLesImages(feeRefRose);
        //tabImages[0] = createImage(dimension, dimension, ARGB);
        //tabImages[0].copy(feeRefRose[0], 0, 0, feeRefRose[0].width, feeRefRose[0].height, 0, 0, dimension, dimension);
        println("case rose");
        //tabImages = feeRefRose;
        break;
      case FEE_TYPE_JAUNE :
        definirLesImages(feeRefJaune);
        println("case jaune");
        //tabImages = feeRefJaune;
        break;
    }
    
    
    
    
    
    //Copie de l'image de référence pour le bon type 
    imgPapillon = createImage(dimension, dimension, ARGB);
    //imgPapillon.copy(tabImages[idxImageCourante], 0, 0, tabImages[idxImageCourante].width, tabImages[idxImageCourante].height, 0, 0, dimension, dimension);
    angleTranslation = new Vector3D( 0.0f, 0.0f, 0.0f);
    translationMax = new Vector3D( 100.0f, 50.0f, 0.0f);
    translationCourante = new Vector3D();
    
    imgFond = createImage(dimension, dimension, ARGB);
    imgFond.copy(feeRefFond, 0, 0, feeRefFond.width, feeRefFond.height, 0, 0, dimension, dimension);
    angleProportionFond = 0.0f;
    
    attrapee = false;
    angleRotation = 0;
  }
  
  int determinerType() {
    return int(random(3));
    //return 2;
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
    
    //image(imgPapillon, 0, 0);
    image(tabImages[idxImageCourante], 0, 0);
    //image(feeRefBleu[0], 0, 0);
    
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
    } else {
      translationCourante.copy(translationFee());
      idxImageCourante = (idxImageCourante + 1) % 3;
      println("idx image : " + idxImageCourante);
      //imgPapillon.copy(tabImages[idxImageCourante]);
    }
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
    if (positionRelative.x >= 0 && positionRelative.x <= dimension && positionRelative.y >= 0 && positionRelative.y <= dimension) {      
      
      //Index du pixel de l'image touché
      int idxPixel = dimension * int(positionRelative.y) + int(positionRelative.x);
      
      //Charger l'image actuelle
      tabImages[idxImageCourante].loadPixels();
      
      //Si le pixel est dans le cadre de l'image
      if (idxPixel >= 0 && idxPixel < tabImages[idxImageCourante].pixels.length) {
        
        //On considère qu'il y a un contact si le pixel concerné n'est pas 
        //complètement transparent
        if (alpha(tabImages[idxImageCourante].pixels[idxPixel]) > alpha(0) ) {
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
  
  
  //Fonction permettant de copier les images de fée de la couleur appropriée dans le tableau d'image de l'instance de fée. 
  //La taille de ces images est adaptée en fonction de la dimension de la fée.
  void definirLesImages(PImage[] tabImgRef) {
    
    println("definirLesImage");
    println("taille tabImgRef : " + tabImgRef.length);
    
    //image(tabImgRef[0], centreX, centreY);
    
    //tabImages = new PImage[3];
    
    for (int idx = 0 ; idx < 3 ; idx++) {
      
      tabImages[idx] = createImage(dimension, dimension, ARGB);
      tabImages[idx].copy(tabImgRef[idx], 0, 0, tabImgRef[idx].width, tabImgRef[idx].height, 0, 0, dimension, dimension);
    }
    
  }
}
