//Classe de type Fee

class Fee {
  //Type de fée, influançant sa couleur.
  final static int FEE_TYPE_BLEU  = 0;
  final static int FEE_TYPE_ROSE  = 1;
  final static int FEE_TYPE_JAUNE = 2;
  
  //Propriétés de la fée
  Vector3D position = new Vector3D();
  int dimension;
  int type;
  boolean attrapee;
  
  //Propriétés audio-visuelles
  PImage imgFond;
  PImage[] tabImages;
  int idxImageCourante;
  int couleurTeinte;

  //Transformation
  //Rotation
  float angleRotation;
  //Translation
  Vector3D translationMax;
  Vector3D translationCourante;
  Vector3D angleTranslation;
  float deltaAngleTranslation;
  
  //Gestion du temps et animation
  float timeLast, timeNow, timeElapsed;
  float timelinePlayhead, timelineDuration;
  float delaiRire, frequenceRire;
  
  //Constructeur
  Fee() {
    //Initialisation pseudo-aléatoire des propriétés de transformation de la fée
    angleTranslation = new Vector3D( 0.0f, 0.0f, 0.0f);
    translationMax = new Vector3D( random(25.0f, 100.0f), random(5.0, 50.0f), 0.0f);
    translationCourante = new Vector3D(random(360), random(360), 0.0f);
    deltaAngleTranslation = random(2, 8);
    
    //Une fois sur deux, son déplacement se fait dans le sens inverse.
    float hasard = random(1);
    if (hasard >= 5.0f)
      deltaAngleTranslation *= -1;
    
    //Position déterminée aléatoirement, dans le bas de l'écran.
    position.set(random(200, width - 200), random(500, height - 200.0), 0);
    
    //Détermination du type de fée de façon aléatoire.
    type = int(random(3));
    
    //Initialisation des propriétés audio-visuelles de la fée.
    dimension = int(random(80.0f, 120.0f));
    tabImages = new PImage[3];
    idxImageCourante = int(random(2));
    //Propriétés dépendantes du type.
    switch(type) {
      case FEE_TYPE_BLEU :
        definirLesImages(feeRefBleu);
        couleurTeinte = color(24,124,254,255);
        break;
      case FEE_TYPE_ROSE :
        definirLesImages(feeRefRose);
        couleurTeinte = color(255,71,138,255);
        break;
      case FEE_TYPE_JAUNE :
        definirLesImages(feeRefJaune);
        couleurTeinte = color(255,239,48,255);
        break;
    }
    imgFond = createImage(dimension, dimension, ARGB);
    imgFond.copy(feeRefFond, 0, 0, feeRefFond.width, feeRefFond.height, 0, 0, dimension, dimension);
    
    //Initialement, la fée n'est pas attrapée et ne subit pas de rotation.
    attrapee = false;
    angleRotation = 0.0f;
    
    //Animation
    timelinePlayhead = 0.0f;
    timelineDuration = 1.0f;
    delaiRire = 0.0f;
    frequenceRire = determinerFrequenceRire();
  }
  
  //Fonction permettant de mettre à jour les propriétés de la fée.
  //La fée possède une position fixe dans le canevas, mais virevolte grâce à une translation en X et Y
  //appliquée pour déterminer sa position courante au moment de l'afficher. La position absolue de la
  //fée n'est modifiée que lorsque la fée est attrapée par la baguette de l'utilisateur.
  void update() {
    
    //Si la fée est attrapée :
    if (attrapee) {
      //Sa position devient celle de la pointe de la baguette, en conservant la translation courante.
      position.set(pointeBaguette.x - translationCourante.x, pointeBaguette.y - translationCourante.y, 0.0f);
      //Le battement d'ailes s'interrompt
      idxImageCourante = 0;
       
      //Le temps commence à être monitoré pour l'animation de rotation et du rire
      timeNow = millis();
      timeElapsed = (timeNow - timeLast) / 1000.0f;
      timeLast = timeNow;
      
      //Une rotation périodique est appliquée à la fée. Cette rotation déterminée par
      //interpolation en fonction des poses de sa courbe d'animation.
      timelinePlayhead += timeElapsed;
      if (timelinePlayhead >= timelineDuration)
        timelinePlayhead -= timelineDuration;
      sequencer.update("clipFee", 0, timelinePlayhead);
      angleRotation = sequencer.rotationFee;
      
      //Le rire de la fait se fait entendre suite à un moment variable après l'avoir attrappée,
      //si un animal est disponible pour apparaître. Lorsque la fée rit, elle se libère de l'emprise
      //de la baguette et un animal apparaît quelque part dans la scène.
      if (gestionAnimaux.animauxDispos.size() > 0) {
        delaiRire += timeElapsed;
        if (delaiRire >= frequenceRire) {
          sonFee.play();
          delaiRire -= delaiRire;
          frequenceRire = determinerFrequenceRire();
          gestionAnimaux.apparitionAnimal();
          attrapee = false;
        }
      }
      
    //Si la fée n'est pas attrapée :
    } else {
      //la translation courante et le battement d'ailes se poursuivent.
      translationCourante.copy(translationFee());
      angleRotation = 0.0f;
      idxImageCourante = (idxImageCourante + 1) % 3;
    }
  }
  
  //Fonction permettant d'afficher la fée.
  void render() {

    imageMode(CENTER);
    
    //Modification du système de coordonnées pour l'affichage de la fée.
    pushMatrix();
    
    //Déplacement du système de coordonnées à la position de la fée.
    translate(position.x, position.y);
    
    //Application de des translation et rotation courantes.
    translate(translationCourante.x, translationCourante.y);
    rotate(angleRotation);
    
    //Redimension de l'image de fond de la fée
    pushMatrix();
    scale(proportionFond());

    //Coloration et affichage de l'arrière-plan de la fée.
    tint(couleurTeinte);
    image(imgFond, 0, 0);
    tint(255, 255);

    popMatrix();
    
    //Affichage de la fée. 
    //Une transparence est appliquée à son image s'il s'agit du moment
    //où ses ailes sont déployées au maximum vers l'avant (idx == 1);
    if (idxImageCourante == 1) {
      tint(255, 100);
      image(tabImages[idxImageCourante], 15, -15);
      tint(255, 255);
    } else {
      image(tabImages[idxImageCourante], 15, -15);
    }

    popMatrix();
  }
  
  //Fonction permettant de vérifier si l'utilisateur clique sur la fée avec sa baguette.
  boolean verifierSuperposition() {    

    Vector3D coinImgActuelActuel = new Vector3D();
    Vector3D positionRelative = new Vector3D();
    
    //Déterminer la position du coin supérieur droit de l'image de la fée.
    coinImgActuelActuel.copy(determinerCoinImgActuel());
    
    //Déterminer la position relative de la pointe de la baguette sur l'image
    positionRelative.set( pointeBaguette.x - coinImgActuelActuel.x, pointeBaguette.y - coinImgActuelActuel.y, 0.0f);
    
    //Vérifier si la pointe de la baguette est dans le cadre de l'image
    if (positionRelative.x >= 0 && positionRelative.x <= dimension && positionRelative.y >= 0 && positionRelative.y <= dimension) {      
      
      //Index du pixel de l'image touché
      int idxPixel = dimension * int(positionRelative.y) + int(positionRelative.x);
      
      //Charger l'image actuelle
      tabImages[idxImageCourante].loadPixels();
      
      //Si le pixel est dans le cadre de l'image
      if (idxPixel >= 0 && idxPixel < tabImages[idxImageCourante].pixels.length) {
        
        //On considère qu'il y a un contact si le pixel concerné n'est pas 
        //complètement transparent
        if (alpha(tabImages[idxImageCourante].pixels[idxPixel]) > alpha(0) ) {
          return true;
        } else
          return false;
      }
    }
    return false;
  }
  
  //Fonction régulant la redimension de l'arrière-plan de la fée.
  //La taille de l'arrière-plan de la fée est directement proportionnel à la translation courante
  //de la fée sur l'axe des absisse.
  float proportionFond() {
    //Déterminer la proportion courante
    float proportion;
    proportion = 0.5f + sin(radians(angleTranslation.y)) * 0.3f;
    
    //Retour de la valeur de proportion calculée
    return proportion;
  }
  
  //Fonction régulant la translation de la fée
  Vector3D translationFee() {
    //Déterminer les translation courante.
    Vector3D translationCourante = new Vector3D( sin(radians(angleTranslation.x)) * translationMax.x, sin(radians(angleTranslation.y)) * translationMax.y, 0.0f);
    
    //Mise à jour des angles régulant la variation de la translation courante la translation.
    angleTranslation.x = (angleTranslation.x + deltaAngleTranslation) % 360;
    angleTranslation.y = (angleTranslation.y + 2 * deltaAngleTranslation) % 360;
    
    //Retourner la translation courante.
    return translationCourante;
  }
  
  //Fonction retournant un Vector3D dont les propriétés indiquent la position courante de la fée, avec application de la translation courante.
  Vector3D determinerPositioActuelle() {
    Vector3D positionActuelle = new Vector3D( position.x + translationCourante.x, position.y + translationCourante.y, 0.0f);
    return positionActuelle;
  }
  
  //Fonction déterminant et retournant la position correspondant au coin supérieur droit de l'image de référence.
  Vector3D determinerCoinImgActuel() {
    Vector3D positionActuelle = new Vector3D();
    Vector3D coinActuel = new Vector3D();
    
    //Déterminer la position courante de la fée, avec l'effet de translation
    positionActuelle.copy(determinerPositioActuelle());
    
    //Déterminer et retourner l'emplacement du coin de l'image
    coinActuel.set(positionActuelle.x - tabImages[idxImageCourante].width / 2, positionActuelle.y - tabImages[idxImageCourante].height / 2, 0);
    
    return coinActuel;
  }
  
  
  //Fonction permettant de copier les images de fée de référence en fonction de la couleur appropriée dans le tableau d'image 
  //de l'instance de fée. La taille de ces images est adaptée en fonction de la dimension de la fée.
  void definirLesImages(PImage[] tabImgRef) {
    for (int idx = 0 ; idx < 3 ; idx++) {
      tabImages[idx] = createImage(dimension, dimension, ARGB);
      tabImages[idx].copy(tabImgRef[idx], 0, 0, tabImgRef[idx].width, tabImgRef[idx].height, 0, 0, dimension, dimension);
    }
    
  }
  
  //Fonction permettant de déterminer la durée d'attente entre le moment où l'utilisateur attrape
  //une fée et le moment où elle rit.
  float determinerFrequenceRire() {
    return random (2.0f, 6.0);
  }
}
