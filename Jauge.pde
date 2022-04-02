class Jauge {
  float posX, posY;
  float longueur, largeur;
  float hauteur;
  float niveau, niveauMax, niveauCourant;
  float vitesseUpdate;
  color couleurFond, couleurContour;
  
  Jauge(float x, float y, float l, float h, float n, float v, color cF, color cC) {
    posX = x;
    posY = y;
    longueur = largeur = l;
    hauteur = h;
    niveauMax = niveau = niveauCourant = n;
    vitesseUpdate = v;
    couleurFond = cF;
    couleurContour = cC;
  }
  
  void render() {
    rectMode(CORNER);
    
    //Fond
    noStroke();
    fill(200);
    rect(posX, posY, longueur, hauteur);
    
    //Intérieur
    fill(couleurFond);
    //La largeur est propotionnelle au niveau courant
    largeur = map(niveauCourant, 0, niveauMax, 0, longueur);
    rect(posX, posY, largeur, hauteur);
    
    //Dessus
    //stroke(150);
    stroke(couleurContour);
    strokeWeight(5);
    noFill();
    rect(posX, posY, longueur, hauteur);
  }
  
  void update() {
    //En tout temps, lorsque la jauge est affichée, on vérifie si le niveau absolu
    //et différent du niveau courant, c'est-à-dire celui qui est affiché. S'il y a
    //une différence, le niveau courant va tendre vers le niveau absolu.
    if (niveau > niveauCourant) {
      niveauCourant += vitesseUpdate;
      couleurContour = color(4, 51, 83, 255);
    } else if (niveau < niveauCourant) {
      niveauCourant -= vitesseUpdate;
    }
  }
}
