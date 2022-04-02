/*class Slider {
  PVector posJour, posNuit;
  PVector posIndicateur;
  float longueur;
  float diametre;
  PImage imgJour, imgNuit;
  
  Slider(float x, float y) {
    longueur = 50.0f;
    diametre = 20.0f;
    
    //Images de référence du jour et de la nuit
    imgJour = loadImage("images/soleil.png");
    imgNuit = loadImage("images/lune.png");
    
    //Emplacement des deux positions
    posJour = new PVector (x, y);
    posNuit = new PVector (x + longueur, y);
    
    //L'indicateur commence en podition Jour
    posIndicateur = new PVector (posJour.x, posJour.y);
  }
  
  void render() {
    tint(255, 255);
    ellipseMode(CENTER);

    //Ligne qui relie les cercles
    fill(255);
    stroke(255);
    strokeWeight(10);
    strokeCap(ROUND);
    line(posJour.x, posJour.y, posNuit.x, posNuit.y);
    
    //Les cercles
    noStroke();
    ellipse(posJour.x, posJour.y, diametre, diametre);
    ellipse(posNuit.x, posNuit.y, diametre, diametre);
    
    //Images de référemce
    imageMode(CENTER);
    image(imgJour, posJour.x, posJour.y - 1.5f * diametre, 20, 20);
    image(imgNuit, posNuit.x, posNuit.y - 1.5f * diametre, 20, 20);
    
    //Indicateur
    stroke(100);
    point(posIndicateur.x, posIndicateur.y);
  }
  
  void update() {
    //Si c'est la nuit, que la souris est pressée et que le curseur est par-dessus
    //le cercle du jour, on appelle le déplacement vers le jour
    if (verifierSuperposition(posJour) && pressed && !isJour)
      deplacement('j');
    
    //Vice versa
    if (verifierSuperposition(posNuit) && pressed && isJour)
      deplacement('n');
  }
  
  boolean verifierSuperposition(PVector position) {
    //Pytagore pour déterminer la distance qui sépare le centre du jour ou de la nuit
    //et l'emplacement du clic
    float distance =  sqrt(sq(mouseX - position.x) + sq(mouseY - position.y));
    
    //Si la distance est plus petite ou égale au cercle du jour ou de la nuit, on
    //retourn true
    return (distance <= diametre / 2);
  }
  
  //La destionation est un char ('j' ou 'n'). 'j' provoque un déplacement vers le jour
  //et le 'n', un déplacement vers la nuit
  void deplacement(char destination) {
    
    //Le déplacement modifie graduellement la position de l'indicateur jusqu'à ce
    //qu'il atteigne sa nouvelle position. C'est alors que le moment de la journée
    //est modifié par le boolean isJour et que le son "clic" est entendu.
    if (destination == 'j') {
      while (posIndicateur.x > posJour.x) 
        posIndicateur.x -= 0.0001f;
      isJour = true;
      sonClic.play();
    }
    if (destination == 'n') {
      while (posIndicateur.x < posNuit.x)
        posIndicateur.x += 0.0001;
      isJour = false;
      sonClic.play();
    }
  }
}*/
