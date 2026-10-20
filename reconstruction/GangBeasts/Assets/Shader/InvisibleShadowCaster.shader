Shader "Transparent/InvisibleShadowCaster" {
SubShader { 
 UsePass "VertexLit/SHADOWCOLLECTOR"
 UsePass "VertexLit/SHADOWCASTER"
}
Fallback Off
}