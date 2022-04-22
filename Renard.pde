class Renard extends Animal {

  Renard() {
    super();
    image = imgRenard;
    
    decallageImage = 0.0f - image.height / 3;
  }
  
  void render() {
    super.render();
  }
}
