class AnimalLapin extends Animal {
  
  float angleSaut = 0.0;
  float hauteurSautMax;
  
  AnimalLapin(int typeEntree) {
    super(typeEntree);
    
    image = imgLapin;
    son = sonLapin;
    
    if (entree < 2)
      hauteurSautMax = 20.0f;
    else
      hauteurSautMax = 10.0f;
    
    decallageImage = 0.0f ;
    
    super.blurImage();
  }
  
  void update() {
    super.update();
    
    position.y += sin(radians(angleSaut)) * hauteurSautMax;
    angleSaut += radians(1000.0);
  }
  
  void render() {
    super.render();
  }
}
