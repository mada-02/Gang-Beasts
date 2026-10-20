Shader "Marmoset/Mobile/Bumped Specular IBL" {
Properties {
 _Color ("Diffuse Color", Color) = (1,1,1,1)
 _SpecColor ("Specular Color", Color) = (1,1,1,1)
 _SpecInt ("Specular Intensity", Float) = 1
 _Shininess ("Specular Sharpness", Range(2,8)) = 4
 _Fresnel ("Fresnel Strength", Range(0,1)) = 0
 _MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
 _SpecTex ("Specular(RGB) Gloss(A)", 2D) = "white" {}
 _BumpMap ("Normalmap", 2D) = "bump" {}
 _DiffCubeIBL ("Custom Diffuse Cube", CUBE) = "black" {}
 _SpecCubeIBL ("Custom Specular Cube", CUBE) = "black" {}
}
SubShader { 
 LOD 400
 Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry" "RenderType"="Opaque" }
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_14;
  vec3 x2_17;
  vec3 x1_18;
  x1_18.x = dot (unity_SHAr, tmpvar_16);
  x1_18.y = dot (unity_SHAg, tmpvar_16);
  x1_18.z = dot (unity_SHAb, tmpvar_16);
  vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_14.xyzz * tmpvar_14.yzzx);
  x2_17.x = dot (unity_SHBr, tmpvar_19);
  x2_17.y = dot (unity_SHBg, tmpvar_19);
  x2_17.z = dot (unity_SHBb, tmpvar_19);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1_18 + x2_17) + (unity_SHC.xyz * ((tmpvar_14.x * tmpvar_14.x) - (tmpvar_14.y * tmpvar_14.y))));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  float tmpvar_11;
  tmpvar_11 = (1.0 - tmpvar_8.w);
  float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (_Shininess * tmpvar_12));
  float tmpvar_13;
  tmpvar_13 = exp2((8.0 - tmpvar_10));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_14.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_14.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_14, tmpvar_2) * tmpvar_14))), tmpvar_10);
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_17;
  frag_17.w = 1.0;
  frag_17.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_17.xyz = (frag_17.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_13)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_13 * 0.159155) + 0.31831))));
  frag_17.xyz = frag_17.xyz;
  c_1.w = frag_17.w;
  c_1.xyz = (frag_17.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + ((((tmpvar_15.xyz * tmpvar_15.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_16.xyz * tmpvar_16.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [unity_Scale]
Vector 22 [_MainTex_ST]
"vs_3_0
; 64 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c23.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r2.xyz, r1, c21.w, -v0
mul r1.xyz, v2, c21.w
dp3 r0.y, r2, r3
dp3 r0.x, r2, v1
dp3 r0.z, v2, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r2.w, r1, c5
mov r0.y, r2.w
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.w, c23.x
mul r1, r0.xyzz, r0.yzzx
dp4 r4.z, r0, c16
dp4 r4.y, r0, c15
dp4 r4.x, r0, c14
mul r2.w, r2, r2
dp4 r0.w, r1, c19
dp4 r0.z, r1, c18
dp4 r0.y, r1, c17
add r1.xyz, r4, r0.yzww
mad r0.x, r0, r0, -r2.w
mul r4.xyz, r0.x, c20
add o7.xyz, r1, r4
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
dp4 r4.y, c13, r0
mov r1, c8
dp4 r4.x, c13, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c21.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c21.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o6.y, r3, r4
mul o5, r0, c21.w
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c22, c22.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedlbkpioighddcmmbamejpcadgbihnghgpabaaaaaadealaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
faajaaaaeaaaabaafeacaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaa
giaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaa
fgafbaiaebaaaaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaia
ebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaaakaabaaa
aaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaadaaaaaaakiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaa
akiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaa
adaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
dgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaa
bkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaaaaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaacaaaaaa
aaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaa
pgipcaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaagaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaa
abaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaa
aaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
adaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaia
ebaaaaaaaaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  vec3 tmpvar_12;
  tmpvar_12.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_12.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_12.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_12, tmpvar_2) * tmpvar_12))), ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11)));
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  c_1.xyz = (diff_4.xyz * ((8.0 * tmpvar_15.w) * tmpvar_15.xyz));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 38 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c13.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c13.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c13.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c13.w
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 256 [unity_LightmapST]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefieceddiicdeajojppbkmpjoafalgpibmaeeolabaaaaaadeaiaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiagaaaaeaaaabaajkabaaaafjaaaaaeegiocaaaaaaaaaaa
bcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaa
baaaaaaakgiocaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgafbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaal
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaacaaaaaaaoaaaaaa
kgakbaiaebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaa
akaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaacaaaaaaamaaaaaa
dgaaaaagccaabaaaadaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaa
adaaaaaaakiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
adaaaaaadiaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaadgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
acaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaacaaaaaaaoaaaaaa
baaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaa
egaobaaaabaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaa
ckiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaabaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaa
aaaaaaaapgipcaaaacaaaaaabeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  float tmpvar_11;
  tmpvar_11 = (1.0 - tmpvar_8.w);
  float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (_Shininess * tmpvar_12));
  float tmpvar_13;
  tmpvar_13 = exp2((8.0 - tmpvar_10));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_14.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_14.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_14, tmpvar_2) * tmpvar_14))), tmpvar_10);
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec4 tmpvar_18;
  tmpvar_18 = texture2D (unity_LightmapInd, xlv_TEXCOORD5);
  mat3 tmpvar_19;
  tmpvar_19[0].x = 0.816497;
  tmpvar_19[0].y = -0.408248;
  tmpvar_19[0].z = -0.408248;
  tmpvar_19[1].x = 0.0;
  tmpvar_19[1].y = 0.707107;
  tmpvar_19[1].z = -0.707107;
  tmpvar_19[2].x = 0.57735;
  tmpvar_19[2].y = 0.57735;
  tmpvar_19[2].z = 0.57735;
  vec3 lm_20;
  vec3 tmpvar_21;
  tmpvar_21 = ((8.0 * tmpvar_18.w) * tmpvar_18.xyz);
  lm_20 = (((8.0 * tmpvar_17.w) * tmpvar_17.xyz) * dot (clamp ((tmpvar_19 * normal_6), 0.0, 1.0), tmpvar_21));
  vec3 v_22;
  v_22.x = tmpvar_19[0].x;
  v_22.y = tmpvar_19[1].x;
  v_22.z = tmpvar_19[2].x;
  vec3 v_23;
  v_23.x = tmpvar_19[0].y;
  v_23.y = tmpvar_19[1].y;
  v_23.z = tmpvar_19[2].y;
  vec3 v_24;
  v_24.x = tmpvar_19[0].z;
  v_24.y = tmpvar_19[1].z;
  v_24.z = tmpvar_19[2].z;
  c_1.xyz = ((((spec_3.xyz * ((tmpvar_13 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (dot (normal_6, normalize((normalize((((tmpvar_21.x * v_22) + (tmpvar_21.y * v_23)) + (tmpvar_21.z * v_24))) + xlv_TEXCOORD1))), 0.0, 1.0), tmpvar_13))) * lm_20) + (diff_4.xyz * lm_20));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_15.xyz * tmpvar_15.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_16.xyz * tmpvar_16.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 38 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c13.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c13.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c13.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c13.w
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 256 [unity_LightmapST]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefieceddiicdeajojppbkmpjoafalgpibmaeeolabaaaaaadeaiaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiagaaaaeaaaabaajkabaaaafjaaaaaeegiocaaaaaaaaaaa
bcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaa
baaaaaaakgiocaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgafbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaal
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaacaaaaaaaoaaaaaa
kgakbaiaebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaa
akaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaacaaaaaaamaaaaaa
dgaaaaagccaabaaaadaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaa
adaaaaaaakiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
adaaaaaadiaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaadgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
acaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaacaaaaaaaoaaaaaa
baaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaa
egaobaaaabaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaa
ckiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaabaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaa
aaaaaaaapgipcaaaacaaaaaabeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_15;
  vec3 x2_18;
  vec3 x1_19;
  x1_19.x = dot (unity_SHAr, tmpvar_17);
  x1_19.y = dot (unity_SHAg, tmpvar_17);
  x1_19.z = dot (unity_SHAb, tmpvar_17);
  vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_15.xyzz * tmpvar_15.yzzx);
  x2_18.x = dot (unity_SHBr, tmpvar_20);
  x2_18.y = dot (unity_SHBg, tmpvar_20);
  x2_18.z = dot (unity_SHBb, tmpvar_20);
  vec4 o_21;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_1 * 0.5);
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_21.xy = (tmpvar_23 + tmpvar_22.w);
  o_21.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_16).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1_19 + x2_18) + (unity_SHC.xyz * ((tmpvar_15.x * tmpvar_15.x) - (tmpvar_15.y * tmpvar_15.y))));
  xlv_TEXCOORD7 = o_21;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  float tmpvar_11;
  tmpvar_11 = (1.0 - tmpvar_8.w);
  float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (_Shininess * tmpvar_12));
  float tmpvar_13;
  tmpvar_13 = exp2((8.0 - tmpvar_10));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_14.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_14.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_14, tmpvar_2) * tmpvar_14))), tmpvar_10);
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_17;
  frag_17.w = 1.0;
  frag_17.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_17.xyz = (frag_17.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_13)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_13 * 0.159155) + 0.31831))));
  frag_17.xyz = (frag_17.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x);
  c_1.w = frag_17.w;
  c_1.xyz = (frag_17.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + ((((tmpvar_15.xyz * tmpvar_15.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_16.xyz * tmpvar_16.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [unity_Scale]
Vector 24 [_MainTex_ST]
"vs_3_0
; 69 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c25, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c25.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r2.xyz, r1, c23.w, -v0
mul r1.xyz, v2, c23.w
dp3 r0.y, r2, r3
dp3 r0.x, r2, v1
dp3 r0.z, v2, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r2.w, r1, c5
mov r0.y, r2.w
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.w, c25.x
mul r1, r0.xyzz, r0.yzzx
dp4 r4.z, r0, c18
dp4 r4.y, r0, c17
dp4 r4.x, r0, c16
mul r2.w, r2, r2
dp4 r0.w, r1, c21
dp4 r0.z, r1, c20
dp4 r0.y, r1, c19
add r1.xyz, r4, r0.yzww
mad r0.x, r0, r0, -r2.w
mul r4.xyz, r0.x, c22
add o7.xyz, r1, r4
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c9
dp4 r4.y, c15, r0
mov r1, c8
dp4 r4.x, c15, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c23.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c23.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c23.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c13.x
dp3 o6.y, r3, r4
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c24, c24.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedklfpaacoeockigcfkcpcanihkhpicjolabaaaaaaoealaaaaadaaaaaa
cmaaaaaapeaaaaaapeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopiaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaomaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaomaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaomaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaomaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaahaaaaaaaaaaaaaaadaaaaaaaiaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoiajaaaaeaaaabaa
hkacaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaadpccabaaa
aiaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabeaaaaaaogikcaaaaaaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaadaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgbpbaaa
abaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaiaebaaaaaa
abaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaadcaaaaal
lcaabaaaabaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaiaebaaaaaaabaaaaaa
egambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaadgaaaaag
bcaabaaaaeaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaa
baaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaah
ecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaa
adaaaaaaegaobaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaaficaabaaa
acaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaeaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaa
egacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaa
abaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaa
abaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaa
abaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaa
bbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaa
bbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaa
bbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaah
ccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaa
dcaaaaakhccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaiaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaaiaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = _WorldSpaceCameraPos;
  vec4 o_15;
  vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_1 * 0.5);
  vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_15.xy = (tmpvar_17 + tmpvar_16.w);
  o_15.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_14).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_15;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  vec3 tmpvar_12;
  tmpvar_12.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_12.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_12.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_12, tmpvar_2) * tmpvar_12))), ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11)));
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec3 tmpvar_17;
  tmpvar_17 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  c_1.xyz = (diff_4.xyz * max (min (tmpvar_17, ((tmpvar_15.x * 2.0) * tmpvar_16.xyz)), (tmpvar_17 * tmpvar_15.x)));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"vs_3_0
; 44 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c18.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c15.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.w, -r1, c4
dp3 r0.y, r2, c4
dp4 r1.w, v0, c3
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c15.w
dp3 r0.w, -r1, c5
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c15.w
dp3 r0.w, -r1, c6
dp4 r1.z, v0, c2
dp3 r0.y, r2, c6
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c18.y
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c15.w
mov r0.x, r2
mul r0.y, r2, c13.x
mad o7.xy, r2.z, c14.zwzw, r0
mov o0, r1
mov o7.zw, r1
mad o1.xy, v3, c17, c17.zwzw
mad o6.xy, v4, c16, c16.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 352
Vector 320 [unity_LightmapST]
Vector 336 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedmhmgbnlinjffeabcafombaigdgbgkphnabaaaaaaoeaiaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
aaahaaaaeaaaabaamaabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
afaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabfaaaaaaogikcaaaaaaaaaaabfaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabeaaaaaakgiocaaa
aaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaia
ebaaaaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaallcaabaaaabaaaaaaegiicaaaacaaaaaaaoaaaaaakgakbaiaebaaaaaa
abaaaaaaegambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaa
dgaaaaagbcaabaaaaeaaaaaaakiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaa
aeaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaa
acaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaa
aeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaa
baaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaaf
icaabaaaacaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaa
acaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaacaaaaaaanaaaaaa
dgaaaaagecaabaaaaeaaaaaabkiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaa
egbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaacaaaaaa
amaaaaaadgaaaaagccaabaaaacaaaaaackiacaaaacaaaaaaanaaaaaadgaaaaag
ecaabaaaacaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = _WorldSpaceCameraPos;
  vec4 o_15;
  vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_1 * 0.5);
  vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_15.xy = (tmpvar_17 + tmpvar_16.w);
  o_15.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_14).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_15;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  float tmpvar_11;
  tmpvar_11 = (1.0 - tmpvar_8.w);
  float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (_Shininess * tmpvar_12));
  float tmpvar_13;
  tmpvar_13 = exp2((8.0 - tmpvar_10));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_14.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_14.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_14, tmpvar_2) * tmpvar_14))), tmpvar_10);
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  vec4 tmpvar_18;
  tmpvar_18 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec4 tmpvar_19;
  tmpvar_19 = texture2D (unity_LightmapInd, xlv_TEXCOORD5);
  mat3 tmpvar_20;
  tmpvar_20[0].x = 0.816497;
  tmpvar_20[0].y = -0.408248;
  tmpvar_20[0].z = -0.408248;
  tmpvar_20[1].x = 0.0;
  tmpvar_20[1].y = 0.707107;
  tmpvar_20[1].z = -0.707107;
  tmpvar_20[2].x = 0.57735;
  tmpvar_20[2].y = 0.57735;
  tmpvar_20[2].z = 0.57735;
  vec3 lm_21;
  vec3 tmpvar_22;
  tmpvar_22 = ((8.0 * tmpvar_19.w) * tmpvar_19.xyz);
  lm_21 = (((8.0 * tmpvar_18.w) * tmpvar_18.xyz) * dot (clamp ((tmpvar_20 * normal_6), 0.0, 1.0), tmpvar_22));
  vec3 v_23;
  v_23.x = tmpvar_20[0].x;
  v_23.y = tmpvar_20[1].x;
  v_23.z = tmpvar_20[2].x;
  vec3 v_24;
  v_24.x = tmpvar_20[0].y;
  v_24.y = tmpvar_20[1].y;
  v_24.z = tmpvar_20[2].y;
  vec3 v_25;
  v_25.x = tmpvar_20[0].z;
  v_25.y = tmpvar_20[1].z;
  v_25.z = tmpvar_20[2].z;
  c_1.xyz = ((((spec_3.xyz * ((tmpvar_13 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (dot (normal_6, normalize((normalize((((tmpvar_22.x * v_23) + (tmpvar_22.y * v_24)) + (tmpvar_22.z * v_25))) + xlv_TEXCOORD1))), 0.0, 1.0), tmpvar_13))) * lm_21) + (diff_4.xyz * max (min (lm_21, ((tmpvar_17.x * 2.0) * tmpvar_18.xyz)), (lm_21 * tmpvar_17.x))));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_15.xyz * tmpvar_15.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_16.xyz * tmpvar_16.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"vs_3_0
; 44 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c18.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c15.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.w, -r1, c4
dp3 r0.y, r2, c4
dp4 r1.w, v0, c3
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c15.w
dp3 r0.w, -r1, c5
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c15.w
dp3 r0.w, -r1, c6
dp4 r1.z, v0, c2
dp3 r0.y, r2, c6
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c18.y
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c15.w
mov r0.x, r2
mul r0.y, r2, c13.x
mad o7.xy, r2.z, c14.zwzw, r0
mov o0, r1
mov o7.zw, r1
mad o1.xy, v3, c17, c17.zwzw
mad o6.xy, v4, c16, c16.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 352
Vector 320 [unity_LightmapST]
Vector 336 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedmhmgbnlinjffeabcafombaigdgbgkphnabaaaaaaoeaiaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
aaahaaaaeaaaabaamaabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
afaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabfaaaaaaogikcaaaaaaaaaaabfaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabeaaaaaakgiocaaa
aaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaia
ebaaaaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaallcaabaaaabaaaaaaegiicaaaacaaaaaaaoaaaaaakgakbaiaebaaaaaa
abaaaaaaegambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaa
dgaaaaagbcaabaaaaeaaaaaaakiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaa
aeaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaa
acaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaa
aeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaa
baaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaaf
icaabaaaacaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaa
acaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaacaaaaaaanaaaaaa
dgaaaaagecaabaaaaeaaaaaabkiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaa
egbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaacaaaaaa
amaaaaaadgaaaaagccaabaaaacaaaaaackiacaaaacaaaaaaanaaaaaadgaaaaag
ecaabaaaacaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_14;
  vec3 x2_17;
  vec3 x1_18;
  x1_18.x = dot (unity_SHAr, tmpvar_16);
  x1_18.y = dot (unity_SHAg, tmpvar_16);
  x1_18.z = dot (unity_SHAb, tmpvar_16);
  vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_14.xyzz * tmpvar_14.yzzx);
  x2_17.x = dot (unity_SHBr, tmpvar_19);
  x2_17.y = dot (unity_SHBg, tmpvar_19);
  x2_17.z = dot (unity_SHBb, tmpvar_19);
  vec3 tmpvar_20;
  tmpvar_20 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_21;
  tmpvar_21 = (unity_4LightPosX0 - tmpvar_20.x);
  vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosY0 - tmpvar_20.y);
  vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosZ0 - tmpvar_20.z);
  vec4 tmpvar_24;
  tmpvar_24 = (((tmpvar_21 * tmpvar_21) + (tmpvar_22 * tmpvar_22)) + (tmpvar_23 * tmpvar_23));
  vec4 tmpvar_25;
  tmpvar_25 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_21 * tmpvar_14.x) + (tmpvar_22 * tmpvar_14.y)) + (tmpvar_23 * tmpvar_14.z)) * inversesqrt(tmpvar_24))) * (1.0/((1.0 + (tmpvar_24 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1_18 + x2_17) + (unity_SHC.xyz * ((tmpvar_14.x * tmpvar_14.x) - (tmpvar_14.y * tmpvar_14.y)))) + ((((unity_LightColor[0].xyz * tmpvar_25.x) + (unity_LightColor[1].xyz * tmpvar_25.y)) + (unity_LightColor[2].xyz * tmpvar_25.z)) + (unity_LightColor[3].xyz * tmpvar_25.w)));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  float tmpvar_11;
  tmpvar_11 = (1.0 - tmpvar_8.w);
  float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (_Shininess * tmpvar_12));
  float tmpvar_13;
  tmpvar_13 = exp2((8.0 - tmpvar_10));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_14.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_14.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_14, tmpvar_2) * tmpvar_14))), tmpvar_10);
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_17;
  frag_17.w = 1.0;
  frag_17.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_17.xyz = (frag_17.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_13)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_13 * 0.159155) + 0.31831))));
  frag_17.xyz = frag_17.xyz;
  c_1.w = frag_17.w;
  c_1.xyz = (frag_17.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + ((((tmpvar_15.xyz * tmpvar_15.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_16.xyz * tmpvar_16.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Vector 29 [unity_Scale]
Vector 30 [_MainTex_ST]
"vs_3_0
; 95 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c31, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c29.w
dp4 r0.x, v0, c5
add r1, -r0.x, c15
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c31.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c16
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c17
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c24
dp4 r2.y, r4, c23
dp4 r2.x, r4, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mul r1, r4.xyzz, r4.yzzx
mad r0.xyz, r0.w, c21, r0
mul r0.w, r3, r3
mad r0.w, r4.x, r4.x, -r0
dp4 r3.z, r1, c27
dp4 r3.y, r1, c26
dp4 r3.x, r1, c25
add r1.xyz, r2, r3
mov r2.xyz, v1
mul r3.xyz, v2.zxyw, r2.yzxw
mul r4.xyz, r0.w, c28
add r4.xyz, r1, r4
mov r2.xyz, v1
mad r2.xyz, v2.yzxw, r2.zxyw, -r3
mul r3.xyz, r2, v1.w
mov r1.xyz, c12
mov r1.w, c31.x
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c29.w, -v0
add o7.xyz, r4, r0
dp3 r1.y, r2, r3
dp3 r1.x, r2, v1
dp3 r1.z, v2, r2
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
dp4 r4.y, c13, r0
mul o2.xyz, r1.w, r1
mov r1, c8
dp4 r4.x, c13, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c29.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c29.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o6.y, r3, r4
mul o5, r0, c29.w
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c30, c30.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedaimoojoccmejgnlaapiiobjmafgpkjaiabaaaaaaieaoaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
kaamaaaaeaaaabaaciadaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaa
giaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaa
fgafbaiaebaaaaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaia
ebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaaakaabaaa
aaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaadaaaaaaakiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaa
akiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaa
adaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
dgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaa
bkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaaaaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaacaaaaaa
aaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaa
pgipcaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaagaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaa
abaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaa
egacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
hcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
abaaaaaaegadbaaaabaaaaaabbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
adaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakicaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaa
egiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaa
egaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaa
adaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaaaaaaaaajpcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaa
egiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaa
agaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaa
egaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaa
acaaaaaaegaobaaaacaaaaaaegaobaaaacaaaaaaegaobaaaadaaaaaaeeaaaaaf
pcaabaaaadaaaaaaegaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaa
acaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaacaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaa
acaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
agaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaahhccabaaaahaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_15;
  vec3 x2_18;
  vec3 x1_19;
  x1_19.x = dot (unity_SHAr, tmpvar_17);
  x1_19.y = dot (unity_SHAg, tmpvar_17);
  x1_19.z = dot (unity_SHAb, tmpvar_17);
  vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_15.xyzz * tmpvar_15.yzzx);
  x2_18.x = dot (unity_SHBr, tmpvar_20);
  x2_18.y = dot (unity_SHBg, tmpvar_20);
  x2_18.z = dot (unity_SHBb, tmpvar_20);
  vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_15.x) + (tmpvar_23 * tmpvar_15.y)) + (tmpvar_24 * tmpvar_15.z)) * inversesqrt(tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  vec4 o_27;
  vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_1 * 0.5);
  vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_28.x;
  tmpvar_29.y = (tmpvar_28.y * _ProjectionParams.x);
  o_27.xy = (tmpvar_29 + tmpvar_28.w);
  o_27.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_16).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1_19 + x2_18) + (unity_SHC.xyz * ((tmpvar_15.x * tmpvar_15.x) - (tmpvar_15.y * tmpvar_15.y)))) + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  xlv_TEXCOORD7 = o_27;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  float tmpvar_11;
  tmpvar_11 = (1.0 - tmpvar_8.w);
  float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (_Shininess * tmpvar_12));
  float tmpvar_13;
  tmpvar_13 = exp2((8.0 - tmpvar_10));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_14.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_14.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_14, tmpvar_2) * tmpvar_14))), tmpvar_10);
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_17;
  frag_17.w = 1.0;
  frag_17.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_17.xyz = (frag_17.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_13)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_13 * 0.159155) + 0.31831))));
  frag_17.xyz = (frag_17.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x);
  c_1.w = frag_17.w;
  c_1.xyz = (frag_17.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + ((((tmpvar_15.xyz * tmpvar_15.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_16.xyz * tmpvar_16.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [unity_Scale]
Vector 32 [_MainTex_ST]
"vs_3_0
; 100 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c33, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c31.w
dp4 r0.x, v0, c5
add r1, -r0.x, c17
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c16
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c18
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c19
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
dp4 r2.z, r4, c26
dp4 r2.y, r4, c25
dp4 r2.x, r4, c24
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r0.xyz, r0.z, c22, r1
mul r1, r4.xyzz, r4.yzzx
mad r0.xyz, r0.w, c23, r0
mul r0.w, r3, r3
mad r0.w, r4.x, r4.x, -r0
dp4 r3.z, r1, c29
dp4 r3.y, r1, c28
dp4 r3.x, r1, c27
add r1.xyz, r2, r3
mov r2.xyz, v1
mul r3.xyz, v2.zxyw, r2.yzxw
mul r4.xyz, r0.w, c30
add r4.xyz, r1, r4
mov r2.xyz, v1
mad r2.xyz, v2.yzxw, r2.zxyw, -r3
mul r3.xyz, r2, v1.w
mov r1.xyz, c12
mov r1.w, c33.x
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c31.w, -v0
add o7.xyz, r4, r0
dp3 r1.y, r2, r3
dp3 r1.x, r2, v1
dp3 r1.z, v2, r2
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c9
dp4 r4.y, c15, r0
mul o2.xyz, r1.w, r1
mov r1, c8
dp4 r4.x, c15, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c31.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c31.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c31.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c13.x
dp3 o6.y, r3, r4
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c32, c32.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedbnhifhamfjhedgaiaacnhnoooliopaehabaaaaaadeapaaaaadaaaaaa
cmaaaaaapeaaaaaapeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopiaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaomaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaomaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaomaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaomaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaahaaaaaaaaaaaaaaadaaaaaaaiaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcdianaaaaeaaaabaa
eoadaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaadpccabaaa
aiaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabeaaaaaaogikcaaaaaaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaadaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgbpbaaa
abaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaiaebaaaaaa
abaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaadcaaaaal
lcaabaaaabaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaiaebaaaaaaabaaaaaa
egambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaadgaaaaag
bcaabaaaaeaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaa
baaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaah
ecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaa
adaaaaaaegaobaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaaficaabaaa
acaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaeaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaa
egacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaacaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaadaaaaaa
fgafbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaa
acaaaaaabbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaa
abaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaa
abaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaa
abaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaa
bbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaa
bbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaa
bbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaah
icaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaihcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaa
adaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaa
aaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaa
adaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaa
diaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaaj
pcaabaaaagaaaaaaagaabaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaacaaaaaa
aaaaaaajpcaabaaaadaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaa
aeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaaagaabaaaabaaaaaa
egaobaaaafaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaakgakbaaa
abaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaagaaaaaa
egaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaadaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaa
egaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaa
acaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
adaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaa
deaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaa
abaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
ahaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaa
abaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
aiaaaaaakgakbaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaah
hccabaaaahaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaaiaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaiaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [ExposureIBL]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
"ps_3_0
; 63 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c8, 2.00000000, -1.00000000, 7.00000000, 8.00000000
def c9, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c10, 0.15915494, 0.31830987, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
texld r2, v0, s2
add_pp r0.x, -r2.w, c9.w
mad_pp r0.x, -r0, r0, c9.w
mad_pp r0.x, -r0, c6, r0
texld r1.yw, v0, s1
add_pp r0.w, r0.x, c8.z
mad_pp r0.xy, r1.wyzw, c8.x, c8.y
mul_pp r3.xy, r0, r0
add_pp_sat r0.z, r3.x, r3.y
mov_pp r1.xyz, v5
add_pp r1.xyz, v1, r1
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
add_pp r0.z, -r0, c9.w
rsq_pp r0.z, r0.z
mul_pp r1.xyz, r1.w, r1
rcp_pp r0.z, r0.z
dp3_pp_sat r3.x, r0, r1
dp3_sat r1.y, r0, v1
add_pp r1.x, -r0.w, c8.w
add r3.y, -r1, c9.w
exp_pp r2.w, r1.x
pow r1, r3.x, r2.w
mad_pp r1.y, r3, c9.x, c9.x
mul_pp r1.z, r3.y, r1.y
dp3_pp_sat r1.w, r0, v5
mad_pp r1.z, r1, c9.y, c9
mov_pp r1.y, c9.w
mad_pp r1.y, r1.z, c7.x, r1
mul_pp r1.y, r1, c5.x
mad r1.z, r2.w, c10.x, c10.y
mul_pp r1.y, r1, c2.w
mul_pp r2.xyz, r2, c1
mul_pp r3.xyz, r2, r1.y
mul_pp r2.xyz, r3, r1.z
mul_pp r1.xyz, r1.x, c0
mul_pp r2.xyz, r1, r2
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r5.xyz, r2, c9.x
mul_pp r2.xyz, r1, c2.w
mul_pp r4.xyz, r2, r1.w
mul_pp r4.xyz, r4, c0
dp3_pp r1.x, r0, v2
dp3_pp r1.y, r0, v3
dp3_pp r1.z, r0, v4
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r1.w, r1, r0
mad_pp r4.xyz, r4, c8.x, r5
mul r5.xyz, r1, r1.w
mad r0.xyz, -r5, c8.x, r0
texldl r0, r0, s3
texld r1, r1, s4
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, r1.w
mov_pp r5.xy, c2
mul_pp r5.xy, c3, r5
mul_pp r1.xyz, r2, r1
mul_pp r1.xyz, r5.x, r1
mul_pp r0.xyz, r3, r0
mad_pp r0.xyz, r0, r5.y, r1
mad_pp r1.xyz, r2, v6, r4
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 4
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 1
ConstBuffer "$Globals" 272
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 244 [_Shininess]
Float 248 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedamamekjmaacpmfopaelljbbldagnejjlabaaaaaapmajaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefckmaiaaaaeaaaaaaaclacaaaafjaaaaaeegiocaaa
aaaaaaaabaaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagcbaaaadpcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagcbaaaad
hcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaa
dcaaaaandcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaapgapbaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaaaebaaaaaaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaa
bkiacaiaebaaaaaaaaaaaaaaapaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaa
dgaaaaafbcaabaaaabaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaaabaaaaaa
dkbabaaaaeaaaaaadgaaaaafecaabaaaabaaaaaadkbabaaaafaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaeaaaaaa
dcaaaaapdcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaah
icaabaaaabaaaaaaegaabaaaacaaaaaaegaabaaaacaaaaaaddaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaacaaaaaa
dkaabaaaabaaaaaabaaaaaahbcaabaaaadaaaaaaegbcbaaaadaaaaaaegacbaaa
acaaaaaabaaaaaahccaabaaaadaaaaaaegbcbaaaaeaaaaaaegacbaaaacaaaaaa
baaaaaahecaabaaaadaaaaaaegbcbaaaafaaaaaaegacbaaaacaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaaaaaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaadaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaadaaaaaaegacbaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaabaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaaeiaaaaal
pcaabaaaabaaaaaaegacbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
dkaabaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaaaebbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabacaaaahicaabaaa
abaaaaaaegacbaaaacaaaaaaegbcbaaaacaaaaaaaaaaaaaiicaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaacaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaadcaaaaajicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakicaabaaa
abaaaaaackiacaaaaaaaaaaaapaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaiadp
diaaaaaiicaabaaaabaaaaaadkaabaaaabaaaaaaakiacaaaaaaaaaaaapaaaaaa
diaaaaaiicaabaaaabaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
aeaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaai
hcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaai
hcaabaaaaeaaaaaaegacbaaaaeaaaaaapgipcaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaadiaaaaajdcaabaaa
afaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaah
hcaabaaaadaaaaaaegacbaaaadaaaaaaagaabaaaafaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaabaaaaaafgafbaaaafaaaaaaegacbaaaadaaaaaaaaaaaaah
hcaabaaaadaaaaaaegbcbaaaacaaaaaaegbcbaaaagaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaa
adaaaaaabacaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
bacaaaahbcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaaagaaaaaaaaaaaaah
bcaabaaaacaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaaeaaaaaaagaabaaaacaaaaaacpaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
abaaaaaadcaaaaajicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaidpjccdo
abeaaaaaidpjkcdodiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaa
adaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaa
aaaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaeaaaaaaegbcbaaaahaaaaaa
egacbaaaaaaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [unity_Lightmap] 2D 5
"ps_3_0
; 45 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
def c8, 2.00000000, -1.00000000, 7.00000000, 0.50000000
def c9, 0.85009766, -0.84997559, 1.00000000, 8.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0.yw, v0, s1
mad_pp r3.xy, r0.wyzw, c8.x, c8.y
mul_pp r0.xy, r3, r3
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c9.z
rsq_pp r0.x, r0.x
rcp_pp r3.z, r0.x
dp3_sat r1.w, r3, v1
dp3_pp r2.x, v2, r3
dp3_pp r2.y, r3, v3
dp3_pp r2.z, r3, v4
add r2.w, -r1, c9.z
mad_pp r3.x, r2.w, c8.w, c8.w
mul_pp r2.w, r2, r3.x
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r0.w, r2, r0
mul r1.xyz, r2, r0.w
mad r1.xyz, -r1, c8.x, r0
texld r0, v0, s2
add_pp r0.w, -r0, c9.z
mad_pp r0.w, -r0, r0, c9.z
mad_pp r1.w, -r0, c6.x, r0
add_pp r1.w, r1, c8.z
texldl r1, r1, s3
mul_pp r1.xyz, r1, r1.w
mad_pp r2.w, r2, c9.x, c9.y
mov_pp r0.w, c9.z
mad_pp r0.w, r2, c7.x, r0
texld r2, r2, s4
mul_pp r0.w, r0, c5.x
mul_pp r3.xyz, r2, r2.w
mul_pp r0.w, r0, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r1, r0
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r2.xyz, r1, c1.w
mov_pp r1.xy, c1
mul_pp r4.xy, c3, r1
texld r1, v5, s5
mul_pp r1.xyz, r1.w, r1
mul_pp r4.xy, r4, c2
mul_pp r3.xyz, r2, r3
mul_pp r3.xyz, r4.x, r3
mad_pp r0.xyz, r0, r4.y, r3
mul_pp r1.xyz, r1, r2
mad_pp oC0.xyz, r1, c9.w, r0
mov_pp oC0.w, c9.z
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 4
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 1
SetTexture 5 [unity_Lightmap] 2D 5
ConstBuffer "$Globals" 288
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 244 [_Shininess]
Float 248 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedilifbaaamemgnpjmmloimhhcfhakndleabaaaaaadiaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcaaahaaaaeaaaaaaamaabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafidaaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadgaaaaafbcaabaaaaaaaaaaa
dkbabaaaadaaaaaadgaaaaafccaabaaaaaaaaaaadkbabaaaaeaaaaaadgaaaaaf
ecaabaaaaaaaaaaadkbabaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaabaaaaaa
hgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaa
abaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaa
acaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaa
egbcbaaaafaaaaaaegacbaaaabaaaaaabacaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegbcbaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahbcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaiaebaaaaaa
abaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaacaaaaaa
eghobaaaaeaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaacaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaacaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaandcaabaaaadaaaaaapgapbaia
ebaaaaaaabaaaaaapgapbaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaebaaaaaaaa
aaaaaaaadcaaaaalicaabaaaabaaaaaabkiacaiaebaaaaaaaaaaaaaaapaaaaaa
akaabaaaadaaaaaabkaabaaaadaaaaaaeiaaaaalpcaabaaaadaaaaaaegacbaaa
aaaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaadcaaaaajicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaabaaaaaadcaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaak
icaabaaaaaaaaaaackiacaaaaaaaaaaaapaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaiadpdiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
apaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
adaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaj
dcaabaaaadaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaaaeaaaaaa
diaaaaaidcaabaaaadaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaagaabaaaadaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
"ps_3_0
; 76 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c8, 2.00000000, -1.00000000, 8.00000000, 7.00000000
def c9, -0.40824831, 0.70710677, 0.57735026, 0.50000000
def c10, 0.81649655, 0.00000000, 0.57735026, 1.00000000
def c11, -0.40824828, -0.70710677, 0.57735026, 0.12500000
def c12, 0.85009766, -0.84997559, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r2.yw, v0, s1
mad_pp r5.xy, r2.wyzw, c8.x, c8.y
texld r1, v0, s2
texld r0, v5, s6
mul_pp r0.xyz, r0.w, r0
mul_pp r3.xyz, r0, c8.z
mul r0.xyz, r3.y, c9
mad r0.xyz, r3.x, c10, r0
mad r0.xyz, r3.z, c11, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r0, v1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
add_pp r0.w, -r1, c10
mad_pp r1.w, -r0, r0, c10
mul_pp r2.xy, r5, r5
add_pp_sat r0.w, r2.x, r2.y
mad_pp r1.w, -r1, c6.x, r1
add_pp r2.w, r1, c8
add_pp r1.w, -r2, c8.z
add_pp r0.w, -r0, c10
rsq_pp r0.w, r0.w
rcp_pp r5.z, r0.w
mov_pp r6.xy, c1
mul_pp r6.xy, c3, r6
dp3_pp_sat r3.w, r5, r0
exp_pp r1.w, r1.w
pow r0, r3.w, r1.w
dp3_pp r2.x, r5, v2
dp3_pp r2.y, r5, v3
dp3_pp r2.z, r5, v4
mov r4.x, v2.w
mov r4.z, v4.w
mov r4.y, v3.w
dp3 r4.w, r2, r4
mul r0.yzw, r2.xxyz, r4.w
mov_pp r4.w, r2
mad r4.xyz, -r0.yzww, c8.x, r4
texldl r4, r4, s3
texld r2, r2, s4
mul_pp r0.yzw, r2.xxyz, r2.w
dp3_sat r3.w, r5, v1
add r2.w, -r3, c10
mad_pp r3.w, r2, c9, c9
mul_pp r2.w, r2, r3
mad_pp r3.w, r2, c12.x, c12.y
texld r2.xyz, v0, s0
mul_pp r2.xyz, r2, c4
mul_pp r2.xyz, r2, c1.w
mov_pp r2.w, c10
mad_pp r2.w, r3, c7.x, r2
mul_pp r2.w, r2, c5.x
mul_pp r0.yzw, r2.xxyz, r0
mul_pp r6.xy, r6, c2
mul_pp r0.yzw, r6.x, r0
mul_pp r2.w, r2, c1
mul_pp r1.xyz, r1, c0
mul_pp r1.xyz, r1, r2.w
mov r2.w, r0.x
mul_pp r4.xyz, r4, r4.w
mul_pp r4.xyz, r1, r4
mad_pp r4.xyz, r4, r6.y, r0.yzww
mad r1.w, r1, c12.z, c12
mul_pp r1.xyz, r1, r1.w
mul r1.xyz, r2.w, r1
dp3_pp_sat r0.z, r5, c11
dp3_pp_sat r0.x, r5, c10
dp3_pp_sat r0.y, r5, c9
dp3_pp r3.x, r3, r0
texld r0, v5, s5
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r3.x
mul_pp r0.xyz, r0, c8.z
mul_pp r2.xyz, r0, r2
mul r1.xyz, r1, c11.w
mad_pp r0.xyz, r1, r0, r2
add_pp oC0.xyz, r0, r4
mov_pp oC0.w, c10
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 4
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 1
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
ConstBuffer "$Globals" 288
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 244 [_Shininess]
Float 248 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedloibfhccgnelibebhpkgoppcffaplmloabaaaaaammalaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeakaaaaeaaaaaaakfacaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaa
adaaaaaagcbaaaadpcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaandcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaapgapbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaeb
aaaaaaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
apaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaaaebbjaaaaafbcaabaaaabaaaaaa
akaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
agaaaaaaaagabaaaagaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaa
abaaaaaadiaaaaakhcaabaaaacaaaaaakgakbaaaabaaaaaaaceaaaaaomafnblo
pdaedfdpdkmnbddpaaaaaaaadcaaaaamhcaabaaaacaaaaaafgafbaaaabaaaaaa
aceaaaaaolaffbdpaaaaaaaadkmnbddpaaaaaaaaegacbaaaacaaaaaadcaaaaam
hcaabaaaacaaaaaapgapbaaaabaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaaj
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaacaaaaaaegbcbaaaacaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
acaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaa
adaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaacaaaaaaegaabaaaadaaaaaa
egaabaaaadaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaaabeaaaaa
aaaaiadpelaaaaafecaabaaaadaaaaaadkaabaaaacaaaaaabacaaaahbcaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaacpaaaaafbcaabaaaacaaaaaa
akaabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaaabaaaaaaakaabaaa
acaaaaaadcaaaaajbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaidpjccdo
abeaaaaaidpjkcdobjaaaaafbcaabaaaacaaaaaaakaabaaaacaaaaaadiaaaaah
bcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaaaaaaadobacaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegbcbaaaacaaaaaaaaaaaaaiccaabaaaacaaaaaa
bkaabaiaebaaaaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaajecaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahccaabaaa
acaaaaaackaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaajccaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakccaabaaa
acaaaaaackiacaaaaaaaaaaaapaaaaaabkaabaaaacaaaaaaabeaaaaaaaaaiadp
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaaakiacaaaaaaaaaaaapaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaadkiacaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaacaaaaaadiaaaaah
ocaabaaaacaaaaaaagaabaaaabaaaaaaagajbaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaaagaabaaaacaaaaaajgahbaaaacaaaaaaapcaaaakbcaabaaaaeaaaaaa
aceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaaadaaaaaabacaaaak
ccaabaaaaeaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaaegacbaaa
adaaaaaabacaaaakecaabaaaaeaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaeaaaaaa
jgahbaaaabaaaaaaefaaaaajpcaabaaaaeaaaaaaogbkbaaaabaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaeaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaaeaaaaaafgafbaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaa
efaaaaajpcaabaaaaeaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaaihcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaaaaaaaaaa
aoaaaaaadiaaaaaihcaabaaaaeaaaaaaegacbaaaaeaaaaaapgipcaaaaaaaaaaa
adaaaaaadiaaaaahhcaabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaaeaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
afaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaadaaaaaa
baaaaaahccaabaaaacaaaaaaegbcbaaaaeaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaacaaaaaaegbcbaaaafaaaaaaegacbaaaadaaaaaadgaaaaafbcaabaaa
adaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaaadaaaaaadkbabaaaaeaaaaaa
dgaaaaafecaabaaaadaaaaaadkbabaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaiaebaaaaaaabaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egacbaaaacaaaaaaeghobaaaaeaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaaeaaaaaaegacbaaaacaaaaaaeiaaaaalpcaabaaaadaaaaaaegacbaaa
adaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaajdcaabaaaadaaaaaa
egiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaaidcaabaaa
adaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [ExposureIBL]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [_ShadowMapTexture] 2D 5
"ps_3_0
; 65 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
def c8, 2.00000000, -1.00000000, 7.00000000, 8.00000000
def c9, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c10, 0.15915494, 0.31830987, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c8.x, c8.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c9.w
rsq_pp r1.z, r0.x
rcp_pp r1.z, r1.z
texld r0, v0, s2
add_pp r0.w, -r0, c9
mad_pp r0.w, -r0, r0, c9
mad_pp r0.w, -r0, c6.x, r0
add_pp r0.w, r0, c8.z
mov_pp r2.w, r0
texld r5.xyz, v0, s0
mul_pp r5.xyz, r5, c4
dp3_pp r3.x, r1, v2
dp3_pp r3.y, r1, v3
dp3_pp r3.z, r1, v4
mul_pp r5.xyz, r5, c2.w
mov r2.x, v2.w
mov r2.z, v4.w
mov r2.y, v3.w
dp3 r1.w, r3, r2
mul r4.xyz, r3, r1.w
mad r2.xyz, -r4, c8.x, r2
texldl r2, r2, s3
dp3_sat r1.w, r1, v1
add r1.w, -r1, c9
mul_pp r4.xyz, r2, r2.w
mad_pp r3.w, r1, c9.x, c9.x
mul_pp r2.x, r1.w, r3.w
texld r3, r3, s4
mul_pp r3.xyz, r3, r3.w
mad_pp r2.x, r2, c9.y, c9.z
mov_pp r1.w, c9
mad_pp r1.w, r2.x, c7.x, r1
mul_pp r2.xyz, r0, c1
mul_pp r1.w, r1, c5.x
mul_pp r1.w, r1, c2
mul_pp r2.xyz, r2, r1.w
mov_pp r0.xyz, v5
add_pp r0.xyz, v1, r0
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mul_pp r0.xyz, r1.w, r0
add_pp r0.w, -r0, c8
exp_pp r1.w, r0.w
dp3_pp_sat r2.w, r1, r0
pow r0, r2.w, r1.w
mov_pp r0.zw, c2.xyxy
mul_pp r0.zw, c3.xyxy, r0
mul_pp r3.xyz, r5, r3
mul_pp r4.xyz, r2, r4
mul_pp r3.xyz, r0.z, r3
mad_pp r3.xyz, r4, r0.w, r3
mad r0.w, r1, c10.x, c10.y
mul_pp r2.xyz, r2, r0.w
mul_pp r0.xyz, r0.x, c0
dp3_pp_sat r0.w, r1, v5
mul_pp r1.xyz, r0, r2
mul_pp r0.xyz, r0.w, r5
mul_pp r0.xyz, r0, c0
mul_pp r1.xyz, r1, c9.x
mad_pp r1.xyz, r0, c8.x, r1
mul_pp r2.xyz, r5, v6
texldp r0.x, v7, s5
mad_pp r0.xyz, r1, r0.x, r2
add_pp oC0.xyz, r0, r3
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 5
SetTexture 2 [_SpecTex] 2D 3
SetTexture 3 [_SpecCubeIBL] CUBE 4
SetTexture 4 [_DiffCubeIBL] CUBE 2
SetTexture 5 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 308 [_Shininess]
Float 312 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedjlbddocfjikdkmmgekllmopdhommkmonabaaaaaajiakaaaaadaaaaaa
cmaaaaaacmabaaaagaabaaaaejfdeheopiaaaaaaajaaaaaaaiaaaaaaoaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaomaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaaomaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaaomaaaaaa
ahaaaaaaaaaaaaaaadaaaaaaaiaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcdaajaaaaeaaaaaaaemacaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaa
adaaaaaaffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagcbaaaadpcbabaaa
afaaaaaagcbaaaadhcbabaaaagaaaaaagcbaaaadhcbabaaaahaaaaaagcbaaaad
lcbabaaaaiaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaa
dcaaaaandcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaapgapbaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaaaebaaaaaaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaa
bkiacaiaebaaaaaaaaaaaaaabdaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaa
aaaaaaaibcaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaaaeb
bjaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaajccaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjccdoabeaaaaaidpjkcdoefaaaaajpcaabaaa
acaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaafaaaaaadcaaaaap
dcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahecaabaaa
abaaaaaaegaabaaaacaaaaaaegaabaaaacaaaaaaddaaaaahecaabaaaabaaaaaa
ckaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaaiecaabaaaabaaaaaackaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaacaaaaaackaabaaa
abaaaaaabacaaaahecaabaaaabaaaaaaegacbaaaacaaaaaaegbcbaaaacaaaaaa
aaaaaaaiecaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dcaaaaajicaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpdiaaaaahecaabaaaabaaaaaadkaabaaaabaaaaaackaabaaaabaaaaaa
dcaaaaajecaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaajkjjfjdpabeaaaaa
jkjjfjlpdcaaaaakecaabaaaabaaaaaackiacaaaaaaaaaaabdaaaaaackaabaaa
abaaaaaaabeaaaaaaaaaiadpdiaaaaaiecaabaaaabaaaaaackaabaaaabaaaaaa
akiacaaaaaaaaaaabdaaaaaadiaaaaaiecaabaaaabaaaaaackaabaaaabaaaaaa
dkiacaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
kgakbaaaabaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagajbaaa
aaaaaaaaaaaaaaahhcaabaaaadaaaaaaegbcbaaaacaaaaaaegbcbaaaagaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaa
acaaaaaaegacbaaaadaaaaaabacaaaahicaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaacpaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaafbcaabaaa
abaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaa
egacbaaaadaaaaaadiaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaabacaaaahicaabaaaabaaaaaaegacbaaa
acaaaaaaegbcbaaaagaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaadaaaaaa
egiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaadaaaaaa
pgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaeaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaeaaaaaaegiccaaa
aaaaaaaaabaaaaaaegacbaaaabaaaaaaaoaaaaahdcaabaaaaeaaaaaaegbabaaa
aiaaaaaapgbpbaaaaiaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaa
eghobaaaafaaaaaaaagabaaaaaaaaaaadiaaaaahocaabaaaaeaaaaaaagajbaaa
adaaaaaaagbjbaaaahaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaa
agaabaaaaeaaaaaajgahbaaaaeaaaaaabaaaaaahbcaabaaaaeaaaaaaegbcbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahccaabaaaaeaaaaaaegbcbaaaaeaaaaaa
egacbaaaacaaaaaabaaaaaahecaabaaaaeaaaaaaegbcbaaaafaaaaaaegacbaaa
acaaaaaadgaaaaafbcaabaaaacaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaa
acaaaaaadkbabaaaaeaaaaaadgaaaaafecaabaaaacaaaaaadkbabaaaafaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaaegacbaaaaeaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaaaacaaaaaa
efaaaaajpcaabaaaaeaaaaaaegacbaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaaeaaaaaapgapbaaaaeaaaaaaegacbaaaaeaaaaaa
diaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaaeiaaaaal
pcaabaaaacaaaaaaegacbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaa
acaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaajdcaabaaaacaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
aiaaaaaadiaaaaahncaabaaaacaaaaaaagaabaaaacaaaaaaagajbaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaacaaaaaaigadbaaa
acaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [_ShadowMapTexture] 2D 5
SetTexture 6 [unity_Lightmap] 2D 6
"ps_3_0
; 50 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c8, 8.00000000, 2.00000000, -1.00000000, 7.00000000
def c9, 0.50000000, 0.85009766, -0.84997559, 1.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0.yw, v0, s1
mad_pp r3.xy, r0.wyzw, c8.y, c8.z
mul_pp r0.xy, r3, r3
add_pp_sat r0.x, r0, r0.y
texld r2, v0, s2
add_pp r0.y, -r2.w, c9.w
mad_pp r0.w, -r0.y, r0.y, c9
add_pp r0.x, -r0, c9.w
rsq_pp r0.x, r0.x
rcp_pp r3.z, r0.x
mad_pp r0.w, -r0, c6.x, r0
dp3_pp r1.x, v2, r3
dp3_pp r1.y, r3, v3
dp3_pp r1.z, r3, v4
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r1.w, r1, r0
mul r4.xyz, r1, r1.w
texld r1, r1, s4
mad r0.xyz, -r4, c8.y, r0
mul_pp r4.xyz, r1, r1.w
add_pp r0.w, r0, c8
texldl r0, r0, s3
mul_pp r0.xyz, r0, r0.w
dp3_sat r0.w, r3, v1
add r0.w, -r0, c9
mad_pp r1.w, r0, c9.x, c9.x
mul_pp r1.w, r0, r1
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, c1.w
mul_pp r3.xyz, r1, r4
mov_pp r4.xy, c1
mul_pp r4.xy, c3, r4
mul_pp r4.xy, r4, c2
mul_pp r3.xyz, r4.x, r3
texldp r4.x, v6, s5
mov_pp r0.w, c9
mad_pp r1.w, r1, c9.y, c9.z
mad_pp r0.w, r1, c7.x, r0
mul_pp r0.w, r0, c5.x
mul_pp r0.w, r0, c1
mul_pp r2.xyz, r2, c0
mul_pp r2.xyz, r2, r0.w
mul_pp r0.xyz, r0, r2
mad_pp r2.xyz, r0, r4.y, r3
texld r0, v5, s6
mul_pp r3.xyz, r0.w, r0
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c8.x
mul_pp r0.xyz, r0, c8.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r1, r0, r2
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 5
SetTexture 2 [_SpecTex] 2D 3
SetTexture 3 [_SpecCubeIBL] CUBE 4
SetTexture 4 [_DiffCubeIBL] CUBE 2
SetTexture 5 [_ShadowMapTexture] 2D 0
SetTexture 6 [unity_Lightmap] 2D 6
ConstBuffer "$Globals" 352
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 308 [_Shininess]
Float 312 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedhgjobnpjpidgbdgmhbkmecednlackonfabaaaaaaeeajaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcpeahaaaaeaaaaaaapnabaaaafjaaaaaeegiocaaa
aaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafidaaaae
aahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaafibiaaae
aahabaaaagaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagcbaaaadlcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadgaaaaafbcaabaaaaaaaaaaa
dkbabaaaadaaaaaadgaaaaafccaabaaaaaaaaaaadkbabaaaaeaaaaaadgaaaaaf
ecaabaaaaaaaaaaadkbabaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaafaaaaaadcaaaaapdcaabaaaabaaaaaa
hgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaa
abaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaa
acaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaa
egbcbaaaafaaaaaaegacbaaaabaaaaaabacaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegbcbaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahbcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaiaebaaaaaa
abaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaacaaaaaa
eghobaaaaeaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaadaaaaaaaaaaaaaiicaabaaaabaaaaaadkaabaia
ebaaaaaaacaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaacaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaandcaabaaaadaaaaaapgapbaia
ebaaaaaaabaaaaaapgapbaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaebaaaaaaaa
aaaaaaaadcaaaaalicaabaaaabaaaaaabkiacaiaebaaaaaaaaaaaaaabdaaaaaa
akaabaaaadaaaaaabkaabaaaadaaaaaaeiaaaaalpcaabaaaadaaaaaaegacbaaa
aaaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaadcaaaaajicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaabaaaaaadcaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaak
icaabaaaaaaaaaaackiacaaaaaaaaaaabdaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaiadpdiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
bdaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaabcaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaj
dcaabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaa
diaaaaaidcaabaaaadaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaagaabaaaadaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaaabaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaaefaaaaaj
pcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
adaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaabaaaaaa
fgaobaaaabaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaa
abaaaaaaegacbaaaadaaaaaadeaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaa
egacbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [_ShadowMapTexture] 2D 5
SetTexture 6 [unity_Lightmap] 2D 6
SetTexture 7 [unity_LightmapInd] 2D 7
"ps_3_0
; 81 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
dcl_2d s7
def c8, 2.00000000, -1.00000000, 8.00000000, 7.00000000
def c9, -0.40824831, 0.70710677, 0.57735026, 0.50000000
def c10, 0.81649655, 0.00000000, 0.57735026, 1.00000000
def c11, -0.40824828, -0.70710677, 0.57735026, 0.12500000
def c12, 0.85009766, -0.84997559, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0.yw, v0, s1
mad_pp r3.xy, r0.wyzw, c8.x, c8.y
mul_pp r0.xy, r3, r3
add_pp_sat r0.x, r0, r0.y
add_pp r1.x, -r0, c10.w
texld r0, v5, s7
mul_pp r0.xyz, r0.w, r0
rsq_pp r1.x, r1.x
rcp_pp r3.z, r1.x
mul_pp r2.xyz, r0, c8.z
dp3_pp_sat r0.z, r3, c11
dp3_pp_sat r0.x, r3, c10
dp3_pp_sat r0.y, r3, c9
dp3_pp r1.w, r2, r0
texld r0, v5, s6
texldp r5.x, v6, s5
mul_pp r1.xyz, r0, r5.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r1.w
mul_pp r4.xyz, r0, c8.z
mul r0.xyz, r2.y, c9
mad r0.xyz, r2.x, c10, r0
mad r0.xyz, r2.z, c11, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul_pp r1.xyz, r1, c8.x
mul_pp r5.xyz, r4, r5.x
min_pp r1.xyz, r4, r1
max_pp r1.xyz, r1, r5
texld r5.xyz, v0, s0
mul_pp r2.xyz, r5, c4
mul_pp r5.xyz, r2, c1.w
mul_pp r6.xyz, r5, r1
texld r2, v0, s2
add_pp r0.w, -r2, c10
mad_pp r1.x, -r0.w, r0.w, c10.w
add_pp r0.xyz, r0, v1
dp3_pp r0.w, r0, r0
mad_pp r1.x, -r1, c6, r1
rsq_pp r0.w, r0.w
dp3_pp r1.z, r3, v4
dp3_sat r1.y, r3, v1
add_pp r1.w, r1.x, c8
mul_pp r0.xyz, r0.w, r0
add_pp r0.w, -r1, c8.z
dp3_pp_sat r1.x, r3, r0
exp_pp r3.w, r0.w
pow r0, r1.x, r3.w
add r0.y, -r1, c10.w
mad_pp r0.z, r0.y, c9.w, c9.w
mul_pp r0.y, r0, r0.z
mov r2.w, r0.x
dp3_pp r1.x, r3, v2
dp3_pp r1.y, r3, v3
mov_pp r0.x, c10.w
mad_pp r0.y, r0, c12.x, c12
mad_pp r4.w, r0.y, c7.x, r0.x
mul_pp r3.y, r4.w, c5.x
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r0.w, r1, r0
mul r7.xyz, r1, r0.w
mul_pp r3.y, r3, c1.w
mul_pp r2.xyz, r2, c0
mul_pp r2.xyz, r2, r3.y
mad r3.x, r3.w, c12.z, c12.w
mul_pp r3.xyz, r2, r3.x
mad r0.xyz, -r7, c8.x, r0
mov_pp r0.w, r1
texldl r0, r0, s3
mul_pp r7.xyz, r0, r0.w
texld r0, r1, s4
mov_pp r1.xy, c1
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xy, c3, r1
mul_pp r1.xy, r1, c2
mul_pp r0.xyz, r5, r0
mul_pp r0.xyz, r1.x, r0
mul_pp r2.xyz, r2, r7
mad_pp r0.xyz, r2, r1.y, r0
mul r3.xyz, r2.w, r3
mul r1.xyz, r3, c11.w
mad_pp r1.xyz, r1, r4, r6
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c10
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 5
SetTexture 2 [_SpecTex] 2D 3
SetTexture 3 [_SpecCubeIBL] CUBE 4
SetTexture 4 [_DiffCubeIBL] CUBE 2
SetTexture 5 [_ShadowMapTexture] 2D 0
SetTexture 6 [unity_Lightmap] 2D 6
SetTexture 7 [unity_LightmapInd] 2D 7
ConstBuffer "$Globals" 352
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 308 [_Shininess]
Float 312 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedekekjphkjhngjioamopkbaikmlfnnfjhabaaaaaaniamaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefciialaaaaeaaaaaaaocacaaaafjaaaaaeegiocaaa
aaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafkaaaaad
aagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaa
adaaaaaaffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaafibiaaaeaahabaaa
ahaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagcbaaaadpcbabaaaafaaaaaagcbaaaadlcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaandcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaapgapbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaeb
aaaaaaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
bdaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaaaebbjaaaaafbcaabaaaabaaaaaa
akaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
ahaaaaaaaagabaaaahaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaa
abaaaaaadiaaaaakhcaabaaaacaaaaaakgakbaaaabaaaaaaaceaaaaaomafnblo
pdaedfdpdkmnbddpaaaaaaaadcaaaaamhcaabaaaacaaaaaafgafbaaaabaaaaaa
aceaaaaaolaffbdpaaaaaaaadkmnbddpaaaaaaaaegacbaaaacaaaaaadcaaaaam
hcaabaaaacaaaaaapgapbaaaabaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaaj
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaacaaaaaaegbcbaaaacaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
acaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaafaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaa
adaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaacaaaaaaegaabaaaadaaaaaa
egaabaaaadaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaaabeaaaaa
aaaaiadpelaaaaafecaabaaaadaaaaaadkaabaaaacaaaaaabacaaaahbcaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaacpaaaaafbcaabaaaacaaaaaa
akaabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaaabaaaaaaakaabaaa
acaaaaaadcaaaaajbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaidpjccdo
abeaaaaaidpjkcdobjaaaaafbcaabaaaacaaaaaaakaabaaaacaaaaaadiaaaaah
bcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaaaaaaadobacaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegbcbaaaacaaaaaaaaaaaaaiccaabaaaacaaaaaa
bkaabaiaebaaaaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaajecaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahccaabaaa
acaaaaaackaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaajccaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakccaabaaa
acaaaaaackiacaaaaaaaaaaabdaaaaaabkaabaaaacaaaaaaabeaaaaaaaaaiadp
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaaakiacaaaaaaaaaaabdaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaadkiacaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaacaaaaaadiaaaaah
ocaabaaaacaaaaaaagaabaaaabaaaaaaagajbaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaaagaabaaaacaaaaaajgahbaaaacaaaaaaapcaaaakbcaabaaaaeaaaaaa
aceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaaadaaaaaabacaaaak
ccaabaaaaeaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaaegacbaaa
adaaaaaabacaaaakecaabaaaaeaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaeaaaaaa
jgahbaaaabaaaaaaefaaaaajpcaabaaaaeaaaaaaogbkbaaaabaaaaaaeghobaaa
agaaaaaaaagabaaaagaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaeaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaaeaaaaaafgafbaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaa
aoaaaaahdcaabaaaafaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaaj
pcaabaaaafaaaaaaegaabaaaafaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaa
aaaaaaahicaabaaaabaaaaaaakaabaaaafaaaaaaakaabaaaafaaaaaadiaaaaah
hcaabaaaafaaaaaaegacbaaaabaaaaaaagaabaaaafaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgapbaaaabaaaaaaddaaaaahhcaabaaaaeaaaaaa
egacbaaaabaaaaaaegacbaaaaeaaaaaadeaaaaahhcaabaaaaeaaaaaaegacbaaa
afaaaaaaegacbaaaaeaaaaaaefaaaaajpcaabaaaafaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaaafaaaaaaegacbaaa
afaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaaafaaaaaaegacbaaa
afaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaafaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
adaaaaaaegacbaaaadaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaaeaaaaaa
egacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaafaaaaaaegacbaaa
adaaaaaadgaaaaafbcaabaaaadaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaa
adaaaaaadkbabaaaaeaaaaaadgaaaaafecaabaaaadaaaaaadkbabaaaafaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaa
adaaaaaaegacbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaaaadaaaaaa
efaaaaajpcaabaaaacaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaaeiaaaaal
pcaabaaaadaaaaaaegacbaaaadaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaa
adaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaa
diaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
aiaaaaaadiaaaaaidcaabaaaadaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaa
aiaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaa
acaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
}
 }
}
SubShader { 
 LOD 400
 Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry" "RenderType"="Opaque" }
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_14;
  vec3 x2_17;
  vec3 x1_18;
  x1_18.x = dot (unity_SHAr, tmpvar_16);
  x1_18.y = dot (unity_SHAg, tmpvar_16);
  x1_18.z = dot (unity_SHAb, tmpvar_16);
  vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_14.xyzz * tmpvar_14.yzzx);
  x2_17.x = dot (unity_SHBr, tmpvar_19);
  x2_17.y = dot (unity_SHBg, tmpvar_19);
  x2_17.z = dot (unity_SHBb, tmpvar_19);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1_18 + x2_17) + (unity_SHC.xyz * ((tmpvar_14.x * tmpvar_14.x) - (tmpvar_14.y * tmpvar_14.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = exp2((8.0 - ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11))));
  vec3 tmpvar_13;
  tmpvar_13.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_13.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_13.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_13, tmpvar_2) * tmpvar_13))));
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_16;
  frag_16.w = 1.0;
  frag_16.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_16.xyz = (frag_16.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_12)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_12 * 0.159155) + 0.31831))));
  frag_16.xyz = frag_16.xyz;
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [unity_Scale]
Vector 22 [_MainTex_ST]
"vs_3_0
; 64 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c23.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r2.xyz, r1, c21.w, -v0
mul r1.xyz, v2, c21.w
dp3 r0.y, r2, r3
dp3 r0.x, r2, v1
dp3 r0.z, v2, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r2.w, r1, c5
mov r0.y, r2.w
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.w, c23.x
mul r1, r0.xyzz, r0.yzzx
dp4 r4.z, r0, c16
dp4 r4.y, r0, c15
dp4 r4.x, r0, c14
mul r2.w, r2, r2
dp4 r0.w, r1, c19
dp4 r0.z, r1, c18
dp4 r0.y, r1, c17
add r1.xyz, r4, r0.yzww
mad r0.x, r0, r0, -r2.w
mul r4.xyz, r0.x, c20
add o7.xyz, r1, r4
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
dp4 r4.y, c13, r0
mov r1, c8
dp4 r4.x, c13, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c21.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c21.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o6.y, r3, r4
mul o5, r0, c21.w
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c22, c22.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedlbkpioighddcmmbamejpcadgbihnghgpabaaaaaadealaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
faajaaaaeaaaabaafeacaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaa
giaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaa
fgafbaiaebaaaaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaia
ebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaaakaabaaa
aaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaadaaaaaaakiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaa
akiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaa
adaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
dgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaa
bkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaaaaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaacaaaaaa
aaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaa
pgipcaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaagaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaa
abaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaa
aaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
adaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaia
ebaaaaaaaaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_10.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_10.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_10, tmpvar_2) * tmpvar_10))));
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  c_1.xyz = (diff_4.xyz * ((8.0 * tmpvar_13.w) * tmpvar_13.xyz));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_11.xyz * tmpvar_11.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 38 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c13.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c13.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c13.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c13.w
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 256 [unity_LightmapST]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefieceddiicdeajojppbkmpjoafalgpibmaeeolabaaaaaadeaiaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiagaaaaeaaaabaajkabaaaafjaaaaaeegiocaaaaaaaaaaa
bcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaa
baaaaaaakgiocaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgafbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaal
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaacaaaaaaaoaaaaaa
kgakbaiaebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaa
akaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaacaaaaaaamaaaaaa
dgaaaaagccaabaaaadaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaa
adaaaaaaakiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
adaaaaaadiaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaadgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
acaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaacaaaaaaaoaaaaaa
baaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaa
egaobaaaabaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaa
ckiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaabaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaa
aaaaaaaapgipcaaaacaaaaaabeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = exp2((8.0 - ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11))));
  vec3 tmpvar_13;
  tmpvar_13.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_13.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_13.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_13, tmpvar_2) * tmpvar_13))));
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_LightmapInd, xlv_TEXCOORD5);
  mat3 tmpvar_18;
  tmpvar_18[0].x = 0.816497;
  tmpvar_18[0].y = -0.408248;
  tmpvar_18[0].z = -0.408248;
  tmpvar_18[1].x = 0.0;
  tmpvar_18[1].y = 0.707107;
  tmpvar_18[1].z = -0.707107;
  tmpvar_18[2].x = 0.57735;
  tmpvar_18[2].y = 0.57735;
  tmpvar_18[2].z = 0.57735;
  vec3 lm_19;
  vec3 tmpvar_20;
  tmpvar_20 = ((8.0 * tmpvar_17.w) * tmpvar_17.xyz);
  lm_19 = (((8.0 * tmpvar_16.w) * tmpvar_16.xyz) * dot (clamp ((tmpvar_18 * normal_6), 0.0, 1.0), tmpvar_20));
  vec3 v_21;
  v_21.x = tmpvar_18[0].x;
  v_21.y = tmpvar_18[1].x;
  v_21.z = tmpvar_18[2].x;
  vec3 v_22;
  v_22.x = tmpvar_18[0].y;
  v_22.y = tmpvar_18[1].y;
  v_22.z = tmpvar_18[2].y;
  vec3 v_23;
  v_23.x = tmpvar_18[0].z;
  v_23.y = tmpvar_18[1].z;
  v_23.z = tmpvar_18[2].z;
  c_1.xyz = ((((spec_3.xyz * ((tmpvar_12 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (dot (normal_6, normalize((normalize((((tmpvar_20.x * v_21) + (tmpvar_20.y * v_22)) + (tmpvar_20.z * v_23))) + xlv_TEXCOORD1))), 0.0, 1.0), tmpvar_12))) * lm_19) + (diff_4.xyz * lm_19));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 38 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c13.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c13.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c13.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c13.w
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 256 [unity_LightmapST]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefieceddiicdeajojppbkmpjoafalgpibmaeeolabaaaaaadeaiaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiagaaaaeaaaabaajkabaaaafjaaaaaeegiocaaaaaaaaaaa
bcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaa
baaaaaaakgiocaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgafbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaal
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaacaaaaaaaoaaaaaa
kgakbaiaebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaa
akaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaacaaaaaaamaaaaaa
dgaaaaagccaabaaaadaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaa
adaaaaaaakiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
adaaaaaadiaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaadgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
acaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaacaaaaaaaoaaaaaa
baaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaa
egaobaaaabaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaa
ckiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaabaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaa
aaaaaaaapgipcaaaacaaaaaabeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_15;
  vec3 x2_18;
  vec3 x1_19;
  x1_19.x = dot (unity_SHAr, tmpvar_17);
  x1_19.y = dot (unity_SHAg, tmpvar_17);
  x1_19.z = dot (unity_SHAb, tmpvar_17);
  vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_15.xyzz * tmpvar_15.yzzx);
  x2_18.x = dot (unity_SHBr, tmpvar_20);
  x2_18.y = dot (unity_SHBg, tmpvar_20);
  x2_18.z = dot (unity_SHBb, tmpvar_20);
  vec4 o_21;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_1 * 0.5);
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_21.xy = (tmpvar_23 + tmpvar_22.w);
  o_21.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_16).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1_19 + x2_18) + (unity_SHC.xyz * ((tmpvar_15.x * tmpvar_15.x) - (tmpvar_15.y * tmpvar_15.y))));
  xlv_TEXCOORD7 = o_21;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = exp2((8.0 - ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11))));
  vec3 tmpvar_13;
  tmpvar_13.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_13.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_13.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_13, tmpvar_2) * tmpvar_13))));
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_16;
  frag_16.w = 1.0;
  frag_16.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_16.xyz = (frag_16.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_12)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_12 * 0.159155) + 0.31831))));
  frag_16.xyz = (frag_16.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x);
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [unity_Scale]
Vector 24 [_MainTex_ST]
"vs_3_0
; 69 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c25, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c25.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r2.xyz, r1, c23.w, -v0
mul r1.xyz, v2, c23.w
dp3 r0.y, r2, r3
dp3 r0.x, r2, v1
dp3 r0.z, v2, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r2.w, r1, c5
mov r0.y, r2.w
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.w, c25.x
mul r1, r0.xyzz, r0.yzzx
dp4 r4.z, r0, c18
dp4 r4.y, r0, c17
dp4 r4.x, r0, c16
mul r2.w, r2, r2
dp4 r0.w, r1, c21
dp4 r0.z, r1, c20
dp4 r0.y, r1, c19
add r1.xyz, r4, r0.yzww
mad r0.x, r0, r0, -r2.w
mul r4.xyz, r0.x, c22
add o7.xyz, r1, r4
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c9
dp4 r4.y, c15, r0
mov r1, c8
dp4 r4.x, c15, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c23.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c23.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c23.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c13.x
dp3 o6.y, r3, r4
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c24, c24.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedklfpaacoeockigcfkcpcanihkhpicjolabaaaaaaoealaaaaadaaaaaa
cmaaaaaapeaaaaaapeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopiaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaomaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaomaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaomaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaomaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaahaaaaaaaaaaaaaaadaaaaaaaiaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoiajaaaaeaaaabaa
hkacaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaadpccabaaa
aiaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabeaaaaaaogikcaaaaaaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaadaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgbpbaaa
abaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaiaebaaaaaa
abaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaadcaaaaal
lcaabaaaabaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaiaebaaaaaaabaaaaaa
egambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaadgaaaaag
bcaabaaaaeaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaa
baaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaah
ecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaa
adaaaaaaegaobaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaaficaabaaa
acaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaeaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaa
egacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaa
abaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaa
abaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaa
abaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaa
bbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaa
bbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaa
bbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaah
ccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaa
dcaaaaakhccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaiaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaaiaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = _WorldSpaceCameraPos;
  vec4 o_15;
  vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_1 * 0.5);
  vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_15.xy = (tmpvar_17 + tmpvar_16.w);
  o_15.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_14).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_15;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_10.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_10.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_10, tmpvar_2) * tmpvar_10))));
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  c_1.xyz = (diff_4.xyz * max (min (tmpvar_15, ((tmpvar_13.x * 2.0) * tmpvar_14.xyz)), (tmpvar_15 * tmpvar_13.x)));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_11.xyz * tmpvar_11.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"vs_3_0
; 44 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c18.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c15.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.w, -r1, c4
dp3 r0.y, r2, c4
dp4 r1.w, v0, c3
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c15.w
dp3 r0.w, -r1, c5
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c15.w
dp3 r0.w, -r1, c6
dp4 r1.z, v0, c2
dp3 r0.y, r2, c6
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c18.y
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c15.w
mov r0.x, r2
mul r0.y, r2, c13.x
mad o7.xy, r2.z, c14.zwzw, r0
mov o0, r1
mov o7.zw, r1
mad o1.xy, v3, c17, c17.zwzw
mad o6.xy, v4, c16, c16.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 352
Vector 320 [unity_LightmapST]
Vector 336 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedmhmgbnlinjffeabcafombaigdgbgkphnabaaaaaaoeaiaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
aaahaaaaeaaaabaamaabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
afaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabfaaaaaaogikcaaaaaaaaaaabfaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabeaaaaaakgiocaaa
aaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaia
ebaaaaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaallcaabaaaabaaaaaaegiicaaaacaaaaaaaoaaaaaakgakbaiaebaaaaaa
abaaaaaaegambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaa
dgaaaaagbcaabaaaaeaaaaaaakiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaa
aeaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaa
acaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaa
aeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaa
baaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaaf
icaabaaaacaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaa
acaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaacaaaaaaanaaaaaa
dgaaaaagecaabaaaaeaaaaaabkiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaa
egbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaacaaaaaa
amaaaaaadgaaaaagccaabaaaacaaaaaackiacaaaacaaaaaaanaaaaaadgaaaaag
ecaabaaaacaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = _WorldSpaceCameraPos;
  vec4 o_15;
  vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_1 * 0.5);
  vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_15.xy = (tmpvar_17 + tmpvar_16.w);
  o_15.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_14).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_15;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = exp2((8.0 - ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11))));
  vec3 tmpvar_13;
  tmpvar_13.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_13.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_13.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_13, tmpvar_2) * tmpvar_13))));
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec4 tmpvar_18;
  tmpvar_18 = texture2D (unity_LightmapInd, xlv_TEXCOORD5);
  mat3 tmpvar_19;
  tmpvar_19[0].x = 0.816497;
  tmpvar_19[0].y = -0.408248;
  tmpvar_19[0].z = -0.408248;
  tmpvar_19[1].x = 0.0;
  tmpvar_19[1].y = 0.707107;
  tmpvar_19[1].z = -0.707107;
  tmpvar_19[2].x = 0.57735;
  tmpvar_19[2].y = 0.57735;
  tmpvar_19[2].z = 0.57735;
  vec3 lm_20;
  vec3 tmpvar_21;
  tmpvar_21 = ((8.0 * tmpvar_18.w) * tmpvar_18.xyz);
  lm_20 = (((8.0 * tmpvar_17.w) * tmpvar_17.xyz) * dot (clamp ((tmpvar_19 * normal_6), 0.0, 1.0), tmpvar_21));
  vec3 v_22;
  v_22.x = tmpvar_19[0].x;
  v_22.y = tmpvar_19[1].x;
  v_22.z = tmpvar_19[2].x;
  vec3 v_23;
  v_23.x = tmpvar_19[0].y;
  v_23.y = tmpvar_19[1].y;
  v_23.z = tmpvar_19[2].y;
  vec3 v_24;
  v_24.x = tmpvar_19[0].z;
  v_24.y = tmpvar_19[1].z;
  v_24.z = tmpvar_19[2].z;
  c_1.xyz = ((((spec_3.xyz * ((tmpvar_12 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (dot (normal_6, normalize((normalize((((tmpvar_21.x * v_22) + (tmpvar_21.y * v_23)) + (tmpvar_21.z * v_24))) + xlv_TEXCOORD1))), 0.0, 1.0), tmpvar_12))) * lm_20) + (diff_4.xyz * max (min (lm_20, ((tmpvar_16.x * 2.0) * tmpvar_17.xyz)), (lm_20 * tmpvar_16.x))));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"vs_3_0
; 44 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c18.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c15.w, -v0
dp3 r0.y, r1, r2
dp3 r0.x, r1, v1
dp3 r0.z, v2, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp3 r0.w, -r1, c4
dp3 r0.y, r2, c4
dp4 r1.w, v0, c3
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c15.w
dp3 r0.w, -r1, c5
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c15.w
dp3 r0.w, -r1, c6
dp4 r1.z, v0, c2
dp3 r0.y, r2, c6
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c18.y
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c15.w
mov r0.x, r2
mul r0.y, r2, c13.x
mad o7.xy, r2.z, c14.zwzw, r0
mov o0, r1
mov o7.zw, r1
mad o1.xy, v3, c17, c17.zwzw
mad o6.xy, v4, c16, c16.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 352
Vector 320 [unity_LightmapST]
Vector 336 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedmhmgbnlinjffeabcafombaigdgbgkphnabaaaaaaoeaiaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
aaahaaaaeaaaabaamaabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaac
afaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabfaaaaaaogikcaaaaaaaaaaabfaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabeaaaaaakgiocaaa
aaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaia
ebaaaaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaallcaabaaaabaaaaaaegiicaaaacaaaaaaaoaaaaaakgakbaiaebaaaaaa
abaaaaaaegambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaa
dgaaaaagbcaabaaaaeaaaaaaakiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaa
aeaaaaaaakiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaa
acaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaa
aeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaa
baaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaaf
icaabaaaacaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaa
acaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaacaaaaaaanaaaaaa
dgaaaaagecaabaaaaeaaaaaabkiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaa
egbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaa
acaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaacaaaaaa
amaaaaaadgaaaaagccaabaaaacaaaaaackiacaaaacaaaaaaanaaaaaadgaaaaag
ecaabaaaacaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  vec3 tmpvar_4;
  vec3 tmpvar_5;
  tmpvar_4 = TANGENT.xyz;
  tmpvar_5 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = gl_Normal.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = gl_Normal.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = gl_Normal.z;
  vec4 v_7;
  v_7.x = _Object2World[0].x;
  v_7.y = _Object2World[1].x;
  v_7.z = _Object2World[2].x;
  v_7.w = _Object2World[3].x;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_7.xyz);
  tmpvar_8.w = tmpvar_3.x;
  vec4 v_9;
  v_9.x = _Object2World[0].y;
  v_9.y = _Object2World[1].y;
  v_9.z = _Object2World[2].y;
  v_9.w = _Object2World[3].y;
  vec4 tmpvar_10;
  tmpvar_10.xyz = (tmpvar_6 * v_9.xyz);
  tmpvar_10.w = tmpvar_3.y;
  vec4 v_11;
  v_11.x = _Object2World[0].z;
  v_11.y = _Object2World[1].z;
  v_11.z = _Object2World[2].z;
  v_11.w = _Object2World[3].z;
  vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_6 * v_11.xyz);
  tmpvar_12.w = tmpvar_3.z;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_14;
  vec3 x2_17;
  vec3 x1_18;
  x1_18.x = dot (unity_SHAr, tmpvar_16);
  x1_18.y = dot (unity_SHAg, tmpvar_16);
  x1_18.z = dot (unity_SHAb, tmpvar_16);
  vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_14.xyzz * tmpvar_14.yzzx);
  x2_17.x = dot (unity_SHBr, tmpvar_19);
  x2_17.y = dot (unity_SHBg, tmpvar_19);
  x2_17.z = dot (unity_SHBb, tmpvar_19);
  vec3 tmpvar_20;
  tmpvar_20 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_21;
  tmpvar_21 = (unity_4LightPosX0 - tmpvar_20.x);
  vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosY0 - tmpvar_20.y);
  vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosZ0 - tmpvar_20.z);
  vec4 tmpvar_24;
  tmpvar_24 = (((tmpvar_21 * tmpvar_21) + (tmpvar_22 * tmpvar_22)) + (tmpvar_23 * tmpvar_23));
  vec4 tmpvar_25;
  tmpvar_25 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_21 * tmpvar_14.x) + (tmpvar_22 * tmpvar_14.y)) + (tmpvar_23 * tmpvar_14.z)) * inversesqrt(tmpvar_24))) * (1.0/((1.0 + (tmpvar_24 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_6 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_10 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_12 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1_18 + x2_17) + (unity_SHC.xyz * ((tmpvar_14.x * tmpvar_14.x) - (tmpvar_14.y * tmpvar_14.y)))) + ((((unity_LightColor[0].xyz * tmpvar_25.x) + (unity_LightColor[1].xyz * tmpvar_25.y)) + (unity_LightColor[2].xyz * tmpvar_25.z)) + (unity_LightColor[3].xyz * tmpvar_25.w)));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = exp2((8.0 - ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11))));
  vec3 tmpvar_13;
  tmpvar_13.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_13.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_13.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_13, tmpvar_2) * tmpvar_13))));
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_16;
  frag_16.w = 1.0;
  frag_16.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_16.xyz = (frag_16.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_12)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_12 * 0.159155) + 0.31831))));
  frag_16.xyz = frag_16.xyz;
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Vector 29 [unity_Scale]
Vector 30 [_MainTex_ST]
"vs_3_0
; 95 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c31, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c29.w
dp4 r0.x, v0, c5
add r1, -r0.x, c15
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c31.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c16
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c17
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c24
dp4 r2.y, r4, c23
dp4 r2.x, r4, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mul r1, r4.xyzz, r4.yzzx
mad r0.xyz, r0.w, c21, r0
mul r0.w, r3, r3
mad r0.w, r4.x, r4.x, -r0
dp4 r3.z, r1, c27
dp4 r3.y, r1, c26
dp4 r3.x, r1, c25
add r1.xyz, r2, r3
mov r2.xyz, v1
mul r3.xyz, v2.zxyw, r2.yzxw
mul r4.xyz, r0.w, c28
add r4.xyz, r1, r4
mov r2.xyz, v1
mad r2.xyz, v2.yzxw, r2.zxyw, -r3
mul r3.xyz, r2, v1.w
mov r1.xyz, c12
mov r1.w, c31.x
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c29.w, -v0
add o7.xyz, r4, r0
dp3 r1.y, r2, r3
dp3 r1.x, r2, v1
dp3 r1.z, v2, r2
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
dp4 r4.y, c13, r0
mul o2.xyz, r1.w, r1
mov r1, c8
dp4 r4.x, c13, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c29.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c29.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o6.y, r3, r4
mul o5, r0, c29.w
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c30, c30.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedaimoojoccmejgnlaapiiobjmafgpkjaiabaaaaaaieaoaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
kaamaaaaeaaaabaaciadaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaa
giaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
adaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaajgbebaaaabaaaaaa
cgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaaacaaaaaacgbjbaaa
abaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaa
fgafbaiaebaaaaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaiaebaaaaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaallcaabaaaaaaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaia
ebaaaaaaaaaaaaaaegambaaaaaaaaaaadgaaaaaficaabaaaabaaaaaaakaabaaa
aaaaaaaadgaaaaagbcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaadaaaaaaakiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaa
akiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaaegacbaaa
adaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaadaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
dgaaaaaficaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaagbcaabaaaadaaaaaa
bkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaaaaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaacaaaaaa
aaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaa
pgipcaaaacaaaaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaagaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaa
abaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaa
egacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
hcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
abaaaaaaegadbaaaabaaaaaabbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
adaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakicaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaa
egiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaa
egaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaa
adaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaaaaaaaaajpcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaa
egiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaa
agaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaa
egaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaa
acaaaaaaegaobaaaacaaaaaaegaobaaaacaaaaaaegaobaaaadaaaaaaeeaaaaaf
pcaabaaaadaaaaaaegaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaa
acaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaacaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaa
acaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
agaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaahhccabaaaahaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  vec3 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_5 = TANGENT.xyz;
  tmpvar_6 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = gl_Normal.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = gl_Normal.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = gl_Normal.z;
  vec4 v_8;
  v_8.x = _Object2World[0].x;
  v_8.y = _Object2World[1].x;
  v_8.z = _Object2World[2].x;
  v_8.w = _Object2World[3].x;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_7 * v_8.xyz);
  tmpvar_9.w = tmpvar_4.x;
  vec4 v_10;
  v_10.x = _Object2World[0].y;
  v_10.y = _Object2World[1].y;
  v_10.z = _Object2World[2].y;
  v_10.w = _Object2World[3].y;
  vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_7 * v_10.xyz);
  tmpvar_11.w = tmpvar_4.y;
  vec4 v_12;
  v_12.x = _Object2World[0].z;
  v_12.y = _Object2World[1].z;
  v_12.z = _Object2World[2].z;
  v_12.w = _Object2World[3].z;
  vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_7 * v_12.xyz);
  tmpvar_13.w = tmpvar_4.z;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_15;
  vec3 x2_18;
  vec3 x1_19;
  x1_19.x = dot (unity_SHAr, tmpvar_17);
  x1_19.y = dot (unity_SHAg, tmpvar_17);
  x1_19.z = dot (unity_SHAb, tmpvar_17);
  vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_15.xyzz * tmpvar_15.yzzx);
  x2_18.x = dot (unity_SHBr, tmpvar_20);
  x2_18.y = dot (unity_SHBg, tmpvar_20);
  x2_18.z = dot (unity_SHBb, tmpvar_20);
  vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_15.x) + (tmpvar_23 * tmpvar_15.y)) + (tmpvar_24 * tmpvar_15.z)) * inversesqrt(tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  vec4 o_27;
  vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_1 * 0.5);
  vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_28.x;
  tmpvar_29.y = (tmpvar_28.y * _ProjectionParams.x);
  o_27.xy = (tmpvar_29 + tmpvar_28.w);
  o_27.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize((tmpvar_7 * (((_World2Object * tmpvar_16).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD2 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_11 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_13 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1_19 + x2_18) + (unity_SHC.xyz * ((tmpvar_15.x * tmpvar_15.x) - (tmpvar_15.y * tmpvar_15.y)))) + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  xlv_TEXCOORD7 = o_27;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D _BumpMap;
uniform samplerCube _SpecCubeIBL;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec3 tmpvar_2;
  tmpvar_2.x = xlv_TEXCOORD2.w;
  tmpvar_2.y = xlv_TEXCOORD3.w;
  tmpvar_2.z = xlv_TEXCOORD4.w;
  vec4 spec_3;
  vec4 diff_4;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * ExposureIBL.w);
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt((1.0 - clamp (dot (normal_6.xy, normal_6.xy), 0.0, 1.0)));
  vec3 tmpvar_7;
  tmpvar_7.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_7.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_7.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_8.w;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_8.xyz * _SpecColor.xyz);
  spec_3.xyz = (spec_3.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_9 * (0.5 + (0.5 * tmpvar_9))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_10;
  tmpvar_10 = (1.0 - tmpvar_8.w);
  float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  float tmpvar_12;
  tmpvar_12 = exp2((8.0 - ((7.0 + tmpvar_11) - (_Shininess * tmpvar_11))));
  vec3 tmpvar_13;
  tmpvar_13.x = dot (xlv_TEXCOORD2.xyz, normal_6);
  tmpvar_13.y = dot (xlv_TEXCOORD3.xyz, normal_6);
  tmpvar_13.z = dot (xlv_TEXCOORD4.xyz, normal_6);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_SpecCubeIBL, (tmpvar_2 - (2.0 * (dot (tmpvar_13, tmpvar_2) * tmpvar_13))));
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_7);
  vec4 frag_16;
  frag_16.w = 1.0;
  frag_16.xyz = (((2.0 * clamp (dot (normal_6, xlv_TEXCOORD5), 0.0, 1.0)) * diff_4.xyz) * _LightColor0.xyz);
  frag_16.xyz = (frag_16.xyz + ((0.5 * (vec3(pow (clamp (dot (normal_6, normalize((xlv_TEXCOORD1 + xlv_TEXCOORD5))), 0.0, 1.0), tmpvar_12)) * _LightColor0.xyz)) * (spec_3.xyz * ((tmpvar_12 * 0.159155) + 0.31831))));
  frag_16.xyz = (frag_16.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x);
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (diff_4.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * tmpvar_8.w) * spec_3.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * xlat_mutableExposureIBL.x)));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [unity_Scale]
Vector 32 [_MainTex_ST]
"vs_3_0
; 100 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c33, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c31.w
dp4 r0.x, v0, c5
add r1, -r0.x, c17
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c16
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c18
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c19
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
dp4 r2.z, r4, c26
dp4 r2.y, r4, c25
dp4 r2.x, r4, c24
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r0.xyz, r0.z, c22, r1
mul r1, r4.xyzz, r4.yzzx
mad r0.xyz, r0.w, c23, r0
mul r0.w, r3, r3
mad r0.w, r4.x, r4.x, -r0
dp4 r3.z, r1, c29
dp4 r3.y, r1, c28
dp4 r3.x, r1, c27
add r1.xyz, r2, r3
mov r2.xyz, v1
mul r3.xyz, v2.zxyw, r2.yzxw
mul r4.xyz, r0.w, c30
add r4.xyz, r1, r4
mov r2.xyz, v1
mad r2.xyz, v2.yzxw, r2.zxyw, -r3
mul r3.xyz, r2, v1.w
mov r1.xyz, c12
mov r1.w, c33.x
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c31.w, -v0
add o7.xyz, r4, r0
dp3 r1.y, r2, r3
dp3 r1.x, r2, v1
dp3 r1.z, v2, r2
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c9
dp4 r4.y, c15, r0
mul o2.xyz, r1.w, r1
mov r1, c8
dp4 r4.x, c15, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c31.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c31.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c31.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c13.x
dp3 o6.y, r3, r4
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c32, c32.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedbnhifhamfjhedgaiaacnhnoooliopaehabaaaaaadeapaaaaadaaaaaa
cmaaaaaapeaaaaaapeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopiaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaomaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaomaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaomaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaomaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaahaaaaaaaaaaaaaaadaaaaaaaiaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcdianaaaaeaaaabaa
eoadaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaadpccabaaa
aiaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabeaaaaaaogikcaaaaaaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaadaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaahhcaabaaaadaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaa
dcaaaaakhcaabaaaadaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaia
ebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgbpbaaa
abaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaajhcaabaaaacaaaaaafgafbaiaebaaaaaa
abaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaallcaabaaaabaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaiaebaaaaaaabaaaaaaegaibaaaacaaaaaadcaaaaal
lcaabaaaabaaaaaaegiicaaaadaaaaaaaoaaaaaakgakbaiaebaaaaaaabaaaaaa
egambaaaabaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaaabaaaaaadgaaaaag
bcaabaaaaeaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaeaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaeaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaa
baaaaaahbcaabaaaacaaaaaaegbcbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaah
ecaabaaaacaaaaaaegbcbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaaipccabaaa
adaaaaaaegaobaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaaficaabaaa
acaaaaaabkaabaaaabaaaaaadgaaaaagbcaabaaaaeaaaaaabkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaeaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaeaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaacaaaaaa
egacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaaeaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaaipccabaaaaeaaaaaaegaobaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahccaabaaaabaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaahecaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadiaaaaaipccabaaaafaaaaaaegaobaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegbcbaaaabaaaaaaegacbaaa
abaaaaaabaaaaaaheccabaaaagaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaacaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaadaaaaaa
fgafbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaa
acaaaaaabbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaa
abaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaa
abaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaa
abaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaa
bbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaa
bbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaa
bbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaah
icaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaihcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaa
adaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaa
aaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaa
adaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaa
diaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaaj
pcaabaaaagaaaaaaagaabaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaacaaaaaa
aaaaaaajpcaabaaaadaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaa
aeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaaagaabaaaabaaaaaa
egaobaaaafaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaakgakbaaa
abaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaagaaaaaa
egaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaadaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaa
egaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaa
acaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
adaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaa
deaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaa
abaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
ahaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaa
abaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
aiaaaaaakgakbaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaah
hccabaaaahaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaaiaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaiaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [ExposureIBL]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
"ps_3_0
; 63 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
def c8, 2.00000000, -1.00000000, 0.50000000, 1.00000000
def c9, 0.85009766, -0.84997559, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
texld r1, v0, s2
texld r0.yw, v0, s1
mad_pp r3.xy, r0.wyzw, c8.x, c8.y
mul_pp r2.xy, r3, r3
add_pp_sat r0.w, r2.x, r2.y
add_pp r0.x, -r1.w, c8.w
mad_pp r0.x, -r0, r0, c8.w
mad_pp r2.z, -r0.x, c6.x, r0.x
mov_pp r0.xyz, v5
add_pp r0.xyz, v1, r0
dp3_pp r2.x, r0, r0
rsq_pp r2.x, r2.x
add_pp r0.w, -r0, c8
rsq_pp r0.w, r0.w
rcp_pp r3.z, r0.w
mul_pp r0.xyz, r2.x, r0
dp3_pp_sat r2.x, r3, r0
add_pp r0.x, -r2.z, c8.w
dp3_sat r0.y, r3, v1
exp_pp r2.y, r0.x
add r2.z, -r0.y, c8.w
pow r0, r2.x, r2.y
mad_pp r0.y, r2.z, c8.z, c8.z
mul_pp r0.z, r2, r0.y
mad_pp r0.z, r0, c9.x, c9.y
mov_pp r0.y, c8.w
mad_pp r0.y, r0.z, c7.x, r0
mul_pp r0.y, r0, c5.x
mad r0.z, r2.y, c9, c9.w
mul_pp r0.y, r0, c2.w
mul_pp r1.xyz, r1, c1
mul_pp r4.xyz, r1, r0.y
mul_pp r1.xyz, r4, r0.z
mul_pp r0.xyz, r0.x, c0
mul_pp r2.xyz, r0, r1
mul_pp r5.xyz, r2, c8.z
texld r2.xyz, v0, s0
mul_pp r2.xyz, r2, c4
dp3_pp r1.x, r3, v2
dp3_pp r1.y, r3, v3
dp3_pp r1.z, r3, v4
mul_pp r2.xyz, r2, c2.w
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r0.w, r1, r0
mul r6.xyz, r1, r0.w
dp3_pp_sat r0.w, r3, v5
mul_pp r3.xyz, r2, r0.w
mad r0.xyz, -r6, c8.x, r0
mul_pp r3.xyz, r3, c0
texld r0, r0, s3
mad_pp r3.xyz, r3, c8.x, r5
mul_pp r5.xyz, r0, r0.w
texld r0, r1, s4
mul_pp r1.xyz, r1.w, r5
mul_pp r0.xyz, r0, r0.w
mov_pp r5.xy, c2
mul_pp r5.xy, c3, r5
mul_pp r0.xyz, r2, r0
mul_pp r1.xyz, r4, r1
mul_pp r0.xyz, r5.x, r0
mad_pp r0.xyz, r1, r5.y, r0
mad_pp r1.xyz, r2, v6, r3
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c8
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 4
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 1
ConstBuffer "$Globals" 272
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 244 [_Shininess]
Float 248 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmobacadmbmdacopkgeebapohmiegccgdabaaaaaabaakaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcmaaiaaaaeaaaaaaadaacaaaafjaaaaaeegiocaaa
aaaaaaaabaaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagcbaaaadpcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagcbaaaad
hcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaadgaaaaaf
bcaabaaaaaaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaaaaaaaaaadkbabaaa
aeaaaaaadgaaaaafecaabaaaaaaaaaaadkbabaaaafaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaeaaaaaadcaaaaap
dcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaa
aaaaaaaaegaabaaaabaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaadkaabaaa
aaaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaa
baaaaaahccaabaaaacaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaah
ecaabaaaacaaaaaaegbcbaaaafaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaa
acaaaaaapgapbaiaebaaaaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaa
acaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaaaagabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaa
aaaaaaaaegacbaaaaaaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaadaaaaaabacaaaahicaabaaa
aaaaaaaaegacbaaaabaaaaaaegbcbaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkaabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakicaabaaa
aaaaaaaackiacaaaaaaaaaaaapaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaadaaaaaaegacbaaaadaaaaaaegiccaaaaaaaaaaaacaaaaaa
aaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadp
dcaaaaandcaabaaaaeaaaaaapgapbaiaebaaaaaaabaaaaaapgapbaaaabaaaaaa
aceaaaaaaaaaiadpaaaaaaebaaaaaaaaaaaaaaaadcaaaaalicaabaaaabaaaaaa
bkiacaiaebaaaaaaaaaaaaaaapaaaaaaakaabaaaaeaaaaaabkaabaaaaeaaaaaa
aaaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaaaeb
bjaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaa
pgapbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaaeaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaaeaaaaaaegacbaaa
aeaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaaeaaaaaaegacbaaa
aeaaaaaapgipcaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegacbaaaaeaaaaaadiaaaaajdcaabaaaafaaaaaaegiacaaaaaaaaaaa
adaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaagaabaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
fgafbaaaafaaaaaaegacbaaaacaaaaaaaaaaaaahhcaabaaaacaaaaaaegbcbaaa
acaaaaaaegbcbaaaagaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaabacaaaahicaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabacaaaahbcaabaaaabaaaaaa
egacbaaaabaaaaaaegbcbaaaagaaaaaaaaaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaeaaaaaa
agaabaaaabaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaabaaaaaadcaaaaajicaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaidpjccdoabeaaaaaidpjkcdodiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaadaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaacaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaaeaaaaaaegbcbaaaahaaaaaaegacbaaaabaaaaaaaaaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [unity_Lightmap] 2D 5
"ps_3_0
; 42 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
def c7, 2.00000000, -1.00000000, 0.50000000, 1.00000000
def c8, 0.85009766, -0.84997559, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0.yw, v0, s1
mad_pp r2.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c7.w
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
mov_pp r4.xy, c1
mul_pp r4.xy, c3, r4
dp3_pp r0.x, v2, r2
dp3_pp r0.y, r2, v3
dp3_pp r0.z, r2, v4
dp3_sat r1.w, r2, v1
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r0.w, r0, r1
mul r2.xyz, r0, r0.w
add r0.w, -r1, c7
mad r1.xyz, -r2, c7.x, r1
mad_pp r2.x, r0.w, c7.z, c7.z
mul_pp r2.x, r0.w, r2
texld r1, r1, s3
mad_pp r2.x, r2, c8, c8.y
mov_pp r0.w, c7
mad_pp r0.w, r2.x, c6.x, r0
mul_pp r2.xyz, r1, r1.w
texld r1, v0, s2
mul_pp r0.w, r0, c5.x
mul_pp r0.w, r0, c1
mul_pp r1.xyz, r1, c0
mul_pp r1.xyz, r1, r0.w
texld r0, r0, s4
mul_pp r2.xyz, r2, r1.w
mul_pp r2.xyz, r2, r1
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c1.w
mul_pp r3.xyz, r1, r0
mul_pp r4.xy, r4, c2
texld r0, v5, s5
mul_pp r3.xyz, r4.x, r3
mul_pp r0.xyz, r0.w, r0
mad_pp r2.xyz, r2, r4.y, r3
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c8.z, r2
mov_pp oC0.w, c7
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 4
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 1
SetTexture 5 [unity_Lightmap] 2D 5
ConstBuffer "$Globals" 288
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 248 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkmablddelofginfhgcfomjpikccecphhabaaaaaammahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeagaaaaeaaaaaaakfabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafidaaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadgaaaaafbcaabaaaaaaaaaaa
dkbabaaaadaaaaaadgaaaaafccaabaaaaaaaaaaadkbabaaaaeaaaaaadgaaaaaf
ecaabaaaaaaaaaaadkbabaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaabaaaaaa
hgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaa
abaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaa
acaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaa
egbcbaaaafaaaaaaegacbaaaabaaaaaabacaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegbcbaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahbcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaiaebaaaaaa
abaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaacaaaaaa
eghobaaaaeaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaaaaaaaaaa
eghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
acaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaaaaaaaaaacaaaaaadcaaaaajicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkaabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakicaabaaaaaaaaaaackiacaaa
aaaaaaaaapaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaapgipcaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajdcaabaaaadaaaaaaegiacaaa
aaaaaaaaadaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaaidcaabaaaadaaaaaa
egaabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaafgafbaaaadaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaabaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgapbaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
"ps_3_0
; 75 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c8, 2.00000000, -1.00000000, 8.00000000, 0.50000000
def c9, -0.40824831, 0.70710677, 0.57735026, 1.00000000
def c10, 0.81649655, 0.00000000, 0.57735026, 0.12500000
def c11, -0.40824828, -0.70710677, 0.57735026, 0
def c12, 0.85009766, -0.84997559, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0, v5, s6
mul_pp r0.xyz, r0.w, r0
mul_pp r5.xyz, r0, c8.z
mul r0.xyz, r5.y, c9
mad r0.xyz, r5.x, c10, r0
mad r0.xyz, r5.z, c11, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
texld r0.yw, v0, s1
mad_pp r4.xy, r0.wyzw, c8.x, c8.y
add_pp r1.xyz, r1, v1
mul_pp r0.xy, r4, r4
dp3_pp r0.z, r1, r1
add_pp_sat r0.w, r0.x, r0.y
rsq_pp r0.z, r0.z
mul_pp r0.xyz, r0.z, r1
texld r1, v0, s2
add_pp r0.w, -r0, c9
rsq_pp r0.w, r0.w
rcp_pp r4.z, r0.w
dp3_pp_sat r4.w, r4, r0
add_pp r2.x, -r1.w, c9.w
mad_pp r0.w, -r2.x, r2.x, c9
mad_pp r0.w, -r0, c6.x, r0
add_pp r0.w, -r0, c9
mov_pp r6.xy, c1
mul_pp r6.xy, c3, r6
dp3_pp r3.x, r4, v2
dp3_pp r3.y, r4, v3
dp3_pp r3.z, r4, v4
exp_pp r3.w, r0.w
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r2.x, r3, r0
mul r2.xyz, r3, r2.x
mad r0.xyz, -r2, c8.x, r0
texld r2, r0, s3
pow r0, r4.w, r3.w
mul_pp r2.xyz, r2, r2.w
mul_pp r0.yzw, r1.w, r2.xxyz
texld r2, r3, s4
mul_pp r3.xyz, r2, r2.w
dp3_sat r1.w, r4, v1
add r1.w, -r1, c9
mad_pp r2.w, r1, c8, c8
mul_pp r1.w, r1, r2
mad_pp r2.w, r1, c12.x, c12.y
texld r2.xyz, v0, s0
mul_pp r2.xyz, r2, c4
mul_pp r2.xyz, r2, c1.w
mov_pp r1.w, c9
mad_pp r1.w, r2, c7.x, r1
mul_pp r1.w, r1, c5.x
mul_pp r3.xyz, r2, r3
mul_pp r6.xy, r6, c2
mul_pp r1.w, r1, c1
mul_pp r1.xyz, r1, c0
mul_pp r1.xyz, r1, r1.w
mov r1.w, r0.x
mul_pp r0.yzw, r1.xxyz, r0
mul_pp r3.xyz, r6.x, r3
mad_pp r3.xyz, r0.yzww, r6.y, r3
mad r2.w, r3, c12.z, c12
mul_pp r1.xyz, r1, r2.w
mul r1.xyz, r1.w, r1
dp3_pp_sat r0.z, r4, c11
dp3_pp_sat r0.x, r4, c10
dp3_pp_sat r0.y, r4, c9
dp3_pp r4.x, r5, r0
texld r0, v5, s5
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r4.x
mul_pp r0.xyz, r0, c8.z
mul_pp r2.xyz, r0, r2
mul r1.xyz, r1, c10.w
mad_pp r0.xyz, r1, r0, r2
add_pp oC0.xyz, r0, r3
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 4
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 1
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
ConstBuffer "$Globals" 288
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 244 [_Shininess]
Float 248 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedikgachgnnpihllhlbndmjjcjmgpaiojiabaaaaaaoaalaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckiakaaaaeaaaaaaakkacaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaa
adaaaaaagcbaaaadpcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaaibcaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaandcaabaaaabaaaaaa
agaabaiaebaaaaaaabaaaaaaagaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaeb
aaaaaaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaabkiacaiaebaaaaaaaaaaaaaa
apaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaaaebbjaaaaafbcaabaaaabaaaaaa
akaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
agaaaaaaaagabaaaagaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaa
abaaaaaadiaaaaakhcaabaaaacaaaaaakgakbaaaabaaaaaaaceaaaaaomafnblo
pdaedfdpdkmnbddpaaaaaaaadcaaaaamhcaabaaaacaaaaaafgafbaaaabaaaaaa
aceaaaaaolaffbdpaaaaaaaadkmnbddpaaaaaaaaegacbaaaacaaaaaadcaaaaam
hcaabaaaacaaaaaapgapbaaaabaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaaj
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaacaaaaaaegbcbaaaacaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
acaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaeaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaa
adaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaacaaaaaaegaabaaaadaaaaaa
egaabaaaadaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaaabeaaaaa
aaaaiadpelaaaaafecaabaaaadaaaaaadkaabaaaacaaaaaabacaaaahbcaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaacpaaaaafbcaabaaaacaaaaaa
akaabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaaabaaaaaaakaabaaa
acaaaaaadcaaaaajbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaidpjccdo
abeaaaaaidpjkcdobjaaaaafbcaabaaaacaaaaaaakaabaaaacaaaaaadiaaaaah
bcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaaaaaaadodiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaabacaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegbcbaaaacaaaaaaaaaaaaaiccaabaaaacaaaaaa
bkaabaiaebaaaaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaajecaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahccaabaaa
acaaaaaackaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaajccaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakccaabaaa
acaaaaaackiacaaaaaaaaaaaapaaaaaabkaabaaaacaaaaaaabeaaaaaaaaaiadp
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaaakiacaaaaaaaaaaaapaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaadkiacaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaacaaaaaadiaaaaah
ocaabaaaacaaaaaaagaabaaaabaaaaaaagajbaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaaagaabaaaacaaaaaajgahbaaaacaaaaaaapcaaaakbcaabaaaaeaaaaaa
aceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaaadaaaaaabacaaaak
ccaabaaaaeaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaaegacbaaa
adaaaaaabacaaaakecaabaaaaeaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaeaaaaaa
jgahbaaaabaaaaaaefaaaaajpcaabaaaaeaaaaaaogbkbaaaabaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaeaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaaeaaaaaafgafbaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaa
efaaaaajpcaabaaaaeaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaaihcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaaaaaaaaaa
aoaaaaaadiaaaaaihcaabaaaaeaaaaaaegacbaaaaeaaaaaapgipcaaaaaaaaaaa
adaaaaaadiaaaaahhcaabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaaeaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
afaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaadaaaaaa
baaaaaahccaabaaaacaaaaaaegbcbaaaaeaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaacaaaaaaegbcbaaaafaaaaaaegacbaaaadaaaaaadgaaaaafbcaabaaa
adaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaaadaaaaaadkbabaaaaeaaaaaa
dgaaaaafecaabaaaadaaaaaadkbabaaaafaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaaadaaaaaaegacbaaaacaaaaaa
pgapbaiaebaaaaaaabaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egacbaaaacaaaaaaeghobaaaaeaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaaeaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegacbaaa
adaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahhcaabaaaadaaaaaa
pgapbaaaadaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaadaaaaaadiaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaaadaaaaaa
ogikcaaaaaaaaaaaaeaaaaaadiaaaaaidcaabaaaadaaaaaaegaabaaaadaaaaaa
egiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
agaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaa
adaaaaaaegacbaaaacaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [ExposureIBL]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [_ShadowMapTexture] 2D 5
"ps_3_0
; 64 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
def c8, 2.00000000, -1.00000000, 0.50000000, 1.00000000
def c9, 0.85009766, -0.84997559, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c8.x, c8.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c8.w
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
texld r5.xyz, v0, s0
mul_pp r5.xyz, r5, c4
dp3_pp r3.x, r1, v2
dp3_pp r3.y, r1, v3
dp3_pp r3.z, r1, v4
dp3_sat r0.w, r1, v1
mul_pp r5.xyz, r5, c2.w
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r1.w, r3, r0
mul r2.xyz, r3, r1.w
texld r3, r3, s4
mul_pp r3.xyz, r3, r3.w
add r1.w, -r0, c8
mad r0.xyz, -r2, c8.x, r0
mad_pp r2.x, r1.w, c8.z, c8.z
mul_pp r2.x, r1.w, r2
texld r0, r0, s3
mad_pp r2.x, r2, c9, c9.y
mov_pp r1.w, c8
mad_pp r1.w, r2.x, c7.x, r1
mul_pp r2.xyz, r0, r0.w
texld r0, v0, s2
mul_pp r4.xyz, r0.w, r2
mul_pp r1.w, r1, c5.x
mul_pp r1.w, r1, c2
mul_pp r0.xyz, r0, c1
mul_pp r2.xyz, r0, r1.w
add_pp r0.w, -r0, c8
mad_pp r1.w, -r0, r0, c8
mov_pp r0.xyz, v5
add_pp r0.xyz, v1, r0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
mad_pp r1.w, -r1, c6.x, r1
add_pp r1.w, -r1, c8
mul_pp r4.xyz, r2, r4
exp_pp r1.w, r1.w
dp3_pp_sat r2.w, r1, r0
pow r0, r2.w, r1.w
mov_pp r0.zw, c2.xyxy
mul_pp r0.zw, c3.xyxy, r0
mul_pp r3.xyz, r5, r3
mul_pp r3.xyz, r0.z, r3
mad_pp r3.xyz, r4, r0.w, r3
mad r0.w, r1, c9.z, c9
mul_pp r2.xyz, r2, r0.w
mul_pp r0.xyz, r0.x, c0
dp3_pp_sat r0.w, r1, v5
mul_pp r1.xyz, r0, r2
mul_pp r0.xyz, r0.w, r5
mul_pp r0.xyz, r0, c0
mul_pp r1.xyz, r1, c8.z
mad_pp r1.xyz, r0, c8.x, r1
mul_pp r2.xyz, r5, v6
texldp r0.x, v7, s5
mad_pp r0.xyz, r1, r0.x, r2
add_pp oC0.xyz, r0, r3
mov_pp oC0.w, c8
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 5
SetTexture 2 [_SpecTex] 2D 3
SetTexture 3 [_SpecCubeIBL] CUBE 4
SetTexture 4 [_DiffCubeIBL] CUBE 2
SetTexture 5 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 308 [_Shininess]
Float 312 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbelgafobepkddlhmhokmiomnhaalpbcgabaaaaaakmakaaaaadaaaaaa
cmaaaaaacmabaaaagaabaaaaejfdeheopiaaaaaaajaaaaaaaiaaaaaaoaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaomaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaaomaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaaomaaaaaa
ahaaaaaaaaaaaaaaadaaaaaaaiaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefceeajaaaaeaaaaaaafbacaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaa
adaaaaaaffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagcbaaaadpcbabaaa
afaaaaaagcbaaaadhcbabaaaagaaaaaagcbaaaadhcbabaaaahaaaaaagcbaaaad
lcbabaaaaiaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaa
aaaaaaaibcaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
dcaaaaandcaabaaaabaaaaaaagaabaiaebaaaaaaabaaaaaaagaabaaaabaaaaaa
aceaaaaaaaaaiadpaaaaaaebaaaaaaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaa
bkiacaiaebaaaaaaaaaaaaaabdaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaa
aaaaaaaibcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaaaeb
bjaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaajccaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaidpjccdoabeaaaaaidpjkcdodiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaafaaaaaadcaaaaap
dcaabaaaacaaaaaahgapbaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahecaabaaa
abaaaaaaegaabaaaacaaaaaaegaabaaaacaaaaaaddaaaaahecaabaaaabaaaaaa
ckaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaaiecaabaaaabaaaaaackaabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaacaaaaaackaabaaa
abaaaaaabacaaaahecaabaaaabaaaaaaegacbaaaacaaaaaaegbcbaaaacaaaaaa
aaaaaaaiecaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dcaaaaajicaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaadpabeaaaaa
aaaaaadpdiaaaaahecaabaaaabaaaaaadkaabaaaabaaaaaackaabaaaabaaaaaa
dcaaaaajecaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaajkjjfjdpabeaaaaa
jkjjfjlpdcaaaaakecaabaaaabaaaaaackiacaaaaaaaaaaabdaaaaaackaabaaa
abaaaaaaabeaaaaaaaaaiadpdiaaaaaiecaabaaaabaaaaaackaabaaaabaaaaaa
akiacaaaaaaaaaaabdaaaaaadiaaaaaiecaabaaaabaaaaaackaabaaaabaaaaaa
dkiacaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
kgakbaaaabaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagajbaaa
aaaaaaaaaaaaaaahhcaabaaaadaaaaaaegbcbaaaacaaaaaaegbcbaaaagaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaa
acaaaaaaegacbaaaadaaaaaabacaaaahicaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaacpaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaabjaaaaafbcaabaaa
abaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaadaaaaaaagaabaaaabaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaa
egacbaaaadaaaaaadiaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaabacaaaahicaabaaaabaaaaaaegacbaaa
acaaaaaaegbcbaaaagaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaadaaaaaa
egiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaadaaaaaa
pgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaeaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaeaaaaaaegiccaaa
aaaaaaaaabaaaaaaegacbaaaabaaaaaaaoaaaaahdcaabaaaaeaaaaaaegbabaaa
aiaaaaaapgbpbaaaaiaaaaaaefaaaaajpcaabaaaaeaaaaaaegaabaaaaeaaaaaa
eghobaaaafaaaaaaaagabaaaaaaaaaaadiaaaaahocaabaaaaeaaaaaaagajbaaa
adaaaaaaagbjbaaaahaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaa
agaabaaaaeaaaaaajgahbaaaaeaaaaaabaaaaaahbcaabaaaaeaaaaaaegbcbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahccaabaaaaeaaaaaaegbcbaaaaeaaaaaa
egacbaaaacaaaaaabaaaaaahecaabaaaaeaaaaaaegbcbaaaafaaaaaaegacbaaa
acaaaaaadgaaaaafbcaabaaaacaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaa
acaaaaaadkbabaaaaeaaaaaadgaaaaafecaabaaaacaaaaaadkbabaaaafaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaaegacbaaaaeaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaaaacaaaaaa
efaaaaajpcaabaaaaeaaaaaaegacbaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaaeaaaaaapgapbaaaaeaaaaaaegacbaaaaeaaaaaa
diaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaaefaaaaaj
pcaabaaaacaaaaaaegacbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaajdcaabaaaacaaaaaa
egiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaahncaabaaa
acaaaaaaagaabaaaacaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaacaaaaaaigadbaaaacaaaaaaaaaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [_ShadowMapTexture] 2D 5
SetTexture 6 [unity_Lightmap] 2D 6
"ps_3_0
; 47 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c7, 8.00000000, 2.00000000, -1.00000000, 0.50000000
def c8, 0.85009766, -0.84997559, 1.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0.yw, v0, s1
mad_pp r3.xy, r0.wyzw, c7.y, c7.z
mul_pp r0.xy, r3, r3
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c8.z
rsq_pp r0.x, r0.x
rcp_pp r3.z, r0.x
dp3_pp r1.x, v2, r3
dp3_pp r1.y, r3, v3
dp3_pp r1.z, r3, v4
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r0.w, r1, r0
mul r2.xyz, r1, r0.w
texld r1, r1, s4
mul_pp r4.xyz, r1, r1.w
mad r0.xyz, -r2, c7.y, r0
texld r0, r0, s3
mul_pp r2.xyz, r0, r0.w
texld r0, v0, s2
mul_pp r2.xyz, r2, r0.w
dp3_sat r0.w, r3, v1
add r0.w, -r0, c8.z
mad_pp r1.w, r0, c7, c7
mul_pp r1.w, r0, r1
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, c1.w
mul_pp r3.xyz, r1, r4
mov_pp r4.xy, c1
mul_pp r4.xy, c3, r4
mul_pp r4.xy, r4, c2
mul_pp r3.xyz, r4.x, r3
texldp r4.x, v6, s5
mov_pp r0.w, c8.z
mad_pp r1.w, r1, c8.x, c8.y
mad_pp r0.w, r1, c6.x, r0
mul_pp r0.w, r0, c5.x
mul_pp r0.w, r0, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r2, r0
mad_pp r2.xyz, r0, r4.y, r3
texld r0, v5, s6
mul_pp r3.xyz, r0.w, r0
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c7.x
mul_pp r0.xyz, r0, c7.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r1, r0, r2
mov_pp oC0.w, c8.z
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 5
SetTexture 2 [_SpecTex] 2D 3
SetTexture 3 [_SpecCubeIBL] CUBE 4
SetTexture 4 [_DiffCubeIBL] CUBE 2
SetTexture 5 [_ShadowMapTexture] 2D 0
SetTexture 6 [unity_Lightmap] 2D 6
ConstBuffer "$Globals" 352
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 312 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkhgohfmbccnigcdoiegjnldbbgcpiefkabaaaaaaniaiaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefciiahaaaaeaaaaaaaocabaaaafjaaaaaeegiocaaa
aaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafidaaaae
aahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaafibiaaae
aahabaaaagaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagcbaaaadlcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadgaaaaafbcaabaaaaaaaaaaa
dkbabaaaadaaaaaadgaaaaafccaabaaaaaaaaaaadkbabaaaaeaaaaaadgaaaaaf
ecaabaaaaaaaaaaadkbabaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaafaaaaaadcaaaaapdcaabaaaabaaaaaa
hgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaa
abaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaacaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaa
acaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaa
egbcbaaaafaaaaaaegacbaaaabaaaaaabacaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegbcbaaaacaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahbcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaiaebaaaaaa
abaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaacaaaaaa
eghobaaaaeaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaaaaaaaaaa
eghobaaaadaaaaaaaagabaaaaeaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
acaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaadaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaaaaaaaaaacaaaaaadcaaaaajicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkaabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakicaabaaaaaaaaaaackiacaaa
aaaaaaaabdaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaabdaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajdcaabaaaadaaaaaaegiacaaa
aaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaaidcaabaaaadaaaaaa
egaabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaafgafbaaaadaaaaaaegacbaaaabaaaaaaaoaaaaahdcaabaaaabaaaaaa
egbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaa
abaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaadiaaaaahocaabaaaabaaaaaa
pgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
adaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaa
pgapbaaaaaaaaaaaddaaaaahocaabaaaabaaaaaafgaobaaaabaaaaaaagajbaaa
adaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaa
deaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaaadaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [ExposureIBL]
Vector 2 [ExposureLM]
Vector 3 [UniformOcclusion]
Vector 4 [_Color]
Float 5 [_SpecInt]
Float 6 [_Shininess]
Float 7 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_SpecTex] 2D 2
SetTexture 3 [_SpecCubeIBL] CUBE 3
SetTexture 4 [_DiffCubeIBL] CUBE 4
SetTexture 5 [_ShadowMapTexture] 2D 5
SetTexture 6 [unity_Lightmap] 2D 6
SetTexture 7 [unity_LightmapInd] 2D 7
"ps_3_0
; 80 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
dcl_2d s7
def c8, 2.00000000, -1.00000000, 8.00000000, 0.50000000
def c9, -0.40824831, 0.70710677, 0.57735026, 1.00000000
def c10, 0.81649655, 0.00000000, 0.57735026, 0.12500000
def c11, -0.40824828, -0.70710677, 0.57735026, 0
def c12, 0.85009766, -0.84997559, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c8.x, c8.y
mul_pp r0.xy, r1, r1
add_pp_sat r1.z, r0.x, r0.y
texld r2, v5, s7
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c8.z
mul r4.xyz, r2.y, c9
add_pp r1.z, -r1, c9.w
rsq_pp r1.z, r1.z
rcp_pp r1.z, r1.z
dp3_pp_sat r3.z, r1, c11
dp3_pp_sat r3.x, r1, c10
dp3_pp_sat r3.y, r1, c9
dp3_pp r1.w, r2, r3
texld r0, v5, s6
mul_pp r3.xyz, r0.w, r0
mul_pp r3.xyz, r3, r1.w
texldp r5.x, v6, s5
mul_pp r0.xyz, r0, r5.x
mad r4.xyz, r2.x, c10, r4
mad r2.xyz, r2.z, c11, r4
mul_pp r3.xyz, r3, c8.z
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
add_pp r2.xyz, r2, v1
dp3_pp r1.w, r2, r2
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, r2
mul_pp r0.xyz, r0, c8.x
dp3_pp_sat r1.w, r1, r2
mul_pp r4.xyz, r3, r5.x
min_pp r0.xyz, r3, r0
max_pp r5.xyz, r0, r4
texld r0, v0, s2
add_pp r2.w, -r0, c9
mad_pp r2.w, -r2, r2, c9
mad_pp r2.w, -r2, c6.x, r2
add_pp r2.w, -r2, c9
exp_pp r3.w, r2.w
pow r2, r1.w, r3.w
dp3_sat r1.w, r1, v1
mov r2.w, r2.x
texld r4.xyz, v0, s0
mul_pp r4.xyz, r4, c4
mul_pp r4.xyz, r4, c1.w
dp3_pp r2.x, r1, v2
dp3_pp r2.y, r1, v3
dp3_pp r2.z, r1, v4
add r1.w, -r1, c9
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r4.w, r2, r1
mul r6.xyz, r2, r4.w
mad_pp r4.w, r1, c8, c8
mul_pp r4.w, r1, r4
mad r1.xyz, -r6, c8.x, r1
mov_pp r1.w, c9
mad_pp r4.w, r4, c12.x, c12.y
mad_pp r4.w, r4, c7.x, r1
texld r1, r1, s3
mul_pp r1.xyz, r1, r1.w
mul_pp r7.xyz, r0.w, r1
texld r1, r2, s4
mul_pp r4.w, r4, c5.x
mov_pp r2.xy, c1
mul_pp r1.xyz, r1, r1.w
mul_pp r2.xy, c3, r2
mul_pp r2.xy, r2, c2
mul_pp r1.xyz, r4, r1
mul_pp r1.xyz, r2.x, r1
mul_pp r5.xyz, r4, r5
mad r3.w, r3, c12.z, c12
mul_pp r4.w, r4, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r4.w
mul_pp r6.xyz, r0, r3.w
mul_pp r0.xyz, r0, r7
mad_pp r0.xyz, r0, r2.y, r1
mul r6.xyz, r2.w, r6
mul r1.xyz, r6, c10.w
mad_pp r1.xyz, r1, r3, r5
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 5
SetTexture 2 [_SpecTex] 2D 3
SetTexture 3 [_SpecCubeIBL] CUBE 4
SetTexture 4 [_DiffCubeIBL] CUBE 2
SetTexture 5 [_ShadowMapTexture] 2D 0
SetTexture 6 [unity_Lightmap] 2D 6
SetTexture 7 [unity_LightmapInd] 2D 7
ConstBuffer "$Globals" 352
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 308 [_Shininess]
Float 312 [_Fresnel]
BindCB  "$Globals" 0
"ps_4_0
eefiecedppgpdpknfoeellbopjalkhglgacffhplabaaaaaaomamaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apapaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcjmalaaaaeaaaaaaaohacaaaafjaaaaaeegiocaaa
aaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafkaaaaad
aagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaa
adaaaaaaffffaaaafidaaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaafibiaaaeaahabaaa
ahaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagcbaaaadpcbabaaaafaaaaaagcbaaaadlcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaaaaaaaaibcaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaandcaabaaaabaaaaaa
agaabaiaebaaaaaaabaaaaaaagaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaeb
aaaaaaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaabkiacaiaebaaaaaaaaaaaaaa
bdaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaaaebbjaaaaafbcaabaaaabaaaaaa
akaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
ahaaaaaaaagabaaaahaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaa
abaaaaaadiaaaaakhcaabaaaacaaaaaakgakbaaaabaaaaaaaceaaaaaomafnblo
pdaedfdpdkmnbddpaaaaaaaadcaaaaamhcaabaaaacaaaaaafgafbaaaabaaaaaa
aceaaaaaolaffbdpaaaaaaaadkmnbddpaaaaaaaaegacbaaaacaaaaaadcaaaaam
hcaabaaaacaaaaaapgapbaaaabaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadcaaaaaj
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaacaaaaaaegbcbaaaacaaaaaa
baaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
acaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaafaaaaaadcaaaaapdcaabaaaadaaaaaahgapbaaa
adaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialp
aaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaacaaaaaaegaabaaaadaaaaaa
egaabaaaadaaaaaaddaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaiadpaaaaaaaiicaabaaaacaaaaaadkaabaiaebaaaaaaacaaaaaaabeaaaaa
aaaaiadpelaaaaafecaabaaaadaaaaaadkaabaaaacaaaaaabacaaaahbcaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaacpaaaaafbcaabaaaacaaaaaa
akaabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaaabaaaaaaakaabaaa
acaaaaaadcaaaaajbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaidpjccdo
abeaaaaaidpjkcdobjaaaaafbcaabaaaacaaaaaaakaabaaaacaaaaaadiaaaaah
bcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaaaaaaadodiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaabacaaaahccaabaaa
acaaaaaaegacbaaaadaaaaaaegbcbaaaacaaaaaaaaaaaaaiccaabaaaacaaaaaa
bkaabaiaebaaaaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaajecaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahccaabaaa
acaaaaaackaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaajccaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakccaabaaa
acaaaaaackiacaaaaaaaaaaabdaaaaaabkaabaaaacaaaaaaabeaaaaaaaaaiadp
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaaakiacaaaaaaaaaaabdaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaacaaaaaadkiacaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaacaaaaaadiaaaaah
ocaabaaaacaaaaaaagaabaaaabaaaaaaagajbaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaaagaabaaaacaaaaaajgahbaaaacaaaaaaapcaaaakbcaabaaaaeaaaaaa
aceaaaaaolaffbdpdkmnbddpaaaaaaaaaaaaaaaaigaabaaaadaaaaaabacaaaak
ccaabaaaaeaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaaegacbaaa
adaaaaaabacaaaakecaabaaaaeaaaaaaaceaaaaaolafnblopdaedflpdkmnbddp
aaaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaeaaaaaa
jgahbaaaabaaaaaaefaaaaajpcaabaaaaeaaaaaaogbkbaaaabaaaaaaeghobaaa
agaaaaaaaagabaaaagaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaeaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaaeaaaaaafgafbaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaa
aoaaaaahdcaabaaaafaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaaj
pcaabaaaafaaaaaaegaabaaaafaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaa
aaaaaaahicaabaaaabaaaaaaakaabaaaafaaaaaaakaabaaaafaaaaaadiaaaaah
hcaabaaaafaaaaaaegacbaaaabaaaaaaagaabaaaafaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgapbaaaabaaaaaaddaaaaahhcaabaaaaeaaaaaa
egacbaaaabaaaaaaegacbaaaaeaaaaaadeaaaaahhcaabaaaaeaaaaaaegacbaaa
afaaaaaaegacbaaaaeaaaaaaefaaaaajpcaabaaaafaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaaafaaaaaaegacbaaa
afaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaaafaaaaaaegacbaaa
afaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaafaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaeaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
adaaaaaaegacbaaaadaaaaaabaaaaaahccaabaaaacaaaaaaegbcbaaaaeaaaaaa
egacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaafaaaaaaegacbaaa
adaaaaaadgaaaaafbcaabaaaadaaaaaadkbabaaaadaaaaaadgaaaaafccaabaaa
adaaaaaadkbabaaaaeaaaaaadgaaaaafecaabaaaadaaaaaadkbabaaaafaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaa
adaaaaaaegacbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaaaadaaaaaa
efaaaaajpcaabaaaacaaaaaaegacbaaaacaaaaaaeghobaaaaeaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaadaaaaaaegacbaaaadaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaajdcaabaaaadaaaaaa
egiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaaidcaabaaa
adaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
}
 }
}
Fallback "Marmoset/Mobile/Specular IBL"
}