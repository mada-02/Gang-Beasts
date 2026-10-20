Shader "Self-Illumin/VertexLit" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _SpecColor ("Spec Color", Color) = (1,1,1,1)
 _Shininess ("Shininess", Range(0.1,1)) = 0.7
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _Illum ("Illumin (A)", 2D) = "white" {}
 _EmissionLM ("Emission (Lightmapper)", Float) = 0
}
SubShader { 
 LOD 100
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "BASE"
  Tags { "LIGHTMODE"="Vertex" "RenderType"="Opaque" }
  Lighting On
  SeparateSpecular On
  Material {
   Diffuse [_Color]
   Specular [_SpecColor]
   Shininess [_Shininess]
  }
  SetTexture [_Illum] { ConstantColor [_Color] combine constant lerp(texture) previous }
  SetTexture [_MainTex] { combine texture * previous, texture alpha * primary alpha }
 }
}
Fallback "VertexLit"
}