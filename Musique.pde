//Classe de type musique
//Cette classe est responsable de la gestion de la mélodie synthétisée
//pendant l'exécution du programme à l'écran principal.
class Musique {
  //Joueur la musique
  SinOsc oscillateur;
  Env enveloppeMusique;
  
  //Les notes de musique jouées par le synthétiseur
  final int[] notesMusique = {440, 494, 554, 494, 440, 494, 554, 494,
                              415, 440, 494, 440, 415, 440, 494, 440,
                              370, 415, 440, 415, 370, 415, 440, 415,
                              415, 440, 494, 440, 415, 440, 494, 440}; 
  
  //Gestion de la musique
  int idxNote;
  float delaiMusique;
  float frequenceMusique;
  float delaiNote;
  final float longueurNote = 0.1f;
  boolean musiqueOn;
  
  //Gestion du temps
  float timeNow, timeLast, timeElapsed;
  
  //Constructeur
  Musique() {
    //Gestion du temps
    timeNow = timeLast = millis();
    timeElapsed = 0.0f;
    
    //Gestion de la musique
    idxNote = 0;
    idxNote = 0;
    musiqueOn = true;
    frequenceMusique = 0.5f;
  }
  
  //Fonction responsable de la mise à jour de la musique
  void update() {
    //Gestion du temps
    timeNow = millis();
    timeElapsed = (timeNow - timeLast) / 1000.0f;
    timeLast = timeNow;
      
    //Plus la profondeur du feuillage est grand, plus le tempo de la musique accélère.
    
    
    //Jouer la musique
    //La vitesse de la musique est directement proportionnelle avec la profondeur
    //du système de Lindenmayer de la classe Feuillage    
    frequenceMusique = map(feuillage.depthCurrent, 1, feuillage.depthMax, 0.5, 0.1f);
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
    //oscillateur.play();
    enveloppeMusique.play(oscillateur, 0.01f, 0.004f, 0.3f, 0.4f);
    
    //Index de la prochaine note
    if (idxNote < notesMusique.length - 1)
      idxNote++;
    else
      idxNote = 0;
  }
}
