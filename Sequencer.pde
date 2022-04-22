class Sequencer {
  
  //Clip fée
  AnimationClip clipFee;
  float rotationFee;
  
  //Clip amimaux
  AnimationClip[] clipAnimaux;
  float[] animauxPositionX = new float [4];
  float[] animauxPositionY = new float [4];
  float[] animauxRotation  = new float [4];
 
  float timeCurrent;
  
  Sequencer() {
  }
  
  void update(String nomClip, int idx, float timelinePlayhead) {
    timeCurrent = timelinePlayhead;
    
    if (nomClip == "clipFee")
      rotationFee = evaluate("clipFee", "rotation", timelinePlayhead, false, 0);
    
    if (nomClip == "clipRenard") {
      switch(idx) {
        case Animal.ENTREE_DEVANT_GAUCHE:
          animauxPositionX[Animal.ENTREE_DEVANT_GAUCHE] = evaluate("clipRenard", "positionX", timelinePlayhead, true, Animal.ENTREE_DEVANT_GAUCHE);
          animauxPositionY[Animal.ENTREE_DEVANT_GAUCHE] = evaluate("clipRenard", "positionY", timelinePlayhead, true, Animal.ENTREE_DEVANT_GAUCHE);
          animauxRotation[Animal.ENTREE_DEVANT_GAUCHE]  = evaluate("clipRenard", "rotation", timelinePlayhead, true, Animal.ENTREE_DEVANT_GAUCHE);
      }
    }
  }
  
  float evaluate(String nomClip, String attributeName, float timestamp, boolean linear, int idx) {
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
    } else if (nomClip == "clipRenard") {
      curve = clipAnimaux[idx].curveCollection.get(attributeName);
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
          
          if (linear) {
            valueInterpolated = interpolationLinear(keyframeValue1, keyframeValue2, progression);
          } else {
            //interpolation avec accélération et décélération
            valueInterpolated = interpolationSmoothstep(keyframeValue1, keyframeValue2, progression);
          }
          return valueInterpolated;
        }
      
      }
    }
    
    return 0.0f;
  }
  
  // fonction qui calcule une interpolation linéaire entre deux valeurs numériques
  float interpolationLinear(float value1, float value2, float t)
  {
    if (t < 0.0f)
      return value1;

    if (t > 1.0f)
      return value2;

    return (1.0f - t) * value1 + t * value2;
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
