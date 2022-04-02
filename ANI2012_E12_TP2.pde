/* ANI-2021 - Programmation en animation
 * Hiver 2022
 * Travail pratique 2
 * Équipe 12 composée de :
   * Alexandre Doucet-Lagueux
   * Christophe Chalifour-Perutin
   * Julie Charbonneau
   * Maïlys Gaudin
   * Olivier Desmarais
 */
 
//Importations de la classe Sound afin de pouvoir jouer des sons
import processing.sound.*;

//Strcture canevas
final int dimensionX = 1020;
final int dimensionY = 720;

//Nombre de captures d'écran réalisées pendant l'exécution du programme
int idxCapture;

//Références
int centreX, centreY;
boolean pressed;

//Polices de caractère
PFont policeTitre, policeTexte, policeBouton;

//Structure du jeu
boolean debut, jeu, fin;
Bouton bCommencer;
Bouton bRejouer;
boolean termine;
boolean victoire;
SoundFile sonVictoire;
SoundFile sonDefaite;
PImage imgCanevas;
//Nombre d'ennemis à éliminer pour gagner
final int objectifVictoire = 30;
//Nombre maximal affiché à l'écran
final int objectifDefaite = 5;

//Environnement
PImage imgAccueil;
PImage imgPrincial_avantPlan, imgPrincial_planMedian, imgPrincial_arrierePlan;
//PImage cielJour, cielNuit;
//PImage cockpit;
final int hauteurCockpit = 242;
final int dimensionCadreFin = 400;
SoundFile sonClic;

/*//Slidder jour-nuit
boolean isJour;
Slider sliderJourNuit;*/

//Étoiles
SoundFile sonEtoile;
/*ArrayList<Etoile> listeEtoiles;
final float frequenceEtoiles = 1.0f;
float delaiEtoiles;
PImage[] etoilesRef;
//Taille du cercle pour attraper les étoiles
final int diametreAttraperEtoile = 50;*/

/*//Ennemis
ArrayList<Ennemi> listeEnnemis;
float delaiEnnemis;
final float frequenceEnnemis = 2.0f;
PImage[] imgEnnemis;
SoundFile sonEnnemi;*/

//Attaque
/*final float diametreAttaqueMax = 150;
int nbKills;
SoundFile sonAttaque;*/

//Jauge magie
/*Jauge jaugeMagie;
SoundFile sonManqueMagie;
boolean manqueMagie;*/

//Gestion du temps
float tempsEcoule, tempsCourant;

//Musique
SinOsc musique;
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

void settings() {
  size( dimensionX, dimensionY);
}

void setup() {
  
  frameRate(30);
  
  //Références
  idxCapture = 1;
  pressed = false;
  centreX = width / 2;
  centreY = height / 2;
  
  //Structure du jeu
  debut = true;
  jeu = false;
  fin = false;
  sonClic = new SoundFile(this, "audios/sonClic.wav");
  
  //Polices
  policeTitre  = loadFont("polices/Origicide-48.vlw");
  policeTexte  = loadFont("polices/AvenirLTStd-Book-48.vlw");
  policeBouton = loadFont("polices/AvenirLTStd-Heavy-48.vlw");
  
  //Début du jeu
  bCommencer = new Bouton (centreX, 525, 285, 85, false, "COMMENCER", 22);
  
  //Fin du jeu
  termine = false;
  imgCanevas = createImage(dimensionX, dimensionY, RGB);
  bRejouer = new Bouton (centreX, centreY + dimensionCadreFin / 3, 200, 50, true, "REJOUER", 15);
  sonVictoire = new SoundFile(this, "audios/victoire.aiff");
  sonDefaite = new SoundFile(this, "audios/sonDefaite.wav");
  
  //Environnement
  imgAccueil = loadImage("images/ACCEUIL.png");
  imgPrincial_avantPlan = loadImage("images/avantPlan.png");
  imgPrincial_planMedian = loadImage("images/planMedian.png");
  imgPrincial_arrierePlan = loadImage("images/arrierePlan.png");
  //cielJour = loadImage("images/CIEL_JOUR.png");
  //cielNuit = loadImage("images/CIEL_NUIT.png");
  //cockpit = loadImage("images/CABINE_M2.png");
  
  //Slider jour-nuit
  //sliderJourNuit = new Slider(698.0f, 547.0f);
  
  //Étoiles
  sonEtoile = new SoundFile(this, "audios/sonEtoileMono.mp3");
  //etoilesRef = new PImage[3];
  //etoilesRef[0] = loadImage("images/etoile/grande.png");
  //etoilesRef[1] = loadImage("images/etoile/petite.png");
  //etoilesRef[2] = loadImage("images/etoile/ronde.png");
  
  //Ennemis
  //genererImageEnnemi();
  //sonEnnemi = new SoundFile(this, "audios/Grunt2.wav");
  
  //Attaque
  //sonAttaque = new SoundFile(this, "audios/sonAttaque.mp3");
  //sonAttaque.amp(0.1f);
  
  //Jauge magie
  //jaugeMagie = new Jauge(283, 518, 175, 30, 100, 1.0f, color(255, 255, 0, 255), color(4, 51, 83, 255));
  //sonManqueMagie = new SoundFile(this, "audios/SonManqueMagie.wav");
  //sonManqueMagie.amp(0.1f);
    
  //Musique
  musique = new SinOsc(this);
  enveloppeMusique = new Env(this);
  musique.amp(0.2f);
  idxNote = 0;
  musiqueOn = true;
  frequenceMusique = 0.5f;
}

void draw() {
  //Écran d'accueil
  if (debut) {
    afficherAccueil();
  }
  
  //Déroulement du jeu
  if(jeu) {    
    //Écran principal
    afficherJeu();

    //Gestion du temps
    tempsEcoule = (millis() - tempsCourant) / 1000.0f;
    //delaiEtoiles += tempsEcoule;
    //delaiEnnemis += tempsEcoule;
    delaiMusique += tempsEcoule;
    tempsCourant = millis();
    
    //Slider jour-nuit
    //sliderJourNuit.update();
    
    //Jauge magie
    //jaugeMagie.update();
    
    //Étoiles
    //Mécanisme d'ajout d'étoiles à fréquence régulière
    /*if (delaiEtoiles > frequenceEtoiles) {
      ajouterEtoile();
      delaiEtoiles -= frequenceEtoiles;
    }
    //Si c'est le na nuit et que la souris est pressée, 
    //le mode permettant d'attraper des étoiles s'active.
    if (!isJour && pressed) {
      attraperEtoiles();
    }*/
      
    //Ennemis
    //Mémanisme d'ajout d'ennemis à intervalle régulier
    /*if (delaiEnnemis > frequenceEnnemis) {
      ajouterEnnemi();
      delaiEnnemis -= frequenceEnnemis;
    }*/
    //Mise à jour en temps réel du niveau de vie des ennemis
    //avec mise à jour de l'affichage et de la collection d'ennemis
    //en conséquence
    //updateEnnemis();
      
    //Jouer la musique
    //La vitesse de la musique est directement proportionnelle avec le nombre
    //d'ennemis dans la collection d'ennemis
    //frequenceMusique = map(listeEnnemis.size(), 0, objectifDefaite, 0.2f, 0.1f);
    if (delaiMusique > frequenceMusique) {
      //Option pour inactiver le son (Touche 'm')
      if (musiqueOn)
        jouerMusique();
      delaiMusique -= frequenceMusique;
    }
    
    /*//Fin du jeu
    //Le jeu prend fin si le nombre fixé comme objectif est atteint
    if (nbKills >= objectifVictoire || listeEnnemis.size() >= objectifDefaite) {
      termine = true;
      //VICTOIRE : Le nombre d'ennemis éléminé atteint l'objectifVictoire (30)
      //L'invasion des ennemis est empêchée.
      if (nbKills >= objectifVictoire) {
        victoire = true;
        sonVictoire.play();
      //DÉFAITE : Le nombre d'ennemis à l'écran a atteint l'objectifDefaite (5)
      //L'invasion des ennemis est une réussite.
      } else {
        victoire = false;
        sonDefaite.play();
      }
    }*/
    //La fonction transitionFin() est appelée une seule fois au moment de l'atteinte
    //de l'objectif. En plus d'arrêter la musique et de passer en mode "fin"
    //elle permet d'afficher l'arrière plan de l'écran de fin. Cette étape étant
    //exigeante pour le programme, elle n'est exécutée qu'une seule fois pour
    //éviter de ralentir son exécution.
    if (termine) {
      transitionFin();
    }
  }

  //Écran de fin
  if (fin) {
    afficherFin();
  }
}

void mousePressed() {
  //À quelques endroits dans le programme, il est vérifié si la souris est pressée.
  //Cette variable est notée dans le boolean "pressed".
  pressed = true;
}

void mouseReleased() {
  //Pendant le jeu :
  //Il est vérifié si le relâchement de la souris est une tentative d'attaque.
  //Si oui et le niveau de magie le permet, l'attaque a bien lieu. Sinon, une
  //rétroaction informe le joueur du manque de magie par un son et le cadre de
  //la jauge de magie qui change au rouge.
  if (jeu){
    /*if (isJour) {
      if(mouseY < height - hauteurCockpit) {
        if (jaugeMagie.niveau >= 10)
          attaquer();
        else {
          sonManqueMagie.play();
          jaugeMagie.couleurContour = color(255, 0, 0, 255);
        }
      }
    }*/
  }
  
  //Pendant le début :
  //Il est vérifié si le relâchement de la souris démontre le désir de cliquer
  //sur le bouton commencer.
  if (debut) {
    if (bCommencer.verifierSuperposition()) {
      clicBouton();
    }
  }

  //Pendant la fin :
  //Il est vérifié si le relâchement de la souris démontre le désir de cliquer
  //sur le bouton rejouer.
  if (fin) {
    if (bRejouer.verifierSuperposition()) {
      clicBouton();
    }
  }
  
  //La souris n'est plus pressée
  pressed = false;
}

void keyReleased() {
  //Raccourci pour le slider jour-nuit (ESPACE)
  if (key == ' ') {
    /*if (isJour)
      sliderJourNuit.deplacement('n');
    else
      sliderJourNuit.deplacement('j');*/
  }
  
  //Raccourci pour cliquer sur un bouton (ENTER)
  if (keyCode == ENTER) {
    clicBouton();
  }
  
  //Touche pour activer/inactiver la musique ('m')
  if (key == 'm')
    musiqueOn = !musiqueOn;
  
  //Touche pour réaliser une capture d'écran ('p')
  if (key == 'p') {
    save("captures/capture" + nf(idxCapture, 2) + ".png");
    idxCapture++;
  }
}

//Fonction appelée au début de chaque partie pour initialiser toutes les valeurs
//à leur état initial
void initialisation() {
  
  //Toggle jour-nuit 
  //isJour = true;
  
  //Étoiles
  //listerEtoiles();
  //delaiEtoiles = 0.0f;
  
  //Ennemis
  //listerEnnemis();
  //delaiEnnemis = 0.0f;
  
  //Jauge pouvoir
  /*jaugeMagie.niveau = 100;
  jaugeMagie.niveauCourant = 100;
  jaugeMagie.couleurContour = color(4, 51, 83, 255);
  nbKills = 0;*/
 
  //Gestion du temps
  tempsEcoule = 0.0f;
  tempsCourant = 0.0f;
  tempsCourant = millis();
  
  //Musique
  idxNote = 0;
  jouerMusique();  
}

void afficherAccueil() {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  //Background de l'écran d'accueil
  imageMode(CORNER);
  image(imgAccueil, 0, 0);

  //Affichage du titre
  textAlign(CENTER, CENTER);
  fill(255, 255, 0);
  textFont(policeTitre, 120);
  text("STARCATCH", centreX, 200);
  
  //Affichage des instructions
  fill(255);
  textFont(policeTexte, 18);
  String[] lignesTexte = new String[5];
  lignesTexte[0] = "Tentez de vaincre les envahisseurs en cliquant sur eux";
  lignesTexte[1] = "avant qu'ils soient trop nombeux ! Afin d'avoir assez";
  lignesTexte[2] = "de magie pour attaquer, alternez entre le jour et la nuit et";
  lignesTexte[3] = "attrapez des étoiles. Il faut cependant faire vite, car ces";
  lignesTexte[4] = "extra-terresetres se multiplient à la vitesse de la lumières !";
  //Emplacement de chacune des lignes
  float posY = 325;  
  int hauteurLigne = 20;
  //Affichage de chacune des lignes
  for (int ligne = 0 ; ligne < lignesTexte.length ; ligne++) {
    text(lignesTexte[ligne], centreX, posY);
    posY += hauteurLigne;
  }
  
  //Afficage du bouton pour commencer
  bCommencer.render();
}

void afficherJeu() {
  imageMode(CORNER);
  
  image(imgPrincial_arrierePlan, 0, 0, dimensionX, dimensionY);
  image(imgPrincial_planMedian, 0, 0, dimensionX, dimensionY);
  image(imgPrincial_avantPlan, 0, 0, dimensionX, dimensionY);
  
  /*//Le jour : afficher le background et les ennemis
  if(isJour) {
    image(cielJour, 0, 0);
    afficherEnnemis();
  //La nuit : afficher le background et les étoiles
  } else {
    image(cielNuit, 0, 0);
    afficherEtoiles();
  }
  
  //Afficher le cockpit
  afficherCockpit();*/
}

void afficherFin() {
  //L'arrière-plan de l'écran de fin est affiché dans la fonction transitionFin().
  //Il s'agit d'une copie du caneva au moment où le jeu prend fin. Cette image est
  //ensuite floutée puis affichée.
  
  //Afficher le cadre de fond
  rectMode(CENTER);
  stroke(4,51,83,255);
  strokeWeight(10);
  fill(255);
  rect(centreX, centreY, dimensionCadreFin, dimensionCadreFin);
  
  //Afficher le texte
  textAlign(CENTER, CENTER);
  fill(0);
  //Dans le cas d'une victoire, le nombre d'ennemis éléminés est indiqué.
  if (victoire) {
    textFont(policeTitre, 50);
    fill(0, 255, 0);
    text("Victoire !", centreX, centreY - dimensionCadreFin / 3);
    //text("Victoire !!!", centreX, centreY - dimensionCadreFin / 3);
    
    fill(0);
    textFont(policeTexte, 18);
    //text("Nombre de kills : " + nbKills, centreX, centreY);
  //Dans le cas d'une défaite, le nombre d'ennemis à l'écran est indiqué.
  } else {
    textFont(policeTitre, 30);
    fill(255, 0, 0);
    text("Vous n'avez pas \n pu prévenir l'invasion ...", centreX, centreY - dimensionCadreFin / 3);
    
    fill(0);
    textFont(policeTexte, 18);
    //text("Nombre de kills : " + nbKills, centreX, centreY);
  }
  
  //Affichage du bouton pour rejouer
  bRejouer.render();
}

//Lorsqu'un ennemi est ajouté à la collection d'ennemis, un feedback est transmis au joueur
//en colorant l'écran de la couleur 
void teinterEcran() {
  //Copie de l'écran actuel  
  PImage ecran = get (0, 0, dimensionX, dimensionY);
  //Affichage de l'écran avec une teinte rouge
  tint(255, 0, 0, 255);
  imageMode(CORNER);
  image(ecran, 0, 0);
  
  //Rétablissement de la teinte
  tint(255, 255);
}

/*void afficherCockpit() {
  //Affichage de l'image du cockpit
  imageMode(CORNER);
  image(cockpit, 0, 0);
 
  //Affichage des outils
  afficherRadar();
  sliderJourNuit.render();
  jaugeMagie.render();
}*/

/*void afficherRadar() {
  //Position du radar
  PVector posRadar = new PVector(455, 505);
  int hRadar = 100;
  int wRadar = 145;
  //Références minimales et maximales de coordonnées X et Y des ennemis
  PVector posEnnemisMin = new PVector (0 - 400 / 2, 0 - 400 / 2);
  PVector posEnnemisMax = new PVector (dimensionX - 400 / 2, dimensionY - hauteurCockpit - 400 / 2);
  
  //Déterminer l'emplacement et afficher les ennemis sur le radar 
  float posRelativeX, posRelativeY, dimensionRelative;
  for (int idx = 0 ; idx < listeEnnemis.size() ; idx++) {
    //Déterminer la position des ennemis sur le radar
    posRelativeX = map(listeEnnemis.get(idx).position.x, posEnnemisMin.x, posEnnemisMax.x, posRadar.x, posRadar.x + wRadar);
    posRelativeY = map(listeEnnemis.get(idx).position.y, posEnnemisMin.y, posEnnemisMax.y, posRadar.y, posRadar.y + hRadar);
    dimensionRelative = map(listeEnnemis.get(idx).dimension, 200, 400, 5, 10);
    
    //Affichage du triangle
    fill(255, 0, 0);
    noStroke();
    triangle(
      posRelativeX + dimensionRelative / 2, posRelativeY, 
      posRelativeX, posRelativeY + dimensionRelative,
      posRelativeX + dimensionRelative, posRelativeY + dimensionRelative
    );
  }
  //Nombre d'ennemis au centre du radar
  fill(255);
  textFont(policeTexte, 10);
  text(listeEnnemis.size(), 540, 579);
}*/

//Fonction permettant de créer la collection d'étoile à l'initialisation du jeu.
//Un nombre aléatoile d'étoiles (entre 1 et 9) est ajouté à la collection.
/*void listerEtoiles() {
  int nbEtoiles = int(random(1, 10));
  listeEtoiles = new ArrayList<Etoile>();

  for (int idx = 0; idx < nbEtoiles ; idx++) {
    //Instanciation de l'objet étoile
    Etoile etoile = new Etoile();
    //Ajout à la collection d'étoiles
    listeEtoiles.add(etoile);
  }
}*/

//Fonction permettant d'afficher toutes les étoiles de la collection
/*void afficherEtoiles() { 
  for (int idx = 0; idx < listeEtoiles.size() ; idx++) {
    listeEtoiles.get(idx).render();
  }
}*/

//Fonction ajoutant une étoile à la collection 
/*void ajouterEtoile() {
  if (listeEtoiles.size() < 20) {
    Etoile etoile = new Etoile();
    listeEtoiles.add(etoile);
  }
}*/

//Fonction enclenchée lorsque la souris est enfoncée dans le ciel pendant la nuit.
/*void attraperEtoiles() {
  //Afficher le cercle qui permet d'attraper les étoiles
  fill(255, 100);
  noStroke();
  if (mouseY < height - hauteurCockpit)
    ellipse(mouseX, mouseY, diametreAttraperEtoile, diametreAttraperEtoile);
  
  //Vérifier le contact entre ce cercle et les étoiles dans le ciel
  for (int idx = 0 ; idx < listeEtoiles.size() ; idx++) {    
    
    //Lorsque qu'une étoile est attrapée :
    if (listeEtoiles.get(idx).verifierSuperposition()) {
      //La puissance de l'étoile est ajoutée au niveau de magie
      jaugeMagie.niveau += listeEtoiles.get(idx).puissance;
      if (jaugeMagie.niveau > 100)
        jaugeMagie.niveau = 100;
      //L'étoile est retirée de la collection
      listeEtoiles.remove(idx);
      //Son de l'étoile, joué en panoramique
      if (mouseX >= 0 && mouseX <= dimensionX)
        sonEtoile.pan(map(mouseX, 0, width, -1, 1));
      else if (mouseX < 0)
        sonEtoile.pan(-1);
      else
        sonEtoile.pan(1);
      sonEtoile.play();
    }
  }
}*/

//Fonction appelée au lancement du programme pour générer les images de 
//la séquence d'images des ennemis. Pour les 6 frame, l'images et le masques sont accédés,
//le masque est appliqué à l'image et l'image est stockée.
/*void genererImageEnnemi() {
  //Nom des fichiers
  String emplaImage = "images/ennemi/alien";
  String emplaMasque = "images/ennemi/masque";
  
  //Stockage des images de chacun des frames avec masque
  imgEnnemis = new PImage[6]; 

  //Variable utilisée locales pour effectuer les manipuations
  PImage image;
  PImage masque;
  
  for (int idx = 0 ; idx < 6 ; idx++) {
    //Accès aux fichiers
    image = loadImage(emplaImage + nf(idx + 1, 2) + ".png");
    masque = loadImage(emplaMasque + nf(idx + 1, 2) + ".png");
    
    //Création de l'image, copie et masquage
    imgEnnemis[idx] = createImage(400, 400, ARGB);
    imgEnnemis[idx] = image;
    imgEnnemis[idx].mask(masque);
  }
}*/

//Fonction permettant de créer la collection d'ennemis à l'initialisation du jeu.
//Un nombre aléatoile d'ennemis (entre 1 et 3) est ajouté à la collection.
/*void listerEnnemis() {
  int nbEnnemis = int(random(1, 4));
  listeEnnemis = new ArrayList<Ennemi>();

  for (int idx = 0; idx < nbEnnemis ; idx++) {
    //Instanciation de la classe Ennemi
    Ennemi ennemi = new Ennemi();
    //Ajout à la collection
    listeEnnemis.add(ennemi);
  }
}*/

//Fonction permettant d'afficher les ennemis de la collection
/*void afficherEnnemis() { 
  for (int idx = 0; idx < listeEnnemis.size() ; idx++) {
    listeEnnemis.get(idx).render();
  }
}*/

//Fonction permettant d'ajouter un ennemi à la collection
/*void ajouterEnnemi() {
  //Instanciation de l'objet Ennemi
  Ennemi ennemi = new Ennemi();
  //Ajout à la collection
  listeEnnemis.add(ennemi);

  //Feedback au joueur
  teinterEcran();
}*/

//Fonction permettant la mise à jour en temps réel de la collection d'ennemis. 
/*void updateEnnemis() {
  for (int idx = 0 ; idx < listeEnnemis.size() ; idx++) {
    //Mise à jour de la jauge de vie de chacun des ennemis
    listeEnnemis.get(idx).jaugeVie.update();
    //Mise à jour lorsque l'ennemi n'a plus de vie
    if (listeEnnemis.get(idx).jaugeVie.niveauCourant <= 0) {
      sonEnnemi.play();
      listeEnnemis.remove(idx);
      nbKills++;
    }
  }
}*/

//Fonction enclenchée lorsqu'une tentative d'attaque est faite alors que le niveau
//de magie permet une attaque.
/*void attaquer() {
  //Emplacement de l'attaque
  PVector position = new PVector(mouseX, mouseY);
  
  //Visuel de l'attaque
  ellipseMode(CENTER);
  noStroke();
  float diametre = 25.0f;
  float opacite = 255.0f;
  while (diametre < diametreAttaqueMax) {
    fill(255, opacite);
    ellipse(position.x, position.y, diametre, diametre);
    diametre += 25;
    opacite -= 50;
  }
  
  //Son
  sonAttaque.play();
  
  //Jauge magie
  jaugeMagie.niveau -= 10;
  
  //Vérifier les contacts avec chacun de ennemis de la collection
  for (int idx = 0 ; idx < listeEnnemis.size(); idx++)
    listeEnnemis.get(idx).verifierDegats(position.x, position.y);
}*/

//Fonction permettant la synthétisation de la musique ambiante pendant le jeu.
void jouerMusique() {
  //Jouer la musique
  musique.freq(notesMusique[idxNote]);
  musique.play();
  enveloppeMusique.play(musique, 0.01f, 0.004f, 0.3f, 0.4f);
  
  //Index de la prochaine note
  if (idxNote < notesMusique.length - 1)
    idxNote++;
  else
    idxNote = 0;
}

//Fonction enclenchée lorsque l'objectif du jeu est atteint.
//Quelques étapes sont suivis dans le passage du jeu vers la fin. 
void transitionFin() {
  //Arrêt de la musique
  musique.stop();
  
  //Capture du canevas au moment où l'objectif est atteint.
  imgCanevas = get(0, 0, dimensionX, dimensionY);
  
  //Transition vers la fin du jeu.
  termine = false;
  jeu = false;
  fin = true;
  
  //Afficher de l'arrière-plan de l'écran de fin.
  imageMode(CORNER);
  imgCanevas.filter(BLUR, 10);
  image(imgCanevas, 0, 0);
}

//Fonction appelée lorsque le bouton "commencer" est appuyé
void clicBouton() {
  //Initialisation de la partie
  initialisation();
  
  //Transition du début/de la fin du jeu vers le jeu
  jeu = true;
  debut = false;
  fin = false;
  
  //Son du bouton
  sonClic.play();
}
