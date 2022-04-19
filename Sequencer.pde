class Sequencer {
  
  //Clip fée
  AnimationClip clipFee;
  float rotationFee;
  
  float timeCurrent;
  
  Sequencer() {
  }
  
  void update(String nomClip, float timelinePlayhead) {
    timeCurrent = timelinePlayhead;
    
    rotationFee = evaluate(nomClip, "rotation", timelinePlayhead);
  }
  
  float evaluate(String nomClip, String attributeName, float timestamp) {
    Keyframe keyframe1, keyframe2;
    
    float keyframeValue1 = 0.0f;
    float keyframeValue2 = 0.0f;
    
    float keyframeTimestamp1 = 0.0f;
    float keyframeTimestamp2 = 0.0f;

    float valueInterpolated = 0.0f;

    float progression;
    
    AnimationCurve curve;
    
    if (nomClip == "clipFee") {
      curve = clipFee.curveCollection.get(attributeName);
    } else {
      curve = null;
    }
    
    //Si la courbe d'animation existe
    if (curve != null) {
      //Pour chaque pose clé de la courbe d'animation
      for (float keyframeTimestamp : curve.keyframeCollection.keySet()) {
        
        //Si la tête de lecture est devant la pose clée courante
        if( keyframeTimestamp <= timestamp) {
          keyframe1 = curve.keyframeCollection.get(keyframeTimestamp);
          keyframeTimestamp1 = keyframe1.timestamp;
          keyframeValue1 = keyframe1.value;
        } 
        //Si la tête de lecture est après la pose clée, la pose clée 1 est définitivement
        //celle immédiatement devant la tête de lecture. Il est maintenant temps de déterminer
        //qu'elle sera la prochaine propriété, pour calculer et retourner l'interpolation.
        else {
          keyframe2 = curve.keyframeCollection.get(keyframeTimestamp);
          keyframeTimestamp2 = keyframe2.timestamp;
          keyframeValue2 = keyframe2.value;
          
          //claculer la progression entre la pose clée 1 et la pose clé 2
          progression = (timestamp - keyframeTimestamp1) / (keyframeTimestamp2 - keyframeTimestamp1);
          
          //interpolation avec accélération et décélération
          valueInterpolated = interpolationSmoothstep(keyframeValue1, keyframeValue2, progression);
          
          return valueInterpolated;
        }
      
      }
    }
    
    return 0.0f;
  }
  
  //Fonction qui calcule l'interpolation entre la valeur de deux pose clée (value1 et value2) en fonction de la progression
  //entre les deux poses clées (t)
  float interpolationSmoothstep( float value1, float value2, float t) {
    if (t < 0.0f)
      return 0.0f;
    
    if (t > 1.0)
      return 1.0f;
      
    t = t * t * (3.0f - 2.0f * t);
    
    return (1.0f - t) * value1 + t * value2;
  }
}
