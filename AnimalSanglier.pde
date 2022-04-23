class AnimalSanglier extends Animal {

  float angleMarche = 0.0;
  
  AnimalSanglier(int typeEntree) {
    super(typeEntree);
    image = imgSanglier;
    son = sonSanglier;
    
    decallageImage = 0.0f - image.height / 5;
    
    super.blurImage();
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
