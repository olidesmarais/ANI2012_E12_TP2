class Ennemi {
  PVector position;
  Jauge jaugeVie;
  int dimension;
  PImage img; 
  int idxImg;
  
  //Constructeur
  Ennemi() {
    //Dimensions
    dimension = int(random(200.0f, 400.0f));
    
    //Position
    int posX = int(random(0 - dimension / 2, dimensionX - dimension / 2));
    int posY = int(random(0 - dimension / 2, height - hauteurCockpit - dimension / 2));
    position = new PVector(posX, posY);
    
    //Jauge de vie
    jaugeVie = new Jauge(position.x + dimension / 2, position.y + dimension / 8, 50, 10, 10, 0.5f, color(0, 255, 0, 255), color(150, 255));
    
    //Image
    img = createImage(dimension, dimension, ARGB);
    idxImg = 0;
  }
  
  void render() {
    imageMode(CORNER);
    
    //Lorsque le niveau de vie est inférieur ou égal à 5, l'ennemi commence
    //à disparaître proportionnellement à son niveau de vie. Sinon, sa transparence
    //et sa couleur est normele.
    if(jaugeVie.niveauCourant > 5)
      tint(255, 255);
    else 
      tint(255, map(jaugeVie.niveauCourant, 0, 5, 0, 255));
    
    //Copie de l'image de référence de l'ennemi à l'index en cours
    img.copy(imgEnnemis[idxImg], 0, 0, 400, 400, 0, 0, dimension, dimension);
    image(img, position.x, position.y);
    
    //La jauge de vie est activée lorsque le niveau de vie est en train de varier
    if (jaugeVie.niveauCourant > jaugeVie.niveau) {
        jaugeVie.render();
    }
    
    float hasard;
    
    //Dans 1% des cas, la séquence d'images est enclenchée
    if (idxImg == 0) {
      //hasard = 0;
      hasard = random(10.0f); 
      if (hasard > 9.9f) {
        idxImg++;
      }
    }
    
    //Image suivante de la sequence d'image
    if (idxImg > 0 && idxImg < 5) {
      idxImg++;
    } else if (idxImg == 6) {
      idxImg = 0;
    }
    
    //Rétablissement de l'opacité, au besoin
    tint(255, 255);
  }
  
  void verifierDegats (float clicX, float clicY) {
    
    //Emplacement relatif de l'attaque
    int posRelativeX = int(clicX) - int(position.x);
    int posRelativeY = int(clicY) - int(position.y);
    
    //Vérifier un contact direct
    if (verifierContact(posRelativeX, posRelativeY))
      jaugeVie.niveau -= 10;
    
    //Vérifier un contact indirect
    else {
      int posCx, posCy;
      
      //On vérifie tout autour de l'emplacement du clic s'il y a un contact
      for (float angle = radians(0) ; angle < radians(360) ; angle += 0.1) {
          //Position du pixel vérifier
          posCx = posRelativeX + int(cos(angle) * diametreAttraperEtoile);
          posCy = posRelativeY + int(sin(angle) * diametreAttraperEtoile);
          
          //S'il y a un contact, le niveau de vie est adapté
          //On sort de la fonction dès le premier cocntact
          if (verifierContact(posCx, posCy)) {
            jaugeVie.niveau -= 5;
            return;
          }
      }
    }
  }
    
  boolean verifierContact(int posRelativeX, int posRelativeY) {
    //Vérifier si l'attaque est dans le cadre de l'image
    if (posRelativeX >= 0 && posRelativeX <= dimension && posRelativeY >= 0 && posRelativeY <= dimension) {
      //Index du pixel de l'image
      int idxPixel = dimension * posRelativeY + posRelativeX;
      
      //Charger l'image actuelle
      img.loadPixels();
      
      //Si le pixel est dans le cadre de l'image
      if (idxPixel >= 0 && idxPixel < img.pixels.length) {
        
        //On considère qu'il y a un contact si le pixel concerné n'est pas 
        //complètement transparent
        if (alpha(img.pixels[idxPixel]) > alpha(0) ) {
          return true;
        } else
          return false;
      }
    }
    return false;
  }
}
