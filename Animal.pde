class Animal {
  
  int disposition;
  
  Animal() {
    
    disposition = determinerDisposition();
  }
  
  //Fonction qui retourne la disposition de l'animal, en fonction de s'il
  //0 - Arrive de l'avant à gauche
  //1 - Arrive de l'avant à droite
  //2 - Arrive de l'arrière à gauche
  //3 - Arrive de l'arrière à droite
  int determinerDisposition() {
    //int position;
    int hasardProdondeur = int(random(2));
    int hasardGD = int(random(2));
    boolean devant, gauche;
    
    if (hasardProdondeur == 1)
      devant = true;
    else
      devant = false;
      
    if (hasardGD == 1)
      gauche = true;
    else
      gauche = false;
      
    if (devant && gauche)
      return 0;
    else if (devant)
      return 1;
    else if (gauche)
      return 2;
    else
      return 3;
  }
}
