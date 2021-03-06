//Classe de type ParticleSystem.
//Responsable de la gestion des instances de la classe Particle.
//Permet de gérer un système de particule.

class ParticleSystem
{
  //Types de système de particules
  final static int PARTICLE_TYPE_ETOILE  = 1;
  final static int PARTICLE_TYPE_BRUME   = 2;

  int index;

  int count;
  int type;

  int activeParticleCount;

  float timeStart;
  float timeNow;
  float timeLast;
  float timeElapsed;

  float timeScale = 1.0f;

  float probabilitySpawn;

  // collection de systèmes de particules
  ArrayList<Particle> system;

  // collection de particules actives
  ArrayList<Particle> particleActive;

  // collection de particules inactives
  ArrayList<Particle> particleReady;

  // itérateur de projectiles
  Iterator<Particle> iterator;

  Vector3D space;
  Vector3D origin;

  Particle particle;

  //Constructeur
  ParticleSystem(int size, int type)
  {
    count = size;
    this.type = type;
    init();
  }

  //Fonction permettant l'initialisation d'un systèmne de particules
  void init()
  {
    system = new ArrayList<Particle>();

    particleActive = new ArrayList<Particle>();
    particleReady = new ArrayList<Particle>();

    origin = new Vector3D(width / 2.0f, height / 2.0f, 0.0f);
    space = new Vector3D();

    //Initialisation du système de particules en fonction de son type.
    //PARTICLE_TYPE_ETOILE : 1
    //PARTICLE_TYPE_BRUME  : 2
    for (index = 0; index < count; ++index)
    {
      switch (type)
      {
        case PARTICLE_TYPE_ETOILE:
          particle = new ParticuleEtoile();
          probabilitySpawn = ParticuleEtoile.probabilitySpawn;
          break;
        case PARTICLE_TYPE_BRUME:
          particle = new ParticuleBrume();
          probabilitySpawn = ParticuleBrume.probabilitySpawn;
          break;
      }
      
      particle.ps = this;
      particle.position.copy(origin);

      system.add(particle);
      particleReady.add(particle);
    }

    timeStart = millis();
    timeLast= timeStart;
  }

  //Mise à jour du système de particule en fonction de si de nouvelles particules doivent être crées.
  void update(boolean creerNouvelle)
  {
    // mise à jour des variables en lien avec le temps
    timeNow = millis();
    timeElapsed = (timeNow - timeLast) / 1000.0f;
    timeLast = timeNow;

    // mise à jour de l'émetteur de particules
    updateEmitter(creerNouvelle);

    // nombre de particules actives
    activeParticleCount = particleActive.size();

    // valider s'il y a des particules actives
    if (activeParticleCount > 0)
    {
      // boucler sur la collection de particules actives
      for (index = 0; index < particleActive.size(); ++index)
      {
        // référence vers la particule situé à cet index de la collection
        particle = particleActive.get(index);

        // valider si la particule est expirée
        if (!particle.isExpired)
        {
          // mettre à jour la particule
          particle.update();
        }
        else
        {
          // recycler la particule si elle est expirée
          recycle(particle);
        }
      }
      
      // obtenir un itérateur pour la collection de particules actives
      iterator = particleActive.iterator();

      // boucle avec itérateur et un 'while' car présence d'un 'remove' qui modifie la taille de la collection
      while (iterator.hasNext())
      {
        particle = iterator.next();

        if (!particle.isExpired)
          particle.render();
      }
    }
  }
   
    
  //Fonction permettant d'ajouter une nouvelle particule au système à un emplacement défini. 
  void addParticule(float positionX, float positionY)
  {
    if (particleReady.size() > 0)
    {
      particle = particleReady.get(0);

      particle.init();

      particle.position.x = positionX;
      particle.position.y = positionY;

      particleReady.remove(0);
      particleActive.add(particle);
    }
    else
      print("particles system overload");
  }

  //Mise à jour de l'émetteur en fonction du besoin en nouvelles particules.
  void updateEmitter(boolean creerNouvelle)
  {
    if (random(0.0f, 1.0f) < probabilitySpawn && creerNouvelle && particleReady.size() > 0)
    {
      if (particleReady.size() > 0)
      {
        particle = particleReady.get(0);

        particle.init();

        particleReady.remove(0);
        particleActive.add(particle);
      }
      else
        print("sytem overload");
    }
  }

  //Fonction permettant de retirer la particule de la collection active
  //et de la placée dans la collection prête à être utilisée.
  void recycle(Particle p)
  {
    particleActive.remove(p);
    particleReady.add(p);
  }
}
