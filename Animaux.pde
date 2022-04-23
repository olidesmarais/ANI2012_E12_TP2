//Classe de type Animaux
//Elle permet de gérer la collection d'instances de la classe Animal.
class Animaux{
  
  AnimationClip[] clipAnimaux;
  ArrayList<Animal> animauxShow, animauxDispos;
  Iterator<Animal> iterateur;
  Animal animal;
  
  Animaux() {
    //Création des deux collections d'instances de la classe Animal
    //animauxShow correspond aux instances couramment affichées
    //animauxDispos correspond aux instances disponibles pour être affichées
    animauxShow = new ArrayList<Animal>();
    animauxDispos = new ArrayList<Animal>();
    
    //Initialement, toutes les instances sont ajoutées à la collection disponible.
    //Une instance de chaque type d'animal est créée pour chaque position d'entrée possible,
    //pour un total de 16 instances (4 type d'animal et 4 points d'entrée).
    for (int entree = 0 ; entree < Animal.NB_ENTREES ; entree++) {
      animauxDispos.add(new AnimalLapin(entree));
      animauxDispos.add(new AnimalOrignal(entree));
      animauxDispos.add(new AnimalRenard(entree));
      animauxDispos.add(new AnimalSanglier(entree));
    }
    
    //La gestion des animations liées aux instances de la classe Animal se fait
    //par le biais de 4 clips d'animation, soit un clip par point d'entrée. Ces
    //clips sont stockés dans un tableau de clips d'animation. Chaque clip possède
    //trois courbes d'animation modulant les positions en ordonnée et en abscisse 
    //ainsi que la rotation.
    clipAnimaux = new AnimationClip[4];
    String[] tabCourbeAnimaux = {"positionX", "positionY", "rotation"};
    clipAnimaux[Animal.ENTREE_DEVANT_GAUCHE] = new AnimationClip(tabCourbeAnimaux);
    clipAnimaux[Animal.ENTREE_DEVANT_DROITE] = new AnimationClip(tabCourbeAnimaux);
    clipAnimaux[Animal.ENTREE_ARRIERE_GAUCHE] = new AnimationClip(tabCourbeAnimaux);
    clipAnimaux[Animal.ENTREE_ARRIERE_DROITE] = new AnimationClip(tabCourbeAnimaux);
  }
  
  //Fonction permettant de mettre à jour les propriétés des instances de la classe Animal.
  //Les propriétés doivent être mises à jour uniquement pour les instances faisant partie
  //de la collection des animaux affichés.
  void update() {
    
    //Un itérateur est utilisé pour traverser la collection afin de pouvoir retirer des instances
    //pour les replacer dans la collection des instances disponibles.
    iterateur = animauxShow.iterator();

    //Itération à travers les instances de la classe Animal figurant dans la collection des animaux affichés.
    while (iterateur.hasNext())
    {
      animal = iterateur.next();
    
      //Gestion du temps
      animal.timeNow = millis();
      animal.timeElapsed = (animal.timeNow - animal.timeLast) / 1000.0f;
      animal.timeLast = animal.timeNow;
      
      //Gestion des animations
      animal.timelinePlayhead += animal.timeElapsed;
      
      //Si les courbes d'animation sont achevées, les instances sont retirées
      //de la collection affichée pour les replacer dans la collection disponible.
      if (animal.timelinePlayhead >= animal.timelineDuration) {
        animauxDispos.add(animal);
        iterateur.remove();
      //Sinon, les propriétés de l'instance sont mises à jour.
      } else {
        animal.update();
      }
    }    
  }
  
  //Les animaux ont 4 points d'entrée dans le canevas, soit
  //Deux points d'entrée à l'avant   : ENTREE_DEVANT_GAUCHE  (0) et ENTREE_DEVANT_DROITE  (1) et
  //Deux points d'entrée à l'arrière : ENTREE_ARRIERE_GAUCHE (2) et ENTREE_ARRIERE_DROITE (3).
  void render(boolean devant) {
    
    //Affichage des animaux des points d'entée avants
    if (devant) {
      for (Animal animal : animauxShow) 
        if (animal.entree <= 1)
          animal.render();
    
    //Affichage des animaux des points d'entrée arrières
    } else {
      for (Animal animal : animauxShow) 
        if (animal.entree > 1)
          animal.render();
    }
  }
  
  //Fonction qui permet de déplacer un animal de la collection des animaux disponibles
  //vers la collection des animaux affichés.
  void apparitionAnimal() {
    
    Animal animalAjoute;
    
    //L'index de l'animal ajouté à la collection affichée est identifié aléatoirement
    int hasard = int(random(animauxDispos.size()));
    
    //Initialisation de l'animal à ajouter
    animalAjoute = animauxDispos.get(hasard);
    animalAjoute.timeNow = animalAjoute.timeLast = millis();
    animalAjoute.timelinePlayhead = 0.0f;
    
    //Ajout de l'animal à la liste des animaux affichés
    //et retrait de la liste des animaux disponibles.
    animauxShow.add(animalAjoute);
    animauxDispos.remove(hasard);
  }
}
