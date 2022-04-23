//Classe de type AnimalRenard
//Elle hérite de la classe Animal.
class AnimalRenard extends Animal {
  
  //Propriétés propre aux renard
  float angleMarche = 0.0;
  
  //Constructeur
  AnimalRenard(int typeEntree) {
    //Appel du constructeur de la classe Animal.
    super(typeEntree);
    
    //Initialisation des propriétés audio-visuelles.
    image = imgRenard;
    son = sonRenard;
    
    //Décallage de l'image par rapport à la position de l'animal.
    decallageImage = 0.0f - image.height / 3;
  }
  
  //Fonction permettant de mettre à jour les propriétés du renard.
  void update() {
    //Mise à jour de la classe Animal.
    super.update();
    
    //Modification de la rotation par la marche du renard.
    rotation += sin(radians(angleMarche)) * 0.05f;
    angleMarche += radians(1000.0);
  }
  
  //Fonction permettant d'afficher le renard.
  void render() {
    super.render();
  }
}
