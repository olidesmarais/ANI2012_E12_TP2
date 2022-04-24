//Classe de type Keyframe
//Elle correspond aux poses clées utilisées par la classe AnimationCurve. 
//Elle permet de stocker le temps ainsi que la valeur qui y est associée pour une pose clé.
class Keyframe {
  
  float timestamp, value;
  
  Keyframe( float keyframeTimestamp, float keyframeValue) {
    
    timestamp = keyframeTimestamp;
    value = keyframeValue;
  }
}
