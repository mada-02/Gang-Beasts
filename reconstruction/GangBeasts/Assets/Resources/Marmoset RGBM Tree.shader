Shader "Hidden/Marmoset/RGBM Tree" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _Shininess ("Shininess", Range(0.01,1)) = 0.078125
 _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
 _BumpMap ("Normalmap", 2D) = "bump" {}
 _GlossMap ("Gloss (A)", 2D) = "black" {}
 _SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
 _SpecInt ("Specular Intensity", Float) = 1
 _Fresnel ("Fresnel Falloff", Range(0,1)) = 0
 _Scale ("Scale", Vector) = (1,1,1,1)
 _SquashAmount ("Squash", Float) = 1
}
SubShader { 
 LOD 200
 Tags { "RenderType"="TreeBark" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "RenderType"="TreeBark" }
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_22;
  vec3 x2_25;
  vec3 x1_26;
  x1_26.x = dot (unity_SHAr, tmpvar_24);
  x1_26.y = dot (unity_SHAg, tmpvar_24);
  x1_26.z = dot (unity_SHAb, tmpvar_24);
  vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_22.xyzz * tmpvar_22.yzzx);
  x2_25.x = dot (unity_SHBr, tmpvar_27);
  x2_25.y = dot (unity_SHBg, tmpvar_27);
  x2_25.z = dot (unity_SHBb, tmpvar_27);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1_26 + x2_25) + (unity_SHC.xyz * ((tmpvar_22.x * tmpvar_22.x) - (tmpvar_22.y * tmpvar_22.y))));
  xlv_TEXCOORD6 = (tmpvar_17 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - tmpvar_11));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  vec4 c_9;
  c_9.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * 2.0);
  c_9.w = tmpvar_2.w;
  c_1.w = c_9.w;
  c_1.xyz = (c_9.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * tmpvar_8.w) * tmpvar_7) * ExposureIBL.x));
  vec4 color_10;
  vec4 tmpvar_11;
  tmpvar_11 = (c_1 * 0.166667);
  color_10 = tmpvar_11;
  float tmpvar_12;
  tmpvar_12 = (ceil((clamp (max (max (tmpvar_11.x, tmpvar_11.y), tmpvar_11.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_12 > 0.0)) {
    color_10.xyz = clamp ((tmpvar_11.xyz * (1.0/(tmpvar_12))), 0.0, 1.0);
    color_10.w = tmpvar_12;
  } else {
    color_10 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_10;
  gl_FragData[0] = color_10;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [unity_Scale]
Vector 23 [_Scale]
Vector 24 [_SquashPlaneNormal]
Float 25 [_SquashAmount]
Vector 26 [_Wind]
Vector 27 [_MainTex_ST]
"vs_3_0
; 100 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
def c28, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c29, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c30, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c28.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c23
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c12.y
mul r0, r0.xxyy, c29
frc r0, r0
mad r0, r0, c28.y, c28.z
frc r0, r0
mad r0, r0, c28.y, c28.w
abs r0, r0
mad r1, -r0, c30.x, c30.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c26
mul r0.x, v5.y, c30.w
mov r1.w, c28.x
mov r0.w, c28.x
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c30.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c26.w, r2
mad r1.xyz, v4.x, c26, r0
dp3 r0.x, r1, c24
add r0.x, r0, c24.w
mul r0.xyz, r0.x, c24
add r1.xyz, -r0, r1
mad r1.xyz, r0, c25.x, r1
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r2.xyz, r0.x, v2
mul r3.xyz, r0.y, v1
mul r0.xyz, r2.zxyw, r3.yzxw
mad r4.xyz, r2.yzxw, r3.zxyw, -r0
mov r0.xyz, c13
mul r4.xyz, r4, v1.w
dp4 r5.z, r0, c10
dp4 r5.x, r0, c8
dp4 r5.y, r0, c9
mad r0.xyz, r5, c22.w, -r1
mov r0.w, c28.x
dp3 o8.z, r2, r0
dp3 o8.y, r4, r0
dp3 o8.x, r3, r0
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
mul r1.xyz, r2, c22.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
dp4 r5.z, r0, c17
dp4 r5.y, r0, c16
dp4 r5.x, r0, c15
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c20
dp4 r0.y, r1, c19
dp4 r0.x, r1, c18
add r0.xyz, r5, r0
mul r1.xyz, r0.w, c21
add o7.xyz, r0, r1
dp3 r0.y, r4, c4
dp3 r0.x, r3, c4
dp3 r0.z, r2, c4
mul o3.xyz, r0, c22.w
dp3 r0.y, r4, c5
dp3 r0.x, r3, c5
dp3 r0.z, r2, c5
mul o4.xyz, r0, c22.w
mov r0, c10
dp4 r5.z, c14, r0
mov r0, c9
dp4 r5.y, c14, r0
dp3 r1.y, r4, c6
dp3 r1.x, r3, c6
dp3 r1.z, r2, c6
mul o5.xyz, r1, c22.w
mov r1, c8
dp4 r5.x, c14, r1
dp3 o6.y, r4, r5
dp3 o6.z, r2, r5
dp3 o6.x, r3, r5
mov o2.xyz, c28.x
mad o1.xy, v3, c27, c27.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedabpdkfjbgnhaebcmnpfnnjaaceialogdabaaaaaaimapaaaaadaaaaaa
cmaaaaaapeaaaaaapiabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopmaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaapfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaomaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaomaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklfdeieefcimanaaaa
eaaaabaagdadaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaa
aaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaa
ahaaaaaagfaaaaadhccabaaaaiaaaaaagiaaaaacaiaaaaaadgaaaaagbcaabaaa
aaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaa
baaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaa
afaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaai
pcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamado
mlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaea
aceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaia
ibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
acaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaah
ccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaa
aaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaa
fgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaa
jkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaa
aeaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaa
abaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaa
aaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pccabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaa
aaaaaaaaanaaaaaadgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaag
bcaabaaaabaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaaeaaaaaajgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaa
aeaaaaaajgaebaaaadaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaa
diaaaaahhcaabaaaaeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaah
ccaabaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaa
afaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaafaaaaaa
pgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaafaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaadiaaaaaihccabaaaafaaaaaaegacbaaaafaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaadaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaafaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaficaabaaaabaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaafaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaabaaaaaabbaaaaaiccaabaaaafaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaabaaaaaabbaaaaaiecaabaaaafaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaabaaaaaadiaaaaahpcaabaaaagaaaaaajgacbaaaabaaaaaaegakbaaa
abaaaaaabbaaaaaibcaabaaaahaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
agaaaaaabbaaaaaiccaabaaaahaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
agaaaaaabbaaaaaiecaabaaaahaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaafaaaaaaegacbaaaafaaaaaaegacbaaaahaaaaaa
diaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaak
icaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaa
aaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaa
aaaaaaaaegacbaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaiaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaaiaaaaaaegacbaaa
adaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaiaaaaaaegacbaaaaeaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_15;
  tmpvar_15 = (gl_ModelViewProjectionMatrix * tmpvar_12);
  vec3 tmpvar_16;
  vec3 tmpvar_17;
  tmpvar_16 = tmpvar_2.xyz;
  tmpvar_17 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_16.x;
  tmpvar_18[0].y = tmpvar_17.x;
  tmpvar_18[0].z = tmpvar_14.x;
  tmpvar_18[1].x = tmpvar_16.y;
  tmpvar_18[1].y = tmpvar_17.y;
  tmpvar_18[1].z = tmpvar_14.y;
  tmpvar_18[2].x = tmpvar_16.z;
  tmpvar_18[2].y = tmpvar_17.z;
  tmpvar_18[2].z = tmpvar_14.z;
  vec3 v_19;
  v_19.x = _Object2World[0].x;
  v_19.y = _Object2World[1].x;
  v_19.z = _Object2World[2].x;
  vec3 v_20;
  v_20.x = _Object2World[0].y;
  v_20.y = _Object2World[1].y;
  v_20.z = _Object2World[2].y;
  vec3 v_21;
  v_21.x = _Object2World[0].z;
  v_21.y = _Object2World[1].z;
  v_21.z = _Object2World[2].z;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_23;
  vec3 x2_26;
  vec3 x1_27;
  x1_27.x = dot (unity_SHAr, tmpvar_25);
  x1_27.y = dot (unity_SHAg, tmpvar_25);
  x1_27.z = dot (unity_SHAb, tmpvar_25);
  vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_23.xyzz * tmpvar_23.yzzx);
  x2_26.x = dot (unity_SHBr, tmpvar_28);
  x2_26.y = dot (unity_SHBg, tmpvar_28);
  x2_26.z = dot (unity_SHBb, tmpvar_28);
  vec4 o_29;
  vec4 tmpvar_30;
  tmpvar_30 = (tmpvar_15 * 0.5);
  vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_30.x;
  tmpvar_31.y = (tmpvar_30.y * _ProjectionParams.x);
  o_29.xy = (tmpvar_31 + tmpvar_30.w);
  o_29.zw = tmpvar_15.zw;
  gl_Position = tmpvar_15;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_18 * v_19) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_18 * v_20) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_18 * v_21) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_18 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1_27 + x2_26) + (unity_SHC.xyz * ((tmpvar_23.x * tmpvar_23.x) - (tmpvar_23.y * tmpvar_23.y))));
  xlv_TEXCOORD6 = (tmpvar_18 * (((_World2Object * tmpvar_24).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD7 = o_29;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  vec4 c_9;
  c_9.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * (texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0));
  c_9.w = tmpvar_2.w;
  c_1.w = c_9.w;
  c_1.xyz = (c_9.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * tmpvar_8.w) * tmpvar_7) * ExposureIBL.x));
  vec4 color_10;
  vec4 tmpvar_11;
  tmpvar_11 = (c_1 * 0.166667);
  color_10 = tmpvar_11;
  float tmpvar_12;
  tmpvar_12 = (ceil((clamp (max (max (tmpvar_11.x, tmpvar_11.y), tmpvar_11.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_12 > 0.0)) {
    color_10.xyz = clamp ((tmpvar_11.xyz * (1.0/(tmpvar_12))), 0.0, 1.0);
    color_10.w = tmpvar_12;
  } else {
    color_10 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_10;
  gl_FragData[0] = color_10;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_ScreenParams]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [unity_Scale]
Vector 25 [_Scale]
Vector 26 [_SquashPlaneNormal]
Float 27 [_SquashAmount]
Vector 28 [_Wind]
Vector 29 [_MainTex_ST]
"vs_3_0
; 105 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
dcl_texcoord7 o9
def c30, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c31, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c32, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c33, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c30.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r4.w, c30.x
mul r2.xyz, v0, c25
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c12.y
mul r0, r0.xxyy, c31
frc r0, r0
mad r0, r0, c30.y, c30.z
frc r0, r0
mad r0, r0, c30.y, c30.w
abs r0, r0
mad r1, -r0, c32.x, c32.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c28
mul r0.x, v5.y, c32.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c32.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c28.w, r2
mad r1.xyz, v4.x, c28, r0
dp3 r0.x, r1, c26
add r0.x, r0, c26.w
mul r0.xyz, r0.x, c26
add r1.xyz, -r0, r1
mad r4.xyz, r0, c27.x, r1
dp4 r0.w, r4, c3
dp4 r0.z, r4, c2
dp4 r0.x, r4, c0
dp4 r0.y, r4, c1
mul r1.xyz, r0.xyww, c33.x
mov o0, r0
mul r1.y, r1, c14.x
mov o9.zw, r0
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r2.xyz, r0.x, v2
mul r3.xyz, r0.y, v1
mad o9.xy, r1.z, c15.zwzw, r1
mul r1.xyz, r2.zxyw, r3.yzxw
mov r0.w, c30.x
mov r0.xyz, c13
dp4 r5.z, r0, c10
dp4 r5.x, r0, c8
dp4 r5.y, r0, c9
mad r0.xyz, r5, c24.w, -r4
mad r1.xyz, r2.yzxw, r3.zxyw, -r1
mul r4.xyz, r1, v1.w
mul r1.xyz, r2, c24.w
mov r0.w, c30.x
dp3 o8.z, r2, r0
dp3 o8.y, r4, r0
dp3 o8.x, r3, r0
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
dp4 r5.z, r0, c19
dp4 r5.y, r0, c18
dp4 r5.x, r0, c17
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c22
dp4 r0.y, r1, c21
dp4 r0.x, r1, c20
add r0.xyz, r5, r0
mul r1.xyz, r0.w, c23
add o7.xyz, r0, r1
dp3 r0.y, r4, c4
dp3 r0.x, r3, c4
dp3 r0.z, r2, c4
mul o3.xyz, r0, c24.w
dp3 r0.y, r4, c5
dp3 r0.x, r3, c5
dp3 r0.z, r2, c5
mul o4.xyz, r0, c24.w
mov r0, c10
dp4 r5.z, c16, r0
mov r0, c9
dp4 r5.y, c16, r0
dp3 r1.y, r4, c6
dp3 r1.x, r3, c6
dp3 r1.z, r2, c6
mul o5.xyz, r1, c24.w
mov r1, c8
dp4 r5.x, c16, r1
dp3 o6.y, r4, r5
dp3 o6.z, r2, r5
dp3 o6.x, r3, r5
mov o2.xyz, c30.x
mad o1.xy, v3, c29, c29.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedkcldfgnmneejngigdcohhbaijeglfjgpabaaaaaafibaaaaaadaaaaaa
cmaaaaaapeaaaaaabaacaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheobeabaaaaakaaaaaa
aiaaaaaapiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaaeabaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaanabaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaaeabaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaaeabaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaaeabaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaaeabaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaaeabaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaaeabaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaaaeabaaaa
ahaaaaaaaaaaaaaaadaaaaaaajaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefceaaoaaaaeaaaabaajaadaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaad
hccabaaaaiaaaaaagfaaaaadpccabaaaajaaaaaagiaaaaacajaaaaaadgaaaaag
bcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaa
dkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaa
aoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaa
akbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
afaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaa
afaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaa
aaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaa
diaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldp
aaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaa
egaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaea
aaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaa
diaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaah
ccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaa
adaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaa
abeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
agbabaaaaeaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaaaaaaaaabaaaaaai
icaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaal
hcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
adaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
aaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaa
dgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
dgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaagbcaabaaaacaaaaaa
akiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaaoaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaahhcaabaaaafaaaaaa
jgaebaaaadaaaaaacgajbaaaaeaaaaaadcaaaaakhcaabaaaafaaaaaajgaebaaa
aeaaaaaacgajbaaaadaaaaaaegacbaiaebaaaaaaafaaaaaadiaaaaahhcaabaaa
afaaaaaaegacbaaaafaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaagaaaaaa
egacbaaaafaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaaagaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaa
beaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaacaaaaaa
ckiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
diaaaaaihccabaaaafaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaajhcaabaaaacaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
acaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
baaaaaahcccabaaaagaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaagaaaaaafgafbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaacaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaacaaaaaaegaibaaa
agaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
acaaaaaaegadbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaagaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaagaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaagaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaacaaaaaa
diaaaaahpcaabaaaahaaaaaajgacbaaaacaaaaaaegakbaaaacaaaaaabbaaaaai
bcaabaaaaiaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaahaaaaaabbaaaaai
ccaabaaaaiaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaahaaaaaabbaaaaai
ecaabaaaaiaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaahaaaaaaaaaaaaah
hcaabaaaagaaaaaaegacbaaaagaaaaaaegacbaaaaiaaaaaadiaaaaahicaabaaa
aaaaaaaabkaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakicaabaaaaaaaaaaa
akaabaaaacaaaaaaakaabaaaacaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaak
hccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaa
agaaaaaadiaaaaajhcaabaaaacaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaa
aaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaadaaaaaabdaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegacbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
egacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaiaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaabaaaaaaheccabaaaaiaaaaaaegacbaaaaeaaaaaaegacbaaa
aaaaaaaabaaaaaahcccabaaaaiaaaaaaegacbaaaafaaaaaaegacbaaaaaaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaabaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaadgaaaaafmccabaaaajaaaaaakgaobaaaabaaaaaaaaaaaaahdccabaaa
ajaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_22;
  vec3 x2_25;
  vec3 x1_26;
  x1_26.x = dot (unity_SHAr, tmpvar_24);
  x1_26.y = dot (unity_SHAg, tmpvar_24);
  x1_26.z = dot (unity_SHAb, tmpvar_24);
  vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_22.xyzz * tmpvar_22.yzzx);
  x2_25.x = dot (unity_SHBr, tmpvar_27);
  x2_25.y = dot (unity_SHBg, tmpvar_27);
  x2_25.z = dot (unity_SHBb, tmpvar_27);
  vec3 tmpvar_28;
  tmpvar_28 = (_Object2World * tmpvar_12).xyz;
  vec4 tmpvar_29;
  tmpvar_29 = (unity_4LightPosX0 - tmpvar_28.x);
  vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosY0 - tmpvar_28.y);
  vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosZ0 - tmpvar_28.z);
  vec4 tmpvar_32;
  tmpvar_32 = (((tmpvar_29 * tmpvar_29) + (tmpvar_30 * tmpvar_30)) + (tmpvar_31 * tmpvar_31));
  vec4 tmpvar_33;
  tmpvar_33 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_29 * tmpvar_22.x) + (tmpvar_30 * tmpvar_22.y)) + (tmpvar_31 * tmpvar_22.z)) * inversesqrt(tmpvar_32))) * (1.0/((1.0 + (tmpvar_32 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1_26 + x2_25) + (unity_SHC.xyz * ((tmpvar_22.x * tmpvar_22.x) - (tmpvar_22.y * tmpvar_22.y)))) + ((((unity_LightColor[0].xyz * tmpvar_33.x) + (unity_LightColor[1].xyz * tmpvar_33.y)) + (unity_LightColor[2].xyz * tmpvar_33.z)) + (unity_LightColor[3].xyz * tmpvar_33.w)));
  xlv_TEXCOORD6 = (tmpvar_17 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - tmpvar_11));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  vec4 c_9;
  c_9.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * 2.0);
  c_9.w = tmpvar_2.w;
  c_1.w = c_9.w;
  c_1.xyz = (c_9.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * tmpvar_8.w) * tmpvar_7) * ExposureIBL.x));
  vec4 color_10;
  vec4 tmpvar_11;
  tmpvar_11 = (c_1 * 0.166667);
  color_10 = tmpvar_11;
  float tmpvar_12;
  tmpvar_12 = (ceil((clamp (max (max (tmpvar_11.x, tmpvar_11.y), tmpvar_11.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_12 > 0.0)) {
    color_10.xyz = clamp ((tmpvar_11.xyz * (1.0/(tmpvar_12))), 0.0, 1.0);
    color_10.w = tmpvar_12;
  } else {
    color_10 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_10;
  gl_FragData[0] = color_10;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
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
Vector 31 [_Scale]
Vector 32 [_SquashPlaneNormal]
Float 33 [_SquashAmount]
Vector 34 [_Wind]
Vector 35 [_MainTex_ST]
"vs_3_0
; 131 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
def c36, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c37, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c38, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c39, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c36.x, r0
add r0.x, v5, r0
add r0.w, v5.y, r0.x
mov r1.y, r0.x
mul r0.xyz, v0, c31
dp3 r1.x, r0, r0.w
add r1.xy, r1, c12.y
mul r1, r1.xxyy, c37
frc r1, r1
mad r1, r1, c36.y, c36.z
frc r1, r1
mad r1, r1, c36.y, c36.w
abs r2, r1
mad r1, -r2, c38.x, c38.y
mul r2, r2, r2
mul r1, r2, r1
add r2.xy, r1.xzzw, r1.ywzw
mul r1.xyz, r2.y, c34
mul r3.xyz, v4.y, r1
mul r0.w, v5.y, c38
mov r1.w, c36.x
mul r1.xz, r0.w, v2
mul r1.y, v4, c38.z
mad r1.xyz, r2.xyxw, r1, r3
mad r0.xyz, r1, c34.w, r0
mad r0.xyz, v4.x, c34, r0
dp3 r0.w, r0, c32
add r0.w, r0, c32
mul r1.xyz, r0.w, c32
add r0.xyz, -r1, r0
mad r1.xyz, r1, c33.x, r0
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
add r3, -r0.y, c16
add r2, -r0.x, c15
mul r0, r3, r3
mad r4, r2, r2, r0
dp3 r5.x, v2, v2
rsq r0.x, r5.x
mul r6.xyz, r0.x, v2
mul r7.xyz, r6, c30.w
dp3 r6.w, r7, c5
dp4 r0.y, r1, c6
add r0, -r0.y, c17
mad r4, r0, r0, r4
dp3 r7.w, r7, c4
mul r3, r6.w, r3
mad r2, r7.w, r2, r3
dp3 r3.x, r7, c6
mad r0, r3.x, r0, r2
mul r5, r4, c18
mov r7.x, r6.w
mov r7.y, r3.x
mov r7.z, c36.x
rsq r2.x, r4.x
rsq r2.y, r4.y
rsq r2.z, r4.z
rsq r2.w, r4.w
mul r0, r0, r2
add r2, r5, c36.x
rcp r2.x, r2.x
rcp r2.y, r2.y
rcp r2.w, r2.w
rcp r2.z, r2.z
max r0, r0, c39.x
mul r0, r0, r2
mul r2.xyz, r0.y, c20
mad r2.xyz, r0.x, c19, r2
mad r0.xyz, r0.z, c21, r2
mad r2.xyz, r0.w, c22, r0
mul r0, r7.wxyy, r7.xyyw
mul r2.w, r6, r6
dp4 r4.z, r0, c28
dp4 r4.y, r0, c27
dp4 r4.x, r0, c26
mad r2.w, r7, r7, -r2
mov r0.w, c36.x
dp4 r3.z, r7.wxyz, c25
dp4 r3.y, r7.wxyz, c24
dp4 r3.x, r7.wxyz, c23
add r3.xyz, r3, r4
mul r0.xyz, r2.w, c29
add r0.xyz, r3, r0
add o7.xyz, r0, r2
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r2.xyz, r0.x, v1
mul r0.xyz, r6.zxyw, r2.yzxw
mad r3.xyz, r6.yzxw, r2.zxyw, -r0
mov r0.xyz, c13
mul r3.xyz, r3, v1.w
dp4 r4.z, r0, c10
dp4 r4.x, r0, c8
dp4 r4.y, r0, c9
mad r0.xyz, r4, c30.w, -r1
dp3 o8.z, r6, r0
dp3 o8.y, r3, r0
dp3 o8.x, r2, r0
dp3 r0.y, r3, c4
dp3 r0.x, r2, c4
dp3 r0.z, r6, c4
mul o3.xyz, r0, c30.w
dp3 r0.y, r3, c5
dp3 r0.x, r2, c5
dp3 r0.z, r6, c5
mul o4.xyz, r0, c30.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
dp3 r1.y, r3, c6
dp3 r1.x, r2, c6
dp3 r1.z, r6, c6
mul o5.xyz, r1, c30.w
mov r1, c8
dp4 r4.x, c14, r1
dp3 o6.y, r3, r4
dp3 o6.z, r6, r4
dp3 o6.x, r2, r4
mov o2.xyz, c36.x
mad o1.xy, v3, c35, c35.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedmbnhnhlefajecbgfamllieomoldlbdocabaaaaaanebcaaaaadaaaaaa
cmaaaaaapeaaaaaapiabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopmaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaapfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaomaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaomaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklfdeieefcnebaaaaa
eaaaabaadfaeaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaa
aaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaa
ahaaaaaagfaaaaadhccabaaaaiaaaaaagiaaaaacalaaaaaadgaaaaagbcaabaaa
aaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaa
baaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaa
afaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaai
pcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamado
mlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaea
aceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaia
ibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
acaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaah
ccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaa
aaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaa
fgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaa
jkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaa
aeaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaa
abaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaa
aaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pccabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaa
aaaaaaaaanaaaaaadgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaag
bcaabaaaabaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaaeaaaaaajgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaa
aeaaaaaajgaebaaaadaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaa
diaaaaahhcaabaaaaeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaah
ccaabaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaa
afaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaafaaaaaa
pgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaafaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaadiaaaaaihccabaaaafaaaaaaegacbaaaafaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaadaaaaaaapaaaaaaaaaaaaajpcaabaaaafaaaaaa
fgafbaiaebaaaaaaabaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaa
agaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaaaaaaaajpcaabaaaahaaaaaa
agaabaiaebaaaaaaabaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaa
abaaaaaakgakbaiaebaaaaaaabaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaaj
pcaabaaaagaaaaaaegaobaaaahaaaaaaegaobaaaahaaaaaaegaobaaaagaaaaaa
dcaaaaajpcaabaaaagaaaaaaegaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
agaaaaaadcaaaaanpcaabaaaaiaaaaaaegaobaaaagaaaaaaegiocaaaacaaaaaa
afaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpeeaaaaafpcaabaaa
agaaaaaaegaobaaaagaaaaaaaoaaaaakpcaabaaaaiaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaaiaaaaaadiaaaaaihcaabaaaajaaaaaa
egacbaaaadaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaakaaaaaa
fgafbaaaajaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaajaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaajaaaaaaegaibaaaakaaaaaadcaaaaak
hcaabaaaajaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaajaaaaaaegadbaaa
ajaaaaaadiaaaaahpcaabaaaafaaaaaaegaobaaaafaaaaaafgafbaaaajaaaaaa
dcaaaaajpcaabaaaafaaaaaaegaobaaaahaaaaaaagaabaaaajaaaaaaegaobaaa
afaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaakgakbaaaajaaaaaa
egaobaaaafaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaagaaaaaaegaobaaa
abaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaaiaaaaaa
egaobaaaabaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaabaaaaaaegiccaaa
acaaaaaaahaaaaaadcaaaaakhcaabaaaafaaaaaaegiccaaaacaaaaaaagaaaaaa
agaabaaaabaaaaaaegacbaaaafaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaafaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaajaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaafaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaajaaaaaabbaaaaaiccaabaaaafaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaajaaaaaabbaaaaaiecaabaaaafaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaajaaaaaadiaaaaahpcaabaaaagaaaaaa
jgacbaaaajaaaaaaegakbaaaajaaaaaabbaaaaaibcaabaaaahaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaagaaaaaabbaaaaaiccaabaaaahaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaagaaaaaabbaaaaaiecaabaaaahaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaagaaaaaaaaaaaaahhcaabaaaafaaaaaaegacbaaa
afaaaaaaegacbaaaahaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaajaaaaaa
bkaabaaaajaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaajaaaaaaakaabaaa
ajaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaaafaaaaaaegiccaaa
acaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaafaaaaaaaaaaaaahhccabaaa
ahaaaaaaegacbaaaabaaaaaaegacbaaaafaaaaaadiaaaaajhcaabaaaabaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaah
bccabaaaaiaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaa
aiaaaaaaegacbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaiaaaaaa
egacbaaaaeaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_15;
  tmpvar_15 = (gl_ModelViewProjectionMatrix * tmpvar_12);
  vec3 tmpvar_16;
  vec3 tmpvar_17;
  tmpvar_16 = tmpvar_2.xyz;
  tmpvar_17 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_16.x;
  tmpvar_18[0].y = tmpvar_17.x;
  tmpvar_18[0].z = tmpvar_14.x;
  tmpvar_18[1].x = tmpvar_16.y;
  tmpvar_18[1].y = tmpvar_17.y;
  tmpvar_18[1].z = tmpvar_14.y;
  tmpvar_18[2].x = tmpvar_16.z;
  tmpvar_18[2].y = tmpvar_17.z;
  tmpvar_18[2].z = tmpvar_14.z;
  vec3 v_19;
  v_19.x = _Object2World[0].x;
  v_19.y = _Object2World[1].x;
  v_19.z = _Object2World[2].x;
  vec3 v_20;
  v_20.x = _Object2World[0].y;
  v_20.y = _Object2World[1].y;
  v_20.z = _Object2World[2].y;
  vec3 v_21;
  v_21.x = _Object2World[0].z;
  v_21.y = _Object2World[1].z;
  v_21.z = _Object2World[2].z;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_23;
  vec3 x2_26;
  vec3 x1_27;
  x1_27.x = dot (unity_SHAr, tmpvar_25);
  x1_27.y = dot (unity_SHAg, tmpvar_25);
  x1_27.z = dot (unity_SHAb, tmpvar_25);
  vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_23.xyzz * tmpvar_23.yzzx);
  x2_26.x = dot (unity_SHBr, tmpvar_28);
  x2_26.y = dot (unity_SHBg, tmpvar_28);
  x2_26.z = dot (unity_SHBb, tmpvar_28);
  vec3 tmpvar_29;
  tmpvar_29 = (_Object2World * tmpvar_12).xyz;
  vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosX0 - tmpvar_29.x);
  vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosY0 - tmpvar_29.y);
  vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosZ0 - tmpvar_29.z);
  vec4 tmpvar_33;
  tmpvar_33 = (((tmpvar_30 * tmpvar_30) + (tmpvar_31 * tmpvar_31)) + (tmpvar_32 * tmpvar_32));
  vec4 tmpvar_34;
  tmpvar_34 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_30 * tmpvar_23.x) + (tmpvar_31 * tmpvar_23.y)) + (tmpvar_32 * tmpvar_23.z)) * inversesqrt(tmpvar_33))) * (1.0/((1.0 + (tmpvar_33 * unity_4LightAtten0)))));
  vec4 o_35;
  vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_15 * 0.5);
  vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_15.zw;
  gl_Position = tmpvar_15;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_18 * v_19) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_18 * v_20) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_18 * v_21) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_18 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1_27 + x2_26) + (unity_SHC.xyz * ((tmpvar_23.x * tmpvar_23.x) - (tmpvar_23.y * tmpvar_23.y)))) + ((((unity_LightColor[0].xyz * tmpvar_34.x) + (unity_LightColor[1].xyz * tmpvar_34.y)) + (unity_LightColor[2].xyz * tmpvar_34.z)) + (unity_LightColor[3].xyz * tmpvar_34.w)));
  xlv_TEXCOORD6 = (tmpvar_18 * (((_World2Object * tmpvar_24).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD7 = o_35;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  vec4 c_9;
  c_9.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * (texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0));
  c_9.w = tmpvar_2.w;
  c_1.w = c_9.w;
  c_1.xyz = (c_9.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * tmpvar_8.w) * tmpvar_7) * ExposureIBL.x));
  vec4 color_10;
  vec4 tmpvar_11;
  tmpvar_11 = (c_1 * 0.166667);
  color_10 = tmpvar_11;
  float tmpvar_12;
  tmpvar_12 = (ceil((clamp (max (max (tmpvar_11.x, tmpvar_11.y), tmpvar_11.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_12 > 0.0)) {
    color_10.xyz = clamp ((tmpvar_11.xyz * (1.0/(tmpvar_12))), 0.0, 1.0);
    color_10.w = tmpvar_12;
  } else {
    color_10 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_10;
  gl_FragData[0] = color_10;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_ScreenParams]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [unity_Scale]
Vector 33 [_Scale]
Vector 34 [_SquashPlaneNormal]
Float 35 [_SquashAmount]
Vector 36 [_Wind]
Vector 37 [_MainTex_ST]
"vs_3_0
; 137 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
dcl_texcoord7 o9
def c38, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c39, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c40, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c41, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c38.x, r0
add r0.x, v5, r0
add r0.w, v5.y, r0.x
mov r1.y, r0.x
mul r0.xyz, v0, c33
dp3 r1.x, r0, r0.w
add r1.xy, r1, c12.y
mul r1, r1.xxyy, c39
frc r1, r1
mad r1, r1, c38.y, c38.z
frc r1, r1
mad r1, r1, c38.y, c38.w
abs r2, r1
mad r1, -r2, c40.x, c40.y
mul r2, r2, r2
mul r1, r2, r1
add r2.xy, r1.xzzw, r1.ywzw
mul r1.xyz, r2.y, c36
mul r3.xyz, v4.y, r1
mul r0.w, v5.y, c40
mov r1.w, c38.x
mul r1.xz, r0.w, v2
mul r1.y, v4, c40.z
mad r1.xyz, r2.xyxw, r1, r3
mad r0.xyz, r1, c36.w, r0
mad r0.xyz, v4.x, c36, r0
dp3 r0.w, r0, c34
add r0.w, r0, c34
mul r1.xyz, r0.w, c34
add r0.xyz, -r1, r0
mad r1.xyz, r1, c35.x, r0
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
add r3, -r0.y, c18
add r2, -r0.x, c17
mul r0, r3, r3
mad r4, r2, r2, r0
dp3 r5.x, v2, v2
rsq r0.x, r5.x
mul r6.xyz, r0.x, v2
mul r7.xyz, r6, c32.w
dp3 r6.w, r7, c5
dp4 r0.y, r1, c6
add r0, -r0.y, c19
mad r4, r0, r0, r4
dp3 r7.w, r7, c4
mul r3, r6.w, r3
mad r2, r7.w, r2, r3
dp3 r3.w, r7, c6
mad r0, r3.w, r0, r2
mul r5, r4, c20
mov r7.x, r6.w
mov r7.y, r3.w
mov r7.z, c38.x
rsq r2.x, r4.x
rsq r2.y, r4.y
rsq r2.z, r4.z
rsq r2.w, r4.w
mul r0, r0, r2
add r2, r5, c38.x
dp4 r5.z, r7.wxyz, c27
dp4 r5.y, r7.wxyz, c26
dp4 r5.x, r7.wxyz, c25
rcp r2.x, r2.x
rcp r2.y, r2.y
rcp r2.w, r2.w
rcp r2.z, r2.z
max r0, r0, c41.x
mul r0, r0, r2
mul r2.xyz, r0.y, c22
mad r2.xyz, r0.x, c21, r2
mad r0.xyz, r0.z, c23, r2
mad r3.xyz, r0.w, c24, r0
mul r0, r7.wxyy, r7.xyyw
mul r2.z, r6.w, r6.w
dp4 r2.w, r1, c3
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r4.xyz, r2.xyww, c41.y
dp4 r7.z, r0, c30
dp4 r7.y, r0, c29
dp4 r7.x, r0, c28
mad r2.z, r7.w, r7.w, -r2
mul r0.xyz, r2.z, c31
dp4 r2.z, r1, c2
add r5.xyz, r5, r7
add r0.xyz, r5, r0
add o7.xyz, r0, r3
mov r0.x, r4
mul r0.y, r4, c14.x
mad o9.xy, r4.z, c15.zwzw, r0
dp3 r0.z, v1, v1
rsq r0.x, r0.z
mul r0.xyz, r0.x, v1
mul r3.xyz, r6.zxyw, r0.yzxw
mad r3.xyz, r6.yzxw, r0.zxyw, -r3
mul r3.xyz, r3, v1.w
mov o0, r2
mov o9.zw, r2
mov r2.xyz, c13
mov r2.w, c38.x
dp4 r4.z, r2, c10
dp4 r4.x, r2, c8
dp4 r4.y, r2, c9
mad r1.xyz, r4, c32.w, -r1
dp3 o8.z, r6, r1
dp3 o8.y, r3, r1
dp3 o8.x, r0, r1
dp3 r1.y, r3, c4
dp3 r1.x, r0, c4
dp3 r1.z, r6, c4
mul o3.xyz, r1, c32.w
dp3 r1.y, r3, c5
dp3 r1.x, r0, c5
dp3 r1.z, r6, c5
mul o4.xyz, r1, c32.w
mov r1, c10
dp4 r4.z, c16, r1
mov r1, c9
dp4 r4.y, c16, r1
dp3 r2.y, r3, c6
dp3 r2.x, r0, c6
dp3 r2.z, r6, c6
mul o5.xyz, r2, c32.w
mov r2, c8
dp4 r4.x, c16, r2
dp3 o6.y, r3, r4
dp3 o6.z, r6, r4
dp3 o6.x, r0, r4
mov o2.xyz, c38.x
mad o1.xy, v3, c37, c37.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefieceddnegmolnijkfoknmhcbpkddhfnjookdgabaaaaaakabdaaaaadaaaaaa
cmaaaaaapeaaaaaabaacaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheobeabaaaaakaaaaaa
aiaaaaaapiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaaeabaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaanabaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaaeabaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaaeabaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaaeabaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaaeabaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaaeabaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaaeabaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaaaeabaaaa
ahaaaaaaaaaaaaaaadaaaaaaajaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciibbaaaaeaaaabaagcaeaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaad
hccabaaaaiaaaaaagfaaaaadpccabaaaajaaaaaagiaaaaacamaaaaaadgaaaaag
bcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaa
dkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaa
aoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaa
akbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
afaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaa
afaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaa
aaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaa
diaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldp
aaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaa
egaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaea
aaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaa
diaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaah
ccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaa
adaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaa
abeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
agbabaaaaeaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaaaaaaaaabaaaaaai
icaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaal
hcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
adaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
aaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaa
dgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
dgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaagbcaabaaaacaaaaaa
akiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaaoaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaahhcaabaaaafaaaaaa
jgaebaaaadaaaaaacgajbaaaaeaaaaaadcaaaaakhcaabaaaafaaaaaajgaebaaa
aeaaaaaacgajbaaaadaaaaaaegacbaiaebaaaaaaafaaaaaadiaaaaahhcaabaaa
afaaaaaaegacbaaaafaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaagaaaaaa
egacbaaaafaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaaagaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaa
beaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaacaaaaaa
ckiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
diaaaaaihccabaaaafaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaajhcaabaaaacaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
acaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
baaaaaahcccabaaaagaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaaaaaaaaajpcaabaaaagaaaaaafgafbaiaebaaaaaa
acaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaahaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaaaaaaaajpcaabaaaaiaaaaaaagaabaiaebaaaaaa
acaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaaacaaaaaakgakbaia
ebaaaaaaacaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaahaaaaaa
egaobaaaaiaaaaaaegaobaaaaiaaaaaaegaobaaaahaaaaaadcaaaaajpcaabaaa
ahaaaaaaegaobaaaacaaaaaaegaobaaaacaaaaaaegaobaaaahaaaaaadcaaaaan
pcaabaaaajaaaaaaegaobaaaahaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpeeaaaaafpcaabaaaahaaaaaaegaobaaa
ahaaaaaaaoaaaaakpcaabaaaajaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaajaaaaaadiaaaaaihcaabaaaakaaaaaaegacbaaaaeaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaalaaaaaafgafbaaaakaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaakaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaakaaaaaaegaibaaaalaaaaaadcaaaaakhcaabaaaakaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaakaaaaaaegadbaaaakaaaaaadiaaaaah
pcaabaaaagaaaaaaegaobaaaagaaaaaafgafbaaaakaaaaaadcaaaaajpcaabaaa
agaaaaaaegaobaaaaiaaaaaaagaabaaaakaaaaaaegaobaaaagaaaaaadcaaaaaj
pcaabaaaacaaaaaaegaobaaaacaaaaaakgakbaaaakaaaaaaegaobaaaagaaaaaa
diaaaaahpcaabaaaacaaaaaaegaobaaaahaaaaaaegaobaaaacaaaaaadeaaaaak
pcaabaaaacaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaaegaobaaaajaaaaaaegaobaaaacaaaaaa
diaaaaaihcaabaaaagaaaaaafgafbaaaacaaaaaaegiccaaaacaaaaaaahaaaaaa
dcaaaaakhcaabaaaagaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaacaaaaaa
egacbaaaagaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
kgakbaaaacaaaaaaegacbaaaagaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
acaaaaaaajaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaa
akaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaagaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaakaaaaaabbaaaaaiccaabaaaagaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaakaaaaaabbaaaaaiecaabaaaagaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaakaaaaaadiaaaaahpcaabaaaahaaaaaajgacbaaaakaaaaaa
egakbaaaakaaaaaabbaaaaaibcaabaaaaiaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaahaaaaaabbaaaaaiccaabaaaaiaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaahaaaaaabbaaaaaiecaabaaaaiaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaahaaaaaaaaaaaaahhcaabaaaagaaaaaaegacbaaaagaaaaaaegacbaaa
aiaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaakaaaaaabkaabaaaakaaaaaa
dcaaaaakicaabaaaaaaaaaaaakaabaaaakaaaaaaakaabaaaakaaaaaadkaabaia
ebaaaaaaaaaaaaaadcaaaaakhcaabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaaaaaaaaaegacbaaaagaaaaaaaaaaaaahhccabaaaahaaaaaaegacbaaa
acaaaaaaegacbaaaagaaaaaadiaaaaajhcaabaaaacaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaiaaaaaa
egacbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaaiaaaaaaegacbaaa
aeaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaiaaaaaaegacbaaaafaaaaaa
egacbaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaabkaabaaaabaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaadpdiaaaaakfcaabaaaaaaaaaaaagadbaaaabaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaaaadgaaaaafmccabaaaajaaaaaakgaobaaaabaaaaaa
aaaaaaahdccabaaaajaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_22;
  vec3 x2_25;
  vec3 x1_26;
  x1_26.x = dot (unity_SHAr, tmpvar_24);
  x1_26.y = dot (unity_SHAg, tmpvar_24);
  x1_26.z = dot (unity_SHAb, tmpvar_24);
  vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_22.xyzz * tmpvar_22.yzzx);
  x2_25.x = dot (unity_SHBr, tmpvar_27);
  x2_25.y = dot (unity_SHBg, tmpvar_27);
  x2_25.z = dot (unity_SHBb, tmpvar_27);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1_26 + x2_25) + (unity_SHC.xyz * ((tmpvar_22.x * tmpvar_22.x) - (tmpvar_22.y * tmpvar_22.y))));
  xlv_TEXCOORD6 = (tmpvar_17 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - tmpvar_11));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  float tmpvar_9;
  tmpvar_9 = (tmpvar_8.w * tmpvar_8.w);
  vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (tmpvar_8.w * tmpvar_9);
  vec4 c_11;
  c_11.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * 2.0);
  c_11.w = tmpvar_2.w;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * tmpvar_7) * ExposureIBL.x));
  vec4 color_12;
  color_12.w = c_1.w;
  color_12.xyz = pow (c_1.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_13;
  tmpvar_13 = (color_12 * 0.166667);
  color_12 = tmpvar_13;
  float tmpvar_14;
  tmpvar_14 = (ceil((clamp (max (max (tmpvar_13.x, tmpvar_13.y), tmpvar_13.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_14 > 0.0)) {
    color_12.xyz = clamp ((tmpvar_13.xyz * (1.0/(tmpvar_14))), 0.0, 1.0);
    color_12.w = tmpvar_14;
  } else {
    color_12 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_12.xyz = pow (color_12.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_12;
  gl_FragData[0] = color_12;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [unity_Scale]
Vector 23 [_Scale]
Vector 24 [_SquashPlaneNormal]
Float 25 [_SquashAmount]
Vector 26 [_Wind]
Vector 27 [_MainTex_ST]
"vs_3_0
; 100 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
def c28, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c29, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c30, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c28.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c23
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c12.y
mul r0, r0.xxyy, c29
frc r0, r0
mad r0, r0, c28.y, c28.z
frc r0, r0
mad r0, r0, c28.y, c28.w
abs r0, r0
mad r1, -r0, c30.x, c30.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c26
mul r0.x, v5.y, c30.w
mov r1.w, c28.x
mov r0.w, c28.x
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c30.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c26.w, r2
mad r1.xyz, v4.x, c26, r0
dp3 r0.x, r1, c24
add r0.x, r0, c24.w
mul r0.xyz, r0.x, c24
add r1.xyz, -r0, r1
mad r1.xyz, r0, c25.x, r1
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r2.xyz, r0.x, v2
mul r3.xyz, r0.y, v1
mul r0.xyz, r2.zxyw, r3.yzxw
mad r4.xyz, r2.yzxw, r3.zxyw, -r0
mov r0.xyz, c13
mul r4.xyz, r4, v1.w
dp4 r5.z, r0, c10
dp4 r5.x, r0, c8
dp4 r5.y, r0, c9
mad r0.xyz, r5, c22.w, -r1
mov r0.w, c28.x
dp3 o8.z, r2, r0
dp3 o8.y, r4, r0
dp3 o8.x, r3, r0
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
mul r1.xyz, r2, c22.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
dp4 r5.z, r0, c17
dp4 r5.y, r0, c16
dp4 r5.x, r0, c15
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c20
dp4 r0.y, r1, c19
dp4 r0.x, r1, c18
add r0.xyz, r5, r0
mul r1.xyz, r0.w, c21
add o7.xyz, r0, r1
dp3 r0.y, r4, c4
dp3 r0.x, r3, c4
dp3 r0.z, r2, c4
mul o3.xyz, r0, c22.w
dp3 r0.y, r4, c5
dp3 r0.x, r3, c5
dp3 r0.z, r2, c5
mul o4.xyz, r0, c22.w
mov r0, c10
dp4 r5.z, c14, r0
mov r0, c9
dp4 r5.y, c14, r0
dp3 r1.y, r4, c6
dp3 r1.x, r3, c6
dp3 r1.z, r2, c6
mul o5.xyz, r1, c22.w
mov r1, c8
dp4 r5.x, c14, r1
dp3 o6.y, r4, r5
dp3 o6.z, r2, r5
dp3 o6.x, r3, r5
mov o2.xyz, c28.x
mad o1.xy, v3, c27, c27.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedabpdkfjbgnhaebcmnpfnnjaaceialogdabaaaaaaimapaaaaadaaaaaa
cmaaaaaapeaaaaaapiabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopmaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaapfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaomaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaomaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklfdeieefcimanaaaa
eaaaabaagdadaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaa
aaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaa
ahaaaaaagfaaaaadhccabaaaaiaaaaaagiaaaaacaiaaaaaadgaaaaagbcaabaaa
aaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaa
baaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaa
afaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaai
pcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamado
mlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaea
aceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaia
ibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
acaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaah
ccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaa
aaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaa
fgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaa
jkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaa
aeaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaa
abaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaa
aaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pccabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaa
aaaaaaaaanaaaaaadgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaag
bcaabaaaabaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaaeaaaaaajgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaa
aeaaaaaajgaebaaaadaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaa
diaaaaahhcaabaaaaeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaah
ccaabaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaa
afaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaafaaaaaa
pgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaafaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaadiaaaaaihccabaaaafaaaaaaegacbaaaafaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaadaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaafaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaaficaabaaaabaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaafaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaabaaaaaabbaaaaaiccaabaaaafaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaabaaaaaabbaaaaaiecaabaaaafaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaabaaaaaadiaaaaahpcaabaaaagaaaaaajgacbaaaabaaaaaaegakbaaa
abaaaaaabbaaaaaibcaabaaaahaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
agaaaaaabbaaaaaiccaabaaaahaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
agaaaaaabbaaaaaiecaabaaaahaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaafaaaaaaegacbaaaafaaaaaaegacbaaaahaaaaaa
diaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaak
icaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaa
aaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaa
aaaaaaaaegacbaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaal
hcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaabaaaaaapgipcaaa
adaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaiaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaaiaaaaaaegacbaaa
adaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaiaaaaaaegacbaaaaeaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_15;
  tmpvar_15 = (gl_ModelViewProjectionMatrix * tmpvar_12);
  vec3 tmpvar_16;
  vec3 tmpvar_17;
  tmpvar_16 = tmpvar_2.xyz;
  tmpvar_17 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_16.x;
  tmpvar_18[0].y = tmpvar_17.x;
  tmpvar_18[0].z = tmpvar_14.x;
  tmpvar_18[1].x = tmpvar_16.y;
  tmpvar_18[1].y = tmpvar_17.y;
  tmpvar_18[1].z = tmpvar_14.y;
  tmpvar_18[2].x = tmpvar_16.z;
  tmpvar_18[2].y = tmpvar_17.z;
  tmpvar_18[2].z = tmpvar_14.z;
  vec3 v_19;
  v_19.x = _Object2World[0].x;
  v_19.y = _Object2World[1].x;
  v_19.z = _Object2World[2].x;
  vec3 v_20;
  v_20.x = _Object2World[0].y;
  v_20.y = _Object2World[1].y;
  v_20.z = _Object2World[2].y;
  vec3 v_21;
  v_21.x = _Object2World[0].z;
  v_21.y = _Object2World[1].z;
  v_21.z = _Object2World[2].z;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_23;
  vec3 x2_26;
  vec3 x1_27;
  x1_27.x = dot (unity_SHAr, tmpvar_25);
  x1_27.y = dot (unity_SHAg, tmpvar_25);
  x1_27.z = dot (unity_SHAb, tmpvar_25);
  vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_23.xyzz * tmpvar_23.yzzx);
  x2_26.x = dot (unity_SHBr, tmpvar_28);
  x2_26.y = dot (unity_SHBg, tmpvar_28);
  x2_26.z = dot (unity_SHBb, tmpvar_28);
  vec4 o_29;
  vec4 tmpvar_30;
  tmpvar_30 = (tmpvar_15 * 0.5);
  vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_30.x;
  tmpvar_31.y = (tmpvar_30.y * _ProjectionParams.x);
  o_29.xy = (tmpvar_31 + tmpvar_30.w);
  o_29.zw = tmpvar_15.zw;
  gl_Position = tmpvar_15;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_18 * v_19) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_18 * v_20) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_18 * v_21) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_18 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1_27 + x2_26) + (unity_SHC.xyz * ((tmpvar_23.x * tmpvar_23.x) - (tmpvar_23.y * tmpvar_23.y))));
  xlv_TEXCOORD6 = (tmpvar_18 * (((_World2Object * tmpvar_24).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD7 = o_29;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  float tmpvar_9;
  tmpvar_9 = (tmpvar_8.w * tmpvar_8.w);
  vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (tmpvar_8.w * tmpvar_9);
  vec4 c_11;
  c_11.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * (texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0));
  c_11.w = tmpvar_2.w;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * tmpvar_7) * ExposureIBL.x));
  vec4 color_12;
  color_12.w = c_1.w;
  color_12.xyz = pow (c_1.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_13;
  tmpvar_13 = (color_12 * 0.166667);
  color_12 = tmpvar_13;
  float tmpvar_14;
  tmpvar_14 = (ceil((clamp (max (max (tmpvar_13.x, tmpvar_13.y), tmpvar_13.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_14 > 0.0)) {
    color_12.xyz = clamp ((tmpvar_13.xyz * (1.0/(tmpvar_14))), 0.0, 1.0);
    color_12.w = tmpvar_14;
  } else {
    color_12 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_12.xyz = pow (color_12.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_12;
  gl_FragData[0] = color_12;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_ScreenParams]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [unity_Scale]
Vector 25 [_Scale]
Vector 26 [_SquashPlaneNormal]
Float 27 [_SquashAmount]
Vector 28 [_Wind]
Vector 29 [_MainTex_ST]
"vs_3_0
; 105 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
dcl_texcoord7 o9
def c30, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c31, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c32, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c33, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c30.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r4.w, c30.x
mul r2.xyz, v0, c25
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c12.y
mul r0, r0.xxyy, c31
frc r0, r0
mad r0, r0, c30.y, c30.z
frc r0, r0
mad r0, r0, c30.y, c30.w
abs r0, r0
mad r1, -r0, c32.x, c32.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c28
mul r0.x, v5.y, c32.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c32.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c28.w, r2
mad r1.xyz, v4.x, c28, r0
dp3 r0.x, r1, c26
add r0.x, r0, c26.w
mul r0.xyz, r0.x, c26
add r1.xyz, -r0, r1
mad r4.xyz, r0, c27.x, r1
dp4 r0.w, r4, c3
dp4 r0.z, r4, c2
dp4 r0.x, r4, c0
dp4 r0.y, r4, c1
mul r1.xyz, r0.xyww, c33.x
mov o0, r0
mul r1.y, r1, c14.x
mov o9.zw, r0
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r2.xyz, r0.x, v2
mul r3.xyz, r0.y, v1
mad o9.xy, r1.z, c15.zwzw, r1
mul r1.xyz, r2.zxyw, r3.yzxw
mov r0.w, c30.x
mov r0.xyz, c13
dp4 r5.z, r0, c10
dp4 r5.x, r0, c8
dp4 r5.y, r0, c9
mad r0.xyz, r5, c24.w, -r4
mad r1.xyz, r2.yzxw, r3.zxyw, -r1
mul r4.xyz, r1, v1.w
mul r1.xyz, r2, c24.w
mov r0.w, c30.x
dp3 o8.z, r2, r0
dp3 o8.y, r4, r0
dp3 o8.x, r3, r0
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
dp4 r5.z, r0, c19
dp4 r5.y, r0, c18
dp4 r5.x, r0, c17
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c22
dp4 r0.y, r1, c21
dp4 r0.x, r1, c20
add r0.xyz, r5, r0
mul r1.xyz, r0.w, c23
add o7.xyz, r0, r1
dp3 r0.y, r4, c4
dp3 r0.x, r3, c4
dp3 r0.z, r2, c4
mul o3.xyz, r0, c24.w
dp3 r0.y, r4, c5
dp3 r0.x, r3, c5
dp3 r0.z, r2, c5
mul o4.xyz, r0, c24.w
mov r0, c10
dp4 r5.z, c16, r0
mov r0, c9
dp4 r5.y, c16, r0
dp3 r1.y, r4, c6
dp3 r1.x, r3, c6
dp3 r1.z, r2, c6
mul o5.xyz, r1, c24.w
mov r1, c8
dp4 r5.x, c16, r1
dp3 o6.y, r4, r5
dp3 o6.z, r2, r5
dp3 o6.x, r3, r5
mov o2.xyz, c30.x
mad o1.xy, v3, c29, c29.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedkcldfgnmneejngigdcohhbaijeglfjgpabaaaaaafibaaaaaadaaaaaa
cmaaaaaapeaaaaaabaacaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheobeabaaaaakaaaaaa
aiaaaaaapiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaaeabaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaanabaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaaeabaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaaeabaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaaeabaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaaeabaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaaeabaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaaeabaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaaaeabaaaa
ahaaaaaaaaaaaaaaadaaaaaaajaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefceaaoaaaaeaaaabaajaadaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaad
hccabaaaaiaaaaaagfaaaaadpccabaaaajaaaaaagiaaaaacajaaaaaadgaaaaag
bcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaa
dkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaa
aoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaa
akbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
afaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaa
afaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaa
aaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaa
diaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldp
aaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaa
egaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaea
aaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaa
diaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaah
ccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaa
adaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaa
abeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
agbabaaaaeaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaaaaaaaaabaaaaaai
icaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaal
hcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
adaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
aaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaa
dgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
dgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaagbcaabaaaacaaaaaa
akiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaaoaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaahhcaabaaaafaaaaaa
jgaebaaaadaaaaaacgajbaaaaeaaaaaadcaaaaakhcaabaaaafaaaaaajgaebaaa
aeaaaaaacgajbaaaadaaaaaaegacbaiaebaaaaaaafaaaaaadiaaaaahhcaabaaa
afaaaaaaegacbaaaafaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaagaaaaaa
egacbaaaafaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaaagaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaa
beaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaacaaaaaa
ckiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
diaaaaaihccabaaaafaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaajhcaabaaaacaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
acaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
baaaaaahcccabaaaagaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaai
hcaabaaaagaaaaaafgafbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
lcaabaaaacaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaacaaaaaaegaibaaa
agaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
acaaaaaaegadbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaagaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaagaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaagaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaacaaaaaa
diaaaaahpcaabaaaahaaaaaajgacbaaaacaaaaaaegakbaaaacaaaaaabbaaaaai
bcaabaaaaiaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaahaaaaaabbaaaaai
ccaabaaaaiaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaahaaaaaabbaaaaai
ecaabaaaaiaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaahaaaaaaaaaaaaah
hcaabaaaagaaaaaaegacbaaaagaaaaaaegacbaaaaiaaaaaadiaaaaahicaabaaa
aaaaaaaabkaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakicaabaaaaaaaaaaa
akaabaaaacaaaaaaakaabaaaacaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaak
hccabaaaahaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaa
agaaaaaadiaaaaajhcaabaaaacaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaa
aaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaadaaaaaabdaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegacbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
egacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaiaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaabaaaaaaheccabaaaaiaaaaaaegacbaaaaeaaaaaaegacbaaa
aaaaaaaabaaaaaahcccabaaaaiaaaaaaegacbaaaafaaaaaaegacbaaaaaaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaabaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaadgaaaaafmccabaaaajaaaaaakgaobaaaabaaaaaaaaaaaaahdccabaaa
ajaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_22;
  vec3 x2_25;
  vec3 x1_26;
  x1_26.x = dot (unity_SHAr, tmpvar_24);
  x1_26.y = dot (unity_SHAg, tmpvar_24);
  x1_26.z = dot (unity_SHAb, tmpvar_24);
  vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_22.xyzz * tmpvar_22.yzzx);
  x2_25.x = dot (unity_SHBr, tmpvar_27);
  x2_25.y = dot (unity_SHBg, tmpvar_27);
  x2_25.z = dot (unity_SHBb, tmpvar_27);
  vec3 tmpvar_28;
  tmpvar_28 = (_Object2World * tmpvar_12).xyz;
  vec4 tmpvar_29;
  tmpvar_29 = (unity_4LightPosX0 - tmpvar_28.x);
  vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosY0 - tmpvar_28.y);
  vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosZ0 - tmpvar_28.z);
  vec4 tmpvar_32;
  tmpvar_32 = (((tmpvar_29 * tmpvar_29) + (tmpvar_30 * tmpvar_30)) + (tmpvar_31 * tmpvar_31));
  vec4 tmpvar_33;
  tmpvar_33 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_29 * tmpvar_22.x) + (tmpvar_30 * tmpvar_22.y)) + (tmpvar_31 * tmpvar_22.z)) * inversesqrt(tmpvar_32))) * (1.0/((1.0 + (tmpvar_32 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1_26 + x2_25) + (unity_SHC.xyz * ((tmpvar_22.x * tmpvar_22.x) - (tmpvar_22.y * tmpvar_22.y)))) + ((((unity_LightColor[0].xyz * tmpvar_33.x) + (unity_LightColor[1].xyz * tmpvar_33.y)) + (unity_LightColor[2].xyz * tmpvar_33.z)) + (unity_LightColor[3].xyz * tmpvar_33.w)));
  xlv_TEXCOORD6 = (tmpvar_17 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - tmpvar_11));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  float tmpvar_9;
  tmpvar_9 = (tmpvar_8.w * tmpvar_8.w);
  vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (tmpvar_8.w * tmpvar_9);
  vec4 c_11;
  c_11.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * 2.0);
  c_11.w = tmpvar_2.w;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * tmpvar_7) * ExposureIBL.x));
  vec4 color_12;
  color_12.w = c_1.w;
  color_12.xyz = pow (c_1.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_13;
  tmpvar_13 = (color_12 * 0.166667);
  color_12 = tmpvar_13;
  float tmpvar_14;
  tmpvar_14 = (ceil((clamp (max (max (tmpvar_13.x, tmpvar_13.y), tmpvar_13.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_14 > 0.0)) {
    color_12.xyz = clamp ((tmpvar_13.xyz * (1.0/(tmpvar_14))), 0.0, 1.0);
    color_12.w = tmpvar_14;
  } else {
    color_12 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_12.xyz = pow (color_12.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_12;
  gl_FragData[0] = color_12;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
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
Vector 31 [_Scale]
Vector 32 [_SquashPlaneNormal]
Float 33 [_SquashAmount]
Vector 34 [_Wind]
Vector 35 [_MainTex_ST]
"vs_3_0
; 131 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
def c36, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c37, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c38, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c39, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c36.x, r0
add r0.x, v5, r0
add r0.w, v5.y, r0.x
mov r1.y, r0.x
mul r0.xyz, v0, c31
dp3 r1.x, r0, r0.w
add r1.xy, r1, c12.y
mul r1, r1.xxyy, c37
frc r1, r1
mad r1, r1, c36.y, c36.z
frc r1, r1
mad r1, r1, c36.y, c36.w
abs r2, r1
mad r1, -r2, c38.x, c38.y
mul r2, r2, r2
mul r1, r2, r1
add r2.xy, r1.xzzw, r1.ywzw
mul r1.xyz, r2.y, c34
mul r3.xyz, v4.y, r1
mul r0.w, v5.y, c38
mov r1.w, c36.x
mul r1.xz, r0.w, v2
mul r1.y, v4, c38.z
mad r1.xyz, r2.xyxw, r1, r3
mad r0.xyz, r1, c34.w, r0
mad r0.xyz, v4.x, c34, r0
dp3 r0.w, r0, c32
add r0.w, r0, c32
mul r1.xyz, r0.w, c32
add r0.xyz, -r1, r0
mad r1.xyz, r1, c33.x, r0
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
add r3, -r0.y, c16
add r2, -r0.x, c15
mul r0, r3, r3
mad r4, r2, r2, r0
dp3 r5.x, v2, v2
rsq r0.x, r5.x
mul r6.xyz, r0.x, v2
mul r7.xyz, r6, c30.w
dp3 r6.w, r7, c5
dp4 r0.y, r1, c6
add r0, -r0.y, c17
mad r4, r0, r0, r4
dp3 r7.w, r7, c4
mul r3, r6.w, r3
mad r2, r7.w, r2, r3
dp3 r3.x, r7, c6
mad r0, r3.x, r0, r2
mul r5, r4, c18
mov r7.x, r6.w
mov r7.y, r3.x
mov r7.z, c36.x
rsq r2.x, r4.x
rsq r2.y, r4.y
rsq r2.z, r4.z
rsq r2.w, r4.w
mul r0, r0, r2
add r2, r5, c36.x
rcp r2.x, r2.x
rcp r2.y, r2.y
rcp r2.w, r2.w
rcp r2.z, r2.z
max r0, r0, c39.x
mul r0, r0, r2
mul r2.xyz, r0.y, c20
mad r2.xyz, r0.x, c19, r2
mad r0.xyz, r0.z, c21, r2
mad r2.xyz, r0.w, c22, r0
mul r0, r7.wxyy, r7.xyyw
mul r2.w, r6, r6
dp4 r4.z, r0, c28
dp4 r4.y, r0, c27
dp4 r4.x, r0, c26
mad r2.w, r7, r7, -r2
mov r0.w, c36.x
dp4 r3.z, r7.wxyz, c25
dp4 r3.y, r7.wxyz, c24
dp4 r3.x, r7.wxyz, c23
add r3.xyz, r3, r4
mul r0.xyz, r2.w, c29
add r0.xyz, r3, r0
add o7.xyz, r0, r2
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r2.xyz, r0.x, v1
mul r0.xyz, r6.zxyw, r2.yzxw
mad r3.xyz, r6.yzxw, r2.zxyw, -r0
mov r0.xyz, c13
mul r3.xyz, r3, v1.w
dp4 r4.z, r0, c10
dp4 r4.x, r0, c8
dp4 r4.y, r0, c9
mad r0.xyz, r4, c30.w, -r1
dp3 o8.z, r6, r0
dp3 o8.y, r3, r0
dp3 o8.x, r2, r0
dp3 r0.y, r3, c4
dp3 r0.x, r2, c4
dp3 r0.z, r6, c4
mul o3.xyz, r0, c30.w
dp3 r0.y, r3, c5
dp3 r0.x, r2, c5
dp3 r0.z, r6, c5
mul o4.xyz, r0, c30.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
dp3 r1.y, r3, c6
dp3 r1.x, r2, c6
dp3 r1.z, r6, c6
mul o5.xyz, r1, c30.w
mov r1, c8
dp4 r4.x, c14, r1
dp3 o6.y, r3, r4
dp3 o6.z, r6, r4
dp3 o6.x, r2, r4
mov o2.xyz, c36.x
mad o1.xy, v3, c35, c35.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedmbnhnhlefajecbgfamllieomoldlbdocabaaaaaanebcaaaaadaaaaaa
cmaaaaaapeaaaaaapiabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheopmaaaaaaajaaaaaa
aiaaaaaaoaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaapfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaomaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaomaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaomaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaomaaaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklfdeieefcnebaaaaa
eaaaabaadfaeaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaa
aaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaa
ahaaaaaagfaaaaadhccabaaaaiaaaaaagiaaaaacalaaaaaadgaaaaagbcaabaaa
aaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaa
baaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaa
afaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaa
diaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaai
pcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamado
mlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaea
aceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaia
ibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaea
aaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
acaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaah
ccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaa
aaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaa
fgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaa
jkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
aaaaaaaaadaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaa
aeaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaa
abaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaa
aaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
aaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pccabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaa
aaaaaaaaanaaaaaadgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaadgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaag
bcaabaaaabaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaabaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaaeaaaaaajgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaa
aeaaaaaajgaebaaaadaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaa
diaaaaahhcaabaaaaeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaah
ccaabaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaa
afaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaabkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaabaaaaaabkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaabaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaa
afaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaafaaaaaa
pgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaabaaaaaackiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaabaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaabaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaafaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaahccaabaaaafaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaabaaaaaahecaabaaaafaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaadiaaaaaihccabaaaafaaaaaaegacbaaaafaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaaacaaaaaaaaaaaaaa
egiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
baaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaa
acaaaaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaabaaaaaabaaaaaahcccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaadaaaaaaapaaaaaaaaaaaaajpcaabaaaafaaaaaa
fgafbaiaebaaaaaaabaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaa
agaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaaaaaaaajpcaabaaaahaaaaaa
agaabaiaebaaaaaaabaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaa
abaaaaaakgakbaiaebaaaaaaabaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaaj
pcaabaaaagaaaaaaegaobaaaahaaaaaaegaobaaaahaaaaaaegaobaaaagaaaaaa
dcaaaaajpcaabaaaagaaaaaaegaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
agaaaaaadcaaaaanpcaabaaaaiaaaaaaegaobaaaagaaaaaaegiocaaaacaaaaaa
afaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpeeaaaaafpcaabaaa
agaaaaaaegaobaaaagaaaaaaaoaaaaakpcaabaaaaiaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaaiaaaaaadiaaaaaihcaabaaaajaaaaaa
egacbaaaadaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaakaaaaaa
fgafbaaaajaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaajaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaajaaaaaaegaibaaaakaaaaaadcaaaaak
hcaabaaaajaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaajaaaaaaegadbaaa
ajaaaaaadiaaaaahpcaabaaaafaaaaaaegaobaaaafaaaaaafgafbaaaajaaaaaa
dcaaaaajpcaabaaaafaaaaaaegaobaaaahaaaaaaagaabaaaajaaaaaaegaobaaa
afaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaakgakbaaaajaaaaaa
egaobaaaafaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaagaaaaaaegaobaaa
abaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaaiaaaaaa
egaobaaaabaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaabaaaaaaegiccaaa
acaaaaaaahaaaaaadcaaaaakhcaabaaaafaaaaaaegiccaaaacaaaaaaagaaaaaa
agaabaaaabaaaaaaegacbaaaafaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaafaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaajaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaafaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaajaaaaaabbaaaaaiccaabaaaafaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaajaaaaaabbaaaaaiecaabaaaafaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaajaaaaaadiaaaaahpcaabaaaagaaaaaa
jgacbaaaajaaaaaaegakbaaaajaaaaaabbaaaaaibcaabaaaahaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaagaaaaaabbaaaaaiccaabaaaahaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaagaaaaaabbaaaaaiecaabaaaahaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaagaaaaaaaaaaaaahhcaabaaaafaaaaaaegacbaaa
afaaaaaaegacbaaaahaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaajaaaaaa
bkaabaaaajaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaajaaaaaaakaabaaa
ajaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaaafaaaaaaegiccaaa
acaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaafaaaaaaaaaaaaahhccabaaa
ahaaaaaaegacbaaaabaaaaaaegacbaaaafaaaaaadiaaaaajhcaabaaaabaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaa
abaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
abaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaah
bccabaaaaiaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaa
aiaaaaaaegacbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaiaaaaaa
egacbaaaaeaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_15;
  tmpvar_15 = (gl_ModelViewProjectionMatrix * tmpvar_12);
  vec3 tmpvar_16;
  vec3 tmpvar_17;
  tmpvar_16 = tmpvar_2.xyz;
  tmpvar_17 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_16.x;
  tmpvar_18[0].y = tmpvar_17.x;
  tmpvar_18[0].z = tmpvar_14.x;
  tmpvar_18[1].x = tmpvar_16.y;
  tmpvar_18[1].y = tmpvar_17.y;
  tmpvar_18[1].z = tmpvar_14.y;
  tmpvar_18[2].x = tmpvar_16.z;
  tmpvar_18[2].y = tmpvar_17.z;
  tmpvar_18[2].z = tmpvar_14.z;
  vec3 v_19;
  v_19.x = _Object2World[0].x;
  v_19.y = _Object2World[1].x;
  v_19.z = _Object2World[2].x;
  vec3 v_20;
  v_20.x = _Object2World[0].y;
  v_20.y = _Object2World[1].y;
  v_20.z = _Object2World[2].y;
  vec3 v_21;
  v_21.x = _Object2World[0].z;
  v_21.y = _Object2World[1].z;
  v_21.z = _Object2World[2].z;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_14 * unity_Scale.w));
  vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_23;
  vec3 x2_26;
  vec3 x1_27;
  x1_27.x = dot (unity_SHAr, tmpvar_25);
  x1_27.y = dot (unity_SHAg, tmpvar_25);
  x1_27.z = dot (unity_SHAb, tmpvar_25);
  vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_23.xyzz * tmpvar_23.yzzx);
  x2_26.x = dot (unity_SHBr, tmpvar_28);
  x2_26.y = dot (unity_SHBg, tmpvar_28);
  x2_26.z = dot (unity_SHBb, tmpvar_28);
  vec3 tmpvar_29;
  tmpvar_29 = (_Object2World * tmpvar_12).xyz;
  vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosX0 - tmpvar_29.x);
  vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosY0 - tmpvar_29.y);
  vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosZ0 - tmpvar_29.z);
  vec4 tmpvar_33;
  tmpvar_33 = (((tmpvar_30 * tmpvar_30) + (tmpvar_31 * tmpvar_31)) + (tmpvar_32 * tmpvar_32));
  vec4 tmpvar_34;
  tmpvar_34 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_30 * tmpvar_23.x) + (tmpvar_31 * tmpvar_23.y)) + (tmpvar_32 * tmpvar_23.z)) * inversesqrt(tmpvar_33))) * (1.0/((1.0 + (tmpvar_33 * unity_4LightAtten0)))));
  vec4 o_35;
  vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_15 * 0.5);
  vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_15.zw;
  gl_Position = tmpvar_15;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = ((tmpvar_18 * v_19) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_18 * v_20) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_18 * v_21) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_18 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1_27 + x2_26) + (unity_SHC.xyz * ((tmpvar_23.x * tmpvar_23.x) - (tmpvar_23.y * tmpvar_23.y)))) + ((((unity_LightColor[0].xyz * tmpvar_34.x) + (unity_LightColor[1].xyz * tmpvar_34.y)) + (unity_LightColor[2].xyz * tmpvar_34.z)) + (unity_LightColor[3].xyz * tmpvar_34.w)));
  xlv_TEXCOORD6 = (tmpvar_18 * (((_World2Object * tmpvar_24).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD7 = o_35;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 v_4;
  v_4.x = SkyMatrix[0].x;
  v_4.y = SkyMatrix[1].x;
  v_4.z = SkyMatrix[2].x;
  v_4.w = SkyMatrix[3].x;
  vec4 v_5;
  v_5.x = SkyMatrix[0].y;
  v_5.y = SkyMatrix[1].y;
  v_5.z = SkyMatrix[2].y;
  v_5.w = SkyMatrix[3].y;
  vec4 v_6;
  v_6.x = SkyMatrix[0].z;
  v_6.y = SkyMatrix[1].z;
  v_6.z = SkyMatrix[2].z;
  v_6.w = SkyMatrix[3].z;
  vec3 tmpvar_7;
  tmpvar_7 = (((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, ((v_4.xyz * dot (xlv_TEXCOORD1, normal_3)) + ((v_5.xyz * dot (xlv_TEXCOORD2, normal_3)) + (v_6.xyz * dot (xlv_TEXCOORD3, normal_3)))));
  float tmpvar_9;
  tmpvar_9 = (tmpvar_8.w * tmpvar_8.w);
  vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (tmpvar_8.w * tmpvar_9);
  vec4 c_11;
  c_11.xyz = (((tmpvar_7 * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD4))) * (texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0));
  c_11.w = tmpvar_2.w;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_7 * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((tmpvar_8.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * tmpvar_7) * ExposureIBL.x));
  vec4 color_12;
  color_12.w = c_1.w;
  color_12.xyz = pow (c_1.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_13;
  tmpvar_13 = (color_12 * 0.166667);
  color_12 = tmpvar_13;
  float tmpvar_14;
  tmpvar_14 = (ceil((clamp (max (max (tmpvar_13.x, tmpvar_13.y), tmpvar_13.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_14 > 0.0)) {
    color_12.xyz = clamp ((tmpvar_13.xyz * (1.0/(tmpvar_14))), 0.0, 1.0);
    color_12.w = tmpvar_14;
  } else {
    color_12 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_12.xyz = pow (color_12.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_12;
  gl_FragData[0] = color_12;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_ScreenParams]
Vector 16 [_WorldSpaceLightPos0]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [unity_Scale]
Vector 33 [_Scale]
Vector 34 [_SquashPlaneNormal]
Float 35 [_SquashAmount]
Vector 36 [_Wind]
Vector 37 [_MainTex_ST]
"vs_3_0
; 137 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
dcl_texcoord6 o8
dcl_texcoord7 o9
def c38, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c39, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c40, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c41, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c38.x, r0
add r0.x, v5, r0
add r0.w, v5.y, r0.x
mov r1.y, r0.x
mul r0.xyz, v0, c33
dp3 r1.x, r0, r0.w
add r1.xy, r1, c12.y
mul r1, r1.xxyy, c39
frc r1, r1
mad r1, r1, c38.y, c38.z
frc r1, r1
mad r1, r1, c38.y, c38.w
abs r2, r1
mad r1, -r2, c40.x, c40.y
mul r2, r2, r2
mul r1, r2, r1
add r2.xy, r1.xzzw, r1.ywzw
mul r1.xyz, r2.y, c36
mul r3.xyz, v4.y, r1
mul r0.w, v5.y, c40
mov r1.w, c38.x
mul r1.xz, r0.w, v2
mul r1.y, v4, c40.z
mad r1.xyz, r2.xyxw, r1, r3
mad r0.xyz, r1, c36.w, r0
mad r0.xyz, v4.x, c36, r0
dp3 r0.w, r0, c34
add r0.w, r0, c34
mul r1.xyz, r0.w, c34
add r0.xyz, -r1, r0
mad r1.xyz, r1, c35.x, r0
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
add r3, -r0.y, c18
add r2, -r0.x, c17
mul r0, r3, r3
mad r4, r2, r2, r0
dp3 r5.x, v2, v2
rsq r0.x, r5.x
mul r6.xyz, r0.x, v2
mul r7.xyz, r6, c32.w
dp3 r6.w, r7, c5
dp4 r0.y, r1, c6
add r0, -r0.y, c19
mad r4, r0, r0, r4
dp3 r7.w, r7, c4
mul r3, r6.w, r3
mad r2, r7.w, r2, r3
dp3 r3.w, r7, c6
mad r0, r3.w, r0, r2
mul r5, r4, c20
mov r7.x, r6.w
mov r7.y, r3.w
mov r7.z, c38.x
rsq r2.x, r4.x
rsq r2.y, r4.y
rsq r2.z, r4.z
rsq r2.w, r4.w
mul r0, r0, r2
add r2, r5, c38.x
dp4 r5.z, r7.wxyz, c27
dp4 r5.y, r7.wxyz, c26
dp4 r5.x, r7.wxyz, c25
rcp r2.x, r2.x
rcp r2.y, r2.y
rcp r2.w, r2.w
rcp r2.z, r2.z
max r0, r0, c41.x
mul r0, r0, r2
mul r2.xyz, r0.y, c22
mad r2.xyz, r0.x, c21, r2
mad r0.xyz, r0.z, c23, r2
mad r3.xyz, r0.w, c24, r0
mul r0, r7.wxyy, r7.xyyw
mul r2.z, r6.w, r6.w
dp4 r2.w, r1, c3
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r4.xyz, r2.xyww, c41.y
dp4 r7.z, r0, c30
dp4 r7.y, r0, c29
dp4 r7.x, r0, c28
mad r2.z, r7.w, r7.w, -r2
mul r0.xyz, r2.z, c31
dp4 r2.z, r1, c2
add r5.xyz, r5, r7
add r0.xyz, r5, r0
add o7.xyz, r0, r3
mov r0.x, r4
mul r0.y, r4, c14.x
mad o9.xy, r4.z, c15.zwzw, r0
dp3 r0.z, v1, v1
rsq r0.x, r0.z
mul r0.xyz, r0.x, v1
mul r3.xyz, r6.zxyw, r0.yzxw
mad r3.xyz, r6.yzxw, r0.zxyw, -r3
mul r3.xyz, r3, v1.w
mov o0, r2
mov o9.zw, r2
mov r2.xyz, c13
mov r2.w, c38.x
dp4 r4.z, r2, c10
dp4 r4.x, r2, c8
dp4 r4.y, r2, c9
mad r1.xyz, r4, c32.w, -r1
dp3 o8.z, r6, r1
dp3 o8.y, r3, r1
dp3 o8.x, r0, r1
dp3 r1.y, r3, c4
dp3 r1.x, r0, c4
dp3 r1.z, r6, c4
mul o3.xyz, r1, c32.w
dp3 r1.y, r3, c5
dp3 r1.x, r0, c5
dp3 r1.z, r6, c5
mul o4.xyz, r1, c32.w
mov r1, c10
dp4 r4.z, c16, r1
mov r1, c9
dp4 r4.y, c16, r1
dp3 r2.y, r3, c6
dp3 r2.x, r0, c6
dp3 r2.z, r6, c6
mul o5.xyz, r2, c32.w
mov r2, c8
dp4 r4.x, c16, r2
dp3 o6.y, r3, r4
dp3 o6.z, r6, r4
dp3 o6.x, r0, r4
mov o2.xyz, c38.x
mad o1.xy, v3, c37, c37.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefieceddnegmolnijkfoknmhcbpkddhfnjookdgabaaaaaakabdaaaaadaaaaaa
cmaaaaaapeaaaaaabaacaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheobeabaaaaakaaaaaa
aiaaaaaapiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaaeabaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaanabaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaaeabaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaaeabaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaaeabaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaaeabaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaaeabaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaaaeabaaaaagaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaiaaaaaeabaaaa
ahaaaaaaaaaaaaaaadaaaaaaajaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciibbaaaaeaaaabaagcaeaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagfaaaaadhccabaaaahaaaaaagfaaaaad
hccabaaaaiaaaaaagfaaaaadpccabaaaajaaaaaagiaaaaacamaaaaaadgaaaaag
bcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaa
dkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaa
aoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaa
akbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
afaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaa
afaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaa
aaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaa
diaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldp
aaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaa
egaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaea
aaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
egaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaa
diaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaah
ccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaa
adaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaa
abeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaahaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
agbabaaaaeaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaaaaaaaaabaaaaaai
icaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
icaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaal
hcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
adaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
aaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaa
dgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
dgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaadgaaaaagbcaabaaaacaaaaaa
akiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaacaaaaaaakiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaacaaaaaaakiacaaaadaaaaaaaoaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaadaaaaaapgapbaaaaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaahhcaabaaaafaaaaaa
jgaebaaaadaaaaaacgajbaaaaeaaaaaadcaaaaakhcaabaaaafaaaaaajgaebaaa
aeaaaaaacgajbaaaadaaaaaaegacbaiaebaaaaaaafaaaaaadiaaaaahhcaabaaa
afaaaaaaegacbaaaafaaaaaapgbpbaaaabaaaaaabaaaaaahccaabaaaagaaaaaa
egacbaaaafaaaaaaegacbaaaacaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaadiaaaaaihccabaaaadaaaaaaegacbaaaagaaaaaapgipcaaa
adaaaaaabeaaaaaadgaaaaagbcaabaaaacaaaaaabkiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaacaaaaaabkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
acaaaaaabkiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaa
adaaaaaaegacbaaaacaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaa
beaaaaaadgaaaaagbcaabaaaacaaaaaackiacaaaadaaaaaaamaaaaaadgaaaaag
ccaabaaaacaaaaaackiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaacaaaaaa
ckiacaaaadaaaaaaaoaaaaaabaaaaaahbcaabaaaagaaaaaaegacbaaaadaaaaaa
egacbaaaacaaaaaabaaaaaahccaabaaaagaaaaaaegacbaaaafaaaaaaegacbaaa
acaaaaaabaaaaaahecaabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
diaaaaaihccabaaaafaaaaaaegacbaaaagaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaajhcaabaaaacaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
acaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahbccabaaaagaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaabaaaaaaheccabaaaagaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaa
baaaaaahcccabaaaagaaaaaaegacbaaaafaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaaaaaaaaajpcaabaaaagaaaaaafgafbaiaebaaaaaa
acaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaahaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaaaaaaaajpcaabaaaaiaaaaaaagaabaiaebaaaaaa
acaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaaacaaaaaakgakbaia
ebaaaaaaacaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaahaaaaaa
egaobaaaaiaaaaaaegaobaaaaiaaaaaaegaobaaaahaaaaaadcaaaaajpcaabaaa
ahaaaaaaegaobaaaacaaaaaaegaobaaaacaaaaaaegaobaaaahaaaaaadcaaaaan
pcaabaaaajaaaaaaegaobaaaahaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpeeaaaaafpcaabaaaahaaaaaaegaobaaa
ahaaaaaaaoaaaaakpcaabaaaajaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaajaaaaaadiaaaaaihcaabaaaakaaaaaaegacbaaaaeaaaaaa
pgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaalaaaaaafgafbaaaakaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaakaaaaaaegiicaaaadaaaaaa
amaaaaaaagaabaaaakaaaaaaegaibaaaalaaaaaadcaaaaakhcaabaaaakaaaaaa
egiccaaaadaaaaaaaoaaaaaakgakbaaaakaaaaaaegadbaaaakaaaaaadiaaaaah
pcaabaaaagaaaaaaegaobaaaagaaaaaafgafbaaaakaaaaaadcaaaaajpcaabaaa
agaaaaaaegaobaaaaiaaaaaaagaabaaaakaaaaaaegaobaaaagaaaaaadcaaaaaj
pcaabaaaacaaaaaaegaobaaaacaaaaaakgakbaaaakaaaaaaegaobaaaagaaaaaa
diaaaaahpcaabaaaacaaaaaaegaobaaaahaaaaaaegaobaaaacaaaaaadeaaaaak
pcaabaaaacaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaaegaobaaaajaaaaaaegaobaaaacaaaaaa
diaaaaaihcaabaaaagaaaaaafgafbaaaacaaaaaaegiccaaaacaaaaaaahaaaaaa
dcaaaaakhcaabaaaagaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaacaaaaaa
egacbaaaagaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
kgakbaaaacaaaaaaegacbaaaagaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
acaaaaaaajaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaa
akaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaagaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaakaaaaaabbaaaaaiccaabaaaagaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaakaaaaaabbaaaaaiecaabaaaagaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaakaaaaaadiaaaaahpcaabaaaahaaaaaajgacbaaaakaaaaaa
egakbaaaakaaaaaabbaaaaaibcaabaaaaiaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaahaaaaaabbaaaaaiccaabaaaaiaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaahaaaaaabbaaaaaiecaabaaaaiaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaahaaaaaaaaaaaaahhcaabaaaagaaaaaaegacbaaaagaaaaaaegacbaaa
aiaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaakaaaaaabkaabaaaakaaaaaa
dcaaaaakicaabaaaaaaaaaaaakaabaaaakaaaaaaakaabaaaakaaaaaadkaabaia
ebaaaaaaaaaaaaaadcaaaaakhcaabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaaaaaaaaaegacbaaaagaaaaaaaaaaaaahhccabaaaahaaaaaaegacbaaa
acaaaaaaegacbaaaagaaaaaadiaaaaajhcaabaaaacaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaadcaaaaal
hcaabaaaacaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaiaaaaaa
egacbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaaiaaaaaaegacbaaa
aeaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaiaaaaaaegacbaaaafaaaaaa
egacbaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaabkaabaaaabaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaadpdiaaaaakfcaabaaaaaaaaaaaagadbaaaabaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaaaadgaaaaafmccabaaaajaaaaaakgaobaaaabaaaaaa
aaaaaaahdccabaaaajaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
"ps_3_0
; 36 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.16666667, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c7.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3_pp r0.x, r1, v4
texld r2.xyz, v0, s0
mul_pp r2.xyz, r2, c5
dp3_pp r0.w, r1, v3
mul r0.xyz, r0.x, c2
mad r0.xyz, r0.w, c1, r0
dp3_pp r0.w, v2, r1
mad r0.xyz, r0.w, c0, r0
dp3_pp r0.w, r1, v5
mul_pp r2.xyz, r2, v1.w
mul_pp r1.xyz, r2, c6.w
mul_pp r2.xyz, r1, c4
max_pp r0.w, r0, c7
mul_pp r2.xyz, r2, r0.w
texld r0, r0, s2
mul_pp r0.xyz, r0, r0.w
mul r2.xyz, r2, c7.x
mul_pp r0.xyz, r0, r1
mad_pp r2.xyz, r1, v6, r2
mad_pp r0.xyz, r0, c6.x, r2
mul r0.xyz, r0, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
cmp r1.x, -r0.w, c7.w, c7.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_DiffCubeIBL] CUBE 0
ConstBuffer "$Globals" 224
Matrix 128 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmlgejpkkaaokneioocpojjpogelnefehabaaaaaajmahaaaaadaaaaaa
cmaaaaaadaabaaaageabaaaaejfdeheopmaaaaaaajaaaaaaaiaaaaaaoaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaapfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaomaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaomaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaomaaaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaaomaaaaaa
agaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklklfdeieefcdaagaaaaeaaaaaaaimabaaaafjaaaaaeegiocaaaaaaaaaaa
alaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gcbaaaadhcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaa
aaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaaiaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaajaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaakaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
akaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaagaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaaibcaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadiaaaaaiccaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaajaaaaaadiaaaaaiecaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaahocaabaaaaaaaaaaa
agajbaaaabaaaaaaagajbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaajgahbaaa
aaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaa
pgapbaaaabaaaaaaagajbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagajbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaahaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgahbaaaaaaaaaaaagiacaaa
aaaaaaaaahaaaaaaegacbaaaabaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaah
icaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaa
dicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaah
pccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 37 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.16666667, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
dcl_texcoord7 v8
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c7.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
texld r0.xyz, v0, s0
mul_pp r2.xyz, r0, c5
dp3_pp r0.w, r1, v4
mul r0.xyz, r0.w, c2
dp3_pp r0.w, r1, v3
mad r0.xyz, r0.w, c1, r0
dp3_pp r0.w, v2, r1
dp3_pp r1.y, r1, v5
texldp r1.x, v8, s3
mul_pp r2.xyz, r2, v1.w
mul_pp r2.xyz, r2, c6.w
mad r0.xyz, r0.w, c0, r0
texld r0, r0, s2
mul_pp r0.xyz, r0, r0.w
mul_pp r1.w, r1.x, c7.x
mul_pp r3.xyz, r2, c4
max_pp r1.y, r1, c7.w
mul_pp r1.xyz, r3, r1.y
mul r1.xyz, r1, r1.w
mad_pp r1.xyz, r2, v6, r1
mul_pp r0.xyz, r0, r2
mad_pp r0.xyz, r0, c6.x, r1
mul r0.xyz, r0, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
cmp r1.x, -r0.w, c7.w, c7.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_BumpMap] 2D 3
SetTexture 2 [_DiffCubeIBL] CUBE 1
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 288
Matrix 192 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkaohaikpkdogpefekmmcibpgjddmmffcabaaaaaadiaiaaaaadaaaaaa
cmaaaaaaeiabaaaahmabaaaaejfdeheobeabaaaaakaaaaaaaiaaaaaapiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaaeabaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaanabaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaaeabaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaaeabaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaaeabaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaaeabaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaaeabaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaaaeabaaaa
agaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaaaaaaaeabaaaaahaaaaaaaaaaaaaa
adaaaaaaajaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
leagaaaaeaaaaaaaknabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadicbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagcbaaaadhcbabaaaahaaaaaa
gcbaaaadlcbabaaaajaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
adaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaa
aaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaamaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaanaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaaoaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
amaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
anaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aoaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaagaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaaibcaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaadiaaaaaiccaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaanaaaaaadiaaaaaiecaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaaaaaaaahocaabaaaaaaaaaaa
agajbaaaabaaaaaaagajbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaajgahbaaa
aaaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaa
pgapbaaaabaaaaaaagajbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaiaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaaaaaaaaaalaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagajbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egbcbaaaahaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaaaoaaaaahdcaabaaaadaaaaaaegbabaaaajaaaaaapgbpbaaaajaaaaaa
efaaaaajpcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaadaaaaaaakaabaaaadaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaajgahbaaaaaaaaaaaagiacaaaaaaaaaaa
alaaaaaaegacbaaaabaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaa
aaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaah
hcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaa
aaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
"ps_3_0
; 65 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.75341797, 0.24682617, 0.45454544, 0.16666667
def c9, 255.00000000, 0.00392157, 2.20000005, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
texld r0.yw, v0, s1
mad_pp r2.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.xy, r2, r2
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c7.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, v4
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c5
mul_pp r1.xyz, r1, v1.w
mul_pp r1.xyz, r1, c6.w
dp3_pp r0.w, r2, v3
mul r0.xyz, r0.x, c2
mad r0.xyz, r0.w, c1, r0
dp3_pp r0.w, v2, r2
mad r0.xyz, r0.w, c0, r0
texld r0, r0, s2
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
dp3_pp r0.w, r2, v5
max_pp r0.w, r0, c7
mul_pp r2.xyz, r1, c4
mul_pp r2.xyz, r2, r0.w
mul_pp r3.xy, r3, c8
add_pp r0.w, r3.x, r3.y
mul_pp r0.xyz, r0, r0.w
mul r2.xyz, r2, c7.x
mul_pp r0.xyz, r0, r1
mad_pp r2.xyz, r1, v6, r2
mad_pp r1.xyz, r0, c6.x, r2
pow r0, r1.x, c8.z
pow r2, r1.y, c8.z
mov r1.x, r0
pow r0, r1.z, c8.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c9.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c9.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c7.w, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.w, r0
pow r0, r1.x, c9.z
mov oC0.x, r0
pow r0, r1.y, c9.z
pow r2, r1.z, c9.z
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_DiffCubeIBL] CUBE 0
ConstBuffer "$Globals" 224
Matrix 128 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkalfdlnbdgflpkgijkjnjonhpbmfiaobabaaaaaapeaiaaaaadaaaaaa
cmaaaaaadaabaaaageabaaaaejfdeheopmaaaaaaajaaaaaaaiaaaaaaoaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaomaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaapfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaomaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaomaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaomaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaomaaaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaomaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaaomaaaaaa
agaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklklfdeieefciiahaaaaeaaaaaaaocabaaaafjaaaaaeegiocaaaaaaaaaaa
alaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gcbaaaadhcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaa
aaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaaiaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaajaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaakaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
akaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaagaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaaibcaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadiaaaaaiccaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaajaaaaaadiaaaaaiecaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaahocaabaaaaaaaaaaa
agajbaaaabaaaaaaagajbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaajgahbaaa
aaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaacaaaaaa
dkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaa
abaaaaaaakaabaaaacaaaaaaapaaaaakccaabaaaaaaaaaaaaceaaaaalhnbeadp
celjhmdoaaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahocaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagajbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagajbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaaaaaaaaaa
egacbaaaacaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaahaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgahbaaaaaaaaaaaagiacaaa
aaaaaaaaahaaaaaaegacbaaaabaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoido
cplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaa
abaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaaf
hccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 66 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.75341797, 0.24682617, 0.45454544, 0.16666667
def c9, 255.00000000, 0.00392157, 2.20000005, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
dcl_texcoord7 v8
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c7.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3_pp r0.x, r1, v4
mul r2.xyz, r0.x, c2
dp3_pp r0.x, r1, v3
mad r2.xyz, r0.x, c1, r2
dp3_pp r0.x, v2, r1
dp3_pp r1.y, r1, v5
mad r0.xyz, r0.x, c0, r2
texld r0, r0, s2
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
mul_pp r3.xy, r3, c8
add_pp r0.w, r3.x, r3.y
texldp r1.x, v8, s3
texld r2.xyz, v0, s0
mul_pp r2.xyz, r2, c5
mul_pp r2.xyz, r2, v1.w
mul_pp r2.xyz, r2, c6.w
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r0, r2
mul_pp r1.w, r1.x, c7.x
mul_pp r3.xyz, r2, c4
max_pp r1.y, r1, c7.w
mul_pp r1.xyz, r3, r1.y
mul r1.xyz, r1, r1.w
mad_pp r1.xyz, r2, v6, r1
mad_pp r1.xyz, r0, c6.x, r1
pow r0, r1.x, c8.z
pow r2, r1.y, c8.z
mov r1.x, r0
pow r0, r1.z, c8.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c9.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c9.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c7.w, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.w, r0
pow r0, r1.x, c9.z
mov oC0.x, r0
pow r0, r1.y, c9.z
pow r2, r1.z, c9.z
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_BumpMap] 2D 3
SetTexture 2 [_DiffCubeIBL] CUBE 1
SetTexture 3 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 288
Matrix 192 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkcinjomfekmihbekeafegaokcmcmeailabaaaaaajaajaaaaadaaaaaa
cmaaaaaaeiabaaaahmabaaaaejfdeheobeabaaaaakaaaaaaaiaaaaaapiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaaeabaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaanabaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaaeabaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaaeabaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaaeabaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaaeabaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaaeabaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaaaeabaaaa
agaaaaaaaaaaaaaaadaaaaaaaiaaaaaaahaaaaaaaeabaaaaahaaaaaaaaaaaaaa
adaaaaaaajaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
amaiaaaaeaaaaaaaadacaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadicbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagcbaaaadhcbabaaaahaaaaaa
gcbaaaadlcbabaaaajaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
adaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaa
aaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaamaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaanaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaabkiacaaa
aaaaaaaaaoaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
amaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
anaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aoaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaagaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaaibcaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaadiaaaaaiccaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaanaaaaaadiaaaaaiecaabaaaacaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaaaaaaaahocaabaaaaaaaaaaa
agajbaaaabaaaaaaagajbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaajgahbaaa
aaaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaacaaaaaa
dkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahccaabaaaacaaaaaadkaabaaa
abaaaaaaakaabaaaacaaaaaaapaaaaakccaabaaaaaaaaaaaaceaaaaalhnbeadp
celjhmdoaaaaaaaaaaaaaaaaegaabaaaacaaaaaadiaaaaahocaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagajbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaiaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaapgipcaaaaaaaaaaaalaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagajbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egbcbaaaahaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaaaoaaaaahdcaabaaaadaaaaaaegbabaaaajaaaaaapgbpbaaaajaaaaaa
efaaaaajpcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaadaaaaaaakaabaaaadaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaajgahbaaaaaaaaaaaagiacaaaaaaaaaaa
alaaaaaaegacbaaaabaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoidocplkoido
cplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdo
aaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaa
deaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
ibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaa
aoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
dkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
acaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaa
pgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaafhccabaaa
aaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "RenderType"="TreeBark" }
  ZWrite Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
Program "vp" {
SubProgram "opengl " {
Keywords { "POINT" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, normalize(xlv_TEXCOORD1)))) * (texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  vec4 tmpvar_6;
  tmpvar_6 = (c_1 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r0.xyz, v4.x, c23, r0
dp3 r0.w, r0, c21
add r0.w, r0, c21
mul r1.xyz, r0.w, c21
add r0.xyz, -r1, r0
mad r2.xyz, r1, c22.x, r0
dp4 r0.w, r2, c7
dp4 r0.z, r2, c6
dp4 r0.x, r2, c4
dp4 r0.y, r2, c5
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r4.xyz, r0.y, v1
mul r3.xyz, r0.x, v2
mul r1.xyz, r3.zxyw, r4.yzxw
mad r5.xyz, r3.yzxw, r4.zxyw, -r1
mov r0, c10
dp4 r6.z, c18, r0
mov r0, c9
dp4 r6.y, c18, r0
mov r1, c8
dp4 r6.x, c18, r1
mad r1.xyz, r6, c19.w, -r2
mul r5.xyz, r5, v1.w
mov r0.xyz, c17
mov r0.w, c25.x
dp4 r6.z, r0, c10
dp4 r6.x, r0, c8
dp4 r6.y, r0, c9
mad r0.xyz, r6, c19.w, -r2
dp4 o0.w, r2, c3
dp4 o0.z, r2, c2
dp4 o0.y, r2, c1
dp4 o0.x, r2, c0
dp3 o3.z, r3, r1
dp3 o3.y, r1, r5
dp3 o3.x, r1, r4
dp3 o4.z, r3, r0
dp3 o4.y, r5, r0
dp3 o4.x, r4, r0
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedbbpnnhagllldeocaijhgjhallojgnkefabaaaaaadiamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaknaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciaakaaaaeaaaabaakaacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadgaaaaai
hccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaf
iccabaaaacaaaaaadkbabaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaaeaaaaaa
jgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaaaeaaaaaajgaebaaa
adaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaaeaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD1))) * 2.0);
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  vec4 tmpvar_6;
  tmpvar_6 = (c_1 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_Scale]
Vector 16 [_Scale]
Vector 17 [_SquashPlaneNormal]
Float 18 [_SquashAmount]
Vector 19 [_Wind]
Vector 20 [_MainTex_ST]
"vs_3_0
; 70 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
def c21, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c22, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c23, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c21.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r4.w, c21.x
mul r2.xyz, v0, c16
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c12.y
mul r0, r0.xxyy, c22
frc r0, r0
mad r0, r0, c21.y, c21.z
frc r0, r0
mad r0, r0, c21.y, c21.w
abs r0, r0
mad r1, -r0, c23.x, c23.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c19
mul r0.x, v5.y, c23.w
mov r1.w, c21.x
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c23.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c19.w, r2
mad r1.xyz, v4.x, c19, r0
dp3 r0.x, r1, c17
add r0.x, r0, c17.w
mul r0.xyz, r0.x, c17
add r1.xyz, -r0, r1
mad r4.xyz, r0, c18.x, r1
mov r1.xyz, c13
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r3.xyz, r0.y, v1
mul r2.xyz, r0.x, v2
mul r0.xyz, r2.zxyw, r3.yzxw
dp4 r5.z, r1, c10
dp4 r5.x, r1, c8
dp4 r5.y, r1, c9
mad r1.xyz, r5, c15.w, -r4
mad r0.xyz, r2.yzxw, r3.zxyw, -r0
dp4 o0.w, r4, c3
dp4 o0.z, r4, c2
dp4 o0.y, r4, c1
dp4 o0.x, r4, c0
mul r4.xyz, r0, v1.w
mov r0, c10
dp4 r5.z, c14, r0
mov r0, c9
dp4 r5.y, c14, r0
dp3 o4.z, r2, r1
dp3 o4.y, r4, r1
dp3 o4.x, r3, r1
mov r1, c8
dp4 r5.x, c14, r1
dp3 o3.y, r5, r4
dp3 o3.z, r2, r5
dp3 o3.x, r5, r3
mov o2.xyz, c21.x
mad o1.xy, v3, c20, c20.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedlobcojcchflablngpccmkicgnnggleppabaaaaaamaakaaaaadaaaaaa
cmaaaaaapeaaaaaajiabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojmaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaajfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklfdeieefccaajaaaa
eaaaabaaeiacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaa
aaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
giaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
aaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaa
aaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaa
bkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaa
aaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
abaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaa
fgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalp
aaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaea
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaa
egaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaa
aaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaa
ngafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaa
bkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaa
mnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaa
dgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaa
igaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaaadaaaaaa
egacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaa
egacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaa
aeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaa
egiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
agiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
pcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaa
aaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaaabaaaaaa
egiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadgaaaaaihccabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaficcabaaa
acaaaaaadkbabaaaafaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
abaaaaaadiaaaaahhcaabaaaadaaaaaacgajbaaaabaaaaaajgaebaaaacaaaaaa
dcaaaaakhcaabaaaadaaaaaajgaebaaaabaaaaaacgajbaaaacaaaaaaegacbaia
ebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgbpbaaa
abaaaaaadiaaaaajhcaabaaaaeaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaadcaaaaalhcaabaaaaeaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaa
dcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaa
aaaaaaaaegacbaaaaeaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaadaaaaaa
egacbaaaaeaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaaacaaaaaaegacbaaa
aeaaaaaabaaaaaaheccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaaeaaaaaa
diaaaaajhcaabaaaaeaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
abaaaaaaaeaaaaaaegacbaaaaeaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaeaaaaaaaaaaaaai
hcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaal
hcaabaaaaaaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaia
ebaaaaaaaaaaaaaabaaaaaahbccabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaa
aaaaaaaabaaaaaaheccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
baaaaaahcccabaaaaeaaaaaaegacbaaaadaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, normalize(xlv_TEXCOORD1)))) * (((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz))).w) * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  vec4 tmpvar_6;
  tmpvar_6 = (c_1 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 79 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r0.xyz, v4.x, c23, r0
dp3 r0.w, r0, c21
add r0.w, r0, c21
mul r1.xyz, r0.w, c21
add r0.xyz, -r1, r0
mad r2.xyz, r1, c22.x, r0
dp4 r0.w, r2, c7
dp4 r0.z, r2, c6
dp4 r0.x, r2, c4
dp4 r0.y, r2, c5
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r4.xyz, r0.y, v1
mul r3.xyz, r0.x, v2
mul r1.xyz, r3.zxyw, r4.yzxw
mad r5.xyz, r3.yzxw, r4.zxyw, -r1
mov r0, c10
dp4 r6.z, c18, r0
mov r0, c9
dp4 r6.y, c18, r0
mov r1, c8
dp4 r6.x, c18, r1
mad r1.xyz, r6, c19.w, -r2
mul r5.xyz, r5, v1.w
mov r0.xyz, c17
mov r0.w, c25.x
dp4 r6.z, r0, c10
dp4 r6.x, r0, c8
dp4 r6.y, r0, c9
mad r0.xyz, r6, c19.w, -r2
dp4 o0.w, r2, c3
dp4 o0.z, r2, c2
dp4 o0.y, r2, c1
dp4 o0.x, r2, c0
dp3 o3.z, r3, r1
dp3 o3.y, r1, r5
dp3 o3.x, r1, r4
dp3 o4.z, r3, r0
dp3 o4.y, r5, r0
dp3 o4.x, r4, r0
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedojenhgibgafeknafheiadgemeefeeobdabaaaaaadiamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaknaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciaakaaaaeaaaabaakaacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadgaaaaai
hccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaf
iccabaaaacaaaaaadkbabaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaaeaaaaaa
jgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaaaeaaaaaajgaebaaa
adaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaaeaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaadiaaaaai
pcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, normalize(xlv_TEXCOORD1)))) * ((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w) * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  vec4 tmpvar_6;
  tmpvar_6 = (c_1 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r0.xyz, v4.x, c23, r0
dp3 r0.w, r0, c21
add r0.w, r0, c21
mul r1.xyz, r0.w, c21
add r0.xyz, -r1, r0
mad r2.xyz, r1, c22.x, r0
dp4 r0.w, r2, c7
dp4 r0.z, r2, c6
dp4 r0.x, r2, c4
dp4 r0.y, r2, c5
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r4.xyz, r0.y, v1
mul r3.xyz, r0.x, v2
mul r1.xyz, r3.zxyw, r4.yzxw
mad r5.xyz, r3.yzxw, r4.zxyw, -r1
mov r0, c10
dp4 r6.z, c18, r0
mov r0, c9
dp4 r6.y, c18, r0
mov r1, c8
dp4 r6.x, c18, r1
mad r1.xyz, r6, c19.w, -r2
mul r5.xyz, r5, v1.w
mov r0.xyz, c17
mov r0.w, c25.x
dp4 r6.z, r0, c10
dp4 r6.x, r0, c8
dp4 r6.y, r0, c9
mad r0.xyz, r6, c19.w, -r2
dp4 o0.w, r2, c3
dp4 o0.z, r2, c2
dp4 o0.y, r2, c1
dp4 o0.x, r2, c0
dp3 o3.z, r3, r1
dp3 o3.y, r1, r5
dp3 o3.x, r1, r4
dp3 o4.z, r3, r0
dp3 o4.y, r5, r0
dp3 o4.x, r4, r0
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedbbpnnhagllldeocaijhgjhallojgnkefabaaaaaadiamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaknaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciaakaaaaeaaaabaakaacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadgaaaaai
hccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaf
iccabaaaacaaaaaadkbabaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaaeaaaaaa
jgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaaaeaaaaaajgaebaaa
adaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaaeaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD1))) * (texture2D (_LightTexture0, xlv_TEXCOORD3).w * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  vec4 tmpvar_6;
  tmpvar_6 = (c_1 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 76 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r4.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mov r1.w, c25.x
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r1.xyz, v4.x, c23, r0
dp3 r0.x, r1, c21
add r0.x, r0, c21.w
mul r0.xyz, r0.x, c21
add r1.xyz, -r0, r1
mad r4.xyz, r0, c22.x, r1
mov r1.xyz, c17
dp4 r0.w, r4, c7
dp4 r0.z, r4, c6
dp4 r0.x, r4, c4
dp4 r0.y, r4, c5
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r3.xyz, r0.y, v1
mul r2.xyz, r0.x, v2
mul r0.xyz, r2.zxyw, r3.yzxw
dp4 r5.z, r1, c10
dp4 r5.x, r1, c8
dp4 r5.y, r1, c9
mad r1.xyz, r5, c19.w, -r4
mad r0.xyz, r2.yzxw, r3.zxyw, -r0
dp4 o0.w, r4, c3
dp4 o0.z, r4, c2
dp4 o0.y, r4, c1
dp4 o0.x, r4, c0
mul r4.xyz, r0, v1.w
mov r0, c10
dp4 r5.z, c18, r0
mov r0, c9
dp4 r5.y, c18, r0
dp3 o4.z, r2, r1
dp3 o4.y, r4, r1
dp3 o4.x, r3, r1
mov r1, c8
dp4 r5.x, c18, r1
dp3 o3.y, r5, r4
dp3 o3.z, r2, r5
dp3 o3.x, r5, r3
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedaghjbdnhijhpcjbnhjgekpmiepkpecmoabaaaaaaamamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefcfeakaaaaeaaaabaajfacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
adaaaaaaamaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
aaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaapaaaaaa
diaaaaaidcaabaaaacaaaaaafgafbaaaabaaaaaaegiacaaaaaaaaaaaaeaaaaaa
dcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaabaaaaaa
egaabaaaacaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
kgakbaaaabaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiecaaa
aaaaaaaaagaaaaaapgapbaaaabaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaadiaaaaahhcaabaaaadaaaaaacgajbaaa
abaaaaaajgaebaaaacaaaaaadcaaaaakhcaabaaaadaaaaaajgaebaaaabaaaaaa
cgajbaaaacaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaaeaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaeaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaa
dcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaaeaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbccabaaaadaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaabaaaaaaheccabaaaadaaaaaaegacbaaa
abaaaaaaegacbaaaaeaaaaaadiaaaaajhcaabaaaaeaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaeaaaaaadcaaaaal
hcaabaaaaeaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaeaaaaaaaaaaaaaihcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaeaaaaaapgipcaaa
adaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaeaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaaeaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, normalize(xlv_TEXCOORD1)))) * (texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  color_5.w = c_1.w;
  color_5.xyz = pow (c_4.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_6;
  tmpvar_6 = (color_5 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_5.xyz = pow (color_5.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r0.xyz, v4.x, c23, r0
dp3 r0.w, r0, c21
add r0.w, r0, c21
mul r1.xyz, r0.w, c21
add r0.xyz, -r1, r0
mad r2.xyz, r1, c22.x, r0
dp4 r0.w, r2, c7
dp4 r0.z, r2, c6
dp4 r0.x, r2, c4
dp4 r0.y, r2, c5
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r4.xyz, r0.y, v1
mul r3.xyz, r0.x, v2
mul r1.xyz, r3.zxyw, r4.yzxw
mad r5.xyz, r3.yzxw, r4.zxyw, -r1
mov r0, c10
dp4 r6.z, c18, r0
mov r0, c9
dp4 r6.y, c18, r0
mov r1, c8
dp4 r6.x, c18, r1
mad r1.xyz, r6, c19.w, -r2
mul r5.xyz, r5, v1.w
mov r0.xyz, c17
mov r0.w, c25.x
dp4 r6.z, r0, c10
dp4 r6.x, r0, c8
dp4 r6.y, r0, c9
mad r0.xyz, r6, c19.w, -r2
dp4 o0.w, r2, c3
dp4 o0.z, r2, c2
dp4 o0.y, r2, c1
dp4 o0.x, r2, c0
dp3 o3.z, r3, r1
dp3 o3.y, r1, r5
dp3 o3.x, r1, r4
dp3 o4.z, r3, r0
dp3 o4.y, r5, r0
dp3 o4.x, r4, r0
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedbbpnnhagllldeocaijhgjhallojgnkefabaaaaaadiamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaknaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciaakaaaaeaaaabaakaacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadgaaaaai
hccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaf
iccabaaaacaaaaaadkbabaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaaeaaaaaa
jgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaaaeaaaaaajgaebaaa
adaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaaeaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD1))) * 2.0);
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  color_5.w = c_1.w;
  color_5.xyz = pow (c_4.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_6;
  tmpvar_6 = (color_5 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_5.xyz = pow (color_5.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_Time]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_Scale]
Vector 16 [_Scale]
Vector 17 [_SquashPlaneNormal]
Float 18 [_SquashAmount]
Vector 19 [_Wind]
Vector 20 [_MainTex_ST]
"vs_3_0
; 70 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
def c21, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c22, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c23, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c21.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r4.w, c21.x
mul r2.xyz, v0, c16
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c12.y
mul r0, r0.xxyy, c22
frc r0, r0
mad r0, r0, c21.y, c21.z
frc r0, r0
mad r0, r0, c21.y, c21.w
abs r0, r0
mad r1, -r0, c23.x, c23.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c19
mul r0.x, v5.y, c23.w
mov r1.w, c21.x
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c23.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c19.w, r2
mad r1.xyz, v4.x, c19, r0
dp3 r0.x, r1, c17
add r0.x, r0, c17.w
mul r0.xyz, r0.x, c17
add r1.xyz, -r0, r1
mad r4.xyz, r0, c18.x, r1
mov r1.xyz, c13
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r3.xyz, r0.y, v1
mul r2.xyz, r0.x, v2
mul r0.xyz, r2.zxyw, r3.yzxw
dp4 r5.z, r1, c10
dp4 r5.x, r1, c8
dp4 r5.y, r1, c9
mad r1.xyz, r5, c15.w, -r4
mad r0.xyz, r2.yzxw, r3.zxyw, -r0
dp4 o0.w, r4, c3
dp4 o0.z, r4, c2
dp4 o0.y, r4, c1
dp4 o0.x, r4, c0
mul r4.xyz, r0, v1.w
mov r0, c10
dp4 r5.z, c14, r0
mov r0, c9
dp4 r5.y, c14, r0
dp3 o4.z, r2, r1
dp3 o4.y, r4, r1
dp3 o4.x, r3, r1
mov r1, c8
dp4 r5.x, c14, r1
dp3 o3.y, r5, r4
dp3 o3.z, r2, r5
dp3 o3.x, r5, r3
mov o2.xyz, c21.x
mad o1.xy, v3, c20, c20.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedlobcojcchflablngpccmkicgnnggleppabaaaaaamaakaaaaadaaaaaa
cmaaaaaapeaaaaaajiabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojmaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaajfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklfdeieefccaajaaaa
eaaaabaaeiacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaa
aaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
giaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaa
dgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaa
aaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaa
aaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaa
bkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaa
aaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
abaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaa
fgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalp
aaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaea
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaa
egaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaa
aaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaa
ngafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaa
bkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaa
mnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaa
dgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaa
igaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaaadaaaaaa
egacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaa
egacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaa
aeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaa
egiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
agiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
pcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaa
aaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaaabaaaaaa
egiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadgaaaaaihccabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaficcabaaa
acaaaaaadkbabaaaafaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
abaaaaaadiaaaaahhcaabaaaadaaaaaacgajbaaaabaaaaaajgaebaaaacaaaaaa
dcaaaaakhcaabaaaadaaaaaajgaebaaaabaaaaaacgajbaaaacaaaaaaegacbaia
ebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaapgbpbaaa
abaaaaaadiaaaaajhcaabaaaaeaaaaaafgifcaaaacaaaaaaaaaaaaaaegiccaaa
adaaaaaabbaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabaaaaaaa
agiacaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaadcaaaaalhcaabaaaaeaaaaaa
egiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaa
dcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabdaaaaaapgipcaaaacaaaaaa
aaaaaaaaegacbaaaaeaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaaadaaaaaa
egacbaaaaeaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaaacaaaaaaegacbaaa
aeaaaaaabaaaaaaheccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaaeaaaaaa
diaaaaajhcaabaaaaeaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaadaaaaaa
bbaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabaaaaaaaagiacaaa
abaaaaaaaeaaaaaaegacbaaaaeaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaa
adaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaeaaaaaaaaaaaaai
hcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaaadaaaaaabdaaaaaadcaaaaal
hcaabaaaaaaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaia
ebaaaaaaaaaaaaaabaaaaaahbccabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaa
aaaaaaaabaaaaaaheccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
baaaaaahcccabaaaaeaaaaaaegacbaaaadaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, normalize(xlv_TEXCOORD1)))) * (((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz))).w) * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  color_5.w = c_1.w;
  color_5.xyz = pow (c_4.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_6;
  tmpvar_6 = (color_5 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_5.xyz = pow (color_5.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 79 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r0.xyz, v4.x, c23, r0
dp3 r0.w, r0, c21
add r0.w, r0, c21
mul r1.xyz, r0.w, c21
add r0.xyz, -r1, r0
mad r2.xyz, r1, c22.x, r0
dp4 r0.w, r2, c7
dp4 r0.z, r2, c6
dp4 r0.x, r2, c4
dp4 r0.y, r2, c5
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r4.xyz, r0.y, v1
mul r3.xyz, r0.x, v2
mul r1.xyz, r3.zxyw, r4.yzxw
mad r5.xyz, r3.yzxw, r4.zxyw, -r1
mov r0, c10
dp4 r6.z, c18, r0
mov r0, c9
dp4 r6.y, c18, r0
mov r1, c8
dp4 r6.x, c18, r1
mad r1.xyz, r6, c19.w, -r2
mul r5.xyz, r5, v1.w
mov r0.xyz, c17
mov r0.w, c25.x
dp4 r6.z, r0, c10
dp4 r6.x, r0, c8
dp4 r6.y, r0, c9
mad r0.xyz, r6, c19.w, -r2
dp4 o0.w, r2, c3
dp4 o0.z, r2, c2
dp4 o0.y, r2, c1
dp4 o0.x, r2, c0
dp3 o3.z, r3, r1
dp3 o3.y, r1, r5
dp3 o3.x, r1, r4
dp3 o4.z, r3, r0
dp3 o4.y, r5, r0
dp3 o4.x, r4, r0
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedojenhgibgafeknafheiadgemeefeeobdabaaaaaadiamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaknaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciaakaaaaeaaaabaakaacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadgaaaaai
hccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaf
iccabaaaacaaaaaadkbabaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaaeaaaaaa
jgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaaaeaaaaaajgaebaaa
adaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaaeaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaadiaaaaai
pcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, normalize(xlv_TEXCOORD1)))) * ((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w) * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  color_5.w = c_1.w;
  color_5.xyz = pow (c_4.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_6;
  tmpvar_6 = (color_5 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_5.xyz = pow (color_5.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r0.xyz, v4.x, c23, r0
dp3 r0.w, r0, c21
add r0.w, r0, c21
mul r1.xyz, r0.w, c21
add r0.xyz, -r1, r0
mad r2.xyz, r1, c22.x, r0
dp4 r0.w, r2, c7
dp4 r0.z, r2, c6
dp4 r0.x, r2, c4
dp4 r0.y, r2, c5
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r4.xyz, r0.y, v1
mul r3.xyz, r0.x, v2
mul r1.xyz, r3.zxyw, r4.yzxw
mad r5.xyz, r3.yzxw, r4.zxyw, -r1
mov r0, c10
dp4 r6.z, c18, r0
mov r0, c9
dp4 r6.y, c18, r0
mov r1, c8
dp4 r6.x, c18, r1
mad r1.xyz, r6, c19.w, -r2
mul r5.xyz, r5, v1.w
mov r0.xyz, c17
mov r0.w, c25.x
dp4 r6.z, r0, c10
dp4 r6.x, r0, c8
dp4 r6.y, r0, c9
mad r0.xyz, r6, c19.w, -r2
dp4 o0.w, r2, c3
dp4 o0.z, r2, c2
dp4 o0.y, r2, c1
dp4 o0.x, r2, c0
dp3 o3.z, r3, r1
dp3 o3.y, r1, r5
dp3 o3.x, r1, r4
dp3 o4.z, r3, r0
dp3 o4.y, r5, r0
dp3 o4.x, r4, r0
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedbbpnnhagllldeocaijhgjhallojgnkefabaaaaaadiamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaknaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefciaakaaaaeaaaabaakaacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaabbaaaaaadgaaaaai
hccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaf
iccabaaaacaaaaaadkbabaaaafaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaa
abaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahbccabaaaadaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaaheccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaaeaaaaaa
jgaebaaaacaaaaaacgajbaaaadaaaaaadcaaaaakhcaabaaaaeaaaaaajgaebaaa
adaaaaaacgajbaaaacaaaaaaegacbaiaebaaaaaaaeaaaaaadiaaaaahhcaabaaa
aeaaaaaaegacbaaaaeaaaaaapgbpbaaaabaaaaaabaaaaaahcccabaaaadaaaaaa
egacbaaaaeaaaaaaegacbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaadaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaadaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaaeaaaaaa
egacbaaaadaaaaaaegacbaaaabaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaa
aeaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaai
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec3 tmpvar_11;
  tmpvar_11 = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
  tmpvar_1 = tmpvar_12;
  vec4 tmpvar_13;
  tmpvar_13.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_13.w = gl_Color.w;
  vec3 tmpvar_14;
  tmpvar_14 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_14.yzx * tmpvar_2.zxy) - (tmpvar_14.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_14.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_14.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_14.z;
  vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_12);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_13;
  xlv_TEXCOORD1 = (tmpvar_17 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_17 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - tmpvar_11));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * tmpvar_12)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 c_4;
  c_4.xyz = ((((((tmpvar_2.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w) * _LightColor0.xyz) * max (0.0, dot (normal_3, xlv_TEXCOORD1))) * (texture2D (_LightTexture0, xlv_TEXCOORD3).w * 2.0));
  c_4.w = tmpvar_2.w;
  c_1.xyz = c_4.xyz;
  c_1.w = 0.0;
  vec4 color_5;
  color_5.w = c_1.w;
  color_5.xyz = pow (c_4.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_6;
  tmpvar_6 = (color_5 * 0.166667);
  color_5 = tmpvar_6;
  float tmpvar_7;
  tmpvar_7 = (ceil((clamp (max (max (tmpvar_6.x, tmpvar_6.y), tmpvar_6.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_7 > 0.0)) {
    color_5.xyz = clamp ((tmpvar_6.xyz * (1.0/(tmpvar_7))), 0.0, 1.0);
    color_5.w = tmpvar_7;
  } else {
    color_5 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_5.xyz = pow (color_5.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_5;
  gl_FragData[0] = color_5;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_Time]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
Vector 20 [_Scale]
Vector 21 [_SquashPlaneNormal]
Float 22 [_SquashAmount]
Vector 23 [_Wind]
Vector 24 [_MainTex_ST]
"vs_3_0
; 76 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
def c25, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c26, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c27, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c25.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r4.w, c25.x
mul r2.xyz, v0, c20
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c16.y
mul r0, r0.xxyy, c26
frc r0, r0
mad r0, r0, c25.y, c25.z
frc r0, r0
mad r0, r0, c25.y, c25.w
abs r0, r0
mad r1, -r0, c27.x, c27.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r1.xyz, r3.y, c23
mul r0.x, v5.y, c27.w
mov r1.w, c25.x
mul r1.xyz, v4.y, r1
mul r0.xz, r0.x, v2
mul r0.y, v4, c27.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c23.w, r2
mad r1.xyz, v4.x, c23, r0
dp3 r0.x, r1, c21
add r0.x, r0, c21.w
mul r0.xyz, r0.x, c21
add r1.xyz, -r0, r1
mad r4.xyz, r0, c22.x, r1
mov r1.xyz, c17
dp4 r0.w, r4, c7
dp4 r0.z, r4, c6
dp4 r0.x, r4, c4
dp4 r0.y, r4, c5
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
rsq r0.x, r0.x
mul r3.xyz, r0.y, v1
mul r2.xyz, r0.x, v2
mul r0.xyz, r2.zxyw, r3.yzxw
dp4 r5.z, r1, c10
dp4 r5.x, r1, c8
dp4 r5.y, r1, c9
mad r1.xyz, r5, c19.w, -r4
mad r0.xyz, r2.yzxw, r3.zxyw, -r0
dp4 o0.w, r4, c3
dp4 o0.z, r4, c2
dp4 o0.y, r4, c1
dp4 o0.x, r4, c0
mul r4.xyz, r0, v1.w
mov r0, c10
dp4 r5.z, c18, r0
mov r0, c9
dp4 r5.y, c18, r0
dp3 o4.z, r2, r1
dp3 o4.y, r4, r1
dp3 o4.x, r3, r1
mov r1, c8
dp4 r5.x, c18, r1
dp3 o3.y, r5, r4
dp3 o3.z, r2, r5
dp3 o3.x, r5, r3
mov o2.xyz, c25.x
mad o1.xy, v3, c24, c24.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 288
Matrix 48 [_LightMatrix0]
Vector 112 [_Wind]
Vector 272 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedaghjbdnhijhpcjbnhjgekpmiepkpecmoabaaaaaaamamaaaaadaaaaaa
cmaaaaaapeaaaaaalaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoleaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefcfeakaaaaeaaaabaajfacaaaa
fjaaaaaeegiocaaaaaaaaaaabcaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaa
fjaaaaaeegiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaadlcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaa
amaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaag
ecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaa
aaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalp
aaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaap
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaa
acaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaaba
pcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaa
aaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaa
aaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaa
abeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaa
acaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaa
aaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaa
aaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaa
abaaaaaaegiocaaaadaaaaaaadaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
adaaaaaaamaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
aaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaaapaaaaaa
diaaaaaidcaabaaaacaaaaaafgafbaaaabaaaaaaegiacaaaaaaaaaaaaeaaaaaa
dcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaaabaaaaaa
egaabaaaacaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaa
kgakbaaaabaaaaaaegaabaaaabaaaaaadcaaaaakmccabaaaabaaaaaaagiecaaa
aaaaaaaaagaaaaaapgapbaaaabaaaaaaagaebaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadgaaaaaihccabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaadgaaaaaficcabaaaacaaaaaadkbabaaaafaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaadiaaaaahhcaabaaaadaaaaaacgajbaaa
abaaaaaajgaebaaaacaaaaaadcaaaaakhcaabaaaadaaaaaajgaebaaaabaaaaaa
cgajbaaaacaaaaaaegacbaiaebaaaaaaadaaaaaadiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaaeaaaaaafgifcaaa
acaaaaaaaaaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaeaaaaaa
egiccaaaadaaaaaabaaaaaaaagiacaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaa
dcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaacaaaaaa
aaaaaaaaegacbaaaaeaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaaadaaaaaa
bdaaaaaapgipcaaaacaaaaaaaaaaaaaaegacbaaaaeaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaabaaaaaahbccabaaaadaaaaaa
egacbaaaacaaaaaaegacbaaaaeaaaaaabaaaaaaheccabaaaadaaaaaaegacbaaa
abaaaaaaegacbaaaaeaaaaaadiaaaaajhcaabaaaaeaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaadaaaaaabbaaaaaadcaaaaalhcaabaaaaeaaaaaaegiccaaa
adaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaeaaaaaadcaaaaal
hcaabaaaaeaaaaaaegiccaaaadaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaeaaaaaaaaaaaaaihcaabaaaaeaaaaaaegacbaaaaeaaaaaaegiccaaa
adaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaeaaaaaapgipcaaa
adaaaaaabeaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahbccabaaaaeaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaaheccabaaaaeaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "POINT" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTexture0] 2D 3
"ps_3_0
; 31 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.16666667, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r1.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.w, r1.z, r1
dp3_pp r1.z, v2, v2
rsq_pp r1.z, r1.z
add_pp r0.w, -r0, c7.z
texld r0.xyz, v0, s0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r1.z, v2
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, r2
mul_pp r1.xyz, r0, c5
mul_pp r1.xyz, r1, v1.w
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
mul_pp r1.xyz, r1, c4
max_pp r0.y, r0.w, c7.w
texld r0.x, r0.x, s3
mul_pp r0.w, r0.x, c7.x
mul_pp r0.xyz, r1, r0.y
mul r0.xyz, r0, r0.w
mul r0.xyz, r0, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
cmp r1.x, -r0.w, c7.w, c7.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedlkgodhdhofcdonikmhimcdjiklkkgcdjabaaaaaaieafaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
gaaeaaaaeaaaaaaabiabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
icbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaegaabaaaabaaaaaaegaabaaaabaaaaaaddaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaa
abaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaa
aaaaaaaaaiaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaa
acaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaa
alaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
abaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaaj
pcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaa
deaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
ibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaa
aoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
dkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaa
acaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
"ps_3_0
; 26 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.33333334, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.w, -r0.x, c7.z
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, v2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, v1.w
mul_pp r0.xyz, r0, c6.w
max_pp r0.w, r0, c7
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, r0.w
mul r1.xyz, r0, c8.x
max r0.x, r1, r1.y
max_sat r0.x, r0, r1.z
mul r0.x, r0, c8.y
frc r0.y, -r0.x
add r0.x, -r0, -r0.y
mul r0.y, -r0.x, c8.z
cmp r0.x, -r0.y, c7.w, c7.z
rcp r0.z, r0.y
abs_pp r0.x, r0
mul_sat r1.xyz, r1, r0.z
mov r1.w, r0.y
cmp oC0, -r0.x, c7.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
ConstBuffer "$Globals" 224
Vector 16 [_LightColor0]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedjlgnhmpokdlkempikjgofdenhbmpjddjabaaaaaaiaaeaaaaadaaaaaa
cmaaaaaanaaaaaaaaeabaaaaejfdeheojmaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaajfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklklfdeieefcheadaaaaeaaaaaaannaaaaaafjaaaaaeegiocaaaaaaaaaaa
aiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaa
aaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaa
egaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaadaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaai
ocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaaeaaaaaadiaaaaah
ocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaklkkkkdoklkkkkdoklkkkkdoaaaaaaaadeaaaaah
icaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaa
aaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadl
dbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaak
bcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaa
abaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaa
abaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTexture0] 2D 3
SetTexture 4 [_LightTextureB0] 2D 4
"ps_3_0
; 36 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_2d s4
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.50000000, 0.16666667, 255.00000000, 0.00392157
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r1.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.w, r1.z, r1
dp3_pp r1.z, v2, v2
rsq_pp r1.z, r1.z
add_pp r0.w, -r0, c7.z
texld r0.xyz, v0, s0
mul_pp r2.xyz, r1.z, v2
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, r2
mul_pp r1.xyz, r0, c5
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c8.x
max_pp r0.y, r0.w, c7.w
mul_pp r1.xyz, r1, v1.w
mul_pp r1.xyz, r1, c6.w
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c4
texld r0.w, r2, s3
cmp r0.z, -v4, c7.w, c7
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s4
mul_pp r0.x, r0.z, r0
mul_pp r0.w, r0.x, c7.x
mul_pp r0.xyz, r1, r0.y
mul r0.xyz, r0, r0.w
mul r0.xyz, r0, c8.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8
cmp r1.x, -r0.w, c7.w, c7.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_BumpMap] 2D 3
SetTexture 2 [_LightTexture0] 2D 0
SetTexture 3 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedhoemknjebgjgmjafofhihkdoejcnofdkabaaaaaafmagaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
diafaaaaeaaaaaaaeoabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadicbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaa
dcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaah
icaabaaaaaaaaaaaegaabaaaabaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaa
dkaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
aiaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaa
agaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaaapaaaaahicaabaaa
aaaaaaaapgapbaaaaaaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaah
icaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaa
dicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaah
pccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_LightTexture0] CUBE 4
"ps_3_0
; 32 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s4
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.16666667, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c5
dp3_pp r0.w, v2, v2
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v2
add_pp r0.z, -r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.x, r0, r2
max_pp r0.y, r0.x, c7.w
mul_pp r1.xyz, r1, v1.w
mul_pp r1.xyz, r1, c6.w
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c4
texld r0.w, v4, s4
texld r0.x, r0.x, s3
mul r0.x, r0, r0.w
mul_pp r0.w, r0.x, c7.x
mul_pp r0.xyz, r1, r0.y
mul r0.xyz, r0, r0.w
mul r0.xyz, r0, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
cmp r1.x, -r0.w, c7.w, c7.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_BumpMap] 2D 3
SetTexture 2 [_LightTextureB0] 2D 1
SetTexture 3 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbdmlmddhdfhgaikjhbejedegbagnfdgjabaaaaaameafaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
kaaeaaaaeaaaaaaaciabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaae
aahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadicbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaa
dcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaah
icaabaaaaaaaaaaaegaabaaaabaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaa
dkaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
aiaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaa
abaaaaaapgapbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbcbaaaafaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaagaabaaaabaaaaaapgapbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaa
deaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
ibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaa
aoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
dkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaa
acaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTexture0] 2D 3
"ps_3_0
; 28 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.16666667, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4.xy
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r1.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.w, r1.z, r1
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c5
add_pp r0.w, -r0, c7.z
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
dp3_pp r1.x, r1, v2
mul_pp r0.xyz, r0, v1.w
mul_pp r0.xyz, r0, c6.w
texld r0.w, v4, s3
max_pp r1.x, r1, c7.w
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, r1.x
mul_pp r0.w, r0, c7.x
mul r0.xyz, r0, r0.w
mul r1.xyz, r0, c8.x
max r0.x, r1, r1.y
max_sat r0.x, r0, r1.z
mul r0.x, r0, c8.y
frc r0.y, -r0.x
add r0.x, -r0, -r0.y
mul r0.y, -r0.x, c8.z
cmp r0.x, -r0.y, c7.w, c7.z
rcp r0.z, r0.y
abs_pp r0.x, r0
mul_sat r1.xyz, r1, r0.z
mov r1.w, r0.y
cmp oC0, -r0.x, c7.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedjjchladnedhblcgdcdbndimbhllpogkjabaaaaaabmafaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaiaaaakeaaaaaa
abaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
piadaaaaeaaaaaaapoaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaadcaaaaapdcaabaaa
aaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaa
egaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaadaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaai
ocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaaiaaaaaadiaaaaah
ocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaah
icaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaa
dicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaah
pccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTexture0] 2D 3
"ps_3_0
; 56 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r1.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.w, r1.z, r1
dp3_pp r1.z, v2, v2
rsq_pp r1.z, r1.z
add_pp r0.w, -r0, c7.z
texld r0.xyz, v0, s0
mul_pp r2.xyz, r1.z, v2
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, r2
mul_pp r1.xyz, r0, c5
mul_pp r1.xyz, r1, v1.w
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
max_pp r0.y, r0.w, c7.w
texld r0.x, r0.x, s3
mul_pp r0.w, r0.x, c7.x
mul_pp r1.xyz, r1, c4
mul_pp r0.xyz, r1, r0.y
mul r1.xyz, r0, r0.w
pow r0, r1.x, c8.x
pow r2, r1.y, c8.x
mov r1.x, r0
pow r0, r1.z, c8.x
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8
rcp r1.y, r0.w
cmp r1.x, -r0.w, c7.w, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.w, r0
pow r0, r1.x, c9.x
mov oC0.x, r0
pow r0, r1.y, c9.x
pow r2, r1.z, c9.x
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedfkikndfigngdmkjgmkmghfejpiealmbiabaaaaaahmagaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
fiafaaaaeaaaaaaafgabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
icbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaadcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaegaabaaaabaaaaaaegaabaaaabaaaaaaddaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaa
abaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaa
aaaaaaaaaiaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaa
acaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaa
alaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
abaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaaj
pcaabaaaabaaaaaapgapbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
klkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaa
dkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahped
ecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaa
aaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmamea
aaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
"ps_3_0
; 51 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.w, -r0.x, c7.z
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, v2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, v1.w
mul_pp r0.xyz, r0, c6.w
max_pp r0.w, r0, c7
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, r0.w
mul r1.xyz, r0, c7.x
pow r0, r1.x, c8.x
pow r2, r1.y, c8.x
mov r1.x, r0
pow r0, r1.z, c8.x
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8
rcp r1.y, r0.w
cmp r1.x, -r0.w, c7.w, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.w, r0
pow r0, r1.x, c9.x
mov oC0.x, r0
pow r0, r1.y, c9.x
pow r2, r1.z, c9.x
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
ConstBuffer "$Globals" 224
Vector 16 [_LightColor0]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbbahdodanjbhojakpikkbnknbcgafjcdabaaaaaajeafaaaaadaaaaaa
cmaaaaaanaaaaaaaaeabaaaaejfdeheojmaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaajfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklklfdeieefciiaeaaaaeaaaaaaaccabaaaafjaaaaaeegiocaaaaaaaaaaa
aiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadcaaaaapdcaabaaa
aaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaa
egaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaadaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaai
ocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaaeaaaaaadiaaaaah
ocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoido
cplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaa
abaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaaf
hccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTexture0] 2D 3
SetTexture 4 [_LightTextureB0] 2D 4
"ps_3_0
; 61 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_2d s4
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.50000000, 0.45454544, 0.16666667, 255.00000000
def c9, 0.00392157, 2.20000005, 0, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r1.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.w, r1.z, r1
dp3_pp r1.z, v2, v2
rsq_pp r1.z, r1.z
add_pp r0.w, -r0, c7.z
texld r0.xyz, v0, s0
mul_pp r2.xyz, r1.z, v2
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
dp3_pp r0.w, r1, r2
mul_pp r1.xyz, r0, c5
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c8.x
max_pp r0.y, r0.w, c7.w
mul_pp r1.xyz, r1, v1.w
mul_pp r1.xyz, r1, c6.w
dp3 r0.x, v4, v4
texld r0.w, r2, s3
cmp r0.z, -v4, c7.w, c7
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s4
mul_pp r0.x, r0.z, r0
mul_pp r0.w, r0.x, c7.x
mul_pp r1.xyz, r1, c4
mul_pp r0.xyz, r1, r0.y
mul r1.xyz, r0, r0.w
pow r0, r1.x, c8.y
pow r2, r1.y, c8.y
mov r1.x, r0
pow r0, r1.z, c8.y
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c9.x
rcp r1.y, r0.w
cmp r1.x, -r0.w, c7.w, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.w, r0
pow r0, r1.x, c9.y
mov oC0.x, r0
pow r0, r1.y, c9.y
pow r2, r1.z, c9.y
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_BumpMap] 2D 3
SetTexture 2 [_LightTexture0] 2D 0
SetTexture 3 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecediabkababnpgpegbdfdcfjmkgehlnamapabaaaaaafeahaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
daagaaaaeaaaaaaaimabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadicbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaa
dcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaah
icaabaaaaaaaaaaaegaabaaaabaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaa
dkaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
aiaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
aaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaa
abaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaa
agaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaaapaaaaahicaabaaa
aaaaaaaapgapbaaaaaaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoido
cplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaa
abaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaaf
hccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTextureB0] 2D 3
SetTexture 4 [_LightTexture0] CUBE 4
"ps_3_0
; 57 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s4
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c5
dp3_pp r0.w, v2, v2
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v2
add_pp r0.z, -r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.x, r0, r2
max_pp r0.y, r0.x, c7.w
mul_pp r1.xyz, r1, v1.w
mul_pp r1.xyz, r1, c6.w
dp3 r0.x, v4, v4
texld r0.w, v4, s4
texld r0.x, r0.x, s3
mul r0.x, r0, r0.w
mul_pp r0.w, r0.x, c7.x
mul_pp r1.xyz, r1, c4
mul_pp r0.xyz, r1, r0.y
mul r1.xyz, r0, r0.w
pow r0, r1.x, c8.x
pow r2, r1.y, c8.x
mov r1.x, r0
pow r0, r1.z, c8.x
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8
rcp r1.y, r0.w
cmp r1.x, -r0.w, c7.w, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.w, r0
pow r0, r1.x, c9.x
mov oC0.x, r0
pow r0, r1.y, c9.x
pow r2, r1.z, c9.x
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_BumpMap] 2D 3
SetTexture 2 [_LightTextureB0] 2D 1
SetTexture 3 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedlifmnfgfhjljgoakaehjnejineibfdniabaaaaaalmagaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
jiafaaaaeaaaaaaaggabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafidaaaae
aahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadicbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
adaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaadaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaa
dcaaaaapdcaabaaaabaaaaaahgapbaaaabaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaah
icaabaaaaaaaaaaaegaabaaaabaaaaaaegaabaaaabaaaaaaddaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaabaaaaaa
dkaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
aiaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaa
abaaaaaapgapbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbcbaaaafaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaa
apaaaaahicaabaaaaaaaaaaaagaabaaaabaaaaaapgapbaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
klkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaa
dkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahped
ecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaa
aaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmamea
aaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 3 [_LightTexture0] 2D 3
"ps_3_0
; 52 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c8, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2.xyz
dcl_texcoord3 v4.xy
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r1.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.w, r1.z, r1
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c5
add_pp r0.w, -r0, c7.z
rsq_pp r0.w, r0.w
rcp_pp r1.z, r0.w
dp3_pp r1.x, r1, v2
mul_pp r0.xyz, r0, v1.w
mul_pp r0.xyz, r0, c6.w
texld r0.w, v4, s3
max_pp r1.x, r1, c7.w
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, r1.x
mul_pp r0.w, r0, c7.x
mul r1.xyz, r0, r0.w
pow r0, r1.x, c8.x
pow r2, r1.y, c8.x
mov r1.x, r0
pow r0, r1.z, c8.x
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8
rcp r1.y, r0.w
cmp r1.x, -r0.w, c7.w, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.w, r0
pow r0, r1.x, c9.x
mov oC0.x, r0
pow r0, r1.y, c9.x
pow r2, r1.z, c9.x
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 288
Vector 16 [_LightColor0]
Vector 128 [_Color]
Vector 176 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkdmmkaconcjfnkieegnaoafjhchepncaabaaaaaabeagaaaaadaaaaaa
cmaaaaaaoiaaaaaabmabaaaaejfdeheoleaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaknaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaiaaaakeaaaaaa
abaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefc
paaeaaaaeaaaaaaadmabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaadcaaaaapdcaabaaa
aaaaaaaahgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaa
egaabaaaaaaaaaaaegaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpelaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaadaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaai
ocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaaiaaaaaadiaaaaah
ocaabaaaaaaaaaaafgaobaaaaaaaaaaapgbpbaaaacaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaalaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoido
cplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaa
abaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaaf
hccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassBase" "RenderType"="TreeBark" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_11;
  vec3 tmpvar_12;
  tmpvar_12 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_13;
  vec3 tmpvar_14;
  tmpvar_13 = tmpvar_2.xyz;
  tmpvar_14 = (((tmpvar_12.yzx * tmpvar_2.zxy) - (tmpvar_12.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_12.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_12.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_12.z;
  vec3 v_16;
  v_16.x = _Object2World[0].x;
  v_16.y = _Object2World[1].x;
  v_16.z = _Object2World[2].x;
  vec3 v_17;
  v_17.x = _Object2World[0].y;
  v_17.y = _Object2World[1].y;
  v_17.z = _Object2World[2].y;
  vec3 v_18;
  v_18.x = _Object2World[0].z;
  v_18.y = _Object2World[1].z;
  v_18.z = _Object2World[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_15 * v_16) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_15 * v_17) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_15 * v_18) * unity_Scale.w);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 res_1;
  vec3 worldN_2;
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  worldN_2.x = dot (xlv_TEXCOORD1, normal_3);
  worldN_2.y = dot (xlv_TEXCOORD2, normal_3);
  worldN_2.z = dot (xlv_TEXCOORD3, normal_3);
  res_1.xyz = ((worldN_2 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [unity_Scale]
Vector 10 [_Scale]
Vector 11 [_SquashPlaneNormal]
Float 12 [_SquashAmount]
Vector 13 [_Wind]
Vector 14 [_MainTex_ST]
"vs_3_0
; 62 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c16, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c17, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c15.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c10
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c16
frc r0, r0
mad r0, r0, c15.y, c15.z
frc r0, r0
mad r0, r0, c15.y, c15.w
abs r0, r0
mad r1, -r0, c17.x, c17.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c13
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c17
mov r1.w, c15.x
mul r0.xz, r0.w, v2
mul r0.y, v4, c17.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c13.w, r2
mad r1.xyz, v4.x, c13, r0
dp3 r0.x, r1, c11
add r0.x, r0, c11.w
mul r0.xyz, r0.x, c11
add r1.xyz, -r0, r1
mad r1.xyz, r0, c12.x, r1
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r2.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
mul r3.xyz, r0.zxyw, r2.yzxw
mad r3.xyz, r0.yzxw, r2.zxyw, -r3
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
mul r3.xyz, r3, v1.w
dp3 r1.y, r3, c4
dp3 r1.x, r2, c4
dp3 r1.z, r0, c4
mul o2.xyz, r1, c9.w
dp3 r1.y, r3, c5
dp3 r1.x, r2, c5
dp3 r1.z, r0, c5
mul o3.xyz, r1, c9.w
dp3 r1.y, r3, c6
dp3 r1.x, r2, c6
dp3 r1.z, r0, c6
mul o4.xyz, r1, c9.w
mad o1.xy, v3, c14, c14.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
BindCB  "UnityTerrain" 3
"vs_4_0
eefiecedmicmkgikflhdkhdihbggacajnhagpbjfabaaaaaajeakaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcpiaiaaaaeaaaabaa
doacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafjaaaaaeegiocaaaadaaaaaa
amaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
fpaaaaaddcbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaa
dkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaacaaaaaaaoaaaaaabaaaaaak
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaa
aaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaai
hcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaadaaaaaaafaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaa
aaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdo
bkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialp
diaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaa
aaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaa
adaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaa
bkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaa
aaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdo
dcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egiccaaaadaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkiacaaaadaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaaegiccaaaadaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagiacaaaadaaaaaaalaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
abaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaadaaaaaaakiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaa
akiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaaakiacaaaacaaaaaa
aoaaaaaabaaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
baaaaaahbcaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaa
acaaaaaaegacbaaaaeaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
acaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaacaaaaaaaoaaaaaa
baaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
aeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaadaaaaaa
egacbaaaaeaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaadaaaaaa
ckiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaackiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaah
ccaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
acaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_11;
  vec3 tmpvar_12;
  tmpvar_12 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec3 tmpvar_13;
  vec3 tmpvar_14;
  tmpvar_13 = tmpvar_2.xyz;
  tmpvar_14 = (((tmpvar_12.yzx * tmpvar_2.zxy) - (tmpvar_12.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_12.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_12.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_12.z;
  vec3 v_16;
  v_16.x = _Object2World[0].x;
  v_16.y = _Object2World[1].x;
  v_16.z = _Object2World[2].x;
  vec3 v_17;
  v_17.x = _Object2World[0].y;
  v_17.y = _Object2World[1].y;
  v_17.z = _Object2World[2].y;
  vec3 v_18;
  v_18.x = _Object2World[0].z;
  v_18.y = _Object2World[1].z;
  v_18.z = _Object2World[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_15 * v_16) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_15 * v_17) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_15 * v_18) * unity_Scale.w);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 res_1;
  vec3 worldN_2;
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  worldN_2.x = dot (xlv_TEXCOORD1, normal_3);
  worldN_2.y = dot (xlv_TEXCOORD2, normal_3);
  worldN_2.z = dot (xlv_TEXCOORD3, normal_3);
  res_1.xyz = ((worldN_2 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [unity_Scale]
Vector 10 [_Scale]
Vector 11 [_SquashPlaneNormal]
Float 12 [_SquashAmount]
Vector 13 [_Wind]
Vector 14 [_MainTex_ST]
"vs_3_0
; 62 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c16, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c17, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c15.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c10
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c16
frc r0, r0
mad r0, r0, c15.y, c15.z
frc r0, r0
mad r0, r0, c15.y, c15.w
abs r0, r0
mad r1, -r0, c17.x, c17.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c13
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c17
mov r1.w, c15.x
mul r0.xz, r0.w, v2
mul r0.y, v4, c17.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c13.w, r2
mad r1.xyz, v4.x, c13, r0
dp3 r0.x, r1, c11
add r0.x, r0, c11.w
mul r0.xyz, r0.x, c11
add r1.xyz, -r0, r1
mad r1.xyz, r0, c12.x, r1
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r2.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
mul r3.xyz, r0.zxyw, r2.yzxw
mad r3.xyz, r0.yzxw, r2.zxyw, -r3
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
mul r3.xyz, r3, v1.w
dp3 r1.y, r3, c4
dp3 r1.x, r2, c4
dp3 r1.z, r0, c4
mul o2.xyz, r1, c9.w
dp3 r1.y, r3, c5
dp3 r1.x, r2, c5
dp3 r1.z, r0, c5
mul o3.xyz, r1, c9.w
dp3 r1.y, r3, c6
dp3 r1.x, r2, c6
dp3 r1.z, r0, c6
mul o4.xyz, r1, c9.w
mad o1.xy, v3, c14, c14.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 224
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
BindCB  "UnityTerrain" 3
"vs_4_0
eefiecedmicmkgikflhdkhdihbggacajnhagpbjfabaaaaaajeakaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcpiaiaaaaeaaaabaa
doacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafjaaaaaeegiocaaaadaaaaaa
amaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
fpaaaaaddcbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaa
dkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaacaaaaaaaoaaaaaabaaaaaak
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaa
aaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaai
hcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaadaaaaaaafaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaa
aaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdo
bkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialp
diaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaa
aaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaa
adaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaa
bkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaa
aaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdo
dcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egiccaaaadaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkiacaaaadaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaaegiccaaaadaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagiacaaaadaaaaaaalaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaacaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
abaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaacgajbaaaaaaaaaaajgaebaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaadaaaaaaakiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaa
akiacaaaacaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaaakiacaaaacaaaaaa
aoaaaaaabaaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
baaaaaahbcaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaa
acaaaaaaegacbaaaaeaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
acaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaacaaaaaaaoaaaaaa
baaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
aeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaadaaaaaa
egacbaaaaeaaaaaapgipcaaaacaaaaaabeaaaaaadgaaaaagbcaabaaaadaaaaaa
ckiacaaaacaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaackiacaaaacaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaackiacaaaacaaaaaaaoaaaaaabaaaaaah
ccaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
acaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaaeaaaaaaegacbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" }
SetTexture 1 [_BumpMap] 2D 1
"ps_3_0
; 11 ALU, 1 TEX
dcl_2d s1
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
add_pp r0.z, -r0, c4
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r1.z, v3, r0
dp3 r1.x, r0, v1
dp3 r1.y, r0, v2
mad_pp oC0.xyz, r1, c4.w, c4.w
mov_pp oC0.w, c5.x
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" }
SetTexture 0 [_BumpMap] 2D 0
"ps_4_0
eefiecedooffhajeemnfofekahclgcnejledjbfdabaaaaaaoeacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcnmabaaaaeaaaaaaahhaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaapdcaabaaaaaaaaaaa
hgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaa
aaaaaaaaegaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpelaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaaegacbaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" }
SetTexture 1 [_BumpMap] 2D 1
"ps_3_0
; 11 ALU, 1 TEX
dcl_2d s1
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
add_pp r0.z, -r0, c4
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r1.z, v3, r0
dp3 r1.x, r0, v1
dp3 r1.y, r0, v2
mad_pp oC0.xyz, r1, c4.w, c4.w
mov_pp oC0.w, c5.x
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" }
SetTexture 0 [_BumpMap] 2D 0
"ps_4_0
eefiecedooffhajeemnfofekahclgcnejledjbfdabaaaaaaoeacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcnmabaaaaeaaaaaaahhaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaapdcaabaaaaaaaaaaa
hgapbaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaa
aaaaialpaaaaialpaaaaaaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaa
aaaaaaaaegaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpelaaaaafecaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahccaabaaa
abaaaaaaegbcbaaaadaaaaaaegacbaaaaaaaaaaabaaaaaahecaabaaaabaaaaaa
egbcbaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaaegacbaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaa
doaaaaab"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassFinal" "RenderType"="TreeBark" }
  ZWrite Off
Program "vp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_12.w = gl_Color.w;
  vec3 tmpvar_13;
  tmpvar_13 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_14;
  tmpvar_14 = (gl_ModelViewProjectionMatrix * tmpvar_11);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_13.yzx * tmpvar_2.zxy) - (tmpvar_13.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_13.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_13.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_13.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  vec4 o_21;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_14 * 0.5);
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_21.xy = (tmpvar_23 + tmpvar_22.w);
  o_21.zw = tmpvar_14.zw;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (tmpvar_13 * unity_Scale.w));
  vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = tmpvar_25;
  vec3 x2_27;
  vec3 x1_28;
  x1_28.x = dot (unity_SHAr, tmpvar_26);
  x1_28.y = dot (unity_SHAg, tmpvar_26);
  x1_28.z = dot (unity_SHAb, tmpvar_26);
  vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyzz * tmpvar_25.yzzx);
  x2_27.x = dot (unity_SHBr, tmpvar_29);
  x2_27.y = dot (unity_SHBg, tmpvar_29);
  x2_27.z = dot (unity_SHBb, tmpvar_29);
  gl_Position = tmpvar_14;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_12;
  xlv_TEXCOORD1 = o_21;
  xlv_TEXCOORD2 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD5 = ((x1_28 + x2_27) + (unity_SHC.xyz * ((tmpvar_25.x * tmpvar_25.x) - (tmpvar_25.y * tmpvar_25.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
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
  vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_3.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_5.xyz * dot (xlv_TEXCOORD2, normal_4)) + ((v_6.xyz * dot (xlv_TEXCOORD3, normal_4)) + (v_7.xyz * dot (xlv_TEXCOORD4, normal_4)))));
  vec4 tmpvar_10;
  tmpvar_10 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD1)));
  light_2.w = tmpvar_10.w;
  light_2.xyz = (tmpvar_10.xyz + xlv_TEXCOORD5);
  vec4 c_11;
  c_11.xyz = (tmpvar_8 * light_2.xyz);
  c_11.w = tmpvar_3.w;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * tmpvar_8) * ExposureIBL.x));
  vec4 color_12;
  vec4 tmpvar_13;
  tmpvar_13 = (c_1 * 0.166667);
  color_12 = tmpvar_13;
  float tmpvar_14;
  tmpvar_14 = (ceil((clamp (max (max (tmpvar_13.x, tmpvar_13.y), tmpvar_13.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_14 > 0.0)) {
    color_12.xyz = clamp ((tmpvar_13.xyz * (1.0/(tmpvar_14))), 0.0, 1.0);
    color_12.w = tmpvar_14;
  } else {
    color_12 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_12;
  gl_FragData[0] = color_12;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
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
Vector 19 [_Scale]
Vector 20 [_SquashPlaneNormal]
Float 21 [_SquashAmount]
Vector 22 [_Wind]
Vector 23 [_MainTex_ST]
"vs_3_0
; 87 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
def c24, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c25, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c26, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c27, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c24.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c19
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c25
frc r0, r0
mad r0, r0, c24.y, c24.z
frc r0, r0
mad r0, r0, c24.y, c24.w
abs r0, r0
mad r1, -r0, c26.x, c26.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c22
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c26
mul r0.xz, r0.w, v2
mul r0.y, v4, c26.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c22.w, r2
mad r1.xyz, v4.x, c22, r0
dp3 r0.x, r1, c20
add r0.x, r0, c20.w
mul r0.xyz, r0.x, c20
add r1.xyz, -r0, r1
mad r0.xyz, r0, c21.x, r1
mov r0.w, c24.x
dp4 r2.w, r0, c3
dp4 r2.z, r0, c2
dp4 r2.x, r0, c0
dp4 r2.y, r0, c1
mul r1.xyz, r2.xyww, c27.x
mul r1.y, r1, c9.x
mov o0, r2
mov o3.zw, r2
mad o3.xy, r1.z, c10.zwzw, r1
dp3 r1.w, v2, v2
rsq r1.x, r1.w
mul r1.xyz, r1.x, v2
mul r0.xyz, r1, c18.w
dp3 r1.w, r0, c5
dp3 r2.x, r0, c4
dp3 r2.z, r0, c6
mov r2.y, r1.w
mul r0, r2.xyzz, r2.yzzx
mov r2.w, c24.x
dp4 r4.z, r0, c16
dp4 r4.y, r0, c15
dp4 r4.x, r0, c14
mul r0.w, r1, r1
dp4 r3.z, r2, c13
dp4 r3.y, r2, c12
dp4 r3.x, r2, c11
dp3 r2.y, v1, v1
rsq r0.x, r2.y
add r3.xyz, r3, r4
mul r0.xyz, r0.x, v1
mul r4.xyz, r1.zxyw, r0.yzxw
mad r0.w, r2.x, r2.x, -r0
mad r2.xyz, r1.yzxw, r0.zxyw, -r4
mul r4.xyz, r0.w, c17
add o7.xyz, r3, r4
mul r2.xyz, r2, v1.w
dp3 r3.y, r2, c4
dp3 r3.x, r0, c4
dp3 r3.z, r1, c4
mul o4.xyz, r3, c18.w
dp3 r3.y, r2, c5
dp3 r2.y, r2, c6
dp3 r3.x, r0, c5
dp3 r3.z, r1, c5
dp3 r2.x, r0, c6
dp3 r2.z, r1, c6
mul o5.xyz, r3, c18.w
mul o6.xyz, r2, c18.w
mov o2.xyz, c24.x
mad o1.xy, v3, c23, c23.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 240
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecednccjblphbbijeknbbdfpknjmechgbldfabaaaaaanmanaaaaadaaaaaa
cmaaaaaapeaaaaaaoaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooeaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaannaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
fdeieefcpealaaaaeaaaabaapnacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaa
fpaaaaadhcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaad
lcbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
gfaaaaadhccabaaaahaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaa
dkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaak
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaa
aaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaai
hcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaa
aaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdo
bkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialp
diaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaa
aaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaa
adaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaa
bkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaa
aaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdo
dcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadgaaaaaihccabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaficcabaaa
acaaaaaadkbabaaaafaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaacaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaajgaebaaaabaaaaaacgajbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
baaaaaahbcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaa
aeaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaa
baaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
aeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaafaaaaaa
egacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaadaaaaaa
ckiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaackiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihccabaaaagaaaaaaegacbaaa
acaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaa
acaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_12.w = gl_Color.w;
  vec3 tmpvar_13;
  tmpvar_13 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_14;
  tmpvar_14 = (gl_ModelViewProjectionMatrix * tmpvar_11);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_13.yzx * tmpvar_2.zxy) - (tmpvar_13.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_13.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_13.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_13.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  vec4 o_21;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_14 * 0.5);
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_21.xy = (tmpvar_23 + tmpvar_22.w);
  o_21.zw = tmpvar_14.zw;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (tmpvar_13 * unity_Scale.w));
  vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = tmpvar_25;
  vec3 x2_27;
  vec3 x1_28;
  x1_28.x = dot (unity_SHAr, tmpvar_26);
  x1_28.y = dot (unity_SHAg, tmpvar_26);
  x1_28.z = dot (unity_SHAb, tmpvar_26);
  vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyzz * tmpvar_25.yzzx);
  x2_27.x = dot (unity_SHBr, tmpvar_29);
  x2_27.y = dot (unity_SHBg, tmpvar_29);
  x2_27.z = dot (unity_SHBb, tmpvar_29);
  gl_Position = tmpvar_14;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_12;
  xlv_TEXCOORD1 = o_21;
  xlv_TEXCOORD2 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD5 = ((x1_28 + x2_27) + (unity_SHC.xyz * ((tmpvar_25.x * tmpvar_25.x) - (tmpvar_25.y * tmpvar_25.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
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
  vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_3.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_5.xyz * dot (xlv_TEXCOORD2, normal_4)) + ((v_6.xyz * dot (xlv_TEXCOORD3, normal_4)) + (v_7.xyz * dot (xlv_TEXCOORD4, normal_4)))));
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_2.w = tmpvar_10.w;
  light_2.xyz = (tmpvar_10.xyz + xlv_TEXCOORD5);
  vec4 c_11;
  c_11.xyz = (tmpvar_8 * light_2.xyz);
  c_11.w = tmpvar_3.w;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (((tmpvar_9.xyz * tmpvar_9.w) * tmpvar_8) * ExposureIBL.x));
  vec4 color_12;
  vec4 tmpvar_13;
  tmpvar_13 = (c_1 * 0.166667);
  color_12 = tmpvar_13;
  float tmpvar_14;
  tmpvar_14 = (ceil((clamp (max (max (tmpvar_13.x, tmpvar_13.y), tmpvar_13.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_14 > 0.0)) {
    color_12.xyz = clamp ((tmpvar_13.xyz * (1.0/(tmpvar_14))), 0.0, 1.0);
    color_12.w = tmpvar_14;
  } else {
    color_12 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  c_1 = color_12;
  gl_FragData[0] = color_12;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
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
Vector 19 [_Scale]
Vector 20 [_SquashPlaneNormal]
Float 21 [_SquashAmount]
Vector 22 [_Wind]
Vector 23 [_MainTex_ST]
"vs_3_0
; 87 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
def c24, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c25, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c26, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c27, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c24.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c19
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c25
frc r0, r0
mad r0, r0, c24.y, c24.z
frc r0, r0
mad r0, r0, c24.y, c24.w
abs r0, r0
mad r1, -r0, c26.x, c26.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c22
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c26
mul r0.xz, r0.w, v2
mul r0.y, v4, c26.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c22.w, r2
mad r1.xyz, v4.x, c22, r0
dp3 r0.x, r1, c20
add r0.x, r0, c20.w
mul r0.xyz, r0.x, c20
add r1.xyz, -r0, r1
mad r0.xyz, r0, c21.x, r1
mov r0.w, c24.x
dp4 r2.w, r0, c3
dp4 r2.z, r0, c2
dp4 r2.x, r0, c0
dp4 r2.y, r0, c1
mul r1.xyz, r2.xyww, c27.x
mul r1.y, r1, c9.x
mov o0, r2
mov o3.zw, r2
mad o3.xy, r1.z, c10.zwzw, r1
dp3 r1.w, v2, v2
rsq r1.x, r1.w
mul r1.xyz, r1.x, v2
mul r0.xyz, r1, c18.w
dp3 r1.w, r0, c5
dp3 r2.x, r0, c4
dp3 r2.z, r0, c6
mov r2.y, r1.w
mul r0, r2.xyzz, r2.yzzx
mov r2.w, c24.x
dp4 r4.z, r0, c16
dp4 r4.y, r0, c15
dp4 r4.x, r0, c14
mul r0.w, r1, r1
dp4 r3.z, r2, c13
dp4 r3.y, r2, c12
dp4 r3.x, r2, c11
dp3 r2.y, v1, v1
rsq r0.x, r2.y
add r3.xyz, r3, r4
mul r0.xyz, r0.x, v1
mul r4.xyz, r1.zxyw, r0.yzxw
mad r0.w, r2.x, r2.x, -r0
mad r2.xyz, r1.yzxw, r0.zxyw, -r4
mul r4.xyz, r0.w, c17
add o7.xyz, r3, r4
mul r2.xyz, r2, v1.w
dp3 r3.y, r2, c4
dp3 r3.x, r0, c4
dp3 r3.z, r1, c4
mul o4.xyz, r3, c18.w
dp3 r3.y, r2, c5
dp3 r2.y, r2, c6
dp3 r3.x, r0, c5
dp3 r3.z, r1, c5
dp3 r2.x, r0, c6
dp3 r2.z, r1, c6
mul o5.xyz, r3, c18.w
mul o6.xyz, r2, c18.w
mov o2.xyz, c24.x
mad o1.xy, v3, c23, c23.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 240
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecednccjblphbbijeknbbdfpknjmechgbldfabaaaaaanmanaaaaadaaaaaa
cmaaaaaapeaaaaaaoaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooeaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaannaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
fdeieefcpealaaaaeaaaabaapnacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaa
fpaaaaadhcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaad
lcbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
gfaaaaadhccabaaaahaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaa
dkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaak
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaa
aaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaai
hcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaa
aaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdo
bkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialp
diaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaa
aaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaa
adaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaa
bkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaa
aaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdo
dcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadgaaaaaihccabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaficcabaaa
acaaaaaadkbabaaaafaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaacaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaajgaebaaaabaaaaaacgajbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
baaaaaahbcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaa
aeaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaa
baaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
aeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaafaaaaaa
egacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaadaaaaaa
ckiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaackiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihccabaaaagaaaaaaegacbaaa
acaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaa
acaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_12.w = gl_Color.w;
  vec3 tmpvar_13;
  tmpvar_13 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_14;
  tmpvar_14 = (gl_ModelViewProjectionMatrix * tmpvar_11);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_13.yzx * tmpvar_2.zxy) - (tmpvar_13.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_13.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_13.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_13.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  vec4 o_21;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_14 * 0.5);
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_21.xy = (tmpvar_23 + tmpvar_22.w);
  o_21.zw = tmpvar_14.zw;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (tmpvar_13 * unity_Scale.w));
  vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = tmpvar_25;
  vec3 x2_27;
  vec3 x1_28;
  x1_28.x = dot (unity_SHAr, tmpvar_26);
  x1_28.y = dot (unity_SHAg, tmpvar_26);
  x1_28.z = dot (unity_SHAb, tmpvar_26);
  vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyzz * tmpvar_25.yzzx);
  x2_27.x = dot (unity_SHBr, tmpvar_29);
  x2_27.y = dot (unity_SHBg, tmpvar_29);
  x2_27.z = dot (unity_SHBb, tmpvar_29);
  gl_Position = tmpvar_14;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_12;
  xlv_TEXCOORD1 = o_21;
  xlv_TEXCOORD2 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD5 = ((x1_28 + x2_27) + (unity_SHC.xyz * ((tmpvar_25.x * tmpvar_25.x) - (tmpvar_25.y * tmpvar_25.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
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
  vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_3.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_5.xyz * dot (xlv_TEXCOORD2, normal_4)) + ((v_6.xyz * dot (xlv_TEXCOORD3, normal_4)) + (v_7.xyz * dot (xlv_TEXCOORD4, normal_4)))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  vec4 tmpvar_12;
  tmpvar_12 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD1)));
  light_2.w = tmpvar_12.w;
  light_2.xyz = (tmpvar_12.xyz + xlv_TEXCOORD5);
  vec4 c_13;
  c_13.xyz = (tmpvar_8 * light_2.xyz);
  c_13.w = tmpvar_3.w;
  c_1.w = c_13.w;
  c_1.xyz = (c_13.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * tmpvar_8) * ExposureIBL.x));
  vec4 color_14;
  color_14.w = c_1.w;
  color_14.xyz = pow (c_1.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_15;
  tmpvar_15 = (color_14 * 0.166667);
  color_14 = tmpvar_15;
  float tmpvar_16;
  tmpvar_16 = (ceil((clamp (max (max (tmpvar_15.x, tmpvar_15.y), tmpvar_15.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_16 > 0.0)) {
    color_14.xyz = clamp ((tmpvar_15.xyz * (1.0/(tmpvar_16))), 0.0, 1.0);
    color_14.w = tmpvar_16;
  } else {
    color_14 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_14.xyz = pow (color_14.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_14;
  gl_FragData[0] = color_14;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
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
Vector 19 [_Scale]
Vector 20 [_SquashPlaneNormal]
Float 21 [_SquashAmount]
Vector 22 [_Wind]
Vector 23 [_MainTex_ST]
"vs_3_0
; 87 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
def c24, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c25, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c26, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c27, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c24.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c19
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c25
frc r0, r0
mad r0, r0, c24.y, c24.z
frc r0, r0
mad r0, r0, c24.y, c24.w
abs r0, r0
mad r1, -r0, c26.x, c26.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c22
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c26
mul r0.xz, r0.w, v2
mul r0.y, v4, c26.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c22.w, r2
mad r1.xyz, v4.x, c22, r0
dp3 r0.x, r1, c20
add r0.x, r0, c20.w
mul r0.xyz, r0.x, c20
add r1.xyz, -r0, r1
mad r0.xyz, r0, c21.x, r1
mov r0.w, c24.x
dp4 r2.w, r0, c3
dp4 r2.z, r0, c2
dp4 r2.x, r0, c0
dp4 r2.y, r0, c1
mul r1.xyz, r2.xyww, c27.x
mul r1.y, r1, c9.x
mov o0, r2
mov o3.zw, r2
mad o3.xy, r1.z, c10.zwzw, r1
dp3 r1.w, v2, v2
rsq r1.x, r1.w
mul r1.xyz, r1.x, v2
mul r0.xyz, r1, c18.w
dp3 r1.w, r0, c5
dp3 r2.x, r0, c4
dp3 r2.z, r0, c6
mov r2.y, r1.w
mul r0, r2.xyzz, r2.yzzx
mov r2.w, c24.x
dp4 r4.z, r0, c16
dp4 r4.y, r0, c15
dp4 r4.x, r0, c14
mul r0.w, r1, r1
dp4 r3.z, r2, c13
dp4 r3.y, r2, c12
dp4 r3.x, r2, c11
dp3 r2.y, v1, v1
rsq r0.x, r2.y
add r3.xyz, r3, r4
mul r0.xyz, r0.x, v1
mul r4.xyz, r1.zxyw, r0.yzxw
mad r0.w, r2.x, r2.x, -r0
mad r2.xyz, r1.yzxw, r0.zxyw, -r4
mul r4.xyz, r0.w, c17
add o7.xyz, r3, r4
mul r2.xyz, r2, v1.w
dp3 r3.y, r2, c4
dp3 r3.x, r0, c4
dp3 r3.z, r1, c4
mul o4.xyz, r3, c18.w
dp3 r3.y, r2, c5
dp3 r2.y, r2, c6
dp3 r3.x, r0, c5
dp3 r3.z, r1, c5
dp3 r2.x, r0, c6
dp3 r2.z, r1, c6
mul o5.xyz, r3, c18.w
mul o6.xyz, r2, c18.w
mov o2.xyz, c24.x
mad o1.xy, v3, c23, c23.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 240
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecednccjblphbbijeknbbdfpknjmechgbldfabaaaaaanmanaaaaadaaaaaa
cmaaaaaapeaaaaaaoaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooeaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaannaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
fdeieefcpealaaaaeaaaabaapnacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaa
fpaaaaadhcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaad
lcbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
gfaaaaadhccabaaaahaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaa
dkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaak
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaa
aaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaai
hcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaa
aaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdo
bkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialp
diaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaa
aaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaa
adaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaa
bkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaa
aaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdo
dcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadgaaaaaihccabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaficcabaaa
acaaaaaadkbabaaaafaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaacaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaajgaebaaaabaaaaaacgajbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
baaaaaahbcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaa
aeaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaa
baaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
aeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaafaaaaaa
egacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaadaaaaaa
ckiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaackiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihccabaaaagaaaaaaegacbaaa
acaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaa
acaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
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
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_2.w = TANGENT.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_1.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_1.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_12.w = gl_Color.w;
  vec3 tmpvar_13;
  tmpvar_13 = normalize(gl_Normal);
  tmpvar_2.xyz = normalize(TANGENT.xyz);
  vec4 tmpvar_14;
  tmpvar_14 = (gl_ModelViewProjectionMatrix * tmpvar_11);
  vec3 tmpvar_15;
  vec3 tmpvar_16;
  tmpvar_15 = tmpvar_2.xyz;
  tmpvar_16 = (((tmpvar_13.yzx * tmpvar_2.zxy) - (tmpvar_13.zxy * tmpvar_2.yzx)) * TANGENT.w);
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_15.x;
  tmpvar_17[0].y = tmpvar_16.x;
  tmpvar_17[0].z = tmpvar_13.x;
  tmpvar_17[1].x = tmpvar_15.y;
  tmpvar_17[1].y = tmpvar_16.y;
  tmpvar_17[1].z = tmpvar_13.y;
  tmpvar_17[2].x = tmpvar_15.z;
  tmpvar_17[2].y = tmpvar_16.z;
  tmpvar_17[2].z = tmpvar_13.z;
  vec3 v_18;
  v_18.x = _Object2World[0].x;
  v_18.y = _Object2World[1].x;
  v_18.z = _Object2World[2].x;
  vec3 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  vec3 v_20;
  v_20.x = _Object2World[0].z;
  v_20.y = _Object2World[1].z;
  v_20.z = _Object2World[2].z;
  vec4 o_21;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_14 * 0.5);
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_21.xy = (tmpvar_23 + tmpvar_22.w);
  o_21.zw = tmpvar_14.zw;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (tmpvar_13 * unity_Scale.w));
  vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = tmpvar_25;
  vec3 x2_27;
  vec3 x1_28;
  x1_28.x = dot (unity_SHAr, tmpvar_26);
  x1_28.y = dot (unity_SHAg, tmpvar_26);
  x1_28.z = dot (unity_SHAb, tmpvar_26);
  vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyzz * tmpvar_25.yzzx);
  x2_27.x = dot (unity_SHBr, tmpvar_29);
  x2_27.y = dot (unity_SHBg, tmpvar_29);
  x2_27.z = dot (unity_SHBb, tmpvar_29);
  gl_Position = tmpvar_14;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_12;
  xlv_TEXCOORD1 = o_21;
  xlv_TEXCOORD2 = ((tmpvar_17 * v_18) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_17 * v_19) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_17 * v_20) * unity_Scale.w);
  xlv_TEXCOORD5 = ((x1_28 + x2_27) + (unity_SHC.xyz * ((tmpvar_25.x * tmpvar_25.x) - (tmpvar_25.y * tmpvar_25.y))));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform sampler2D _BumpMap;
uniform sampler2D _MainTex;
uniform mat4 SkyMatrix;
uniform samplerCube _DiffCubeIBL;
uniform vec4 ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
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
  vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_3.xyz * _Color.xyz) * xlv_COLOR0.w) * ExposureIBL.w);
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, ((v_5.xyz * dot (xlv_TEXCOORD2, normal_4)) + ((v_6.xyz * dot (xlv_TEXCOORD3, normal_4)) + (v_7.xyz * dot (xlv_TEXCOORD4, normal_4)))));
  float tmpvar_10;
  tmpvar_10 = (tmpvar_9.w * tmpvar_9.w);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (tmpvar_9.w * tmpvar_10);
  vec4 tmpvar_12;
  tmpvar_12 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_2.w = tmpvar_12.w;
  light_2.xyz = (tmpvar_12.xyz + xlv_TEXCOORD5);
  vec4 c_13;
  c_13.xyz = (tmpvar_8 * light_2.xyz);
  c_13.w = tmpvar_3.w;
  c_1.w = c_13.w;
  c_1.xyz = (c_13.xyz + (((tmpvar_9.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * tmpvar_8) * ExposureIBL.x));
  vec4 color_14;
  color_14.w = c_1.w;
  color_14.xyz = pow (c_1.xyz, vec3(0.454545, 0.454545, 0.454545));
  vec4 tmpvar_15;
  tmpvar_15 = (color_14 * 0.166667);
  color_14 = tmpvar_15;
  float tmpvar_16;
  tmpvar_16 = (ceil((clamp (max (max (tmpvar_15.x, tmpvar_15.y), tmpvar_15.z), 0.0, 1.0) * 255.0)) / 255.0);
  if ((tmpvar_16 > 0.0)) {
    color_14.xyz = clamp ((tmpvar_15.xyz * (1.0/(tmpvar_16))), 0.0, 1.0);
    color_14.w = tmpvar_16;
  } else {
    color_14 = vec4(0.0, 0.0, 0.0, 0.0);
  };
  color_14.xyz = pow (color_14.xyz, vec3(2.2, 2.2, 2.2));
  c_1 = color_14;
  gl_FragData[0] = color_14;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
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
Vector 19 [_Scale]
Vector 20 [_SquashPlaneNormal]
Float 21 [_SquashAmount]
Vector 22 [_Wind]
Vector 23 [_MainTex_ST]
"vs_3_0
; 87 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
dcl_texcoord1 o3
dcl_texcoord2 o4
dcl_texcoord3 o5
dcl_texcoord4 o6
dcl_texcoord5 o7
def c24, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c25, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c26, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c27, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c24.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c19
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c25
frc r0, r0
mad r0, r0, c24.y, c24.z
frc r0, r0
mad r0, r0, c24.y, c24.w
abs r0, r0
mad r1, -r0, c26.x, c26.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c22
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c26
mul r0.xz, r0.w, v2
mul r0.y, v4, c26.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c22.w, r2
mad r1.xyz, v4.x, c22, r0
dp3 r0.x, r1, c20
add r0.x, r0, c20.w
mul r0.xyz, r0.x, c20
add r1.xyz, -r0, r1
mad r0.xyz, r0, c21.x, r1
mov r0.w, c24.x
dp4 r2.w, r0, c3
dp4 r2.z, r0, c2
dp4 r2.x, r0, c0
dp4 r2.y, r0, c1
mul r1.xyz, r2.xyww, c27.x
mul r1.y, r1, c9.x
mov o0, r2
mov o3.zw, r2
mad o3.xy, r1.z, c10.zwzw, r1
dp3 r1.w, v2, v2
rsq r1.x, r1.w
mul r1.xyz, r1.x, v2
mul r0.xyz, r1, c18.w
dp3 r1.w, r0, c5
dp3 r2.x, r0, c4
dp3 r2.z, r0, c6
mov r2.y, r1.w
mul r0, r2.xyzz, r2.yzzx
mov r2.w, c24.x
dp4 r4.z, r0, c16
dp4 r4.y, r0, c15
dp4 r4.x, r0, c14
mul r0.w, r1, r1
dp4 r3.z, r2, c13
dp4 r3.y, r2, c12
dp4 r3.x, r2, c11
dp3 r2.y, v1, v1
rsq r0.x, r2.y
add r3.xyz, r3, r4
mul r0.xyz, r0.x, v1
mul r4.xyz, r1.zxyw, r0.yzxw
mad r0.w, r2.x, r2.x, -r0
mad r2.xyz, r1.yzxw, r0.zxyw, -r4
mul r4.xyz, r0.w, c17
add o7.xyz, r3, r4
mul r2.xyz, r2, v1.w
dp3 r3.y, r2, c4
dp3 r3.x, r0, c4
dp3 r3.z, r1, c4
mul o4.xyz, r3, c18.w
dp3 r3.y, r2, c5
dp3 r2.y, r2, c6
dp3 r3.x, r0, c5
dp3 r3.z, r1, c5
dp3 r2.x, r0, c6
dp3 r2.z, r1, c6
mul o5.xyz, r3, c18.w
mul o6.xyz, r2, c18.w
mov o2.xyz, c24.x
mad o1.xy, v3, c23, c23.zwzw
mov o2.w, v5
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
ConstBuffer "$Globals" 240
Vector 48 [_Wind]
Vector 208 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
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
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecednccjblphbbijeknbbdfpknjmechgbldfabaaaaaanmanaaaaadaaaaaa
cmaaaaaapeaaaaaaoaabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooeaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaannaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
fdeieefcpealaaaaeaaaabaapnacaaaafjaaaaaeegiocaaaaaaaaaaaaoaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaamaaaaaa
fpaaaaadhcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaad
lcbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
gfaaaaadhccabaaaahaaaaaagiaaaaacafaaaaaadgaaaaagbcaabaaaaaaaaaaa
dkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaak
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaa
aaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaai
hcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaa
aaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdo
bkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialp
diaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaa
aaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaea
aaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaa
adaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaa
bkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaa
aaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdo
dcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaa
adaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaa
egiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaa
pgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadgaaaaaihccabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaadgaaaaaficcabaaa
acaaaaaadkbabaaaafaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadiaaaaah
hcaabaaaacaaaaaajgaebaaaaaaaaaaacgajbaaaabaaaaaadcaaaaakhcaabaaa
acaaaaaajgaebaaaabaaaaaacgajbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgbpbaaaabaaaaaadgaaaaag
bcaabaaaadaaaaaaakiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaa
akiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaaakiacaaaadaaaaaa
aoaaaaaabaaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaa
baaaaaahbcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaa
aeaaaaaaegacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaa
adaaaaaabkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaabkiacaaa
adaaaaaaanaaaaaadgaaaaagecaabaaaadaaaaaabkiacaaaadaaaaaaaoaaaaaa
baaaaaahccaabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaah
bcaabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaa
aeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihccabaaaafaaaaaa
egacbaaaaeaaaaaapgipcaaaadaaaaaabeaaaaaadgaaaaagbcaabaaaadaaaaaa
ckiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaaadaaaaaackiacaaaadaaaaaa
anaaaaaadgaaaaagecaabaaaadaaaaaackiacaaaadaaaaaaaoaaaaaabaaaaaah
ccaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaabaaaaaahbcaabaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaahecaabaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
abaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihccabaaaagaaaaaaegacbaaa
acaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaahaaaaaaegiccaaa
acaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
SetTexture 3 [_LightBuffer] 2D 3
"ps_3_0
; 35 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c6, 2.00000000, -1.00000000, 1.00000000, 0.16666667
def c7, 255.00000000, 0.00392157, 0.00000000, 1.00000000
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c6.x, c6.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c6.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3_pp r0.x, r1, v5
dp3_pp r0.w, r1, v4
mul r0.xyz, r0.x, c2
mad r2.xyz, r0.w, c1, r0
dp3_pp r0.w, v3, r1
mad r1.xyz, r0.w, c0, r2
texld r1, r1, s2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, v1.w
mul_pp r2.xyz, r1, r1.w
mul_pp r1.xyz, r0, c5.w
texldp r0.xyz, v2, s3
mul_pp r2.xyz, r1, r2
mul_pp r2.xyz, r2, c5.x
log_pp r0.x, r0.x
log_pp r0.z, r0.z
log_pp r0.y, r0.y
add_pp r0.xyz, -r0, v6
mad_pp r0.xyz, r1, r0, r2
mul r0.xyz, r0, c6.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7.y
cmp r1.x, -r0.w, c7.z, c7.w
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.z, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_DiffCubeIBL] CUBE 0
SetTexture 3 [_LightBuffer] 2D 3
ConstBuffer "$Globals" 240
Matrix 128 [SkyMatrix]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkipbcfhpinjnbknbmhddofhhjgjfciodabaaaaaahmahaaaaadaaaaaa
cmaaaaaabiabaaaaemabaaaaejfdeheooeaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaannaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklklfdeieefcciagaaaaeaaaaaaaikabaaaafjaaaaae
egiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaa
agaaaaaagcbaaaadhcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaai
icaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaaf
ecaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
afaaaaaaegacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaajaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaakaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaagaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
akaaaaaaaaaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaaagajbaaaacaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaaiccaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaaiecaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaa
aaaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaahaaaaaaaoaaaaahdcaabaaa
acaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaacpaaaaafhcaabaaa
acaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaa
acaaaaaaegbcbaaaahaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaah
icaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaa
dicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaah
pccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
SetTexture 3 [_LightBuffer] 2D 3
"ps_3_0
; 32 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c6, 2.00000000, -1.00000000, 1.00000000, 0.16666667
def c7, 255.00000000, 0.00392157, 0.00000000, 1.00000000
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c6.x, c6.y
mul_pp r0.xy, r1, r1
add_pp_sat r0.x, r0, r0.y
add_pp r0.x, -r0, c6.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3_pp r0.x, r1, v5
dp3_pp r0.w, r1, v4
mul r0.xyz, r0.x, c2
mad r2.xyz, r0.w, c1, r0
dp3_pp r0.w, v3, r1
mad r1.xyz, r0.w, c0, r2
texld r1, r1, s2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, v1.w
mul_pp r2.xyz, r1, r1.w
mul_pp r1.xyz, r0, c5.w
mul_pp r2.xyz, r1, r2
texldp r0.xyz, v2, s3
mul_pp r2.xyz, r2, c5.x
add_pp r0.xyz, r0, v6
mad_pp r0.xyz, r1, r0, r2
mul r0.xyz, r0, c6.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7.y
cmp r1.x, -r0.w, c7.z, c7.w
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.z, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_DiffCubeIBL] CUBE 0
SetTexture 3 [_LightBuffer] 2D 3
ConstBuffer "$Globals" 240
Matrix 128 [SkyMatrix]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedhagdobijjlfdhjnbinbfkolkmfflhboaabaaaaaageahaaaaadaaaaaa
cmaaaaaabiabaaaaemabaaaaejfdeheooeaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaannaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklklfdeieefcbaagaaaaeaaaaaaaieabaaaafjaaaaae
egiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaa
agaaaaaagcbaaaadhcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaai
icaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaaf
ecaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
afaaaaaaegacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaajaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaakaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaagaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
akaaaaaaaaaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaaagajbaaaacaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaaiccaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaaiecaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaa
aaaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaahaaaaaaaoaaaaahdcaabaaa
acaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegbcbaaaahaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaa
deaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
ibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaa
aoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
dkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaa
acaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
SetTexture 3 [_LightBuffer] 2D 3
"ps_3_0
; 64 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c6, 2.00000000, -1.00000000, 1.00000000, 0.45454544
def c7, 0.75341797, 0.24682617, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 2.20000005
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c6.x, c6.y
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
add_pp r0.z, -r0, c6
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, v5
mul r1.xyz, r0.w, c2
dp3_pp r0.w, r0, v4
mad r1.xyz, r0.w, c1, r1
dp3_pp r0.x, v3, r0
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s2
mul_pp r2.x, r0.w, r0.w
mul_pp r2.y, r0.w, r2.x
mul_pp r2.xy, r2, c7
add_pp r0.w, r2.x, r2.y
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, v1.w
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c5.w
mul_pp r2.xyz, r1, r0
texldp r0.xyz, v2, s3
mul_pp r2.xyz, r2, c5.x
log_pp r0.x, r0.x
log_pp r0.z, r0.z
log_pp r0.y, r0.y
add_pp r0.xyz, -r0, v6
mad_pp r1.xyz, r1, r0, r2
pow r0, r1.x, c6.w
pow r2, r1.y, c6.w
mov r1.x, r0
pow r0, r1.z, c6.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.y, c8.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.y, r0
pow r0, r1.x, c8.w
mov oC0.x, r0
pow r0, r1.y, c8.w
pow r2, r1.z, c8.w
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_DiffCubeIBL] CUBE 0
SetTexture 3 [_LightBuffer] 2D 3
ConstBuffer "$Globals" 240
Matrix 128 [SkyMatrix]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedanafpnnfnccpclgidkiaelbimfdlohflabaaaaaaneaiaaaaadaaaaaa
cmaaaaaabiabaaaaemabaaaaejfdeheooeaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaannaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklklfdeieefciaahaaaaeaaaaaaaoaabaaaafjaaaaae
egiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaa
agaaaaaagcbaaaadhcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaai
icaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaaf
ecaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
afaaaaaaegacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaajaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaakaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaagaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
akaaaaaaaaaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaaagajbaaaacaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaaiccaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaaiecaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaa
aaaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
diaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
ccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaaapaaaaakicaabaaa
aaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaahaaaaaaaoaaaaahdcaabaaa
acaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaacpaaaaafhcaabaaa
acaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaa
acaaaaaaegbcbaaaahaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoido
cplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaa
abaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaaf
hccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_DiffCubeIBL] CUBE 2
SetTexture 3 [_LightBuffer] 2D 3
"ps_3_0
; 61 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c6, 2.00000000, -1.00000000, 1.00000000, 0.45454544
def c7, 0.75341797, 0.24682617, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 2.20000005
dcl_texcoord0 v0.xy
dcl_color0 v1.xyzw
dcl_texcoord1 v2
dcl_texcoord2 v3.xyz
dcl_texcoord3 v4.xyz
dcl_texcoord4 v5.xyz
dcl_texcoord5 v6.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c6.x, c6.y
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
add_pp r0.z, -r0, c6
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, v5
mul r1.xyz, r0.w, c2
dp3_pp r0.w, r0, v4
mad r1.xyz, r0.w, c1, r1
dp3_pp r0.x, v3, r0
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s2
mul_pp r2.x, r0.w, r0.w
mul_pp r2.y, r0.w, r2.x
mul_pp r2.xy, r2, c7
add_pp r0.w, r2.x, r2.y
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, v1.w
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c5.w
mul_pp r2.xyz, r1, r0
texldp r0.xyz, v2, s3
mul_pp r2.xyz, r2, c5.x
add_pp r0.xyz, r0, v6
mad_pp r1.xyz, r1, r0, r2
pow r0, r1.x, c6.w
pow r2, r1.y, c6.w
mov r1.x, r0
pow r0, r1.z, c6.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.y, c8.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.y, r0
pow r0, r1.x, c8.w
mov oC0.x, r0
pow r0, r1.y, c8.w
pow r2, r1.z, c8.w
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_BumpMap] 2D 2
SetTexture 2 [_DiffCubeIBL] CUBE 0
SetTexture 3 [_LightBuffer] 2D 3
ConstBuffer "$Globals" 240
Matrix 128 [SkyMatrix]
Vector 64 [_Color]
Vector 112 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedhfdkbpjbkljckjhojpfdjilkaffklidaabaaaaaalmaiaaaaadaaaaaa
cmaaaaaabiabaaaaemabaaaaejfdeheooeaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaannaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaiaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaneaaaaaa
acaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaahaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklklfdeieefcgiahaaaaeaaaaaaankabaaaafjaaaaae
egiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafidaaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadicbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaa
agaaaaaagcbaaaadhcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaapdcaabaaaaaaaaaaahgapbaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaaaaaaaaaa
ddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaai
icaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpelaaaaaf
ecaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
afaaaaaaegacbaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaiccaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaajaaaaaadiaaaaaiecaabaaaabaaaaaadkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaakaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaagaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaa
aaaaaaaadiaaaaaibcaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
aiaaaaaadiaaaaaiccaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaadiaaaaaiecaabaaaacaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
akaaaaaaaaaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaaagajbaaaacaaaaaa
diaaaaaibcaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
diaaaaaiccaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaaiecaabaaaabaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaa
aaaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
diaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
ccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaaapaaaaakicaabaaa
aaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgbpbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaahaaaaaaaoaaaaahdcaabaaa
acaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaa
egaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegbcbaaaahaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
klkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaa
dkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahped
ecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaa
aaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmamea
aaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "SHADOWCASTER"
  Tags { "LIGHTMODE"="SHADOWCASTER" "RenderType"="TreeBark" }
  Cull Off
  Fog { Mode Off }
  Offset 1, 1
Program "vp" {
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;

uniform vec4 unity_LightShadowBias;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (gl_ModelViewProjectionMatrix * tmpvar_11);
  tmpvar_1.xyw = tmpvar_12.xyw;
  tmpvar_1.z = (tmpvar_12.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_12.w * -1.0)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _BumpMap;
void main ()
{
  vec2 tmpvar_1;
  vec3 normal_2;
  normal_2.xy = ((texture2D (_BumpMap, tmpvar_1).wy * 2.0) - 1.0);
  normal_2.z = sqrt((1.0 - clamp (dot (normal_2.xy, normal_2.xy), 0.0, 1.0)));
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_DEPTH" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [unity_LightShadowBias]
Vector 10 [_Scale]
Vector 11 [_SquashPlaneNormal]
Float 12 [_SquashAmount]
Vector 13 [_Wind]
"vs_3_0
; 46 ALU
dcl_position o0
dcl_texcoord0 o1
def c14, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c15, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c16, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c17, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c14.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c10
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c15
frc r0, r0
mad r0, r0, c14.y, c14.z
frc r0, r0
mad r0, r0, c14.y, c14.w
abs r0, r0
mad r1, -r0, c16.x, c16.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c13
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c16
mov r1.w, c14.x
mul r0.xz, r0.w, v2
mul r0.y, v4, c16.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c13.w, r2
mad r1.xyz, v4.x, c13, r0
dp3 r0.x, r1, c11
add r0.x, r0, c11.w
mul r0.xyz, r0.x, c11
add r1.xyz, -r0, r1
mad r1.xyz, r0, c12.x, r1
dp4 r0.x, r1, c2
add r0.x, r0, c9
max r0.y, r0.x, c17.x
add r0.y, r0, -r0.x
mad r0.z, r0.y, c9.y, r0.x
dp4 r0.w, r1, c3
dp4 r0.x, r1, c0
dp4 r0.y, r1, c1
mov o0, r0
mov o1, r0
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_DEPTH" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityShadows" 416
Vector 80 [unity_LightShadowBias]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedeombomdchfdbafpijhnghepeiedihcgaabaaaaaadaahaaaaadaaaaaa
cmaaaaaapeaaaaaaciabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafdeieefcaaagaaaaeaaaabaaiaabaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaa
acaaaaaaagaaaaaafjaaaaaeegiocaaaadaaaaaaapaaaaaafjaaaaaeegiocaaa
aeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaaacaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagiaaaaacaeaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
aaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaah
ecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaa
agafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaaj
pcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaa
dcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaea
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaah
dcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaa
bkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaa
afaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaa
agbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaaj
hcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaa
aaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaa
aeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaia
ebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaaaaaaaaaiecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakiacaaaacaaaaaaafaaaaaadgaaaaaflccabaaaaaaaaaaa
egambaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaaaaaaaaibcaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakeccabaaaaaaaaaaabkiacaaaacaaaaaaafaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_2;
  pos_2.w = tmpvar_1.w;
  vec3 bend_3;
  vec4 v_4;
  v_4.x = _Object2World[0].w;
  v_4.y = _Object2World[1].w;
  v_4.z = _Object2World[2].w;
  v_4.w = _Object2World[3].w;
  float tmpvar_5;
  tmpvar_5 = (dot (v_4.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_6;
  tmpvar_6.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_5)));
  tmpvar_6.y = tmpvar_5;
  vec4 tmpvar_7;
  tmpvar_7 = abs(((fract((((fract(((_Time.yy + tmpvar_6).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_8;
  tmpvar_8 = ((tmpvar_7 * tmpvar_7) * (3.0 - (2.0 * tmpvar_7)));
  vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_8.xz + tmpvar_8.yw);
  bend_3.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_3.y = (gl_MultiTexCoord1.y * 0.3);
  pos_2.xyz = (tmpvar_1.xyz + (((tmpvar_9.xyx * bend_3) + ((_Wind.xyz * tmpvar_9.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_2.xyz = (pos_2.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = mix ((pos_2.xyz - ((dot (_SquashPlaneNormal.xyz, pos_2.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_2.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_10);
  xlv_TEXCOORD0 = ((_Object2World * tmpvar_10).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform vec4 _LightPositionRange;
void main ()
{
  vec2 tmpvar_1;
  vec3 normal_2;
  normal_2.xy = ((texture2D (_BumpMap, tmpvar_1).wy * 2.0) - 1.0);
  normal_2.z = sqrt((1.0 - clamp (dot (normal_2.xy, normal_2.xy), 0.0, 1.0)));
  vec4 tmpvar_3;
  tmpvar_3 = fract((vec4(1.0, 255.0, 65025.0, 1.60581e+08) * min ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w), 0.999)));
  gl_FragData[0] = (tmpvar_3 - (tmpvar_3.yzww * 0.00392157));
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_CUBE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_LightPositionRange]
Vector 10 [_Scale]
Vector 11 [_SquashPlaneNormal]
Float 12 [_SquashAmount]
Vector 13 [_Wind]
"vs_3_0
; 44 ALU
dcl_position o0
dcl_texcoord0 o1
def c14, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c15, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c16, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c14.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c10
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c15
frc r0, r0
mad r0, r0, c14.y, c14.z
frc r0, r0
mad r0, r0, c14.y, c14.w
abs r0, r0
mad r1, -r0, c16.x, c16.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c13
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c16
mov r1.w, c14.x
mul r0.xz, r0.w, v2
mul r0.y, v4, c16.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c13.w, r2
mad r1.xyz, v4.x, c13, r0
dp3 r0.x, r1, c11
add r0.x, r0, c11.w
mul r0.xyz, r0.x, c11
add r1.xyz, -r0, r1
mad r1.xyz, r0, c12.x, r1
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
add o1.xyz, r0, -c9
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_CUBE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedkhbkipafophochafhoajghgdcpblnlaiabaaaaaahmahaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciagaaaaeaaaabaaikabaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaaacaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafjaaaaae
egiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaa
acaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaacaeaaaaaa
dgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaa
aaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaa
adaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaa
aaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaa
aeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaa
aaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaa
aaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdp
amaceldpaaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialp
aaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaa
aaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaia
mbaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaa
igaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaa
aeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaah
fcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaa
aaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaa
baaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaa
dcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaa
alaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaaaaaaaaajhccabaaaabaaaaaa
egacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;

uniform vec4 unity_LightShadowBias;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (gl_ModelViewProjectionMatrix * tmpvar_11);
  tmpvar_1.xyw = tmpvar_12.xyw;
  tmpvar_1.z = (tmpvar_12.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_12.w * -1.0)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _BumpMap;
void main ()
{
  vec2 tmpvar_1;
  vec3 normal_2;
  normal_2.xy = ((texture2D (_BumpMap, tmpvar_1).wy * 2.0) - 1.0);
  normal_2.z = sqrt((1.0 - clamp (dot (normal_2.xy, normal_2.xy), 0.0, 1.0)));
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_DEPTH" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [unity_LightShadowBias]
Vector 10 [_Scale]
Vector 11 [_SquashPlaneNormal]
Float 12 [_SquashAmount]
Vector 13 [_Wind]
"vs_3_0
; 46 ALU
dcl_position o0
dcl_texcoord0 o1
def c14, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c15, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c16, 2.00000000, 3.00000000, 0.30000001, 0.10000000
def c17, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c14.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c10
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c15
frc r0, r0
mad r0, r0, c14.y, c14.z
frc r0, r0
mad r0, r0, c14.y, c14.w
abs r0, r0
mad r1, -r0, c16.x, c16.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c13
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c16
mov r1.w, c14.x
mul r0.xz, r0.w, v2
mul r0.y, v4, c16.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c13.w, r2
mad r1.xyz, v4.x, c13, r0
dp3 r0.x, r1, c11
add r0.x, r0, c11.w
mul r0.xyz, r0.x, c11
add r1.xyz, -r0, r1
mad r1.xyz, r0, c12.x, r1
dp4 r0.x, r1, c2
add r0.x, r0, c9
max r0.y, r0.x, c17.x
add r0.y, r0, -r0.x
mad r0.z, r0.y, c9.y, r0.x
dp4 r0.w, r1, c3
dp4 r0.x, r1, c0
dp4 r0.y, r1, c1
mov o0, r0
mov o1, r0
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_DEPTH" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityShadows" 416
Vector 80 [unity_LightShadowBias]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedeombomdchfdbafpijhnghepeiedihcgaabaaaaaadaahaaaaadaaaaaa
cmaaaaaapeaaaaaaciabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafdeieefcaaagaaaaeaaaabaaiaabaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaa
acaaaaaaagaaaaaafjaaaaaeegiocaaaadaaaaaaapaaaaaafjaaaaaeegiocaaa
aeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaaacaaaaaa
fpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagiaaaaacaeaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
aaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaah
ecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaa
agafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaaj
pcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaa
dcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaea
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaah
dcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaa
bkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaa
afaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaa
agbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaaj
hcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaa
aaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaa
aeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaia
ebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaaaaaaaaaiecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakiacaaaacaaaaaaafaaaaaadgaaaaaflccabaaaaaaaaaaa
egambaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaaaaaaaaibcaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakeccabaaaaaaaaaaabkiacaaaacaaaaaaafaaaaaaakaabaaa
aaaaaaaackaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;

uniform vec4 _LightPositionRange;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  tmpvar_1.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_2;
  pos_2.w = tmpvar_1.w;
  vec3 bend_3;
  vec4 v_4;
  v_4.x = _Object2World[0].w;
  v_4.y = _Object2World[1].w;
  v_4.z = _Object2World[2].w;
  v_4.w = _Object2World[3].w;
  float tmpvar_5;
  tmpvar_5 = (dot (v_4.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_6;
  tmpvar_6.x = dot (tmpvar_1.xyz, vec3((gl_Color.y + tmpvar_5)));
  tmpvar_6.y = tmpvar_5;
  vec4 tmpvar_7;
  tmpvar_7 = abs(((fract((((fract(((_Time.yy + tmpvar_6).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_8;
  tmpvar_8 = ((tmpvar_7 * tmpvar_7) * (3.0 - (2.0 * tmpvar_7)));
  vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_8.xz + tmpvar_8.yw);
  bend_3.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_3.y = (gl_MultiTexCoord1.y * 0.3);
  pos_2.xyz = (tmpvar_1.xyz + (((tmpvar_9.xyx * bend_3) + ((_Wind.xyz * tmpvar_9.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_2.xyz = (pos_2.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = mix ((pos_2.xyz - ((dot (_SquashPlaneNormal.xyz, pos_2.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_2.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_10);
  xlv_TEXCOORD0 = ((_Object2World * tmpvar_10).xyz - _LightPositionRange.xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform vec4 _LightPositionRange;
void main ()
{
  vec2 tmpvar_1;
  vec3 normal_2;
  normal_2.xy = ((texture2D (_BumpMap, tmpvar_1).wy * 2.0) - 1.0);
  normal_2.z = sqrt((1.0 - clamp (dot (normal_2.xy, normal_2.xy), 0.0, 1.0)));
  vec4 tmpvar_3;
  tmpvar_3 = fract((vec4(1.0, 255.0, 65025.0, 1.60581e+08) * min ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w), 0.999)));
  gl_FragData[0] = (tmpvar_3 - (tmpvar_3.yzww * 0.00392157));
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_CUBE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_LightPositionRange]
Vector 10 [_Scale]
Vector 11 [_SquashPlaneNormal]
Float 12 [_SquashAmount]
Vector 13 [_Wind]
"vs_3_0
; 44 ALU
dcl_position o0
dcl_texcoord0 o1
def c14, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c15, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c16, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c7
dp3 r0.x, c14.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mul r2.xyz, v0, c10
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c8.y
mul r0, r0.xxyy, c15
frc r0, r0
mad r0, r0, c14.y, c14.z
frc r0, r0
mad r0, r0, c14.y, c14.w
abs r0, r0
mad r1, -r0, c16.x, c16.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c13
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c16
mov r1.w, c14.x
mul r0.xz, r0.w, v2
mul r0.y, v4, c16.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c13.w, r2
mad r1.xyz, v4.x, c13, r0
dp3 r0.x, r1, c11
add r0.x, r0, c11.w
mul r0.xyz, r0.x, c11
add r1.xyz, -r0, r1
mad r1.xyz, r0, c12.x, r1
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
add o1.xyz, r0, -c9
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_CUBE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedkhbkipafophochafhoajghgdcpblnlaiabaaaaaahmahaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciagaaaaeaaaabaaikabaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaaacaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafjaaaaae
egiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaa
acaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaacaeaaaaaa
dgaaaaagbcaabaaaaaaaaaaadkiacaaaadaaaaaaamaaaaaadgaaaaagccaabaaa
aaaaaaaadkiacaaaadaaaaaaanaaaaaadgaaaaagecaabaaaaaaaaaaadkiacaaa
adaaaaaaaoaaaaaabaaaaaakbcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaa
aaaaaaaaakbabaaaafaaaaaaaaaaaaahecaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkbabaaaafaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaaaaaaaaaegiccaaa
aeaaaaaaafaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaabaaaaaakgakbaaa
aaaaaaaaaaaaaaaipcaabaaaaaaaaaaaagafbaaaaaaaaaaafgifcaaaabaaaaaa
aaaaaaaadiaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmpmdp
amaceldpaaaamadomlkbefdobkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaaalpaaaaaalpaaaaaalpaaaaaalpbkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaialp
aaaaialpaaaaialpaaaaialpdiaaaaajpcaabaaaacaaaaaaegaobaiaibaaaaaa
aaaaaaaaegaobaiaibaaaaaaaaaaaaaadcaaaabapcaabaaaaaaaaaaaegaobaia
mbaaaaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaa
aaaaeaeaaaaaeaeaaaaaeaeaaaaaeaeadiaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaacaaaaaaaaaaaaahdcaabaaaaaaaaaaangafbaaaaaaaaaaa
igaabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaa
aaaaaaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgbfbaaa
aeaaaaaadiaaaaahccaabaaaadaaaaaabkaabaaaaaaaaaaabkbabaaaaeaaaaaa
diaaaaahccaabaaaaaaaaaaabkbabaaaafaaaaaaabeaaaaamnmmmmdndiaaaaah
fcaabaaaadaaaaaafgafbaaaaaaaaaaaagbcbaaaacaaaaaadgaaaaafecaabaaa
aaaaaaaaabeaaaaajkjjjjdodcaaaaajhcaabaaaaaaaaaaaigaabaaaaaaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaagbabaaaaeaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaa
baaaaaaiicaabaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaeaaaaaaakaaaaaa
dcaaaaalhcaabaaaabaaaaaapgapbaiaebaaaaaaaaaaaaaaegiccaaaaeaaaaaa
akaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagiacaaaaeaaaaaa
alaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaaaaaaaaaipccabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaaaaaaaaajhccabaaaabaaaaaa
egacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_DEPTH" "MARMO_GAMMA" }
"ps_3_0
; 2 ALU
dcl_texcoord0 v0.xyzw
rcp r0.x, v0.w
mul oC0, v0.z, r0.x
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_DEPTH" "MARMO_GAMMA" }
"ps_4_0
eefiecedcbejcgfjfchfioiockkbgpdagbgpkifoabaaaaaaneaaaaaaadaaaaaa
cmaaaaaagaaaaaaajeaaaaaaejfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiaaaaaaeaaaaaaa
aoaaaaaagfaaaaadpccabaaaaaaaaaaadgaaaaaipccabaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_CUBE" "MARMO_GAMMA" }
Vector 4 [_LightPositionRange]
"ps_3_0
; 8 ALU
def c5, 0.99900001, 0.00392157, 0, 0
def c6, 1.00000000, 255.00000000, 65025.00000000, 160581376.00000000
dcl_texcoord0 v0.xyz
dp3 r0.x, v0, v0
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r0.x, r0, c4.w
min r0.x, r0, c5
mul r0, r0.x, c6
frc r0, r0
mad oC0, -r0.yzww, c5.y, r0
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_CUBE" "MARMO_GAMMA" }
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
BindCB  "UnityLighting" 0
"ps_4_0
eefiecedeffbmdkmmbgglefcljablkglnmdbenjkabaaaaaaniabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbiabaaaa
eaaaaaaaegaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaagcbaaaadhcbabaaa
abaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaa
aaaaaaaaabaaaaaaddaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
hhlohpdpdiaaaaakpcaabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaahpedaaabhoehhacebjenbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaanpccabaaaaaaaaaaajgapbaiaebaaaaaaaaaaaaaaaceaaaaaibiaiadl
ibiaiadlibiaiadlibiaiadlegaobaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_DEPTH" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_DEPTH" "MARMO_LINEAR" }
"ps_3_0
; 2 ALU
dcl_texcoord0 v0.xyzw
rcp r0.x, v0.w
mul oC0, v0.z, r0.x
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_DEPTH" "MARMO_LINEAR" }
"ps_4_0
eefiecedcbejcgfjfchfioiockkbgpdagbgpkifoabaaaaaaneaaaaaaadaaaaaa
cmaaaaaagaaaaaaajeaaaaaaejfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiaaaaaaeaaaaaaa
aoaaaaaagfaaaaadpccabaaaaaaaaaaadgaaaaaipccabaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_CUBE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_CUBE" "MARMO_LINEAR" }
Vector 4 [_LightPositionRange]
"ps_3_0
; 8 ALU
def c5, 0.99900001, 0.00392157, 0, 0
def c6, 1.00000000, 255.00000000, 65025.00000000, 160581376.00000000
dcl_texcoord0 v0.xyz
dp3 r0.x, v0, v0
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r0.x, r0, c4.w
min r0.x, r0, c5
mul r0, r0.x, c6
frc r0, r0
mad oC0, -r0.yzww, c5.y, r0
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_CUBE" "MARMO_LINEAR" }
ConstBuffer "UnityLighting" 720
Vector 16 [_LightPositionRange]
BindCB  "UnityLighting" 0
"ps_4_0
eefiecedeffbmdkmmbgglefcljablkglnmdbenjkabaaaaaaniabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbiabaaaa
eaaaaaaaegaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaagcbaaaadhcbabaaa
abaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaa
aaaaaaaaabaaaaaaddaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
hhlohpdpdiaaaaakpcaabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaahpedaaabhoehhacebjenbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaanpccabaaaaaaaaaaajgapbaiaebaaaaaaaaaaaaaaaceaaaaaibiaiadl
ibiaiadlibiaiadlibiaiadlegaobaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "SHADOWCOLLECTOR"
  Tags { "LIGHTMODE"="SHADOWCOLLECTOR" "RenderType"="TreeBark" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "SHADOWS_NONATIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightShadowData;
uniform vec4 _LightSplitsFar;
uniform vec4 _LightSplitsNear;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec2 tmpvar_2;
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, tmpvar_2).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 tmpvar_4;
  tmpvar_4 = (vec4(greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear)) * vec4(lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar)));
  float tmpvar_5;
  tmpvar_5 = clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = ((((xlv_TEXCOORD0 * tmpvar_4.x) + (xlv_TEXCOORD1 * tmpvar_4.y)) + (xlv_TEXCOORD2 * tmpvar_4.z)) + (xlv_TEXCOORD3 * tmpvar_4.w));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_ShadowMapTexture, tmpvar_6.xy);
  float tmpvar_8;
  if ((tmpvar_7.x < tmpvar_6.z)) {
    tmpvar_8 = _LightShadowData.x;
  } else {
    tmpvar_8 = 1.0;
  };
  res_1.x = clamp ((tmpvar_8 + tmpvar_5), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_9;
  vec2 tmpvar_10;
  tmpvar_10 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_9.y = tmpvar_10.y;
  enc_9.x = (tmpvar_10.x - (tmpvar_10.y * 0.00392157));
  res_1.zw = enc_9;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "SHADOWS_NONATIVE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 _LightShadowData;
uniform vec4 _LightSplitsFar;
uniform vec4 _LightSplitsNear;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec2 tmpvar_2;
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, tmpvar_2).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 tmpvar_4;
  tmpvar_4 = (vec4(greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear)) * vec4(lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar)));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = ((((xlv_TEXCOORD0 * tmpvar_4.x) + (xlv_TEXCOORD1 * tmpvar_4.y)) + (xlv_TEXCOORD2 * tmpvar_4.z)) + (xlv_TEXCOORD3 * tmpvar_4.w));
  res_1.x = clamp (((_LightShadowData.x + (shadow2D (_ShadowMapTexture, tmpvar_5.xyz).x * (1.0 - _LightShadowData.x))) + clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_6;
  vec2 tmpvar_7;
  tmpvar_7 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_6.y = tmpvar_7.y;
  enc_6.x = (tmpvar_7.x - (tmpvar_7.y * 0.00392157));
  res_1.zw = enc_6;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedegokfljmmknppnmegbdjpoibgmiipfieabaaaaaaaealaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcfaajaaaaeaaaabaafeacaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabiaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafjaaaaae
egiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaa
acaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagiaaaaacaeaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
aaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaah
ecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaa
agafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaaj
pcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaa
dcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaea
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaah
dcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaa
bkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaa
afaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaa
agbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaaj
hcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaa
aaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaa
aeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaia
ebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaa
egaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaaaaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaa
apaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
akaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaabaaaaaa
egiccaaaacaaaaaaalaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaa
apaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabaaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaabcaaaaaakgakbaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaabdaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaabfaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
beaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabgaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hccabaaaaeaaaaaaegiccaaaacaaaaaabhaaaaaapgapbaaaabaaaaaaegacbaaa
acaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaaeaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaackaabaaaaaaaaaaa
akaabaaaaaaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadgaaaaagiccabaaaafaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_GAMMA" "SHADOWS_NONATIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _ShadowMapTexture;
uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _LightShadowData;
uniform vec4 unity_ShadowSplitSqRadii;
uniform vec4 unity_ShadowSplitSpheres[4];
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec4 cascadeWeights_2;
  vec2 tmpvar_3;
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, tmpvar_3).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  vec4 tmpvar_9;
  tmpvar_9.x = dot (tmpvar_5, tmpvar_5);
  tmpvar_9.y = dot (tmpvar_6, tmpvar_6);
  tmpvar_9.z = dot (tmpvar_7, tmpvar_7);
  tmpvar_9.w = dot (tmpvar_8, tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = vec4(lessThan (tmpvar_9, unity_ShadowSplitSqRadii));
  cascadeWeights_2.x = tmpvar_10.x;
  cascadeWeights_2.yzw = clamp ((tmpvar_10.yzw - tmpvar_10.xyz), 0.0, 1.0);
  vec3 p_11;
  p_11 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  float tmpvar_12;
  tmpvar_12 = clamp (((sqrt(dot (p_11, p_11)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((((xlv_TEXCOORD0 * tmpvar_10.x) + (xlv_TEXCOORD1 * cascadeWeights_2.y)) + (xlv_TEXCOORD2 * cascadeWeights_2.z)) + (xlv_TEXCOORD3 * cascadeWeights_2.w));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_13.z)) {
    tmpvar_15 = _LightShadowData.x;
  } else {
    tmpvar_15 = 1.0;
  };
  res_1.x = clamp ((tmpvar_15 + tmpvar_12), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_16;
  vec2 tmpvar_17;
  tmpvar_17 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_16.y = tmpvar_17.y;
  enc_16.x = (tmpvar_17.x - (tmpvar_17.y * 0.00392157));
  res_1.zw = enc_16;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_GAMMA" "SHADOWS_NONATIVE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _LightShadowData;
uniform vec4 unity_ShadowSplitSqRadii;
uniform vec4 unity_ShadowSplitSpheres[4];
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec4 cascadeWeights_2;
  vec2 tmpvar_3;
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, tmpvar_3).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  vec4 tmpvar_9;
  tmpvar_9.x = dot (tmpvar_5, tmpvar_5);
  tmpvar_9.y = dot (tmpvar_6, tmpvar_6);
  tmpvar_9.z = dot (tmpvar_7, tmpvar_7);
  tmpvar_9.w = dot (tmpvar_8, tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = vec4(lessThan (tmpvar_9, unity_ShadowSplitSqRadii));
  cascadeWeights_2.x = tmpvar_10.x;
  cascadeWeights_2.yzw = clamp ((tmpvar_10.yzw - tmpvar_10.xyz), 0.0, 1.0);
  vec3 p_11;
  p_11 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = ((((xlv_TEXCOORD0 * tmpvar_10.x) + (xlv_TEXCOORD1 * cascadeWeights_2.y)) + (xlv_TEXCOORD2 * cascadeWeights_2.z)) + (xlv_TEXCOORD3 * cascadeWeights_2.w));
  res_1.x = clamp (((_LightShadowData.x + (shadow2D (_ShadowMapTexture, tmpvar_12.xyz).x * (1.0 - _LightShadowData.x))) + clamp (((sqrt(dot (p_11, p_11)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_13;
  vec2 tmpvar_14;
  tmpvar_14 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_13.y = tmpvar_14.y;
  enc_13.x = (tmpvar_14.x - (tmpvar_14.y * 0.00392157));
  res_1.zw = enc_13;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedegokfljmmknppnmegbdjpoibgmiipfieabaaaaaaaealaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcfaajaaaaeaaaabaafeacaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabiaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafjaaaaae
egiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaa
acaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagiaaaaacaeaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
aaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaah
ecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaa
agafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaaj
pcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaa
dcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaea
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaah
dcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaa
bkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaa
afaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaa
agbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaaj
hcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaa
aaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaa
aeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaia
ebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaa
egaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaaaaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaa
apaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
akaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaabaaaaaa
egiccaaaacaaaaaaalaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaa
apaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabaaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaabcaaaaaakgakbaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaabdaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaabfaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
beaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabgaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hccabaaaaeaaaaaaegiccaaaacaaaaaabhaaaaaapgapbaaaabaaaaaaegacbaaa
acaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaaeaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaackaabaaaaaaaaaaa
akaabaaaaaaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadgaaaaagiccabaaaafaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "SHADOWS_NONATIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightShadowData;
uniform vec4 _LightSplitsFar;
uniform vec4 _LightSplitsNear;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec2 tmpvar_2;
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, tmpvar_2).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 tmpvar_4;
  tmpvar_4 = (vec4(greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear)) * vec4(lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar)));
  float tmpvar_5;
  tmpvar_5 = clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = ((((xlv_TEXCOORD0 * tmpvar_4.x) + (xlv_TEXCOORD1 * tmpvar_4.y)) + (xlv_TEXCOORD2 * tmpvar_4.z)) + (xlv_TEXCOORD3 * tmpvar_4.w));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_ShadowMapTexture, tmpvar_6.xy);
  float tmpvar_8;
  if ((tmpvar_7.x < tmpvar_6.z)) {
    tmpvar_8 = _LightShadowData.x;
  } else {
    tmpvar_8 = 1.0;
  };
  res_1.x = clamp ((tmpvar_8 + tmpvar_5), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_9;
  vec2 tmpvar_10;
  tmpvar_10 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_9.y = tmpvar_10.y;
  enc_9.x = (tmpvar_10.x - (tmpvar_10.y * 0.00392157));
  res_1.zw = enc_9;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "SHADOWS_NONATIVE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 _LightShadowData;
uniform vec4 _LightSplitsFar;
uniform vec4 _LightSplitsNear;
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec2 tmpvar_2;
  vec3 normal_3;
  normal_3.xy = ((texture2D (_BumpMap, tmpvar_2).wy * 2.0) - 1.0);
  normal_3.z = sqrt((1.0 - clamp (dot (normal_3.xy, normal_3.xy), 0.0, 1.0)));
  vec4 tmpvar_4;
  tmpvar_4 = (vec4(greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear)) * vec4(lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar)));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = ((((xlv_TEXCOORD0 * tmpvar_4.x) + (xlv_TEXCOORD1 * tmpvar_4.y)) + (xlv_TEXCOORD2 * tmpvar_4.z)) + (xlv_TEXCOORD3 * tmpvar_4.w));
  res_1.x = clamp (((_LightShadowData.x + (shadow2D (_ShadowMapTexture, tmpvar_5.xyz).x * (1.0 - _LightShadowData.x))) + clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_6;
  vec2 tmpvar_7;
  tmpvar_7 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_6.y = tmpvar_7.y;
  enc_6.x = (tmpvar_7.x - (tmpvar_7.y * 0.00392157));
  res_1.zw = enc_6;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedegokfljmmknppnmegbdjpoibgmiipfieabaaaaaaaealaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcfaajaaaaeaaaabaafeacaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabiaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafjaaaaae
egiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaa
acaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagiaaaaacaeaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
aaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaah
ecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaa
agafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaaj
pcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaa
dcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaea
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaah
dcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaa
bkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaa
afaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaa
agbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaaj
hcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaa
aaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaa
aeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaia
ebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaa
egaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaaaaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaa
apaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
akaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaabaaaaaa
egiccaaaacaaaaaaalaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaa
apaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabaaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaabcaaaaaakgakbaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaabdaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaabfaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
beaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabgaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hccabaaaaeaaaaaaegiccaaaacaaaaaabhaaaaaapgapbaaaabaaaaaaegacbaaa
acaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaaeaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaackaabaaaaaaaaaaa
akaabaaaaaaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadgaaaaagiccabaaaafaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_LINEAR" "SHADOWS_NONATIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2D _ShadowMapTexture;
uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _LightShadowData;
uniform vec4 unity_ShadowSplitSqRadii;
uniform vec4 unity_ShadowSplitSpheres[4];
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec4 cascadeWeights_2;
  vec2 tmpvar_3;
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, tmpvar_3).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  vec4 tmpvar_9;
  tmpvar_9.x = dot (tmpvar_5, tmpvar_5);
  tmpvar_9.y = dot (tmpvar_6, tmpvar_6);
  tmpvar_9.z = dot (tmpvar_7, tmpvar_7);
  tmpvar_9.w = dot (tmpvar_8, tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = vec4(lessThan (tmpvar_9, unity_ShadowSplitSqRadii));
  cascadeWeights_2.x = tmpvar_10.x;
  cascadeWeights_2.yzw = clamp ((tmpvar_10.yzw - tmpvar_10.xyz), 0.0, 1.0);
  vec3 p_11;
  p_11 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  float tmpvar_12;
  tmpvar_12 = clamp (((sqrt(dot (p_11, p_11)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((((xlv_TEXCOORD0 * tmpvar_10.x) + (xlv_TEXCOORD1 * cascadeWeights_2.y)) + (xlv_TEXCOORD2 * cascadeWeights_2.z)) + (xlv_TEXCOORD3 * cascadeWeights_2.w));
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_13.z)) {
    tmpvar_15 = _LightShadowData.x;
  } else {
    tmpvar_15 = 1.0;
  };
  res_1.x = clamp ((tmpvar_15 + tmpvar_12), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_16;
  vec2 tmpvar_17;
  tmpvar_17 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_16.y = tmpvar_17.y;
  enc_16.x = (tmpvar_17.x - (tmpvar_17.y * 0.00392157));
  res_1.zw = enc_16;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_LINEAR" "SHADOWS_NONATIVE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform vec4 _Wind;
uniform float _SquashAmount;
uniform vec4 _SquashPlaneNormal;
uniform vec4 _Scale;
uniform mat4 _Object2World;


uniform mat4 unity_World2Shadow[4];
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.w = gl_Vertex.w;
  tmpvar_2.xyz = (gl_Vertex.xyz * _Scale.xyz);
  vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.0, 1.0, 1.0)) + gl_Color.x);
  vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((gl_Color.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.975, 0.793, 0.375, 0.193))) * 2.0) - 1.0) + 0.5)) * 2.0) - 1.0));
  vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.0 - (2.0 * tmpvar_8)));
  vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((gl_Color.y * 0.1) * gl_Normal).xz;
  bend_4.y = (gl_MultiTexCoord1.y * 0.3);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * gl_MultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (gl_MultiTexCoord1.x * _Wind.xyz));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  vec4 tmpvar_12;
  tmpvar_12 = (_Object2World * tmpvar_11);
  tmpvar_1.xyz = tmpvar_12.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * tmpvar_11).z);
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_12).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_12).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_12).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_12).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform sampler2DShadow _ShadowMapTexture;
uniform vec4 unity_ShadowFadeCenterAndType;
uniform vec4 _LightShadowData;
uniform vec4 unity_ShadowSplitSqRadii;
uniform vec4 unity_ShadowSplitSpheres[4];
uniform vec4 _ProjectionParams;
void main ()
{
  vec4 res_1;
  vec4 cascadeWeights_2;
  vec2 tmpvar_3;
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, tmpvar_3).wy * 2.0) - 1.0);
  normal_4.z = sqrt((1.0 - clamp (dot (normal_4.xy, normal_4.xy), 0.0, 1.0)));
  vec3 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  vec4 tmpvar_9;
  tmpvar_9.x = dot (tmpvar_5, tmpvar_5);
  tmpvar_9.y = dot (tmpvar_6, tmpvar_6);
  tmpvar_9.z = dot (tmpvar_7, tmpvar_7);
  tmpvar_9.w = dot (tmpvar_8, tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = vec4(lessThan (tmpvar_9, unity_ShadowSplitSqRadii));
  cascadeWeights_2.x = tmpvar_10.x;
  cascadeWeights_2.yzw = clamp ((tmpvar_10.yzw - tmpvar_10.xyz), 0.0, 1.0);
  vec3 p_11;
  p_11 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = ((((xlv_TEXCOORD0 * tmpvar_10.x) + (xlv_TEXCOORD1 * cascadeWeights_2.y)) + (xlv_TEXCOORD2 * cascadeWeights_2.z)) + (xlv_TEXCOORD3 * cascadeWeights_2.w));
  res_1.x = clamp (((_LightShadowData.x + (shadow2D (_ShadowMapTexture, tmpvar_12.xyz).x * (1.0 - _LightShadowData.x))) + clamp (((sqrt(dot (p_11, p_11)) * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0)), 0.0, 1.0);
  res_1.y = 1.0;
  vec2 enc_13;
  vec2 tmpvar_14;
  tmpvar_14 = fract((vec2(1.0, 255.0) * (1.0 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_13.y = tmpvar_14.y;
  enc_13.x = (tmpvar_14.x - (tmpvar_14.y * 0.00392157));
  res_1.zw = enc_13;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [unity_World2Shadow0]
Matrix 12 [unity_World2Shadow1]
Matrix 16 [unity_World2Shadow2]
Matrix 20 [unity_World2Shadow3]
Matrix 24 [_Object2World]
Vector 28 [_Time]
Vector 29 [_Scale]
Vector 30 [_SquashPlaneNormal]
Float 31 [_SquashAmount]
Vector 32 [_Wind]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 2.00000000, -0.50000000, -1.00000000
def c34, 1.97500002, 0.79299998, 0.37500000, 0.19300000
def c35, 2.00000000, 3.00000000, 0.30000001, 0.10000000
dcl_position0 v0
dcl_normal0 v2
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, c27
dp3 r0.x, c33.x, r0
add r0.x, v5, r0
mov r0.y, r0.x
mov r2.w, c33.x
mul r2.xyz, v0, c29
add r0.x, v5.y, r0
dp3 r0.x, r2, r0.x
add r0.xy, r0, c28.y
mul r0, r0.xxyy, c34
frc r0, r0
mad r0, r0, c33.y, c33.z
frc r0, r0
mad r0, r0, c33.y, c33.w
abs r0, r0
mad r1, -r0, c35.x, c35.y
mul r0, r0, r0
mul r0, r0, r1
add r3.xy, r0.xzzw, r0.ywzw
mul r0.xyz, r3.y, c32
mul r1.xyz, v4.y, r0
mul r0.w, v5.y, c35
mul r0.xz, r0.w, v2
mul r0.y, v4, c35.z
mad r0.xyz, r3.xyxw, r0, r1
mad r0.xyz, r0, c32.w, r2
mad r1.xyz, v4.x, c32, r0
dp3 r0.x, r1, c30
add r0.x, r0, c30.w
mul r0.xyz, r0.x, c30
add r1.xyz, -r0, r1
mad r2.xyz, r0, c31.x, r1
dp4 r0.w, r2, c2
dp4 r1.w, r2, c27
dp4 r0.z, r2, c26
dp4 r0.x, r2, c24
dp4 r0.y, r2, c25
mov r1.xyz, r0
mov r0.w, -r0
dp4 o1.z, r1, c10
dp4 o1.y, r1, c9
dp4 o1.x, r1, c8
dp4 o2.z, r1, c14
dp4 o2.y, r1, c13
dp4 o2.x, r1, c12
dp4 o3.z, r1, c18
dp4 o3.y, r1, c17
dp4 o3.x, r1, c16
dp4 o4.z, r1, c22
dp4 o4.y, r1, c21
dp4 o4.x, r1, c20
mov o5, r0
dp4 o0.w, r2, c7
dp4 o0.z, r2, c6
dp4 o0.y, r2, c5
dp4 o0.x, r2, c4
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 208
Vector 48 [_Wind]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 64 [glstate_matrix_modelview0]
Matrix 192 [_Object2World]
ConstBuffer "UnityTerrain" 256
Vector 80 [_Scale]
Vector 160 [_SquashPlaneNormal]
Float 176 [_SquashAmount]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityTerrain" 4
"vs_4_0
eefiecedegokfljmmknppnmegbdjpoibgmiipfieabaaaaaaaealaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapahaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahafaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapadaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcfaajaaaaeaaaabaafeacaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabiaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafjaaaaae
egiocaaaaeaaaaaaamaaaaaafpaaaaadhcbabaaaaaaaaaaafpaaaaadfcbabaaa
acaaaaaafpaaaaaddcbabaaaaeaaaaaafpaaaaaddcbabaaaafaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagiaaaaacaeaaaaaadgaaaaagbcaabaaaaaaaaaaadkiacaaa
adaaaaaaamaaaaaadgaaaaagccaabaaaaaaaaaaadkiacaaaadaaaaaaanaaaaaa
dgaaaaagecaabaaaaaaaaaaadkiacaaaadaaaaaaaoaaaaaabaaaaaakbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
aaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakbabaaaafaaaaaaaaaaaaah
ecaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaafaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaaaaaaaaaegiccaaaaeaaaaaaafaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaabaaaaaakgakbaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaa
agafbaaaaaaaaaaafgifcaaaabaaaaaaaaaaaaaadiaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaamnmmpmdpamaceldpaaaamadomlkbefdobkaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaaalp
aaaaaalpaaaaaalpaaaaaalpbkaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaialpdiaaaaaj
pcaabaaaacaaaaaaegaobaiaibaaaaaaaaaaaaaaegaobaiaibaaaaaaaaaaaaaa
dcaaaabapcaabaaaaaaaaaaaegaobaiambaaaaaaaaaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaaaaaeaeaaaaaeaeaaaaaeaeaaaaaeaea
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaah
dcaabaaaaaaaaaaangafbaaaaaaaaaaaigaabaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaafgbfbaaaaeaaaaaadiaaaaahccaabaaaadaaaaaa
bkaabaaaaaaaaaaabkbabaaaaeaaaaaadiaaaaahccaabaaaaaaaaaaabkbabaaa
afaaaaaaabeaaaaamnmmmmdndiaaaaahfcaabaaaadaaaaaafgafbaaaaaaaaaaa
agbcbaaaacaaaaaadgaaaaafecaabaaaaaaaaaaaabeaaaaajkjjjjdodcaaaaaj
hcaabaaaaaaaaaaaigaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaagbabaaaaeaaaaaaegiccaaa
aaaaaaaaadaaaaaaegacbaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegiccaaa
aeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaadkiacaaaaeaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaapgapbaia
ebaaaaaaaaaaaaaaegiccaaaaeaaaaaaakaaaaaaegacbaaaaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaagiacaaaaeaaaaaaalaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaadaaaaaa
acaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaaaaaaaaaipccabaaaaaaaaaaa
egaobaaaabaaaaaaegiocaaaadaaaaaaadaaaaaadiaaaaaipcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegaobaaa
abaaaaaaaaaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaadaaaaaa
apaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
akaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaabaaaaaa
egiccaaaacaaaaaaalaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaa
apaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabaaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaabcaaaaaakgakbaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaabdaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaabfaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
beaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaabgaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hccabaaaaeaaaaaaegiccaaaacaaaaaabhaaaaaapgapbaaaabaaaaaaegacbaaa
acaaaaaadgaaaaafhccabaaaafaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaaeaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaackaabaaaaaaaaaaa
akaabaaaaaaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadgaaaaagiccabaaaafaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "SHADOWS_NONATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "SHADOWS_NONATIVE" }
Vector 4 [_ProjectionParams]
Vector 5 [_LightSplitsNear]
Vector 6 [_LightSplitsFar]
Vector 7 [_LightShadowData]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 22 ALU, 1 TEX
dcl_2d s3
def c8, 1.00000000, 0.00000000, 255.00000000, 0.00392157
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyzw
add r1, v4.w, -c6
add r0, v4.w, -c5
cmp r1, r1, c8.y, c8.x
cmp r0, r0, c8.x, c8.y
mul r0, r0, r1
mul r1.xyz, r0.y, v1
mad r1.xyz, r0.x, v0, r1
mad r0.xyz, r0.z, v2, r1
mad r0.xyz, v3, r0.w, r0
texld r0.x, r0, s3
add r0.y, r0.x, -r0.z
mov r0.z, c7.x
mul r0.x, -v4.w, c4.w
cmp r1.x, r0.y, c8, r0.z
add r0.x, r0, c8
mul r0.xy, r0.x, c8.xzzw
frc r0.zw, r0.xyxy
mad_sat r1.y, v4.w, c7.z, c7.w
mov r0.y, r0.w
mad r0.x, -r0.w, c8.w, r0.z
add_sat oC0.x, r1, r1.y
mov oC0.zw, r0.xyxy
mov oC0.y, c8.x
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_NATIVE" "MARMO_GAMMA" }
Vector 4 [_ProjectionParams]
Vector 5 [_LightSplitsNear]
Vector 6 [_LightSplitsFar]
Vector 7 [_LightShadowData]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 22 ALU, 1 TEX
dcl_2d s3
def c8, 0.00000000, 1.00000000, 255.00000000, 0.00392157
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyzw
add r1, v4.w, -c6
add r0, v4.w, -c5
cmp r1, r1, c8.x, c8.y
cmp r0, r0, c8.y, c8.x
mul r0, r0, r1
mul r1.xyz, r0.y, v1
mad r1.xyz, r0.x, v0, r1
mad r0.xyz, r0.z, v2, r1
mad r0.xyz, v3, r0.w, r0
texld r0.x, r0, s3
mov r0.z, c7.x
add r0.z, c8.y, -r0
mul r0.y, -v4.w, c4.w
mad r1.x, r0, r0.z, c7
add r0.y, r0, c8
mul r0.xy, r0.y, c8.yzzw
frc r0.zw, r0.xyxy
mad_sat r1.y, v4.w, c7.z, c7.w
mov r0.y, r0.w
mad r0.x, -r0.w, c8.w, r0.z
add_sat oC0.x, r1, r1.y
mov oC0.zw, r0.xyxy
mov oC0.y, c8
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_NATIVE" "MARMO_GAMMA" }
SetTexture 0 [_ShadowMapTexture] 2D 0
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 96 [_LightSplitsNear]
Vector 112 [_LightSplitsFar]
Vector 384 [_LightShadowData]
BindCB  "UnityPerCamera" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedfoicichoepiaaopfmpilgmkjgoeglgdgabaaaaaageaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceeadaaaa
eaaaaaaanbaaaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaabjaaaaaafkaiaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadicbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabnaaaaaipcaabaaaaaaaaaaa
pgbpbaaaafaaaaaaegiocaaaabaaaaaaagaaaaaaabaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdbaaaaai
pcaabaaaabaaaaaapgbpbaaaafaaaaaaegiocaaaabaaaaaaahaaaaaaabaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaaj
hcaabaaaabaaaaaaegbcbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegbcbaaaadaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaaegbcbaaaaeaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaehaaaaalbcaabaaaaaaaaaaaegaabaaaaaaaaaaaaghabaaa
aaaaaaaaaagabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaa
akiacaiaebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadpdcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaabiaaaaaa
dccaaaalccaabaaaaaaaaaaadkbabaaaafaaaaaackiacaaaabaaaaaabiaaaaaa
dkiacaaaabaaaaaabiaaaaaaaacaaaahbccabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaadkbabaiaebaaaaaaafaaaaaa
dkiacaaaaaaaaaaaafaaaaaaabeaaaaaaaaaiadpdiaaaaakdcaabaaaaaaaaaaa
agaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaahpedaaaaaaaaaaaaaaaabkaaaaaf
dcaabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakeccabaaaaaaaaaaabkaabaia
ebaaaaaaaaaaaaaaabeaaaaaibiaiadlakaabaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaabkaabaaaaaaaaaaadgaaaaafcccabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_GAMMA" "SHADOWS_NONATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_GAMMA" "SHADOWS_NONATIVE" }
Vector 4 [_ProjectionParams]
Vector 5 [unity_ShadowSplitSpheres0]
Vector 6 [unity_ShadowSplitSpheres1]
Vector 7 [unity_ShadowSplitSpheres2]
Vector 8 [unity_ShadowSplitSpheres3]
Vector 9 [unity_ShadowSplitSqRadii]
Vector 10 [_LightShadowData]
Vector 11 [unity_ShadowFadeCenterAndType]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 32 ALU, 1 TEX
dcl_2d s3
def c12, 1.00000000, 255.00000000, 0.00392157, 0.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
add r0.xyz, v4, -c5
add r2.xyz, v4, -c8
dp3 r0.x, r0, r0
add r1.xyz, v4, -c6
dp3 r0.y, r1, r1
add r1.xyz, v4, -c7
dp3 r0.w, r2, r2
dp3 r0.z, r1, r1
add r0, r0, -c9
cmp r2, r0, c12.w, c12.x
add_sat r0.xyz, r2.yzww, -r2
mul r1.xyz, r0.x, v1
mad r1.xyz, r2.x, v0, r1
mad r1.xyz, r0.y, v2, r1
mad r0.xyz, v3, r0.z, r1
texld r0.x, r0, s3
add r0.x, r0, -r0.z
mov r0.y, c10.x
cmp r0.x, r0, c12, r0.y
add r1.xyz, -v4, c11
dp3 r0.z, r1, r1
rsq r0.z, r0.z
mul r0.y, -v4.w, c4.w
add r0.y, r0, c12.x
rcp r1.x, r0.z
mul r0.zw, r0.y, c12.xyxy
mad_sat r0.y, r1.x, c10.z, c10.w
frc r0.zw, r0
add_sat oC0.x, r0, r0.y
mov r0.y, r0.w
mad r0.x, -r0.w, c12.z, r0.z
mov oC0.zw, r0.xyxy
mov oC0.y, c12.x
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_GAMMA" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_GAMMA" }
Vector 4 [_ProjectionParams]
Vector 5 [unity_ShadowSplitSpheres0]
Vector 6 [unity_ShadowSplitSpheres1]
Vector 7 [unity_ShadowSplitSpheres2]
Vector 8 [unity_ShadowSplitSpheres3]
Vector 9 [unity_ShadowSplitSqRadii]
Vector 10 [_LightShadowData]
Vector 11 [unity_ShadowFadeCenterAndType]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 32 ALU, 1 TEX
dcl_2d s3
def c12, 0.00000000, 1.00000000, 255.00000000, 0.00392157
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
add r0.xyz, v4, -c5
add r2.xyz, v4, -c8
dp3 r0.x, r0, r0
add r1.xyz, v4, -c6
dp3 r0.y, r1, r1
add r1.xyz, v4, -c7
dp3 r0.w, r2, r2
dp3 r0.z, r1, r1
add r0, r0, -c9
cmp r2, r0, c12.x, c12.y
add_sat r0.xyz, r2.yzww, -r2
mul r1.xyz, r0.x, v1
mad r1.xyz, r2.x, v0, r1
mad r1.xyz, r0.y, v2, r1
mad r0.xyz, v3, r0.z, r1
texld r0.x, r0, s3
mov r0.w, c10.x
add r0.y, c12, -r0.w
mad r0.x, r0, r0.y, c10
add r1.xyz, -v4, c11
dp3 r0.z, r1, r1
rsq r0.z, r0.z
mul r0.y, -v4.w, c4.w
add r0.y, r0, c12
rcp r1.x, r0.z
mul r0.zw, r0.y, c12.xyyz
mad_sat r0.y, r1.x, c10.z, c10.w
frc r0.zw, r0
add_sat oC0.x, r0, r0.y
mov r0.y, r0.w
mad r0.x, -r0.w, c12.w, r0.z
mov oC0.zw, r0.xyxy
mov oC0.y, c12
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_GAMMA" }
SetTexture 0 [_ShadowMapTexture] 2D 0
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 0 [unity_ShadowSplitSpheres0]
Vector 16 [unity_ShadowSplitSpheres1]
Vector 32 [unity_ShadowSplitSpheres2]
Vector 48 [unity_ShadowSplitSpheres3]
Vector 64 [unity_ShadowSplitSqRadii]
Vector 384 [_LightShadowData]
Vector 400 [unity_ShadowFadeCenterAndType]
BindCB  "UnityPerCamera" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedehfdffddekigboeafomdgidfgeolncnbabaaaaaaneafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcleaeaaaa
eaaaaaaacnabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaabkaaaaaafkaiaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaaaaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaabaaaaaabaaaaaahccaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaacaaaaaabaaaaaahecaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaadaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaadbaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaabaaaaaaaeaaaaaadhaaaaaphcaabaaaabaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaaaceaaaaa
aaaaaaiaaaaaaaiaaaaaaaiaaaaaaaaaabaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaaaaaaahocaabaaa
aaaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaadeaaaaakocaabaaaaaaaaaaa
fgaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaajhcaabaaa
abaaaaaaegbcbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegbcbaaaadaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegbcbaaaaeaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaehaaaaalbcaabaaaaaaaaaaaegaabaaaaaaaaaaaaghabaaaaaaaaaaa
aagabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaaakiacaia
ebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadpdcaaaaakbcaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaabiaaaaaaaaaaaaaj
ocaabaaaaaaaaaaaagbjbaaaafaaaaaaagijcaiaebaaaaaaabaaaaaabjaaaaaa
baaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadccaaaalccaabaaaaaaaaaaabkaabaaa
aaaaaaaackiacaaaabaaaaaabiaaaaaadkiacaaaabaaaaaabiaaaaaaaacaaaah
bccabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalbcaabaaa
aaaaaaaadkbabaiaebaaaaaaafaaaaaadkiacaaaaaaaaaaaafaaaaaaabeaaaaa
aaaaiadpdiaaaaakdcaabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaahpedaaaaaaaaaaaaaaaabkaaaaafdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakeccabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabeaaaaaibiaiadl
akaabaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaabkaabaaaaaaaaaaadgaaaaaf
cccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "SHADOWS_NONATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "SHADOWS_NONATIVE" }
Vector 4 [_ProjectionParams]
Vector 5 [_LightSplitsNear]
Vector 6 [_LightSplitsFar]
Vector 7 [_LightShadowData]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 22 ALU, 1 TEX
dcl_2d s3
def c8, 1.00000000, 0.00000000, 255.00000000, 0.00392157
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyzw
add r1, v4.w, -c6
add r0, v4.w, -c5
cmp r1, r1, c8.y, c8.x
cmp r0, r0, c8.x, c8.y
mul r0, r0, r1
mul r1.xyz, r0.y, v1
mad r1.xyz, r0.x, v0, r1
mad r0.xyz, r0.z, v2, r1
mad r0.xyz, v3, r0.w, r0
texld r0.x, r0, s3
add r0.y, r0.x, -r0.z
mov r0.z, c7.x
mul r0.x, -v4.w, c4.w
cmp r1.x, r0.y, c8, r0.z
add r0.x, r0, c8
mul r0.xy, r0.x, c8.xzzw
frc r0.zw, r0.xyxy
mad_sat r1.y, v4.w, c7.z, c7.w
mov r0.y, r0.w
mad r0.x, -r0.w, c8.w, r0.z
add_sat oC0.x, r1, r1.y
mov oC0.zw, r0.xyxy
mov oC0.y, c8.x
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_NATIVE" "MARMO_LINEAR" }
Vector 4 [_ProjectionParams]
Vector 5 [_LightSplitsNear]
Vector 6 [_LightSplitsFar]
Vector 7 [_LightShadowData]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 22 ALU, 1 TEX
dcl_2d s3
def c8, 0.00000000, 1.00000000, 255.00000000, 0.00392157
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyzw
add r1, v4.w, -c6
add r0, v4.w, -c5
cmp r1, r1, c8.x, c8.y
cmp r0, r0, c8.y, c8.x
mul r0, r0, r1
mul r1.xyz, r0.y, v1
mad r1.xyz, r0.x, v0, r1
mad r0.xyz, r0.z, v2, r1
mad r0.xyz, v3, r0.w, r0
texld r0.x, r0, s3
mov r0.z, c7.x
add r0.z, c8.y, -r0
mul r0.y, -v4.w, c4.w
mad r1.x, r0, r0.z, c7
add r0.y, r0, c8
mul r0.xy, r0.y, c8.yzzw
frc r0.zw, r0.xyxy
mad_sat r1.y, v4.w, c7.z, c7.w
mov r0.y, r0.w
mad r0.x, -r0.w, c8.w, r0.z
add_sat oC0.x, r1, r1.y
mov oC0.zw, r0.xyxy
mov oC0.y, c8
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_NATIVE" "MARMO_LINEAR" }
SetTexture 0 [_ShadowMapTexture] 2D 0
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 96 [_LightSplitsNear]
Vector 112 [_LightSplitsFar]
Vector 384 [_LightShadowData]
BindCB  "UnityPerCamera" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedfoicichoepiaaopfmpilgmkjgoeglgdgabaaaaaageaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceeadaaaa
eaaaaaaanbaaaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaabjaaaaaafkaiaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadicbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabnaaaaaipcaabaaaaaaaaaaa
pgbpbaaaafaaaaaaegiocaaaabaaaaaaagaaaaaaabaaaaakpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdbaaaaai
pcaabaaaabaaaaaapgbpbaaaafaaaaaaegiocaaaabaaaaaaahaaaaaaabaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaaj
hcaabaaaabaaaaaaegbcbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegbcbaaaadaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaaegbcbaaaaeaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaehaaaaalbcaabaaaaaaaaaaaegaabaaaaaaaaaaaaghabaaa
aaaaaaaaaagabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaa
akiacaiaebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadpdcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaabiaaaaaa
dccaaaalccaabaaaaaaaaaaadkbabaaaafaaaaaackiacaaaabaaaaaabiaaaaaa
dkiacaaaabaaaaaabiaaaaaaaacaaaahbccabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaadkbabaiaebaaaaaaafaaaaaa
dkiacaaaaaaaaaaaafaaaaaaabeaaaaaaaaaiadpdiaaaaakdcaabaaaaaaaaaaa
agaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaahpedaaaaaaaaaaaaaaaabkaaaaaf
dcaabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakeccabaaaaaaaaaaabkaabaia
ebaaaaaaaaaaaaaaabeaaaaaibiaiadlakaabaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaabkaabaaaaaaaaaaadgaaaaafcccabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_LINEAR" "SHADOWS_NONATIVE" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "MARMO_LINEAR" "SHADOWS_NONATIVE" }
Vector 4 [_ProjectionParams]
Vector 5 [unity_ShadowSplitSpheres0]
Vector 6 [unity_ShadowSplitSpheres1]
Vector 7 [unity_ShadowSplitSpheres2]
Vector 8 [unity_ShadowSplitSpheres3]
Vector 9 [unity_ShadowSplitSqRadii]
Vector 10 [_LightShadowData]
Vector 11 [unity_ShadowFadeCenterAndType]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 32 ALU, 1 TEX
dcl_2d s3
def c12, 1.00000000, 255.00000000, 0.00392157, 0.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
add r0.xyz, v4, -c5
add r2.xyz, v4, -c8
dp3 r0.x, r0, r0
add r1.xyz, v4, -c6
dp3 r0.y, r1, r1
add r1.xyz, v4, -c7
dp3 r0.w, r2, r2
dp3 r0.z, r1, r1
add r0, r0, -c9
cmp r2, r0, c12.w, c12.x
add_sat r0.xyz, r2.yzww, -r2
mul r1.xyz, r0.x, v1
mad r1.xyz, r2.x, v0, r1
mad r1.xyz, r0.y, v2, r1
mad r0.xyz, v3, r0.z, r1
texld r0.x, r0, s3
add r0.x, r0, -r0.z
mov r0.y, c10.x
cmp r0.x, r0, c12, r0.y
add r1.xyz, -v4, c11
dp3 r0.z, r1, r1
rsq r0.z, r0.z
mul r0.y, -v4.w, c4.w
add r0.y, r0, c12.x
rcp r1.x, r0.z
mul r0.zw, r0.y, c12.xyxy
mad_sat r0.y, r1.x, c10.z, c10.w
frc r0.zw, r0
add_sat oC0.x, r0, r0.y
mov r0.y, r0.w
mad r0.x, -r0.w, c12.z, r0.z
mov oC0.zw, r0.xyxy
mov oC0.y, c12.x
"
}
SubProgram "opengl " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_LINEAR" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_LINEAR" }
Vector 4 [_ProjectionParams]
Vector 5 [unity_ShadowSplitSpheres0]
Vector 6 [unity_ShadowSplitSpheres1]
Vector 7 [unity_ShadowSplitSpheres2]
Vector 8 [unity_ShadowSplitSpheres3]
Vector 9 [unity_ShadowSplitSqRadii]
Vector 10 [_LightShadowData]
Vector 11 [unity_ShadowFadeCenterAndType]
SetTexture 3 [_ShadowMapTexture] 2D 3
"ps_3_0
; 32 ALU, 1 TEX
dcl_2d s3
def c12, 0.00000000, 1.00000000, 255.00000000, 0.00392157
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
add r0.xyz, v4, -c5
add r2.xyz, v4, -c8
dp3 r0.x, r0, r0
add r1.xyz, v4, -c6
dp3 r0.y, r1, r1
add r1.xyz, v4, -c7
dp3 r0.w, r2, r2
dp3 r0.z, r1, r1
add r0, r0, -c9
cmp r2, r0, c12.x, c12.y
add_sat r0.xyz, r2.yzww, -r2
mul r1.xyz, r0.x, v1
mad r1.xyz, r2.x, v0, r1
mad r1.xyz, r0.y, v2, r1
mad r0.xyz, v3, r0.z, r1
texld r0.x, r0, s3
mov r0.w, c10.x
add r0.y, c12, -r0.w
mad r0.x, r0, r0.y, c10
add r1.xyz, -v4, c11
dp3 r0.z, r1, r1
rsq r0.z, r0.z
mul r0.y, -v4.w, c4.w
add r0.y, r0, c12
rcp r1.x, r0.z
mul r0.zw, r0.y, c12.xyyz
mad_sat r0.y, r1.x, c10.z, c10.w
frc r0.zw, r0
add_sat oC0.x, r0, r0.y
mov r0.y, r0.w
mad r0.x, -r0.w, c12.w, r0.z
mov oC0.zw, r0.xyxy
mov oC0.y, c12
"
}
SubProgram "d3d11 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "MARMO_LINEAR" }
SetTexture 0 [_ShadowMapTexture] 2D 0
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityShadows" 416
Vector 0 [unity_ShadowSplitSpheres0]
Vector 16 [unity_ShadowSplitSpheres1]
Vector 32 [unity_ShadowSplitSpheres2]
Vector 48 [unity_ShadowSplitSpheres3]
Vector 64 [unity_ShadowSplitSqRadii]
Vector 384 [_LightShadowData]
Vector 400 [unity_ShadowFadeCenterAndType]
BindCB  "UnityPerCamera" 0
BindCB  "UnityShadows" 1
"ps_4_0
eefiecedehfdffddekigboeafomdgidfgeolncnbabaaaaaaneafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcleaeaaaa
eaaaaaaacnabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaa
abaaaaaabkaaaaaafkaiaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaaaaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaabaaaaaabaaaaaahccaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaacaaaaaabaaaaaahecaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaa
egbcbaaaafaaaaaaegiccaiaebaaaaaaabaaaaaaadaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaadbaaaaaipcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegiocaaaabaaaaaaaeaaaaaadhaaaaaphcaabaaaabaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaaaceaaaaa
aaaaaaiaaaaaaaiaaaaaaaiaaaaaaaaaabaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaaaaaaahocaabaaa
aaaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaadeaaaaakocaabaaaaaaaaaaa
fgaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaajhcaabaaa
abaaaaaaegbcbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegbcbaaaadaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegbcbaaaaeaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaehaaaaalbcaabaaaaaaaaaaaegaabaaaaaaaaaaaaghabaaaaaaaaaaa
aagabaaaaaaaaaaackaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaaakiacaia
ebaaaaaaabaaaaaabiaaaaaaabeaaaaaaaaaiadpdcaaaaakbcaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaabiaaaaaaaaaaaaaj
ocaabaaaaaaaaaaaagbjbaaaafaaaaaaagijcaiaebaaaaaaabaaaaaabjaaaaaa
baaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadccaaaalccaabaaaaaaaaaaabkaabaaa
aaaaaaaackiacaaaabaaaaaabiaaaaaadkiacaaaabaaaaaabiaaaaaaaacaaaah
bccabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalbcaabaaa
aaaaaaaadkbabaiaebaaaaaaafaaaaaadkiacaaaaaaaaaaaafaaaaaaabeaaaaa
aaaaiadpdiaaaaakdcaabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaahpedaaaaaaaaaaaaaaaabkaaaaafdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakeccabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabeaaaaaibiaiadl
akaabaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaabkaabaaaaaaaaaaadgaaaaaf
cccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
}
 }
}
Fallback "Hidden/Marmoset/RGBM Grass"
}