Shader "Hidden/ScreenSpaceAmbientObscurance" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_TexelSize;
uniform sampler2D _Rand;
uniform sampler2D _CameraDepthTexture;
uniform vec4 _ProjInfo;
uniform float _Intensity;
uniform float _Radius2;
uniform float _Radius;
uniform vec4 _ZBufferParams;
void main ()
{
  int l_1;
  float sum_2;
  float ssDiskRadius_3;
  vec3 n_C_4;
  float randomPatternRotationAngle_5;
  vec3 C_6;
  vec2 ssC_7;
  vec4 fragment_8;
  fragment_8.xw = vec2(1.0, 1.0);
  ssC_7 = xlv_TEXCOORD1;
  vec3 P_9;
  P_9.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD1).x;
  float tmpvar_10;
  tmpvar_10 = (1.0/(((_ZBufferParams.z * P_9.z) + _ZBufferParams.w)));
  vec3 tmpvar_11;
  tmpvar_11.xy = ((((xlv_TEXCOORD1 * _MainTex_TexelSize.zw) * _ProjInfo.xy) + _ProjInfo.zw) * tmpvar_10);
  tmpvar_11.z = tmpvar_10;
  P_9 = tmpvar_11;
  C_6 = tmpvar_11;
  float tmpvar_12;
  tmpvar_12 = clamp ((tmpvar_10 * 0.00333333), 0.0, 1.0);
  vec2 p_13;
  float tmpvar_14;
  tmpvar_14 = floor((tmpvar_12 * 256.0));
  p_13.x = (tmpvar_14 * 0.00390625);
  p_13.y = ((tmpvar_12 * 256.0) - tmpvar_14);
  fragment_8.yz = p_13;
  randomPatternRotationAngle_5 = (texture2D (_Rand, (xlv_TEXCOORD0 * 12.0)).x * 1000.0);
  vec3 tmpvar_15;
  tmpvar_15 = dFdy(tmpvar_11);
  vec3 tmpvar_16;
  tmpvar_16 = dFdx(tmpvar_11);
  n_C_4 = normalize(((tmpvar_15.yzx * tmpvar_16.zxy) - (tmpvar_15.zxy * tmpvar_16.yzx)));
  ssDiskRadius_3 = (-(_Radius) / tmpvar_10);
  sum_2 = 0.0;
  l_1 = 0;
  for (int l_1 = 0; l_1 < 11; ) {
    float tmpvar_17;
    tmpvar_17 = ((float(l_1) + 0.5) * 0.0909091);
    float tmpvar_18;
    tmpvar_18 = ((tmpvar_17 * 43.96) + randomPatternRotationAngle_5);
    vec2 tmpvar_19;
    tmpvar_19.x = cos(tmpvar_18);
    tmpvar_19.y = sin(tmpvar_18);
    vec3 P_20;
    vec2 tmpvar_21;
    tmpvar_21 = clamp ((((tmpvar_17 * ssDiskRadius_3) * tmpvar_19) + ssC_7), 0.0, 1.0);
    P_20.z = texture2D (_CameraDepthTexture, tmpvar_21).x;
    float tmpvar_22;
    tmpvar_22 = (1.0/(((_ZBufferParams.z * P_20.z) + _ZBufferParams.w)));
    vec3 tmpvar_23;
    tmpvar_23.xy = ((((tmpvar_21 * _MainTex_TexelSize.zw) * _ProjInfo.xy) + _ProjInfo.zw) * tmpvar_22);
    tmpvar_23.z = tmpvar_22;
    P_20 = tmpvar_23;
    vec3 tmpvar_24;
    tmpvar_24 = (tmpvar_23 - C_6);
    float tmpvar_25;
    tmpvar_25 = dot (tmpvar_24, tmpvar_24);
    float tmpvar_26;
    tmpvar_26 = max ((_Radius2 - tmpvar_25), 0.0);
    sum_2 = (sum_2 + (((tmpvar_26 * tmpvar_26) * tmpvar_26) * max (((dot (tmpvar_24, n_C_4) - 0.01) / (0.01 + tmpvar_25)), 0.0)));
    l_1 = (l_1 + 1);
  };
  float tmpvar_27;
  tmpvar_27 = (_Radius2 * _Radius);
  float tmpvar_28;
  tmpvar_28 = (sum_2 / (tmpvar_27 * tmpvar_27));
  sum_2 = tmpvar_28;
  float tmpvar_29;
  tmpvar_29 = max (0.0, (1.0 - ((tmpvar_28 * _Intensity) * 0.454545)));
  vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_29;
  tmpvar_30.y = tmpvar_29;
  fragment_8.xw = tmpvar_30;
  gl_FragData[0] = fragment_8;
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
; 11 ALU, 1 FLOW
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c5, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r1.z, c5.x
dp4 r0.x, v0, c0
mov r1.xy, v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.y, v0, c1
if_lt c4.y, r1.z
add r1.y, -v1, c5
mov r1.x, v1
endif
mov o0, r0
mov o1.xy, v1
mov o2.xy, r1
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 144
Vector 112 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedbcjeglhmoohcpmffkgpbmdpjijmafmehabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaahaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Float 1 [_Radius]
Float 2 [_Radius2]
Float 3 [_Intensity]
Vector 4 [_ProjInfo]
Vector 5 [_MainTex_TexelSize]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_Rand] 2D 1
"ps_3_0
; 71 ALU, 3 TEX, 5 FLOW
dcl_2d s0
dcl_2d s1
def c6, 0.00333333, 256.00000000, 0.00390625, 12.00000000
def c7, 1000.00000000, 0.00000000, 0.50000000, 0.09090909
defi i0, 11, 0, 1, 0
def c8, 43.96000290, 0.15915491, 0.50000000, -0.01000000
def c9, 6.28318501, -3.14159298, 0.01000000, 1.00000000
def c10, 0.45454547, 1.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
texld r0.x, v1, s0
mad r0.w, r0.x, c0.z, c0
rcp r1.w, r0.w
mul r0.xy, v1, c5.zwzw
mad r0.xy, r0, c4, c4.zwzw
mul r1.xy, r0, r1.w
mov r1.z, r1.w
mul_sat r1.w, r1, c6.x
dsx r2.xyz, r1
dsy r0.xyz, r1
mul r3.xyz, r0.zxyw, r2.yzxw
mad r0.xyz, r0.yzxw, r2.zxyw, -r3
dp3 r2.x, r0, r0
rsq r2.x, r2.x
mul r2.xyz, r2.x, r0
mul r2.w, r1, c6.y
frc r0.z, r2.w
add r0.z, r2.w, -r0
mul r0.xy, v0, c6.w
texld r0.x, r0, s1
mad r3.y, r1.w, c6, -r0.z
mul r3.x, r0.z, c6.z
mul r1.w, r0.x, c7.x
mul r2.w, r0, -c1.x
mov r3.z, c7.y
mov r3.w, c7.y
loop aL, i0
add r0.x, r3.w, c7.z
mul r4.x, r0, c7.w
mad r0.x, r4, c8, r1.w
mad r0.x, r0, c8.y, c8.z
frc r0.x, r0
mad r4.y, r0.x, c9.x, c9
sincos r0.xy, r4.y
mul r0.z, r4.x, r2.w
mad_sat r4.xy, r0.z, r0, v1
texld r0.x, r4, s0
mad r0.z, r0.x, c0, c0.w
rcp r0.w, r0.z
mul r0.xy, r4, c5.zwzw
mad r0.xy, r0, c4, c4.zwzw
mul r0.xy, r0, r0.w
mov r0.z, r0.w
add r0.xyz, r0, -r1
dp3 r4.x, r0, r0
add r0.w, -r4.x, c2.x
dp3 r0.x, r0, r2
add r4.x, r4, c9.z
max r0.w, r0, c7.y
add r0.x, r0, c8.w
rcp r0.y, r4.x
mul r0.y, r0.x, r0
mul r0.x, r0.w, r0.w
max r0.y, r0, c7
mul r0.x, r0, r0.w
mad r3.z, r0.x, r0.y, r3
add r3.w, r3, c9
endloop
mov r0.x, c2
mul r0.x, c1, r0
mul r0.x, r0, r0
rcp r0.x, r0.x
mul r0.x, r3.z, r0
mul r0.x, r0, c3
mad r0.x, -r0, c10, c10.y
max oC0.xw, r0.x, c7.y
mov oC0.yz, r3.xxyw
"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 0
ConstBuffer "$Globals" 144
Float 16 [_Radius]
Float 20 [_Radius2]
Float 24 [_Intensity]
Vector 32 [_ProjInfo]
Vector 112 [_MainTex_TexelSize]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedbhimcolpdmdjdeeilmempllhjogoeljgabaaaaaajaaiaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcliahaaaaeaaaaaaaooabaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
mcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaaaaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakecaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaa
ogbkbaaaabaaaaaaogikcaaaaaaaaaaaahaaaaaadcaaaaalmcaabaaaabaaaaaa
agaebaaaabaaaaaaagiecaaaaaaaaaaaacaaaaaakgiocaaaaaaaaaaaacaaaaaa
diaaaaahdcaabaaaaaaaaaaakgakbaaaaaaaaaaaogakbaaaabaaaaaadicaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaohefkdldiaaaaahecaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiaedebaaaaafecaabaaaabaaaaaa
ckaabaaaabaaaaaadiaaaaahcccabaaaaaaaaaaackaabaaaabaaaaaaabeaaaaa
aaaaiadldcaaaaakeccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiaed
ckaabaiaebaaaaaaabaaaaaablaaaaafdcaabaaaabaaaaaaegaabaaaabaaaaaa
cgaaaaaiaanaaaaaicaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaaadaaaaaa
cdaaaaajbcaabaaaabaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaafhaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
cgaaaaaiaanaaaaaicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaakaaaaaa
claaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaamaaaaafhcaabaaaabaaaaaa
cgajbaaaaaaaaaaaalaaaaafhcaabaaaacaaaaaajgaebaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaacgajbaaaabaaaaaajgaebaaaacaaaaaaegacbaiaebaaaaaaadaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaaaoaaaaajicaabaaaabaaaaaaakiacaiaebaaaaaa
aaaaaaaaabaaaaaackaabaaaaaaaaaaadgaaaaaidcaabaaaacaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahecaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaaapaaaaaaadaaaeadckaabaaaacaaaaaaclaaaaaf
ecaabaaaacaaaaaabkaabaaaacaaaaaaaaaaaaahecaabaaaacaaaaaackaabaaa
acaaaaaaabeaaaaaaaaaaadpdiaaaaahicaabaaaacaaaaaadkaabaaaabaaaaaa
ckaabaaaacaaaaaadcaaaaajecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaa
aljadleadkaabaaaaaaaaaaaenaaaaahbcaabaaaadaaaaaabcaabaaaaeaaaaaa
ckaabaaaacaaaaaadiaaaaahecaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
ijiiiidndgaaaaafccaabaaaaeaaaaaaakaabaaaadaaaaaadccaaaajmcaabaaa
acaaaaaakgakbaaaacaaaaaaagaebaaaaeaaaaaakgbobaaaabaaaaaaefaaaaaj
pcaabaaaadaaaaaaogakbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dcaaaaalbcaabaaaadaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaadaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakecaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaadaaaaaadiaaaaaimcaabaaaacaaaaaa
kgaobaaaacaaaaaakgiocaaaaaaaaaaaahaaaaaadcaaaaalmcaabaaaacaaaaaa
kgaobaaaacaaaaaaagiecaaaaaaaaaaaacaaaaaakgiocaaaaaaaaaaaacaaaaaa
diaaaaahdcaabaaaadaaaaaakgakbaaaadaaaaaaogakbaaaacaaaaaaaaaaaaai
hcaabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaaaaaaaaajbcaabaaaadaaaaaa
ckaabaiaebaaaaaaacaaaaaabkiacaaaaaaaaaaaabaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadiaaaaahccaabaaaadaaaaaa
akaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaahbcaabaaaadaaaaaaakaabaaa
adaaaaaabkaabaaaadaaaaaaaaaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaknhcdlmaaaaaaahecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaa
aknhcddmaoaaaaahecaabaaaacaaaaaadkaabaaaacaaaaaackaabaaaacaaaaaa
deaaaaahecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaaaaaaaaaadcaaaaaj
bcaabaaaacaaaaaaakaabaaaadaaaaaackaabaaaacaaaaaaakaabaaaacaaaaaa
boaaaaahccaabaaaacaaaaaabkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaab
diaaaaajbcaabaaaaaaaaaaaakiacaaaaaaaaaaaabaaaaaabkiacaaaaaaaaaaa
abaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
aoaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaaaaaaaaaaabaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaklkkkkdoabeaaaaa
aaaaiadpdeaaaaakjccabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD0;
uniform float _BlurFilterDistance;
uniform vec2 _Axis;
float gaussian[5];
uniform vec4 _MainTex_TexelSize;
uniform sampler2D _MainTex;
void main ()
{
  gaussian[0] = 0.15317;
  gaussian[1] = 0.144893;
  gaussian[2] = 0.122649;
  gaussian[3] = 0.092902;
  gaussian[4] = 0.06297;
  int r_1;
  float totalWeight_2;
  float sum_3;
  float key_4;
  vec2 ssC_5;
  vec4 fragment_6;
  fragment_6 = vec4(1.0, 1.0, 1.0, 1.0);
  ssC_5 = xlv_TEXCOORD0;
  vec4 tmpvar_7;
  tmpvar_7 = texture2DLod (_MainTex, xlv_TEXCOORD0, 0.0);
  vec2 tmpvar_8;
  tmpvar_8 = tmpvar_7.yz;
  key_4 = ((tmpvar_7.y * 0.996109) + (tmpvar_7.z * 0.00389105));
  float tmpvar_9;
  tmpvar_9 = (gaussian[0] * 0.5);
  totalWeight_2 = tmpvar_9;
  sum_3 = (tmpvar_7.x * tmpvar_9);
  r_1 = -4;
  for (int r_1 = -4; r_1 <= 4; ) {
    if ((r_1 != 0)) {
      int index_10;
      vec4 tmpvar_11;
      tmpvar_11.zw = vec2(0.0, 0.0);
      tmpvar_11.xy = (ssC_5 + ((_Axis * _MainTex_TexelSize.xy) * (float(r_1) * _BlurFilterDistance)));
      vec4 tmpvar_12;
      tmpvar_12 = texture2DLod (_MainTex, tmpvar_11.xy, 0.0);
      float tmpvar_13;
      tmpvar_13 = ((tmpvar_12.y * 0.996109) + (tmpvar_12.z * 0.00389105));
      index_10 = r_1;
      if ((r_1 < 0)) {
        index_10 = -(r_1);
      };
      float tmpvar_14;
      tmpvar_14 = ((0.3 + gaussian[index_10]) * max (0.0, (1.0 - (2000.0 * abs((tmpvar_13 - key_4))))));
      sum_3 = (sum_3 + (tmpvar_12.x * tmpvar_14));
      totalWeight_2 = (totalWeight_2 + tmpvar_14);
    };
    r_1 = (r_1 + 1);
  };
  fragment_6.xw = vec2((sum_3 / (totalWeight_2 + 0.0001)));
  fragment_6.yz = tmpvar_8;
  gl_FragData[0] = fragment_6;
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
; 11 ALU, 1 FLOW
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c5, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r1.z, c5.x
dp4 r0.x, v0, c0
mov r1.xy, v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.y, v0, c1
if_lt c4.y, r1.z
add r1.y, -v1, c5
mov r1.x, v1
endif
mov o0, r0
mov o1.xy, v1
mov o2.xy, r1
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 144
Vector 112 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedbcjeglhmoohcpmffkgpbmdpjijmafmehabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaahaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Vector 0 [_MainTex_TexelSize]
Vector 1 [_Axis]
Float 2 [_BlurFilterDistance]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
; 99 ALU, 18 TEX
dcl_2d s0
def c3, 0.00000000, 4.00000000, 0.00389105, 0.99610895
def c4, 2000.00000000, 1.00000000, 0.36296999, 3.00000000
def c5, 0.39290202, 2.00000000, 0.42264903, 0.44489300
def c6, -2.00000000, -3.00000000, -4.00000000, 0.07658500
def c7, 0.07668500, 0, 0, 0
dcl_texcoord0 v0.xy
mov r0.xy, c1
mul r3.xy, c0, r0
mul r3.zw, r3.xyxy, c2.x
mad r0.xy, r3.zwzw, c6.x, v0
mov r0.z, c3.x
texldl r1.xyz, r0.xyzz, s0
mul r1.z, r1, c3
mad r1.y, r1, c3.w, r1.z
mad r2.xy, r3.zwzw, c6.z, v0
mov r2.z, c3.x
texldl r4.xyz, r2.xyzz, s0
mul r1.z, r4, c3
mad r1.z, r4.y, c3.w, r1
mad r2.xy, r3.zwzw, c6.y, v0
mov r2.z, c3.x
texldl r2.xyz, r2.xyzz, s0
mov r0.z, c3.x
mov r0.xy, v0
texldl r0.xyz, r0.xyzz, s0
mul r0.w, r0.z, c3.z
mad r0.w, r0.y, c3, r0
add r1.w, -r0, r1.z
mul r1.z, r2, c3
add r1.y, -r0.w, r1
mad r1.z, r2.y, c3.w, r1
add r1.z, -r0.w, r1
abs r1.y, r1
mad r1.y, -r1, c4.x, c4
max r1.y, r1, c3.x
abs r1.w, r1
mad r1.w, -r1, c4.x, c4.y
max r1.w, r1, c3.x
mul r1.w, r1, c4.z
mul r2.y, r4.x, r1.w
abs r1.z, r1
mad r1.z, -r1, c4.x, c4.y
mad r2.y, r0.x, c6.w, r2
max r1.z, r1, c3.x
mul r0.x, r1.z, c5
mad r1.z, r2.x, r0.x, r2.y
mad r2.xy, r3, -c2.x, v0
mov r2.z, c3.x
texldl r2.xyz, r2.xyzz, s0
mul r2.w, r1.y, c5.z
mul r1.y, r2.z, c3.z
mad r2.z, r1.x, r2.w, r1
mad r2.y, r2, c3.w, r1
add r2.y, -r0.w, r2
mad r1.xy, r3, c2.x, v0
mov r1.z, c3.x
texldl r1.xyz, r1.xyzz, s0
mul r1.z, r1, c3
mad r1.y, r1, c3.w, r1.z
abs r2.y, r2
mad r1.z, -r2.y, c4.x, c4.y
add r1.y, -r0.w, r1
max r2.y, r1.z, c3.x
abs r1.z, r1.y
mul r1.y, r2, c5.w
mad r3.x, r2, r1.y, r2.z
mad r1.z, -r1, c4.x, c4.y
max r1.z, r1, c3.x
mul r1.z, r1, c5.w
add r1.w, r0.x, r1
mad r2.xy, r3.zwzw, c5.y, v0
mov r2.z, c3.x
texldl r2.xyz, r2.xyzz, s0
mul r2.z, r2, c3
mad r2.z, r2.y, c3.w, r2
mad r2.y, r1.x, r1.z, r3.x
add r1.x, -r0.w, r2.z
abs r0.x, r1
add r1.x, r2.w, r1.w
add r1.x, r1.y, r1
add r1.x, r1.z, r1
mad r0.x, -r0, c4, c4.y
max r0.x, r0, c3
mul r0.x, r0, c5.z
add r1.w, r0.x, r1.x
mad r1.xy, r3.zwzw, c4.w, v0
mov r1.z, c3.x
texldl r1.xyz, r1.xyzz, s0
mul r2.z, r1, c3
mad r2.z, r1.y, c3.w, r2
mov r4.z, c3.x
mad r4.xy, r3.zwzw, c3.y, v0
texldl r3.xyz, r4.xyzz, s0
mul r1.z, r3, c3
mad r1.y, r3, c3.w, r1.z
add r1.z, -r0.w, r2
add r0.w, r1.y, -r0
abs r1.y, r1.z
abs r0.w, r0
mad r1.y, -r1, c4.x, c4
mad r0.w, -r0, c4.x, c4.y
max r1.y, r1, c3.x
mul r1.y, r1, c5.x
max r0.w, r0, c3.x
mad r0.x, r2, r0, r2.y
mul r0.w, r0, c4.z
mad r0.x, r1, r1.y, r0
add r1.z, r1.y, r1.w
add r1.z, r0.w, r1
add r1.z, r1, c7.x
rcp r1.x, r1.z
mad r0.x, r3, r0.w, r0
mul oC0.xw, r0.x, r1.x
mov oC0.yz, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 144
Vector 112 [_MainTex_TexelSize]
Vector 128 [_Axis] 2
Float 136 [_BlurFilterDistance]
BindCB  "$Globals" 0
"ps_4_0
eefiecedlgoncigjcllliboeagcmfhgcoleiofnkabaaaaaaoaaeaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcaiaeaaaaeaaaaaaaacabaaaa
dfbiaaaabgaaaaaajjnibmdoaaaaaaaaaaaaaaaaaaaaaaaanffobedoaaaaaaaa
aaaaaaaaaaaaaaaaggcppldnaaaaaaaaaaaaaaaaaaaaaaaaghedlodnaaaaaaaa
aaaaaaaaaaaaaaaagkpgiadnaaaaaaaaaaaaaaaaaaaaaaaafjaaaaaeegiocaaa
aaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaeiaaaaalpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaabeaaaaaaaaaaaaaapaaaaakicaabaaaaaaaaaaajgafbaaa
aaaaaaaaaceaaaaappaahpdpppaahpdlaaaaaaaaaaaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaajjnijmdndiaaaaajdcaabaaaabaaaaaa
egiacaaaaaaaaaaaahaaaaaaegiacaaaaaaaaaaaaiaaaaaadgaaaaafbcaabaaa
acaaaaaaakaabaaaaaaaaaaadgaaaaaigcaabaaaacaaaaaaaceaaaaaaaaaaaaa
jjnijmdnpmppppppaaaaaaaadaaaaaabccaaaaahecaabaaaabaaaaaaabeaaaaa
aeaaaaaackaabaaaacaaaaaaadaaaeadckaabaaaabaaaaaabpaaaeadckaabaaa
acaaaaaaclaaaaafecaabaaaabaaaaaackaabaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaaiaaaaaadcaaaaajmcaabaaa
abaaaaaaagaebaaaabaaaaaakgakbaaaabaaaaaaagbebaaaabaaaaaaeiaaaaal
pcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
abeaaaaaaaaaaaaaapaaaaakecaabaaaabaaaaaajgafbaaaadaaaaaaaceaaaaa
ppaahpdpppaahpdlaaaaaaaaaaaaaaaaccaaaaahicaabaaaabaaaaaackaabaaa
acaaaaaaabeaaaaaaaaaaaaaciaaaaaficaabaaaacaaaaaackaabaaaacaaaaaa
dhaaaaajicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaackaabaaa
acaaaaaaaaaaaaaiicaabaaaabaaaaaaabeaaaaajkjjjjdoakjajaaadkaabaaa
abaaaaaaaaaaaaaiecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaackaabaaa
abaaaaaadcaaaaakecaabaaaabaaaaaackaabaiambaaaaaaabaaaaaaabeaaaaa
aaaapkeeabeaaaaaaaaaiadpdeaaaaahecaabaaaabaaaaaackaabaaaabaaaaaa
abeaaaaaaaaaaaaadiaaaaahicaabaaaacaaaaaackaabaaaabaaaaaadkaabaaa
abaaaaaadcaaaaajbcaabaaaacaaaaaaakaabaaaadaaaaaadkaabaaaacaaaaaa
akaabaaaacaaaaaadcaaaaajccaabaaaacaaaaaadkaabaaaabaaaaaackaabaaa
abaaaaaabkaabaaaacaaaaaabfaaaaabboaaaaahecaabaaaacaaaaaackaabaaa
acaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahbcaabaaaaaaaaaaabkaabaaa
acaaaaaaabeaaaaabhlhnbdiaoaaaaahjccabaaaaaaaaaaaagaabaaaacaaaaaa
agaabaaaaaaaaaaadgaaaaafgccabaaaaaaaaaaafgagbaaaaaaaaaaadoaaaaab
"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _AOTex;
void main ()
{
  gl_FragData[0] = (texture2D (_MainTex, xlv_TEXCOORD0) * texture2D (_AOTex, xlv_TEXCOORD1).xxxx);
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
; 11 ALU, 1 FLOW
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c5, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r1.z, c5.x
dp4 r0.x, v0, c0
mov r1.xy, v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.y, v0, c1
if_lt c4.y, r1.z
add r1.y, -v1, c5
mov r1.x, v1
endif
mov o0, r0
mov o1.xy, v1
mov o2.xy, r1
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 144
Vector 112 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedbcjeglhmoohcpmffkgpbmdpjijmafmehabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaahaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
SetTexture 0 [_AOTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_3_0
; 1 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
texld r1.x, v1, s0
texld r0, v0, s1
mul oC0, r0, r1.x
"
}
SubProgram "d3d11 " {
SetTexture 0 [_AOTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_4_0
eefiecedhonmmkhajogncnhbhnncghjepkpfkmgiabaaaaaakmabaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcneaaaaaaeaaaaaaadfaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaadiaaaaahpccabaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadoaaaaab"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_TexelSize;
uniform sampler2D _MainTex;
uniform sampler2D _AOTex;
void main ()
{
  float tmpvar_1;
  tmpvar_1 = ((((texture2D (_AOTex, xlv_TEXCOORD1).x + texture2D (_AOTex, (xlv_TEXCOORD1 + (_MainTex_TexelSize.xy * 0.75))).x) + texture2D (_AOTex, (xlv_TEXCOORD1 - (_MainTex_TexelSize.xy * 0.75))).x) + texture2D (_AOTex, (xlv_TEXCOORD1 + (_MainTex_TexelSize.xy * vec2(-0.75, 0.75)))).x) + texture2D (_AOTex, (xlv_TEXCOORD1 - (_MainTex_TexelSize.xy * vec2(-0.75, 0.75)))).x);
  vec4 tmpvar_2;
  tmpvar_2.w = 5.0;
  tmpvar_2.x = tmpvar_1;
  tmpvar_2.y = tmpvar_1;
  tmpvar_2.z = tmpvar_1;
  gl_FragData[0] = ((texture2D (_MainTex, xlv_TEXCOORD0) * tmpvar_2) / 5.0);
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
; 11 ALU, 1 FLOW
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c5, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r1.z, c5.x
dp4 r0.x, v0, c0
mov r1.xy, v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.y, v0, c1
if_lt c4.y, r1.z
add r1.y, -v1, c5
mov r1.x, v1
endif
mov o0, r0
mov o1.xy, v1
mov o2.xy, r1
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 144
Vector 112 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedbcjeglhmoohcpmffkgpbmdpjijmafmehabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaahaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Vector 0 [_MainTex_TexelSize]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_AOTex] 2D 1
"ps_3_0
; 15 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
def c1, 0.75000000, -0.75000000, 5.00000000, 0.20000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
mov r0.xy, c0
mad r0.xy, c1.x, -r0, v1
mov r1.xy, c0
mad r1.xy, c1.x, r1, v1
texld r2.x, r1, s1
texld r0.x, r0, s1
texld r1.x, v1, s1
add r0.y, r1.x, r2.x
mov r0.zw, c0.xyxy
add r1.z, r0.y, r0.x
mad r0.xy, c1.yxzw, r0.zwzw, v1
mov r0.zw, c0.xyxy
texld r0.x, r0, s1
mad r1.xy, c1.yxzw, -r0.zwzw, v1
add r0.y, r1.z, r0.x
texld r0.x, r1, s1
texld r3, v0, s0
mov r0.w, c1.z
add r0.xyz, r0.y, r0.x
mul r0, r3, r0
mul oC0, r0, c1.w
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_AOTex] 2D 0
ConstBuffer "$Globals" 144
Vector 112 [_MainTex_TexelSize]
BindCB  "$Globals" 0
"ps_4_0
eefiecedibocfdcnabbhkpknkndkdbfilibkibceabaaaaaafaadaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchiacaaaaeaaaaaaajoaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadcaaaaanpcaabaaa
abaaaaaaegiecaaaaaaaaaaaahaaaaaaaceaaaaaaaaaeadpaaaaeadpaaaaealp
aaaaeadpogbobaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogakbaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaacaaaaaadcaaaaaopcaabaaaacaaaaaaegiecaia
ebaaaaaaaaaaaaaaahaaaaaaaceaaaaaaaaaeadpaaaaeadpaaaaealpaaaaeadp
ogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaogakbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaabaaaaaa
akaabaaaaaaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaakpccabaaaaaaaaaaaegaobaaaabaaaaaaaceaaaaamnmmemdo
mnmmemdomnmmemdoaaaaiadpdoaaaaab"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_TexelSize;
uniform sampler2D _MainTex;
uniform sampler2D _CameraDepthTexture;
uniform vec4 _ProjInfo;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 fragment_1;
  vec3 P_2;
  P_2.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x;
  float tmpvar_3;
  tmpvar_3 = (1.0/(((_ZBufferParams.z * P_2.z) + _ZBufferParams.w)));
  vec3 tmpvar_4;
  tmpvar_4.xy = ((((xlv_TEXCOORD0 * _MainTex_TexelSize.zw) * _ProjInfo.xy) + _ProjInfo.zw) * tmpvar_3);
  tmpvar_4.z = tmpvar_3;
  P_2 = tmpvar_4;
  float tmpvar_5;
  tmpvar_5 = clamp ((tmpvar_3 * 0.00333333), 0.0, 1.0);
  vec2 p_6;
  float tmpvar_7;
  tmpvar_7 = floor((tmpvar_5 * 256.0));
  p_6.x = (tmpvar_7 * 0.00390625);
  p_6.y = ((tmpvar_5 * 256.0) - tmpvar_7);
  fragment_1.yz = p_6;
  fragment_1.xw = texture2D (_MainTex, xlv_TEXCOORD0).xw;
  gl_FragData[0] = fragment_1;
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
; 11 ALU, 1 FLOW
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c5, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r1.z, c5.x
dp4 r0.x, v0, c0
mov r1.xy, v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.y, v0, c1
if_lt c4.y, r1.z
add r1.y, -v1, c5
mov r1.x, v1
endif
mov o0, r0
mov o1.xy, v1
mov o2.xy, r1
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 144
Vector 112 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedbcjeglhmoohcpmffkgpbmdpjijmafmehabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaahaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_3_0
; 9 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c1, 0.00333333, 256.00000000, 0.00390625, 0
dcl_texcoord0 v0.xy
texld r0.x, v0, s0
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
mul_sat r0.x, r0, c1
mul r0.y, r0.x, c1
frc r0.z, r0.y
add r0.y, r0, -r0.z
mul r0.z, r0.y, c1
mad r0.w, r0.x, c1.y, -r0.y
mov oC0.yz, r0.xzww
texld oC0.xw, v0, s1
"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "UnityPerCamera" 0
"ps_4_0
eefiecedijibedojkfamodpldjkldjnjlpkofjfhabaaaaaaimacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcleabaaaaeaaaaaaagnaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaa
ahaaaaaaakaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaaaoaaaaakbcaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaa
dicaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaohefkdldiaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiaedebaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakeccabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaiaedbkaabaiaebaaaaaaaaaaaaaadiaaaaahcccabaaaaaaaaaaa
bkaabaaaaaaaaaaaabeaaaaaaaaaiadlefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadgaaaaafjccabaaaaaaaaaaa
agambaaaaaaaaaaadoaaaaab"
}
}
 }
}
Fallback Off
}