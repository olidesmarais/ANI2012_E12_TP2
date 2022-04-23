//Classe de type AnimalOrignal
//Elle hérite de la classe Animal.
class AnimalOrignal extends Animal {
  
  //Propriétés propre aux orignaux
  float angleMarche = 0.0;
  
  //Constructeur
  AnimalOrignal(int typeEntree) {
    //Appel du constructeur de la classe Animal.
    super(typeEntree);
    
    //Initialisation des propriétés audio-visuelles.
    image = imgOrignal;
    son = sonOrignal;
    
    //Décallage de l'image par rapport à la position de l'animal.
    decallageImage = 0.0f - image.height / 5;
  }
  
  //Fonction permettant de mettre à jour les propriétés de l'orignal.
  void update() {
    //Mise à jour de la classe Animal.
    super.update();
    
    //Modification de la rotation par la marche de l'orignal.
    rotation += sin(radians(angleMarche)) * 0.1f;
    angleMarche += radians(250.0);
  }
  
  //Fonction permettant d'afficher l'orignal.
  void render() {
    super.render();
  }
}
