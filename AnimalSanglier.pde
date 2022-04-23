//Classe de type AnimalSanglier
//Elle hérite de la classe Animal.
class AnimalSanglier extends Animal {

  //Propriétés propre aux sangliers
  float angleMarche = 0.0;
  
  //Constructeur
  AnimalSanglier(int typeEntree) {
    //Appel du constructeur de la classe Animal.
    super(typeEntree);
    
    //Initialisation des propriétés audio-visuelles.
    image = imgSanglier;
    son = sonSanglier;
    
    //Décallage de l'image par rapport à la position de l'animal.
    decallageImage = 0.0f - image.height / 5;
  }
  
  //Fonction permettant de mettre à jour les propriétés du sanglier.
  void update() {
    //Mise à jour de la classe Animal.
    super.update();
    
    //Modification de la rotation par la marche du sanglier.
    rotation += sin(radians(angleMarche)) * 0.05f;
    angleMarche += radians(1000.0);
  }
  
  //Fonction permettant d'afficher le sanglier.
  void render() {
    super.render();
  }
}
