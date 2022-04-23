class AnimalRenard extends Animal {
  float angleMarche = 0.0;
  
  AnimalRenard(int typeEntree) {
    super(typeEntree);
    image = imgRenard;
    son = sonRenard;
    
    decallageImage = 0.0f - image.height / 3;
    
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
