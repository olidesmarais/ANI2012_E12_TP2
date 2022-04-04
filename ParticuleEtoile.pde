class ParticleEtoile extends ParticlePhysic {
  
  final static float probabilitySpawn = 0.5f;
  float radius;

  ParticleEtoile() {
    super();
    
    colorDiffuse = color(255, 155);
    lifetime = 0.5f;
    
    mass = 1.0f;
    speed = 100.0f;
    speedMax = 100.0f;
    noise.set(5.0f, 5.0f, 0.0f);
    
    //Taille de la particule aléatoire
    radius = random(2.0f, 5.0f);
  }
  
  
  void init()
  {
    super.init();
    
    //La position initiale de la particule correspond à la position de la souris.
    position.set(pointeBaguette.x, pointeBaguette.y, pointeBaguette.z);
    
    //Force de base déterminant l'intensité et la direction du déplacement de la particule.
    applyForce(random(-noise.x, noise.x), random(-noise.y, noise.y), 0.0f);
    
    //Un son d'étoile se fait entendre à l'apparition d'une nouvelle ParticuleEtoile.
    //Ce son est panoramique en fonction de la position de la souris sur l'axe des X.
    if (position.x >= 0 && position.x <= dimensionX)
      sonEtoile1.pan(map(position.x, 0, width, -1, 1));
    else if (position.x < 0)
      sonEtoile1.pan(-1);
    else
      sonEtoile1.pan(1);
    sonEtoile1.play();
  }
  
  void update() {
    
    //Calcul de la distance entre la particule et la pointe de la baguette
    float distanceSouris = dist(position.x, position.y, mouseX - imgBaguette.width + 75, mouseY - imgBaguette.height + 70);
    float distanceMax = 200.0f;
    
    //Si la particule est trop loin de la souris, elle ne bouge pas.
    if (distanceSouris > distanceMax) {
      force.set( 0.0f, 0.0f, 0.0f);
      velocity.set( 0.0f, 0.0f, 0.0f);
    
    //Sinon, sa vitesse est proportionnelle à sa proximité avec la souris. 
    } else {
      force.set(
        map(distanceSouris, distanceMax, 0.0f, 0.0f, force.x),
        map(distanceSouris, distanceMax, 0.0f, 0.0f, force.y),
        0.0f);
    }

    //Régulation de la vitesse
    if (velocity.magnitude() > speedMax)
    {
      velocity.normalize();
      velocity.scale(speedMax);
    }
    
    super.update();
  }
  
  void render() {
    
    fill(colorDiffuse);
    
    //Variable pour l'affichage d'une étoile
    int side = 5;
    float angle = radians(-90.0f);
    float offset = radians(360.0f / side);
    float vertexX, vertexY;
    
    //Début de la forme vectorielle
    beginShape();
    
    //Pour chaque côté de l'étoile
    for (int index = 0; index < side; ++index) {
      
      // calculer la position du prochain sommet
      vertexX = position.x + cos(angle) * radius;
      vertexY = position.y + sin(angle) * radius;
  
      // ajouter le sommet au polygone
      vertex(vertexX, vertexY);
  
      // décalage de 2 fois l'angle entre 2 sommets
      angle += offset * 2;
    }
  
    //Fin de la forme
    endShape(CLOSE);
  }
}
