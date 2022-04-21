class Renard extends Animal {

  Renard() {
    super();
    image = imgRenard;
  }
  
  void render() {
    super.render();
    
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    
    
    //Test
    fill(255);
    noStroke();
    ellipse(0, 0, 50, 50);
    fill(0);
    ellipse(0, 0, 10, 10);
    stroke(255);
    line(-50, 0, 50, 0);
    
    
    
    
    //image(image, 0, 0);
    popMatrix();
  }
}
