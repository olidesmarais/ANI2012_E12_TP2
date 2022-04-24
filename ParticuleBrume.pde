//Classe de type ParticuleBrume. 
//Elle hérite de la classe ParticlePhysic. 
//Elle correspond au système de particules responsable de l'effet de brume visible en arrière-plan de l'écran principal.
class ParticuleBrume extends ParticlePhysic {
  
  final static float probabilitySpawn = 1.0f; 
  
  float diametre;
  float transparence;
  int idxCouleur;
  boolean couleurFixee;
  
  //Constructeur
  ParticuleBrume() {
    super();
    lifetime = 3.0f;
  }
  
  //Initialisation de la particule
  void init() {
    super.init();
    
    //Couleur de la particule
    idxCouleur = idxCouleurBrumeRef;
    transparence = 100.0f;
    //Taille de la particule
    diametre = random(50.0f, 100.0f);
    //Position de la particule
    position.set(random(width), 420.0f + diametre, 0.0f);
    //Initialement, la couleur de la particule peut être modifiée par l'utilisateur
    couleurFixee = false;
    
    //Les particules apparaîssent sur une position aléatoire essentiellement alignée, cachée par une image du décor.
    //Elles gravitent ensuite vers le haut, leur permettant de faire leur appararition. La force à l'origine de
    //cette ascention est directement proportionnelle à leur distance du centre.
    if (position.x < centreX)
      force.set( random(-2.0f, 0.0f), map(dist(position.x, position.y, centreX, centreY), 0, width / 2, 0, -2), 0.0f); 
    else
      force.set( random( 0.0f, 2.0f), map(dist(position.x, position.y, centreX, centreY), 0, width / 2, 0, -2), 0.0f);
    
    //Paramètres des particules
    speed = 25.0f;
    speedMax = 50.0f;
    noise.set(5.0f, 5.0f, 0.0f);
  }
  
  //Mise à jour de la paricule.
  void update() {
    super.update();
    
    //Si l'utilisateur interagit avec une particule, en cliquant sur celle-ci, sa couleur est modifée,
    //si elle n'est pas fixée.
    if (pressed && verifierSuperposition() && !couleurFixee) {
      //Déterminer la nouvelle couleur
      int nouvelIndexCouleur = int(random(couleursBrume.length));
      
      //S'assurer que la nouvelle couleur est différente de la précédente
      while(nouvelIndexCouleur == idxCouleur) {
        nouvelIndexCouleur = int(random(couleursBrume.length));
      } 
      
      //Application de la nouvelle couleur
      //À la particule touchée
      idxCouleur = nouvelIndexCouleur;
      //Et aux nouvelles particules du système
      idxCouleurBrumeRef = nouvelIndexCouleur;
      
      //Une fois la couleur modifiée, elle devient fixée, c'est-à-dire qu'elle ne peut donc plus être modifiée
      //tant l'utilisisateur ne relâche pas sa souris ou encore qu'il ne la déplace pas.
      couleurFixee = true;
    
    //S'il n'y a plus de superposition, la couleur n'est plus fixée, c'est-à-dire qu'elle peut être modifiée à nouveau.
    } else if (!verifierSuperposition())
      couleurFixee = false;
  }
  
  //Fonction permettant d'afficher la  particule.
  void render() {
    noStroke();
    colorDiffuse = couleursBrume[idxCouleur];
    fill(colorDiffuse, transparence--);
    ellipse(position.x, position.y, diametre, diametre);
  }
  
  //Méthode permettant de déterminer si la pointe de la baguette se trouve par-dessus la particule.
  boolean verifierSuperposition() {
    return dist(position.x, position.y, pointeBaguette.x, pointeBaguette.y) <= diametre / 2;
  }
}
