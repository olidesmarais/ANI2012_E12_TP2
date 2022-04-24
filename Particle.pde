//Classe de type Particle.
//Elle regroupe tous les renseignements nécessaires dans la gestion des particules d'un système de particules. 
//La collection de particule est gérée par la classe ParticleSystem.
class Particle
{
  //Systère de particule
  ParticleSystem ps;
  
  //Proprietes
  Vector3D position;
  color colorDiffuse;
  boolean isExpired;
  float lifetime;
  float timer;
  
  //Gestion du temps
  float timeStart;
  float timeFrame;
  float timeElapsed;
  float timeActive;

  //Constructeur
  Particle()
  {
    position = new Vector3D();

    colorDiffuse = #FFFFFF;

    isExpired = true;
  }

  //Fonction permettant l'initialisation de la particule pour
  //lui permettre d'être affichée.
  void init()
  {
    isExpired = false;

    timer = 0;
    timeStart = millis();
    timeFrame = timeStart;
    timeActive = 0;
  }

  //Fonction permettant la mise à jour de la particule
  void update()
  {
    timeElapsed = (millis() - timeFrame) / 1000.0f;
    timer += timeElapsed;

    if (timer > lifetime)
      isExpired = true;

    timeFrame = millis();
    timeActive = timeFrame - timeStart;
  }

  //Fonction permettant d'afficher la particule.
  void render()
  {
    fill(colorDiffuse, 127);
    ellipse(position.x, position.y, 32, 32);
  }
}
