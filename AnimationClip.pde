class AnimationClip {
  
  //Dictionnaire de courbes d'animation
  TreeMap<String, AnimationCurve> curveCollection;
  
  AnimationClip(String[] tabCourbesAnimation) {
    //Création du dictionnaire
    curveCollection = new TreeMap<String, AnimationCurve>();
    
    //Ajout des courbes d'animation au dictionnaire
    for (String nomCourbe : tabCourbesAnimation) {
      curveCollection.put(nomCourbe, new AnimationCurve(nomCourbe));
    }
  }
}
