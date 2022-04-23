//Classe permettant de gérer la collection des instances de la classe Animal.

class Animaux{
  
  AnimationClip[] clipAnimaux;
  ArrayList<Animal> animauxShow, animauxDispos;
  Iterator<Animal> iterateur;
  Animal animal;
  
  Animaux() {
    animauxShow = new ArrayList<Animal>();
    animauxDispos = new ArrayList<Animal>();
    
    //Ajouter un animal de chaque espece dans la liste d'animaux disponibles
    //pour chaque disposition d'entrée.
    for (int entree = 0 ; entree < Animal.NB_ENTREES ; entree++) {
      animauxDispos.add(new AnimalLapin(entree));
      animauxDispos.add(new AnimalOrignal(entree));
      animauxDispos.add(new AnimalRenard(entree));
      animauxDispos.add(new AnimalSanglier(entree));
    }
    
    clipAnimaux = new AnimationClip[4];
    String[] tabCourbeAnimaux = {"positionX", "positionY", "rotation"};
    clipAnimaux[Animal.ENTREE_DEVANT_GAUCHE] = new AnimationClip(tabCourbeAnimaux);
    clipAnimaux[Animal.ENTREE_DEVANT_DROITE] = new AnimationClip(tabCourbeAnimaux);
    clipAnimaux[Animal.ENTREE_ARRIERE_GAUCHE] = new AnimationClip(tabCourbeAnimaux);
    clipAnimaux[Animal.ENTREE_ARRIERE_DROITE] = new AnimationClip(tabCourbeAnimaux);
  }
  
  void update() {
    
    iterateur = animauxShow.iterator();

    //Itérateur pour traverser toutes les instances de la classe Animal
    //dans la liste d'animaux affichés.
    while (iterateur.hasNext())
    {
      animal = iterateur.next();
    
      animal.timeNow = millis();
      animal.timeElapsed = (animal.timeNow - animal.timeLast) / 1000.0f;
      animal.timeLast = animal.timeNow;
      
      animal.timelinePlayhead += animal.timeElapsed;
      
      if (animal.timelinePlayhead >= animal.timelineDuration) {
        animauxDispos.add(animal);
        iterateur.remove();
       
        //show = false;
      } else {
        animal.update();
      }
    }
    /*for (Animal animal : animauxDispos)
      animal.update();*/
    
  }
  
  
  //Les animaux ont 4 points d'entrée dans le canevas dont
  //Points d'entrée à l'avant   : ENTREE_DEVANT_GAUCHE  (0) et ENTREE_DEVANT_DROITE  (1)
  //Points d'entrée à l'arrière : ENTREE_ARRIERE_GAUCHE (2) et ENTREE_ARRIERE_DROITE (3).
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
  
  //Fonction qui permet de déplacer un animal de la liste des animaux disponibles
  //vers la liste des animaux affichés.
  void apparitionAnimal() {
    
    Animal animalAjoute;
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
  
  void ajouterPosesCles() {
    
  }
}
