class AnimalOrignal extends Animal {

  float angleMarche = 0.0;
  
  AnimalOrignal(int typeEntree) {
    super(typeEntree);
    image = imgOrignal;
    son = sonOrignal;
    
    decallageImage = 0.0f - image.height / 5;
  }
  
  void update() {
    super.update();
    
    rotation += sin(radians(angleMarche)) * 0.1f;
    angleMarche += radians(250.0);
  }
  
  void render() {
    super.render();
  }
}
