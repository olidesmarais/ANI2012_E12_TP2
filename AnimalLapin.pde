//Classe de type AnimalLapin
//Elle hérite de la classe Animal.

class AnimalLapin extends Animal {
  
  //Propriétés propre aux lapins
  float angleSaut = 0.0;
  float hauteurSautMax;
  
  //Constructeur
  AnimalLapin(int typeEntree) {
    //Appel du constructeur de la classe Animal.
    super(typeEntree);
    
    //Initialisation des propriétés audio-visuelles.
    image = imgLapin;
    son = sonLapin;
    
    //Initialisation de la hauteur des sauts si le lapin fait son entrée à l'avant du canevas.
    if (entree < 2)
      hauteurSautMax = 20.0f;
    //Initialisation de la hauteur des sauts si le lapin fait son entrée à l'arrère du canevas.
    else
      hauteurSautMax = 10.0f;
    
    //Décallage de l'image par rapport à la position de l'animal.
    decallageImage = 0.0f ;
  }
  
  //Fonction permettant de mettre à jour les propriétés du lapin.
  void update() {
    //Mise à jour de la classe Animal.
    super.update();
    
    //Modification de la position par le saut du lapin.
    position.y += sin(radians(angleSaut)) * hauteurSautMax;
    angleSaut += radians(1000.0);
  }
  
  //Fonction permettant d'afficher le lain.
  void render() {
    super.render();
  }
}
