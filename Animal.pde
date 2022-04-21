class Animal {
  
  final static int ENTREE_DEVANT_GAUCHE = 0;
  final static int ENTREE_DEVANT_DROITE = 1;
  final static int ENTREE_ARRIERE_GAUCHE = 2;
  final static int ENTREE_ARRIERE_DROITE = 3;
  
  int entree;
  PImage image;
  
  boolean show, miroir;
  
  Vector3D position = new Vector3D();
  float rotation = 0.0;
  
  Animal() {
    
    entree = int(random(4.0f));
    
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
    
    show = true;
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
        image(image, 0, -image.height / 3);
      } else
        image(image, 0, -image.height / 3);
      popMatrix();
    }
    
  }
  
}
