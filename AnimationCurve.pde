class AnimationCurve {
  
  TreeMap<Float, Keyframe> keyframeCollection;
  String name;
  
  AnimationCurve(String attributeName) {
    //Dictionnaire des clées
    keyframeCollection = new TreeMap<Float, Keyframe>();
    name = attributeName;
  }
  
  void addKeyframe( float keyframeTimestamp, float keyframeValue) {
    keyframeCollection.put(keyframeTimestamp, new Keyframe(keyframeTimestamp, keyframeValue));
  }
}
