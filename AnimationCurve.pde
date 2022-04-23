//Classe de type AnimationCurve
//Elle stocke toutes les poses clés contenues dans la courbe d'animation
class AnimationCurve {
  
  TreeMap<Float, Keyframe> keyframeCollection;
  String name;
  
  //Constructeur
  AnimationCurve(String attributeName) {
    //Dictionnaire des images clés
    keyframeCollection = new TreeMap<Float, Keyframe>();
    //Nom de la courbe d'animation
    name = attributeName;
  }
  
  //Fonction permettant d'ajouter une pose clé à la collection de la courbe d'animation
  void addKeyframe( float keyframeTimestamp, float keyframeValue) {
    keyframeCollection.put(keyframeTimestamp, new Keyframe(keyframeTimestamp, keyframeValue));
  }
}
