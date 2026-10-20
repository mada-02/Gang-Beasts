Shader "FX/SimpleWater4" {
Properties {
 _ReflectionTex ("Internal reflection", 2D) = "white" {}
 _MainTex ("Fallback texture", 2D) = "black" {}
 _BumpMap ("Normals ", 2D) = "bump" {}
 _DistortParams ("Distortions (Bump waves, Reflection, Fresnel power, Fresnel bias)", Vector) = (1,1,2,1.15)
 _InvFadeParemeter ("Auto blend parameter (Edge, Shore, Distance scale)", Vector) = (0.15,0.15,0.5,1)
 _AnimationTiling ("Animation Tiling (Displacement)", Vector) = (2.2,2.2,-1.1,-1.1)
 _AnimationDirection ("Animation Direction (displacement)", Vector) = (1,1,1,1)
 _BumpTiling ("Bump Tiling", Vector) = (1,1,-2,3)
 _BumpDirection ("Bump Direction & Speed", Vector) = (1,1,-1,1)
 _FresnelScale ("FresnelScale", Range(0.15,4)) = 0.75
 _BaseColor ("Base color", Color) = (0.54,0.95,0.99,0.5)
 _ReflectionColor ("Reflection color", Color) = (0.54,0.95,0.99,0.5)
 _SpecularColor ("Specular color", Color) = (0.72,0.72,0.72,1)
 _WorldLightDir ("Specular light direction", Vector) = (0,0.1,-0.5,0)
 _Shininess ("Shininess", Range(2,500)) = 200
 _GerstnerIntensity ("Per vertex displacement", Float) = 1
 _GAmplitude ("Wave Amplitude", Vector) = (0.3,0.35,0.25,0.25)
 _GFrequency ("Wave Frequency", Vector) = (1.3,1.35,1.25,1.25)
 _GSteepness ("Wave Steepness", Vector) = (1,1,1,1)
 _GSpeed ("Wave Speed", Vector) = (1.2,1.375,1.1,1.5)
 _GDirectionAB ("Wave Direction", Vector) = (0.3,0.85,0.85,0.25)
 _GDirectionCD ("Wave Direction", Vector) = (0.1,0.9,0.5,0.5)
}
SubShader { 
 LOD 500
 Tags { "QUEUE"="Transparent" "RenderType"="Transparent" }
 GrabPass {
  "_RefractionTex"
 }
 Pass {
  Tags { "QUEUE"="Transparent" "RenderType"="Transparent" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha OneMinusSrcAlpha
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_8));
  float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_12 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), mix (tmpvar_11, _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  float tmpvar_11;
  tmpvar_11 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_8));
  float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_12 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), mix (tmpvar_11, _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  float tmpvar_11;
  tmpvar_11 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
SetTexture 3 [_ReflectionTex] 2D 3
"ps_3_0
; 53 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r3.xy, r0, c9.w
mov_pp r3.zw, c9.y
add r2, r3, v4
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r0.xyz, v4, s1
texldp r2.xyz, r2, s1
cmp_pp r2.xyz, r0.w, r2, r0
add r0, v3, r3
texldp r0.xyz, r0, s3
add_pp r3.xyz, -r2, c2
mad_pp r4.xyz, r3, c2.w, r2
add_pp r2.xyz, -r0, c3
mad_pp r0.xyz, r2, c3.w, r0
add_pp r5.xyz, r0, -r4
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mad_pp_sat r0.x, r0, r0.w, c7.w
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
mov r0.y, r1.x
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_CameraDepthTexture] 2D 3
SetTexture 3 [_ReflectionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefieceddcnmijckmocpocjlfdgompehodohkfjkabaaaaaajmajaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchmaiaaaa
eaaaaaaabpacaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacagaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaafaaaaaapgbpbaaa
afaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaapganbaaa
abaaaaaapganbaaaacaaaaaaaaaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaabaaaaaa
egacbaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaidcaabaaaacaaaaaaigaabaaa
abaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaacaaaaaaegaabaaa
acaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
acaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaa
egbdbaaaafaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbdbaaa
aeaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaakgakbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaaaoaaaaahdcaabaaaadaaaaaaegaabaaaadaaaaaakgakbaaaadaaaaaa
efaaaaajpcaabaaaaeaaaaaaegaabaaaadaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaalicaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaa
akaabaaaaeaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaaaaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaackbabaaaaeaaaaaadhaaaaajhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaaj
hcaabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaaaaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaadaaaaaaegacbaiaebaaaaaaacaaaaaa
egiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaaaaaaaaaa
afaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaiaebaaaaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaifcaabaaaadaaaaaa
agacbaaaabaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaadaaaaaa
bkaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaafaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaadaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
icaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaafaaaaaa
egacbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaafaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
aaaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
"ps_3_0
; 50 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r0.xy, r0, c9.w
mov_pp r0.zw, c9.y
add r2, v4, r0
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r2.xyz, r2, s1
texldp r0.xyz, v4, s1
cmp_pp r0.xyz, r0.w, r2, r0
add_pp r2.xyz, -r0, c2
mad_pp r4.xyz, r2, c2.w, r0
dp3 r0.w, v1, v1
rsq r0.x, r0.w
mul r2.xyz, r0.x, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mov r0.y, r1.x
mad_pp_sat r0.x, r0, r0.w, c7.w
add_pp r5.xyz, -r4, c3
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedencfdgmknbcifcffhonebpbfjnofajimabaaaaaanmaiaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefclmahaaaa
eaaaaaaaopabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaa
aaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaa
aaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaa
aaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaafaaaaaa
aoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadcaaaaalicaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
acaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadbaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaackbabaaaaeaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadhaaaaajhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
acaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaa
aaaaaaaaafaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_ReflectionTex] 2D 2
"ps_3_0
; 44 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r1.w, v1, v1
mov_pp r0.zw, c7.y
mul r0.xy, r0, c7.w
add r2, v3, r0
texldp r2.xyz, r2, s2
add r0, r0, v4
add_pp r3.xyz, -r2, c2
texldp r0.xyz, r0, s1
add_pp r5.xyz, -r0, c1
mad_pp r4.xyz, r3, c2.w, r2
mad_pp r0.xyz, r5, c1.w, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, r4, -r0
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_ReflectionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkaacckpopllppchjpbnhhohbjfkacjggabaaaaaaliahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjiagaaaa
eaaaaaaakgabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaad
lcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaa
kgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaa
kgakbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaaeaaaaaaegacbaiaebaaaaaa
acaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaa
aaaaaaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaa
aeaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegacbaaa
acaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
"ps_3_0
; 41 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord4 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.w, r0.z
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
mul r0.xy, r0, c7.w
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r4.xyz, -r0, c1
mad_pp r0.xyz, r4, c1.w, r0
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, -r0, c2
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedalccaahodpbofjbkbhnmlgbgimhabdoaabaaaaaaomagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmafaaaa
eaaaaaaahdabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaa
aaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaa
egacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaajhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaa
egacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaaaaaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
SetTexture 3 [_ReflectionTex] 2D 3
"ps_3_0
; 53 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r3.xy, r0, c9.w
mov_pp r3.zw, c9.y
add r2, r3, v4
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r0.xyz, v4, s1
texldp r2.xyz, r2, s1
cmp_pp r2.xyz, r0.w, r2, r0
add r0, v3, r3
texldp r0.xyz, r0, s3
add_pp r3.xyz, -r2, c2
mad_pp r4.xyz, r3, c2.w, r2
add_pp r2.xyz, -r0, c3
mad_pp r0.xyz, r2, c3.w, r0
add_pp r5.xyz, r0, -r4
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mad_pp_sat r0.x, r0, r0.w, c7.w
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
mov r0.y, r1.x
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_CameraDepthTexture] 2D 3
SetTexture 3 [_ReflectionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefieceddcnmijckmocpocjlfdgompehodohkfjkabaaaaaajmajaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchmaiaaaa
eaaaaaaabpacaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacagaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaafaaaaaapgbpbaaa
afaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaapganbaaa
abaaaaaapganbaaaacaaaaaaaaaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaabaaaaaa
egacbaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaidcaabaaaacaaaaaaigaabaaa
abaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaacaaaaaaegaabaaa
acaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
acaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaa
egbdbaaaafaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbdbaaa
aeaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaakgakbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaaaoaaaaahdcaabaaaadaaaaaaegaabaaaadaaaaaakgakbaaaadaaaaaa
efaaaaajpcaabaaaaeaaaaaaegaabaaaadaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaalicaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaa
akaabaaaaeaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaaaaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaackbabaaaaeaaaaaadhaaaaajhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaaj
hcaabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaaaaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaadaaaaaaegacbaiaebaaaaaaacaaaaaa
egiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaaaaaaaaaa
afaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaiaebaaaaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaifcaabaaaadaaaaaa
agacbaaaabaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaadaaaaaa
bkaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaafaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaadaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
icaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaafaaaaaa
egacbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaafaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
aaaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
"ps_3_0
; 50 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r0.xy, r0, c9.w
mov_pp r0.zw, c9.y
add r2, v4, r0
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r2.xyz, r2, s1
texldp r0.xyz, v4, s1
cmp_pp r0.xyz, r0.w, r2, r0
add_pp r2.xyz, -r0, c2
mad_pp r4.xyz, r2, c2.w, r0
dp3 r0.w, v1, v1
rsq r0.x, r0.w
mul r2.xyz, r0.x, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mov r0.y, r1.x
mad_pp_sat r0.x, r0, r0.w, c7.w
add_pp r5.xyz, -r4, c3
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedencfdgmknbcifcffhonebpbfjnofajimabaaaaaanmaiaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefclmahaaaa
eaaaaaaaopabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaa
aaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaa
aaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaa
aaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaafaaaaaa
aoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadcaaaaalicaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
acaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadbaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaackbabaaaaeaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadhaaaaajhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
acaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaa
aaaaaaaaafaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_ReflectionTex] 2D 2
"ps_3_0
; 44 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r1.w, v1, v1
mov_pp r0.zw, c7.y
mul r0.xy, r0, c7.w
add r2, v3, r0
texldp r2.xyz, r2, s2
add r0, r0, v4
add_pp r3.xyz, -r2, c2
texldp r0.xyz, r0, s1
add_pp r5.xyz, -r0, c1
mad_pp r4.xyz, r3, c2.w, r2
mad_pp r0.xyz, r5, c1.w, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, r4, -r0
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_ReflectionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkaacckpopllppchjpbnhhohbjfkacjggabaaaaaaliahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjiagaaaa
eaaaaaaakgabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaad
lcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaa
kgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaa
kgakbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaaeaaaaaaegacbaiaebaaaaaa
acaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaa
aaaaaaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaa
aeaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegacbaaa
acaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
"ps_3_0
; 41 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord4 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.w, r0.z
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
mul r0.xy, r0, c7.w
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r4.xyz, -r0, c1
mad_pp r0.xyz, r4, c1.w, r0
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, -r0, c2
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedalccaahodpbofjbkbhnmlgbgimhabdoaabaaaaaaomagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmafaaaa
eaaaaaaahdabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaa
aaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaa
egacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaajhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaa
egacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaaaaaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
}
 }
}
SubShader { 
 LOD 300
 Tags { "QUEUE"="Transparent" "RenderType"="Transparent" }
 Pass {
  Tags { "QUEUE"="Transparent" "RenderType"="Transparent" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha OneMinusSrcAlpha
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_8), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
Vector 208 [_GAmplitude]
Vector 224 [_GFrequency]
Vector 240 [_GSteepness]
Vector 256 [_GSpeed]
Vector 272 [_GDirectionAB]
Vector 288 [_GDirectionCD]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_8), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
"ps_3_0
; 48 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.z
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c9.y
mul r0.xy, r0, c10.x
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r1.xyz, -r0, c3
mad_pp r0.xyz, r1, c3.w, r0
add_pp r4.xyz, r0, -c2
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.w, r3, r3
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r1.x, -r1, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r3
dp3_pp r0.y, r2, -r0
max_pp r0.w, r1.x, c9.y
add_pp_sat r0.x, -r0.w, c9
pow_pp r1, r0.x, c7.z
max_pp r2.x, r0.y, c9.y
pow r0, r2.x, c5.x
mov_pp r0.z, r1.x
mov_pp r0.y, c7.w
add_pp r0.y, c9.x, -r0
mad_pp_sat r0.y, r0, r0.z, c7.w
mad_pp r2.xyz, r0.y, r4, c2
mov r0.z, r0.x
texldp r1.x, v3, s2
mad r0.x, r1, c0.z, c0.w
max r0.z, r0, c9.y
rcp r0.x, r0.x
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c9.w
mul_sat r0.x, r0, c4
mad oC0.xyz, r0.z, c1, r2
mul_pp oC0.w, r0.x, r0.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedjnolchnheceibcjdncnpmhcdckbhbcenabaaaaaabiaiaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbaahaaaaeaaaaaaameabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaa
aaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaa
acaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaak
icaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
ajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaa
ajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaeb
aaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaah
dcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaaj
hcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
abaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_CameraDepthTexture] 2D 1
"ps_3_0
; 40 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c8, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c8.z
mul_pp r2.xy, r0.zwzw, c6.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c5
mad_pp r2.xyz, r2.xxyw, c8.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c8.y
pow r0, r1.w, c4.x
mul_pp r2.xz, r2, c7.x
dp3_pp r0.y, -r1, r2
mov r0.z, r0.x
max_pp r0.x, r0.y, c8.y
max r0.y, r0.z, c8
mul r1.xyz, r0.y, c1
add_pp_sat r1.w, -r0.x, c8.x
pow_pp r0, r1.w, c6.z
add oC0.xyz, r1, c2
mov_pp r0.y, c6.w
mov_pp r0.z, r0.x
texldp r1.x, v3, s1
mad r0.x, r1, c0.z, c0.w
rcp r0.x, r0.x
add_pp r0.y, c8.x, -r0
mad_pp_sat r0.y, r0, r0.z, c6.w
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c8.w
mul_sat r0.x, r0, c3
mul_pp oC0.w, r0.x, r0.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_CameraDepthTexture] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedcpmolfnjoofpphognjpbcnemhdcobfbmabaaaaaalaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckiafaaaaeaaaaaaagkabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
aoaaaaahdcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
dcaaaaalbcaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaabaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaaaaaaaaaa
dkaabaaaaaaaaaaaakaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaai
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaalhccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
egiccaaaaaaaaaaaafaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
"ps_3_0
; 42 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.z
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.x, r0.z
mul r1.xyz, r1.x, v1
add r3.xyz, r1, c4
mul r0.xy, r0, c8.x
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r1.w, r2, -r3
mul_pp r2.xz, r2, c6.x
dp3_pp r0.w, -r1, r2
max_pp r2.x, r1.w, c7.y
pow r1, r2.x, c3.x
add_pp r4.xyz, -r0, c2
mad_pp r0.xyz, r4, c2.w, r0
max_pp r0.w, r0, c7.y
add_pp_sat r0.w, -r0, c7.x
pow_pp r2, r0.w, c5.z
mov_pp r0.w, c5
add_pp r0.xyz, r0, -c1
mov r1.y, r1.x
mov_pp r1.x, r2
add_pp r0.w, c7.x, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r0, c1
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
add_pp_sat oC0.w, r0, c7
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedekijejogacbmpgejcncafnodliedoeghabaaaaaapmagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcpeafaaaaeaaaaaaahnabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaa
abaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaabaaaaaa
pgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
baaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 3 [_WorldLightDir]
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
"ps_3_0
; 34 ALU, 2 TEX
dcl_2d s0
def c6, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c6.z
mul_pp r2.xy, r0.zwzw, c4.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c3
mad_pp r2.xyz, r2.xxyw, c6.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c6.y
pow r0, r1.w, c2.x
mul_pp r2.xz, r2, c5.x
dp3_pp r0.y, -r1, r2
max_pp r0.y, r0, c6
add_pp_sat r1.x, -r0.y, c6
max r1.y, r0.x, c6
pow_pp r0, r1.x, c4.z
mul r1.xyz, r1.y, c0
mov_pp r0.z, r0.x
mov_pp r0.y, c4.w
add_pp r0.x, c6, -r0.y
mad_pp_sat r0.x, r0, r0.z, c4.w
add oC0.xyz, r1, c1
add_pp_sat oC0.w, r0.x, c6
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedfjonkajjjfejdllgemfphgdffiegbeoaabaaaaaaiiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefciaaeaaaaeaaaaaaacaabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpbaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegiccaaaaaaaaaaa
afaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
"ps_3_0
; 48 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.z
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c9.y
mul r0.xy, r0, c10.x
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r1.xyz, -r0, c3
mad_pp r0.xyz, r1, c3.w, r0
add_pp r4.xyz, r0, -c2
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.w, r3, r3
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r1.x, -r1, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r3
dp3_pp r0.y, r2, -r0
max_pp r0.w, r1.x, c9.y
add_pp_sat r0.x, -r0.w, c9
pow_pp r1, r0.x, c7.z
max_pp r2.x, r0.y, c9.y
pow r0, r2.x, c5.x
mov_pp r0.z, r1.x
mov_pp r0.y, c7.w
add_pp r0.y, c9.x, -r0
mad_pp_sat r0.y, r0, r0.z, c7.w
mad_pp r2.xyz, r0.y, r4, c2
mov r0.z, r0.x
texldp r1.x, v3, s2
mad r0.x, r1, c0.z, c0.w
max r0.z, r0, c9.y
rcp r0.x, r0.x
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c9.w
mul_sat r0.x, r0, c4
mad oC0.xyz, r0.z, c1, r2
mul_pp oC0.w, r0.x, r0.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedjnolchnheceibcjdncnpmhcdckbhbcenabaaaaaabiaiaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbaahaaaaeaaaaaaameabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaa
aaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaa
acaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaak
icaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
ajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaa
ajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaeb
aaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaah
dcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaaj
hcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
abaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_CameraDepthTexture] 2D 1
"ps_3_0
; 40 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c8, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c8.z
mul_pp r2.xy, r0.zwzw, c6.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c5
mad_pp r2.xyz, r2.xxyw, c8.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c8.y
pow r0, r1.w, c4.x
mul_pp r2.xz, r2, c7.x
dp3_pp r0.y, -r1, r2
mov r0.z, r0.x
max_pp r0.x, r0.y, c8.y
max r0.y, r0.z, c8
mul r1.xyz, r0.y, c1
add_pp_sat r1.w, -r0.x, c8.x
pow_pp r0, r1.w, c6.z
add oC0.xyz, r1, c2
mov_pp r0.y, c6.w
mov_pp r0.z, r0.x
texldp r1.x, v3, s1
mad r0.x, r1, c0.z, c0.w
rcp r0.x, r0.x
add_pp r0.y, c8.x, -r0
mad_pp_sat r0.y, r0, r0.z, c6.w
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c8.w
mul_sat r0.x, r0, c3
mul_pp oC0.w, r0.x, r0.y
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_CameraDepthTexture] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 80 [_ReflectionColor]
Vector 96 [_InvFadeParemeter]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedcpmolfnjoofpphognjpbcnemhdcobfbmabaaaaaalaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckiafaaaaeaaaaaaagkabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
aoaaaaahdcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
dcaaaaalbcaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaabaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaaaaaaaaaa
dkaabaaaaaaaaaaaakaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaai
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaalhccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
egiccaaaaaaaaaaaafaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
"ps_3_0
; 42 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.z
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.x, r0.z
mul r1.xyz, r1.x, v1
add r3.xyz, r1, c4
mul r0.xy, r0, c8.x
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r1.w, r2, -r3
mul_pp r2.xz, r2, c6.x
dp3_pp r0.w, -r1, r2
max_pp r2.x, r1.w, c7.y
pow r1, r2.x, c3.x
add_pp r4.xyz, -r0, c2
mad_pp r0.xyz, r4, c2.w, r0
max_pp r0.w, r0, c7.y
add_pp_sat r0.w, -r0, c7.x
pow_pp r2, r0.w, c5.z
mov_pp r0.w, c5
add_pp r0.xyz, r0, -c1
mov r1.y, r1.x
mov_pp r1.x, r2
add_pp r0.w, c7.x, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r0, c1
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
add_pp_sat oC0.w, r0, c7
"
}
SubProgram "d3d11 " {
Keywords { "WATER_REFLECTIVE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedekijejogacbmpgejcncafnodliedoeghabaaaaaapmagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcpeafaaaaeaaaaaaahnabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaa
abaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaabaaaaaa
pgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
baaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
Vector 0 [_SpecularColor]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 3 [_WorldLightDir]
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
"ps_3_0
; 34 ALU, 2 TEX
dcl_2d s0
def c6, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c6.z
mul_pp r2.xy, r0.zwzw, c4.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c3
mad_pp r2.xyz, r2.xxyw, c6.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c6.y
pow r0, r1.w, c2.x
mul_pp r2.xz, r2, c5.x
dp3_pp r0.y, -r1, r2
max_pp r0.y, r0, c6
add_pp_sat r1.x, -r0.y, c6
max r1.y, r0.x, c6
pow_pp r0, r1.x, c4.z
mul r1.xyz, r1.y, c0
mov_pp r0.z, r0.x
mov_pp r0.y, c4.w
add_pp r0.x, c6, -r0.y
mad_pp_sat r0.x, r0, r0.z, c4.w
add oC0.xyz, r1, c1
add_pp_sat oC0.w, r0.x, c6
"
}
SubProgram "d3d11 " {
Keywords { "WATER_SIMPLE" "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" }
SetTexture 0 [_BumpMap] 2D 0
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedfjonkajjjfejdllgemfphgdffiegbeoaabaaaaaaiiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefciaaeaaaaeaaaaaaacaabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpbaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegiccaaaaaaaaaaa
afaaaaaadoaaaaab"
}
}
 }
}
SubShader { 
 LOD 200
 Tags { "QUEUE"="Transparent" "RenderType"="Transparent" }
 Pass {
  Tags { "QUEUE"="Transparent" "RenderType"="Transparent" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha OneMinusSrcAlpha
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Matrix 5 [_Object2World]
Vector 9 [_Time]
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_BumpTiling]
Vector 12 [_BumpDirection]
"!!ARBvp1.0
# 11 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
MOV R1, c[12];
MAD R1, R1, c[9].x, R0.xzxz;
DP4 R0.y, vertex.position, c[6];
MUL result.texcoord[1], R1, c[11];
ADD result.texcoord[0].xyz, R0, -c[10];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 11 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_BumpTiling]
Vector 11 [_BumpDirection]
"vs_2_0
; 11 ALU
dcl_position0 v0
mov r0.y, c8.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
mad r1, c11, r0.y, r0.xzxz
dp4 r0.y, v0, c5
mul oT1, r1, c10
add oT0.xyz, r0, -c9
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedadkolaekfkijjkjplcfhfjahhaggecdkabaaaaaaieadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbiacaaaaeaaaabaaigaaaaaafjaaaaaeegiocaaaaaaaaaaa
anaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
baaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaabaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaacaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
doaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304
Vector 176 [_BumpTiling]
Vector 192 [_BumpDirection]
ConstBuffer "UnityPerCamera" 128
Vector 0 [_Time]
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0_level_9_1
eefiecedioabhedglngefckigfpliikcjemhdnnnabaaaaaaaaafaaaaaeaaaaaa
daaaaaaakiabaaaamiadaaaajaaeaaaaebgpgodjhaabaaaahaabaaaaaaacpopp
amabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaalaa
acaaabaaaaaaaaaaabaaaaaaabaaadaaaaaaaaaaabaaaeaaabaaaeaaaaaaaaaa
acaaaaaaaeaaafaaaaaaaaaaacaaamaaaeaaajaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjaafaaaaadaaaaahiaaaaaffjaakaaoekaaeaaaaae
aaaaahiaajaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaalaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaahiaamaaoekaaaaappjaaaaaoeiaabaaaaacabaaabia
adaaaakaaeaaaaaeabaaapiaabaaaaiaacaaoekaaaaaiiiaacaaaaadaaaaahoa
aaaaoeiaaeaaoekbafaaaaadabaaapoaabaaoeiaabaaoekaafaaaaadaaaaapia
aaaaffjaagaaoekaaeaaaaaeaaaaapiaafaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiappppaaaafdeieefcbiacaaaaeaaaabaaigaaaaaafjaaaaaeegiocaaa
aaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaabaaaaaa
egacbaaaaaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaa
aaaaaaaaagiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaa
aaaaaaaadiaaaaaipccabaaaacaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
alaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
laaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaaaiaaaaaa
faaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 2 TEX
PARAM c[8] = { program.local[0..6],
		{ 1, 0, 2, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.yw, fragment.texcoord[1].zwzw, texture[0], 2D;
TEX R0.yw, fragment.texcoord[1], texture[0], 2D;
ADD R0.zw, R0.xyyw, R1.xyyw;
ADD R1.xy, R0.wzzw, -c[7].x;
DP3 R0.x, fragment.texcoord[0], fragment.texcoord[0];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[0];
ADD R2.xyz, R0, c[4];
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R1.xy, R1, c[5].x;
MAD R1.xyz, R1.xxyw, c[7].xyxw, c[7].yxyw;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.w, R1, -R2;
MUL R1.xz, R1, c[6].x;
DP3 R0.x, -R0, R1;
MAX R0.w, R0, c[7].y;
POW R0.y, R0.w, c[3].x;
MAX R0.x, R0, c[7].y;
ADD_SAT R0.w, -R0.x, c[7].x;
POW R1.w, R0.w, c[5].z;
MAX R0.y, R0, c[7];
MOV R0.w, c[7].x;
MOV R1.xyz, c[1];
ADD R0.w, R0, -c[5];
MAD_SAT R0.w, R0, R1, c[5];
MUL R0.xyz, R0.y, c[0];
ADD R1.xyz, -R1, c[2];
MUL_SAT R1.w, R0, c[7].z;
MAD R1.xyz, R1.w, R1, c[1];
ADD result.color.xyz, R1, R0;
MAD_SAT result.color.w, R0, c[7].z, c[7];
END
# 35 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D 0
"ps_2_0
; 51 ALU, 2 TEX
dcl_2d s0
def c7, 1.00000000, 0.00000000, -1.00000000, 2.00000000
def c8, 2.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1
texld r1, t1, s0
mov r0.y, t1.w
mov r0.x, t1.z
mov r1.xz, c7.x
texld r0, r0, s0
add r0.yw, r1, r0
mov r0.x, r0.w
add_pp r0.xy, r0, c7.z
mov_pp r0.z, r0.y
mul_pp r0.xz, r0, c5.x
mov_pp r2.xy, r0.x
mov_pp r2.z, r0
mov r0.xz, c7.y
mov r0.y, c7.x
mov r1.y, c7
mad_pp r1.xyz, r2, r1, r0
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, r1
dp3 r0.x, t0, t0
rsq r0.x, r0.x
mul r3.xyz, r0.x, t0
mul_pp r1.xz, r2, c6.x
mov_pp r1.y, r2
dp3_pp r0.x, -r3, r1
add r4.xyz, r3, c4
max_pp r0.x, r0, c7.y
add_pp_sat r0.x, -r0, c7
pow_pp r3.x, r0.x, c5.z
dp3 r1.x, r4, r4
rsq r0.x, r1.x
mul r1.xyz, r0.x, r4
dp3_pp r1.x, r2, -r1
mov_pp r0.w, c5
add_pp r2.x, c7, -r0.w
mov_pp r0.x, r3.x
mad_pp_sat r0.x, r2, r0, c5.w
max_pp r1.x, r1, c7.y
pow r2.w, r1.x, c3.x
mad_pp_sat r0.w, r0.x, c8.x, c8.y
mov r1.x, r2.w
mov_pp r2.xyz, c2
max r1.x, r1, c7.y
mul_pp_sat r0.x, r0, c7.w
add_pp r2.xyz, -c1, r2
mul r1.xyz, r1.x, c0
mad_pp r0.xyz, r0.x, r2, c1
add_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_BumpMap] 2D 0
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0
eefiecedocjgjknbbkofadmlpdelhmjnmlnempokabaaaaaaoeafaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcamafaaaaeaaaaaaaedabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadpcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaa
ajaaaaaadcaaaaaphcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaaaaaaaaaiadpaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaa
agiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegbcbaaaabaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaa
aaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaeaabeaaaaaaaaaaadp
ddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpddaaaaah
icaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaakhcaabaaa
abaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
doaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_BumpMap] 2D 0
ConstBuffer "$Globals" 304
Vector 48 [_SpecularColor]
Vector 64 [_BaseColor]
Vector 80 [_ReflectionColor]
Float 112 [_Shininess]
Vector 128 [_WorldLightDir]
Vector 144 [_DistortParams]
Float 160 [_FresnelScale]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
eefiecededpcpeogancdmkdpknnfcnckkjffepimabaaaaaamiaiaaaaaeaaaaaa
daaaaaaabaadaaaaceaiaaaajeaiaaaaebgpgodjniacaaaaniacaaaaaaacpppp
jiacaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaadaaadaaaaaaaaaaaaaaaaaaahaaaeaaadaaaaaaaaaaaaacppppfbaaaaaf
ahaaapkaaaaaialpaaaaiadpaaaaaaaaaaaaiadpfbaaaaafaiaaapkaaaaaaaea
aaaaaadpaaaaaaaaaaaaaaaafbaaaaafajaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaacplabpaaaaac
aaaaaajaaaaiapkaabaaaaacaaaacbiaabaakklaabaaaaacaaaacciaabaappla
ecaaaaadaaaaapiaaaaaoeiaaaaioekaecaaaaadabaaapiaabaaoelaaaaioeka
acaaaaadacaacdiaaaaappiaabaappiaacaaaaadacaaceiaaaaaffiaabaaffia
acaaaaadaaaachiaacaaoeiaahaaaakaafaaaaadaaaachiaaaaaoeiaafaaaaka
abaaaaacabaaaoiaahaaoekaaeaaaaaeaaaachiaaaaaoeiaabaabliaajaaoeka
ceaaaaacabaachiaaaaaoeiaafaaaaadaaaacfiaabaaoeiaagaaaakaabaaaaac
aaaacciaabaaffiaaiaaaaadaaaaaiiaaaaaoelaaaaaoelaahaaaaacaaaaaiia
aaaappiaafaaaaadacaachiaaaaappiaaaaaoelaaeaaaaaeadaaahiaaaaaoela
aaaappiaaeaaoekaceaaaaacaeaachiaadaaoeiaaiaaaaadaaaaciiaabaaoeia
aeaaoeibalaaaaadacaaaiiaaaaappiaahaakkkacaaaaaadaaaaaiiaacaappia
adaaaakaaiaaaaadaaaacbiaacaaoeibaaaaoeiaacaaaaadaaaacciaaaaaaaib
ahaappkafiaaaaaeaaaacbiaaaaaaaiaaaaaffiaahaappkaalaaaaadabaacbia
aaaaaaiaahaakkkacaaaaaadaaaacbiaabaaaaiaafaakkkabcaaaaaeacaadbia
aaaaaaiaabaappiaafaappkaacaaaaadaaaacbiaacaaaaiaacaaaaiaaeaaaaae
abaadiiaacaaaaiaaiaaaakaaiaaffkaabaaaaacaaaabbiaaaaaaaiaabaaaaac
acaaahiaabaaoekaacaaaaadacaaahiaacaaoeibacaaoekaaeaaaaaeaaaachia
aaaaaaiaacaaoeiaabaaoekaaeaaaaaeabaachiaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaicpiaabaaoeiappppaaaafdeieefcamafaaaaeaaaaaaaedabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadpcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaa
ajaaaaaadcaaaaaphcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaaaaaaaaaiadpaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaa
agiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegbcbaaaabaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaa
aaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaeaabeaaaaaaaaaaadp
ddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpddaaaaah
icaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaakhcaabaaa
abaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
doaaaaabejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}
}
 }
}
Fallback "Transparent/Diffuse"
}