//Classe test pour établir les poses clées des animaux

class Repere extends Animal {
  
  Repere() {
    super(0);
    
    position.set(centreX, centreY, 0.0f);
    rotation = 0.0f;
    //show = false;
    //image = createImage(10, 10, ARGB);
    
    decallageImage = 0.0f;
  }
  
  void render() {
    //super.render();
    //if (show) {
      pushMatrix();
      translate(position.x, position.y);
      rotate(rotation);
      
      
      //Test
      noFill();
      stroke(255);
      ellipse(0, 0, 50, 50);
      fill(0);
      ellipse(0, 0, 10, 10);
      
      line(-50, 0, 50, 0);
      
      popMatrix();
   // }
  }
}
