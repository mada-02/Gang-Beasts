Shader "Marmoset/Transparent/Cutout/Diffuse IBL" {
Properties {
 _Color ("Diffuse Color", Color) = (1,1,1,1)
 _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
 _MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
 _DiffCubeIBL ("Custom Diffuse Cube", CUBE) = "black" {}
 _SpecCubeIBL ("Custom Specular Cube", CUBE) = "black" {}
}
SubShader { 
 LOD 200
 Tags { "QUEUE"="AlphaTest" "IGNOREPROJECTOR"="True" "RenderType"="TransparentCutout" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="AlphaTest" "IGNOREPROJECTOR"="True" "RenderType"="TransparentCutout" }
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2_5;
  vec3 x1_6;
  x1_6.x = dot (unity_SHAr, tmpvar_4);
  x1_6.y = dot (unity_SHAg, tmpvar_4);
  x1_6.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2_5.x = dot (unity_SHBr, tmpvar_7);
  x2_5.y = dot (unity_SHBg, tmpvar_7);
  x2_5.z = dot (unity_SHBb, tmpvar_7);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((x1_6 + x2_5) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y))));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 frag_13;
  vec4 tmpvar_14;
  tmpvar_14.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_14.w = tmpvar_4;
  frag_13.w = tmpvar_14.w;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_13.xyz = frag_13.xyz;
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [unity_Scale]
Vector 17 [_MainTex_ST]
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c16.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c18.x
dp4 r2.z, r0, c11
dp4 r2.y, r0, c10
dp4 r2.x, r0, c9
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov o3.x, r0
dp4 r3.z, r1, c14
dp4 r3.y, r1, c13
dp4 r3.x, r1, c12
mul r1.xyz, r0.y, c15
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o4.xyz, r2, r1
mov o3.z, r2.w
mov o3.y, r3.w
add o5.xyz, -r0, c8
mad o1.xy, v2, c17, c17.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedcfdocohfddochnpigofaaaplnjhegnfiabaaaaaaieagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcnaaeaaaaeaaaabaadeabaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
adaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaak
hccabaaaaeaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;

void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  c_1.xyz = (diff_2.xyz * ((8.0 * tmpvar_13.w) * tmpvar_13.xyz));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_3_0
; 9 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.xy, v2, c9, c9.zwzw
mad o3.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedjlbglmhbbjnkfamfeboacihdcnmfomaaabaaaaaahmadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
piabaaaaeaaaabaahoaaaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaae
egiocaaaabaaaaaaapaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaa
abaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
abaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
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
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  vec3 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_2 = TANGENT.xyz;
  tmpvar_3 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_2.x;
  tmpvar_4[0].y = tmpvar_3.x;
  tmpvar_4[0].z = gl_Normal.x;
  tmpvar_4[1].x = tmpvar_2.y;
  tmpvar_4[1].y = tmpvar_3.y;
  tmpvar_4[1].z = gl_Normal.y;
  tmpvar_4[2].x = tmpvar_2.z;
  tmpvar_4[2].y = tmpvar_3.z;
  tmpvar_4[2].z = gl_Normal.z;
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_4 * (((_World2Object * tmpvar_5).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  c_1.xyz = (diff_2.xyz * ((8.0 * tmpvar_13.w) * tmpvar_13.xyz));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
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
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
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
mul r1.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c16.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c13.w, -v0
dp3 o4.y, r0, r1
dp3 o4.z, v2, r0
dp3 o4.x, r0, v1
mad o1.xy, v3, c15, c15.zwzw
mad o3.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
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
eefiecedghjjdomakfffnnlficpffcomgeipaldiabaaaaaadiafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcjmadaaaaeaaaabaa
ohaaaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
jgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaa
egacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaa
baaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2_6;
  vec3 x1_7;
  x1_7.x = dot (unity_SHAr, tmpvar_5);
  x1_7.y = dot (unity_SHAg, tmpvar_5);
  x1_7.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2_6.x = dot (unity_SHBr, tmpvar_8);
  x2_6.y = dot (unity_SHBg, tmpvar_8);
  x2_6.z = dot (unity_SHBb, tmpvar_8);
  vec4 o_9;
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_1 * 0.5);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10.x;
  tmpvar_11.y = (tmpvar_10.y * _ProjectionParams.x);
  o_9.xy = (tmpvar_11 + tmpvar_10.w);
  o_9.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = ((x1_7 + x2_6) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y))));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD5 = o_9;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 frag_13;
  vec4 tmpvar_14;
  tmpvar_14.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_14.w = tmpvar_4;
  frag_13.w = tmpvar_14.w;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_13.xyz = (frag_13.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x);
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c20, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c18.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c20.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c13
dp4 r2.y, r1.wxyz, c12
dp4 r2.x, r1.wxyz, c11
dp4 r1.z, r0, c16
dp4 r1.y, r0, c15
dp4 r1.x, r0, c14
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c17
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c20.y
mov o0, r0
mul r1.y, r1, c9.x
mov o6.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o4.xyz, r3, r2
mad o6.xy, r1.z, c10.zwzw, r1
mov o3.z, r2.w
mov o3.y, r3.w
mov o3.x, r1.w
add o5.xyz, -r0, c8
mad o1.xy, v2, c19, c19.zwzw
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaognjjponjbkbpbnngjdeihibemnmflabaaaaaadeahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiafaaaaeaaaabaafkabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
bdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
acaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
acaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
acaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
acaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
adaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaafaaaaaa
egacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaagaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaagaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = o_3;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  c_1.xyz = (diff_2.xyz * max (min (tmpvar_15, ((tmpvar_13.x * 2.0) * tmpvar_14.xyz)), (tmpvar_15 * tmpvar_13.x)));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad o4.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o4.zw, r0
mad o1.xy, v2, c11, c11.zwzw
mad o3.xy, v3, c10, c10.zwzw
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 352
Vector 304 [unity_LightmapST]
Vector 320 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedjdklalggikeiggbmnckmahbeciakcoaeabaaaaaadmaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckaacaaaaeaaaabaa
kiaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaaapaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaa
adaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabeaaaaaaogikcaaaaaaaaaaa
beaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaa
bdaaaaaakgiocaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
acaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  vec3 tmpvar_4;
  tmpvar_3 = TANGENT.xyz;
  tmpvar_4 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_3.x;
  tmpvar_5[0].y = tmpvar_4.x;
  tmpvar_5[0].z = gl_Normal.x;
  tmpvar_5[1].x = tmpvar_3.y;
  tmpvar_5[1].y = tmpvar_4.y;
  tmpvar_5[1].z = gl_Normal.y;
  tmpvar_5[2].x = tmpvar_3.z;
  tmpvar_5[2].y = tmpvar_4.z;
  tmpvar_5[2].z = gl_Normal.z;
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  vec4 o_7;
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_1 * 0.5);
  vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_5 * (((_World2Object * tmpvar_6).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD4 = o_7;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  c_1.xyz = (diff_2.xyz * max (min (tmpvar_15, ((tmpvar_13.x * 2.0) * tmpvar_14.xyz)), (tmpvar_15 * tmpvar_13.x)));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
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
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
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
mul r0.xyz, r0, v1.w
mov r1.xyz, c12
mov r1.w, c18.x
dp4 r0.w, v0, c3
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c15.w, -v0
dp3 o4.y, r2, r0
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.y
mul r1.y, r1, c13.x
dp3 o4.z, v2, r2
dp3 o4.x, r2, v1
mad o5.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o3.xy, v4, c16, c16.zwzw
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 352
Vector 304 [unity_LightmapST]
Vector 320 [_MainTex_ST]
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
eefieceddmijhoghcpjmihokoigaeklfakcnfabmabaaaaaaoiafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcdeaeaaaaeaaaabaaanabaaaafjaaaaae
egiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabeaaaaaaogikcaaaaaaaaaaabeaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaabdaaaaaakgiocaaaaaaaaaaabdaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaa
abaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaa
cgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaacaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaacaaaaaa
egiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaa
dcaaaaalhcaabaaaacaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaa
egbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
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
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2_5;
  vec3 x1_6;
  x1_6.x = dot (unity_SHAr, tmpvar_4);
  x1_6.y = dot (unity_SHAg, tmpvar_4);
  x1_6.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2_5.x = dot (unity_SHBr, tmpvar_7);
  x2_5.y = dot (unity_SHBg, tmpvar_7);
  x2_5.z = dot (unity_SHBb, tmpvar_7);
  vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosX0 - tmpvar_8.x);
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosY0 - tmpvar_8.y);
  vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosZ0 - tmpvar_8.z);
  vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_9 * tmpvar_9) + (tmpvar_10 * tmpvar_10)) + (tmpvar_11 * tmpvar_11));
  vec4 tmpvar_13;
  tmpvar_13 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_9 * tmpvar_3.x) + (tmpvar_10 * tmpvar_3.y)) + (tmpvar_11 * tmpvar_3.z)) * inversesqrt(tmpvar_12))) * (1.0/((1.0 + (tmpvar_12 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (((x1_6 + x2_5) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y)))) + ((((unity_LightColor[0].xyz * tmpvar_13.x) + (unity_LightColor[1].xyz * tmpvar_13.y)) + (unity_LightColor[2].xyz * tmpvar_13.z)) + (unity_LightColor[3].xyz * tmpvar_13.w)));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 frag_13;
  vec4 tmpvar_14;
  tmpvar_14.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_14.w = tmpvar_4;
  frag_13.w = tmpvar_14.w;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_13.xyz = frag_13.xyz;
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [unity_Scale]
Vector 25 [_MainTex_ST]
"vs_3_0
; 63 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c26, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c24.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c10
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c9
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c26.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c11
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c12
add r1, r1, c26.x
mov o3.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c19
dp4 r2.y, r5, c18
dp4 r2.x, r5, c17
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c26.y
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mad r1.xyz, r0.w, c16, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c22
dp4 r5.z, r0, c21
dp4 r5.y, r0, c20
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c23
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add o4.xyz, r0, r1
mov o3.y, r4.z
mov o3.x, r5
add o5.xyz, -r3.wxyw, c8
mad o1.xy, v2, c25, c25.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedhkfbclafjgpmojbhfconnoojcgkbgkkfabaaaaaadmajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefciiahaaaaeaaaabaaocabaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
adaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaaj
pcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaadaaaaaa
diaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaah
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaa
afaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaacaaaaaadcaaaaaj
pcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaa
adaaaaaaaaaaaaajpcaabaaaafaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaa
acaaaaaaaeaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaacaaaaaa
egiccaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaa
afaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaa
egaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
acaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
acaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaa
deaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaa
ahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
aiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaah
hccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
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
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2_6;
  vec3 x1_7;
  x1_7.x = dot (unity_SHAr, tmpvar_5);
  x1_7.y = dot (unity_SHAg, tmpvar_5);
  x1_7.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2_6.x = dot (unity_SHBr, tmpvar_8);
  x2_6.y = dot (unity_SHBg, tmpvar_8);
  x2_6.z = dot (unity_SHBb, tmpvar_8);
  vec3 tmpvar_9;
  tmpvar_9 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosX0 - tmpvar_9.x);
  vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosY0 - tmpvar_9.y);
  vec4 tmpvar_12;
  tmpvar_12 = (unity_4LightPosZ0 - tmpvar_9.z);
  vec4 tmpvar_13;
  tmpvar_13 = (((tmpvar_10 * tmpvar_10) + (tmpvar_11 * tmpvar_11)) + (tmpvar_12 * tmpvar_12));
  vec4 tmpvar_14;
  tmpvar_14 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_10 * tmpvar_4.x) + (tmpvar_11 * tmpvar_4.y)) + (tmpvar_12 * tmpvar_4.z)) * inversesqrt(tmpvar_13))) * (1.0/((1.0 + (tmpvar_13 * unity_4LightAtten0)))));
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
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (((x1_7 + x2_6) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y)))) + ((((unity_LightColor[0].xyz * tmpvar_14.x) + (unity_LightColor[1].xyz * tmpvar_14.y)) + (unity_LightColor[2].xyz * tmpvar_14.z)) + (unity_LightColor[3].xyz * tmpvar_14.w)));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD5 = o_15;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_3.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 frag_13;
  vec4 tmpvar_14;
  tmpvar_14.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_14.w = tmpvar_4;
  frag_13.w = tmpvar_14.w;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_13.xyz = (frag_13.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x);
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [unity_Scale]
Vector 27 [_MainTex_ST]
"vs_3_0
; 69 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c28, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c26.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c12
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c11
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c28.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c13
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c14
add r1, r1, c28.x
mov o3.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c21
dp4 r2.y, r5, c20
dp4 r2.x, r5, c19
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c28.y
mul r0, r0, r1
mul r1.xyz, r0.y, c16
mad r1.xyz, r0.x, c15, r1
mad r0.xyz, r0.z, c17, r1
mad r1.xyz, r0.w, c18, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c24
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c25
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c28.z
add o4.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c9.x
mov r3.x, r4.w
mov r3.y, r4
mad o6.xy, r2.z, c10.zwzw, r1
mov o0, r0
mov o6.zw, r0
mov o3.y, r4.z
mov o3.x, r5
add o5.xyz, -r3.wxyw, c8
mad o1.xy, v2, c27, c27.zwzw
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedoemjndblefgoklafkoindhdanmjlnjnoabaaaaaaomajaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefccaaiaaaaeaaaabaaaiacaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
bdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
acaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
acaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
acaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
acaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
adaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaacmaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaa
fgafbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaa
afaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaa
egaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaia
ebaaaaaaadaaaaaaegiocaaaacaaaaaaacaaaaaadcaaaaajpcaabaaaafaaaaaa
egaobaaaagaaaaaaagaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaa
aeaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaaaaaaaaaj
pcaabaaaagaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaaeaaaaaa
aaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaa
aeaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaagaaaaaakgakbaaaabaaaaaa
egaobaaaafaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaagaaaaaaegaobaaa
agaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaaadaaaaaa
dcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaaacaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaah
pcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaadiaaaaai
hcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaabaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaa
abaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaaaeaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
agaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaagaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2_5;
  vec3 x1_6;
  x1_6.x = dot (unity_SHAr, tmpvar_4);
  x1_6.y = dot (unity_SHAg, tmpvar_4);
  x1_6.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2_5.x = dot (unity_SHBr, tmpvar_7);
  x2_5.y = dot (unity_SHBg, tmpvar_7);
  x2_5.z = dot (unity_SHBb, tmpvar_7);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((x1_6 + x2_5) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y))));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = frag_11.xyz;
  c_1.w = frag_11.w;
  c_1.xyz = (frag_11.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [unity_Scale]
Vector 17 [_MainTex_ST]
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c16.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c18.x
dp4 r2.z, r0, c11
dp4 r2.y, r0, c10
dp4 r2.x, r0, c9
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov o3.x, r0
dp4 r3.z, r1, c14
dp4 r3.y, r1, c13
dp4 r3.x, r1, c12
mul r1.xyz, r0.y, c15
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o4.xyz, r2, r1
mov o3.z, r2.w
mov o3.y, r3.w
add o5.xyz, -r0, c8
mad o1.xy, v2, c17, c17.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedcfdocohfddochnpigofaaaplnjhegnfiabaaaaaaieagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcnaaeaaaaeaaaabaadeabaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
adaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaak
hccabaaaaeaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;

void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  c_1.xyz = (diff_2.xyz * ((8.0 * tmpvar_11.w) * tmpvar_11.xyz));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_3_0
; 9 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.xy, v2, c9, c9.zwzw
mad o3.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedjlbglmhbbjnkfamfeboacihdcnmfomaaabaaaaaahmadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
piabaaaaeaaaabaahoaaaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaae
egiocaaaabaaaaaaapaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaa
abaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
abaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
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
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  vec3 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_2 = TANGENT.xyz;
  tmpvar_3 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_2.x;
  tmpvar_4[0].y = tmpvar_3.x;
  tmpvar_4[0].z = gl_Normal.x;
  tmpvar_4[1].x = tmpvar_2.y;
  tmpvar_4[1].y = tmpvar_3.y;
  tmpvar_4[1].z = gl_Normal.y;
  tmpvar_4[2].x = tmpvar_2.z;
  tmpvar_4[2].y = tmpvar_3.z;
  tmpvar_4[2].z = gl_Normal.z;
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_4 * (((_World2Object * tmpvar_5).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  c_1.xyz = (diff_2.xyz * ((8.0 * tmpvar_11.w) * tmpvar_11.xyz));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
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
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
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
mul r1.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c16.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c13.w, -v0
dp3 o4.y, r0, r1
dp3 o4.z, v2, r0
dp3 o4.x, r0, v1
mad o1.xy, v3, c15, c15.zwzw
mad o3.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
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
eefiecedghjjdomakfffnnlficpffcomgeipaldiabaaaaaadiafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcjmadaaaaeaaaabaa
ohaaaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
jgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaa
egacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaa
baaaaaahcccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaah
bccabaaaadaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaa
adaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2_6;
  vec3 x1_7;
  x1_7.x = dot (unity_SHAr, tmpvar_5);
  x1_7.y = dot (unity_SHAg, tmpvar_5);
  x1_7.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2_6.x = dot (unity_SHBr, tmpvar_8);
  x2_6.y = dot (unity_SHBg, tmpvar_8);
  x2_6.z = dot (unity_SHBb, tmpvar_8);
  vec4 o_9;
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_1 * 0.5);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10.x;
  tmpvar_11.y = (tmpvar_10.y * _ProjectionParams.x);
  o_9.xy = (tmpvar_11 + tmpvar_10.w);
  o_9.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = ((x1_7 + x2_6) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y))));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD5 = o_9;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = (frag_11.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x);
  c_1.w = frag_11.w;
  c_1.xyz = (frag_11.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c20, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c18.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c20.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c13
dp4 r2.y, r1.wxyz, c12
dp4 r2.x, r1.wxyz, c11
dp4 r1.z, r0, c16
dp4 r1.y, r0, c15
dp4 r1.x, r0, c14
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c17
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c20.y
mov o0, r0
mul r1.y, r1, c9.x
mov o6.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o4.xyz, r3, r2
mad o6.xy, r1.z, c10.zwzw, r1
mov o3.z, r2.w
mov o3.y, r3.w
mov o3.x, r1.w
add o5.xyz, -r0, c8
mad o1.xy, v2, c19, c19.zwzw
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaognjjponjbkbpbnngjdeihibemnmflabaaaaaadeahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiafaaaaeaaaabaafkabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
bdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
acaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
acaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
acaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
acaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
adaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaabkaabaiaebaaaaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaafaaaaaa
egacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaagaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaagaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = o_3;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  vec3 tmpvar_13;
  tmpvar_13 = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  c_1.xyz = (diff_2.xyz * max (min (tmpvar_13, ((tmpvar_11.x * 2.0) * tmpvar_12.xyz)), (tmpvar_13 * tmpvar_11.x)));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad o4.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o4.zw, r0
mad o1.xy, v2, c11, c11.zwzw
mad o3.xy, v3, c10, c10.zwzw
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 352
Vector 304 [unity_LightmapST]
Vector 320 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedjdklalggikeiggbmnckmahbeciakcoaeabaaaaaadmaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckaacaaaaeaaaabaa
kiaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaaapaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaa
aeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaa
adaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabeaaaaaaogikcaaaaaaaaaaa
beaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaa
bdaaaaaakgiocaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
acaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  vec3 tmpvar_4;
  tmpvar_3 = TANGENT.xyz;
  tmpvar_4 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_3.x;
  tmpvar_5[0].y = tmpvar_4.x;
  tmpvar_5[0].z = gl_Normal.x;
  tmpvar_5[1].x = tmpvar_3.y;
  tmpvar_5[1].y = tmpvar_4.y;
  tmpvar_5[1].z = gl_Normal.y;
  tmpvar_5[2].x = tmpvar_3.z;
  tmpvar_5[2].y = tmpvar_4.z;
  tmpvar_5[2].z = gl_Normal.z;
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  vec4 o_7;
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_1 * 0.5);
  vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_5 * (((_World2Object * tmpvar_6).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD4 = o_7;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  vec3 tmpvar_13;
  tmpvar_13 = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  c_1.xyz = (diff_2.xyz * max (min (tmpvar_13, ((tmpvar_11.x * 2.0) * tmpvar_12.xyz)), (tmpvar_13 * tmpvar_11.x)));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
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
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
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
mul r0.xyz, r0, v1.w
mov r1.xyz, c12
mov r1.w, c18.x
dp4 r0.w, v0, c3
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c15.w, -v0
dp3 o4.y, r2, r0
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.y
mul r1.y, r1, c13.x
dp3 o4.z, v2, r2
dp3 o4.x, r2, v1
mad o5.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o3.xy, v4, c16, c16.zwzw
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 352
Vector 304 [unity_LightmapST]
Vector 320 [_MainTex_ST]
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
eefieceddmijhoghcpjmihokoigaeklfakcnfabmabaaaaaaoiafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcdeaeaaaaeaaaabaaanabaaaafjaaaaae
egiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabeaaaaaaogikcaaaaaaaaaaabeaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaabdaaaaaakgiocaaaaaaaaaaabdaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaa
abaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaa
cgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaacaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaacaaaaaa
egiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaa
dcaaaaalhcaabaaaacaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaa
egbcbaaaabaaaaaaegacbaaaacaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
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
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2_5;
  vec3 x1_6;
  x1_6.x = dot (unity_SHAr, tmpvar_4);
  x1_6.y = dot (unity_SHAg, tmpvar_4);
  x1_6.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2_5.x = dot (unity_SHBr, tmpvar_7);
  x2_5.y = dot (unity_SHBg, tmpvar_7);
  x2_5.z = dot (unity_SHBb, tmpvar_7);
  vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosX0 - tmpvar_8.x);
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosY0 - tmpvar_8.y);
  vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosZ0 - tmpvar_8.z);
  vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_9 * tmpvar_9) + (tmpvar_10 * tmpvar_10)) + (tmpvar_11 * tmpvar_11));
  vec4 tmpvar_13;
  tmpvar_13 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_9 * tmpvar_3.x) + (tmpvar_10 * tmpvar_3.y)) + (tmpvar_11 * tmpvar_3.z)) * inversesqrt(tmpvar_12))) * (1.0/((1.0 + (tmpvar_12 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (((x1_6 + x2_5) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y)))) + ((((unity_LightColor[0].xyz * tmpvar_13.x) + (unity_LightColor[1].xyz * tmpvar_13.y)) + (unity_LightColor[2].xyz * tmpvar_13.z)) + (unity_LightColor[3].xyz * tmpvar_13.w)));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = frag_11.xyz;
  c_1.w = frag_11.w;
  c_1.xyz = (frag_11.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [unity_Scale]
Vector 25 [_MainTex_ST]
"vs_3_0
; 63 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c26, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c24.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c10
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c9
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c26.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c11
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c12
add r1, r1, c26.x
mov o3.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c19
dp4 r2.y, r5, c18
dp4 r2.x, r5, c17
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c26.y
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mad r1.xyz, r0.w, c16, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c22
dp4 r5.z, r0, c21
dp4 r5.y, r0, c20
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c23
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add o4.xyz, r0, r1
mov o3.y, r4.z
mov o3.x, r5
add o5.xyz, -r3.wxyw, c8
mad o1.xy, v2, c25, c25.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedhkfbclafjgpmojbhfconnoojcgkbgkkfabaaaaaadmajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefciiahaaaaeaaaabaaocabaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
adaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaaj
pcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaadaaaaaa
diaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaah
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaa
afaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaacaaaaaadcaaaaaj
pcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaa
adaaaaaaaaaaaaajpcaabaaaafaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaa
acaaaaaaaeaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaacaaaaaa
egiccaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaa
afaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaa
egaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
acaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
acaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaa
deaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaa
ahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
aiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaah
hccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
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
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2_6;
  vec3 x1_7;
  x1_7.x = dot (unity_SHAr, tmpvar_5);
  x1_7.y = dot (unity_SHAg, tmpvar_5);
  x1_7.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2_6.x = dot (unity_SHBr, tmpvar_8);
  x2_6.y = dot (unity_SHBg, tmpvar_8);
  x2_6.z = dot (unity_SHBb, tmpvar_8);
  vec3 tmpvar_9;
  tmpvar_9 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosX0 - tmpvar_9.x);
  vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosY0 - tmpvar_9.y);
  vec4 tmpvar_12;
  tmpvar_12 = (unity_4LightPosZ0 - tmpvar_9.z);
  vec4 tmpvar_13;
  tmpvar_13 = (((tmpvar_10 * tmpvar_10) + (tmpvar_11 * tmpvar_11)) + (tmpvar_12 * tmpvar_12));
  vec4 tmpvar_14;
  tmpvar_14 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_10 * tmpvar_4.x) + (tmpvar_11 * tmpvar_4.y)) + (tmpvar_12 * tmpvar_4.z)) * inversesqrt(tmpvar_13))) * (1.0/((1.0 + (tmpvar_13 * unity_4LightAtten0)))));
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
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (((x1_7 + x2_6) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y)))) + ((((unity_LightColor[0].xyz * tmpvar_14.x) + (unity_LightColor[1].xyz * tmpvar_14.y)) + (unity_LightColor[2].xyz * tmpvar_14.z)) + (unity_LightColor[3].xyz * tmpvar_14.w)));
  xlv_TEXCOORD4 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD5 = o_15;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_3.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD2, normalize(_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = (frag_11.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x);
  c_1.w = frag_11.w;
  c_1.xyz = (frag_11.xyz + (diff_2.xyz * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [unity_Scale]
Vector 27 [_MainTex_ST]
"vs_3_0
; 69 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c28, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c26.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c12
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c11
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c28.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c13
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c14
add r1, r1, c28.x
mov o3.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c21
dp4 r2.y, r5, c20
dp4 r2.x, r5, c19
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c28.y
mul r0, r0, r1
mul r1.xyz, r0.y, c16
mad r1.xyz, r0.x, c15, r1
mad r0.xyz, r0.z, c17, r1
mad r1.xyz, r0.w, c18, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c24
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c25
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c28.z
add o4.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c9.x
mov r3.x, r4.w
mov r3.y, r4
mad o6.xy, r2.z, c10.zwzw, r1
mov o0, r0
mov o6.zw, r0
mov o3.y, r4.z
mov o3.x, r5
add o5.xyz, -r3.wxyw, c8
mad o1.xy, v2, c27, c27.zwzw
dp3 o2.z, v1, c6
dp3 o2.y, v1, c5
dp3 o2.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedoemjndblefgoklafkoindhdanmjlnjnoabaaaaaaomajaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefccaaiaaaaeaaaabaaaiacaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadpccabaaaagaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
bdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
acaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
acaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
acaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
acaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
adaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaacmaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaadaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaa
fgafbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaa
afaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaa
egaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaia
ebaaaaaaadaaaaaaegiocaaaacaaaaaaacaaaaaadcaaaaajpcaabaaaafaaaaaa
egaobaaaagaaaaaaagaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaa
aeaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaaaaaaaaaj
pcaabaaaagaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaaeaaaaaa
aaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaa
aeaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaagaaaaaakgakbaaaabaaaaaa
egaobaaaafaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaagaaaaaaegaobaaa
agaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaaadaaaaaa
dcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaaacaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaah
pcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaadiaaaaai
hcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaabaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaa
abaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaaaeaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
agaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaagaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [UniformOcclusion]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
"ps_3_0
; 29 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
def c10, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c11, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c10
add_pp r0.w, r1.x, r1.y
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
texld r0, v0, s0
mul_pp r0, r0, c8
mul_pp r0.xyz, r0, c6.w
dp3_pp_sat r1.w, v2, r2
mul_pp r2.xyz, r0, r1.w
mul_pp r1.xyz, r1, r0
mul_pp r2.xyz, r2, c5
mul_pp r0.xyz, r0, v3
mad_pp r0.xyz, r2, c11.x, r0
add_pp r1.w, r0, -c9.x
cmp r2.x, r1.w, c10.z, c10.w
mov_pp r1.w, c6.x
mov_pp r2, -r2.x
mul_pp r1.w, c7.x, r1
mad_pp oC0.xyz, r1, r1.w, r0
texkill r2.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
ConstBuffer "$Globals" 272
Matrix 80 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 256 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedmilkkafnpmojddnofhnekbioofagjhmdabaaaaaadaagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbaafaaaa
eaaaaaaaeeabaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabaaaaaaadiaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaf
bcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
abaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaa
agajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaa
apaaaaakicaabaaaabaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaajicaabaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaabacaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaa
egacbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaaeaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaa
aaaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaa
aaaaaaaaaeaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
"ps_3_0
; 25 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c9, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c10, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r2, r0, s1
mul_pp r0.x, r2.w, r2.w
mul_pp r0.y, r2.w, r0.x
mul_pp r1.xy, r0, c9
add_pp r2.w, r1.x, r1.y
texld r0, v0, s0
mul_pp r1, r0, c7
texld r0, v2, s2
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r1, c4.w
mov_pp r0.w, c4.x
mul_pp r0.w, c6.x, r0
mul_pp r2.xyz, r2, r2.w
mul_pp r0.xyz, r0, r1
mul_pp r1.xyz, r1, r2
add_pp r2.x, r1.w, -c8
mul_pp r0.w, r0, c5.x
cmp r2.x, r2, c9.z, c9.w
mul_pp r1.xyz, r1, r0.w
mov_pp r2, -r2.x
mad_pp oC0.xyz, r0, c10.x, r1
texkill r2.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedggedigimdkijneeppohciikobhcjfkoaabaaaaaakiafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcliaeaaaaeaaaaaaacoabaaaafjaaaaaeegiocaaa
aaaaaaaabcaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaai
bcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaai
bcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaah
ocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaa
abaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaa
acaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaa
dkaabaaaabaaaaaaakaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaa
lhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaa
aaaaaaaaaeaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
"ps_3_0
; 25 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c9, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c10, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r2, r0, s1
mul_pp r0.x, r2.w, r2.w
mul_pp r0.y, r2.w, r0.x
mul_pp r1.xy, r0, c9
add_pp r2.w, r1.x, r1.y
texld r0, v0, s0
mul_pp r1, r0, c7
texld r0, v2, s2
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r1, c4.w
mov_pp r0.w, c4.x
mul_pp r0.w, c6.x, r0
mul_pp r2.xyz, r2, r2.w
mul_pp r0.xyz, r0, r1
mul_pp r1.xyz, r1, r2
add_pp r2.x, r1.w, -c8
mul_pp r0.w, r0, c5.x
cmp r2.x, r2, c9.z, c9.w
mul_pp r1.xyz, r1, r0.w
mov_pp r2, -r2.x
mad_pp oC0.xyz, r0, c10.x, r1
texkill r2.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedaighfmjclgbdenacjdpdngiemkpepidiabaaaaaamaafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcliaeaaaaeaaaaaaacoabaaaafjaaaaaeegiocaaaaaaaaaaabcaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabbaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaaabaaaaaa
akaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaalhnbeadpceljhmdo
aaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [UniformOcclusion]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_ShadowMapTexture] 2D 2
"ps_3_0
; 30 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c10, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c11, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord5 v5
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c10
add_pp r0.w, r1.x, r1.y
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
texld r0, v0, s0
mul_pp r0, r0, c8
mul_pp r0.xyz, r0, c6.w
dp3_pp_sat r1.w, v2, r2
mul_pp r2.xyz, r0, r1.w
mul_pp r1.xyz, r1, r0
add_pp r1.w, r0, -c9.x
texldp r3.x, v5, s2
mul_pp r2.xyz, r2, c5
mul_pp r2.xyz, r2, r3.x
mul_pp r0.xyz, r0, v3
mad_pp r0.xyz, r2, c11.x, r0
cmp r2.x, r1.w, c10.z, c10.w
mov_pp r1.w, c6.x
mov_pp r2, -r2.x
mul_pp r1.w, c7.x, r1
mad_pp oC0.xyz, r1, r1.w, r0
texkill r2.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_DiffCubeIBL] CUBE 2
SetTexture 2 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Matrix 144 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedhfolmopjceiiofhdnaddeehjhkamgddmabaaaaaammagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaaaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeafaaaaeaaaaaaagfabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadlcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaabeaaaaaadiaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaf
bcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
abaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaalaaaaaaaaaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaa
agajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaajaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaakaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaalaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaa
apaaaaakicaabaaaabaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
ahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaajicaabaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaabacaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaa
egacbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaaeaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaaoaaaaah
dcaabaaaadaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaajpcaabaaa
adaaaaaaegaabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaaegacbaaaaaaaaaaa
diaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaackiacaaaaaaaaaaa
aiaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_ShadowMapTexture] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 30 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c10, 8.00000000, 2.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r1, r0, s1
texld r0, v2, s3
texldp r3.x, v3, s2
mul_pp r2.xyz, r0, r3.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c10.x
mul_pp r2.xyz, r2, c10.y
min_pp r2.xyz, r0, r2
mul_pp r3.xyz, r0, r3.x
mul_pp r0.w, r1, r1
mul_pp r0.x, r1.w, r0.w
max_pp r3.xyz, r2, r3
mul_pp r2.xy, r0.wxzw, c9
add_pp r1.w, r2.x, r2.y
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c4.w
add_pp r2.x, r0.w, -c8
mov_pp r1.w, c4.x
mul_pp r1.w, c6.x, r1
mul_pp r1.xyz, r0, r1
mul_pp r1.w, r1, c5.x
cmp r2.w, r2.x, c9.z, c9
mul_pp r2.xyz, r1, r1.w
mov_pp r1, -r2.w
mad_pp oC0.xyz, r0, r3, r2
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_DiffCubeIBL] CUBE 2
SetTexture 2 [_ShadowMapTexture] 2D 0
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 352
Matrix 144 [SkyMatrix]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 336 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkcdlenloagabhjingifbodmodcgkpajdabaaaaaaleagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckmafaaaaeaaaaaaaglabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fidaaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabfaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaai
bcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaadiaaaaai
ccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaakaaaaaadiaaaaai
ecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaajaaaaaadiaaaaai
ccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaakaaaaaadiaaaaai
ecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaalaaaaaaaaaaaaah
ocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaalaaaaaaaaaaaaahhcaabaaa
abaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaadiaaaaahbcaabaaa
acaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaa
dkaabaaaabaaaaaaakaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaa
lhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaackiacaaa
aaaaaaaaaiaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaa
efaaaaajpcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
adaaaaaadiaaaaahocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaa
acaaaaaafgaobaaaacaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaa
agaabaaaacaaaaaaegacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaa
acaaaaaaegacbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_ShadowMapTexture] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 30 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c10, 8.00000000, 2.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord4 v4
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r1, r0, s1
texld r0, v2, s3
texldp r3.x, v4, s2
mul_pp r2.xyz, r0, r3.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c10.x
mul_pp r2.xyz, r2, c10.y
min_pp r2.xyz, r0, r2
mul_pp r3.xyz, r0, r3.x
mul_pp r0.w, r1, r1
mul_pp r0.x, r1.w, r0.w
max_pp r3.xyz, r2, r3
mul_pp r2.xy, r0.wxzw, c9
add_pp r1.w, r2.x, r2.y
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c4.w
add_pp r2.x, r0.w, -c8
mov_pp r1.w, c4.x
mul_pp r1.w, c6.x, r1
mul_pp r1.xyz, r0, r1
mul_pp r1.w, r1, c5.x
cmp r2.w, r2.x, c9.z, c9
mul_pp r2.xyz, r1, r1.w
mov_pp r1, -r2.w
mad_pp oC0.xyz, r0, r3, r2
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_DiffCubeIBL] CUBE 2
SetTexture 2 [_ShadowMapTexture] 2D 0
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 352
Matrix 144 [SkyMatrix]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 336 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedlpfmmephcnjldmjaiodjgonnmclfendoabaaaaaammagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckmafaaaa
eaaaaaaaglabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaabfaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaalaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaalaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaaabaaaaaa
akaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaalhnbeadpceljhmdo
aaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaackiacaaaaaaaaaaaaiaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaogbkbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaah
ocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaacaaaaaafgaobaaa
acaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaacaaaaaa
egacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaa
adaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [UniformOcclusion]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
"ps_3_0
; 25 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
texld r0, v0, s0
mul_pp r0, r0, c8
mul_pp r0.xyz, r0, c6.w
dp3_pp_sat r1.w, v2, r2
mul_pp r2.xyz, r0, r1.w
mul_pp r1.xyz, r1, r0
mul_pp r2.xyz, r2, c5
mul_pp r0.xyz, r0, v3
mad_pp r0.xyz, r2, c10.z, r0
add_pp r1.w, r0, -c9.x
cmp r2.x, r1.w, c10, c10.y
mov_pp r1.w, c6.x
mov_pp r2, -r2.x
mul_pp r1.w, c7.x, r1
mad_pp oC0.xyz, r1, r1.w, r0
texkill r2.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
ConstBuffer "$Globals" 272
Matrix 80 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 256 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedfijbpacbhbccejcjfncjnffcggflljbdabaaaaaanaafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefclaaeaaaa
eaaaaaaacmabaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabaaaaaaadiaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaf
bcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
abaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaabkaabaaaabaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaackaabaaaabaaaaaa
ckiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaa
agajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaa
aaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaajicaabaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaabaaaaaaaaaaaaaabacaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaa
egacbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaaeaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaa
aaaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaa
aaaaaaaaaeaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
"ps_3_0
; 21 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c9, 0.00000000, 1.00000000, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r0.xyz, r0, r0.w
texld r1, v0, s0
mul_pp r2, r1, c7
mul_pp r2.xyz, r2, c4.w
texld r1, v2, s2
mul_pp r1.xyz, r1.w, r1
mov_pp r0.w, c4.x
mul_pp r0.w, c6.x, r0
add_pp r1.w, r2, -c8.x
mul_pp r0.xyz, r2, r0
mul_pp r1.xyz, r1, r2
mul_pp r0.w, r0, c5.x
mul_pp r2.xyz, r0, r0.w
cmp r1.w, r1, c9.x, c9.y
mov_pp r0, -r1.w
mad_pp oC0.xyz, r1, c9.z, r2
texkill r0.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedjleoljmjobombeeoobemggaeaffnnjaoabaaaaaaeiafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcfiaeaaaaeaaaaaaabgabaaaafjaaaaaeegiocaaa
aaaaaaaabcaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaai
bcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaai
bcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaah
ocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaa
abaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaa
aaaaaaaaaeaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
"ps_3_0
; 21 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c9, 0.00000000, 1.00000000, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r0.xyz, r0, r0.w
texld r1, v0, s0
mul_pp r2, r1, c7
mul_pp r2.xyz, r2, c4.w
texld r1, v2, s2
mul_pp r1.xyz, r1.w, r1
mov_pp r0.w, c4.x
mul_pp r0.w, c6.x, r0
add_pp r1.w, r2, -c8.x
mul_pp r0.xyz, r2, r0
mul_pp r1.xyz, r1, r2
mul_pp r0.w, r0, c5.x
mul_pp r2.xyz, r0, r0.w
cmp r1.w, r1, c9.x, c9.y
mov_pp r0, -r1.w
mad_pp oC0.xyz, r1, c9.z, r2
texkill r0.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [unity_Lightmap] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedaomjmlnoglokhepafkpklnoiildmlgcbabaaaaaagaafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcfiaeaaaaeaaaaaaabgabaaaafjaaaaaeegiocaaaaaaaaaaabcaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabbaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [UniformOcclusion]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_ShadowMapTexture] 2D 2
"ps_3_0
; 26 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord5 v5
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
texld r0, v0, s0
mul_pp r0, r0, c8
mul_pp r0.xyz, r0, c6.w
dp3_pp_sat r1.w, v2, r2
mul_pp r2.xyz, r0, r1.w
mul_pp r1.xyz, r1, r0
add_pp r1.w, r0, -c9.x
texldp r3.x, v5, s2
mul_pp r2.xyz, r2, c5
mul_pp r2.xyz, r2, r3.x
mul_pp r0.xyz, r0, v3
mad_pp r0.xyz, r2, c10.z, r0
cmp r2.x, r1.w, c10, c10.y
mov_pp r1.w, c6.x
mov_pp r2, -r2.x
mul_pp r1.w, c7.x, r1
mad_pp oC0.xyz, r1, r1.w, r0
texkill r2.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_DiffCubeIBL] CUBE 2
SetTexture 2 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Matrix 144 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedobofdaehkidaemecbiednnmgkdgheefpabaaaaaagmagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaaaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdeafaaaaeaaaaaaaenabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadlcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaabeaaaaaadiaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaadbaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaa
baaaaaajbcaabaaaabaaaaaaegiccaaaabaaaaaaaaaaaaaaegiccaaaabaaaaaa
aaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaabaaaaaaaaaaaaaabacaaaahbcaabaaa
abaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
diaaaaahocaabaaaacaaaaaaagajbaaaaaaaaaaaagbjbaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaaagaabaaaacaaaaaajgahbaaaacaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaadaaaaaabkaabaaaacaaaaaa
bkiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaadaaaaaabkaabaaaacaaaaaa
bkiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaadaaaaaabkaabaaaacaaaaaa
bkiacaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaeaaaaaackaabaaaacaaaaaa
ckiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaaeaaaaaackaabaaaacaaaaaa
ckiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaaeaaaaaackaabaaaacaaaaaa
ckiacaaaaaaaaaaaalaaaaaaaaaaaaahocaabaaaacaaaaaaagajbaaaadaaaaaa
agajbaaaaeaaaaaadiaaaaaibcaabaaaadaaaaaaakaabaaaacaaaaaaakiacaaa
aaaaaaaaajaaaaaadiaaaaaiccaabaaaadaaaaaaakaabaaaacaaaaaaakiacaaa
aaaaaaaaakaaaaaadiaaaaaiecaabaaaadaaaaaaakaabaaaacaaaaaaakiacaaa
aaaaaaaaalaaaaaaaaaaaaahhcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaa
adaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaa
acaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaackiacaaaaaaaaaaa
aiaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_ShadowMapTexture] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 26 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
texld r0, v2, s3
mul_pp r1.xyz, r0.w, r0
mul_pp r2.xyz, r1, c9.z
texldp r1.x, v3, s2
mul_pp r0.xyz, r0, r1.x
mul_pp r3.xyz, r0, c9.w
min_pp r3.xyz, r2, r3
mul_pp r2.xyz, r2, r1.x
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r0.xyz, r0.w, v1
mul r1.yzw, r0.z, c2.xxyz
mad r1.xyz, r0.y, c1, r1.yzww
mad r1.xyz, r0.x, c0, r1
texld r1, r1, s1
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c7
max_pp r2.xyz, r3, r2
mul_pp r3.xyz, r0, c4.w
mul_pp r0.xyz, r3, r1
mov_pp r1.w, c4.x
mul_pp r1.x, c6, r1.w
mul_pp r1.x, r1, c5
mul_pp r0.xyz, r0, r1.x
add_pp r1.y, r0.w, -c8.x
cmp r1.y, r1, c9.x, c9
mov_pp r1, -r1.y
mad_pp oC0.xyz, r3, r2, r0
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_DiffCubeIBL] CUBE 2
SetTexture 2 [_ShadowMapTexture] 2D 0
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 352
Matrix 144 [SkyMatrix]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 336 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecednihldaiabagcgmihjddfafllpefbmjckabaaaaaafeagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcemafaaaaeaaaaaaafdabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fidaaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabfaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaai
bcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaadiaaaaai
ccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaakaaaaaadiaaaaai
ecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaajaaaaaadiaaaaai
ccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaakaaaaaadiaaaaai
ecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaalaaaaaaaaaaaaah
ocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaa
acaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaalaaaaaaaaaaaaahhcaabaaa
abaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaackiacaaa
aaaaaaaaaiaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaa
efaaaaajpcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
adaaaaaadiaaaaahocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaa
acaaaaaafgaobaaaacaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaa
agaabaaaacaaaaaaegacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaa
acaaaaaaegacbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_ShadowMapTexture] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 26 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord4 v4
texld r0, v2, s3
mul_pp r1.xyz, r0.w, r0
mul_pp r2.xyz, r1, c9.z
texldp r1.x, v4, s2
mul_pp r0.xyz, r0, r1.x
mul_pp r3.xyz, r0, c9.w
min_pp r3.xyz, r2, r3
mul_pp r2.xyz, r2, r1.x
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r0.xyz, r0.w, v1
mul r1.yzw, r0.z, c2.xxyz
mad r1.xyz, r0.y, c1, r1.yzww
mad r1.xyz, r0.x, c0, r1
texld r1, r1, s1
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c7
max_pp r2.xyz, r3, r2
mul_pp r3.xyz, r0, c4.w
mul_pp r0.xyz, r3, r1
mov_pp r1.w, c4.x
mul_pp r1.x, c6, r1.w
mul_pp r1.x, r1, c5
mul_pp r0.xyz, r0, r1.x
add_pp r1.y, r0.w, -c8.x
cmp r1.y, r1, c9.x, c9
mov_pp r1, -r1.y
mad_pp oC0.xyz, r3, r2, r0
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_DiffCubeIBL] CUBE 2
SetTexture 2 [_ShadowMapTexture] 2D 0
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 352
Matrix 144 [SkyMatrix]
Vector 112 [ExposureIBL]
Vector 128 [ExposureLM] 2
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 336 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecednclmeiagagepfmmeklacgamjmkjkeokeabaaaaaagmagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcemafaaaa
eaaaaaaafdabaaaafjaaaaaeegiocaaaaaaaaaaabgaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaabfaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaalaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaajaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaakaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaalaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaackiacaaaaaaaaaaaaiaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaogbkbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaah
ocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaacaaaaaafgaobaaa
acaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaacaaaaaa
egacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaa
adaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "QUEUE"="AlphaTest" "IGNOREPROJECTOR"="True" "RenderType"="TransparentCutout" }
  ZWrite Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w);
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedcokinidigakjdlhimmgdldabpcbonhibabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = frag_6.xyz;
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Vector 10 [unity_Scale]
Vector 11 [_MainTex_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o3.xyz, c9
add o4.xyz, -r0, c8
mad o1.xy, v2, c11, c11.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedoajngkfclnbdfdbmigppbnhmaicknmfkabaaaaaahmaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoaacaaaaeaaaabaa
liaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz))).w));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.w, r0, c11
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedafohpbljdkfcichgdclcknbigflkedicabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedcokinidigakjdlhimmgdldabpcbonhibabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * texture2D (_LightTexture0, xlv_TEXCOORD4).w);
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecednhmichcjbmjgmcchehhjbfedicgbpkghabaaaaaanaafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcbmaeaaaaeaaaabaaahabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaa
aeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaa
agiecaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaa
aaaaaaaabdaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaa
adaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz)));
  vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  float tmpvar_10;
  if ((tmpvar_9.x < (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))) {
    tmpvar_10 = _LightShadowData.x;
  } else {
    tmpvar_10 = 1.0;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = (frag_11.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_7.w) * tmpvar_8.w) * tmpvar_10));
  c_1.xyz = frag_11.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefiecedhnjgdfbpljjhenbkhmifiipbbfedndflabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaa
ogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz))).w) * (_LightShadowData.x + (shadow2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x * (1.0 - _LightShadowData.x)))));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefiecedhnjgdfbpljjhenbkhmifiipbbfedndflabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaa
ogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = o_3;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x);
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceLightPos0]
Vector 12 [unity_Scale]
Vector 13 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mov o0, r0
mul r1.y, r1, c9.x
mad o5.xy, r1.z, c10.zwzw, r1
mul r1.xyz, v1, c12.w
mov o5.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c11
add o4.xyz, -r0, c8
mad o1.xy, v2, c13, c13.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedlgaeakabhnkjonloapdibpmgpbbghcopabaaaaaacmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchiadaaaaeaaaabaanoaaaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaa
ogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaag
hccabaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaa
abaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
afaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
  xlv_TEXCOORD5 = o_3;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * (texture2D (_LightTexture0, xlv_TEXCOORD4).w * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_Scale]
Vector 17 [_MainTex_ST]
"vs_3_0
; 22 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c18, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c16.w
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r0.xyz, r2.xyww, c18.x
mul r0.y, r0, c13.x
mad o6.xy, r0.z, c14.zwzw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o0, r2
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
mov o6.zw, r2
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c15
add o4.xyz, -r0, c12
mad o1.xy, v2, c17, c17.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 400
Matrix 112 [_LightMatrix0]
Vector 368 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedkiillnejehjgoelibdponlemdledjfdjabaaaaaaiaagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcleaeaaaaeaaaabaacnabaaaafjaaaaaeegiocaaaaaaaaaaa
biaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaipcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
anaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaabaaaaaadiaaaaai
dcaabaaaacaaaaaafgafbaaaabaaaaaaegiacaaaaaaaaaaaaiaaaaaadcaaaaak
dcaabaaaabaaaaaaegiacaaaaaaaaaaaahaaaaaaagaabaaaabaaaaaaegaabaaa
acaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaajaaaaaakgakbaaa
abaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiecaaaaaaaaaaa
akaaaaaapgapbaaaabaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabhaaaaaaogikcaaaaaaaaaaabhaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaa
acaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaa
aeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  float tmpvar_8;
  tmpvar_8 = ((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97);
  float tmpvar_9;
  tmpvar_9 = dot (textureCube (_ShadowMapTexture, xlv_TEXCOORD5), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  float tmpvar_10;
  if ((tmpvar_9 < tmpvar_8)) {
    tmpvar_10 = _LightShadowData.x;
  } else {
    tmpvar_10 = 1.0;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = (frag_11.xyz * (tmpvar_7.w * tmpvar_10));
  c_1.xyz = frag_11.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  float tmpvar_9;
  tmpvar_9 = ((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97);
  float tmpvar_10;
  tmpvar_10 = dot (textureCube (_ShadowMapTexture, xlv_TEXCOORD5), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  float tmpvar_11;
  if ((tmpvar_10 < tmpvar_9)) {
    tmpvar_11 = _LightShadowData.x;
  } else {
    tmpvar_11 = 1.0;
  };
  vec4 frag_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_13.w = tmpvar_4;
  frag_12.w = tmpvar_13.w;
  frag_12.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_12.xyz = (frag_12.xyz * ((tmpvar_7.w * tmpvar_8.w) * tmpvar_11));
  c_1.xyz = frag_12.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz)));
  vec4 shadowVals_9;
  vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD5.xyz / xlv_TEXCOORD5.w);
  shadowVals_9.x = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_9.y = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_9.z = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_9.w = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (shadowVals_9, tmpvar_10.zzzz);
  vec4 tmpvar_12;
  tmpvar_12 = _LightShadowData.xxxx;
  float tmpvar_13;
  if (tmpvar_11.x) {
    tmpvar_13 = tmpvar_12.x;
  } else {
    tmpvar_13 = 1.0;
  };
  float tmpvar_14;
  if (tmpvar_11.y) {
    tmpvar_14 = tmpvar_12.y;
  } else {
    tmpvar_14 = 1.0;
  };
  float tmpvar_15;
  if (tmpvar_11.z) {
    tmpvar_15 = tmpvar_12.z;
  } else {
    tmpvar_15 = 1.0;
  };
  float tmpvar_16;
  if (tmpvar_11.w) {
    tmpvar_16 = tmpvar_12.w;
  } else {
    tmpvar_16 = 1.0;
  };
  vec4 tmpvar_17;
  tmpvar_17.x = tmpvar_13;
  tmpvar_17.y = tmpvar_14;
  tmpvar_17.z = tmpvar_15;
  tmpvar_17.w = tmpvar_16;
  vec4 frag_18;
  vec4 tmpvar_19;
  tmpvar_19.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_19.w = tmpvar_4;
  frag_18.w = tmpvar_19.w;
  frag_18.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_18.xyz = (frag_18.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_7.w) * tmpvar_8.w) * dot (tmpvar_17, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_18.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 400
Matrix 112 [_LightMatrix0]
Vector 368 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefieceddnpmlknbaekpnochemjedckhpplfbdhkabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
biaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabhaaaaaa
ogikcaaaaaaaaaaabhaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaiaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaahaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaajaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaakaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _ShadowOffsets[4];
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 shadows_6;
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD5.xyz / xlv_TEXCOORD5.w);
  shadows_6.x = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[0].xyz)).x;
  shadows_6.y = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[1].xyz)).x;
  shadows_6.z = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[2].xyz)).x;
  shadows_6.w = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[3].xyz)).x;
  vec4 tmpvar_8;
  tmpvar_8 = (_LightShadowData.xxxx + (shadows_6 * (1.0 - _LightShadowData.xxxx)));
  shadows_6 = tmpvar_8;
  vec4 frag_9;
  vec4 tmpvar_10;
  tmpvar_10.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_10.w = tmpvar_4;
  frag_9.w = tmpvar_10.w;
  frag_9.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_9.xyz = (frag_9.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz))).w) * dot (tmpvar_8, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_9.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 400
Matrix 112 [_LightMatrix0]
Vector 368 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefieceddnpmlknbaekpnochemjedckhpplfbdhkabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
biaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabhaaaaaa
ogikcaaaaaaaaaaabhaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaiaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaahaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaajaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaakaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  vec4 shadowVals_8;
  shadowVals_8.x = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_8.y = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_8.z = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_8.w = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (shadowVals_8, vec4(((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97)));
  vec4 tmpvar_10;
  tmpvar_10 = _LightShadowData.xxxx;
  float tmpvar_11;
  if (tmpvar_9.x) {
    tmpvar_11 = tmpvar_10.x;
  } else {
    tmpvar_11 = 1.0;
  };
  float tmpvar_12;
  if (tmpvar_9.y) {
    tmpvar_12 = tmpvar_10.y;
  } else {
    tmpvar_12 = 1.0;
  };
  float tmpvar_13;
  if (tmpvar_9.z) {
    tmpvar_13 = tmpvar_10.z;
  } else {
    tmpvar_13 = 1.0;
  };
  float tmpvar_14;
  if (tmpvar_9.w) {
    tmpvar_14 = tmpvar_10.w;
  } else {
    tmpvar_14 = 1.0;
  };
  vec4 tmpvar_15;
  tmpvar_15.x = tmpvar_11;
  tmpvar_15.y = tmpvar_12;
  tmpvar_15.z = tmpvar_13;
  tmpvar_15.w = tmpvar_14;
  vec4 frag_16;
  vec4 tmpvar_17;
  tmpvar_17.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_17.w = tmpvar_4;
  frag_16.w = tmpvar_17.w;
  frag_16.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_16.xyz = (frag_16.xyz * (tmpvar_7.w * dot (tmpvar_15, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_16.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  vec4 shadowVals_9;
  shadowVals_9.x = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_9.y = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_9.z = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_9.w = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  bvec4 tmpvar_10;
  tmpvar_10 = lessThan (shadowVals_9, vec4(((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97)));
  vec4 tmpvar_11;
  tmpvar_11 = _LightShadowData.xxxx;
  float tmpvar_12;
  if (tmpvar_10.x) {
    tmpvar_12 = tmpvar_11.x;
  } else {
    tmpvar_12 = 1.0;
  };
  float tmpvar_13;
  if (tmpvar_10.y) {
    tmpvar_13 = tmpvar_11.y;
  } else {
    tmpvar_13 = 1.0;
  };
  float tmpvar_14;
  if (tmpvar_10.z) {
    tmpvar_14 = tmpvar_11.z;
  } else {
    tmpvar_14 = 1.0;
  };
  float tmpvar_15;
  if (tmpvar_10.w) {
    tmpvar_15 = tmpvar_11.w;
  } else {
    tmpvar_15 = 1.0;
  };
  vec4 tmpvar_16;
  tmpvar_16.x = tmpvar_12;
  tmpvar_16.y = tmpvar_13;
  tmpvar_16.z = tmpvar_14;
  tmpvar_16.w = tmpvar_15;
  vec4 frag_17;
  vec4 tmpvar_18;
  tmpvar_18.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_18.w = tmpvar_4;
  frag_17.w = tmpvar_18.w;
  frag_17.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_17.xyz = (frag_17.xyz * ((tmpvar_7.w * tmpvar_8.w) * dot (tmpvar_16, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_17.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w);
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedcokinidigakjdlhimmgdldabpcbonhibabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = frag_6.xyz;
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Vector 10 [unity_Scale]
Vector 11 [_MainTex_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o3.xyz, c9
add o4.xyz, -r0, c8
mad o1.xy, v2, c11, c11.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedoajngkfclnbdfdbmigppbnhmaicknmfkabaaaaaahmaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoaacaaaaeaaaabaa
liaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz))).w));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.w, r0, c11
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedafohpbljdkfcichgdclcknbigflkedicabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedcokinidigakjdlhimmgdldabpcbonhibabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * texture2D (_LightTexture0, xlv_TEXCOORD4).w);
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_MainTex_ST]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecednhmichcjbmjgmcchehhjbfedicgbpkghabaaaaaanaafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcbmaeaaaaeaaaabaaahabaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaa
aeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaa
agiecaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaa
aaaaaaaabdaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaa
adaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz)));
  vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  float tmpvar_10;
  if ((tmpvar_9.x < (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))) {
    tmpvar_10 = _LightShadowData.x;
  } else {
    tmpvar_10 = 1.0;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = (frag_11.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_7.w) * tmpvar_8.w) * tmpvar_10));
  c_1.xyz = frag_11.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefiecedhnjgdfbpljjhenbkhmifiipbbfedndflabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaa
ogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz))).w) * (_LightShadowData.x + (shadow2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x * (1.0 - _LightShadowData.x)))));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefiecedhnjgdfbpljjhenbkhmifiipbbfedndflabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaa
ogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = o_3;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x);
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceLightPos0]
Vector 12 [unity_Scale]
Vector 13 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mov o0, r0
mul r1.y, r1, c9.x
mad o5.xy, r1.z, c10.zwzw, r1
mul r1.xyz, v1, c12.w
mov o5.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c11
add o4.xyz, -r0, c8
mad o1.xy, v2, c13, c13.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedlgaeakabhnkjonloapdibpmgpbbghcopabaaaaaacmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchiadaaaaeaaaabaanoaaaaaafjaaaaae
egiocaaaaaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabdaaaaaa
ogikcaaaaaaaaaaabdaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaag
hccabaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaa
abaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
afaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
  xlv_TEXCOORD5 = o_3;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 frag_6;
  vec4 tmpvar_7;
  tmpvar_7.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_7.w = tmpvar_4;
  frag_6.w = tmpvar_7.w;
  frag_6.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(xlv_TEXCOORD2)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_6.xyz = (frag_6.xyz * (texture2D (_LightTexture0, xlv_TEXCOORD4).w * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x));
  c_1.xyz = frag_6.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_Scale]
Vector 17 [_MainTex_ST]
"vs_3_0
; 22 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c18, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c16.w
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r0.xyz, r2.xyww, c18.x
mul r0.y, r0, c13.x
mad o6.xy, r0.z, c14.zwzw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o0, r2
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
mov o6.zw, r2
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c15
add o4.xyz, -r0, c12
mad o1.xy, v2, c17, c17.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 400
Matrix 112 [_LightMatrix0]
Vector 368 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedkiillnejehjgoelibdponlemdledjfdjabaaaaaaiaagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcleaeaaaaeaaaabaacnabaaaafjaaaaaeegiocaaaaaaaaaaa
biaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaipcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
anaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaabaaaaaadiaaaaai
dcaabaaaacaaaaaafgafbaaaabaaaaaaegiacaaaaaaaaaaaaiaaaaaadcaaaaak
dcaabaaaabaaaaaaegiacaaaaaaaaaaaahaaaaaaagaabaaaabaaaaaaegaabaaa
acaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaajaaaaaakgakbaaa
abaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiecaaaaaaaaaaa
akaaaaaapgapbaaaabaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabhaaaaaaogikcaaaaaaaaaaabhaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaa
egaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaa
acaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaa
aeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  float tmpvar_8;
  tmpvar_8 = ((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97);
  float tmpvar_9;
  tmpvar_9 = dot (textureCube (_ShadowMapTexture, xlv_TEXCOORD5), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  float tmpvar_10;
  if ((tmpvar_9 < tmpvar_8)) {
    tmpvar_10 = _LightShadowData.x;
  } else {
    tmpvar_10 = 1.0;
  };
  vec4 frag_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_12.w = tmpvar_4;
  frag_11.w = tmpvar_12.w;
  frag_11.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_11.xyz = (frag_11.xyz * (tmpvar_7.w * tmpvar_10));
  c_1.xyz = frag_11.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  float tmpvar_9;
  tmpvar_9 = ((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97);
  float tmpvar_10;
  tmpvar_10 = dot (textureCube (_ShadowMapTexture, xlv_TEXCOORD5), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  float tmpvar_11;
  if ((tmpvar_10 < tmpvar_9)) {
    tmpvar_11 = _LightShadowData.x;
  } else {
    tmpvar_11 = 1.0;
  };
  vec4 frag_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_13.w = tmpvar_4;
  frag_12.w = tmpvar_13.w;
  frag_12.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_12.xyz = (frag_12.xyz * ((tmpvar_7.w * tmpvar_8.w) * tmpvar_11));
  c_1.xyz = frag_12.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz)));
  vec4 shadowVals_9;
  vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD5.xyz / xlv_TEXCOORD5.w);
  shadowVals_9.x = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_9.y = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_9.z = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_9.w = texture2D (_ShadowMapTexture, (tmpvar_10.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (shadowVals_9, tmpvar_10.zzzz);
  vec4 tmpvar_12;
  tmpvar_12 = _LightShadowData.xxxx;
  float tmpvar_13;
  if (tmpvar_11.x) {
    tmpvar_13 = tmpvar_12.x;
  } else {
    tmpvar_13 = 1.0;
  };
  float tmpvar_14;
  if (tmpvar_11.y) {
    tmpvar_14 = tmpvar_12.y;
  } else {
    tmpvar_14 = 1.0;
  };
  float tmpvar_15;
  if (tmpvar_11.z) {
    tmpvar_15 = tmpvar_12.z;
  } else {
    tmpvar_15 = 1.0;
  };
  float tmpvar_16;
  if (tmpvar_11.w) {
    tmpvar_16 = tmpvar_12.w;
  } else {
    tmpvar_16 = 1.0;
  };
  vec4 tmpvar_17;
  tmpvar_17.x = tmpvar_13;
  tmpvar_17.y = tmpvar_14;
  tmpvar_17.z = tmpvar_15;
  tmpvar_17.w = tmpvar_16;
  vec4 frag_18;
  vec4 tmpvar_19;
  tmpvar_19.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_19.w = tmpvar_4;
  frag_18.w = tmpvar_19.w;
  frag_18.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_18.xyz = (frag_18.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_7.w) * tmpvar_8.w) * dot (tmpvar_17, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_18.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 400
Matrix 112 [_LightMatrix0]
Vector 368 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefieceddnpmlknbaekpnochemjedckhpplfbdhkabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
biaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabhaaaaaa
ogikcaaaaaaaaaaabhaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaiaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaahaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaajaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaakaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform mat4 unity_World2Shadow[4];
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _ShadowOffsets[4];
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec4 shadows_6;
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD5.xyz / xlv_TEXCOORD5.w);
  shadows_6.x = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[0].xyz)).x;
  shadows_6.y = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[1].xyz)).x;
  shadows_6.z = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[2].xyz)).x;
  shadows_6.w = shadow2D (_ShadowMapTexture, (tmpvar_7 + _ShadowOffsets[3].xyz)).x;
  vec4 tmpvar_8;
  tmpvar_8 = (_LightShadowData.xxxx + (shadows_6 * (1.0 - _LightShadowData.xxxx)));
  shadows_6 = tmpvar_8;
  vec4 frag_9;
  vec4 tmpvar_10;
  tmpvar_10.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_10.w = tmpvar_4;
  frag_9.w = tmpvar_10.w;
  frag_9.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(normalize(xlv_TEXCOORD2))), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_9.xyz = (frag_9.xyz * (((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz))).w) * dot (tmpvar_8, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_9.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [unity_World2Shadow0]
Matrix 8 [_Object2World]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c18.w
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.w, v0, c11
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp4 o6.w, r0, c7
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp3 o2.z, r1, c10
dp3 o2.y, r1, c9
dp3 o2.x, r1, c8
add o3.xyz, -r0, c17
add o4.xyz, -r0, c16
mad o1.xy, v2, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 400
Matrix 112 [_LightMatrix0]
Vector 368 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityPerDraw" 4
"vs_4_0
eefieceddnpmlknbaekpnochemjedckhpplfbdhkabaaaaaakiagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnmaeaaaaeaaaabaadhabaaaafjaaaaaeegiocaaaaaaaaaaa
biaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaaamaaaaaafjaaaaaeegiocaaaaeaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aeaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aeaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaeaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabhaaaaaa
ogikcaaaaaaaaaaabhaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaeaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaeaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaeaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaaeaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaaeaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaeaaaaaaanaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaeaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaeaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaaaaaaaaaaiaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaahaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaajaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaakaaaaaapgapbaaa
aaaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaagaaaaaaegiocaaaadaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  vec4 shadowVals_8;
  shadowVals_8.x = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_8.y = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_8.z = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_8.w = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (shadowVals_8, vec4(((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97)));
  vec4 tmpvar_10;
  tmpvar_10 = _LightShadowData.xxxx;
  float tmpvar_11;
  if (tmpvar_9.x) {
    tmpvar_11 = tmpvar_10.x;
  } else {
    tmpvar_11 = 1.0;
  };
  float tmpvar_12;
  if (tmpvar_9.y) {
    tmpvar_12 = tmpvar_10.y;
  } else {
    tmpvar_12 = 1.0;
  };
  float tmpvar_13;
  if (tmpvar_9.z) {
    tmpvar_13 = tmpvar_10.z;
  } else {
    tmpvar_13 = 1.0;
  };
  float tmpvar_14;
  if (tmpvar_9.w) {
    tmpvar_14 = tmpvar_10.w;
  } else {
    tmpvar_14 = 1.0;
  };
  vec4 tmpvar_15;
  tmpvar_15.x = tmpvar_11;
  tmpvar_15.y = tmpvar_12;
  tmpvar_15.z = tmpvar_13;
  tmpvar_15.w = tmpvar_14;
  vec4 frag_16;
  vec4 tmpvar_17;
  tmpvar_17.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_17.w = tmpvar_4;
  frag_16.w = tmpvar_17.w;
  frag_16.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_16.xyz = (frag_16.xyz * (tmpvar_7.w * dot (tmpvar_15, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_16.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
  xlv_TEXCOORD5 = ((_Object2World * gl_Vertex).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform samplerCube _ShadowMapTexture;
uniform vec4 _LightColor0;
uniform vec4 _LightShadowData;
uniform vec4 _LightPositionRange;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  float tmpvar_4;
  tmpvar_4 = diff_2.w;
  float x_5;
  x_5 = (tmpvar_3.w - _Cutoff);
  if ((x_5 < 0.0)) {
    discard;
  };
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)));
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  vec4 shadowVals_9;
  shadowVals_9.x = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_9.y = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_9.z = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  shadowVals_9.w = dot (textureCube (_ShadowMapTexture, (xlv_TEXCOORD5 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.00392157, 1.53787e-05, 6.22737e-09));
  bvec4 tmpvar_10;
  tmpvar_10 = lessThan (shadowVals_9, vec4(((sqrt(dot (xlv_TEXCOORD5, xlv_TEXCOORD5)) * _LightPositionRange.w) * 0.97)));
  vec4 tmpvar_11;
  tmpvar_11 = _LightShadowData.xxxx;
  float tmpvar_12;
  if (tmpvar_10.x) {
    tmpvar_12 = tmpvar_11.x;
  } else {
    tmpvar_12 = 1.0;
  };
  float tmpvar_13;
  if (tmpvar_10.y) {
    tmpvar_13 = tmpvar_11.y;
  } else {
    tmpvar_13 = 1.0;
  };
  float tmpvar_14;
  if (tmpvar_10.z) {
    tmpvar_14 = tmpvar_11.z;
  } else {
    tmpvar_14 = 1.0;
  };
  float tmpvar_15;
  if (tmpvar_10.w) {
    tmpvar_15 = tmpvar_11.w;
  } else {
    tmpvar_15 = 1.0;
  };
  vec4 tmpvar_16;
  tmpvar_16.x = tmpvar_12;
  tmpvar_16.y = tmpvar_13;
  tmpvar_16.z = tmpvar_14;
  tmpvar_16.w = tmpvar_15;
  vec4 frag_17;
  vec4 tmpvar_18;
  tmpvar_18.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_18.w = tmpvar_4;
  frag_17.w = tmpvar_18.w;
  frag_17.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize(tmpvar_6)), 0.0, 1.0)) * diff_2.xyz) * _LightColor0.xyz);
  frag_17.xyz = (frag_17.xyz * ((tmpvar_7.w * tmpvar_8.w) * dot (tmpvar_16, vec4(0.25, 0.25, 0.25, 0.25))));
  c_1.xyz = frag_17.xyz;
  c_1.w = tmpvar_4;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [_LightPositionRange]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
add o6.xyz, r0, -c14
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Matrix 48 [_LightMatrix0]
Vector 304 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeaciieddhkekigcaimhmickidiielgjfabaaaaaaceagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfiaeaaaaeaaaabaabgabaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaaaaaaaaajhccabaaaagaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaaabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTexture0] 2D 2
"ps_3_0
; 18 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, r1
texld r0, v0, s0
mul_pp r0, r0, c6
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
mul_pp r1.xyz, r0, c4
add_pp r0.y, r0.w, -c7.x
dp3 r0.x, v4, v4
cmp r1.w, r0.y, c8.x, c8.y
texld r0.x, r0.x, s2
mul_pp r0.xyz, r1, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbgnmhmhmpdadcmpmnifmoimdfojekfbpabaaaaaakeadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcieacaaaa
eaaaaaaakbaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
; 13 ALU, 2 TEX
dcl_2d s0
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
texld r0, v0, s0
mul_pp r0, r0, c6
dp3_pp r1.x, v2, v2
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.w, r0, -c7.x
cmp r1.x, r1.w, c8, c8.y
mul_pp r0.xyz, r0, c4
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 272
Vector 16 [_LightColor0]
Vector 48 [ExposureIBL]
Vector 224 [_Color]
Float 256 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedpnpbdmcpaiglkiahljpffilabdpgpafgabaaaaaaaiadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcaaacaaaaeaaaaaaaiaaaaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabaaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihccabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
"ps_3_0
; 23 ALU, 4 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
def c8, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, r1
texld r0, v0, s0
mul_pp r0, r0.yzwx, c6.yzwx
mul_pp r0.xyw, r0.wxzy, c5.w
dp3_pp_sat r1.x, v1, r1
mul_pp r1.xyz, r1.x, r0.xyww
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c8.z
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c4
add_pp r0.y, r0.z, -c7.x
cmp r1.w, -v4.z, c8.x, c8.y
texld r0.w, r2, s2
mul_pp r0.w, r1, r0
texld r0.x, r0.x, s3
cmp r1.w, r0.y, c8.x, c8.y
mul_pp r0.x, r0.w, r0
mul_pp r0.xyw, r1.xyzz, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0.xyww, c8.w
texkill r1.xyzw
mov_pp oC0.w, r0.z
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedljfcfgdphgpnhilkgdaiciojghojobjcabaaaaaajiaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchiadaaaa
eaaaaaaanoaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaadaaaaaa
egbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaahbcaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaak
dcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaackbabaaa
afaaaaaaabaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaa
abaaaaaaagaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_LightTexture0] CUBE 3
"ps_3_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s2
dcl_cube s3
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, r1
texld r0, v0, s0
mul_pp r0, r0.yzwx, c6.yzwx
mul_pp r0.xyw, r0.wxzy, c5.w
dp3_pp_sat r1.x, v1, r1
mul_pp r1.xyz, r1.x, r0.xyww
add_pp r0.y, r0.z, -c7.x
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c4
texld r0.w, v4, s3
texld r0.x, r0.x, s2
cmp r1.w, r0.y, c8.x, c8.y
mul r0.x, r0, r0.w
mul_pp r0.xyw, r1.xyzz, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0.xyww, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0.z
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedddlbjkmbcppmiohkhmeojnipcfhgceofabaaaaaaaaaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaacaaaa
eaaaaaaaliaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaadaaaaaa
egbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaahbcaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaaj
pcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbcbaaaafaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTexture0] 2D 2
"ps_3_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xy
dp3_pp r1.x, v2, v2
texld r0, v0, s0
mul_pp r0, r0, c6
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c7
texld r1.w, v4, s2
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c8, c8.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedibfmhipcpibfpkldllfobaciidfkbcndabaaaaaaiiadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgiacaaaa
eaaaaaaajkaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_LINEAR" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"ps_3_0
; 28 ALU, 5 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c9, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
texld r0, v0, s0
mul_pp r2, r0, c7
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r0.xyz, r1.w, r1
mul_pp r1.xyz, r2, c6.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c5
add_pp r0.y, r2.w, -c8.x
texldp r0.x, v5, s4
rcp r0.z, v5.w
mad r0.w, -v5.z, r0.z, r0.x
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c9.z
mov r0.z, c4.x
cmp r0.z, r0.w, c9.y, r0
dp3 r0.x, v4, v4
texld r0.w, r2, s2
cmp r1.w, -v4.z, c9.x, c9.y
mul_pp r0.w, r1, r0
texld r0.x, r0.x, s3
mul_pp r0.x, r0.w, r0
mul_pp r0.z, r0.x, r0
mul_pp r1.xyz, r1, r0.z
cmp r0.x, r0.y, c9, c9.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c9.w
texkill r0.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecednifhmgekomaapbcbeafnboaddhoognajabaaaaaaiiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfaaeaaaaeaaaaaaabeabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bcaaaaaaakiacaiaebaaaaaaaaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahbcaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
bcaabaaaabaaaaaadkaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
fgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaacaaaaaaaoaaaaahocaabaaaabaaaaaa
agbjbaaaagaaaaaapgbpbaaaagaaaaaaefaaaaajpcaabaaaacaaaaaajgafbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadbaaaaahccaabaaaabaaaaaa
akaabaaaacaaaaaadkaabaaaabaaaaaadhaaaaakccaabaaaabaaaaaabkaabaaa
abaaaaaaakiacaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadpdiaaaaahbcaabaaa
abaaaaaabkaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaa
abaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaa
bacaaaahccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaah
ccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
fgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"ps_3_0
; 27 ALU, 5 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c9, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
texld r0, v0, s0
mul_pp r2, r0, c7
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r0.xyz, r1.w, r1
mul_pp r1.xyz, r2, c6.w
rcp r0.w, v4.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c5
mov r0.x, c4
add r0.z, c9.y, -r0.x
texldp r0.x, v5, s4
mad r0.z, r0.x, r0, c4.x
mad r2.xy, v4, r0.w, c9.z
dp3 r0.x, v4, v4
add_pp r0.y, r2.w, -c8.x
texld r0.w, r2, s2
cmp r1.w, -v4.z, c9.x, c9.y
mul_pp r0.w, r1, r0
texld r0.x, r0.x, s3
mul_pp r0.x, r0.w, r0
mul_pp r0.z, r0.x, r0
mul_pp r1.xyz, r1, r0.z
cmp r0.x, r0.y, c9, c9.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c9.w
texkill r0.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefieceddodoieompklkalaibjmojiielomfdhmfabaaaaaajiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgaaeaaaaeaaaaaaabiabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaiaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bcaaaaaaakiacaiaebaaaaaaaaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahbcaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
bcaabaaaabaaaaaadkaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
fgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaacaaaaaaaoaaaaahocaabaaaabaaaaaa
agbjbaaaagaaaaaapgbpbaaaagaaaaaaehaaaaalccaabaaaabaaaaaajgafbaaa
abaaaaaaaghabaaaadaaaaaaaagabaaaaaaaaaaadkaabaaaabaaaaaaaaaaaaaj
ecaabaaaabaaaaaaakiacaiaebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadp
dcaaaaakccaabaaaabaaaaaabkaabaaaabaaaaaackaabaaaabaaaaaaakiacaaa
abaaaaaabiaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaa
abaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaa
eeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaa
fgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaa
acaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaa
bkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_ShadowMapTexture] 2D 2
"ps_3_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3_pp r1.x, v2, v2
texld r0, v0, s0
rsq_pp r2.x, r1.x
mul_pp r1, r0, c6
mul_pp r0.xyz, r2.x, v2
mul_pp r1.xyz, r1, c5.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c4
add_pp r0.x, r1.w, -c7
texldp r2.x, v4, s2
cmp r0.x, r0, c8, c8.y
mul_pp r1.xyz, r1, r2.x
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c8.z
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmkhiflmojagfmlnddgceimenjihninbaabaaaaaakeadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcieacaaaa
eaaaaaaakbaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_ShadowMapTexture] 2D 2
SetTexture 3 [_LightTexture0] 2D 3
"ps_3_0
; 15 ALU, 4 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
dp3_pp r1.x, v2, v2
texld r0, v0, s0
mul_pp r0, r0, c6
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
mul_pp r1.xyz, r0, c4
add_pp r0.y, r0.w, -c7.x
texld r1.w, v4, s3
texldp r0.x, v5, s2
mul r0.x, r1.w, r0
cmp r1.w, r0.y, c8.x, c8.y
mul_pp r0.xyz, r1, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 400
Vector 16 [_LightColor0]
Vector 176 [ExposureIBL]
Vector 352 [_Color]
Float 384 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmikbgijenamkcppbdchbkclodfdbjghcabaaaaaaceaeaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaa
fjaaaaaeegiocaaaaaaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabgaaaaaaakiacaiaebaaaaaa
aaaaaaaabiaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabgaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
acaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_LINEAR" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_ShadowMapTexture] CUBE 2
SetTexture 3 [_LightTexture0] 2D 3
"ps_3_0
; 27 ALU, 4 TEX
dcl_2d s0
dcl_cube s2
dcl_2d s3
def c10, 0.00000000, 1.00000000, 0.97000003, 2.00000000
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
texld r1, v0, s0
mul_pp r1, r1, c8
mul_pp r1.xyz, r1, c7.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c6
dp3 r0.x, v5, v5
rsq r2.y, r0.x
texld r0, v5, s2
dp4 r0.y, r0, c11
rcp r2.y, r2.y
mul r0.x, r2.y, c4.w
mad r0.z, -r0.x, c10, r0.y
mov r0.y, c5.x
dp3 r0.x, v4, v4
cmp r0.y, r0.z, c10, r0
texld r0.x, r0.x, s3
mul r0.y, r0.x, r0
mul_pp r1.xyz, r1, r0.y
add_pp r2.x, r1.w, -c9
cmp r0.x, r2, c10, c10.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c10.w
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefieceddfoechkmjfffiodjkbkhfgehifipjhmhabaaaaaabmafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoeadaaaaeaaaaaaapjaaaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
agaaaaaaegbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaa
diaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpefaaaaaj
pcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
bbaaaaakccaabaaaabaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaiadpibiaiadl
icabibdhimpinfdbdbaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaa
abaaaaaadhaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakiacaaaacaaaaaa
biaaaaaaabeaaaaaaaaaiadpbaaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaa
egbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaacaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaa
abaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaa
egbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_LINEAR" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_ShadowMapTexture] CUBE 2
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_LightTexture0] CUBE 4
"ps_3_0
; 28 ALU, 5 TEX
dcl_2d s0
dcl_cube s2
dcl_2d s3
dcl_cube s4
def c10, 0.00000000, 1.00000000, 0.97000003, 2.00000000
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
texld r1, v0, s0
mul_pp r1, r1, c8
dp3 r2.y, v5, v5
mul_pp r1.xyz, r1, c7.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c6
texld r0, v5, s2
dp4 r0.y, r0, c11
rsq r2.y, r2.y
rcp r0.x, r2.y
mul r0.x, r0, c4.w
mad r0.x, -r0, c10.z, r0.y
mov r0.z, c5.x
cmp r0.y, r0.x, c10, r0.z
dp3 r0.x, v4, v4
texld r0.w, v4, s4
texld r0.x, r0.x, s3
mul r0.x, r0, r0.w
mul r0.y, r0.x, r0
mul_pp r1.xyz, r1, r0.y
add_pp r2.x, r1.w, -c9
cmp r0.x, r2, c10, c10.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c10.w
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTextureB0] 2D 2
SetTexture 2 [_LightTexture0] CUBE 1
SetTexture 3 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedpomklhmkpddnpjcbanpflpnphnakpeidabaaaaaahiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceaaeaaaaeaaaaaaabaabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaagaaaaaa
egbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaadiaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpefaaaaajpcaabaaa
acaaaaaaegbcbaaaagaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaabbaaaaak
ccaabaaaabaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdh
impinfdbdbaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaaabaaaaaa
dhaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakiacaaaacaaaaaabiaaaaaa
abeaaaaaaaaaiadpbaaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaa
afaaaaaaefaaaaajpcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbcbaaaafaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaadiaaaaahccaabaaaabaaaaaaakaabaaaacaaaaaa
dkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaabkaabaaa
abaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaa
eeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaa
fgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaa
acaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaa
bkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_LINEAR" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [_ShadowOffsets0]
Vector 7 [_ShadowOffsets1]
Vector 8 [_ShadowOffsets2]
Vector 9 [_ShadowOffsets3]
Vector 10 [ExposureIBL]
Vector 11 [_Color]
Float 12 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"ps_3_0
; 36 ALU, 8 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c13, 0.00000000, 1.00000000, 0.50000000, 0.25000000
def c14, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
rcp r2.z, v5.w
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp_sat r0.z, v1, r0
mad r0.xy, v5, r2.z, c9
texld r0.x, r0, s4
texld r1, v0, s0
mul_pp r1, r1, c11
mul_pp r1.xyz, r1, c10.w
mul_pp r1.xyz, r0.z, r1
mad r2.xy, v5, r2.z, c8
mov r0.w, r0.x
texld r0.x, r2, s4
mad r2.xy, v5, r2.z, c7
mov r0.z, r0.x
texld r0.x, r2, s4
mad r2.xy, v5, r2.z, c6
mov r0.y, r0.x
texld r0.x, r2, s4
mov r2.x, c4
mad r0, -v5.z, r2.z, r0
cmp r0, r0, c13.y, r2.x
dp4_pp r0.z, r0, c13.w
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c13.z
texld r0.w, r2, s2
dp3 r0.x, v4, v4
cmp r2.x, -v4.z, c13, c13.y
add_pp r0.y, r1.w, -c12.x
mul_pp r0.w, r2.x, r0
texld r0.x, r0.x, s3
mul_pp r0.x, r0.w, r0
mul_pp r0.z, r0.x, r0
mul_pp r1.xyz, r1, c5
mul_pp r1.xyz, r1, r0.z
cmp r0.x, r0.y, c13, c13.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c14.x
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 400
Vector 16 [_LightColor0]
Vector 48 [_ShadowOffsets0]
Vector 64 [_ShadowOffsets1]
Vector 80 [_ShadowOffsets2]
Vector 96 [_ShadowOffsets3]
Vector 176 [ExposureIBL]
Vector 352 [_Color]
Float 384 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedcpcgkdolaoabhamooaojpjomolckppioabaaaaaaoeagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckmafaaaaeaaaaaaaglabaaaa
fjaaaaaeegiocaaaaaaaaaaabjaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bgaaaaaaakiacaiaebaaaaaaaaaaaaaabiaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabgaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaoaaaaah
hcaabaaaabaaaaaaegbcbaaaagaaaaaapgbpbaaaagaaaaaaaaaaaaaidcaabaaa
acaaaaaaegaabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaaaaaaaaai
dcaabaaaadaaaaaaegaabaaaabaaaaaaegiacaaaaaaaaaaaaeaaaaaaefaaaaaj
pcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaa
dgaaaaafccaabaaaacaaaaaaakaabaaaadaaaaaaaaaaaaaidcaabaaaadaaaaaa
egaabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaadaaaaaa
egaabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadgaaaaafecaabaaa
acaaaaaaakaabaaaadaaaaaaaaaaaaaidcaabaaaabaaaaaaegaabaaaabaaaaaa
egiacaaaaaaaaaaaagaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaa
adaaaaaadbaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaakgakbaaaabaaaaaa
dhaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaaabaaaaaabiaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbbaaaaakbcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaiadoaoaaaaah
gcaabaaaabaaaaaaagbbbaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakgcaabaaa
abaaaaaafgagbaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaa
efaaaaajpcaabaaaacaaaaaajgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahccaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
ccaabaaaabaaaaaadkaabaaaacaaaaaabkaabaaaabaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
kgakbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaaakaabaaaacaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaabkaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaa
diaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaah
ccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [_ShadowOffsets0]
Vector 7 [_ShadowOffsets1]
Vector 8 [_ShadowOffsets2]
Vector 9 [_ShadowOffsets3]
Vector 10 [ExposureIBL]
Vector 11 [_Color]
Float 12 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"ps_3_0
; 36 ALU, 8 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c13, 0.00000000, 1.00000000, 0.50000000, 0.25000000
def c14, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
rcp r1.w, v5.w
mad r0.xyz, v5, r1.w, c9
mad r1.xyz, v5, r1.w, c7
texld r0.x, r0, s4
mov_pp r0.w, r0.x
mad r0.xyz, v5, r1.w, c8
texld r0.x, r0, s4
mov_pp r0.z, r0.x
texld r1.x, r1, s4
mov_pp r0.y, r1.x
mad r1.xyz, v5, r1.w, c6
mov r0.x, c4
add r1.w, c13.y, -r0.x
texld r0.x, r1, s4
mad r1, r0, r1.w, c4.x
rcp r0.z, v4.w
mad r2.xy, v4, r0.z, c13.z
dp3_pp r0.x, v2, v2
dp4_pp r0.y, r1, c13.w
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
texld r0.w, r2, s2
dp3_pp r2.x, r1, r1
dp3 r0.x, v4, v4
cmp r0.z, -v4, c13.x, c13.y
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.x, r1
dp3_pp_sat r1.x, v1, r1
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s3
mul_pp r0.x, r0.z, r0
mul_pp r1.w, r0.x, r0.y
texld r0, v0, s0
mul_pp r0, r0, c11
mul_pp r0.xyz, r0, c10.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c12
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c13, c13.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c14.x
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 400
Vector 16 [_LightColor0]
Vector 48 [_ShadowOffsets0]
Vector 64 [_ShadowOffsets1]
Vector 80 [_ShadowOffsets2]
Vector 96 [_ShadowOffsets3]
Vector 176 [ExposureIBL]
Vector 352 [_Color]
Float 384 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedphdlmefoeambbhbabjeccdmioahnlpjgabaaaaaameagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcimafaaaaeaaaaaaagdabaaaa
fjaaaaaeegiocaaaaaaaaaaabjaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaiaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bgaaaaaaakiacaiaebaaaaaaaaaaaaaabiaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabgaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaaaaaaaj
bcaabaaaabaaaaaaakiacaiaebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadp
aoaaaaahocaabaaaabaaaaaaagbjbaaaagaaaaaapgbpbaaaagaaaaaaaaaaaaai
hcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaehaaaaal
bcaabaaaacaaaaaaegaabaaaacaaaaaaaghabaaaadaaaaaaaagabaaaaaaaaaaa
ckaabaaaacaaaaaaaaaaaaaihcaabaaaadaaaaaajgahbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaaehaaaaalccaabaaaacaaaaaaegaabaaaadaaaaaaaghabaaa
adaaaaaaaagabaaaaaaaaaaackaabaaaadaaaaaaaaaaaaaihcaabaaaadaaaaaa
jgahbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaaaaaaaaaiocaabaaaabaaaaaa
fgaobaaaabaaaaaaagijcaaaaaaaaaaaagaaaaaaehaaaaalicaabaaaacaaaaaa
jgafbaaaabaaaaaaaghabaaaadaaaaaaaagabaaaaaaaaaaadkaabaaaabaaaaaa
ehaaaaalecaabaaaacaaaaaaegaabaaaadaaaaaaaghabaaaadaaaaaaaagabaaa
aaaaaaaackaabaaaadaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaacaaaaaa
agaabaaaabaaaaaaagiacaaaabaaaaaabiaaaaaabbaaaaakbcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaiadoaoaaaaah
gcaabaaaabaaaaaaagbbbaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakgcaabaaa
abaaaaaafgagbaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaa
efaaaaajpcaabaaaacaaaaaajgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahccaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
ccaabaaaabaaaaaadkaabaaaacaaaaaabkaabaaaabaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
kgakbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaaakaabaaaacaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaabkaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaa
diaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaah
ccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_ShadowMapTexture] CUBE 2
SetTexture 3 [_LightTexture0] 2D 3
"ps_3_0
; 35 ALU, 7 TEX
dcl_2d s0
dcl_cube s2
dcl_2d s3
def c10, 0.00000000, 1.00000000, 0.00781250, -0.00781250
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
def c12, 0.97000003, 0.25000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
add r0.xyz, v5, c10.zwww
texld r0, r0, s2
dp4 r2.w, r0, c11
add r0.xyz, v5, c10.wzww
texld r0, r0, s2
dp4 r2.z, r0, c11
add r1.xyz, v5, c10.wwzw
texld r1, r1, s2
dp4 r2.y, r1, c11
add r0.xyz, v5, c10.z
texld r0, r0, s2
dp4 r2.x, r0, c11
dp3 r1.x, v5, v5
rsq r1.x, r1.x
rcp r0.x, r1.x
mul r0.x, r0, c4.w
mad r1, -r0.x, c12.x, r2
mov r0.y, c5.x
cmp r1, r1, c10.y, r0.y
dp3_pp r0.x, v2, v2
rsq_pp r0.y, r0.x
dp4_pp r0.z, r1, c12.y
mul_pp r1.xyz, r0.y, v2
dp3_pp r2.x, r1, r1
dp3 r0.x, v4, v4
texld r0.x, r0.x, s3
mul r1.w, r0.x, r0.z
texld r0, v0, s0
mul_pp r0, r0, c8
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.x, r1
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c7.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c9
mul_pp r0.xyz, r0, c6
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c10, c10.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c12.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedjoagdolaidfbnkjahgkkfppdlkmpblkkabaaaaaaneagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjmafaaaaeaaaaaaaghabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
agaaaaaaegbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaa
diaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpaaaaaaak
ocaabaaaabaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaadm
aaaaaadmefaaaaajpcaabaaaacaaaaaajgahbaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaaaaaaaaabbaaaaakbcaabaaaacaaaaaaegaobaaaacaaaaaaaceaaaaa
aaaaiadpibiaiadlicabibdhimpinfdbaaaaaaakocaabaaaabaaaaaaagbjbaaa
agaaaaaaaceaaaaaaaaaaaaaaaaaaalmaaaaaalmaaaaaadmefaaaaajpcaabaaa
adaaaaaajgahbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaabbaaaaak
ccaabaaaacaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdh
impinfdbaaaaaaakocaabaaaabaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaa
aaaaaalmaaaaaadmaaaaaalmefaaaaajpcaabaaaadaaaaaajgahbaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaaaaaaaaabbaaaaakecaabaaaacaaaaaaegaobaaa
adaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdhimpinfdbaaaaaaakocaabaaa
abaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaalmaaaaaalm
efaaaaajpcaabaaaadaaaaaajgahbaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaabbaaaaakicaabaaaacaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadp
ibiaiadlicabibdhimpinfdbdbaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaa
agaabaaaabaaaaaadhaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaa
acaaaaaabiaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbbaaaaak
bcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiado
aaaaiadobaaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaa
efaaaaajpcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaacaaaaaa
baaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaf
ccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaa
abaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaaacaaaaaa
jgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
ahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
agaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 2 [_ShadowMapTexture] CUBE 2
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_LightTexture0] CUBE 4
"ps_3_0
; 36 ALU, 8 TEX
dcl_2d s0
dcl_cube s2
dcl_2d s3
dcl_cube s4
def c10, 0.00000000, 1.00000000, 0.00781250, -0.00781250
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
def c12, 0.97000003, 0.25000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
add r0.xyz, v5, c10.zwww
texld r0, r0, s2
dp4 r2.w, r0, c11
add r0.xyz, v5, c10.wzww
texld r0, r0, s2
dp4 r2.z, r0, c11
add r1.xyz, v5, c10.wwzw
texld r1, r1, s2
dp4 r2.y, r1, c11
dp3 r0.w, v5, v5
rsq r1.x, r0.w
add r0.xyz, v5, c10.z
texld r0, r0, s2
dp4 r2.x, r0, c11
rcp r1.x, r1.x
mul r0.x, r1, c4.w
mad r1, -r0.x, c12.x, r2
mov r0.y, c5.x
cmp r1, r1, c10.y, r0.y
dp3_pp r0.x, v2, v2
dp4_pp r0.y, r1, c12.y
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r2.x, r1, r1
dp3 r0.x, v4, v4
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.x, r1
dp3_pp_sat r1.x, v1, r1
texld r0.w, v4, s4
texld r0.x, r0.x, s3
mul r0.x, r0, r0.w
mul r1.w, r0.x, r0.y
texld r0, v0, s0
mul_pp r0, r0, c8
mul_pp r0.xyz, r0, c7.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c9
mul_pp r0.xyz, r0, c6
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c10, c10.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c12.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTextureB0] 2D 2
SetTexture 2 [_LightTexture0] CUBE 1
SetTexture 3 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedlmljglejeegblhanejfoidcipncgljbhabaaaaaadaahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcpiafaaaaeaaaaaaahoabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaagaaaaaa
egbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaadiaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpaaaaaaakocaabaaa
abaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaadmaaaaaadm
efaaaaajpcaabaaaacaaaaaajgahbaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaabbaaaaakbcaabaaaacaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaiadp
ibiaiadlicabibdhimpinfdbaaaaaaakocaabaaaabaaaaaaagbjbaaaagaaaaaa
aceaaaaaaaaaaaaaaaaaaalmaaaaaalmaaaaaadmefaaaaajpcaabaaaadaaaaaa
jgahbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaabbaaaaakccaabaaa
acaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdhimpinfdb
aaaaaaakocaabaaaabaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaalm
aaaaaadmaaaaaalmefaaaaajpcaabaaaadaaaaaajgahbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaaaaaaaaabbaaaaakecaabaaaacaaaaaaegaobaaaadaaaaaa
aceaaaaaaaaaiadpibiaiadlicabibdhimpinfdbaaaaaaakocaabaaaabaaaaaa
agbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaalmaaaaaalmefaaaaaj
pcaabaaaadaaaaaajgahbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaa
bbaaaaakicaabaaaacaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadpibiaiadl
icabibdhimpinfdbdbaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaaagaabaaa
abaaaaaadhaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaaacaaaaaa
biaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbbaaaaakbcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaiado
baaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaaj
pcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaadaaaaaaegbcbaaaafaaaaaaeghobaaaacaaaaaaaagabaaa
abaaaaaadiaaaaahccaabaaaabaaaaaaakaabaaaacaaaaaadkaabaaaadaaaaaa
diaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaabaaaaaah
ccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaa
abaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaa
agbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaa
abaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaa
abaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTexture0] 2D 1
"ps_3_0
; 18 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, r1
texld r0, v0, s0
mul_pp r0, r0, c6
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
mul_pp r1.xyz, r0, c4
add_pp r0.y, r0.w, -c7.x
dp3 r0.x, v4, v4
cmp r1.w, r0.y, c8.x, c8.y
texld r0.x, r0.x, s1
mul_pp r0.xyz, r1, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbgnmhmhmpdadcmpmnifmoimdfojekfbpabaaaaaakeadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcieacaaaa
eaaaaaaakbaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
; 13 ALU, 2 TEX
dcl_2d s0
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
texld r0, v0, s0
mul_pp r0, r0, c6
dp3_pp r1.x, v2, v2
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.w, r0, -c7.x
cmp r1.x, r1.w, c8, c8.y
mul_pp r0.xyz, r0, c4
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 272
Vector 16 [_LightColor0]
Vector 48 [ExposureIBL]
Vector 224 [_Color]
Float 256 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedpnpbdmcpaiglkiahljpffilabdpgpafgabaaaaaaaiadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcaaacaaaaeaaaaaaaiaaaaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabaaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihccabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
"ps_3_0
; 23 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c8, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, r1
texld r0, v0, s0
mul_pp r0, r0.yzwx, c6.yzwx
mul_pp r0.xyw, r0.wxzy, c5.w
dp3_pp_sat r1.x, v1, r1
mul_pp r1.xyz, r1.x, r0.xyww
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c8.z
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c4
add_pp r0.y, r0.z, -c7.x
cmp r1.w, -v4.z, c8.x, c8.y
texld r0.w, r2, s1
mul_pp r0.w, r1, r0
texld r0.x, r0.x, s2
cmp r1.w, r0.y, c8.x, c8.y
mul_pp r0.x, r0.w, r0
mul_pp r0.xyw, r1.xyzz, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0.xyww, c8.w
texkill r1.xyzw
mov_pp oC0.w, r0.z
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedljfcfgdphgpnhilkgdaiciojghojobjcabaaaaaajiaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchiadaaaa
eaaaaaaanoaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaadaaaaaa
egbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaahbcaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaak
dcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaackbabaaa
afaaaaaaabaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaa
abaaaaaaagaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 2
"ps_3_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, r1
texld r0, v0, s0
mul_pp r0, r0.yzwx, c6.yzwx
mul_pp r0.xyw, r0.wxzy, c5.w
dp3_pp_sat r1.x, v1, r1
mul_pp r1.xyz, r1.x, r0.xyww
add_pp r0.y, r0.z, -c7.x
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c4
texld r0.w, v4, s2
texld r0.x, r0.x, s1
cmp r1.w, r0.y, c8.x, c8.y
mul r0.x, r0, r0.w
mul_pp r0.xyw, r1.xyzz, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0.xyww, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0.z
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedddlbjkmbcppmiohkhmeojnipcfhgceofabaaaaaaaaaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaacaaaa
eaaaaaaaliaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaadaaaaaa
egbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaahbcaabaaa
abaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaaj
pcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbcbaaaafaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTexture0] 2D 1
"ps_3_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xy
dp3_pp r1.x, v2, v2
texld r0, v0, s0
mul_pp r0, r0, c6
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c7
texld r1.w, v4, s1
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c8, c8.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedibfmhipcpibfpkldllfobaciidfkbcndabaaaaaaiiadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgiacaaaa
eaaaaaaajkaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_GAMMA" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 28 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
texld r0, v0, s0
mul_pp r2, r0, c7
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r0.xyz, r1.w, r1
mul_pp r1.xyz, r2, c6.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c5
add_pp r0.y, r2.w, -c8.x
texldp r0.x, v5, s3
rcp r0.z, v5.w
mad r0.w, -v5.z, r0.z, r0.x
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c9.z
mov r0.z, c4.x
cmp r0.z, r0.w, c9.y, r0
dp3 r0.x, v4, v4
texld r0.w, r2, s1
cmp r1.w, -v4.z, c9.x, c9.y
mul_pp r0.w, r1, r0
texld r0.x, r0.x, s2
mul_pp r0.x, r0.w, r0
mul_pp r0.z, r0.x, r0
mul_pp r1.xyz, r1, r0.z
cmp r0.x, r0.y, c9, c9.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c9.w
texkill r0.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecednifhmgekomaapbcbeafnboaddhoognajabaaaaaaiiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfaaeaaaaeaaaaaaabeabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bcaaaaaaakiacaiaebaaaaaaaaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahbcaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
bcaabaaaabaaaaaadkaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
fgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaacaaaaaaaoaaaaahocaabaaaabaaaaaa
agbjbaaaagaaaaaapgbpbaaaagaaaaaaefaaaaajpcaabaaaacaaaaaajgafbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadbaaaaahccaabaaaabaaaaaa
akaabaaaacaaaaaadkaabaaaabaaaaaadhaaaaakccaabaaaabaaaaaabkaabaaa
abaaaaaaakiacaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadpdiaaaaahbcaabaaa
abaaaaaabkaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaa
abaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaa
bacaaaahccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaah
ccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
fgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [ExposureIBL]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 27 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
texld r0, v0, s0
mul_pp r2, r0, c7
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r0.xyz, r1.w, r1
mul_pp r1.xyz, r2, c6.w
rcp r0.w, v4.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c5
mov r0.x, c4
add r0.z, c9.y, -r0.x
texldp r0.x, v5, s3
mad r0.z, r0.x, r0, c4.x
mad r2.xy, v4, r0.w, c9.z
dp3 r0.x, v4, v4
add_pp r0.y, r2.w, -c8.x
texld r0.w, r2, s1
cmp r1.w, -v4.z, c9.x, c9.y
mul_pp r0.w, r1, r0
texld r0.x, r0.x, s2
mul_pp r0.x, r0.w, r0
mul_pp r0.z, r0.x, r0
mul_pp r1.xyz, r1, r0.z
cmp r0.x, r0.y, c9, c9.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c9.w
texkill r0.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefieceddodoieompklkalaibjmojiielomfdhmfabaaaaaajiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgaaeaaaaeaaaaaaabiabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaiaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bcaaaaaaakiacaiaebaaaaaaaaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahbcaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
bcaabaaaabaaaaaadkaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
fgafbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaacaaaaaaaoaaaaahocaabaaaabaaaaaa
agbjbaaaagaaaaaapgbpbaaaagaaaaaaehaaaaalccaabaaaabaaaaaajgafbaaa
abaaaaaaaghabaaaadaaaaaaaagabaaaaaaaaaaadkaabaaaabaaaaaaaaaaaaaj
ecaabaaaabaaaaaaakiacaiaebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadp
dcaaaaakccaabaaaabaaaaaabkaabaaaabaaaaaackaabaaaabaaaaaaakiacaaa
abaaaaaabiaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaa
abaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaa
eeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaa
fgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaa
acaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaa
bkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] 2D 1
"ps_3_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3_pp r1.x, v2, v2
texld r0, v0, s0
rsq_pp r2.x, r1.x
mul_pp r1, r0, c6
mul_pp r0.xyz, r2.x, v2
mul_pp r1.xyz, r1, c5.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c4
add_pp r0.x, r1.w, -c7
texldp r2.x, v4, s1
cmp r0.x, r0, c8, c8.y
mul_pp r1.xyz, r1, r2.x
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c8.z
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmkhiflmojagfmlnddgceimenjihninbaabaaaaaakeadaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcieacaaaa
eaaaaaaakbaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [ExposureIBL]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
"ps_3_0
; 15 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c8, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
dp3_pp r1.x, v2, v2
texld r0, v0, s0
mul_pp r0, r0, c6
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c5.w
mul_pp r0.xyz, r1.x, r0
mul_pp r1.xyz, r0, c4
add_pp r0.y, r0.w, -c7.x
texld r1.w, v4, s2
texldp r0.x, v5, s1
mul r0.x, r1.w, r0
cmp r1.w, r0.y, c8.x, c8.y
mul_pp r0.xyz, r1, r0.x
mov_pp r1, -r1.w
mul_pp oC0.xyz, r0, c8.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 400
Vector 16 [_LightColor0]
Vector 176 [ExposureIBL]
Vector 352 [_Color]
Float 384 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmikbgijenamkcppbdchbkclodfdbjghcabaaaaaaceaeaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaa
fjaaaaaeegiocaaaaaaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabgaaaaaaakiacaiaebaaaaaa
aaaaaaaabiaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabgaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaabacaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
acaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_GAMMA" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] CUBE 1
SetTexture 2 [_LightTexture0] 2D 2
"ps_3_0
; 27 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c10, 0.00000000, 1.00000000, 0.97000003, 2.00000000
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
texld r1, v0, s0
mul_pp r1, r1, c8
mul_pp r1.xyz, r1, c7.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c6
dp3 r0.x, v5, v5
rsq r2.y, r0.x
texld r0, v5, s1
dp4 r0.y, r0, c11
rcp r2.y, r2.y
mul r0.x, r2.y, c4.w
mad r0.z, -r0.x, c10, r0.y
mov r0.y, c5.x
dp3 r0.x, v4, v4
cmp r0.y, r0.z, c10, r0
texld r0.x, r0.x, s2
mul r0.y, r0.x, r0
mul_pp r1.xyz, r1, r0.y
add_pp r2.x, r1.w, -c9
cmp r0.x, r2, c10, c10.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c10.w
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefieceddfoechkmjfffiodjkbkhfgehifipjhmhabaaaaaabmafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoeadaaaaeaaaaaaapjaaaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
agaaaaaaegbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaa
diaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpefaaaaaj
pcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
bbaaaaakccaabaaaabaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaiadpibiaiadl
icabibdhimpinfdbdbaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaa
abaaaaaadhaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakiacaaaacaaaaaa
biaaaaaaabeaaaaaaaaaiadpbaaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaa
egbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaaaacaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaa
abaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaa
egbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_GAMMA" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] CUBE 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_LightTexture0] CUBE 3
"ps_3_0
; 28 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_cube s3
def c10, 0.00000000, 1.00000000, 0.97000003, 2.00000000
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
texld r1, v0, s0
mul_pp r1, r1, c8
dp3 r2.y, v5, v5
mul_pp r1.xyz, r1, c7.w
dp3_pp_sat r0.x, v1, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c6
texld r0, v5, s1
dp4 r0.y, r0, c11
rsq r2.y, r2.y
rcp r0.x, r2.y
mul r0.x, r0, c4.w
mad r0.x, -r0, c10.z, r0.y
mov r0.z, c5.x
cmp r0.y, r0.x, c10, r0.z
dp3 r0.x, v4, v4
texld r0.w, v4, s3
texld r0.x, r0.x, s2
mul r0.x, r0, r0.w
mul r0.y, r0.x, r0
mul_pp r1.xyz, r1, r0.y
add_pp r2.x, r1.w, -c9
cmp r0.x, r2, c10, c10.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c10.w
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTextureB0] 2D 2
SetTexture 2 [_LightTexture0] CUBE 1
SetTexture 3 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedpomklhmkpddnpjcbanpflpnphnakpeidabaaaaaahiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceaaeaaaaeaaaaaaabaabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaagaaaaaa
egbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaadiaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpefaaaaajpcaabaaa
acaaaaaaegbcbaaaagaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaabbaaaaak
ccaabaaaabaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdh
impinfdbdbaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaaabaaaaaa
dhaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakiacaaaacaaaaaabiaaaaaa
abeaaaaaaaaaiadpbaaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaa
afaaaaaaefaaaaajpcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbcbaaaafaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaadiaaaaahccaabaaaabaaaaaaakaabaaaacaaaaaa
dkaabaaaadaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaabkaabaaa
abaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaa
eeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaa
fgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaa
acaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaa
bkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_GAMMA" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [_ShadowOffsets0]
Vector 7 [_ShadowOffsets1]
Vector 8 [_ShadowOffsets2]
Vector 9 [_ShadowOffsets3]
Vector 10 [ExposureIBL]
Vector 11 [_Color]
Float 12 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 36 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c13, 0.00000000, 1.00000000, 0.50000000, 0.25000000
def c14, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
rcp r2.z, v5.w
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp_sat r0.z, v1, r0
mad r0.xy, v5, r2.z, c9
texld r0.x, r0, s3
texld r1, v0, s0
mul_pp r1, r1, c11
mul_pp r1.xyz, r1, c10.w
mul_pp r1.xyz, r0.z, r1
mad r2.xy, v5, r2.z, c8
mov r0.w, r0.x
texld r0.x, r2, s3
mad r2.xy, v5, r2.z, c7
mov r0.z, r0.x
texld r0.x, r2, s3
mad r2.xy, v5, r2.z, c6
mov r0.y, r0.x
texld r0.x, r2, s3
mov r2.x, c4
mad r0, -v5.z, r2.z, r0
cmp r0, r0, c13.y, r2.x
dp4_pp r0.z, r0, c13.w
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c13.z
texld r0.w, r2, s1
dp3 r0.x, v4, v4
cmp r2.x, -v4.z, c13, c13.y
add_pp r0.y, r1.w, -c12.x
mul_pp r0.w, r2.x, r0
texld r0.x, r0.x, s2
mul_pp r0.x, r0.w, r0
mul_pp r0.z, r0.x, r0
mul_pp r1.xyz, r1, c5
mul_pp r1.xyz, r1, r0.z
cmp r0.x, r0.y, c13, c13.y
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c14.x
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 400
Vector 16 [_LightColor0]
Vector 48 [_ShadowOffsets0]
Vector 64 [_ShadowOffsets1]
Vector 80 [_ShadowOffsets2]
Vector 96 [_ShadowOffsets3]
Vector 176 [ExposureIBL]
Vector 352 [_Color]
Float 384 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedcpcgkdolaoabhamooaojpjomolckppioabaaaaaaoeagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckmafaaaaeaaaaaaaglabaaaa
fjaaaaaeegiocaaaaaaaaaaabjaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bgaaaaaaakiacaiaebaaaaaaaaaaaaaabiaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabgaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaoaaaaah
hcaabaaaabaaaaaaegbcbaaaagaaaaaapgbpbaaaagaaaaaaaaaaaaaidcaabaaa
acaaaaaaegaabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaaaaaaaaai
dcaabaaaadaaaaaaegaabaaaabaaaaaaegiacaaaaaaaaaaaaeaaaaaaefaaaaaj
pcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaa
dgaaaaafccaabaaaacaaaaaaakaabaaaadaaaaaaaaaaaaaidcaabaaaadaaaaaa
egaabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaaefaaaaajpcaabaaaadaaaaaa
egaabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadgaaaaafecaabaaa
acaaaaaaakaabaaaadaaaaaaaaaaaaaidcaabaaaabaaaaaaegaabaaaabaaaaaa
egiacaaaaaaaaaaaagaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaakaabaaa
adaaaaaadbaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaakgakbaaaabaaaaaa
dhaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaaabaaaaaabiaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbbaaaaakbcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaiadoaoaaaaah
gcaabaaaabaaaaaaagbbbaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakgcaabaaa
abaaaaaafgagbaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaa
efaaaaajpcaabaaaacaaaaaajgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahccaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
ccaabaaaabaaaaaadkaabaaaacaaaaaabkaabaaaabaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
kgakbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaaakaabaaaacaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaabkaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaa
diaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaah
ccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Vector 4 [_LightShadowData]
Vector 5 [_LightColor0]
Vector 6 [_ShadowOffsets0]
Vector 7 [_ShadowOffsets1]
Vector 8 [_ShadowOffsets2]
Vector 9 [_ShadowOffsets3]
Vector 10 [ExposureIBL]
Vector 11 [_Color]
Float 12 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 36 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c13, 0.00000000, 1.00000000, 0.50000000, 0.25000000
def c14, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5
rcp r1.w, v5.w
mad r0.xyz, v5, r1.w, c9
mad r1.xyz, v5, r1.w, c7
texld r0.x, r0, s3
mov_pp r0.w, r0.x
mad r0.xyz, v5, r1.w, c8
texld r0.x, r0, s3
mov_pp r0.z, r0.x
texld r1.x, r1, s3
mov_pp r0.y, r1.x
mad r1.xyz, v5, r1.w, c6
mov r0.x, c4
add r1.w, c13.y, -r0.x
texld r0.x, r1, s3
mad r1, r0, r1.w, c4.x
rcp r0.z, v4.w
mad r2.xy, v4, r0.z, c13.z
dp3_pp r0.x, v2, v2
dp4_pp r0.y, r1, c13.w
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
texld r0.w, r2, s1
dp3_pp r2.x, r1, r1
dp3 r0.x, v4, v4
cmp r0.z, -v4, c13.x, c13.y
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.x, r1
dp3_pp_sat r1.x, v1, r1
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s2
mul_pp r0.x, r0.z, r0
mul_pp r1.w, r0.x, r0.y
texld r0, v0, s0
mul_pp r0, r0, c11
mul_pp r0.xyz, r0, c10.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c12
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c13, c13.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c14.x
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 400
Vector 16 [_LightColor0]
Vector 48 [_ShadowOffsets0]
Vector 64 [_ShadowOffsets1]
Vector 80 [_ShadowOffsets2]
Vector 96 [_ShadowOffsets3]
Vector 176 [ExposureIBL]
Vector 352 [_Color]
Float 384 [_Cutoff]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedphdlmefoeambbhbabjeccdmioahnlpjgabaaaaaameagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcimafaaaaeaaaaaaagdabaaaa
fjaaaaaeegiocaaaaaaaaaaabjaaaaaafjaaaaaeegiocaaaabaaaaaabjaaaaaa
fkaiaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaa
gcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
adaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
bgaaaaaaakiacaiaebaaaaaaaaaaaaaabiaaaaaadiaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaaaaaaaaabgaaaaaadbaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaaaaaaaaaj
bcaabaaaabaaaaaaakiacaiaebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadp
aoaaaaahocaabaaaabaaaaaaagbjbaaaagaaaaaapgbpbaaaagaaaaaaaaaaaaai
hcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaehaaaaal
bcaabaaaacaaaaaaegaabaaaacaaaaaaaghabaaaadaaaaaaaagabaaaaaaaaaaa
ckaabaaaacaaaaaaaaaaaaaihcaabaaaadaaaaaajgahbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaaehaaaaalccaabaaaacaaaaaaegaabaaaadaaaaaaaghabaaa
adaaaaaaaagabaaaaaaaaaaackaabaaaadaaaaaaaaaaaaaihcaabaaaadaaaaaa
jgahbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaaaaaaaaaiocaabaaaabaaaaaa
fgaobaaaabaaaaaaagijcaaaaaaaaaaaagaaaaaaehaaaaalicaabaaaacaaaaaa
jgafbaaaabaaaaaaaghabaaaadaaaaaaaagabaaaaaaaaaaadkaabaaaabaaaaaa
ehaaaaalecaabaaaacaaaaaaegaabaaaadaaaaaaaghabaaaadaaaaaaaagabaaa
aaaaaaaackaabaaaadaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaacaaaaaa
agaabaaaabaaaaaaagiacaaaabaaaaaabiaaaaaabbaaaaakbcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaiadoaoaaaaah
gcaabaaaabaaaaaaagbbbaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakgcaabaaa
abaaaaaafgagbaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaadpaaaaaadpaaaaaaaa
efaaaaajpcaabaaaacaaaaaajgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadbaaaaahccaabaaaabaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaaabeaaaaaaaaaiadpdiaaaaah
ccaabaaaabaaaaaadkaabaaaacaaaaaabkaabaaaabaaaaaabaaaaaahecaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaa
kgakbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaaakaabaaaacaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaabkaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaa
diaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaabacaaaah
ccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaaabaaaaaaaaaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] CUBE 1
SetTexture 2 [_LightTexture0] 2D 2
"ps_3_0
; 35 ALU, 7 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c10, 0.00000000, 1.00000000, 0.00781250, -0.00781250
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
def c12, 0.97000003, 0.25000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
add r0.xyz, v5, c10.zwww
texld r0, r0, s1
dp4 r2.w, r0, c11
add r0.xyz, v5, c10.wzww
texld r0, r0, s1
dp4 r2.z, r0, c11
add r1.xyz, v5, c10.wwzw
texld r1, r1, s1
dp4 r2.y, r1, c11
add r0.xyz, v5, c10.z
texld r0, r0, s1
dp4 r2.x, r0, c11
dp3 r1.x, v5, v5
rsq r1.x, r1.x
rcp r0.x, r1.x
mul r0.x, r0, c4.w
mad r1, -r0.x, c12.x, r2
mov r0.y, c5.x
cmp r1, r1, c10.y, r0.y
dp3_pp r0.x, v2, v2
rsq_pp r0.y, r0.x
dp4_pp r0.z, r1, c12.y
mul_pp r1.xyz, r0.y, v2
dp3_pp r2.x, r1, r1
dp3 r0.x, v4, v4
texld r0.x, r0.x, s2
mul r1.w, r0.x, r0.z
texld r0, v0, s0
mul_pp r0, r0, c8
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.x, r1
dp3_pp_sat r1.x, v1, r1
mul_pp r0.xyz, r0, c7.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c9
mul_pp r0.xyz, r0, c6
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c10, c10.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c12.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 1
SetTexture 2 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedjoagdolaidfbnkjahgkkfppdlkmpblkkabaaaaaaneagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjmafaaaaeaaaaaaaghabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaa
aaaaaaaabeaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaabcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
agaaaaaaegbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaa
diaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpaaaaaaak
ocaabaaaabaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaadm
aaaaaadmefaaaaajpcaabaaaacaaaaaajgahbaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaaaaaaaaabbaaaaakbcaabaaaacaaaaaaegaobaaaacaaaaaaaceaaaaa
aaaaiadpibiaiadlicabibdhimpinfdbaaaaaaakocaabaaaabaaaaaaagbjbaaa
agaaaaaaaceaaaaaaaaaaaaaaaaaaalmaaaaaalmaaaaaadmefaaaaajpcaabaaa
adaaaaaajgahbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaabbaaaaak
ccaabaaaacaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdh
impinfdbaaaaaaakocaabaaaabaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaa
aaaaaalmaaaaaadmaaaaaalmefaaaaajpcaabaaaadaaaaaajgahbaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaaaaaaaaabbaaaaakecaabaaaacaaaaaaegaobaaa
adaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdhimpinfdbaaaaaaakocaabaaa
abaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaalmaaaaaalm
efaaaaajpcaabaaaadaaaaaajgahbaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaabbaaaaakicaabaaaacaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadp
ibiaiadlicabibdhimpinfdbdbaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaa
agaabaaaabaaaaaadhaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaa
acaaaaaabiaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbbaaaaak
bcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiado
aaaaiadobaaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaa
efaaaaajpcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaacaaaaaa
baaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaf
ccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaa
abaaaaaaagbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaaacaaaaaa
jgahbaaaabaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
ahaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
agaabaaaabaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
Vector 4 [_LightPositionRange]
Vector 5 [_LightShadowData]
Vector 6 [_LightColor0]
Vector 7 [ExposureIBL]
Vector 8 [_Color]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ShadowMapTexture] CUBE 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_LightTexture0] CUBE 3
"ps_3_0
; 36 ALU, 8 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_cube s3
def c10, 0.00000000, 1.00000000, 0.00781250, -0.00781250
def c11, 1.00000000, 0.00392157, 0.00001538, 0.00000001
def c12, 0.97000003, 0.25000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
add r0.xyz, v5, c10.zwww
texld r0, r0, s1
dp4 r2.w, r0, c11
add r0.xyz, v5, c10.wzww
texld r0, r0, s1
dp4 r2.z, r0, c11
add r1.xyz, v5, c10.wwzw
texld r1, r1, s1
dp4 r2.y, r1, c11
dp3 r0.w, v5, v5
rsq r1.x, r0.w
add r0.xyz, v5, c10.z
texld r0, r0, s1
dp4 r2.x, r0, c11
rcp r1.x, r1.x
mul r0.x, r1, c4.w
mad r1, -r0.x, c12.x, r2
mov r0.y, c5.x
cmp r1, r1, c10.y, r0.y
dp3_pp r0.x, v2, v2
dp4_pp r0.y, r1, c12.y
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r2.x, r1, r1
dp3 r0.x, v4, v4
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.x, r1
dp3_pp_sat r1.x, v1, r1
texld r0.w, v4, s3
texld r0.x, r0.x, s2
mul r0.x, r0, r0.w
mul r1.w, r0.x, r0.y
texld r0, v0, s0
mul_pp r0, r0, c8
mul_pp r0.xyz, r0, c7.w
mul_pp r0.xyz, r1.x, r0
add_pp r1.x, r0.w, -c9
mul_pp r0.xyz, r0, c6
mul_pp r0.xyz, r0, r1.w
cmp r1.x, r1, c10, c10.y
mov_pp r1, -r1.x
mul_pp oC0.xyz, r0, c12.z
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 3
SetTexture 1 [_LightTextureB0] 2D 2
SetTexture 2 [_LightTexture0] CUBE 1
SetTexture 3 [_ShadowMapTexture] CUBE 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 112 [ExposureIBL]
Vector 288 [_Color]
Float 320 [_Cutoff]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
"ps_4_0
eefiecedlmljglejeegblhanejfoidcipncgljbhabaaaaaadaahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcpiafaaaaeaaaaaaahoabaaaa
fjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaaeegiocaaaabaaaaaaacaaaaaa
fjaaaaaeegiocaaaacaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaadaaaaaadcaaaaambcaabaaaabaaaaaa
dkaabaaaaaaaaaaadkiacaaaaaaaaaaabcaaaaaaakiacaiaebaaaaaaaaaaaaaa
beaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
bcaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaa
anaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaagaaaaaa
egbcbaaaagaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaaakaabaaaabaaaaaadkiacaaaabaaaaaaabaaaaaadiaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaomfbhidpaaaaaaakocaabaaa
abaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaadmaaaaaadm
efaaaaajpcaabaaaacaaaaaajgahbaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaabbaaaaakbcaabaaaacaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaiadp
ibiaiadlicabibdhimpinfdbaaaaaaakocaabaaaabaaaaaaagbjbaaaagaaaaaa
aceaaaaaaaaaaaaaaaaaaalmaaaaaalmaaaaaadmefaaaaajpcaabaaaadaaaaaa
jgahbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaabbaaaaakccaabaaa
acaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadpibiaiadlicabibdhimpinfdb
aaaaaaakocaabaaaabaaaaaaagbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaalm
aaaaaadmaaaaaalmefaaaaajpcaabaaaadaaaaaajgahbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaaaaaaaaabbaaaaakecaabaaaacaaaaaaegaobaaaadaaaaaa
aceaaaaaaaaaiadpibiaiadlicabibdhimpinfdbaaaaaaakocaabaaaabaaaaaa
agbjbaaaagaaaaaaaceaaaaaaaaaaaaaaaaaaadmaaaaaalmaaaaaalmefaaaaaj
pcaabaaaadaaaaaajgahbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaa
bbaaaaakicaabaaaacaaaaaaegaobaaaadaaaaaaaceaaaaaaaaaiadpibiaiadl
icabibdhimpinfdbdbaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaaagaabaaa
abaaaaaadhaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaagiacaaaacaaaaaa
biaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbbaaaaakbcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaiado
baaaaaahccaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaaj
pcaabaaaacaaaaaafgafbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaadaaaaaaegbcbaaaafaaaaaaeghobaaaacaaaaaaaagabaaa
abaaaaaadiaaaaahccaabaaaabaaaaaaakaabaaaacaaaaaadkaabaaaadaaaaaa
diaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaabaaaaaah
ccaabaaaabaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaa
abaaaaaabkaabaaaabaaaaaadiaaaaahocaabaaaabaaaaaafgafbaaaabaaaaaa
agbjbaaaadaaaaaabacaaaahccaabaaaabaaaaaaegbcbaaaacaaaaaajgahbaaa
abaaaaaaaaaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaa
abaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassBase" "QUEUE"="AlphaTest" "IGNOREPROJECTOR"="True" "RenderType"="TransparentCutout" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  vec4 res_1;
  float x_2;
  x_2 = ((texture2D (_MainTex, xlv_TEXCOORD0) * _Color).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  res_1.xyz = ((xlv_TEXCOORD1 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
Vector 9 [_MainTex_ST]
"vs_3_0
; 9 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c8.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
mad o1.xy, v2, c9, c9.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedfmfdopgkipofhoedleigfgmkdacpidlnabaaaaaaeaadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcneabaaaaeaaaabaahfaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaabaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaabaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaabaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  vec4 res_1;
  float x_2;
  x_2 = ((texture2D (_MainTex, xlv_TEXCOORD0) * _Color).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  res_1.xyz = ((xlv_TEXCOORD1 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
Vector 9 [_MainTex_ST]
"vs_3_0
; 9 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c8.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
mad o1.xy, v2, c9, c9.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedfmfdopgkipofhoedleigfgmkdacpidlnabaaaaaaeaadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcneabaaaaeaaaabaahfaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaabaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaabaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaabaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" }
Vector 4 [_Color]
Float 5 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
; 6 ALU, 2 TEX
dcl_2d s0
def c6, 0.00000000, 1.00000000, 0.50000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
texld r0.w, v0, s0
mov_pp r0.x, c5
mad_pp r0.x, r0.w, c4.w, -r0
cmp r0.x, r0, c6, c6.y
mov_pp r0, -r0.x
texkill r0.xyzw
mad_pp oC0.xyz, v1, c6.z, c6.z
mov_pp oC0.w, c6.x
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 272
Vector 224 [_Color]
Float 256 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedondemlmblmehfllpchapahdbchacdmjoabaaaaaaaiacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdaabaaaaeaaaaaaaemaaaaaa
fjaaaaaeegiocaaaaaaaaaaabbaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaam
bcaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaia
ebaaaaaaaaaaaaaabaaaaaaadbaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaa
egbcbaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" }
Vector 4 [_Color]
Float 5 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
; 6 ALU, 2 TEX
dcl_2d s0
def c6, 0.00000000, 1.00000000, 0.50000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
texld r0.w, v0, s0
mov_pp r0.x, c5
mad_pp r0.x, r0.w, c4.w, -r0
cmp r0.x, r0, c6, c6.y
mov_pp r0, -r0.x
texkill r0.xyzw
mad_pp oC0.xyz, v1, c6.z, c6.z
mov_pp oC0.w, c6.x
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 272
Vector 224 [_Color]
Float 256 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedondemlmblmehfllpchapahdbchacdmjoabaaaaaaaiacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdaabaaaaeaaaaaaaemaaaaaa
fjaaaaaeegiocaaaaaaaaaaabbaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaam
bcaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaia
ebaaaaaaaaaaaaaabaaaaaaadbaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaa
egbcbaaaacaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassFinal" "QUEUE"="AlphaTest" "IGNOREPROJECTOR"="True" "RenderType"="TransparentCutout" }
  ZWrite Off
Program "vp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * gl_Normal);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_1 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_1.zw;
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_3 * unity_Scale.w);
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_4.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2)));
  light_2.w = tmpvar_13.w;
  light_2.xyz = (tmpvar_13.xyz + xlv_TEXCOORD3);
  vec4 frag_14;
  frag_14.xyz = (diff_3.xyz * light_2.xyz);
  frag_14.w = diff_3.w;
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c19.y
dp3 r1.z, v1, c6
dp3 r1.x, v1, c4
dp3 r1.y, v1, c5
mul r0.xyz, r1, c17.w
mul r1.w, r0.y, r0.y
mul r2, r0.xyzz, r0.yzzx
dp4 r3.z, r0, c12
dp4 r3.y, r0, c11
dp4 r3.x, r0, c10
mad r1.w, r0.x, r0.x, -r1
dp4 r0.z, r2, c15
dp4 r0.x, r2, c13
dp4 r0.y, r2, c14
add r4.xyz, r3, r0
mul r3.xyz, r1.w, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c19.x
mul r2.y, r2, c8.x
add o4.xyz, r4, r3
mad o3.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o3.zw, r0
mov o2.xyz, r1
mad o1.xy, v2, c18, c18.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 288
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeidbaebkjcomhgadfdcnfcabpobdmddbabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcceaeaaaaeaaaabaa
ajabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaacaaaaaamgaabaaa
acaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
aaaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
aaaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
aaaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;


uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_2 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * gl_Vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * gl_Vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * gl_Normal);
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_4.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2)));
  light_2.w = tmpvar_13.w;
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  light_2.xyz = (tmpvar_13.xyz + mix (((8.0 * tmpvar_15.w) * tmpvar_15.xyz), ((8.0 * tmpvar_14.w) * tmpvar_14.xyz), vec3(clamp (((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0))));
  vec4 frag_16;
  frag_16.xyz = (diff_3.xyz * light_2.xyz);
  frag_16.w = diff_3.w;
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_Object2World]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad o3.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o3.zw, r0
mul o5.xyz, r1, c14.w
mad o1.xy, v2, c16, c16.zwzw
mad o4.xy, v3, c15, c15.zwzw
mul o5.w, -r0.x, r0.y
dp3 o2.z, v1, c10
dp3 o2.y, v1, c9
dp3 o2.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 400 [unity_ShadowFadeCenterAndType]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedhdfpklgalkalakbkdkabblndipigadlmabaaaaaaciagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcheaeaaaaeaaaabaabnabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaa
apaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaa
acaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaa
adaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaa
akbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaa
aaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  vec3 tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_6 = TANGENT.xyz;
  tmpvar_7 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = gl_Normal.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = gl_Normal.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = gl_Normal.z;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (tmpvar_8 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  vec3 tmpvar_4;
  tmpvar_4 = normalize(xlv_TEXCOORD1);
  vec4 v_5;
  v_5.x = SkyMatrix[0].x;
  v_5.y = SkyMatrix[1].x;
  v_5.z = SkyMatrix[2].x;
  v_5.w = SkyMatrix[3].x;
  vec4 v_6;
  v_6.x = SkyMatrix[0].y;
  v_6.y = SkyMatrix[1].y;
  v_6.z = SkyMatrix[2].y;
  v_6.w = SkyMatrix[3].y;
  vec4 v_7;
  v_7.x = SkyMatrix[0].z;
  v_7.y = SkyMatrix[1].z;
  v_7.z = SkyMatrix[2].z;
  v_7.w = SkyMatrix[3].z;
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_5.xyz * tmpvar_4.x) + ((v_6.xyz * tmpvar_4.y) + (v_7.xyz * tmpvar_4.z))));
  float tmpvar_9;
  tmpvar_9 = (tmpvar_8.w * tmpvar_8.w);
  vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (tmpvar_8.w * tmpvar_9);
  float x_11;
  x_11 = (tmpvar_3.w - _Cutoff);
  if ((x_11 < 0.0)) {
    discard;
  };
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 result_13;
  result_13.xyz = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  result_13.w = 0.0;
  vec4 frag_14;
  frag_14.xyz = (diff_2.xyz * (-(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2))) + result_13).xyz);
  frag_14.w = diff_2.w;
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (((tmpvar_8.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
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
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c12
mov r1.w, c18.y
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c15.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.x
mul r2.y, r2, c13.x
dp3 o5.y, r1, r3
mad o3.xy, r2.z, c14.zwzw, r2
dp3 o5.z, v2, r1
dp3 o5.x, r1, v1
mov o0, r0
mov o3.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o4.xy, v4, c16, c16.zwzw
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
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
eefiecedofpkhmmnclmhbeglkopakgcnbbmhjbipabaaaaaaoiafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcdeaeaaaaeaaaabaaanabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
adaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * gl_Normal);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_1 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_1.zw;
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_3 * unity_Scale.w);
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_4.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_2.w = tmpvar_13.w;
  light_2.xyz = (tmpvar_13.xyz + xlv_TEXCOORD3);
  vec4 frag_14;
  frag_14.xyz = (diff_3.xyz * light_2.xyz);
  frag_14.w = diff_3.w;
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c19.y
dp3 r1.z, v1, c6
dp3 r1.x, v1, c4
dp3 r1.y, v1, c5
mul r0.xyz, r1, c17.w
mul r1.w, r0.y, r0.y
mul r2, r0.xyzz, r0.yzzx
dp4 r3.z, r0, c12
dp4 r3.y, r0, c11
dp4 r3.x, r0, c10
mad r1.w, r0.x, r0.x, -r1
dp4 r0.z, r2, c15
dp4 r0.x, r2, c13
dp4 r0.y, r2, c14
add r4.xyz, r3, r0
mul r3.xyz, r1.w, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c19.x
mul r2.y, r2, c8.x
add o4.xyz, r4, r3
mad o3.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o3.zw, r0
mov o2.xyz, r1
mad o1.xy, v2, c18, c18.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 288
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeidbaebkjcomhgadfdcnfcabpobdmddbabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcceaeaaaaeaaaabaa
ajabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaacaaaaaamgaabaaa
acaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
aaaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
aaaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
aaaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;


uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_2 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * gl_Vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * gl_Vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * gl_Normal);
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  float x_12;
  x_12 = (tmpvar_4.w - _Cutoff);
  if ((x_12 < 0.0)) {
    discard;
  };
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_2.w = tmpvar_13.w;
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  light_2.xyz = (tmpvar_13.xyz + mix (((8.0 * tmpvar_15.w) * tmpvar_15.xyz), ((8.0 * tmpvar_14.w) * tmpvar_14.xyz), vec3(clamp (((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0))));
  vec4 frag_16;
  frag_16.xyz = (diff_3.xyz * light_2.xyz);
  frag_16.w = diff_3.w;
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_Object2World]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad o3.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o3.zw, r0
mul o5.xyz, r1, c14.w
mad o1.xy, v2, c16, c16.zwzw
mad o4.xy, v3, c15, c15.zwzw
mul o5.w, -r0.x, r0.y
dp3 o2.z, v1, c10
dp3 o2.y, v1, c9
dp3 o2.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 400 [unity_ShadowFadeCenterAndType]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedhdfpklgalkalakbkdkabblndipigadlmabaaaaaaciagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcheaeaaaaeaaaabaabnabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaa
apaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaa
acaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaa
adaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaa
akbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaa
aaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  vec3 tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_6 = TANGENT.xyz;
  tmpvar_7 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = gl_Normal.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = gl_Normal.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = gl_Normal.z;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (tmpvar_8 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  vec3 tmpvar_4;
  tmpvar_4 = normalize(xlv_TEXCOORD1);
  vec4 v_5;
  v_5.x = SkyMatrix[0].x;
  v_5.y = SkyMatrix[1].x;
  v_5.z = SkyMatrix[2].x;
  v_5.w = SkyMatrix[3].x;
  vec4 v_6;
  v_6.x = SkyMatrix[0].y;
  v_6.y = SkyMatrix[1].y;
  v_6.z = SkyMatrix[2].y;
  v_6.w = SkyMatrix[3].y;
  vec4 v_7;
  v_7.x = SkyMatrix[0].z;
  v_7.y = SkyMatrix[1].z;
  v_7.z = SkyMatrix[2].z;
  v_7.w = SkyMatrix[3].z;
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_5.xyz * tmpvar_4.x) + ((v_6.xyz * tmpvar_4.y) + (v_7.xyz * tmpvar_4.z))));
  float tmpvar_9;
  tmpvar_9 = (tmpvar_8.w * tmpvar_8.w);
  vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (tmpvar_8.w * tmpvar_9);
  float x_11;
  x_11 = (tmpvar_3.w - _Cutoff);
  if ((x_11 < 0.0)) {
    discard;
  };
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 result_13;
  result_13.xyz = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  result_13.w = 0.0;
  vec4 frag_14;
  frag_14.xyz = (diff_2.xyz * (texture2DProj (_LightBuffer, xlv_TEXCOORD2) + result_13).xyz);
  frag_14.w = diff_2.w;
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (((tmpvar_8.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
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
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c12
mov r1.w, c18.y
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c15.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.x
mul r2.y, r2, c13.x
dp3 o5.y, r1, r3
mad o3.xy, r2.z, c14.zwzw, r2
dp3 o5.z, v2, r1
dp3 o5.x, r1, v1
mov o0, r0
mov o3.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o4.xy, v4, c16, c16.zwzw
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
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
eefiecedofpkhmmnclmhbeglkopakgcnbbmhjbipabaaaaaaoiafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcdeaeaaaaeaaaabaaanabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
adaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * gl_Normal);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_1 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_1.zw;
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_3 * unity_Scale.w);
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_4.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2)));
  light_2.w = tmpvar_11.w;
  light_2.xyz = (tmpvar_11.xyz + xlv_TEXCOORD3);
  vec4 frag_12;
  frag_12.xyz = (diff_3.xyz * light_2.xyz);
  frag_12.w = diff_3.w;
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c19.y
dp3 r1.z, v1, c6
dp3 r1.x, v1, c4
dp3 r1.y, v1, c5
mul r0.xyz, r1, c17.w
mul r1.w, r0.y, r0.y
mul r2, r0.xyzz, r0.yzzx
dp4 r3.z, r0, c12
dp4 r3.y, r0, c11
dp4 r3.x, r0, c10
mad r1.w, r0.x, r0.x, -r1
dp4 r0.z, r2, c15
dp4 r0.x, r2, c13
dp4 r0.y, r2, c14
add r4.xyz, r3, r0
mul r3.xyz, r1.w, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c19.x
mul r2.y, r2, c8.x
add o4.xyz, r4, r3
mad o3.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o3.zw, r0
mov o2.xyz, r1
mad o1.xy, v2, c18, c18.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 288
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeidbaebkjcomhgadfdcnfcabpobdmddbabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcceaeaaaaeaaaabaa
ajabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaacaaaaaamgaabaaa
acaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
aaaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
aaaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
aaaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;


uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_2 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * gl_Vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * gl_Vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * gl_Normal);
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_4.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2)));
  light_2.w = tmpvar_11.w;
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  light_2.xyz = (tmpvar_11.xyz + mix (((8.0 * tmpvar_13.w) * tmpvar_13.xyz), ((8.0 * tmpvar_12.w) * tmpvar_12.xyz), vec3(clamp (((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0))));
  vec4 frag_14;
  frag_14.xyz = (diff_3.xyz * light_2.xyz);
  frag_14.w = diff_3.w;
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_Object2World]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad o3.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o3.zw, r0
mul o5.xyz, r1, c14.w
mad o1.xy, v2, c16, c16.zwzw
mad o4.xy, v3, c15, c15.zwzw
mul o5.w, -r0.x, r0.y
dp3 o2.z, v1, c10
dp3 o2.y, v1, c9
dp3 o2.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 400 [unity_ShadowFadeCenterAndType]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedhdfpklgalkalakbkdkabblndipigadlmabaaaaaaciagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcheaeaaaaeaaaabaabnabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaa
apaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaa
acaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaa
adaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaa
akbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaa
aaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  vec3 tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_6 = TANGENT.xyz;
  tmpvar_7 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = gl_Normal.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = gl_Normal.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = gl_Normal.z;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (tmpvar_8 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  vec3 tmpvar_4;
  tmpvar_4 = normalize(xlv_TEXCOORD1);
  vec4 v_5;
  v_5.x = SkyMatrix[0].x;
  v_5.y = SkyMatrix[1].x;
  v_5.z = SkyMatrix[2].x;
  v_5.w = SkyMatrix[3].x;
  vec4 v_6;
  v_6.x = SkyMatrix[0].y;
  v_6.y = SkyMatrix[1].y;
  v_6.z = SkyMatrix[2].y;
  v_6.w = SkyMatrix[3].y;
  vec4 v_7;
  v_7.x = SkyMatrix[0].z;
  v_7.y = SkyMatrix[1].z;
  v_7.z = SkyMatrix[2].z;
  v_7.w = SkyMatrix[3].z;
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_5.xyz * tmpvar_4.x) + ((v_6.xyz * tmpvar_4.y) + (v_7.xyz * tmpvar_4.z))));
  float x_9;
  x_9 = (tmpvar_3.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 result_11;
  result_11.xyz = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  result_11.w = 0.0;
  vec4 frag_12;
  frag_12.xyz = (diff_2.xyz * (-(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2))) + result_11).xyz);
  frag_12.w = diff_2.w;
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (((tmpvar_8.xyz * tmpvar_8.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
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
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c12
mov r1.w, c18.y
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c15.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.x
mul r2.y, r2, c13.x
dp3 o5.y, r1, r3
mad o3.xy, r2.z, c14.zwzw, r2
dp3 o5.z, v2, r1
dp3 o5.x, r1, v1
mov o0, r0
mov o3.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o4.xy, v4, c16, c16.zwzw
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
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
eefiecedofpkhmmnclmhbeglkopakgcnbbmhjbipabaaaaaaoiafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcdeaeaaaaeaaaabaaanabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
adaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * gl_Normal);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_1 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_1.zw;
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_3 * unity_Scale.w);
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_4.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_2.w = tmpvar_11.w;
  light_2.xyz = (tmpvar_11.xyz + xlv_TEXCOORD3);
  vec4 frag_12;
  frag_12.xyz = (diff_3.xyz * light_2.xyz);
  frag_12.w = diff_3.w;
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c19.y
dp3 r1.z, v1, c6
dp3 r1.x, v1, c4
dp3 r1.y, v1, c5
mul r0.xyz, r1, c17.w
mul r1.w, r0.y, r0.y
mul r2, r0.xyzz, r0.yzzx
dp4 r3.z, r0, c12
dp4 r3.y, r0, c11
dp4 r3.x, r0, c10
mad r1.w, r0.x, r0.x, -r1
dp4 r0.z, r2, c15
dp4 r0.x, r2, c13
dp4 r0.y, r2, c14
add r4.xyz, r3, r0
mul r3.xyz, r1.w, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c19.x
mul r2.y, r2, c8.x
add o4.xyz, r4, r3
mad o3.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o3.zw, r0
mov o2.xyz, r1
mad o1.xy, v2, c18, c18.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 288
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
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
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedeidbaebkjcomhgadfdcnfcabpobdmddbabaaaaaamaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcceaeaaaaeaaaabaa
ajabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaacaaaaaamgaabaaa
acaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
aaaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaa
aaaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaa
aaaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;


uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_2 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * gl_Vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * gl_Vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * gl_Normal);
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 light_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD1);
  vec4 v_6;
  v_6.x = SkyMatrix[0].x;
  v_6.y = SkyMatrix[1].x;
  v_6.z = SkyMatrix[2].x;
  v_6.w = SkyMatrix[3].x;
  vec4 v_7;
  v_7.x = SkyMatrix[0].y;
  v_7.y = SkyMatrix[1].y;
  v_7.z = SkyMatrix[2].y;
  v_7.w = SkyMatrix[3].y;
  vec4 v_8;
  v_8.x = SkyMatrix[0].z;
  v_8.y = SkyMatrix[1].z;
  v_8.z = SkyMatrix[2].z;
  v_8.w = SkyMatrix[3].z;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_6.xyz * tmpvar_5.x) + ((v_7.xyz * tmpvar_5.y) + (v_8.xyz * tmpvar_5.z))));
  float x_10;
  x_10 = (tmpvar_4.w - _Cutoff);
  if ((x_10 < 0.0)) {
    discard;
  };
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_2.w = tmpvar_11.w;
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  light_2.xyz = (tmpvar_11.xyz + mix (((8.0 * tmpvar_13.w) * tmpvar_13.xyz), ((8.0 * tmpvar_12.w) * tmpvar_12.xyz), vec3(clamp (((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0))));
  vec4 frag_14;
  frag_14.xyz = (diff_3.xyz * light_2.xyz);
  frag_14.w = diff_3.w;
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * diff_3.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_Object2World]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad o3.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o3.zw, r0
mul o5.xyz, r1, c14.w
mad o1.xy, v2, c16, c16.zwzw
mad o4.xy, v3, c15, c15.zwzw
mul o5.w, -r0.x, r0.y
dp3 o2.z, v1, c10
dp3 o2.y, v1, c9
dp3 o2.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 400 [unity_ShadowFadeCenterAndType]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedhdfpklgalkalakbkdkabblndipigadlmabaaaaaaciagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcheaeaaaaeaaaabaabnabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaa
apaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaa
acaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaa
adaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaa
akbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaa
aaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaa
aaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  vec3 tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_6 = TANGENT.xyz;
  tmpvar_7 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = gl_Normal.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = gl_Normal.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = gl_Normal.z;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * gl_Normal);
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (tmpvar_8 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform float _Cutoff;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform mat4 SkyMatrix;
uniform vec2 UniformOcclusion;
uniform vec2 ExposureLM;
uniform vec4 ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 diff_2;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * ExposureIBL.w);
  vec3 tmpvar_4;
  tmpvar_4 = normalize(xlv_TEXCOORD1);
  vec4 v_5;
  v_5.x = SkyMatrix[0].x;
  v_5.y = SkyMatrix[1].x;
  v_5.z = SkyMatrix[2].x;
  v_5.w = SkyMatrix[3].x;
  vec4 v_6;
  v_6.x = SkyMatrix[0].y;
  v_6.y = SkyMatrix[1].y;
  v_6.z = SkyMatrix[2].y;
  v_6.w = SkyMatrix[3].y;
  vec4 v_7;
  v_7.x = SkyMatrix[0].z;
  v_7.y = SkyMatrix[1].z;
  v_7.z = SkyMatrix[2].z;
  v_7.w = SkyMatrix[3].z;
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_5.xyz * tmpvar_4.x) + ((v_6.xyz * tmpvar_4.y) + (v_7.xyz * tmpvar_4.z))));
  float x_9;
  x_9 = (tmpvar_3.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec4 result_11;
  result_11.xyz = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  result_11.w = 0.0;
  vec4 frag_12;
  frag_12.xyz = (diff_2.xyz * (texture2DProj (_LightBuffer, xlv_TEXCOORD2) + result_11).xyz);
  frag_12.w = diff_2.w;
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (((tmpvar_8.xyz * tmpvar_8.w) * diff_2.xyz) * xlat_mutableExposureIBL.x));
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
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
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c12
mov r1.w, c18.y
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c15.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.x
mul r2.y, r2, c13.x
dp3 o5.y, r1, r3
mad o3.xy, r2.z, c14.zwzw, r2
dp3 o5.z, v2, r1
dp3 o5.x, r1, v1
mov o0, r0
mov o3.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o4.xy, v4, c16, c16.zwzw
dp3 o2.z, v2, c6
dp3 o2.y, v2, c5
dp3 o2.x, v2, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 320
Vector 240 [unity_LightmapST]
Vector 256 [_MainTex_ST]
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
eefiecedofpkhmmnclmhbeglkopakgcnbbmhjbipabaaaaaaoiafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcdeaeaaaaeaaaabaaanabaaaafjaaaaae
egiocaaaaaaaaaaabbaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
adaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaa
egacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [UniformOcclusion]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
"ps_3_0
; 26 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c8, 0.75341797, 0.24682617, 0.00000000, 1.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r1, r0, s1
mul_pp r0.x, r1.w, r1.w
mul_pp r0.y, r1.w, r0.x
mul_pp r0.xy, r0, c8
add_pp r1.w, r0.x, r0.y
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r0.xyz, r0, c4.w
mov_pp r1.w, c4.x
mul_pp r1.w, c5.x, r1
mul_pp r1.xyz, r0, r1
mul_pp r2.xyz, r1, r1.w
texldp r1.xyz, v2, s2
add_pp r1.w, r0, -c7.x
log_pp r1.x, r1.x
log_pp r1.z, r1.z
log_pp r1.y, r1.y
add_pp r3.xyz, -r1, v3
cmp r1.w, r1, c8.z, c8
mov_pp r1, -r1.w
mad_pp oC0.xyz, r0, r3, r2
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefieceddphapkodpooddjhgmlcjbedknjdgdmodabaaaaaameafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefclmaeaaaaeaaaaaaacpabaaaafjaaaaaeegiocaaaaaaaaaaabcaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaam
bcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaia
ebaaaaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egiocaaaaaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaa
diaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaa
diaaaaaibcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaa
aaaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaai
bcaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaah
hcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
bcaabaaaacaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaa
acaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaa
aceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaa
ckiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaacpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaai
hcaabaaaacaaaaaaegacbaiaebaaaaaaacaaaaaaegbcbaaaaeaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Vector 8 [unity_LightmapFade]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
"ps_3_0
; 36 ALU, 6 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c11, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
texld r0, v3, s3
mul_pp r0.xyz, r0.w, r0
texld r1, v3, s4
mul_pp r1.xyz, r1.w, r1
mul_pp r1.xyz, r1, c11.x
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r3.xyz, r0.w, v1
mad_pp r2.xyz, r0, c11.x, -r1
mul r0.xyz, r3.z, c2
mad r0.xyz, r3.y, c1, r0
dp4 r0.w, v4, v4
rsq r0.w, r0.w
rcp r1.w, r0.w
mad r0.xyz, r3.x, c0, r0
texld r0, r0, s1
mul_pp r3.x, r0.w, r0.w
mad_sat r1.w, r1, c8.z, c8
mad_pp r1.xyz, r1.w, r2, r1
texldp r2.xyz, v2, s2
mul_pp r3.y, r0.w, r3.x
mul_pp r3.xy, r3, c10
add_pp r0.w, r3.x, r3.y
mul_pp r3.xyz, r0, r0.w
mov_pp r0.w, c4.x
mul_pp r1.w, c6.x, r0
log_pp r2.x, r2.x
log_pp r2.y, r2.y
log_pp r2.z, r2.z
add_pp r1.xyz, -r2, r1
texld r2, v0, s0
mul_pp r2, r2, c7
mul_pp r0.xyz, r2, c4.w
add_pp r0.w, r2, -c9.x
mul_pp r2.xyz, r0, r3
mul_pp r1.w, r1, c5.x
cmp r0.w, r0, c10.z, c10
mul_pp r2.xyz, r2, r1.w
mov_pp r3, -r0.w
mad_pp oC0.xyz, r0, r1, r2
texkill r3.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Vector 272 [unity_LightmapFade]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedlonblnoflomogfenjcnmhijjnlejmoneabaaaaaaieahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgeagaaaa
eaaaaaaajjabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabdaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabbaaaaahbcaabaaaabaaaaaaegbobaaa
aeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
dccaaaalbcaabaaaabaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaabbaaaaaa
dkiacaaaaaaaaaaabbaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaa
acaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaa
fgafbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaa
acaaaaaajgahbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaajgahbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaacpaaaaafhcaabaaaacaaaaaa
egacbaaaacaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaadaaaaaa
bkaabaaaacaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
bkaabaaaacaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
bkaabaaaacaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaaeaaaaaa
ckaabaaaacaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaaeaaaaaa
ckaabaaaacaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaaeaaaaaa
ckaabaaaacaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaacaaaaaa
agajbaaaadaaaaaaagajbaaaaeaaaaaadiaaaaaibcaabaaaadaaaaaaakaabaaa
acaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaaakaabaaa
acaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaaakaabaaa
acaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaacaaaaaajgahbaaa
acaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaadaaaaaadkaabaaa
acaaaaaadkaabaaaacaaaaaadiaaaaahccaabaaaadaaaaaadkaabaaaacaaaaaa
akaabaaaadaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaalhnbeadpceljhmdo
aaaaaaaaaaaaaaaaegaabaaaadaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 28 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c10, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
texld r3, v3, s3
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
mul r0.xyz, r1.z, c2
mad r0.xyz, r1.y, c1, r0
mad r0.xyz, r1.x, c0, r0
texldp r1.xyz, v2, s2
texld r0, r0, s1
mul_pp r2.x, r0.w, r0.w
mul_pp r3.xyz, r3.w, r3
mul_pp r2.y, r0.w, r2.x
log_pp r1.x, r1.x
log_pp r1.z, r1.z
log_pp r1.y, r1.y
mad_pp r1.xyz, r3, c10.x, -r1
mul_pp r3.xy, r2, c9
add_pp r0.w, r3.x, r3.y
mul_pp r3.xyz, r0, r0.w
mov_pp r0.w, c4.x
mul_pp r1.w, c6.x, r0
texld r2, v0, s0
mul_pp r2, r2, c7
mul_pp r0.xyz, r2, c4.w
add_pp r0.w, r2, -c8.x
mul_pp r2.xyz, r0, r3
mul_pp r1.w, r1, c5.x
cmp r0.w, r0, c9.z, c9
mul_pp r2.xyz, r2, r1.w
mov_pp r3, -r0.w
mad_pp oC0.xyz, r0, r1, r2
texkill r3.xyzw
mov_pp oC0.w, r2
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedliicbplndjikmkfpjhdneniepoidpjnbabaaaaaagaagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceaafaaaa
eaaaaaaafaabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabdaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaaabaaaaaa
akaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaalhnbeadpceljhmdo
aaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaacpaaaaaf
hcaabaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [UniformOcclusion]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
"ps_3_0
; 23 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c8, 0.75341797, 0.24682617, 0.00000000, 1.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r1, r0, s1
mul_pp r0.x, r1.w, r1.w
mul_pp r0.y, r1.w, r0.x
mul_pp r2.xy, r0, c8
add_pp r1.w, r2.x, r2.y
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r2.xyz, r0, c4.w
mul_pp r0.xyz, r2, r1
mov_pp r1.w, c4.x
mul_pp r1.x, c5, r1.w
mul_pp r3.xyz, r0, r1.x
add_pp r1.y, r0.w, -c7.x
cmp r1.x, r1.y, c8.z, c8.w
texldp r0.xyz, v2, s2
mov_pp r1, -r1.x
add_pp r0.xyz, r0, v3
mad_pp oC0.xyz, r2, r0, r3
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedaofbbcfhcoaihbieopjpmkoeiiaikmnjabaaaaaakmafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckeaeaaaaeaaaaaaacjabaaaafjaaaaaeegiocaaaaaaaaaaabcaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaam
bcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaia
ebaaaaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egiocaaaaaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaa
diaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaa
diaaaaaibcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaa
aaaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaai
bcaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaah
hcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
bcaabaaaacaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaa
acaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaa
aceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaa
ckiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaa
aeaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Vector 8 [unity_LightmapFade]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
"ps_3_0
; 33 ALU, 6 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c11, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
texld r0, v3, s3
mul_pp r2.xyz, r0.w, r0
texld r0, v3, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c11.x
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r3.xyz, r1.x, v1
mul r1.xyz, r3.z, c2
mad r1.xyz, r3.y, c1, r1
mad r1.xyz, r3.x, c0, r1
dp4 r0.w, v4, v4
rsq r0.w, r0.w
rcp r2.w, r0.w
texld r1, r1, s1
mad_pp r2.xyz, r2, c11.x, -r0
mad_sat r2.w, r2, c8.z, c8
mad_pp r3.xyz, r2.w, r2, r0
mul_pp r0.w, r1, r1
texldp r2.xyz, v2, s2
mul_pp r0.x, r1.w, r0.w
add_pp r3.xyz, r2, r3
mul_pp r2.xy, r0.wxzw, c10
add_pp r1.w, r2.x, r2.y
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c4.w
add_pp r2.x, r0.w, -c9
mov_pp r1.w, c4.x
mul_pp r1.w, c6.x, r1
mul_pp r1.xyz, r0, r1
mul_pp r1.w, r1, c5.x
cmp r2.w, r2.x, c10.z, c10
mul_pp r2.xyz, r1, r1.w
mov_pp r1, -r2.w
mad_pp oC0.xyz, r0, r3, r2
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Vector 272 [unity_LightmapFade]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedapllolnmbokmocbhkipghdddokhlbnodabaaaaaagmahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcemagaaaa
eaaaaaaajdabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabdaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabbaaaaahbcaabaaaabaaaaaaegbobaaa
aeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
dccaaaalbcaabaaaabaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaabbaaaaaa
dkiacaaaaaaaaaaabbaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaa
acaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaa
fgafbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaa
acaaaaaajgahbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaajgahbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaai
bcaabaaaadaaaaaabkaabaaaacaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaadaaaaaabkaabaaaacaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaadaaaaaabkaabaaaacaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaai
bcaabaaaaeaaaaaackaabaaaacaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaaeaaaaaackaabaaaacaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaaeaaaaaackaabaaaacaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaah
ocaabaaaacaaaaaaagajbaaaadaaaaaaagajbaaaaeaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaacaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaa
adaaaaaaakaabaaaacaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaa
adaaaaaaakaabaaaacaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaa
acaaaaaajgahbaaaacaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egacbaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaa
adaaaaaadkaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahccaabaaaadaaaaaa
dkaabaaaacaaaaaaakaabaaaadaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaa
lhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaa
aaaaaaaaaeaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 25 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.75341797, 0.24682617, 0.00000000, 1.00000000
def c10, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c9
add_pp r0.w, r1.x, r1.y
mul_pp r0.xyz, r0, r0.w
texld r1, v0, s0
mul_pp r1, r1, c7
mul_pp r2.xyz, r1, c4.w
add_pp r1.x, r1.w, -c8
cmp r2.w, r1.x, c9.z, c9
mov_pp r0.w, c4.x
mul_pp r0.w, c6.x, r0
mul_pp r0.xyz, r2, r0
mul_pp r0.w, r0, c5.x
mul_pp r3.xyz, r0, r0.w
texld r0, v3, s3
mul_pp r0.xyz, r0.w, r0
texldp r1.xyz, v2, s2
mad_pp r1.xyz, r0, c10.x, r1
mov_pp r0, -r2.w
mad_pp oC0.xyz, r2, r1, r3
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedcgghfgohdnkjdeihhccadllgcgecjkfkabaaaaaaeiagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcciafaaaa
eaaaaaaaekabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabdaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaaabaaaaaa
akaabaaaacaaaaaaapaaaaakicaabaaaabaaaaaaaceaaaaalhnbeadpceljhmdo
aaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaaj
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [UniformOcclusion]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
"ps_3_0
; 22 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r1, r0, s1
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r0.xyz, r0, c4.w
mov_pp r1.w, c4.x
mul_pp r1.w, c5.x, r1
mul_pp r1.xyz, r0, r1
mul_pp r2.xyz, r1, r1.w
texldp r1.xyz, v2, s2
add_pp r1.w, r0, -c7.x
log_pp r1.x, r1.x
log_pp r1.z, r1.z
log_pp r1.y, r1.y
add_pp r3.xyz, -r1, v3
cmp r1.w, r1, c8.x, c8.y
mov_pp r1, -r1.w
mad_pp oC0.xyz, r0, r3, r2
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecednlfgmpogmpooioomomejkflddfachdbgabaaaaaageafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcfmaeaaaaeaaaaaaabhabaaaafjaaaaaeegiocaaaaaaaaaaabcaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaam
bcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaia
ebaaaaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egiocaaaaaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaa
diaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaa
diaaaaaibcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaa
aaaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaai
bcaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaah
hcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaa
ckiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaacpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaai
hcaabaaaacaaaaaaegacbaiaebaaaaaaacaaaaaaegbcbaaaaeaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Vector 8 [unity_LightmapFade]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
"ps_3_0
; 32 ALU, 6 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, 0.00000000, 1.00000000, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
texld r0, v3, s4
mul_pp r0.xyz, r0.w, r0
texld r1, v3, s3
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r0, c10.z
dp4 r0.w, v4, v4
dp3 r1.w, v1, v1
rsq r1.w, r1.w
rsq r0.w, r0.w
rcp r0.w, r0.w
mul r3.xyz, r1.w, v1
mad_pp r1.xyz, r1, c10.z, -r0
mad_sat r0.w, r0, c8.z, c8
mad_pp r2.xyz, r0.w, r1, r0
texldp r1.xyz, v2, s2
mul r0.xyz, r3.z, c2
mad r0.xyz, r3.y, c1, r0
mad r0.xyz, r3.x, c0, r0
texld r0, r0, s1
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c4.x
mul_pp r2.w, c6.x, r0
log_pp r1.x, r1.x
log_pp r1.y, r1.y
log_pp r1.z, r1.z
add_pp r2.xyz, -r1, r2
texld r1, v0, s0
mul_pp r1, r1, c7
mul_pp r1.xyz, r1, c4.w
add_pp r0.w, r1, -c9.x
mul_pp r0.xyz, r1, r0
mul_pp r2.w, r2, c5.x
mul_pp r3.xyz, r0, r2.w
cmp r0.w, r0, c10.x, c10.y
mov_pp r0, -r0.w
mad_pp oC0.xyz, r1, r2, r3
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Vector 272 [unity_LightmapFade]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedpbecnmimokmgioaeffnjnobbapnghajkabaaaaaaceahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcaeagaaaa
eaaaaaaaibabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabdaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabbaaaaahbcaabaaaabaaaaaaegbobaaa
aeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
dccaaaalbcaabaaaabaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaabbaaaaaa
dkiacaaaaaaaaaaabbaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaa
acaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaa
fgafbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaa
acaaaaaajgahbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaajgahbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaacpaaaaafhcaabaaaacaaaaaa
egacbaaaacaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaia
ebaaaaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaadaaaaaa
bkaabaaaacaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
bkaabaaaacaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
bkaabaaaacaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaaeaaaaaa
ckaabaaaacaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaaeaaaaaa
ckaabaaaacaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaaeaaaaaa
ckaabaaaacaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaacaaaaaa
agajbaaaadaaaaaaagajbaaaaeaaaaaadiaaaaaibcaabaaaadaaaaaaakaabaaa
acaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaaakaabaaa
acaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaaakaabaaa
acaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaacaaaaaajgahbaaa
acaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
acaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 24 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.00000000, 1.00000000, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
texldp r2.xyz, v2, s2
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyw, r0.x, v1.yzzx
mul r1.xyz, r0.y, c2
mad r0.xyz, r0.x, c1, r1
texld r1, v3, s3
mul_pp r1.xyz, r1.w, r1
log_pp r2.x, r2.x
log_pp r2.z, r2.z
log_pp r2.y, r2.y
mad_pp r3.xyz, r1, c9.z, -r2
mad r1.xyz, r0.w, c0, r0
texld r1, r1, s1
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c4.w
add_pp r2.x, r0.w, -c8
mov_pp r1.w, c4.x
mul_pp r1.w, c6.x, r1
mul_pp r1.xyz, r0, r1
mul_pp r1.w, r1, c5.x
cmp r2.w, r2.x, c9.x, c9.y
mul_pp r2.xyz, r1, r1.w
mov_pp r1, -r2.w
mad_pp oC0.xyz, r0, r3, r2
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedfpanolkmcbgjemdipfmbbllpalmhfhhnabaaaaaaaaagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaaeaaaa
eaaaaaaadiabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabdaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaacpaaaaaf
hcaabaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [UniformOcclusion]
Vector 6 [_Color]
Float 7 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
"ps_3_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r1.xyz, r0.x, c0, r1
texld r1, r1, s1
mul_pp r1.xyz, r1, r1.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r2.xyz, r0, c4.w
mul_pp r0.xyz, r2, r1
mov_pp r1.w, c4.x
mul_pp r1.x, c5, r1.w
mul_pp r3.xyz, r0, r1.x
add_pp r1.y, r0.w, -c7.x
cmp r1.x, r1.y, c8, c8.y
texldp r0.xyz, v2, s2
mov_pp r1, -r1.x
add_pp r0.xyz, r0, v3
mad_pp oC0.xyz, r2, r0, r3
texkill r1.xyzw
mov_pp oC0.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
ConstBuffer "$Globals" 288
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 272 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedfchgmeknpllhilpamljddkefmoicillbabaaaaaaemafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefceeaeaaaaeaaaaaaabbabaaaafjaaaaaeegiocaaaaaaaaaaabcaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaam
bcaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaia
ebaaaaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egiocaaaaaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
abeaaaaaaaaaaaaaanaaaeadakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaa
diaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaacaaaaaabkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaa
diaaaaaibcaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaa
diaaaaaiccaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaa
diaaaaaiecaabaaaadaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaa
aaaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaai
bcaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaacaaaaaaakaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaah
hcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegacbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaa
ckiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaa
aeaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Vector 8 [unity_LightmapFade]
Float 9 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
"ps_3_0
; 29 ALU, 6 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, 0.00000000, 1.00000000, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
texld r0, v3, s4
mul_pp r0.xyz, r0.w, r0
texld r1, v3, s3
dp4 r0.w, v4, v4
rsq r0.w, r0.w
rcp r0.w, r0.w
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r0, c10.z
mad_pp r2.xyz, r1, c10.z, -r0
mad_sat r0.w, r0, c8.z, c8
mad_pp r0.xyz, r0.w, r2, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
mul r3.xyz, r1.z, c2
texldp r2.xyz, v2, s2
mad r3.xyz, r1.y, c1, r3
add_pp r2.xyz, r2, r0
mad r0.xyz, r1.x, c0, r3
texld r0, r0, s1
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c4.x
mul_pp r2.w, c6.x, r0
texld r1, v0, s0
mul_pp r1, r1, c7
mul_pp r1.xyz, r1, c4.w
add_pp r0.w, r1, -c9.x
mul_pp r0.xyz, r1, r0
mul_pp r2.w, r2, c5.x
mul_pp r3.xyz, r0, r2.w
cmp r0.w, r0, c10.x, c10.y
mov_pp r0, -r0.w
mad_pp oC0.xyz, r1, r2, r3
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Vector 272 [unity_LightmapFade]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefieceddfihahldfekaagdikhbmpkogppefcgdlabaaaaaaamahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcomafaaaa
eaaaaaaahlabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaa
aaaaaaaabdaaaaaadiaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaaoaaaaaadbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaanaaaeadakaabaaaabaaaaaabbaaaaahbcaabaaaabaaaaaaegbobaaa
aeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaa
dccaaaalbcaabaaaabaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaabbaaaaaa
dkiacaaaaaaaaaaabbaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaa
acaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaa
fgafbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadiaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaa
acaaaaaajgahbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaajgahbaaaabaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaai
bcaabaaaadaaaaaabkaabaaaacaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaadaaaaaabkaabaaaacaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaadaaaaaabkaabaaaacaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaai
bcaabaaaaeaaaaaackaabaaaacaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaai
ccaabaaaaeaaaaaackaabaaaacaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaai
ecaabaaaaeaaaaaackaabaaaacaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaah
ocaabaaaacaaaaaaagajbaaaadaaaaaaagajbaaaaeaaaaaadiaaaaaibcaabaaa
adaaaaaaakaabaaaacaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaa
adaaaaaaakaabaaaacaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaa
adaaaaaaakaabaaaacaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaa
acaaaaaajgahbaaaacaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egacbaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaa
aaaaaaaaaeaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaeaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [ExposureIBL]
Vector 5 [ExposureLM]
Vector 6 [UniformOcclusion]
Vector 7 [_Color]
Float 8 [_Cutoff]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
"ps_3_0
; 21 ALU, 5 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c9, 0.00000000, 1.00000000, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r0.xyz, r0, r0.w
texld r1, v0, s0
mul_pp r1, r1, c7
mul_pp r2.xyz, r1, c4.w
add_pp r1.x, r1.w, -c8
cmp r2.w, r1.x, c9.x, c9.y
mov_pp r0.w, c4.x
mul_pp r0.w, c6.x, r0
mul_pp r0.xyz, r2, r0
mul_pp r0.w, r0, c5.x
mul_pp r3.xyz, r0, r0.w
texld r0, v3, s3
mul_pp r0.xyz, r0.w, r0
texldp r1.xyz, v2, s2
mad_pp r1.xyz, r0, c9.z, r1
mov_pp r0, -r2.w
mad_pp oC0.xyz, r2, r1, r3
texkill r0.xyzw
mov_pp oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_DiffCubeIBL] CUBE 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
ConstBuffer "$Globals" 320
Matrix 80 [SkyMatrix]
Vector 48 [ExposureIBL]
Vector 64 [ExposureLM] 2
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 304 [_Cutoff]
BindCB  "$Globals" 0
"ps_4_0
eefiecedofjifahiacldapboleagpiffmgfjhdckabaaaaaaoiafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmiaeaaaa
eaaaaaaadcabaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaambcaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaaoaaaaaaakiacaiaebaaaaaaaaaaaaaabdaaaaaa
diaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaaoaaaaaa
dbaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaanaaaead
akaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaabaaaaaaegbcbaaaacaaaaaadiaaaaaibcaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaa
bkaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaibcaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaadaaaaaa
ckaabaaaabaaaaaackiacaaaaaaaaaaaahaaaaaaaaaaaaahocaabaaaabaaaaaa
agajbaaaacaaaaaaagajbaaaadaaaaaadiaaaaaibcaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaa
abaaaaaaakiacaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegacbaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaackiacaaaaaaaaaaaaeaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaaj
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}
}
 }
}
Fallback "Transparent/Cutout/Diffuse"
}