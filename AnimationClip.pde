//Classe de type AnimationClip
//Elle stocke toutes les courbes d'animation liée à l'animation d'un élément
class AnimationClip {
  
  //Dictionnaire de courbes d'animation
  TreeMap<String, AnimationCurve> curveCollection;
  
  //Constructeur
  //Il reçoint un tableau de String contenant le nom de toutes les courbes
  //d'animation contenues dans le clip.
  AnimationClip(String[] tabCourbesAnimation) {
    //Création du dictionnaire
    curveCollection = new TreeMap<String, AnimationCurve>();
    
    //Ajout des courbes d'animation au dictionnaire
    for (String nomCourbe : tabCourbesAnimation) {
      curveCollection.put(nomCourbe, new AnimationCurve(nomCourbe));
    }
  }
}
