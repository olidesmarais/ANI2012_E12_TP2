class Animal {
  
  final static int NB_ENTREES = 4;
  final static int ENTREE_DEVANT_GAUCHE  = 0;
  final static int ENTREE_DEVANT_DROITE  = 1;
  final static int ENTREE_ARRIERE_GAUCHE = 2;
  final static int ENTREE_ARRIERE_DROITE = 3;
  
  PImage image;
  SoundFile son;
  Float decallageImage;
  int entree;
  boolean miroir;
  float proportion;
  
  Vector3D position = new Vector3D();
  float rotation;
  
  //Animation
  float timeLast, timeNow, timeElapsed;
  float timelinePlayhead, timelineDuration;
  
  Animal(int typeEntree) {
    
    //Entrée par l'AVANT et la GAUCHE du canevas    = 0
    //Entrée par l'AVANT et la DROITE du canevas    = 1
    //Entrée par l'ARRIÈRE et la GAUCHE du caneva   = 2
    //Entrée par l'ARRIÈRE et la DROITE du canevas  = 3
    entree = typeEntree;
    
    switch(entree) {
      case ENTREE_DEVANT_GAUCHE :
        position.set( -3.0f, 239.0f, 0.0f);
        rotation = 0.22f;
        miroir = true;
        proportion = 0.66;
        break;
      case ENTREE_DEVANT_DROITE :
        position.set( 814.0f, 409.0f, 0.0f);
        rotation = 0.23f;
        miroir = false;
        proportion = 0.66;
        break;
      case ENTREE_ARRIERE_GAUCHE :
        position.set( 475.0f, 339.0f, 0.0f);
        rotation = -0.15f;
        miroir = true;
        proportion = 0.33;
        break;
      case ENTREE_ARRIERE_DROITE :
        position.set( 1021.0f, 261.0f, 0.0f);
        rotation = -0.14f;
        miroir = false;
        proportion = 0.33;
        break;
    }
    
    //Animation
    timelinePlayhead = 0.0f;
    timeElapsed = 0.0f;
    timelineDuration = 30.0f;
  }
  
  //Fonction permettant des mettre à jour l'ordonnée et l'abscisse de la position ainsi
  //que la rotation en fonction de la courbe d'animation adaptée au point d'entrée de l'animal
  void update() {
  
    switch(entree) {
      case ENTREE_DEVANT_GAUCHE:
        sequencer.update("clipAnimal", ENTREE_DEVANT_GAUCHE, timelinePlayhead);
        position.x = sequencer.animauxPositionX[ENTREE_DEVANT_GAUCHE];
        position.y = sequencer.animauxPositionY[ENTREE_DEVANT_GAUCHE];
        rotation   = sequencer.animauxRotation[ENTREE_DEVANT_GAUCHE];
        break;
      case ENTREE_DEVANT_DROITE:
        sequencer.update("clipAnimal", ENTREE_DEVANT_DROITE, timelinePlayhead);
        position.x = sequencer.animauxPositionX[ENTREE_DEVANT_DROITE];
        position.y = sequencer.animauxPositionY[ENTREE_DEVANT_DROITE];
        rotation   = sequencer.animauxRotation[ENTREE_DEVANT_DROITE];
        break;
      case ENTREE_ARRIERE_GAUCHE:
        sequencer.update("clipAnimal", ENTREE_ARRIERE_GAUCHE, timelinePlayhead);
        position.x = sequencer.animauxPositionX[ENTREE_ARRIERE_GAUCHE];
        position.y = sequencer.animauxPositionY[ENTREE_ARRIERE_GAUCHE];
        rotation   = sequencer.animauxRotation[ENTREE_ARRIERE_GAUCHE];
        break;
      case ENTREE_ARRIERE_DROITE:
        sequencer.update("clipAnimal", ENTREE_ARRIERE_DROITE, timelinePlayhead);
        position.x = sequencer.animauxPositionX[ENTREE_ARRIERE_DROITE];
        position.y = sequencer.animauxPositionY[ENTREE_ARRIERE_DROITE];
        rotation   = sequencer.animauxRotation[ENTREE_ARRIERE_DROITE];
        break;
    }
  }
  
  void render(){
    imageMode(CENTER);
    pushMatrix();
    
    //Modification du système de coordonnée en fonction de la position de l'animal.
    translate(position.x, position.y);
    rotate(rotation);
    scale(proportion);
    
    //Affichage de l'image permettant de représenter l'animal avec l'application de
    //l'effet miroir s'il entre dans le canevas par la gauche.
    if (miroir) {
      scale(-1, 1);
      image(image, 0, decallageImage); 
    } else
      image(image, 0, decallageImage);
    popMatrix();
  }
  
  //Fonction permettant de vérifier si la pointe de la baguette se situe par-dessus l'image qui représente l'animal.
  boolean verifierSuperposition() {
    Vector3D coinImage = new Vector3D(position.x - (image.width * proportion) / 2, position.y - (image.height * proportion) / 2, 0.0f);
    Vector3D positionRelative = new Vector3D(pointeBaguette.x - coinImage.x, pointeBaguette.y - coinImage.y, 0.0f);
    
    //Vérifier si la pointe de la baguette est dans le cadre de l'image
    return positionRelative.x >= 0 && positionRelative.x <= image.width * proportion && positionRelative.y >= 0 && positionRelative.y <= image.height * proportion;
  }
}
