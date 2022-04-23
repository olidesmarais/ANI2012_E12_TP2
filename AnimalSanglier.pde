class AnimalSanglier extends Animal {

  float angleMarche = 0.0;
  
  AnimalSanglier() {
    super();
    image = imgSanglier;
    son = sonSanglier;
    
    decallageImage = 0.0f - image.height / 5;
  }
  
  void update() {
    super.update();
    
    rotation += sin(radians(angleMarche)) * 0.05f;
    angleMarche += radians(1000.0);
  }
  
  void render() {
    super.render();
  }
}
