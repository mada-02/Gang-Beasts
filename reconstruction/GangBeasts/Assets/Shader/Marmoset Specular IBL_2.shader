Shader "Marmoset/Mobile/Specular IBL" {
Properties {
 _Color ("Diffuse Color", Color) = (1,1,1,1)
 _SpecColor ("Specular Color", Color) = (1,1,1,1)
 _SpecInt ("Specular Intensity", Float) = 1
 _Shininess ("Specular Sharpness", Range(2,8)) = 4
 _Fresnel ("Fresnel Strength", Range(0,1)) = 0
 _MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
 _SpecTex ("Specular(RGB) Gloss(A)", 2D) = "white" {}
 _DiffCubeIBL ("Custom Diffuse Cube", CUBE) = "black" {}
 _SpecCubeIBL ("Custom Specular Cube", CUBE) = "black" {}
}
SubShader { 
 LOD 250
 Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry" "RenderType"="Opaque" }
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = ((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y))));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_5.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  float tmpvar_10;
  tmpvar_10 = exp2((8.0 - tmpvar_7));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_7);
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_13;
  frag_13.w = 1.0;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_13.xyz = (frag_13.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_10)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  frag_13.xyz = frag_13.xyz;
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Vector 20 [unity_Scale]
Vector 21 [_MainTex_ST]
"vs_3_0
; 49 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c20.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c22.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c15
dp4 r2.y, r0.wxyz, c14
dp4 r2.x, r0.wxyz, c13
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r2.xyz, r2, r0
mov r1.w, c22.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r1.xyz, r0, c20.w, -v0
mul r1.w, r3, r3
mad r0.y, r0.w, r0.w, -r1.w
mul r3.xyz, r0.y, c19
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r1.xyz, -r0, c22.y, -r1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c12
dp3 r1.w, r0, r0
rsq r1.w, r1.w
add o6.xyz, r2, r3
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mul o4.xyz, r1.w, r0
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r0.w
mad o1.xy, v2, c21, c21.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecednbhkgiejcgimgipchmbakbjlfkgehnnkabaaaaaajeaiaaaaadaaaaaa
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
aaklklklfdeieefcmiagaaaaeaaaabaalcabaaaafjaaaaaeegiocaaaaaaaaaaa
bbaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadiaaaaaj
hcaabaaaaaaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaa
bcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaa
aaaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegbcbaaa
acaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
aeaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaa
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
ebaaaaaaaaaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  vec4 tmpvar_9;
  tmpvar_9 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8)));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c_1.xyz = (diff_3.xyz * ((8.0 * tmpvar_11.w) * tmpvar_11.xyz));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_9.xyz * tmpvar_9.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_10.xyz * tmpvar_10.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c16, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c12
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c13.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r1.xyz, -r1, c16.y, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mul o4.xyz, r0.w, r0
mad o1.xy, v2, c15, c15.zwzw
mad o5.xy, v3, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
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
eefiecednhjlkmfhgjpgikhllcpllcoepfjcionoabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmiaeaaaaeaaaabaadcabaaaafjaaaaae
egiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaabaaaaaaakgiocaaaaaaaaaaabaaaaaaa
diaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaa
bbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaa
abaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
acaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaal
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaia
ebaaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaa
egbcbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaalhcaabaaaaaaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaa
aaaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaaeaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
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
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((tmpvar_7 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_5.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  float tmpvar_10;
  tmpvar_10 = exp2((8.0 - tmpvar_7));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_7);
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_13.w) * tmpvar_13.xyz);
  vec3 tmpvar_16;
  tmpvar_16 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  c_1.xyz = ((((spec_2.xyz * ((tmpvar_10 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (normalize((normalize((((tmpvar_16.x * vec3(0.816497, 0.0, 0.57735)) + (tmpvar_16.y * vec3(-0.408248, 0.707107, 0.57735))) + (tmpvar_16.z * vec3(-0.408248, -0.707107, 0.57735)))) + xlv_TEXCOORD3)).z, 0.0, 1.0), tmpvar_10))) * tmpvar_15) + (diff_3.xyz * tmpvar_15));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
; 32 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c16, 1.00000000, 2.00000000, 0, 0
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
mov r1.w, c16.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c13.w, -v0
dp3 r0.y, r1, r0
dp3 r0.w, v2, -r1
dp3 r0.x, r1, v1
mov r0.z, -r0.w
mul r2.xyz, v2, r0.w
mad r1.xyz, -r2, c16.y, -r1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul o4.xyz, r0.w, r0
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mad o1.xy, v3, c15, c15.zwzw
mad o5.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v2, c6
dp3 o3.y, v2, c5
dp3 o3.x, v2, c4
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
eefiecedhbcnnkbaafaobgoijnfdcaogcembfcnnabaaaaaaiaagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmmaeaaaaeaaaabaaddabaaaafjaaaaae
egiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabaaaaaaa
kgiocaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
acaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
acaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaaegbcbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaalhcaabaaaabaaaaaaegbcbaaa
acaaaaaapgapbaiaebaaaaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaa
acaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
abaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhccabaaaaeaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  vec3 x2_9;
  vec3 x1_10;
  x1_10.x = dot (unity_SHAr, tmpvar_8);
  x1_10.y = dot (unity_SHAg, tmpvar_8);
  x1_10.z = dot (unity_SHAb, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  vec4 o_12;
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_1 * 0.5);
  vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_13.x;
  tmpvar_14.y = (tmpvar_13.y * _ProjectionParams.x);
  o_12.xy = (tmpvar_14 + tmpvar_13.w);
  o_12.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = ((x1_10 + x2_9) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
  xlv_TEXCOORD6 = o_12;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_5.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  float tmpvar_10;
  tmpvar_10 = exp2((8.0 - tmpvar_7));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_7);
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_13;
  frag_13.w = 1.0;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_13.xyz = (frag_13.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_10)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  frag_13.xyz = (frag_13.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x);
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [unity_Scale]
Vector 23 [_MainTex_ST]
"vs_3_0
; 54 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c24, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c22.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c24.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c17
dp4 r2.y, r0.wxyz, c16
dp4 r2.x, r0.wxyz, c15
dp4 r0.z, r1, c20
dp4 r0.x, r1, c18
dp4 r0.y, r1, c19
add r2.xyz, r2, r0
mov r1.w, c24.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r1.xyz, r0, c22.w, -v0
mul r0.y, r3.w, r3.w
mad r1.w, r0, r0, -r0.y
mul r3.xyz, r1.w, c21
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c24.y, -r1
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
add o6.xyz, r2, r3
mul r2.xyz, r1.xyww, c24.z
mul r2.y, r2, c13.x
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c12
mad o7.xy, r2.z, c14.zwzw, r2
dp3 r2.x, r0, r0
rsq r2.x, r2.x
mov o0, r1
mul o4.xyz, r2.x, r0
mov o7.zw, r1
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r0.w
mad o1.xy, v2, c23, c23.zwzw
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedmflengamceeedagnnfelahfchaheeondabaaaaaaeeajaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
gaahaaaaeaaaabaaniabaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacafaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabeaaaaaaogikcaaaaaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaai
icaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegbcbaaaacaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaaeaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
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
dcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaahaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaahaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec4 o_6;
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_1 * 0.5);
  vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_6;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  vec4 tmpvar_9;
  tmpvar_9 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8)));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec3 tmpvar_13;
  tmpvar_13 = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  c_1.xyz = (diff_3.xyz * max (min (tmpvar_13, ((tmpvar_11.x * 2.0) * tmpvar_12.xyz)), (tmpvar_13 * tmpvar_11.x)));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_9.xyz * tmpvar_9.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_10.xyz * tmpvar_10.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
; 33 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c18, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.w, c18.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c15.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r1.xyz, -r1, c18.y, -r0
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.z
mul r2.y, r2, c13.x
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
add r1.xyz, -r1, c12
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mad o6.xy, r2.z, c14.zwzw, r2
mov o0, r0
mul o4.xyz, r1.w, r1
mov o6.zw, r0
mad o1.xy, v2, c17, c17.zwzw
mad o5.xy, v3, c16, c16.zwzw
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
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
eefiecednlhhhhnpjmbnibiminocpjflcebpmbdiabaaaaaacmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgaafaaaaeaaaabaafiabaaaafjaaaaaeegiocaaaaaaaaaaa
bgaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabfaaaaaa
ogikcaaaaaaaaaaabfaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaa
agiecaaaaaaaaaaabeaaaaaakgiocaaaaaaaaaaabeaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaa
egacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaa
baaaaaaiicaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegbcbaaaacaaaaaa
aaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajhcaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaaeaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
afaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
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
  vec4 o_10;
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_1 * 0.5);
  vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((tmpvar_8 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_10;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_5.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  float tmpvar_10;
  tmpvar_10 = exp2((8.0 - tmpvar_7));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_7);
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  vec3 tmpvar_16;
  tmpvar_16 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  vec3 tmpvar_17;
  tmpvar_17 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  c_1.xyz = ((((spec_2.xyz * ((tmpvar_10 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (normalize((normalize((((tmpvar_17.x * vec3(0.816497, 0.0, 0.57735)) + (tmpvar_17.y * vec3(-0.408248, 0.707107, 0.57735))) + (tmpvar_17.z * vec3(-0.408248, -0.707107, 0.57735)))) + xlv_TEXCOORD3)).z, 0.0, 1.0), tmpvar_10))) * tmpvar_16) + (diff_3.xyz * max (min (tmpvar_16, ((tmpvar_13.x * 2.0) * tmpvar_14.xyz)), (tmpvar_16 * tmpvar_13.x))));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c18, 1.00000000, 2.00000000, 0.50000000, 0
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
mov r1.w, c18.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c15.w, -v0
dp3 r0.y, r1, r0
dp3 r0.w, v2, -r1
mul r2.xyz, v2, r0.w
mad r2.xyz, -r2, c18.y, -r1
dp3 r0.x, r1, v1
mov r0.z, -r0.w
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul o4.xyz, r0.w, r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.z
mul r1.y, r1, c13.x
dp3 o2.z, r2, c6
dp3 o2.y, r2, c5
dp3 o2.x, r2, c4
mad o6.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o5.xy, v4, c16, c16.zwzw
dp3 o3.z, v2, c6
dp3 o3.y, v2, c5
dp3 o3.x, v2, c4
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
eefiecedpoeodhbfhicglnockfdeidigflfeekbjabaaaaaadaahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgeafaaaaeaaaabaafjabaaaafjaaaaaeegiocaaaaaaaaaaa
bgaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabfaaaaaaogikcaaaaaaaaaaabfaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabeaaaaaakgiocaaaaaaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
acaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaaiicaabaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaaegbcbaaaacaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaaaabaaaaaadcaaaaalhcaabaaaacaaaaaaegbcbaaaacaaaaaapgapbaia
ebaaaaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaaihcaabaaaadaaaaaa
fgafbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaa
acaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhccabaaa
aeaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_12;
  tmpvar_12 = (unity_4LightPosX0 - tmpvar_11.x);
  vec4 tmpvar_13;
  tmpvar_13 = (unity_4LightPosY0 - tmpvar_11.y);
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosZ0 - tmpvar_11.z);
  vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_12 * tmpvar_12) + (tmpvar_13 * tmpvar_13)) + (tmpvar_14 * tmpvar_14));
  vec4 tmpvar_16;
  tmpvar_16 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_12 * tmpvar_6.x) + (tmpvar_13 * tmpvar_6.y)) + (tmpvar_14 * tmpvar_6.z)) * inversesqrt(tmpvar_15))) * (1.0/((1.0 + (tmpvar_15 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y)))) + ((((unity_LightColor[0].xyz * tmpvar_16.x) + (unity_LightColor[1].xyz * tmpvar_16.y)) + (unity_LightColor[2].xyz * tmpvar_16.z)) + (unity_LightColor[3].xyz * tmpvar_16.w)));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_5.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  float tmpvar_10;
  tmpvar_10 = exp2((8.0 - tmpvar_7));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_7);
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_13;
  frag_13.w = 1.0;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_13.xyz = (frag_13.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_10)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  frag_13.xyz = frag_13.xyz;
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_4LightPosX0]
Vector 14 [unity_4LightPosY0]
Vector 15 [unity_4LightPosZ0]
Vector 16 [unity_4LightAtten0]
Vector 17 [unity_LightColor0]
Vector 18 [unity_LightColor1]
Vector 19 [unity_LightColor2]
Vector 20 [unity_LightColor3]
Vector 21 [unity_SHAr]
Vector 22 [unity_SHAg]
Vector 23 [unity_SHAb]
Vector 24 [unity_SHBr]
Vector 25 [unity_SHBg]
Vector 26 [unity_SHBb]
Vector 27 [unity_SHC]
Vector 28 [unity_Scale]
Vector 29 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c30, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c28.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c14
dp3 r4.z, r3, c5
dp3 r3.z, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c13
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.y, r4.z
mov r5.z, r3
mov r5.w, c30.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c15
mad r2, r1, r1, r2
mad r0, r3.z, r1, r0
mul r1, r2, c16
add r1, r1, c30.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c23
dp4 r2.y, r5, c22
dp4 r2.x, r5, c21
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c30.z
mul r0, r0, r1
mul r1.xyz, r0.y, c18
mad r1.xyz, r0.x, c17, r1
mad r0.xyz, r0.z, c19, r1
mad r1.xyz, r0.w, c20, r0
mul r0, r5.xyzz, r5.yzzx
dp4 r5.w, r0, c26
dp4 r5.z, r0, c25
dp4 r5.y, r0, c24
mul r0.x, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0.x
add r2.xyz, r2, r5.yzww
mov r0.w, c30.x
mov r0.xyz, c12
dp4 r5.w, r0, c10
dp4 r5.y, r0, c8
dp4 r5.z, r0, c9
mad r0.xyz, r5.yzww, c28.w, -v0
mul r5.yzw, r1.w, c27.xxyz
add r5.yzw, r2.xxyz, r5
dp3 r0.w, v1, -r0
mul r2.xyz, v1, r0.w
mad r0.xyz, -r2, c30.y, -r0
add o6.xyz, r5.yzww, r1
mov r3.x, r4.w
mov r3.y, r4
add r1.xyz, -r3.wxyw, c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
mul o4.xyz, r0.w, r1
mov o5.z, r3
mov o5.y, r4.z
mov o5.x, r5
mad o1.xy, v2, c29, c29.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecednokdacefjkpkcedccfcjijllbcabodhkabaaaaaaemalaaaaadaaaaaa
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
aaklklklfdeieefciaajaaaaeaaaabaagaacaaaafjaaaaaeegiocaaaaaaaaaaa
bbaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadiaaaaaj
hcaabaaaaaaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaa
bcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaa
aaaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegbcbaaa
acaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
aeaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaa
abaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaa
abaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaa
egakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
aeaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaia
ebaaaaaaaaaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaia
ebaaaaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaa
fgafbaaaabaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaaaaaaaaaakgakbaia
ebaaaaaaaaaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaafaaaaaaagaabaaaabaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
adaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaaj
pcaabaaaadaaaaaaegaobaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaa
dcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaakgakbaaaabaaaaaaegaobaaa
aeaaaaaaeeaaaaafpcaabaaaabaaaaaaegaobaaaadaaaaaadcaaaaanpcaabaaa
adaaaaaaegaobaaaadaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaahpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaabaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaa
aaaaaaaaegaobaaaadaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaagaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  vec3 x2_9;
  vec3 x1_10;
  x1_10.x = dot (unity_SHAr, tmpvar_8);
  x1_10.y = dot (unity_SHAg, tmpvar_8);
  x1_10.z = dot (unity_SHAb, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  vec3 tmpvar_12;
  tmpvar_12 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_13;
  tmpvar_13 = (unity_4LightPosX0 - tmpvar_12.x);
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosY0 - tmpvar_12.y);
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosZ0 - tmpvar_12.z);
  vec4 tmpvar_16;
  tmpvar_16 = (((tmpvar_13 * tmpvar_13) + (tmpvar_14 * tmpvar_14)) + (tmpvar_15 * tmpvar_15));
  vec4 tmpvar_17;
  tmpvar_17 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_13 * tmpvar_7.x) + (tmpvar_14 * tmpvar_7.y)) + (tmpvar_15 * tmpvar_7.z)) * inversesqrt(tmpvar_16))) * (1.0/((1.0 + (tmpvar_16 * unity_4LightAtten0)))));
  vec4 o_18;
  vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_1 * 0.5);
  vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_18.xy = (tmpvar_20 + tmpvar_19.w);
  o_18.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = (((x1_10 + x2_9) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y)))) + ((((unity_LightColor[0].xyz * tmpvar_17.x) + (unity_LightColor[1].xyz * tmpvar_17.y)) + (unity_LightColor[2].xyz * tmpvar_17.z)) + (unity_LightColor[3].xyz * tmpvar_17.w)));
  xlv_TEXCOORD6 = o_18;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_5.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  float tmpvar_10;
  tmpvar_10 = exp2((8.0 - tmpvar_7));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_7);
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_13;
  frag_13.w = 1.0;
  frag_13.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_13.xyz = (frag_13.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_10)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  frag_13.xyz = (frag_13.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x);
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Vector 30 [unity_Scale]
Vector 31 [_MainTex_ST]
"vs_3_0
; 84 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c32, 1.00000000, 2.00000000, 0.00000000, 0.50000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c30.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c16
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c15
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c32.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c17
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c18
add r1, r1, c32.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c25
dp4 r2.y, r5, c24
dp4 r2.x, r5, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c32.z
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c22, r0
dp4 r3.z, r1, c28
dp4 r3.x, r1, c26
dp4 r3.y, r1, c27
add r3.xyz, r2, r3
mov r1.w, c32.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c30.w, -v0
dp3 r0.w, v1, -r1
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c32.y, -r1
mul r5.yzw, r1.w, c29.xxyz
add r3.xyz, r3, r5.yzww
add o6.xyz, r3, r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c32.w
dp3 o2.x, r1, c4
mov r1.x, r2
mul r1.y, r2, c13.x
mov r3.x, r4.w
mov r3.y, r4
add r3.xyz, -r3.wxyw, c12
mad o7.xy, r2.z, c14.zwzw, r1
dp3 r1.x, r3, r3
rsq r1.x, r1.x
mov o0, r0
mul o4.xyz, r1.x, r3
mov o7.zw, r0
mov o5.z, r4.x
mov o5.y, r4.z
mov o5.x, r5
mad o1.xy, v2, c31, c31.zwzw
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedbjhoclafakmeaoblhmdfgbmlloadkcoaabaaaaaapmalaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
biakaaaaeaaaabaaigacaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacahaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabeaaaaaaogikcaaaaaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaai
icaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegbcbaaaacaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaaeaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaaacaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaacaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaaacaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaa
acaaaaaadiaaaaahpcaabaaaaeaaaaaajgacbaaaacaaaaaaegakbaaaacaaaaaa
bbaaaaaibcaabaaaafaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaaeaaaaaa
bbaaaaaiccaabaaaafaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaaeaaaaaa
bbaaaaaiecaabaaaafaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaaeaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaafaaaaaadiaaaaah
icaabaaaabaaaaaabkaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaadkaabaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaabaaaaaa
egiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaacaaaaaa
egaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaa
aeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaabaaaaaaegiocaaa
acaaaaaaacaaaaaaaaaaaaajpcaabaaaabaaaaaakgakbaiaebaaaaaaabaaaaaa
egiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaa
agaabaaaacaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaafaaaaaaeeaaaaaf
pcaabaaaacaaaaaaegaobaaaaeaaaaaadcaaaaanpcaabaaaaeaaaaaaegaobaaa
aeaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaaeaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaacaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
aeaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
agaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaahhccabaaaagaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaahaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaahaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [ExposureIBL]
Vector 4 [UniformOcclusion]
Vector 5 [_Color]
Float 6 [_SpecInt]
Float 7 [_Shininess]
Float 8 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
"ps_3_0
; 50 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
def c9, 7.00000000, 8.00000000, 0.50000000, 1.00000000
def c10, 0.85009766, -0.84997559, 0.15915494, 0.31830987
def c11, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r1, v0, s1
add_pp r0.xyz, v3, c0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp_sat r2.x, v4, r0
mov r0.xyz, v3
dp3_sat r0.x, v2, r0
add_pp r1.w, -r1, c9
mad_pp r1.w, -r1, r1, c9
mad_pp r0.w, -r1, c7.x, r1
add_pp r1.w, r0, c9.x
add_pp r0.w, -r1, c9.y
mov_pp r5.xy, c3
exp_pp r2.y, r0.w
add r2.z, -r0.x, c9.w
pow r0, r2.x, r2.y
mad_pp r0.y, r2.z, c9.z, c9.z
mul_pp r0.z, r2, r0.y
mad_pp r0.z, r0, c10.x, c10.y
mov_pp r0.y, c9.w
mad_pp r0.y, r0.z, c8.x, r0
mul_pp r0.y, r0, c6.x
mad r0.z, r2.y, c10, c10.w
mul_pp r0.y, r0, c3.w
mul_pp r1.xyz, r1, c2
mul_pp r2.xyz, r1, r0.y
mul_pp r1.xyz, r2, r0.z
mul_pp r0.xyz, r0.x, c1
mul_pp r0.xyz, r0, r1
mul_pp r4.xyz, r0, c9.z
texld r0, v2, s3
mul_pp r0.xyz, r0, r0.w
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c5
mul_pp r1.xyz, r1, c3.w
dp3_pp_sat r2.w, v4, c0
mul_pp r3.xyz, r1, r2.w
mul_pp r3.xyz, r3, c1
mad_pp r3.xyz, r3, c11.x, r4
mul_pp r4.xyz, r1, r0
mul_pp r5.xy, c4, r5
mov_pp r0.w, r1
mov_pp r0.xyz, v1
texldl r0, r0, s2
mul_pp r0.xyz, r0, r0.w
mul_pp r4.xyz, r5.x, r4
mul_pp r0.xyz, r2, r0
mad_pp r0.xyz, r0, r5.y, r4
mad_pp r1.xyz, r1, v5, r3
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 2
SetTexture 2 [_SpecCubeIBL] CUBE 3
SetTexture 3 [_DiffCubeIBL] CUBE 1
ConstBuffer "$Globals" 272
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 244 [_Shininess]
Float 248 [_Fresnel]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedpoghoadmknoppjdkhnjpcfdcmlpdjimpabaaaaaabiaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaagaaaaeaaaaaaaliabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaa
fidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
jkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
apaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaandcaabaaa
abaaaaaaagaabaiaebaaaaaaabaaaaaaagaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaaaebaaaaaaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaabkiacaiaebaaaaaa
aaaaaaaaapaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
akaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaaaebeiaaaaalpcaabaaaabaaaaaa
egbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadcaaaaajicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaidpjccdoabeaaaaaidpjkcdodiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaabaaaaaaaaaaaaaihcaabaaaacaaaaaaegbcbaaaaeaaaaaa
egiccaaaabaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaabacaaaahicaabaaa
abaaaaaaegbcbaaaafaaaaaaegacbaaaacaaaaaacpaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
abaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaabacaaaai
icaabaaaaaaaaaaaegbcbaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaaegacbaaaadaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaaaaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegbcbaaaagaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaadaaaaaaegbcbaaaadaaaaaaeghobaaaadaaaaaa
aagabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaa
adaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
diaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaa
aeaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaadaaaaaaegacbaaa
acaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [unity_Lightmap] 2D 4
"ps_3_0
; 32 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c8, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c9, 7.00000000, 8.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
mov r0.xyz, v3
dp3_sat r1.x, v2, r0
texld r0, v0, s1
add r1.y, -r1.x, c8.w
mad_pp r1.z, r1.y, c8.x, c8.x
mul_pp r1.y, r1, r1.z
add_pp r0.w, -r0, c8
mad_pp r1.x, -r0.w, r0.w, c8.w
mov_pp r4.xy, c1
mul_pp r4.xy, c3, r4
mov_pp r0.w, c8
mad_pp r1.y, r1, c8, c8.z
mad_pp r1.y, r1, c7.x, r0.w
mad_pp r0.w, -r1.x, c6.x, r1.x
mul_pp r2.x, r1.y, c5
add_pp r1.w, r0, c9.x
mov_pp r1.xyz, v1
texldl r1, r1, s2
mul_pp r0.w, r2.x, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, r1.w
mul_pp r2.xyz, r1, r0
texld r0, v2, s3
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c1.w
mul_pp r3.xyz, r1, r0
mul_pp r4.xy, r4, c2
texld r0, v4, s4
mul_pp r3.xyz, r4.x, r3
mul_pp r0.xyz, r0.w, r0
mad_pp r2.xyz, r2, r4.y, r3
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c9.y, r2
mov_pp oC0.w, c8
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 2
SetTexture 2 [_SpecCubeIBL] CUBE 3
SetTexture 3 [_DiffCubeIBL] CUBE 1
SetTexture 4 [unity_Lightmap] 2D 4
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
eefiecedigpaamkejibeijlfgcjdfemmgdcifegoabaaaaaadmagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbmafaaaa
eaaaaaaaehabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaaapaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaa
aaaaaaaibcaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dcaaaaandcaabaaaabaaaaaaagaabaiaebaaaaaaabaaaaaaagaabaaaabaaaaaa
aceaaaaaaaaaiadpaaaaaaebaaaaaaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaa
bkiacaiaebaaaaaaaaaaaaaaapaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaa
eiaaaaalpcaabaaaabaaaaaaegbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
aoaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaa
adaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaa
aeaaaaaadiaaaaaidcaabaaaadaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaa
aeaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaagaabaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaaeaaaaaa
aagabaaaaeaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
"ps_3_0
; 57 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
def c8, 8.00000000, -0.40824831, 0.70710677, 0.57735026
def c9, 0.81649655, 0.00000000, 0.57735026, 7.00000000
def c10, -0.40824828, -0.70710677, 0.57735026, 0.50000000
def c11, 0.85009766, -0.84997559, 1.00000000, 0.12500000
def c12, 0.15915494, 0.31830987, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
texld r0, v4, s5
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
mul r1.xyz, r0.y, c8.yzww
mad r1.xyz, r0.x, c9, r1
mad r1.xyz, r0.z, c10, r1
texld r0, v0, s1
dp3 r1.w, r1, r1
add_pp r2.x, -r0.w, c11.z
rsq r0.w, r1.w
mad_pp r1.w, -r2.x, r2.x, c11.z
mul r1.xyz, r0.w, r1
mad_pp r0.w, -r1, c6.x, r1
texld r2.xyz, v0, s0
mul_pp r2.xyz, r2, c4
add_pp r1.xyz, r1, v3
add_pp r2.w, r0, c9
dp3_pp r0.w, r1, r1
rsq_pp r1.x, r0.w
add_pp r1.y, -r2.w, c8.x
exp_pp r0.w, r1.y
mul_pp_sat r1.x, r1, r1.z
pow r4, r1.x, r0.w
texld r1, v2, s3
mul_pp r1.xyz, r1, r1.w
mov r3.xyz, v3
dp3_sat r1.w, v2, r3
mul_pp r2.xyz, r2, c1.w
mov_pp r3.xy, c1
mul_pp r3.xy, c3, r3
mul_pp r1.xyz, r2, r1
mul_pp r3.zw, r3.xyxy, c2.xyxy
mul_pp r3.xyz, r3.z, r1
add r1.w, -r1, c11.z
mad_pp r4.y, r1.w, c10.w, c10.w
mul_pp r1.y, r1.w, r4
mov_pp r1.x, c11.z
mad_pp r1.y, r1, c11.x, c11
mad_pp r4.y, r1, c7.x, r1.x
mov_pp r1.w, r2
mov_pp r1.xyz, v1
texldl r1, r1, s2
mul_pp r1.xyz, r1, r1.w
mul_pp r2.w, r4.y, c5.x
mul_pp r1.w, r2, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r1.w
mul_pp r1.xyz, r0, r1
mad_pp r3.xyz, r1, r3.w, r3
texld r1, v4, s4
mad r0.w, r0, c12.x, c12.y
mul_pp r1.xyz, r1.w, r1
mul_pp r1.xyz, r1, c8.x
mov r2.w, r4.x
mul_pp r0.xyz, r0, r0.w
mul r0.xyz, r2.w, r0
mul_pp r2.xyz, r1, r2
mul r0.xyz, r0, c11.w
mad_pp r0.xyz, r0, r1, r2
add_pp oC0.xyz, r0, r3
mov_pp oC0.w, c11.z
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 2
SetTexture 2 [_SpecCubeIBL] CUBE 3
SetTexture 3 [_DiffCubeIBL] CUBE 1
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
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
eefiecedkimokkdfghmigcdmpkagkacapcmijggoabaaaaaaaeajaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoeahaaaa
eaaaaaaapjabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaa
abaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaadiaaaaakhcaabaaaabaaaaaafgafbaaaaaaaaaaa
aceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaamlcaabaaaaaaaaaaa
agaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaaaaaaaaaadkmnbddpegaibaaa
abaaaaaadcaaaaamhcaabaaaaaaaaaaakgakbaaaaaaaaaaaaceaaaaaolafnblo
pdaedflpdkmnbddpaaaaaaaaegadbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egbcbaaaaeaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadicaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaaaaaaaiccaabaaaaaaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaacaaaaaadcaaaaangcaabaaaaaaaaaaafgafbaiaebaaaaaa
aaaaaaaafgafbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaebaaaaaaaa
dcaaaaalccaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaaapaaaaaabkaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaaiecaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaaaebeiaaaaalpcaabaaaacaaaaaaegbcbaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaadaaaaaabkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaabjaaaaafccaabaaaaaaaaaaa
ckaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaidpjccdo
abeaaaaaidpjkcdobjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadobacaaaahecaabaaa
aaaaaaaaegbcbaaaadaaaaaaegbcbaaaaeaaaaaaaaaaaaaiecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahecaabaaa
aaaaaaaadkaabaaaaaaaaaaackaabaaaaaaaaaaadcaaaaajecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakecaabaaa
aaaaaaaackiacaaaaaaaaaaaapaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaa
diaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaapgipcaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaaadaaaaaa
ogbkbaaaabaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaaaaaaaaadiaaaaahhcaabaaaaeaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaadaaaaaaegacbaaaaeaaaaaaefaaaaajpcaabaaaadaaaaaaegbcbaaa
adaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaa
pgapbaaaadaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaadiaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaa
adaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaaidcaabaaaadaaaaaaegaabaaa
adaaaaaaegiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaa
fgafbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [ExposureIBL]
Vector 4 [UniformOcclusion]
Vector 5 [_Color]
Float 6 [_SpecInt]
Float 7 [_Shininess]
Float 8 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"ps_3_0
; 51 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c9, 7.00000000, 8.00000000, 0.50000000, 1.00000000
def c10, 0.85009766, -0.84997559, 0.15915494, 0.31830987
def c11, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6
texld r1, v0, s1
mov r0.xyz, v3
dp3_sat r0.y, v2, r0
add_pp r0.w, -r1, c9
mad_pp r0.x, -r0.w, r0.w, c9.w
add r0.y, -r0, c9.w
mad_pp r0.z, r0.y, c9, c9
mul_pp r0.y, r0, r0.z
mad_pp r0.x, -r0, c7, r0
add_pp r1.w, r0.x, c9.x
mov_pp r5.xy, c3
mov_pp r0.x, c9.w
mad_pp r0.y, r0, c10.x, c10
mad_pp r2.x, r0.y, c8, r0
mov_pp r0.w, r1
mov_pp r0.xyz, v1
texldl r0, r0, s2
mul_pp r0.xyz, r0, r0.w
mul_pp r2.x, r2, c6
mul_pp r0.w, r2.x, c3
mul_pp r1.xyz, r1, c2
mul_pp r2.xyz, r1, r0.w
mul_pp r3.xyz, r2, r0
texld r0, v2, s3
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c5
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c3.w
mul_pp r4.xyz, r1, r0
add_pp r0.xyz, v3, c0
dp3_pp r0.w, r0, r0
rsq_pp r2.w, r0.w
add_pp r0.w, -r1, c9.y
mul_pp r0.xyz, r2.w, r0
mul_pp r5.xy, c4, r5
mul_pp r4.xyz, r5.x, r4
exp_pp r1.w, r0.w
dp3_pp_sat r2.w, v4, r0
pow r0, r2.w, r1.w
mad r0.y, r1.w, c10.z, c10.w
mul_pp r2.xyz, r2, r0.y
mul_pp r0.xyz, r0.x, c1
mul_pp r2.xyz, r0, r2
dp3_pp_sat r0.w, v4, c0
mul_pp r0.xyz, r0.w, r1
mul_pp r2.xyz, r2, c9.z
mul_pp r0.xyz, r0, c1
mad_pp r0.xyz, r0, c11.x, r2
mad_pp r3.xyz, r3, r5.y, r4
mul_pp r1.xyz, r1, v5
texldp r2.x, v6, s4
mad_pp r0.xyz, r0, r2.x, r1
add_pp oC0.xyz, r0, r3
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_SpecTex] 2D 3
SetTexture 2 [_SpecCubeIBL] CUBE 4
SetTexture 3 [_DiffCubeIBL] CUBE 2
SetTexture 4 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 308 [_Shininess]
Float 312 [_Fresnel]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefieceddfbiebigjgeamlhphaecmollcjgbleapabaaaaaaleaiaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcgeahaaaaeaaaaaaanjabaaaafjaaaaaeegiocaaa
aaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gcbaaaadhcbabaaaagaaaaaagcbaaaadlcbabaaaahaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
jkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
bdaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaabdaaaaaadiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaandcaabaaa
abaaaaaaagaabaiaebaaaaaaabaaaaaaagaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaaaebaaaaaaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaabkiacaiaebaaaaaa
aaaaaaaabdaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
akaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaaaebeiaaaaalpcaabaaaabaaaaaa
egbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaaakaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadcaaaaajicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaidpjccdoabeaaaaaidpjkcdodiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaabaaaaaaaaaaaaaihcaabaaaacaaaaaaegbcbaaaaeaaaaaa
egiccaaaabaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaabacaaaahicaabaaa
abaaaaaaegbcbaaaafaaaaaaegacbaaaacaaaaaacpaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
abaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaabacaaaai
icaabaaaaaaaaaaaegbcbaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaaegacbaaaadaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaaaaaaaaa
aoaaaaahdcaabaaaadaaaaaaegbabaaaahaaaaaapgbpbaaaahaaaaaaefaaaaaj
pcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaaaaaaaa
diaaaaahocaabaaaadaaaaaaagajbaaaacaaaaaaagbjbaaaagaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaadaaaaaajgahbaaaadaaaaaa
efaaaaajpcaabaaaadaaaaaaegbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaj
dcaabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaadcaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaadaaaaaaegacbaaaacaaaaaa
aaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [_ShadowMapTexture] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
"ps_3_0
; 37 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
def c8, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c9, 7.00000000, 8.00000000, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r1, v2, s3
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c4
mul_pp r2.xyz, r0, c1.w
mul_pp r1.xyz, r1, r1.w
mov_pp r0.xy, c1
mul_pp r3.xy, c3, r0
mul_pp r1.xyz, r2, r1
mul_pp r3.zw, r3.xyxy, c2.xyxy
mul_pp r3.xyz, r3.z, r1
mov r0.xyz, v3
dp3_sat r1.x, v2, r0
texld r0, v0, s1
add r1.x, -r1, c8.w
mad_pp r1.y, r1.x, c8.x, c8.x
mul_pp r1.y, r1.x, r1
add_pp r0.w, -r0, c8
mad_pp r0.w, -r0, r0, c8
mov_pp r1.x, c8.w
mad_pp r1.y, r1, c8, c8.z
mad_pp r1.y, r1, c7.x, r1.x
mad_pp r1.x, -r0.w, c6, r0.w
mul_pp r0.w, r1.y, c5.x
add_pp r1.w, r1.x, c9.x
mov_pp r1.xyz, v1
texldl r1, r1, s2
mul_pp r0.w, r0, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r1, r0
mad_pp r1.xyz, r0, r3.w, r3
texld r0, v4, s5
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v5, s4
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c9.y
mul_pp r0.xyz, r0, c9.z
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r2, r0, r1
mov_pp oC0.w, c8
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_SpecTex] 2D 3
SetTexture 2 [_SpecCubeIBL] CUBE 4
SetTexture 3 [_DiffCubeIBL] CUBE 2
SetTexture 4 [_ShadowMapTexture] 2D 0
SetTexture 5 [unity_Lightmap] 2D 5
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
eefiecedglfghpklfegibnbaokmgelpccaiahocbabaaaaaaeiahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbaagaaaaeaaaaaaaieabaaaa
fjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaabdaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaabdaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaa
aaaaaaaibcaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dcaaaaandcaabaaaabaaaaaaagaabaiaebaaaaaaabaaaaaaagaabaaaabaaaaaa
aceaaaaaaaaaiadpaaaaaaebaaaaaaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaa
bkiacaiaebaaaaaaaaaaaaaabdaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaa
eiaaaaalpcaabaaaabaaaaaaegbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
aeaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaa
acaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
bcaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
aiaaaaaadiaaaaaidcaabaaaadaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaa
aiaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaagaabaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaeaaaaaaaagabaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
efaaaaajpcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadiaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaa
abaaaaaafgaobaaaabaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaa
agaabaaaabaaaaaaegacbaaaadaaaaaadeaaaaahhcaabaaaabaaaaaajgahbaaa
abaaaaaaegacbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [_ShadowMapTexture] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
"ps_3_0
; 62 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
dcl_2d s6
def c8, 8.00000000, -0.40824831, 0.70710677, 0.57735026
def c9, 0.81649655, 0.00000000, 0.57735026, 7.00000000
def c10, -0.40824828, -0.70710677, 0.57735026, 0.50000000
def c11, 0.85009766, -0.84997559, 1.00000000, 0.12500000
def c12, 0.15915494, 0.31830987, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r0, v4, s6
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
mul r1.xyz, r0.y, c8.yzww
mad r1.xyz, r0.x, c9, r1
mad r0.xyz, r0.z, c10, r1
texld r3, v0, s1
dp3 r0.w, r0, r0
add_pp r1.x, -r3.w, c11.z
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r0, v3
dp3_pp r0.x, r0, r0
mad_pp r1.x, -r1, r1, c11.z
mad_pp r0.w, -r1.x, c6.x, r1.x
add_pp r3.w, r0, c9
add_pp r0.y, -r3.w, c8.x
texld r2, v2, s3
rsq_pp r0.x, r0.x
exp_pp r1.w, r0.y
mul_pp_sat r0.x, r0, r0.z
pow r4, r0.x, r1.w
texld r0.xyz, v0, s0
mul_pp r1.xyz, r0, c4
mov r0.xyz, v3
dp3_sat r0.z, v2, r0
mul_pp r2.xyz, r2, r2.w
mul_pp r1.xyz, r1, c1.w
mov_pp r0.xy, c1
mul_pp r2.xyz, r1, r2
add r2.w, -r0.z, c11.z
mul_pp r0.xy, c3, r0
mul_pp r0.zw, r0.xyxy, c2.xyxy
mul_pp r0.xyz, r0.z, r2
mad_pp r4.y, r2.w, c10.w, c10.w
mul_pp r2.y, r2.w, r4
mov_pp r2.x, c11.z
mad_pp r2.y, r2, c11.x, c11
mad_pp r4.y, r2, c7.x, r2.x
mov_pp r2.w, r3
mov_pp r2.xyz, v1
texldl r2, r2, s2
mul_pp r5.xyz, r2, r2.w
mul_pp r3.w, r4.y, c5.x
mul_pp r2.w, r3, c1
mul_pp r2.xyz, r3, c0
mul_pp r2.xyz, r2, r2.w
mul_pp r3.xyz, r2, r5
mad_pp r5.xyz, r3, r0.w, r0
mov r2.w, r4.x
texld r0, v4, s5
texldp r4.x, v5, s4
mul_pp r3.xyz, r0, r4.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
mul_pp r3.xyz, r3, c12.z
mad r0.w, r1, c12.x, c12.y
mul_pp r2.xyz, r2, r0.w
mul r2.xyz, r2.w, r2
min_pp r3.xyz, r0, r3
mul_pp r4.xyz, r0, r4.x
max_pp r3.xyz, r3, r4
mul_pp r1.xyz, r1, r3
mul r2.xyz, r2, c11.w
mad_pp r0.xyz, r2, r0, r1
add_pp oC0.xyz, r0, r5
mov_pp oC0.w, c11.z
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_SpecTex] 2D 3
SetTexture 2 [_SpecCubeIBL] CUBE 4
SetTexture 3 [_DiffCubeIBL] CUBE 2
SetTexture 4 [_ShadowMapTexture] 2D 0
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
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
eefiecedkppmhmilbphlablkemdjeoceojgkmbilabaaaaaabaakaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcniaiaaaaeaaaaaaadgacaaaa
fjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaa
abaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaadiaaaaakhcaabaaaabaaaaaafgafbaaaaaaaaaaa
aceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaamlcaabaaaaaaaaaaa
agaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaaaaaaaaaadkmnbddpegaibaaa
abaaaaaadcaaaaamhcaabaaaaaaaaaaakgakbaaaaaaaaaaaaceaaaaaolafnblo
pdaedflpdkmnbddpaaaaaaaaegadbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egbcbaaaaeaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadicaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaadaaaaaaaaaaaaaiccaabaaaaaaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaacaaaaaadcaaaaangcaabaaaaaaaaaaafgafbaiaebaaaaaa
aaaaaaaafgafbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaebaaaaaaaa
dcaaaaalccaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaabdaaaaaabkaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaaiecaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaaaebeiaaaaalpcaabaaaacaaaaaaegbcbaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaaeaaaaaabkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaabjaaaaafccaabaaaaaaaaaaa
ckaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaidpjccdo
abeaaaaaidpjkcdobjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadobacaaaahecaabaaa
aaaaaaaaegbcbaaaadaaaaaaegbcbaaaaeaaaaaaaaaaaaaiecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahecaabaaa
aaaaaaaadkaabaaaaaaaaaaackaabaaaaaaaaaaadcaaaaajecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakecaabaaa
aaaaaaaackiacaaaaaaaaaaabdaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaabdaaaaaa
diaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaa
afaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaa
eghobaaaaeaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaaakaabaaa
acaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaaabaaaaaa
eghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahocaabaaaacaaaaaapgapbaaa
aaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaa
abeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaa
aaaaaaaaddaaaaahocaabaaaacaaaaaafgaobaaaacaaaaaaagajbaaaadaaaaaa
diaaaaahhcaabaaaaeaaaaaaagaabaaaacaaaaaaegacbaaaadaaaaaadeaaaaah
hcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaaaeaaaaaaefaaaaajpcaabaaa
aeaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaai
hcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaaeaaaaaaegacbaaaaeaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaadiaaaaajdcaabaaa
adaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaai
dcaabaaaadaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaabaaaaaafgafbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
}
 }
}
SubShader { 
 LOD 250
 Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry" "RenderType"="Opaque" }
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = ((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  float tmpvar_9;
  tmpvar_9 = exp2((8.0 - ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8))));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_12;
  frag_12.w = 1.0;
  frag_12.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_12.xyz = (frag_12.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  frag_12.xyz = frag_12.xyz;
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Vector 20 [unity_Scale]
Vector 21 [_MainTex_ST]
"vs_3_0
; 49 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c20.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c22.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c15
dp4 r2.y, r0.wxyz, c14
dp4 r2.x, r0.wxyz, c13
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r2.xyz, r2, r0
mov r1.w, c22.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r1.xyz, r0, c20.w, -v0
mul r1.w, r3, r3
mad r0.y, r0.w, r0.w, -r1.w
mul r3.xyz, r0.y, c19
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r1.xyz, -r0, c22.y, -r1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c12
dp3 r1.w, r0, r0
rsq r1.w, r1.w
add o6.xyz, r2, r3
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mul o4.xyz, r1.w, r0
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r0.w
mad o1.xy, v2, c21, c21.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecednbhkgiejcgimgipchmbakbjlfkgehnnkabaaaaaajeaiaaaaadaaaaaa
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
aaklklklfdeieefcmiagaaaaeaaaabaalcabaaaafjaaaaaeegiocaaaaaaaaaaa
bbaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadiaaaaaj
hcaabaaaaaaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaa
bcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaa
aaaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegbcbaaa
acaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
aeaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaa
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
ebaaaaaaaaaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_9;
  tmpvar_9 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c_1.xyz = (diff_3.xyz * ((8.0 * tmpvar_9.w) * tmpvar_9.xyz));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_7.xyz * tmpvar_7.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_8.xyz * tmpvar_8.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c16, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c12
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c13.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r1.xyz, -r1, c16.y, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mul o4.xyz, r0.w, r0
mad o1.xy, v2, c15, c15.zwzw
mad o5.xy, v3, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
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
eefiecednhjlkmfhgjpgikhllcpllcoepfjcionoabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmiaeaaaaeaaaabaadcabaaaafjaaaaae
egiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaabaaaaaaakgiocaaaaaaaaaaabaaaaaaa
diaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaa
bbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaa
abaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
acaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaal
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaia
ebaaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaa
egbcbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaalhcaabaaaaaaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaa
aaaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaaeaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
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
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((tmpvar_7 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  float tmpvar_9;
  tmpvar_9 = exp2((8.0 - ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8))));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  vec3 tmpvar_14;
  tmpvar_14 = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_13.w) * tmpvar_13.xyz);
  c_1.xyz = ((((spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (normalize((normalize((((tmpvar_15.x * vec3(0.816497, 0.0, 0.57735)) + (tmpvar_15.y * vec3(-0.408248, 0.707107, 0.57735))) + (tmpvar_15.z * vec3(-0.408248, -0.707107, 0.57735)))) + xlv_TEXCOORD3)).z, 0.0, 1.0), tmpvar_9))) * tmpvar_14) + (diff_3.xyz * tmpvar_14));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
; 32 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c16, 1.00000000, 2.00000000, 0, 0
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
mov r1.w, c16.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c13.w, -v0
dp3 r0.y, r1, r0
dp3 r0.w, v2, -r1
dp3 r0.x, r1, v1
mov r0.z, -r0.w
mul r2.xyz, v2, r0.w
mad r1.xyz, -r2, c16.y, -r1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul o4.xyz, r0.w, r0
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mad o1.xy, v3, c15, c15.zwzw
mad o5.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v2, c6
dp3 o3.y, v2, c5
dp3 o3.x, v2, c4
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
eefiecedhbcnnkbaafaobgoijnfdcaogcembfcnnabaaaaaaiaagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmmaeaaaaeaaaabaaddabaaaafjaaaaae
egiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacadaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabaaaaaaa
kgiocaaaaaaaaaaabaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
acaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
acaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaaegbcbaaaacaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaalhcaabaaaabaaaaaaegbcbaaa
acaaaaaapgapbaiaebaaaaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaa
acaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
abaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaabaaaaaabaaaaaah
ccaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhccabaaaaeaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  vec3 x2_9;
  vec3 x1_10;
  x1_10.x = dot (unity_SHAr, tmpvar_8);
  x1_10.y = dot (unity_SHAg, tmpvar_8);
  x1_10.z = dot (unity_SHAb, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  vec4 o_12;
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_1 * 0.5);
  vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_13.x;
  tmpvar_14.y = (tmpvar_13.y * _ProjectionParams.x);
  o_12.xy = (tmpvar_14 + tmpvar_13.w);
  o_12.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = ((x1_10 + x2_9) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
  xlv_TEXCOORD6 = o_12;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  float tmpvar_9;
  tmpvar_9 = exp2((8.0 - ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8))));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_12;
  frag_12.w = 1.0;
  frag_12.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_12.xyz = (frag_12.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  frag_12.xyz = (frag_12.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x);
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [unity_Scale]
Vector 23 [_MainTex_ST]
"vs_3_0
; 54 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c24, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c22.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c24.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c17
dp4 r2.y, r0.wxyz, c16
dp4 r2.x, r0.wxyz, c15
dp4 r0.z, r1, c20
dp4 r0.x, r1, c18
dp4 r0.y, r1, c19
add r2.xyz, r2, r0
mov r1.w, c24.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r1.xyz, r0, c22.w, -v0
mul r0.y, r3.w, r3.w
mad r1.w, r0, r0, -r0.y
mul r3.xyz, r1.w, c21
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c24.y, -r1
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
add o6.xyz, r2, r3
mul r2.xyz, r1.xyww, c24.z
mul r2.y, r2, c13.x
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c12
mad o7.xy, r2.z, c14.zwzw, r2
dp3 r2.x, r0, r0
rsq r2.x, r2.x
mov o0, r1
mul o4.xyz, r2.x, r0
mov o7.zw, r1
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r0.w
mad o1.xy, v2, c23, c23.zwzw
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedmflengamceeedagnnfelahfchaheeondabaaaaaaeeajaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
gaahaaaaeaaaabaaniabaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacafaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabeaaaaaaogikcaaaaaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaai
icaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegbcbaaaacaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaaeaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
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
dcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaahaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaahaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec4 o_6;
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_1 * 0.5);
  vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_6;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  c_1.xyz = (diff_3.xyz * max (min (tmpvar_11, ((tmpvar_9.x * 2.0) * tmpvar_10.xyz)), (tmpvar_11 * tmpvar_9.x)));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_7.xyz * tmpvar_7.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_8.xyz * tmpvar_8.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
; 33 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c18, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.w, c18.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c15.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r1.xyz, -r1, c18.y, -r0
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.z
mul r2.y, r2, c13.x
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
add r1.xyz, -r1, c12
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mad o6.xy, r2.z, c14.zwzw, r2
mov o0, r0
mul o4.xyz, r1.w, r1
mov o6.zw, r0
mad o1.xy, v2, c17, c17.zwzw
mad o5.xy, v3, c16, c16.zwzw
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
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
eefiecednlhhhhnpjmbnibiminocpjflcebpmbdiabaaaaaacmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgaafaaaaeaaaabaafiabaaaafjaaaaaeegiocaaaaaaaaaaa
bgaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabfaaaaaa
ogikcaaaaaaaaaaabfaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaaeaaaaaa
agiecaaaaaaaaaaabeaaaaaakgiocaaaaaaaaaaabeaaaaaadiaaaaajhcaabaaa
abaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaa
kgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaa
egacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaa
baaaaaaiicaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegbcbaaaacaaaaaa
aaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaia
ebaaaaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajhcaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaaeaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
afaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
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
  vec4 o_10;
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_1 * 0.5);
  vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((tmpvar_8 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz)));
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_10;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
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
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  xlat_mutableExposureIBL.xy = (xlat_mutableExposureIBL.xy * ExposureLM);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  float tmpvar_9;
  tmpvar_9 = exp2((8.0 - ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8))));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_LightmapInd, xlv_TEXCOORD4);
  vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_13.w) * tmpvar_13.xyz);
  vec3 tmpvar_16;
  tmpvar_16 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  c_1.xyz = ((((spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831)) * (0.125 * pow (clamp (normalize((normalize((((tmpvar_16.x * vec3(0.816497, 0.0, 0.57735)) + (tmpvar_16.y * vec3(-0.408248, 0.707107, 0.57735))) + (tmpvar_16.z * vec3(-0.408248, -0.707107, 0.57735)))) + xlv_TEXCOORD3)).z, 0.0, 1.0), tmpvar_9))) * tmpvar_15) + (diff_3.xyz * max (min (tmpvar_15, ((tmpvar_12.x * 2.0) * tmpvar_13.xyz)), (tmpvar_15 * tmpvar_12.x))));
  c_1.w = 1.0;
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c18, 1.00000000, 2.00000000, 0.50000000, 0
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
mov r1.w, c18.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r1.xyz, r2, c15.w, -v0
dp3 r0.y, r1, r0
dp3 r0.w, v2, -r1
mul r2.xyz, v2, r0.w
mad r2.xyz, -r2, c18.y, -r1
dp3 r0.x, r1, v1
mov r0.z, -r0.w
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul o4.xyz, r0.w, r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.z
mul r1.y, r1, c13.x
dp3 o2.z, r2, c6
dp3 o2.y, r2, c5
dp3 o2.x, r2, c4
mad o6.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o5.xy, v4, c16, c16.zwzw
dp3 o3.z, v2, c6
dp3 o3.y, v2, c5
dp3 o3.x, v2, c4
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
eefiecedpoeodhbfhicglnockfdeidigflfeekbjabaaaaaadaahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgeafaaaaeaaaabaafjabaaaafjaaaaaeegiocaaaaaaaaaaa
bgaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaabfaaaaaaogikcaaaaaaaaaaabfaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaabeaaaaaakgiocaaaaaaaaaaa
beaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
acaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaa
dcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaaiicaabaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaaegbcbaaaacaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaaaabaaaaaadcaaaaalhcaabaaaacaaaaaaegbcbaaaacaaaaaapgapbaia
ebaaaaaaabaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaaihcaabaaaadaaaaaa
fgafbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaa
acaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
jgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaajgbebaaa
acaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaacaaaaaaegbcbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaacaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhccabaaa
aeaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_12;
  tmpvar_12 = (unity_4LightPosX0 - tmpvar_11.x);
  vec4 tmpvar_13;
  tmpvar_13 = (unity_4LightPosY0 - tmpvar_11.y);
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosZ0 - tmpvar_11.z);
  vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_12 * tmpvar_12) + (tmpvar_13 * tmpvar_13)) + (tmpvar_14 * tmpvar_14));
  vec4 tmpvar_16;
  tmpvar_16 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_12 * tmpvar_6.x) + (tmpvar_13 * tmpvar_6.y)) + (tmpvar_14 * tmpvar_6.z)) * inversesqrt(tmpvar_15))) * (1.0/((1.0 + (tmpvar_15 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y)))) + ((((unity_LightColor[0].xyz * tmpvar_16.x) + (unity_LightColor[1].xyz * tmpvar_16.y)) + (unity_LightColor[2].xyz * tmpvar_16.z)) + (unity_LightColor[3].xyz * tmpvar_16.w)));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  float tmpvar_9;
  tmpvar_9 = exp2((8.0 - ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8))));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_12;
  frag_12.w = 1.0;
  frag_12.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_12.xyz = (frag_12.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  frag_12.xyz = frag_12.xyz;
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [unity_4LightPosX0]
Vector 14 [unity_4LightPosY0]
Vector 15 [unity_4LightPosZ0]
Vector 16 [unity_4LightAtten0]
Vector 17 [unity_LightColor0]
Vector 18 [unity_LightColor1]
Vector 19 [unity_LightColor2]
Vector 20 [unity_LightColor3]
Vector 21 [unity_SHAr]
Vector 22 [unity_SHAg]
Vector 23 [unity_SHAb]
Vector 24 [unity_SHBr]
Vector 25 [unity_SHBg]
Vector 26 [unity_SHBb]
Vector 27 [unity_SHC]
Vector 28 [unity_Scale]
Vector 29 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c30, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c28.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c14
dp3 r4.z, r3, c5
dp3 r3.z, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c13
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.y, r4.z
mov r5.z, r3
mov r5.w, c30.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c15
mad r2, r1, r1, r2
mad r0, r3.z, r1, r0
mul r1, r2, c16
add r1, r1, c30.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c23
dp4 r2.y, r5, c22
dp4 r2.x, r5, c21
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c30.z
mul r0, r0, r1
mul r1.xyz, r0.y, c18
mad r1.xyz, r0.x, c17, r1
mad r0.xyz, r0.z, c19, r1
mad r1.xyz, r0.w, c20, r0
mul r0, r5.xyzz, r5.yzzx
dp4 r5.w, r0, c26
dp4 r5.z, r0, c25
dp4 r5.y, r0, c24
mul r0.x, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0.x
add r2.xyz, r2, r5.yzww
mov r0.w, c30.x
mov r0.xyz, c12
dp4 r5.w, r0, c10
dp4 r5.y, r0, c8
dp4 r5.z, r0, c9
mad r0.xyz, r5.yzww, c28.w, -v0
mul r5.yzw, r1.w, c27.xxyz
add r5.yzw, r2.xxyz, r5
dp3 r0.w, v1, -r0
mul r2.xyz, v1, r0.w
mad r0.xyz, -r2, c30.y, -r0
add o6.xyz, r5.yzww, r1
mov r3.x, r4.w
mov r3.y, r4
add r1.xyz, -r3.wxyw, c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
mul o4.xyz, r0.w, r1
mov o5.z, r3
mov o5.y, r4.z
mov o5.x, r5
mad o1.xy, v2, c29, c29.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 272
Vector 256 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecednokdacefjkpkcedccfcjijllbcabodhkabaaaaaaemalaaaaadaaaaaa
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
aaklklklfdeieefciaajaaaaeaaaabaagaacaaaafjaaaaaeegiocaaaaaaaaaaa
bbaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaabaaaaaaadiaaaaaj
hcaabaaaaaaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaa
aeaaaaaaegacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaadaaaaaa
bcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaa
aaaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegbcbaaa
acaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaa
aeaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaa
abaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaa
abaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaa
egakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
aeaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaia
ebaaaaaaaaaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaia
ebaaaaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaa
fgafbaaaabaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaaaaaaaaaakgakbaia
ebaaaaaaaaaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaafaaaaaaagaabaaaabaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
adaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaaj
pcaabaaaadaaaaaaegaobaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaa
dcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaakgakbaaaabaaaaaaegaobaaa
aeaaaaaaeeaaaaafpcaabaaaabaaaaaaegaobaaaadaaaaaadcaaaaanpcaabaaa
adaaaaaaegaobaaaadaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaahpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaabaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaa
aaaaaaaaegaobaaaadaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaagaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  vec3 x2_9;
  vec3 x1_10;
  x1_10.x = dot (unity_SHAr, tmpvar_8);
  x1_10.y = dot (unity_SHAg, tmpvar_8);
  x1_10.z = dot (unity_SHAb, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  vec3 tmpvar_12;
  tmpvar_12 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_13;
  tmpvar_13 = (unity_4LightPosX0 - tmpvar_12.x);
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosY0 - tmpvar_12.y);
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosZ0 - tmpvar_12.z);
  vec4 tmpvar_16;
  tmpvar_16 = (((tmpvar_13 * tmpvar_13) + (tmpvar_14 * tmpvar_14)) + (tmpvar_15 * tmpvar_15));
  vec4 tmpvar_17;
  tmpvar_17 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_13 * tmpvar_7.x) + (tmpvar_14 * tmpvar_7.y)) + (tmpvar_15 * tmpvar_7.z)) * inversesqrt(tmpvar_16))) * (1.0/((1.0 + (tmpvar_16 * unity_4LightAtten0)))));
  vec4 o_18;
  vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_1 * 0.5);
  vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_18.xy = (tmpvar_20 + tmpvar_19.w);
  o_18.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = (((x1_10 + x2_9) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y)))) + ((((unity_LightColor[0].xyz * tmpvar_17.x) + (unity_LightColor[1].xyz * tmpvar_17.y)) + (unity_LightColor[2].xyz * tmpvar_17.z)) + (unity_LightColor[3].xyz * tmpvar_17.w)));
  xlv_TEXCOORD6 = o_18;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
vec4 xlat_mutableExposureIBL;
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
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  xlat_mutableExposureIBL.zw = ExposureIBL.zw;
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  xlat_mutableExposureIBL.xy = (ExposureIBL.xy * UniformOcclusion);
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * _SpecColor.xyz);
  spec_2.xyz = (spec_2.xyz * ((_SpecInt * mix (1.0, (0.15 + ((tmpvar_6 * (0.5 + (0.5 * tmpvar_6))) * 0.85)), _Fresnel)) * ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = (1.0 - tmpvar_5.w);
  float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  float tmpvar_9;
  tmpvar_9 = exp2((8.0 - ((7.0 + tmpvar_8) - (_Shininess * tmpvar_8))));
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_SpecCubeIBL, xlv_TEXCOORD1);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 frag_12;
  frag_12.w = 1.0;
  frag_12.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0)) * diff_3.xyz) * _LightColor0.xyz);
  frag_12.xyz = (frag_12.xyz + ((0.5 * (vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((xlv_TEXCOORD3 + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * _LightColor0.xyz)) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  frag_12.xyz = (frag_12.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x);
  c_1.w = frag_12.w;
  c_1.xyz = (frag_12.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * tmpvar_5.w) * spec_2.xyz) * xlat_mutableExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_3.xyz) * xlat_mutableExposureIBL.x)));
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
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Vector 30 [unity_Scale]
Vector 31 [_MainTex_ST]
"vs_3_0
; 84 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c32, 1.00000000, 2.00000000, 0.00000000, 0.50000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c30.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c16
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c15
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c32.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c17
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c18
add r1, r1, c32.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c25
dp4 r2.y, r5, c24
dp4 r2.x, r5, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c32.z
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c22, r0
dp4 r3.z, r1, c28
dp4 r3.x, r1, c26
dp4 r3.y, r1, c27
add r3.xyz, r2, r3
mov r1.w, c32.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c30.w, -v0
dp3 r0.w, v1, -r1
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c32.y, -r1
mul r5.yzw, r1.w, c29.xxyz
add r3.xyz, r3, r5.yzww
add o6.xyz, r3, r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c32.w
dp3 o2.x, r1, c4
mov r1.x, r2
mul r1.y, r2, c13.x
mov r3.x, r4.w
mov r3.y, r4
add r3.xyz, -r3.wxyw, c12
mad o7.xy, r2.z, c14.zwzw, r1
dp3 r1.x, r3, r3
rsq r1.x, r1.x
mov o0, r0
mul o4.xyz, r1.x, r3
mov o7.zw, r0
mov o5.z, r4.x
mov o5.y, r4.z
mov o5.x, r5
mad o1.xy, v2, c31, c31.zwzw
dp3 o3.z, v1, c6
dp3 o3.y, v1, c5
dp3 o3.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 336
Vector 320 [_MainTex_ST]
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
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
eefiecedbjhoclafakmeaoblhmdfgbmlloadkcoaabaaaaaapmalaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
biakaaaaeaaaabaaigacaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacahaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaabeaaaaaaogikcaaaaaaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaai
icaabaaaabaaaaaaegacbaiaebaaaaaaabaaaaaaegbcbaaaacaaaaaaaaaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegbcbaaaacaaaaaapgapbaiaebaaaaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhccabaaaaeaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaaacaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaacaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaaacaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaa
acaaaaaadiaaaaahpcaabaaaaeaaaaaajgacbaaaacaaaaaaegakbaaaacaaaaaa
bbaaaaaibcaabaaaafaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaaeaaaaaa
bbaaaaaiccaabaaaafaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaaeaaaaaa
bbaaaaaiecaabaaaafaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaaeaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaafaaaaaadiaaaaah
icaabaaaabaaaaaabkaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaadkaabaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaabaaaaaa
egiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaacaaaaaa
egaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaa
aeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaabaaaaaaegiocaaa
acaaaaaaacaaaaaaaaaaaaajpcaabaaaabaaaaaakgakbaiaebaaaaaaabaaaaaa
egiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaa
agaabaaaacaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaafaaaaaaeeaaaaaf
pcaabaaaacaaaaaaegaobaaaaeaaaaaadcaaaaanpcaabaaaaeaaaaaaegaobaaa
aeaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaaeaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaacaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
aeaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
agaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaahhccabaaaagaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaahaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaahaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [ExposureIBL]
Vector 4 [UniformOcclusion]
Vector 5 [_Color]
Float 6 [_SpecInt]
Float 7 [_Shininess]
Float 8 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
"ps_3_0
; 48 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
def c9, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c10, 0.15915494, 0.31830987, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r1, v0, s1
add_pp r0.xyz, v3, c0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mov_pp r5.xy, c3
mul_pp r0.xyz, r0.w, r0
add_pp r2.x, -r1.w, c9.w
mad_pp r0.w, -r2.x, r2.x, c9
dp3_pp_sat r2.x, v4, r0
mov r0.xyz, v3
dp3_sat r0.x, v2, r0
mad_pp r0.w, -r0, c7.x, r0
add_pp r0.w, -r0, c9
exp_pp r2.y, r0.w
add r2.z, -r0.x, c9.w
pow r0, r2.x, r2.y
mad_pp r0.y, r2.z, c9.x, c9.x
mul_pp r0.z, r2, r0.y
mad_pp r0.z, r0, c9.y, c9
mov_pp r0.y, c9.w
mad_pp r0.y, r0.z, c8.x, r0
mul_pp r0.y, r0, c6.x
mad r0.z, r2.y, c10.x, c10.y
mul_pp r0.y, r0, c3.w
mul_pp r1.xyz, r1, c2
mul_pp r2.xyz, r1, r0.y
mul_pp r1.xyz, r2, r0.z
mul_pp r0.xyz, r0.x, c1
mul_pp r1.xyz, r0, r1
texld r0.xyz, v0, s0
mul_pp r4.xyz, r1, c9.x
mul_pp r0.xyz, r0, c5
mul_pp r1.xyz, r0, c3.w
dp3_pp_sat r0.w, v4, c0
mul_pp r3.xyz, r1, r0.w
mul_pp r3.xyz, r3, c1
texld r0, v2, s3
mad_pp r3.xyz, r3, c10.z, r4
mul_pp r4.xyz, r0, r0.w
mul_pp r4.xyz, r1, r4
mul_pp r5.xy, c4, r5
texld r0, v1, s2
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r1.w, r0
mul_pp r4.xyz, r5.x, r4
mul_pp r0.xyz, r2, r0
mad_pp r0.xyz, r0, r5.y, r4
mad_pp r1.xyz, r1, v5, r3
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 2
SetTexture 2 [_SpecCubeIBL] CUBE 3
SetTexture 3 [_DiffCubeIBL] CUBE 1
ConstBuffer "$Globals" 272
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 48 [ExposureIBL]
Vector 72 [UniformOcclusion] 2
Vector 224 [_Color]
Float 240 [_SpecInt]
Float 244 [_Shininess]
Float 248 [_Fresnel]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedmiddnhiekabjaaobbjngoblldojeeiopabaaaaaacmaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcpeagaaaaeaaaaaaalnabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaa
fidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
jkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
apaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaandcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaapgapbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaeb
aaaaaaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
apaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaaaebbjaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
idpjccdoabeaaaaaidpjkcdodiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
agaabaaaabaaaaaaaaaaaaaihcaabaaaacaaaaaaegbcbaaaaeaaaaaaegiccaaa
abaaaaaaaaaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaabacaaaahbcaabaaaacaaaaaa
egbcbaaaafaaaaaaegacbaaaacaaaaaacpaaaaafbcaabaaaacaaaaaaakaabaaa
acaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaacaaaaaa
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaakhcaabaaaabaaaaaaegacbaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaabacaaaaiicaabaaa
aaaaaaaaegbcbaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
adaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaadaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaabaaaaaadcaaaaaj
hcaabaaaabaaaaaaegacbaaaacaaaaaaegbcbaaaagaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaadaaaaaaegbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaa
adaaaaaaegbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadiaaaaajdcaabaaaadaaaaaa
egiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [unity_Lightmap] 2D 4
"ps_3_0
; 28 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c7, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c8, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
mov r0.xyz, v3
dp3_sat r0.x, v2, r0
add r1.x, -r0, c7.w
mad_pp r1.y, r1.x, c7.x, c7.x
mul_pp r1.y, r1.x, r1
mov_pp r4.xy, c1
mul_pp r4.xy, c3, r4
texld r0, v1, s2
mov_pp r1.x, c7.w
mad_pp r1.y, r1, c7, c7.z
mad_pp r1.w, r1.y, c6.x, r1.x
mul_pp r1.xyz, r0, r0.w
texld r0, v0, s1
mul_pp r1.w, r1, c5.x
mul_pp r1.xyz, r1, r0.w
mul_pp r4.xy, r4, c2
mul_pp r1.w, r1, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r1.w
mul_pp r2.xyz, r1, r0
texld r0, v2, s3
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c1.w
mul_pp r3.xyz, r1, r0
texld r0, v4, s4
mul_pp r3.xyz, r4.x, r3
mul_pp r0.xyz, r0.w, r0
mad_pp r2.xyz, r2, r4.y, r3
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c8.x, r2
mov_pp oC0.w, c7
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 2
SetTexture 2 [_SpecCubeIBL] CUBE 3
SetTexture 3 [_DiffCubeIBL] CUBE 1
SetTexture 4 [unity_Lightmap] 2D 4
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
eefiecedfafeifdnhfagmdalhlefdddjhfllacbmabaaaaaanaafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefclaaeaaaa
eaaaaaaacmabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaaapaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajdcaabaaaadaaaaaa
egiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaaaeaaaaaadiaaaaaidcaabaaa
adaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
"ps_3_0
; 55 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
def c8, 8.00000000, -0.40824831, 0.70710677, 0.57735026
def c9, 0.81649655, 0.00000000, 0.57735026, 0.50000000
def c10, -0.40824828, -0.70710677, 0.57735026, 1.00000000
def c11, 0.85009766, -0.84997559, 0.15915494, 0.31830987
def c12, 0.12500000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
texld r0, v4, s5
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
mul r1.xyz, r0.y, c8.yzww
mad r1.xyz, r0.x, c9, r1
mad r1.xyz, r0.z, c10, r1
texld r0, v0, s1
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
add_pp r1.xyz, r1, v3
dp3_pp r1.x, r1, r1
add_pp r2.x, -r0.w, c10.w
mad_pp r1.w, -r2.x, r2.x, c10
mad_pp r1.w, -r1, c6.x, r1
add_pp r1.y, -r1.w, c10.w
rsq_pp r1.x, r1.x
texld r2.xyz, v0, s0
mul_pp r2.xyz, r2, c4
exp_pp r2.w, r1.y
mul_pp_sat r1.x, r1, r1.z
pow r4, r1.x, r2.w
texld r1, v2, s3
mul_pp r1.xyz, r1, r1.w
mul_pp r2.xyz, r2, c1.w
mul_pp r3.xyz, r2, r1
mov r1.xyz, v3
dp3_sat r1.z, v2, r1
add r3.w, -r1.z, c10
mov_pp r4.zw, c1.xyxy
mul_pp r1.xy, c3, r4.zwzw
mul_pp r4.zw, r1.xyxy, c2.xyxy
mad_pp r4.y, r3.w, c9.w, c9.w
mul_pp r4.y, r3.w, r4
texld r1, v1, s2
mul_pp r1.xyz, r1, r1.w
mul_pp r1.xyz, r0.w, r1
mul_pp r3.xyz, r4.z, r3
mov_pp r3.w, c10
mad_pp r4.y, r4, c11.x, c11
mad_pp r3.w, r4.y, c7.x, r3
mul_pp r1.w, r3, c5.x
mul_pp r0.w, r1, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r0, r1
mad_pp r3.xyz, r1, r4.w, r3
texld r1, v4, s4
mad r2.w, r2, c11.z, c11
mul_pp r1.xyz, r1.w, r1
mul_pp r1.xyz, r1, c8.x
mov r0.w, r4.x
mul_pp r0.xyz, r0, r2.w
mul r0.xyz, r0.w, r0
mul_pp r2.xyz, r1, r2
mul r0.xyz, r0, c12.x
mad_pp r0.xyz, r0, r1, r2
add_pp oC0.xyz, r0, r3
mov_pp oC0.w, c10
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 2
SetTexture 2 [_SpecCubeIBL] CUBE 3
SetTexture 3 [_DiffCubeIBL] CUBE 1
SetTexture 4 [unity_Lightmap] 2D 4
SetTexture 5 [unity_LightmapInd] 2D 5
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
eefiecedinnoofhmifoepdnlcekgfjkigcbejoehabaaaaaabiajaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcpiahaaaa
eaaaaaaapoabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaa
abaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaadiaaaaakhcaabaaaabaaaaaafgafbaaaaaaaaaaa
aceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaamlcaabaaaaaaaaaaa
agaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaaaaaaaaaadkmnbddpegaibaaa
abaaaaaadcaaaaamhcaabaaaaaaaaaaakgakbaaaaaaaaaaaaceaaaaaolafnblo
pdaedflpdkmnbddpaaaaaaaaegadbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egbcbaaaaeaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadicaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaaaaaaaiccaabaaaaaaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdcaaaaangcaabaaaaaaaaaaafgafbaiaebaaaaaa
aaaaaaaafgafbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaebaaaaaaaa
dcaaaaalccaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaaapaaaaaabkaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaaiccaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaaaebbjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaaj
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaidpjccdoabeaaaaaidpjkcdo
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaadobacaaaahecaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaaeaaaaaaaaaaaaaiecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahecaabaaaaaaaaaaadkaabaaa
aaaaaaaackaabaaaaaaaaaaadcaaaaajecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakecaabaaaaaaaaaaackiacaaa
aaaaaaaaapaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaaapaaaaaadiaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaadiaaaaahhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaahocaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaa
acaaaaaapgipcaaaaaaaaaaaadaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaa
abaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgapbaaaaaaaaaaadiaaaaahhcaabaaaaeaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaaeaaaaaaefaaaaajpcaabaaaadaaaaaaegbcbaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaadaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaa
adaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
adaaaaaaefaaaaajpcaabaaaadaaaaaaegbcbaaaadaaaaaaeghobaaaadaaaaaa
aagabaaaabaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaa
adaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
diaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaaadaaaaaaogikcaaaaaaaaaaa
aeaaaaaadiaaaaaidcaabaaaadaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaa
aeaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaagaabaaaadaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaadaaaaaaegacbaaa
acaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [ExposureIBL]
Vector 4 [UniformOcclusion]
Vector 5 [_Color]
Float 6 [_SpecInt]
Float 7 [_Shininess]
Float 8 [_Fresnel]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"ps_3_0
; 49 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c9, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c10, 0.15915494, 0.31830987, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6
mov r0.xyz, v3
dp3_sat r0.x, v2, r0
add r0.x, -r0, c9.w
mad_pp r0.y, r0.x, c9.x, c9.x
mul_pp r0.y, r0.x, r0
mov_pp r4.xy, c3
mul_pp r4.zw, c4.xyxy, r4.xyxy
mov_pp r0.x, c9.w
mad_pp r0.y, r0, c9, c9.z
mad_pp r1.x, r0.y, c8, r0
mul_pp r2.x, r1, c6
texld r1, v0, s1
texld r0, v1, s2
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r1.w, r0
mul_pp r0.w, r2.x, c3
mul_pp r1.xyz, r1, c2
mul_pp r2.xyz, r1, r0.w
mul_pp r3.xyz, r2, r0
texld r0, v2, s3
mul_pp r0.xyz, r0, r0.w
add_pp r0.w, -r1, c9
mad_pp r1.w, -r0, r0, c9
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c5
mul_pp r1.xyz, r1, c3.w
mul_pp r0.xyz, r1, r0
mul_pp r4.xyz, r4.z, r0
add_pp r0.xyz, v3, c0
dp3_pp r0.w, r0, r0
mad_pp r2.w, -r1, c7.x, r1
rsq_pp r1.w, r0.w
add_pp r0.w, -r2, c9
mul_pp r0.xyz, r1.w, r0
exp_pp r1.w, r0.w
dp3_pp_sat r2.w, v4, r0
pow r0, r2.w, r1.w
mad r0.y, r1.w, c10.x, c10
mul_pp r2.xyz, r2, r0.y
mul_pp r0.xyz, r0.x, c1
mul_pp r2.xyz, r0, r2
dp3_pp_sat r0.w, v4, c0
mul_pp r0.xyz, r0.w, r1
mul_pp r2.xyz, r2, c9.x
mul_pp r0.xyz, r0, c1
mad_pp r0.xyz, r0, c10.z, r2
mad_pp r3.xyz, r3, r4.w, r4
mul_pp r1.xyz, r1, v5
texldp r2.x, v6, s4
mad_pp r0.xyz, r0, r2.x, r1
add_pp oC0.xyz, r0, r3
mov_pp oC0.w, c9
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_SpecTex] 2D 3
SetTexture 2 [_SpecCubeIBL] CUBE 4
SetTexture 3 [_DiffCubeIBL] CUBE 2
SetTexture 4 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 336
Vector 16 [_LightColor0]
Vector 32 [_SpecColor]
Vector 112 [ExposureIBL]
Vector 136 [UniformOcclusion] 2
Vector 288 [_Color]
Float 304 [_SpecInt]
Float 308 [_Shininess]
Float 312 [_Fresnel]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedpjjgcafokkigfbfjfhhianaadoimllnmabaaaaaamiaiaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefchiahaaaaeaaaaaaanoabaaaafjaaaaaeegiocaaa
aaaaaaaabeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaa
ffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gcbaaaadhcbabaaaagaaaaaagcbaaaadlcbabaaaahaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
jkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
bdaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaabdaaaaaadiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdcaaaaandcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaapgapbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaeb
aaaaaaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
bdaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaaaebbjaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaajbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
idpjccdoabeaaaaaidpjkcdodiaaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
agaabaaaabaaaaaaaaaaaaaihcaabaaaacaaaaaaegbcbaaaaeaaaaaaegiccaaa
abaaaaaaaaaaaaaabaaaaaahicaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaaeeaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaabacaaaahbcaabaaaacaaaaaa
egbcbaaaafaaaaaaegacbaaaacaaaaaacpaaaaafbcaabaaaacaaaaaaakaabaaa
acaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaacaaaaaa
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaakhcaabaaaabaaaaaaegacbaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaabacaaaaiicaabaaa
aaaaaaaaegbcbaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
adaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaadaaaaaaegiccaaaaaaaaaaaabaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaadaaaaaaegbabaaaahaaaaaapgbpbaaaahaaaaaaefaaaaajpcaabaaa
adaaaaaaegaabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaaaaaaaadiaaaaah
ocaabaaaadaaaaaaagajbaaaacaaaaaaagbjbaaaagaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaabaaaaaaagaabaaaadaaaaaajgahbaaaadaaaaaaefaaaaaj
pcaabaaaadaaaaaaegbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaadaaaaaa
egbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaa
adaaaaaapgapbaaaadaaaaaaegacbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaadaaaaaadiaaaaajdcaabaaaadaaaaaaegiacaaa
aaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaafgafbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [_ShadowMapTexture] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
"ps_3_0
; 33 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
def c7, 0.50000000, 0.85009766, -0.84997559, 1.00000000
def c8, 8.00000000, 2.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r0, v2, s3
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r0.xyz, r0, r0.w
mov r2.xyz, v3
dp3_sat r0.w, v2, r2
mul_pp r1.xyz, r1, c1.w
mov_pp r3.xy, c1
mul_pp r2.xy, c3, r3
mul_pp r2.zw, r2.xyxy, c2.xyxy
add r1.w, -r0, c7
mul_pp r0.xyz, r1, r0
mul_pp r3.xyz, r2.z, r0
mad_pp r2.x, r1.w, c7, c7
mul_pp r2.x, r1.w, r2
texld r0, v1, s2
mad_pp r2.x, r2, c7.y, c7.z
mov_pp r1.w, c7
mad_pp r1.w, r2.x, c6.x, r1
mul_pp r2.xyz, r0, r0.w
texld r0, v0, s1
mul_pp r1.w, r1, c5.x
mul_pp r2.xyz, r2, r0.w
texldp r4.x, v5, s4
mul_pp r1.w, r1, c1
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r1.w
mul_pp r0.xyz, r2, r0
mad_pp r2.xyz, r0, r2.w, r3
texld r0, v4, s5
mul_pp r3.xyz, r0.w, r0
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c8.x
mul_pp r0.xyz, r0, c8.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r1, r0, r2
mov_pp oC0.w, c7
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_SpecTex] 2D 3
SetTexture 2 [_SpecCubeIBL] CUBE 4
SetTexture 3 [_DiffCubeIBL] CUBE 2
SetTexture 4 [_ShadowMapTexture] 2D 0
SetTexture 5 [unity_Lightmap] 2D 5
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
eefiecedojahdkikddjkcbconllpiaapknhomlbaabaaaaaanmagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckeafaaaaeaaaaaaagjabaaaa
fjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaabacaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaaeaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaajbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaabdaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaabdaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaacaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbcbaaaadaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajdcaabaaaadaaaaaa
egiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaaidcaabaaa
adaaaaaaegaabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaafgafbaaaadaaaaaaegacbaaaabaaaaaaaoaaaaahdcaabaaa
abaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaaeaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaaefaaaaajpcaabaaaadaaaaaa
ogbkbaaaabaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahocaabaaa
abaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaabaaaaaafgaobaaaabaaaaaa
agajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaabaaaaaaegacbaaa
adaaaaaadeaaaaahhcaabaaaabaaaaaajgahbaaaabaaaaaaegacbaaaadaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
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
SetTexture 1 [_SpecTex] 2D 1
SetTexture 2 [_SpecCubeIBL] CUBE 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
SetTexture 4 [_ShadowMapTexture] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
"ps_3_0
; 60 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
dcl_2d s6
def c8, 8.00000000, -0.40824831, 0.70710677, 0.57735026
def c9, 0.81649655, 0.00000000, 0.57735026, 0.50000000
def c10, -0.40824828, -0.70710677, 0.57735026, 1.00000000
def c11, 0.85009766, -0.84997559, 0.15915494, 0.31830987
def c12, 0.12500000, 2.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r0, v4, s6
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
mul r1.xyz, r0.y, c8.yzww
mad r1.xyz, r0.x, c9, r1
mad r1.xyz, r0.z, c10, r1
texld r0, v0, s1
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
add_pp r1.xyz, r1, v3
dp3_pp r1.x, r1, r1
add_pp r2.x, -r0.w, c10.w
mad_pp r1.w, -r2.x, r2.x, c10
mad_pp r1.w, -r1, c6.x, r1
add_pp r1.y, -r1.w, c10.w
texld r2, v2, s3
rsq_pp r1.x, r1.x
exp_pp r1.w, r1.y
mul_pp_sat r1.x, r1, r1.z
pow r4, r1.x, r1.w
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r2.xyz, r2, r2.w
mov r3.xyz, v3
dp3_sat r2.w, v2, r3
mul_pp r1.xyz, r1, c1.w
mov_pp r4.zw, c1.xyxy
mul_pp r3.xy, c3, r4.zwzw
add r4.y, -r2.w, c10.w
mad_pp r4.z, r4.y, c9.w, c9.w
mul_pp r4.z, r4.y, r4
mul_pp r2.xyz, r1, r2
mul_pp r3.zw, r3.xyxy, c2.xyxy
mul_pp r3.xyz, r3.z, r2
texld r2, v1, s2
mul_pp r2.xyz, r2, r2.w
mul_pp r5.xyz, r0.w, r2
mad_pp r4.z, r4, c11.x, c11.y
mov_pp r4.y, c10.w
mad_pp r4.y, r4.z, c7.x, r4
mul_pp r2.w, r4.y, c5.x
mul_pp r0.w, r2, c1
mul_pp r0.xyz, r0, c0
mul_pp r2.xyz, r0, r0.w
mul_pp r0.xyz, r2, r5
mad_pp r5.xyz, r0, r3.w, r3
mov r2.w, r4.x
texld r0, v4, s5
texldp r4.x, v5, s4
mul_pp r3.xyz, r0, r4.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
mul_pp r3.xyz, r3, c12.y
mad r0.w, r1, c11.z, c11
mul_pp r2.xyz, r2, r0.w
mul r2.xyz, r2.w, r2
min_pp r3.xyz, r0, r3
mul_pp r4.xyz, r0, r4.x
max_pp r3.xyz, r3, r4
mul_pp r1.xyz, r1, r3
mul r2.xyz, r2, c12.x
mad_pp r0.xyz, r2, r0, r1
add_pp oC0.xyz, r0, r5
mov_pp oC0.w, c10
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_SpecTex] 2D 3
SetTexture 2 [_SpecCubeIBL] CUBE 4
SetTexture 3 [_DiffCubeIBL] CUBE 2
SetTexture 4 [_ShadowMapTexture] 2D 0
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
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
eefiecedfkinbacnpdjdnoddfmkpmgboacekpnagabaaaaaaceakaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcomaiaaaaeaaaaaaadlacaaaa
fjaaaaaeegiocaaaaaaaaaaabeaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaa
abaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaadiaaaaakhcaabaaaabaaaaaafgafbaaaaaaaaaaa
aceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaamlcaabaaaaaaaaaaa
agaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaaaaaaaaaadkmnbddpegaibaaa
abaaaaaadcaaaaamhcaabaaaaaaaaaaakgakbaaaaaaaaaaaaceaaaaaolafnblo
pdaedflpdkmnbddpaaaaaaaaegadbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egbcbaaaaeaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadicaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaackaabaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaadaaaaaaaaaaaaaiccaabaaaaaaaaaaadkaabaiaebaaaaaa
abaaaaaaabeaaaaaaaaaiadpdcaaaaangcaabaaaaaaaaaaafgafbaiaebaaaaaa
aaaaaaaafgafbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaebaaaaaaaa
dcaaaaalccaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaabdaaaaaabkaabaaa
aaaaaaaackaabaaaaaaaaaaaaaaaaaaiccaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaaaebbjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaaj
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaidpjccdoabeaaaaaidpjkcdo
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaadobacaaaahecaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaaeaaaaaaaaaaaaaiecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpdcaaaaajicaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaaaaaaaadpabeaaaaaaaaaaadpdiaaaaahecaabaaaaaaaaaaadkaabaaa
aaaaaaaackaabaaaaaaaaaaadcaaaaajecaabaaaaaaaaaaackaabaaaaaaaaaaa
abeaaaaajkjjfjdpabeaaaaajkjjfjlpdcaaaaakecaabaaaaaaaaaaackiacaaa
aaaaaaaabdaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaaakiacaaaaaaaaaaabdaaaaaadiaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaadiaaaaahhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaahocaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaafaaaaaa
pgbpbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaa
aeaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaaakaabaaaacaaaaaa
akaabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaaabaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahocaabaaaacaaaaaapgapbaaaaaaaaaaa
agajbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaa
ddaaaaahocaabaaaacaaaaaafgaobaaaacaaaaaaagajbaaaadaaaaaadiaaaaah
hcaabaaaaeaaaaaaagaabaaaacaaaaaaegacbaaaadaaaaaadeaaaaahhcaabaaa
acaaaaaajgahbaaaacaaaaaaegacbaaaaeaaaaaaefaaaaajpcaabaaaaeaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaa
aeaaaaaaegacbaaaaeaaaaaaegiccaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaa
acaaaaaaegbcbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaa
adaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
aeaaaaaaegacbaaaacaaaaaadiaaaaajdcaabaaaadaaaaaaegiacaaaaaaaaaaa
ahaaaaaaogikcaaaaaaaaaaaaiaaaaaadiaaaaaidcaabaaaadaaaaaaegaabaaa
adaaaaaaegiacaaaaaaaaaaaaiaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaagaabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaa
fgafbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaab"
}
}
 }
}
Fallback "Specular"
}