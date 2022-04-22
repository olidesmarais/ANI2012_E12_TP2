class Musique {
  
  SinOsc oscillateur;
  Env enveloppeMusique;
  final int[] notesMusique = {440, 494, 554, 494, 440, 494, 554, 494,
                              415, 440, 494, 440, 415, 440, 494, 440,
                              370, 415, 440, 415, 370, 415, 440, 415,
                              415, 440, 494, 440, 415, 440, 494, 440}; 
  
  int idxNote;
  float delaiMusique;
  float frequenceMusique;
  float delaiNote;
  final float longueurNote = 0.1f;
  boolean musiqueOn;
  
  //Gestion du temps
  float timeNow, timeLast, timeElapsed;
  
  Musique() {
    
    idxNote = 0;
    musiqueOn = true;
    frequenceMusique = 0.5f;
    
    //Gestion du temps
    timeNow = timeLast = millis();
    timeElapsed = 0.0f;
    
    //Musique
    idxNote = 0;
  }
  
  void update() {
    //Gestion du temps
    timeNow = millis();
    timeElapsed = (timeNow - timeLast) / 1000.0f;
    timeLast = timeNow;
      
    //Plus la profondeur du feuillage est grand, plus le tempo de la musique accélère.
    frequenceMusique = map(feuillage.depthCurrent, 1, feuillage.depthMax, 0.5, 0.1f);
    
    //Jouer la musique
    //La vitesse de la musique est directement proportionnelle avec le nombre
    //d'ennemis dans la collection d'ennemis
    //frequenceMusique = map(listeEnnemis.size(), 0, objectifDefaite, 0.2f, 0.1f);
    delaiMusique += timeElapsed;
    if (delaiMusique > frequenceMusique) {
      //Option pour inactiver le son (Touche 'm')
      if (musiqueOn)
        jouerMusique();
      delaiMusique -= frequenceMusique;
    }
  }
  
  //Fonction permettant la synthétisation de la musique ambiante pendant le jeu.
  void jouerMusique() {
    //Jouer la musique
    oscillateur.freq(notesMusique[idxNote]);
    oscillateur.play();
    enveloppeMusique.play(oscillateur, 0.01f, 0.004f, 0.3f, 0.4f);
    
    //Index de la prochaine note
    if (idxNote < notesMusique.length - 1)
      idxNote++;
    else
      idxNote = 0;
  }
}
