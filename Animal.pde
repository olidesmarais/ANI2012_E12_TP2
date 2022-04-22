class Animal {
  
  final static int ENTREE_DEVANT_GAUCHE  = 0;
  final static int ENTREE_DEVANT_DROITE  = 1;
  final static int ENTREE_ARRIERE_GAUCHE = 2;
  final static int ENTREE_ARRIERE_DROITE = 3;
  
  PImage image;
  Float decallageImage;
  int entree;
  boolean show, miroir;
  
  Vector3D position = new Vector3D();
  float rotation;
  
  //Animation
  float timeLast, timeNow, timeElapsed;
  float timelinePlayhead, timelineDuration;
  
  Animal() {
    
    entree = 0; //int(random(4.0f));
    
    switch(entree) {
      case ENTREE_DEVANT_GAUCHE :
        position.set( -3.0f, 239.0f, 0.0f);
        rotation = 0.22f;
        miroir = true;
        break;
      case ENTREE_DEVANT_DROITE :
        position.set( 814.0f, 409.0f, 0.0f);
        rotation = 0.23f;
        miroir = false;
        break;
      case ENTREE_ARRIERE_GAUCHE :
        position.set( 475.0f, 339.0f, 0.0f);
        rotation = -0.15f;
        miroir = true;
        break;
      case ENTREE_ARRIERE_DROITE :
        position.set( 1021.0f, 261.0f, 0.0f);
        rotation = -0.14f;
        miroir = false;
        break;
    }
    
    show = false;
    
    //Animation
    timelinePlayhead = 0.0f;
    timeElapsed = 0.0f;
    timelineDuration = 10.0f;
  }
  
  void update() {
    if (show) {
      timeNow = millis();
      timeElapsed = (timeNow - timeLast) / 1000.0f;
      timeLast = timeNow;
      
      timelinePlayhead += timeElapsed;
      
      if (timelinePlayhead >= timelineDuration)
        timelinePlayhead -= timelineDuration;
      
      switch(entree) {
        case ENTREE_DEVANT_GAUCHE:
          sequencer.update("clipRenard", ENTREE_DEVANT_GAUCHE, timelinePlayhead);
          position.x = sequencer.animauxPositionX[ENTREE_DEVANT_GAUCHE];
          position.y = sequencer.animauxPositionY[ENTREE_DEVANT_GAUCHE];
          rotation   = sequencer.animauxRotation[ENTREE_DEVANT_GAUCHE];
          break;
      }
    }
  }
  
  void render(){
    imageMode(CENTER);
    
    if (show) {
      //super.render();
      
      pushMatrix();
      translate(position.x, position.y);
      rotate(rotation);    
      
      if (miroir) {
        scale(-1, 1);
        image(image, 0, decallageImage); 
      } else
        image(image, 0, decallageImage);
      popMatrix();
    }
  }
  
}
