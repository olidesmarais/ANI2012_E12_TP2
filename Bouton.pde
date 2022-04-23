//Classe de type Bouton
//Appartement aux éléments de l'interface, son activation influence le déroulement du programme.

class Bouton {
  PVector position;
  float largeur, hauteur;
  String texte;
  int sizeTxt;
  
  //Constructeur
  Bouton(float x, float y, float w, float h, String t, int s) {
    position = new PVector (x, y);
    largeur = w;
    hauteur = h;
    texte = t;
    sizeTxt = s;
  }
  
  //Affichage du bouton
  void render() {
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    
    fill(255);
    noStroke();

    //Si la pointe de la souris est située par-dessus le bouton, la taille du bouton augmente 
    //et la couleur de sa police est modifiée.
    if (verifierSuperposition(pointeBaguette.x, pointeBaguette.y)) {
      rect( position.x, position.y, largeur * 1.1f, hauteur * 1.1f);
      fill(200, 100, 200);
    } else {
      rect( position.x, position.y, largeur, hauteur);
      fill(0);
    }
    
    //Inscription du texte approprié dans le bouton.
    textFont(policeBouton, sizeTxt);
    text(texte, position.x, position.y); 
  }
  
  //Fonction permettant de vérifier si la pointe de la baguette est située par-dessus le bouton.
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
