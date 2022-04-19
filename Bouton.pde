class Bouton {
  PVector position;
  float largeur, hauteur;
  boolean contour;
  //color couleurFond;
  String texte;
  int sizeTxt;
  //color couleurPolice;
  
  
  Bouton(float x, float y, float w, float h, boolean c, String t, int s) {
    position = new PVector (x, y);
    largeur = w;
    hauteur = h;
    contour = c;
    texte = t;
    sizeTxt = s;
  }
  
  void render() {
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    
    fill(255);
    
    //Afficher un comptour s'il en faut un
    if (contour) {
      //stroke(130);
      stroke(4, 51, 83);
      strokeWeight(5);
    } else {
      noStroke();
    }
    
    //Si la souris est par-dessus le bouton, la tailledu bouton est plus grande
    //et la couleur de sa police est modifiée.
    if (verifierSuperposition(pointeBaguette.x, pointeBaguette.y)) {
      rect( position.x, position.y, largeur * 1.1f, hauteur * 1.1f);
      fill(0, 200, 0);
    } else {
      rect( position.x, position.y, largeur, hauteur);
      fill(0);
    }
    
    //Inscription du texte approprié dans le bouton.
    textFont(policeBouton, sizeTxt);
    text(texte, position.x, position.y); 
  }
  
  boolean verifierSuperposition( float posX, float posY) {
    boolean supX = false, supY = false;
    
    //Vérifier s'il y a superposition sur l'axe des X
    if (posX > position.x - largeur / 2 && posX < position.x + largeur / 2)
      supX = true;
     
     //Vérifier s'il y a superposition sur l'axe des Y
     if (posY > position.y - hauteur / 2 && posY < position.y + hauteur / 2)
       supY = true;
     
     //Retourner vrai s'il y a superposition dans les deux axes
     return (supX && supY);
  }
}
