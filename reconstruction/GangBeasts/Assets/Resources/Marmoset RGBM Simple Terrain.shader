Shader "Hidden/Marmoset/RGBM Simple Terrain" {
Properties {
 _Control ("Splatmap (RGBA)", 2D) = "red" {}
 _Splat0 ("Layer 0 (R)", 2D) = "white" {}
 _Splat1 ("Layer 1 (G)", 2D) = "white" {}
 _Splat2 ("Layer 2 (B)", 2D) = "white" {}
 _Splat3 ("Layer 3 (A)", 2D) = "white" {}
 _MainTex ("BaseMap (RGB)", 2D) = "white" {}
 _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader { 
 Tags { "QUEUE"="Geometry-100" "RenderType"="MarmoSimpleTerrain" "SplatCount"="4" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry-100" "RenderType"="MarmoSimpleTerrain" "SplatCount"="4" }
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [unity_Scale]
Vector 17 [_Control_ST]
Vector 18 [_Splat0_ST]
Vector 19 [_Splat1_ST]
Vector 20 [_Splat2_ST]
Vector 21 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[16].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R0.y, R3.w, R3.w;
DP4 R3.z, R1, c[14];
DP4 R3.y, R1, c[13];
DP4 R3.x, R1, c[12];
MAD R0.y, R0.x, R0.x, -R0;
MUL R1.xyz, R0.y, c[15];
ADD R2.xyz, R2, R3;
ADD result.texcoord[5].xyz, R2, R1;
MOV result.texcoord[4].z, R2.w;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[19], c[19].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[21], c[21].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 34 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_SHAr]
Vector 9 [unity_SHAg]
Vector 10 [unity_SHAb]
Vector 11 [unity_SHBr]
Vector 12 [unity_SHBg]
Vector 13 [unity_SHBb]
Vector 14 [unity_SHC]
Vector 15 [unity_Scale]
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c21.x
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
mul r0.y, r3.w, r3.w
dp4 r3.z, r1, c13
dp4 r3.y, r1, c12
dp4 r3.x, r1, c11
mad r0.y, r0.x, r0.x, -r0
mul r1.xyz, r0.y, c14
add r2.xyz, r2, r3
add o6.xyz, r2, r1
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r0
mad o1.zw, v2.xyxy, c17.xyxy, c17
mad o1.xy, v2, c16, c16.zwzw
mad o2.zw, v2.xyxy, c19.xyxy, c19
mad o2.xy, v2, c18, c18.zwzw
mad o3.xy, v2, c20, c20.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 240
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedaebkcdmhdhppgefjlifggjhjjfhjdalbabaaaaaaimagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcmaaeaaaaeaaaabaadaabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaa
ogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaa
amaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
anaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhccabaaaagaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
Vector 10 [_Control_ST]
Vector 11 [_Splat0_ST]
Vector 12 [_Splat1_ST]
Vector 13 [_Splat2_ST]
Vector 14 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 13 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[14], c[14].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 13 instructions, 0 R-regs
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
Vector 9 [_Control_ST]
Vector 10 [_Splat0_ST]
Vector 11 [_Splat1_ST]
Vector 12 [_Splat2_ST]
Vector 13 [_Splat3_ST]
"vs_3_0
; 13 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.zw, v2.xyxy, c10.xyxy, c10
mad o1.xy, v2, c9, c9.zwzw
mad o2.zw, v2.xyxy, c12.xyxy, c12
mad o2.xy, v2, c11, c11.zwzw
mad o3.xy, v2, c13, c13.zwzw
mad o5.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 256
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlhfljeihpfcjfiabgfkicehhpoipflneabaaaaaaheaeaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmaacaaaaeaaaabaalaaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaapaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
pccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaa
gfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
amaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaal
mccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
Vector 10 [_Control_ST]
Vector 11 [_Splat0_ST]
Vector 12 [_Splat1_ST]
Vector 13 [_Splat2_ST]
Vector 14 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 13 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[14], c[14].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 13 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_Control_ST]
Vector 10 [_Splat0_ST]
Vector 11 [_Splat1_ST]
Vector 12 [_Splat2_ST]
Vector 13 [_Splat3_ST]
"vs_3_0
; 13 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.zw, v2.xyxy, c10.xyxy, c10
mad o1.xy, v2, c9, c9.zwzw
mad o2.zw, v2.xyxy, c12.xyxy, c12
mad o2.xy, v2, c11, c11.zwzw
mad o3.xy, v2, c13, c13.zwzw
mad o5.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 256
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlhfljeihpfcjfiabgfkicehhpoipflneabaaaaaaheaeaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmaacaaaaeaaaabaalaaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaapaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
pccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaa
gfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
amaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaal
mccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[23] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[17].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[12];
DP4 R2.y, R1.wxyz, c[11];
DP4 R2.x, R1.wxyz, c[10];
DP4 R1.z, R0, c[15];
DP4 R1.y, R0, c[14];
DP4 R1.x, R0, c[13];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[5].xyz, R3, R2;
ADD result.texcoord[6].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[6].zw, R0;
MOV result.texcoord[4].z, R2.w;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R1.w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[22], c[22].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 39 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
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
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c17.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c23.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c12
dp4 r2.y, r1.wxyz, c11
dp4 r2.x, r1.wxyz, c10
dp4 r1.z, r0, c15
dp4 r1.y, r0, c14
dp4 r1.x, r0, c13
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c23.y
mul r1.y, r1, c8.x
add o6.xyz, r3, r2
mad o7.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o7.zw, r0
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r1.w
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
mad o3.xy, v2, c22, c22.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
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
eefiecedhjabkmbmfbckhebaaighhadenbcikpneabaaaaaaemahaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
giafaaaaeaaaabaafkabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacafaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
dcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaa
adaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaa
bcaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
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
aeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
ahaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaahaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
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
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o6.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o5.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 224 [unity_LightmapST]
Vector 240 [_Control_ST]
Vector 256 [_Splat0_ST]
Vector 272 [_Splat1_ST]
Vector 288 [_Splat2_ST]
Vector 304 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedjffccnffhflcbcfddndkggalemkjmjohabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabaaaaaaakgiocaaaaaaaaaaabaaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bcaaaaaakgiocaaaaaaaaaaabcaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o6.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o5.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 224 [unity_LightmapST]
Vector 240 [_Control_ST]
Vector 256 [_Splat0_ST]
Vector 272 [_Splat1_ST]
Vector 288 [_Splat2_ST]
Vector 304 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedjffccnffhflcbcfddndkggalemkjmjohabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabaaaaaaakgiocaaaaaaaaaaabaaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bcaaaaaakgiocaaaaaaaaaaabcaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
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
Vector 25 [_Control_ST]
Vector 26 [_Splat0_ST]
Vector 27 [_Splat1_ST]
Vector 28 [_Splat2_ST]
Vector 29 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 64 ALU
PARAM c[30] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..29] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[24].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[10];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[9];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[11];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[12];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[19];
DP4 R2.y, R4, c[18];
DP4 R2.x, R4, c[17];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[14];
MAD R1.xyz, R0.x, c[13], R1;
MAD R0.xyz, R0.z, c[15], R1;
MAD R1.xyz, R0.w, c[16], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[22];
DP4 R4.z, R0, c[21];
DP4 R4.y, R0, c[20];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[23];
ADD R2.xyz, R2, R4.yzww;
ADD R0.xyz, R2, R0;
ADD result.texcoord[5].xyz, R0, R1;
MOV result.texcoord[4].z, R3.x;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R4;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[26].xyxy, c[26];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[28].xyxy, c[28];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[27], c[27].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[29], c[29].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 64 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_4LightPosX0]
Vector 9 [unity_4LightPosY0]
Vector 10 [unity_4LightPosZ0]
Vector 11 [unity_4LightAtten0]
Vector 12 [unity_LightColor0]
Vector 13 [unity_LightColor1]
Vector 14 [unity_LightColor2]
Vector 15 [unity_LightColor3]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [unity_Scale]
Vector 24 [_Control_ST]
Vector 25 [_Splat0_ST]
Vector 26 [_Splat1_ST]
Vector 27 [_Splat2_ST]
Vector 28 [_Splat3_ST]
"vs_3_0
; 64 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c29, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c23.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c9
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c8
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c29.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c10
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c11
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c29.x
dp4 r2.z, r4, c18
dp4 r2.y, r4, c17
dp4 r2.x, r4, c16
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c29.y
mul r0, r0, r1
mul r1.xyz, r0.y, c13
mad r1.xyz, r0.x, c12, r1
mad r0.xyz, r0.z, c14, r1
mad r1.xyz, r0.w, c15, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c21
dp4 r4.z, r0, c20
dp4 r4.y, r0, c19
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c22
add r2.xyz, r2, r4.yzww
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov o5.z, r3.x
mov o5.y, r3.w
mov o5.x, r4
mad o1.zw, v2.xyxy, c25.xyxy, c25
mad o1.xy, v2, c24, c24.zwzw
mad o2.zw, v2.xyxy, c27.xyxy, c27
mad o2.xy, v2, c26, c26.zwzw
mad o3.xy, v2, c28, c28.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 240
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedemebapboihagcgjijgedfbcbikdkbhababaaaaaanmajaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbaaiaaaaeaaaabaaaeacaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaa
ogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaa
amaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
anaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
icaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaa
aaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaa
adaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaa
diaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaaj
pcaabaaaafaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaacaaaaaa
aaaaaaajpcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaa
aeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaacaaaaaakgakbaaa
aaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaa
egaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaa
acaaaaaaegaobaaaacaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaa
egaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
abaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
acaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaa
deaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaa
ahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaah
hccabaaaagaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [unity_Scale]
Vector 26 [_Control_ST]
Vector 27 [_Splat0_ST]
Vector 28 [_Splat1_ST]
Vector 29 [_Splat2_ST]
Vector 30 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 70 ALU
PARAM c[31] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..30] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[25].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[10];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[12];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[13];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[20];
DP4 R2.y, R4, c[19];
DP4 R2.x, R4, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[23];
DP4 R4.z, R0, c[22];
DP4 R4.y, R0, c[21];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R4.yzww;
ADD R4.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[5].xyz, R4.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
ADD result.texcoord[6].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[6].zw, R0;
MOV result.texcoord[4].z, R3.x;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R4;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[27].xyxy, c[27];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[30], c[30].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 70 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [unity_Scale]
Vector 26 [_Control_ST]
Vector 27 [_Splat0_ST]
Vector 28 [_Splat1_ST]
Vector 29 [_Splat2_ST]
Vector 30 [_Splat3_ST]
"vs_3_0
; 70 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c31, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c25.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c11
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c10
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c31.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c12
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c13
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c20
dp4 r2.y, r4, c19
dp4 r2.x, r4, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c23
dp4 r4.z, r0, c22
dp4 r4.y, r0, c21
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r4.yzww
add r4.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c31.z
add o6.xyz, r4.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mad o7.xy, r2.z, c9.zwzw, r1
mov o0, r0
mov o7.zw, r0
mov o5.z, r3.x
mov o5.y, r3.w
mov o5.x, r4
mad o1.zw, v2.xyxy, c27.xyxy, c27
mad o1.xy, v2, c26, c26.zwzw
mad o2.zw, v2.xyxy, c29.xyxy, c29
mad o2.xy, v2, c28, c28.zwzw
mad o3.xy, v2, c30, c30.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
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
eefiecedajgpdeklklofncccddeodilblffbaemiabaaaaaajmakaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
liaiaaaaeaaaabaacoacaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacahaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
dcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaa
adaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaa
bcaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
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
aeaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakicaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaadaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaa
adaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaadaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaabaaaaaa
egaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaa
aeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaakgakbaiaebaaaaaaadaaaaaa
egiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaa
agaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaa
adaaaaaakgakbaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
adaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaegaobaaaaeaaaaaaeeaaaaaf
pcaabaaaaeaaaaaaegaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaa
adaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaadaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaaeaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
adaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaa
agaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaadaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaahhccabaaaagaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaahaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaahaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [unity_Scale]
Vector 17 [_Control_ST]
Vector 18 [_Splat0_ST]
Vector 19 [_Splat1_ST]
Vector 20 [_Splat2_ST]
Vector 21 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[16].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R0.y, R3.w, R3.w;
DP4 R3.z, R1, c[14];
DP4 R3.y, R1, c[13];
DP4 R3.x, R1, c[12];
MAD R0.y, R0.x, R0.x, -R0;
MUL R1.xyz, R0.y, c[15];
ADD R2.xyz, R2, R3;
ADD result.texcoord[5].xyz, R2, R1;
MOV result.texcoord[4].z, R2.w;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[19], c[19].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[21], c[21].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 34 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_SHAr]
Vector 9 [unity_SHAg]
Vector 10 [unity_SHAb]
Vector 11 [unity_SHBr]
Vector 12 [unity_SHBg]
Vector 13 [unity_SHBb]
Vector 14 [unity_SHC]
Vector 15 [unity_Scale]
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c21.x
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
mul r0.y, r3.w, r3.w
dp4 r3.z, r1, c13
dp4 r3.y, r1, c12
dp4 r3.x, r1, c11
mad r0.y, r0.x, r0.x, -r0
mul r1.xyz, r0.y, c14
add r2.xyz, r2, r3
add o6.xyz, r2, r1
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r0
mad o1.zw, v2.xyxy, c17.xyxy, c17
mad o1.xy, v2, c16, c16.zwzw
mad o2.zw, v2.xyxy, c19.xyxy, c19
mad o2.xy, v2, c18, c18.zwzw
mad o3.xy, v2, c20, c20.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 240
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedaebkcdmhdhppgefjlifggjhjjfhjdalbabaaaaaaimagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcmaaeaaaaeaaaabaadaabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaa
ogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaa
amaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
anaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhccabaaaagaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
Vector 10 [_Control_ST]
Vector 11 [_Splat0_ST]
Vector 12 [_Splat1_ST]
Vector 13 [_Splat2_ST]
Vector 14 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 13 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[14], c[14].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 13 instructions, 0 R-regs
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
Vector 9 [_Control_ST]
Vector 10 [_Splat0_ST]
Vector 11 [_Splat1_ST]
Vector 12 [_Splat2_ST]
Vector 13 [_Splat3_ST]
"vs_3_0
; 13 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.zw, v2.xyxy, c10.xyxy, c10
mad o1.xy, v2, c9, c9.zwzw
mad o2.zw, v2.xyxy, c12.xyxy, c12
mad o2.xy, v2, c11, c11.zwzw
mad o3.xy, v2, c13, c13.zwzw
mad o5.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 256
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlhfljeihpfcjfiabgfkicehhpoipflneabaaaaaaheaeaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmaacaaaaeaaaabaalaaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaapaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
pccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaa
gfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
amaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaal
mccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
Vector 10 [_Control_ST]
Vector 11 [_Splat0_ST]
Vector 12 [_Splat1_ST]
Vector 13 [_Splat2_ST]
Vector 14 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 13 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[14], c[14].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 13 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
Vector 9 [_Control_ST]
Vector 10 [_Splat0_ST]
Vector 11 [_Splat1_ST]
Vector 12 [_Splat2_ST]
Vector 13 [_Splat3_ST]
"vs_3_0
; 13 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.zw, v2.xyxy, c10.xyxy, c10
mad o1.xy, v2, c9, c9.zwzw
mad o2.zw, v2.xyxy, c12.xyxy, c12
mad o2.xy, v2, c11, c11.zwzw
mad o3.xy, v2, c13, c13.zwzw
mad o5.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 256
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlhfljeihpfcjfiabgfkicehhpoipflneabaaaaaaheaeaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcmaacaaaaeaaaabaalaaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaapaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
pccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaa
gfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
amaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaal
mccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaa
agbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[23] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[17].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[12];
DP4 R2.y, R1.wxyz, c[11];
DP4 R2.x, R1.wxyz, c[10];
DP4 R1.z, R0, c[15];
DP4 R1.y, R0, c[14];
DP4 R1.x, R0, c[13];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[5].xyz, R3, R2;
ADD result.texcoord[6].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[6].zw, R0;
MOV result.texcoord[4].z, R2.w;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R1.w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[22], c[22].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 39 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
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
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c17.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c23.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c12
dp4 r2.y, r1.wxyz, c11
dp4 r2.x, r1.wxyz, c10
dp4 r1.z, r0, c15
dp4 r1.y, r0, c14
dp4 r1.x, r0, c13
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c23.y
mul r1.y, r1, c8.x
add o6.xyz, r3, r2
mad o7.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o7.zw, r0
mov o5.z, r2.w
mov o5.y, r3.w
mov o5.x, r1.w
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
mad o3.xy, v2, c22, c22.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
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
eefiecedhjabkmbmfbckhebaaighhadenbcikpneabaaaaaaemahaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
giafaaaaeaaaabaafkabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacafaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
dcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaa
adaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaa
bcaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
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
aeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
ahaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaahaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
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
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o6.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o5.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 224 [unity_LightmapST]
Vector 240 [_Control_ST]
Vector 256 [_Splat0_ST]
Vector 272 [_Splat1_ST]
Vector 288 [_Splat2_ST]
Vector 304 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedjffccnffhflcbcfddndkggalemkjmjohabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabaaaaaaakgiocaaaaaaaaaaabaaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bcaaaaaakgiocaaaaaaaaaaabcaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[5].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o6.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o5.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 320
Vector 224 [unity_LightmapST]
Vector 240 [_Control_ST]
Vector 256 [_Splat0_ST]
Vector 272 [_Splat1_ST]
Vector 288 [_Splat2_ST]
Vector 304 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedjffccnffhflcbcfddndkggalemkjmjohabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
beaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabaaaaaaakgiocaaaaaaaaaaabaaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabbaaaaaaogikcaaaaaaaaaaa
bbaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bcaaaaaakgiocaaaaaaaaaaabcaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaa
aaaaaaaaaoaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
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
Vector 25 [_Control_ST]
Vector 26 [_Splat0_ST]
Vector 27 [_Splat1_ST]
Vector 28 [_Splat2_ST]
Vector 29 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 64 ALU
PARAM c[30] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..29] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[24].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[10];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[9];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[11];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[12];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[19];
DP4 R2.y, R4, c[18];
DP4 R2.x, R4, c[17];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[14];
MAD R1.xyz, R0.x, c[13], R1;
MAD R0.xyz, R0.z, c[15], R1;
MAD R1.xyz, R0.w, c[16], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[22];
DP4 R4.z, R0, c[21];
DP4 R4.y, R0, c[20];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[23];
ADD R2.xyz, R2, R4.yzww;
ADD R0.xyz, R2, R0;
ADD result.texcoord[5].xyz, R0, R1;
MOV result.texcoord[4].z, R3.x;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R4;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[26].xyxy, c[26];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[28].xyxy, c[28];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[27], c[27].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[29], c[29].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 64 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_4LightPosX0]
Vector 9 [unity_4LightPosY0]
Vector 10 [unity_4LightPosZ0]
Vector 11 [unity_4LightAtten0]
Vector 12 [unity_LightColor0]
Vector 13 [unity_LightColor1]
Vector 14 [unity_LightColor2]
Vector 15 [unity_LightColor3]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [unity_Scale]
Vector 24 [_Control_ST]
Vector 25 [_Splat0_ST]
Vector 26 [_Splat1_ST]
Vector 27 [_Splat2_ST]
Vector 28 [_Splat3_ST]
"vs_3_0
; 64 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c29, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c23.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c9
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c8
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c29.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c10
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c11
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c29.x
dp4 r2.z, r4, c18
dp4 r2.y, r4, c17
dp4 r2.x, r4, c16
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c29.y
mul r0, r0, r1
mul r1.xyz, r0.y, c13
mad r1.xyz, r0.x, c12, r1
mad r0.xyz, r0.z, c14, r1
mad r1.xyz, r0.w, c15, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c21
dp4 r4.z, r0, c20
dp4 r4.y, r0, c19
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c22
add r2.xyz, r2, r4.yzww
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov o5.z, r3.x
mov o5.y, r3.w
mov o5.x, r4
mad o1.zw, v2.xyxy, c25.xyxy, c25
mad o1.xy, v2, c24, c24.zwzw
mad o2.zw, v2.xyxy, c27.xyxy, c27
mad o2.xy, v2, c26, c26.zwzw
mad o3.xy, v2, c28, c28.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 240
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedemebapboihagcgjijgedfbcbikdkbhababaaaaaanmajaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbaaiaaaaeaaaabaaaeacaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaa
ogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaa
amaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
anaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
hccabaaaafaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
icaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaa
aaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaa
adaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaa
diaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaaj
pcaabaaaafaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaacaaaaaa
aaaaaaajpcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaa
aeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaacaaaaaakgakbaaa
aaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaa
egaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaa
acaaaaaaegaobaaaacaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaa
egaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
abaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
acaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaa
deaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaa
ahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aiaaaaaakgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaah
hccabaaaagaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [unity_Scale]
Vector 26 [_Control_ST]
Vector 27 [_Splat0_ST]
Vector 28 [_Splat1_ST]
Vector 29 [_Splat2_ST]
Vector 30 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 70 ALU
PARAM c[31] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..30] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[25].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[10];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[12];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[13];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[20];
DP4 R2.y, R4, c[19];
DP4 R2.x, R4, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[23];
DP4 R4.z, R0, c[22];
DP4 R4.y, R0, c[21];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R4.yzww;
ADD R4.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[5].xyz, R4.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
ADD result.texcoord[6].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[6].zw, R0;
MOV result.texcoord[4].z, R3.x;
MOV result.texcoord[4].y, R3.w;
MOV result.texcoord[4].x, R4;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[27].xyxy, c[27];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[30], c[30].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 70 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [unity_Scale]
Vector 26 [_Control_ST]
Vector 27 [_Splat0_ST]
Vector 28 [_Splat1_ST]
Vector 29 [_Splat2_ST]
Vector 30 [_Splat3_ST]
"vs_3_0
; 70 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c31, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c25.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c11
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c10
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c31.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c12
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c13
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c20
dp4 r2.y, r4, c19
dp4 r2.x, r4, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c23
dp4 r4.z, r0, c22
dp4 r4.y, r0, c21
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r4.yzww
add r4.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c31.z
add o6.xyz, r4.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mad o7.xy, r2.z, c9.zwzw, r1
mov o0, r0
mov o7.zw, r0
mov o5.z, r3.x
mov o5.y, r3.w
mov o5.x, r4
mad o1.zw, v2.xyxy, c27.xyxy, c27
mad o1.xy, v2, c26, c26.zwzw
mad o2.zw, v2.xyxy, c29.xyxy, c29
mad o2.xy, v2, c28, c28.zwzw
mad o3.xy, v2, c30, c30.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
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
eefiecedajgpdeklklofncccddeodilblffbaemiabaaaaaajmakaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaaneaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
liaiaaaaeaaaabaacoacaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaad
hccabaaaagaaaaaagfaaaaadpccabaaaahaaaaaagiaaaaacahaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
dcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaa
ogikcaaaaaaaaaaabaaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaabbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaa
adaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaa
bcaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
acaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
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
aeaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakicaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaia
ebaaaaaaabaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaadaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaa
adaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaadaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaabaaaaaa
egaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaa
aeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaakgakbaiaebaaaaaaadaaaaaa
egiocaaaacaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaa
agaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaa
adaaaaaakgakbaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
adaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaegaobaaaaeaaaaaaeeaaaaaf
pcaabaaaaeaaaaaaegaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaa
adaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaadaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaaeaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
adaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaabaaaaaa
egiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaa
agaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaadaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaahhccabaaaagaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaahaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaahaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
"3.0-!!ARBfp1.0
# 54 ALU, 6 TEX
PARAM c[12] = { program.local[0..8],
		{ 0, 0.75341797, 0.24682617, 2 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R3.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R1.xyz, R0.x, R1;
TEX R2.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R0.z, R2;
ADD R1.xyz, R1, R3;
ADD R1.xyz, R1, R2;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R1.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R1;
MUL R0.xyz, R0, c[6];
MUL R1.xyz, R0, c[7].w;
TEX R0, R2, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
MUL R3.y, R0.w, R3.x;
MUL R4.xy, R3, c[9].yzzw;
DP3 R1.w, fragment.texcoord[4], c[4];
MUL R2.xyz, R1, c[5];
MAX R0.w, R1, c[9].x;
MUL R2.xyz, R0.w, R2;
MUL R3.xyz, R1, fragment.texcoord[5];
ADD R0.w, R4.x, R4.y;
MUL R0.xyz, R0, R0.w;
MOV R0.w, c[8].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R0, c[7].x;
MAD R2.xyz, R2, c[9].w, R3;
MAD R0.xyz, R0, R0.w, R2;
POW R0.x, R0.x, c[10].x;
POW R0.z, R0.z, c[10].x;
POW R0.y, R0.y, c[10].x;
MUL R0.xyz, R0, c[10].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[10].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[10].w;
RCP R1.z, R1.x;
SLT R1.y, c[9].x, R1.x;
MOV R0.w, c[11].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[9].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[9].x, R0;
POW result.color.x, R0.x, c[11].y;
POW result.color.y, R0.y, c[11].y;
POW result.color.z, R0.z, c[11].y;
MOV result.color.w, R0;
END
# 54 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
"ps_3_0
; 64 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
def c9, 0.75341797, 0.24682617, 0.00000000, 2.00000000
def c10, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c11, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
mul r3.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r1.xyz, r0.x, r1
texld r2.xyz, v1.zwzw, s3
mul r2.xyz, r0.z, r2
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r1, r2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mul_pp r1.xyz, r0, c6
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
mul_pp r1.xyz, r1, c7.w
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
dp3_pp r1.w, v4, c4
mul_pp r4.xy, r3, c9
max_pp r0.w, r1, c9.z
mul_pp r2.xyz, r1, c5
mul_pp r2.xyz, r0.w, r2
mul_pp r3.xyz, r1, v5
add_pp r0.w, r4.x, r4.y
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c7.x
mul_pp r0.xyz, r1, r0
mad_pp r2.xyz, r2, c9.w, r3
mul_pp r0.w, c8.x, r0
mad_pp r1.xyz, r0, r0.w, r2
pow r0, r1.x, c10.x
pow r2, r1.y, c10.x
mov r1.x, r0
pow r0, r1.z, c10.x
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c10.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c10.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c10
rcp r1.y, r0.w
cmp r1.x, -r0.w, c11, c11.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c9.z, r0
pow r0, r1.x, c11.z
mov oC0.x, r0
pow r0, r1.y, c11.z
pow r2, r1.z, c11.z
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
ConstBuffer "$Globals" 240
Matrix 96 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedjcagnkphlbcakkcojjcnimoplcdmccheabaaaaaabiajaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaahaaaaeaaaaaaapiabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaaeaahabaaa
afaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaa
afaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaa
agaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaa
ahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaa
aiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaa
agaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaa
ahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaa
aiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaaaaaaaaaaagaaaaaa
diaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaaaaaaaaaaahaaaaaa
diaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaaaaaaaaaaaiaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaa
diaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
ccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaaapaaaaakicaabaaa
aaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgafbaaa
adaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaacaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaakgakbaaaadaaaaaa
egacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
adaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaabaaaaaa
pgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegbcbaaaagaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaa
afaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaaakiacaaaaaaaaaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaacpaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
cplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdo
klkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaa
aaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
aaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaa
egaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaa
bjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"3.0-!!ARBfp1.0
# 52 ALU, 7 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 8, 0.75341797, 0.24682617 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[6].x;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R0.xyz, R2.x, R0;
MUL R1.xyz, R2.y, R1;
ADD R1.xyz, R0, R1;
MUL R3.xyz, fragment.texcoord[3].z, c[2];
MAD R0.xyz, fragment.texcoord[3].y, c[1], R3;
TEX R3.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R2.z, R3;
ADD R2.xyz, R1, R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R0;
TEX R0, R0, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
MUL R3.y, R0.w, R3.x;
TEX R1.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R2.w, R1;
ADD R1.xyz, R2, R1;
MUL R3.xy, R3, c[7].zwzw;
ADD R0.w, R3.x, R3.y;
MUL R1.xyz, R1, c[4];
MUL R1.xyz, R1, c[5].w;
MUL R0.xyz, R0, R0.w;
MUL R2.xyz, R1, R0;
TEX R0, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R0.w, R0;
MUL R1.w, R1, c[5].x;
MUL R0.xyz, R0, R1;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, c[7].y, R2;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[8].w;
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[9].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].y;
POW result.color.y, R0.y, c[9].y;
POW result.color.z, R0.z, c[9].y;
MOV result.color.w, R0;
END
# 52 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"ps_3_0
; 61 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 0.75341797, 0.24682617, 8.00000000, 0.45454544
def c8, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c9, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
mov_pp r1.w, c5.x
texld r2, v0, s0
texld r0.xyz, v0.zwzw, s1
texld r1.xyz, v1, s2
mul r0.xyz, r2.x, r0
mul r1.xyz, r2.y, r1
add_pp r1.xyz, r0, r1
mul r3.xyz, v3.z, c2
mad r0.xyz, v3.y, c1, r3
texld r3.xyz, v1.zwzw, s3
mul r2.xyz, r2.z, r3
add_pp r2.xyz, r1, r2
mad r0.xyz, v3.x, c0, r0
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
texld r1.xyz, v2, s4
mul r1.xyz, r2.w, r1
add_pp r1.xyz, r2, r1
mul_pp r3.xy, r3, c7
add_pp r0.w, r3.x, r3.y
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, c5.w
mul_pp r0.xyz, r0, r0.w
mul_pp r2.xyz, r1, r0
texld r0, v4, s6
mul_pp r1.w, c6.x, r1
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r2, r1.w
mul_pp r0.xyz, r0, r1
mad_pp r1.xyz, r0, c7.z, r2
pow r0, r1.x, c7.w
pow r2, r1.y, c7.w
mov r1.x, r0
pow r0, r1.z, c7.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
rcp r1.y, r0.w
cmp r1.x, -r0.w, c9, c9.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.w, r0
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
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedeifjmhdfljkplfhjflicjlpbpddcnndjabaaaaaamaaiaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckaahaaaa
eaaaaaaaoiabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaadaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaa
aaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaa
abeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaah
pcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmamea
mnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"3.0-!!ARBfp1.0
# 52 ALU, 7 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 8, 0.75341797, 0.24682617 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[6].x;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R0.xyz, R2.x, R0;
MUL R1.xyz, R2.y, R1;
ADD R1.xyz, R0, R1;
MUL R3.xyz, fragment.texcoord[3].z, c[2];
MAD R0.xyz, fragment.texcoord[3].y, c[1], R3;
TEX R3.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R2.z, R3;
ADD R2.xyz, R1, R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R0;
TEX R0, R0, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
MUL R3.y, R0.w, R3.x;
TEX R1.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R2.w, R1;
ADD R1.xyz, R2, R1;
MUL R3.xy, R3, c[7].zwzw;
ADD R0.w, R3.x, R3.y;
MUL R1.xyz, R1, c[4];
MUL R1.xyz, R1, c[5].w;
MUL R0.xyz, R0, R0.w;
MUL R2.xyz, R1, R0;
TEX R0, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R0.w, R0;
MUL R1.w, R1, c[5].x;
MUL R0.xyz, R0, R1;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, c[7].y, R2;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[8].w;
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[9].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].y;
POW result.color.y, R0.y, c[9].y;
POW result.color.z, R0.z, c[9].y;
MOV result.color.w, R0;
END
# 52 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"ps_3_0
; 61 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 0.75341797, 0.24682617, 8.00000000, 0.45454544
def c8, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c9, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
mov_pp r1.w, c5.x
texld r2, v0, s0
texld r0.xyz, v0.zwzw, s1
texld r1.xyz, v1, s2
mul r0.xyz, r2.x, r0
mul r1.xyz, r2.y, r1
add_pp r1.xyz, r0, r1
mul r3.xyz, v3.z, c2
mad r0.xyz, v3.y, c1, r3
texld r3.xyz, v1.zwzw, s3
mul r2.xyz, r2.z, r3
add_pp r2.xyz, r1, r2
mad r0.xyz, v3.x, c0, r0
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
texld r1.xyz, v2, s4
mul r1.xyz, r2.w, r1
add_pp r1.xyz, r2, r1
mul_pp r3.xy, r3, c7
add_pp r0.w, r3.x, r3.y
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, c5.w
mul_pp r0.xyz, r0, r0.w
mul_pp r2.xyz, r1, r0
texld r0, v4, s6
mul_pp r1.w, c6.x, r1
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r2, r1.w
mul_pp r0.xyz, r0, r1
mad_pp r1.xyz, r0, c7.z, r2
pow r0, r1.x, c7.w
pow r2, r1.y, c7.w
mov r1.x, r0
pow r0, r1.z, c7.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
rcp r1.y, r0.w
cmp r1.x, -r0.w, c9, c9.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.w, r0
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
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedeifjmhdfljkplfhjflicjlpbpddcnndjabaaaaaamaaiaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckaahaaaa
eaaaaaaaoiabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaadaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaa
aaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaa
abeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaah
pcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmamea
mnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
"3.0-!!ARBfp1.0
# 56 ALU, 7 TEX
PARAM c[12] = { program.local[0..8],
		{ 0, 0.75341797, 0.24682617, 2 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R3.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R2.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R0.x, R1;
ADD R0.xyz, R0, R2;
ADD R1.xyz, R0, R3;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R1.xyz, R0, c[6];
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R2, texture[5], CUBE;
MUL R1.xyz, R1, c[7].w;
MUL R3.x, R0.w, R0.w;
MUL R3.y, R0.w, R3.x;
DP3 R0.w, fragment.texcoord[4], c[4];
MUL R2.xyz, R1, c[5];
TXP R4.x, fragment.texcoord[6], texture[6], 2D;
MAX R0.w, R0, c[9].x;
MUL R0.w, R0, R4.x;
MUL R4.xy, R3, c[9].yzzw;
MUL R2.xyz, R0.w, R2;
MUL R3.xyz, R1, fragment.texcoord[5];
ADD R0.w, R4.x, R4.y;
MUL R0.xyz, R0, R0.w;
MOV R0.w, c[8].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R0, c[7].x;
MAD R2.xyz, R2, c[9].w, R3;
MAD R0.xyz, R0, R0.w, R2;
POW R0.x, R0.x, c[10].x;
POW R0.z, R0.z, c[10].x;
POW R0.y, R0.y, c[10].x;
MUL R0.xyz, R0, c[10].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[10].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[10].w;
RCP R1.z, R1.x;
SLT R1.y, c[9].x, R1.x;
MOV R0.w, c[11].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[9].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[9].x, R0;
POW result.color.x, R0.x, c[11].y;
POW result.color.y, R0.y, c[11].y;
POW result.color.z, R0.z, c[11].y;
MOV result.color.w, R0;
END
# 56 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
"ps_3_0
; 65 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c9, 0.75341797, 0.24682617, 0.00000000, 2.00000000
def c10, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c11, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6
texld r0, v0, s0
texld r1.xyz, v1.zwzw, s3
mul r3.xyz, r0.z, r1
texld r2.xyz, v1, s2
mul r2.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r0.xyz, r0.x, r1
add_pp r0.xyz, r0, r2
add_pp r1.xyz, r0, r3
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r1.xyz, r1, r0
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
mul_pp r1.xyz, r1, c6
mul_pp r1.xyz, r1, c7.w
dp3_pp r0.w, v4, c4
mul_pp r2.xyz, r1, c5
texldp r4.x, v6, s6
max_pp r0.w, r0, c9.z
mul_pp r0.w, r0, r4.x
mul_pp r4.xy, r3, c9
mul_pp r2.xyz, r0.w, r2
mul_pp r3.xyz, r1, v5
add_pp r0.w, r4.x, r4.y
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c7.x
mul_pp r0.xyz, r1, r0
mad_pp r2.xyz, r2, c9.w, r3
mul_pp r0.w, c8.x, r0
mad_pp r1.xyz, r0, r0.w, r2
pow r0, r1.x, c10.x
pow r2, r1.y, c10.x
mov r1.x, r0
pow r0, r1.z, c10.x
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c10.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c10.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c10
rcp r1.y, r0.w
cmp r1.x, -r0.w, c11, c11.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c9.z, r0
pow r0, r1.x, c11.z
mov oC0.x, r0
pow r0, r1.y, c11.z
pow r2, r1.z, c11.z
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_DiffCubeIBL] CUBE 6
SetTexture 6 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 304
Matrix 160 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
Vector 144 [UniformOcclusion] 2
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedagkmgbndldidapjlljdedcikglfefgnmabaaaaaajiajaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefceiaiaaaaeaaaaaaabcacaaaafjaaaaaeegiocaaa
aaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaa
agaaaaaagcbaaaadlcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaahaaaaaapgbpbaaaahaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaagaaaaaaaagabaaa
aaaaaaaabaaaaaaiccaabaaaaaaaaaaaegbcbaaaafaaaaaaegiccaaaabaaaaaa
aaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
apaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaaagaabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaaagajbaaaacaaaaaafgafbaaa
adaaaaaadcaaaaajocaabaaaaaaaaaaaagaabaaaadaaaaaaagajbaaaabaaaaaa
fgaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
adaaaaaaaagabaaaaeaaaaaadcaaaaajocaabaaaaaaaaaaakgakbaaaadaaaaaa
agajbaaaabaaaaaafgaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
adaaaaaaeghobaaaaeaaaaaaaagabaaaafaaaaaadcaaaaajocaabaaaaaaaaaaa
pgapbaaaadaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaa
abaaaaaajgahbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaajgahbaaaaaaaaaaaegbcbaaaagaaaaaadcaaaaajhcaabaaaabaaaaaa
egacbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaibcaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaamaaaaaadiaaaaaibcaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaibcaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaa
acaaaaaaeghobaaaafaaaaaaaagabaaaagaaaaaadiaaaaahbcaabaaaadaaaaaa
dkaabaaaacaaaaaadkaabaaaacaaaaaadiaaaaahccaabaaaadaaaaaadkaabaaa
acaaaaaaakaabaaaadaaaaaaapaaaaakbcaabaaaaaaaaaaaaceaaaaalhnbeadp
celjhmdoaaaaaaaaaaaaaaaaegaabaaaadaaaaaadiaaaaahhcaabaaaacaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaajgahbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaaakiacaaaaaaaaaaaajaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaacpaaaaafhcaabaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
cplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdo
klkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaa
aaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
aaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaa
egaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmameamnmmameaaaaaaaaa
bjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 58 ALU, 8 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 8, 2, 0.45454544 },
		{ 0.75341797, 0.24682617, 0.16666667, 255 },
		{ 0.0039215689, 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
ADD R1.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R0, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R1.xyz, R1, R2;
MUL R3.y, R0.w, R3.x;
MUL R2.xy, R3, c[8];
ADD R0.w, R2.x, R2.y;
MUL R1.xyz, R1, c[4];
MUL R1.xyz, R1, c[5].w;
MUL R0.xyz, R0, R0.w;
MOV R1.w, c[6].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R1, c[5].x;
MUL R2.xyz, R0, R0.w;
TEX R0, fragment.texcoord[4], texture[7], 2D;
MUL R3.xyz, R0.w, R0;
TXP R4.x, fragment.texcoord[5], texture[6], 2D;
MUL R0.xyz, R0, R4.x;
MUL R3.xyz, R3, c[7].y;
MUL R0.xyz, R0, c[7].z;
MUL R4.xyz, R3, R4.x;
MIN R0.xyz, R3, R0;
MAX R0.xyz, R0, R4;
MAD R0.xyz, R1, R0, R2;
POW R0.x, R0.x, c[7].w;
POW R0.z, R0.z, c[7].w;
POW R0.y, R0.y, c[7].w;
MUL R0.xyz, R0, c[8].z;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8];
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[9];
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[9].y;
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].z;
POW result.color.y, R0.y, c[9].z;
POW result.color.z, R0.z, c[9].z;
MOV result.color.w, R0;
END
# 58 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 66 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 2.00000000, 0.75341797, 0.24682617
def c8, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c9, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
mul r2.xyz, v3.z, c2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
add_pp r1.xyz, r1, r0
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r1.xyz, r1, r2
mul_pp r2.xy, r3, c7.zwzw
add_pp r1.w, r2.x, r2.y
mul_pp r1.xyz, r1, c4
mov_pp r0.w, c5.x
mul_pp r0.xyz, r0, r1.w
mul_pp r1.xyz, r1, c5.w
mul_pp r0.xyz, r1, r0
mul_pp r0.w, c6.x, r0
mul_pp r2.xyz, r0, r0.w
texld r0, v4, s7
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v5, s6
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c7.x
mul_pp r0.xyz, r0, c7.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp r1.xyz, r1, r0, r2
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
cmp r1.x, -r0.w, c9, c9.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c9.x, r0
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
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_DiffCubeIBL] CUBE 6
SetTexture 6 [_ShadowMapTexture] 2D 0
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 320
Matrix 160 [SkyMatrix]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
Vector 144 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecednajjgaoapmpjfmoffojbljjbompimhmoabaaaaaammajaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeaiaaaaeaaaaaaacfacaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaamaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaagaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaafaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaah
ocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaacaaaaaafgaobaaa
acaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaacaaaaaa
egacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoido
aaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaa
deaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadl
dbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaak
bcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaa
abaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaa
ddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaa
aaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 58 ALU, 8 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 8, 2, 0.45454544 },
		{ 0.75341797, 0.24682617, 0.16666667, 255 },
		{ 0.0039215689, 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
ADD R1.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R0, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R1.xyz, R1, R2;
MUL R3.y, R0.w, R3.x;
MUL R2.xy, R3, c[8];
ADD R0.w, R2.x, R2.y;
MUL R1.xyz, R1, c[4];
MUL R1.xyz, R1, c[5].w;
MUL R0.xyz, R0, R0.w;
MOV R1.w, c[6].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R1, c[5].x;
MUL R2.xyz, R0, R0.w;
TEX R0, fragment.texcoord[4], texture[7], 2D;
MUL R3.xyz, R0.w, R0;
TXP R4.x, fragment.texcoord[5], texture[6], 2D;
MUL R0.xyz, R0, R4.x;
MUL R3.xyz, R3, c[7].y;
MUL R0.xyz, R0, c[7].z;
MUL R4.xyz, R3, R4.x;
MIN R0.xyz, R3, R0;
MAX R0.xyz, R0, R4;
MAD R0.xyz, R1, R0, R2;
POW R0.x, R0.x, c[7].w;
POW R0.z, R0.z, c[7].w;
POW R0.y, R0.y, c[7].w;
MUL R0.xyz, R0, c[8].z;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8];
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[9];
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[9].y;
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].z;
POW result.color.y, R0.y, c[9].z;
POW result.color.z, R0.z, c[9].z;
MOV result.color.w, R0;
END
# 58 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 66 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 2.00000000, 0.75341797, 0.24682617
def c8, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c9, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
mul r2.xyz, v3.z, c2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
add_pp r1.xyz, r1, r0
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r1.xyz, r1, r2
mul_pp r2.xy, r3, c7.zwzw
add_pp r1.w, r2.x, r2.y
mul_pp r1.xyz, r1, c4
mov_pp r0.w, c5.x
mul_pp r0.xyz, r0, r1.w
mul_pp r1.xyz, r1, c5.w
mul_pp r0.xyz, r1, r0
mul_pp r0.w, c6.x, r0
mul_pp r2.xyz, r0, r0.w
texld r0, v4, s7
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v5, s6
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c7.x
mul_pp r0.xyz, r0, c7.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp r1.xyz, r1, r0, r2
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
cmp r1.x, -r0.w, c9, c9.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c9.x, r0
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
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_DiffCubeIBL] CUBE 6
SetTexture 6 [_ShadowMapTexture] 2D 0
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 320
Matrix 160 [SkyMatrix]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
Vector 144 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecednajjgaoapmpjfmoffojbljjbompimhmoabaaaaaammajaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeaiaaaaeaaaaaaacfacaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaamaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaagaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaafaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaah
ocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaacaaaaaafgaobaaa
acaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaacaaaaaa
egacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoido
aaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaa
deaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadl
dbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaak
bcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaa
abaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaa
ddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaa
aaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
"3.0-!!ARBfp1.0
# 41 ALU, 6 TEX
PARAM c[11] = { program.local[0..8],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, c[6];
MUL R1.xyz, R0, c[7].w;
MUL R0.xyz, fragment.texcoord[3].z, c[2];
DP3 R0.w, fragment.texcoord[4], c[4];
MAD R0.xyz, fragment.texcoord[3].y, c[1], R0;
MUL R2.xyz, R1, c[5];
MAX R0.w, R0, c[9].z;
MUL R3.xyz, R1, fragment.texcoord[5];
MUL R2.xyz, R0.w, R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R0;
TEX R0, R0, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MOV R0.w, c[8].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R0, c[7].x;
MAD R2.xyz, R2, c[9].w, R3;
MAD R0.xyz, R0, R0.w, R2;
MUL R0.xyz, R0, c[10].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[10].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[9].x;
SLT R1.x, c[9].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[9].z, c[9];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[9].z, R0;
END
# 41 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
"ps_3_0
; 35 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
def c9, 0.00000000, 2.00000000, 0.16666667, 255.00000000
def c10, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c6
mul_pp r1.xyz, r0, c7.w
mul r0.xyz, v3.z, c2
dp3_pp r0.w, v4, c4
mad r0.xyz, v3.y, c1, r0
mul_pp r2.xyz, r1, c5
max_pp r0.w, r0, c9.x
mul_pp r2.xyz, r0.w, r2
mul_pp r3.xyz, r1, v5
mad r0.xyz, v3.x, c0, r0
texld r0, r0, s5
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, r0
mov_pp r0.w, c7.x
mul_pp r0.x, c8, r0.w
mad_pp r2.xyz, r2, c9.y, r3
mad_pp r0.xyz, r1, r0.x, r2
mul r0.xyz, r0, c9.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c9
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c10.x
cmp r1.x, -r0.w, c10.y, c10.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c9.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
ConstBuffer "$Globals" 240
Matrix 96 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedkoocmjjafonhpplpebnlbllakegnfcclabaaaaaamaahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefciiagaaaaeaaaaaaakcabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaaeaahabaaa
afaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaa
afaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaafgafbaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
kgakbaaaacaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaaaaaaaaapgapbaaaacaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
diaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegbcbaaaagaaaaaabaaaaaai
icaabaaaaaaaaaaaegbcbaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaa
egacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaibcaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaibcaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaa
acaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaaakiacaaaaaaaaaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaah
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
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"3.0-!!ARBfp1.0
# 39 ALU, 7 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 8 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R3.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R2.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R0.x, R1;
ADD R0.xyz, R0, R2;
ADD R1.xyz, R0, R3;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R1, R2, texture[5], CUBE;
MUL R2.xyz, R1, R1.w;
MUL R0.xyz, R0, c[4];
MUL R1.xyz, R0, c[5].w;
TEX R0, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R0.w, R0;
MOV R1.w, c[6].x;
MUL R0.xyz, R0, R1;
MUL R2.xyz, R1, R2;
MUL R1.w, R1, c[5].x;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, c[7].w, R2;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 39 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"ps_3_0
; 32 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 8.00000000, 0.16666667, 255.00000000, 0.00392157
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
texld r0, v0, s0
texld r1.xyz, v1.zwzw, s3
mul r3.xyz, r0.z, r1
texld r2.xyz, v1, s2
mul r2.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r0.xyz, r0.x, r1
add_pp r0.xyz, r0, r2
add_pp r1.xyz, r0, r3
mul r2.xyz, v3.z, c2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mad r2.xyz, v3.y, c1, r2
mad r2.xyz, v3.x, c0, r2
texld r1, r2, s5
mul_pp r2.xyz, r1, r1.w
mul_pp r0.xyz, r0, c4
mul_pp r1.xyz, r0, c5.w
texld r0, v4, s6
mul_pp r0.xyz, r0.w, r0
mov_pp r1.w, c5.x
mul_pp r0.xyz, r0, r1
mul_pp r2.xyz, r1, r2
mul_pp r1.w, c6.x, r1
mul_pp r2.xyz, r2, r1.w
mad_pp r0.xyz, r0, c7.x, r2
mul r0.xyz, r0, c7.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7
cmp r1.x, -r0.w, c8, c8.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c8.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedginphimjlfhkofmidhcecmcfcjpodfleabaaaaaagiahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceiagaaaa
eaaaaaaajcabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaadaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdo
aaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaa
decaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"3.0-!!ARBfp1.0
# 39 ALU, 7 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 8 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R3.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R2.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R0.x, R1;
ADD R0.xyz, R0, R2;
ADD R1.xyz, R0, R3;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R1, R2, texture[5], CUBE;
MUL R2.xyz, R1, R1.w;
MUL R0.xyz, R0, c[4];
MUL R1.xyz, R0, c[5].w;
TEX R0, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R0.w, R0;
MOV R1.w, c[6].x;
MUL R0.xyz, R0, R1;
MUL R2.xyz, R1, R2;
MUL R1.w, R1, c[5].x;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, c[7].w, R2;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 39 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
"ps_3_0
; 32 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 8.00000000, 0.16666667, 255.00000000, 0.00392157
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
texld r0, v0, s0
texld r1.xyz, v1.zwzw, s3
mul r3.xyz, r0.z, r1
texld r2.xyz, v1, s2
mul r2.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r0.xyz, r0.x, r1
add_pp r0.xyz, r0, r2
add_pp r1.xyz, r0, r3
mul r2.xyz, v3.z, c2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mad r2.xyz, v3.y, c1, r2
mad r2.xyz, v3.x, c0, r2
texld r1, r2, s5
mul_pp r2.xyz, r1, r1.w
mul_pp r0.xyz, r0, c4
mul_pp r1.xyz, r0, c5.w
texld r0, v4, s6
mul_pp r0.xyz, r0.w, r0
mov_pp r1.w, c5.x
mul_pp r0.xyz, r0, r1
mul_pp r2.xyz, r1, r2
mul_pp r1.w, c6.x, r1
mul_pp r2.xyz, r2, r1.w
mad_pp r0.xyz, r0, c7.x, r2
mul r0.xyz, r0, c7.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7
cmp r1.x, -r0.w, c8, c8.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c8.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [unity_Lightmap] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedginphimjlfhkofmidhcecmcfcjpodfleabaaaaaagiahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceiagaaaa
eaaaaaaajcabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaadaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdo
aaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaa
decaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
"3.0-!!ARBfp1.0
# 43 ALU, 7 TEX
PARAM c[11] = { program.local[0..8],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
ADD R0.xyz, R3, R0;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, c[6];
MUL R1.xyz, R0, c[7].w;
MUL R0.xyz, fragment.texcoord[3].z, c[2];
MAD R0.xyz, fragment.texcoord[3].y, c[1], R0;
DP3 R0.w, fragment.texcoord[4], c[4];
MUL R2.xyz, R1, c[5];
TXP R3.x, fragment.texcoord[6], texture[6], 2D;
MAX R0.w, R0, c[9].z;
MUL R0.w, R0, R3.x;
MUL R3.xyz, R1, fragment.texcoord[5];
MUL R2.xyz, R0.w, R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R0;
TEX R0, R0, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MOV R0.w, c[8].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R0, c[7].x;
MAD R2.xyz, R2, c[9].w, R3;
MAD R0.xyz, R0, R0.w, R2;
MUL R0.xyz, R0, c[10].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[10].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[9].x;
SLT R1.x, c[9].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[9].z, c[9];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[9].z, R0;
END
# 43 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_Color]
Vector 7 [ExposureIBL]
Vector 8 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
"ps_3_0
; 36 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c9, 0.00000000, 2.00000000, 0.16666667, 255.00000000
def c10, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
add_pp r0.xyz, r3, r0
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c6
mul_pp r1.xyz, r0, c7.w
mul r0.xyz, v3.z, c2
mad r0.xyz, v3.y, c1, r0
dp3_pp r0.w, v4, c4
mul_pp r2.xyz, r1, c5
texldp r3.x, v6, s6
max_pp r0.w, r0, c9.x
mul_pp r0.w, r0, r3.x
mul_pp r2.xyz, r0.w, r2
mul_pp r3.xyz, r1, v5
mad r0.xyz, v3.x, c0, r0
texld r0, r0, s5
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, r0
mov_pp r0.w, c7.x
mul_pp r0.x, c8, r0.w
mad_pp r2.xyz, r2, c9.y, r3
mad_pp r0.xyz, r1, r0.x, r2
mul r0.xyz, r0, c9.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c9
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c10.x
cmp r1.x, -r0.w, c10.y, c10.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c9.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_DiffCubeIBL] CUBE 6
SetTexture 6 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 304
Matrix 160 [SkyMatrix]
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
Vector 144 [UniformOcclusion] 2
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
"ps_4_0
eefiecedeldcmglgmdjeblgbifkfnkemlinggfapabaaaaaaeaaiaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaahaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcpaagaaaaeaaaaaaalmabaaaafjaaaaaeegiocaaa
aaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaa
agaaaaaagcbaaaadlcbabaaaahaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaahaaaaaapgbpbaaaahaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaagaaaaaaaagabaaa
aaaaaaaabaaaaaaiccaabaaaaaaaaaaaegbcbaaaafaaaaaaegiccaaaabaaaaaa
aaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
apaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaaagaabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaaagajbaaaacaaaaaafgafbaaa
adaaaaaadcaaaaajocaabaaaaaaaaaaaagaabaaaadaaaaaaagajbaaaabaaaaaa
fgaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
adaaaaaaaagabaaaaeaaaaaadcaaaaajocaabaaaaaaaaaaakgakbaaaadaaaaaa
agajbaaaabaaaaaafgaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
adaaaaaaeghobaaaaeaaaaaaaagabaaaafaaaaaadcaaaaajocaabaaaaaaaaaaa
pgapbaaaadaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaahaaaaaadiaaaaaiocaabaaa
aaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaa
abaaaaaajgahbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaajgahbaaaaaaaaaaaegbcbaaaagaaaaaadcaaaaajhcaabaaaabaaaaaa
egacbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaibcaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaa
acaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaaamaaaaaadiaaaaaibcaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaa
adaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadiaaaaaibcaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaadaaaaaa
akbabaaaaeaaaaaaakiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegacbaaa
acaaaaaaeghobaaaafaaaaaaaagabaaaagaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaajgahbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaaakiacaaaaaaaaaaaajaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaah
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
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 45 ALU, 8 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 8 },
		{ 2, 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R3.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R1.xyz, R0.x, R1;
TEX R2.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R0.z, R2;
ADD R1.xyz, R1, R3;
ADD R1.xyz, R1, R2;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R1.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R1;
MUL R0.xyz, R0, c[4];
MUL R1.xyz, R0, c[5].w;
TEX R0, R2, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MOV R1.w, c[6].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R1, c[5].x;
MUL R2.xyz, R0, R0.w;
TEX R0, fragment.texcoord[4], texture[7], 2D;
MUL R3.xyz, R0.w, R0;
TXP R4.x, fragment.texcoord[5], texture[6], 2D;
MUL R0.xyz, R0, R4.x;
MUL R3.xyz, R3, c[7].w;
MUL R0.xyz, R0, c[8].x;
MUL R4.xyz, R3, R4.x;
MIN R0.xyz, R3, R0;
MAX R0.xyz, R0, R4;
MAD R0.xyz, R1, R0, R2;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 45 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 37 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 2.00000000, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r0, v0, s0
texld r2.xyz, v1, s2
mul r3.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r1.xyz, r0.x, r1
texld r2.xyz, v1.zwzw, s3
mul r2.xyz, r0.z, r2
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r1, r2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mul_pp r1.xyz, r0, c4
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r1.xyz, r1, c5.w
mul_pp r2.xyz, r0, r0.w
mov_pp r1.w, c5.x
mul_pp r2.xyz, r1, r2
mul_pp r0.x, c6, r1.w
mul_pp r2.xyz, r2, r0.x
texld r0, v4, s7
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v5, s6
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c7.x
mul_pp r0.xyz, r0, c7.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp r0.xyz, r1, r0, r2
mul r0.xyz, r0, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
cmp r1.x, -r0.w, c8.y, c8.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c8.y, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_DiffCubeIBL] CUBE 6
SetTexture 6 [_ShadowMapTexture] 2D 0
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 320
Matrix 160 [SkyMatrix]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
Vector 144 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedjdfnpjimpkebfoneenjhapfddaohpmhpabaaaaaaheaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdmahaaaaeaaaaaaampabaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaamaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaagaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaafaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaah
ocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaacaaaaaafgaobaaa
acaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaacaaaaaa
egacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
klkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaa
abeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaa
abaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaa
egaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 45 ALU, 8 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 8 },
		{ 2, 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R3.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R1.xyz, R0.x, R1;
TEX R2.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R0.z, R2;
ADD R1.xyz, R1, R3;
ADD R1.xyz, R1, R2;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R1.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R1;
MUL R0.xyz, R0, c[4];
MUL R1.xyz, R0, c[5].w;
TEX R0, R2, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MOV R1.w, c[6].x;
MUL R0.xyz, R1, R0;
MUL R0.w, R1, c[5].x;
MUL R2.xyz, R0, R0.w;
TEX R0, fragment.texcoord[4], texture[7], 2D;
MUL R3.xyz, R0.w, R0;
TXP R4.x, fragment.texcoord[5], texture[6], 2D;
MUL R0.xyz, R0, R4.x;
MUL R3.xyz, R3, c[7].w;
MUL R0.xyz, R0, c[8].x;
MUL R4.xyz, R3, R4.x;
MIN R0.xyz, R3, R0;
MAX R0.xyz, R0, R4;
MAD R0.xyz, R1, R0, R2;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.x, R1;
RCP R1.y, R0.w;
CMP R1.x, -R1, c[7].z, c[7].y;
MUL_SAT R0.xyz, R0, R1.y;
CMP result.color, -R1.x, c[7].z, R0;
END
# 45 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_ShadowMapTexture] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 37 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 2.00000000, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r0, v0, s0
texld r2.xyz, v1, s2
mul r3.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r1.xyz, r0.x, r1
texld r2.xyz, v1.zwzw, s3
mul r2.xyz, r0.z, r2
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r1, r2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mul_pp r1.xyz, r0, c4
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r1.xyz, r1, c5.w
mul_pp r2.xyz, r0, r0.w
mov_pp r1.w, c5.x
mul_pp r2.xyz, r1, r2
mul_pp r0.x, c6, r1.w
mul_pp r2.xyz, r2, r0.x
texld r0, v4, s7
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v5, s6
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c7.x
mul_pp r0.xyz, r0, c7.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp r0.xyz, r1, r0, r2
mul r0.xyz, r0, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
cmp r1.x, -r0.w, c8.y, c8.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c8.y, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_DiffCubeIBL] CUBE 6
SetTexture 6 [_ShadowMapTexture] 2D 0
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 320
Matrix 160 [SkyMatrix]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
Vector 144 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedjdfnpjimpkebfoneenjhapfddaohpmhpabaaaaaaheaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdmahaaaaeaaaaaaampabaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaamaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaakaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaalaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaamaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaagaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaafaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaiaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaakiacaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaah
ocaabaaaacaaaaaapgapbaaaaaaaaaaaagajbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaadaaaaaa
egacbaaaadaaaaaapgapbaaaaaaaaaaaddaaaaahocaabaaaacaaaaaafgaobaaa
acaaaaaaagajbaaaadaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaacaaaaaa
egacbaaaadaaaaaadeaaaaahhcaabaaaacaaaaaajgahbaaaacaaaaaaegacbaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
klkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaa
abeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaa
abaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaa
egaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "QUEUE"="Geometry-100" "RenderType"="MarmoSimpleTerrain" "SplatCount"="4" }
  ZWrite Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
Program "vp" {
SubProgram "opengl " {
Keywords { "POINT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].z, R0, c[11];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 21 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o6.z, r0, c10
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
add o5.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedbknajphfilnldgkjllgkjlmibgfoppcjabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefclaaeaaaaeaaaabaacmabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_WorldSpaceLightPos0]
Vector 10 [unity_Scale]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 14 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 result.texcoord[3].z, R0, c[7];
DP3 result.texcoord[3].y, R0, c[6];
DP3 result.texcoord[3].x, R0, c[5];
MOV result.texcoord[4].xyz, c[9];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceLightPos0]
Vector 9 [unity_Scale]
Vector 10 [_Control_ST]
Vector 11 [_Splat0_ST]
Vector 12 [_Splat1_ST]
Vector 13 [_Splat2_ST]
Vector 14 [_Splat3_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c9.w
dp3 o4.z, r0, c6
dp3 o4.y, r0, c5
dp3 o4.x, r0, c4
mov o5.xyz, c8
mad o1.zw, v2.xyxy, c11.xyxy, c11
mad o1.xy, v2, c10, c10.zwzw
mad o2.zw, v2.xyxy, c13.xyxy, c13
mad o2.xy, v2, c12, c12.zwzw
mad o3.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 240
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedniadgbhilipkiceaplhmoepchgfkeengabaaaaaaieaeaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcnaacaaaaeaaaabaaleaaaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaa
aaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaanaaaaaa
kgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadgaaaaaghccabaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 22 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].w, R0, c[12];
DP4 result.texcoord[5].z, R0, c[11];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 22 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 22 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o6.w, r0, c11
dp4 o6.z, r0, c10
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
add o5.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecednbfidlkaneonbmeffdcpoedoocpbcdpiabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefclaaeaaaaeaaaabaacmabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaagaaaaaaegiocaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].z, R0, c[11];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 21 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o6.z, r0, c10
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
add o5.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedbknajphfilnldgkjllgkjlmibgfoppcjabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefclaaeaaaaeaaaabaacmabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
MOV result.texcoord[4].xyz, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 20 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
mov o5.xyz, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedibmhgphlfhlmaojghfpijlbpakgfdcjmabaaaaaaniafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
mccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaa
aaaaaaaaaeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaa
adaaaaaaagiecaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaagaebaaaaaaaaaaa
dcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabcaaaaaa
ogikcaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaag
hccabaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].z, R0, c[11];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 21 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o6.z, r0, c10
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
add o5.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedbknajphfilnldgkjllgkjlmibgfoppcjabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefclaaeaaaaeaaaabaacmabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_WorldSpaceLightPos0]
Vector 10 [unity_Scale]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 14 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 result.texcoord[3].z, R0, c[7];
DP3 result.texcoord[3].y, R0, c[6];
DP3 result.texcoord[3].x, R0, c[5];
MOV result.texcoord[4].xyz, c[9];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_WorldSpaceLightPos0]
Vector 9 [unity_Scale]
Vector 10 [_Control_ST]
Vector 11 [_Splat0_ST]
Vector 12 [_Splat1_ST]
Vector 13 [_Splat2_ST]
Vector 14 [_Splat3_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c9.w
dp3 o4.z, r0, c6
dp3 o4.y, r0, c5
dp3 o4.x, r0, c4
mov o5.xyz, c8
mad o1.zw, v2.xyxy, c11.xyxy, c11
mad o1.xy, v2, c10, c10.zwzw
mad o2.zw, v2.xyxy, c13.xyxy, c13
mad o2.xy, v2, c12, c12.zwzw
mad o3.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 240
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedniadgbhilipkiceaplhmoepchgfkeengabaaaaaaieaeaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcnaacaaaaeaaaabaaleaaaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaa
aaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaanaaaaaa
kgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadgaaaaaghccabaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 22 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].w, R0, c[12];
DP4 result.texcoord[5].z, R0, c[11];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 22 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 22 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o6.w, r0, c11
dp4 o6.z, r0, c10
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
add o5.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecednbfidlkaneonbmeffdcpoedoocpbcdpiabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefclaaeaaaaeaaaabaacmabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaagaaaaaaegiocaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].z, R0, c[11];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 21 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o6.z, r0, c10
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
add o5.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedbknajphfilnldgkjllgkjlmibgfoppcjabaaaaaahmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefclaaeaaaaeaaaabaacmabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadhccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaabcaaaaaaogikcaaaaaaaaaaabcaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhccabaaaafaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
Vector 15 [_Control_ST]
Vector 16 [_Splat0_ST]
Vector 17 [_Splat1_ST]
Vector 18 [_Splat2_ST]
Vector 19 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[5].y, R0, c[10];
DP4 result.texcoord[5].x, R0, c[9];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
MOV result.texcoord[4].xyz, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 12 [_WorldSpaceLightPos0]
Vector 13 [unity_Scale]
Vector 14 [_Control_ST]
Vector 15 [_Splat0_ST]
Vector 16 [_Splat1_ST]
Vector 17 [_Splat2_ST]
Vector 18 [_Splat3_ST]
"vs_3_0
; 20 ALU
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
mul r1.xyz, v1, c13.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 o6.y, r0, c9
dp4 o6.x, r0, c8
dp3 o4.z, r1, c6
dp3 o4.y, r1, c5
dp3 o4.x, r1, c4
mov o5.xyz, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
mad o3.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 304
Matrix 48 [_LightMatrix0]
Vector 224 [_Control_ST]
Vector 240 [_Splat0_ST]
Vector 256 [_Splat1_ST]
Vector 272 [_Splat2_ST]
Vector 288 [_Splat3_ST]
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedibmhgphlfhlmaojghfpijlbpakgfdcjmabaaaaaaniafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcamaeaaaaeaaaabaaadabaaaafjaaaaaeegiocaaaaaaaaaaa
bdaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
mccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaa
ogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabaaaaaaaogikcaaaaaaaaaaa
baaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
bbaaaaaakgiocaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaa
aaaaaaaaaeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaa
aaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaa
adaaaaaaagiecaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaagaebaaaaaaaaaaa
dcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaabcaaaaaa
ogikcaaaaaaaaaaabcaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaag
hccabaaaafaaaaaaegiccaaaabaaaaaaaaaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "POINT" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTexture0] 2D 6
"3.0-!!ARBfp1.0
# 44 ALU, 6 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.45454544, 0.16666667, 255, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, c[5];
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
MUL R0.xyz, R0, c[6].w;
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
MAX R1.x, R1, c[7].z;
TEX R0.w, R0.w, texture[6], 2D;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP R0, -R1.y, c[7].z, R0;
POW result.color.x, R0.x, c[8].w;
POW result.color.y, R0.y, c[8].w;
POW result.color.z, R0.z, c[8].w;
MOV result.color.w, R0;
END
# 44 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTexture0] 2D 6
"ps_3_0
; 56 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s6
def c7, 0.00000000, 2.00000000, 0.45454544, 0.16666667
def c8, 255.00000000, 0.00392157, 0.00000000, 1.00000000
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, c6.w
mul_pp r1.xyz, r0, c4
dp3_pp r0.w, v4, v4
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v4
dp3_pp r0.y, v3, r2
dp3 r0.x, v5, v5
max_pp r0.y, r0, c7.x
texld r0.x, r0.x, s6
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c7.y
pow r0, r1.x, c7.z
pow r2, r1.y, c7.z
mov r1.x, r0
pow r0, r1.z, c7.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.z, c8.w
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.x, r0
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
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefieceddigmlhgopccklambpdcmaeancnjkiglaabaaaaaabaahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcniafaaaaeaaaaaaahgabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
aeaaaaaadcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aeaaaaaaaagabaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
afaaaaaaegbcbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaafaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaagaaaaaaegbcbaaaagaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaa
abaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaa
pgapbaaaaaaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
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
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
"3.0-!!ARBfp1.0
# 39 ALU, 5 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.45454544, 0.16666667, 255, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MUL R1.xyz, R0, c[5];
MOV R0.xyz, fragment.texcoord[4];
DP3 R0.w, fragment.texcoord[3], R0;
MUL R1.xyz, R1, c[6].w;
MUL R0.xyz, R1, c[4];
MAX R0.w, R0, c[7].z;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP R0, -R1.y, c[7].z, R0;
POW result.color.x, R0.x, c[8].w;
POW result.color.y, R0.y, c[8].w;
POW result.color.z, R0.z, c[8].w;
MOV result.color.w, R0;
END
# 39 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
"ps_3_0
; 52 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c7, 0.00000000, 2.00000000, 0.45454544, 0.16666667
def c8, 255.00000000, 0.00392157, 0.00000000, 1.00000000
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r1.xyz, r0, c5
mov_pp r0.xyz, v4
dp3_pp r0.x, v3, r0
mul_pp r1.xyz, r1, c6.w
mul_pp r1.xyz, r1, c4
max_pp r0.x, r0, c7
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c7.y
pow r0, r1.x, c7.z
pow r2, r1.y, c7.z
mov r1.x, r0
pow r0, r1.z, c7.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.z, c8.w
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.x, r0
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
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
ConstBuffer "$Globals" 240
Vector 16 [_LightColor0]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbibkeacoabaoajniamcbpldjiimpdnamabaaaaaaeeagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcceafaaaa
eaaaaaaaejabaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aeaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
aeaaaaaaegbcbaaaafaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
cpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaa
aaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
abaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmamea
mnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTexture0] 2D 6
SetTexture 7 [_LightTextureB0] 2D 7
"3.0-!!ARBfp1.0
# 50 ALU, 7 TEX
PARAM c[10] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 0.5 },
		{ 2, 0.45454544, 0.16666667, 255 },
		{ 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, c[5];
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
RCP R0.w, fragment.texcoord[5].w;
MAD R1.zw, fragment.texcoord[5].xyxy, R0.w, c[7].w;
MUL R0.xyz, R0, c[6].w;
DP3 R1.y, fragment.texcoord[5], fragment.texcoord[5];
TEX R0.w, R1.zwzw, texture[6], 2D;
TEX R1.w, R1.y, texture[7], 2D;
SLT R1.y, c[7].z, fragment.texcoord[5].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[7].z;
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].x;
POW R0.x, R0.x, c[8].y;
POW R0.z, R0.z, c[8].y;
POW R0.y, R0.y, c[8].y;
MUL R0.xyz, R0, c[8].z;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8];
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP R0, -R1.y, c[7].z, R0;
POW result.color.x, R0.x, c[9].x;
POW result.color.y, R0.y, c[9].x;
POW result.color.z, R0.z, c[9].x;
MOV result.color.w, R0;
END
# 50 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTexture0] 2D 6
SetTexture 7 [_LightTextureB0] 2D 7
"ps_3_0
; 61 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s6
dcl_2d s7
def c7, 0.50000000, 0.00000000, 1.00000000, 2.00000000
def c8, 0.45454544, 0.16666667, 255.00000000, 0.00392157
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
rcp r0.w, v5.w
mad r2.xy, v5, r0.w, c7.x
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r1.xyz, r0, c5
dp3_pp r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v4
dp3_pp r0.y, v3, r0
dp3 r0.x, v5, v5
texld r0.w, r2, s6
cmp r0.z, -v5, c7.y, c7
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s7
mul_pp r0.z, r0, r0.x
max_pp r0.x, r0.y, c7.y
mul_pp r1.xyz, r1, c4
mul_pp r0.x, r0, r0.z
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c7.w
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
cmp r1.x, -r0.w, c7.y, c7.z
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.y, r0
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
Keywords { "SPOT" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 2
SetTexture 1 [_Splat0] 2D 3
SetTexture 2 [_Splat1] 2D 4
SetTexture 3 [_Splat2] 2D 5
SetTexture 4 [_Splat3] 2D 6
SetTexture 5 [_LightTexture0] 2D 0
SetTexture 6 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedoamnjncghfioidjnbcaphmgeeojcodkhabaaaaaaaeaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmagaaaaeaaaaaaaldabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaa
agaaaaaapgbpbaaaagaaaaaaaaaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaadbaaaaahbcaabaaa
aaaaaaaaabeaaaaaaaaaaaaackbabaaaagaaaaaaabaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaa
aaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaagaaaaaa
egbcbaaaagaaaaaaefaaaaajpcaabaaaabaaaaaafgafbaaaaaaaaaaaeghobaaa
agaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaa
afaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagbjbaaaafaaaaaabaaaaaahccaabaaaaaaaaaaa
egbcbaaaaeaaaaaajgahbaaaaaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaa
agaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaaeaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahocaabaaaaaaaaaaa
agajbaaaacaaaaaafgafbaaaadaaaaaadcaaaaajocaabaaaaaaaaaaaagaabaaa
adaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaafaaaaaadcaaaaajocaabaaa
aaaaaaaakgakbaaaadaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaagaaaaaa
dcaaaaajocaabaaaaaaaaaaapgapbaaaadaaaaaaagajbaaaabaaaaaafgaobaaa
aaaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
ahaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaa
aiaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
abaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaa
cpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaa
aaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
abaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmamea
mnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTextureB0] 2D 6
SetTexture 7 [_LightTexture0] CUBE 7
"3.0-!!ARBfp1.0
# 46 ALU, 7 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.45454544, 0.16666667, 255, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
DP3 R1.y, fragment.texcoord[5], fragment.texcoord[5];
MUL R0.xyz, R0, c[5];
MUL R0.xyz, R0, c[6].w;
TEX R0.w, fragment.texcoord[5], texture[7], CUBE;
TEX R1.w, R1.y, texture[6], 2D;
MUL R1.y, R1.w, R0.w;
MAX R0.w, R1.x, c[7].z;
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP R0, -R1.y, c[7].z, R0;
POW result.color.x, R0.x, c[8].w;
POW result.color.y, R0.y, c[8].w;
POW result.color.z, R0.z, c[8].w;
MOV result.color.w, R0;
END
# 46 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTextureB0] 2D 6
SetTexture 7 [_LightTexture0] CUBE 7
"ps_3_0
; 57 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s6
dcl_cube s7
def c7, 0.00000000, 2.00000000, 0.45454544, 0.16666667
def c8, 255.00000000, 0.00392157, 0.00000000, 1.00000000
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c5
mul_pp r1.xyz, r0, c6.w
dp3_pp r0.w, v4, v4
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v4
dp3_pp r0.y, v3, r0
dp3 r0.x, v5, v5
mul_pp r1.xyz, r1, c4
texld r0.w, v5, s7
texld r0.x, r0.x, s6
mul r0.x, r0, r0.w
max_pp r0.y, r0, c7.x
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r1.xyz, r0, c7.y
pow r0, r1.x, c7.z
pow r2, r1.y, c7.z
mov r1.x, r0
pow r0, r1.z, c7.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.z, c8.w
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.x, r0
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
SetTexture 0 [_Control] 2D 2
SetTexture 1 [_Splat0] 2D 3
SetTexture 2 [_Splat1] 2D 4
SetTexture 3 [_Splat2] 2D 5
SetTexture 4 [_Splat3] 2D 6
SetTexture 5 [_LightTextureB0] 2D 1
SetTexture 6 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecednmgoiadmpeafbajncgjcgckcebjdbbnfabaaaaaagmahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdeagaaaaeaaaaaaainabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafidaaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaafaaaaaa
dcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaa
aagabaaaagaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaa
egbcbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaafaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
agaaaaaaegbcbaaaagaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaa
eghobaaaafaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaa
agaaaaaaeghobaaaagaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaaaacaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaa
aaaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoido
aaaaaaaabjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaa
deaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadl
dbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaak
bcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaa
abaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaa
ddaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaa
aaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaamnmmameamnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTexture0] 2D 6
"3.0-!!ARBfp1.0
# 41 ALU, 6 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.45454544, 0.16666667, 255, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MOV R1.xyz, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
MUL R0.xyz, R0, c[5];
MUL R0.xyz, R0, c[6].w;
MAX R1.x, R1, c[7].z;
TEX R0.w, fragment.texcoord[5], texture[6], 2D;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP R0, -R1.y, c[7].z, R0;
POW result.color.x, R0.x, c[8].w;
POW result.color.y, R0.y, c[8].w;
POW result.color.z, R0.z, c[8].w;
MOV result.color.w, R0;
END
# 41 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_LINEAR" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 6 [_LightTexture0] 2D 6
"ps_3_0
; 53 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s6
def c7, 0.00000000, 2.00000000, 0.45454544, 0.16666667
def c8, 255.00000000, 0.00392157, 0.00000000, 1.00000000
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xy
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mov_pp r1.xyz, v4
dp3_pp r1.x, v3, r1
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, c6.w
max_pp r1.x, r1, c7
texld r0.w, v5, s6
mul_pp r0.w, r1.x, r0
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r0, c7.y
pow r0, r1.x, c7.z
pow r2, r1.y, c7.z
mov r1.x, r0
pow r0, r1.z, c7.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.z, c8.w
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c7.x, r0
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
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecednjkigonpennmkmoekmipjeddbnbenneeabaaaaaakiagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchaafaaaaeaaaaaaafmabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaad
mcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
aeaaaaaadcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aeaaaaaaaagabaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
aeaaaaaaegbcbaaaafaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
afaaaaaaaagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaa
pgapbaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaa
bjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaah
icaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaa
aaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaah
icaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaak
hcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaa
cpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
mnmmameamnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTexture0] 2D 5
"3.0-!!ARBfp1.0
# 37 ALU, 6 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, c[5];
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
MUL R0.xyz, R0, c[6].w;
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
MAX R1.x, R1, c[7].z;
TEX R0.w, R0.w, texture[5], 2D;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 37 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTexture0] 2D 5
"ps_3_0
; 31 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c7, 0.00000000, 2.00000000, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, c6.w
mul_pp r1.xyz, r0, c4
dp3_pp r0.w, v4, v4
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v4
dp3 r0.x, v5, v5
dp3_pp r0.y, v3, r2
max_pp r0.y, r0, c7.x
texld r0.x, r0.x, s5
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.y
mul r0.xyz, r0, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
cmp r1.x, -r0.w, c8.y, c8.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbhokhcjhillgaoamingcgbmdnphonjkkabaaaaaabiagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaaeaaaaeaaaaaaadiabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
aeaaaaaadcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aeaaaaaaaagabaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
afaaaaaaegbcbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaafaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaagaaaaaaegbcbaaaagaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaa
abaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaa
pgapbaaaaaaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
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
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
"3.0-!!ARBfp1.0
# 32 ALU, 5 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MUL R1.xyz, R0, c[5];
MOV R0.xyz, fragment.texcoord[4];
DP3 R0.w, fragment.texcoord[3], R0;
MUL R1.xyz, R1, c[6].w;
MUL R0.xyz, R1, c[4];
MAX R0.w, R0, c[7].z;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 32 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
"ps_3_0
; 27 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c7, 0.00000000, 2.00000000, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r1.xyz, r0, c5
mov_pp r0.xyz, v4
dp3_pp r0.x, v3, r0
mul_pp r1.xyz, r1, c6.w
mul_pp r1.xyz, r1, c4
max_pp r0.x, r0, c7
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.y
mul r0.xyz, r0, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
cmp r1.x, -r0.w, c8.y, c8.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
ConstBuffer "$Globals" 240
Vector 16 [_LightColor0]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedjnhhbbcdmnmkbnoidbgldidfnbfanddgabaaaaaaemafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefccmaeaaaa
eaaaaaaaalabaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aeaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
aeaaaaaaegbcbaaaafaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
aaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaa
aaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaa
pgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "SPOT" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTexture0] 2D 5
SetTexture 6 [_LightTextureB0] 2D 6
"3.0-!!ARBfp1.0
# 43 ALU, 7 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 0.5 },
		{ 2, 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, c[5];
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
RCP R0.w, fragment.texcoord[5].w;
MAD R1.zw, fragment.texcoord[5].xyxy, R0.w, c[7].w;
MUL R0.xyz, R0, c[6].w;
DP3 R1.y, fragment.texcoord[5], fragment.texcoord[5];
TEX R0.w, R1.zwzw, texture[5], 2D;
TEX R1.w, R1.y, texture[6], 2D;
SLT R1.y, c[7].z, fragment.texcoord[5].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[7].z;
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 43 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTexture0] 2D 5
SetTexture 6 [_LightTextureB0] 2D 6
"ps_3_0
; 36 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
dcl_2d s6
def c7, 0.50000000, 0.00000000, 1.00000000, 2.00000000
def c8, 0.16666667, 255.00000000, 0.00392157, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
rcp r0.w, v5.w
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r1.xyz, r0, c5
dp3_pp r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v4
dp3_pp r0.y, v3, r0
mad r2.xy, v5, r0.w, c7.x
dp3 r0.x, v5, v5
mul_pp r1.xyz, r1, c4
texld r0.w, r2, s5
cmp r0.z, -v5, c7.y, c7
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s6
mul_pp r0.z, r0, r0.x
max_pp r0.x, r0.y, c7.y
mul_pp r0.x, r0, r0.z
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.w
mul r0.xyz, r0, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
cmp r1.x, -r0.w, c7.y, c7.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.y, r0
"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 2
SetTexture 1 [_Splat0] 2D 3
SetTexture 2 [_Splat1] 2D 4
SetTexture 3 [_Splat2] 2D 5
SetTexture 4 [_Splat3] 2D 6
SetTexture 5 [_LightTexture0] 2D 0
SetTexture 6 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedcpooiccjagmgihcdeojighlmigambgobabaaaaaaamahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcneafaaaaeaaaaaaahfabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaa
agaaaaaapgbpbaaaagaaaaaaaaaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaafaaaaaaaagabaaaaaaaaaaadbaaaaahbcaabaaa
aaaaaaaaabeaaaaaaaaaaaaackbabaaaagaaaaaaabaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaa
aaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaagaaaaaa
egbcbaaaagaaaaaaefaaaaajpcaabaaaabaaaaaafgafbaaaaaaaaaaaeghobaaa
agaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaa
afaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagbjbaaaafaaaaaabaaaaaahccaabaaaaaaaaaaa
egbcbaaaaeaaaaaajgahbaaaaaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaapaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaa
agaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaaeaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahocaabaaaaaaaaaaa
agajbaaaacaaaaaafgafbaaaadaaaaaadcaaaaajocaabaaaaaaaaaaaagaabaaa
adaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaafaaaaaadcaaaaajocaabaaa
aaaaaaaakgakbaaaadaaaaaaagajbaaaabaaaaaafgaobaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaagaaaaaa
dcaaaaajocaabaaaaaaaaaaapgapbaaaadaaaaaaagajbaaaabaaaaaafgaobaaa
aaaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
ahaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaapgipcaaaaaaaaaaa
aiaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
abaaaaaadiaaaaahhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
aaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaa
aaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaa
pgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTextureB0] 2D 5
SetTexture 6 [_LightTexture0] CUBE 6
"3.0-!!ARBfp1.0
# 39 ALU, 7 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
DP3 R1.y, fragment.texcoord[5], fragment.texcoord[5];
MUL R0.xyz, R0, c[5];
MUL R0.xyz, R0, c[6].w;
TEX R0.w, fragment.texcoord[5], texture[6], CUBE;
TEX R1.w, R1.y, texture[5], 2D;
MUL R1.y, R1.w, R0.w;
MAX R0.w, R1.x, c[7].z;
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 39 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTextureB0] 2D 5
SetTexture 6 [_LightTexture0] CUBE 6
"ps_3_0
; 32 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
dcl_cube s6
def c7, 0.00000000, 2.00000000, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c5
mul_pp r1.xyz, r0, c6.w
dp3_pp r0.w, v4, v4
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v4
dp3_pp r0.y, v3, r0
dp3 r0.x, v5, v5
mul_pp r1.xyz, r1, c4
texld r0.w, v5, s6
texld r0.x, r0.x, s5
mul r0.x, r0, r0.w
max_pp r0.y, r0, c7.x
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.y
mul r0.xyz, r0, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
cmp r1.x, -r0.w, c8.y, c8.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 2
SetTexture 1 [_Splat0] 2D 3
SetTexture 2 [_Splat1] 2D 4
SetTexture 3 [_Splat2] 2D 5
SetTexture 4 [_Splat3] 2D 6
SetTexture 5 [_LightTextureB0] 2D 1
SetTexture 6 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedjdlbfmcgiajikjjnhgbfndjlfikpfdmeabaaaaaaheagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdmafaaaaeaaaaaaaepabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaa
ffffaaaafidaaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaafaaaaaa
dcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaa
aagabaaaagaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaafaaaaaa
egbcbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaafaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
agaaaaaaegbcbaaaagaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaa
eghobaaaafaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaa
agaaaaaaeghobaaaagaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaaaacaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaa
aaaaaaaaagaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
klkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaa
abeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaa
abaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaa
egaobaaaabaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTexture0] 2D 5
"3.0-!!ARBfp1.0
# 34 ALU, 6 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 2 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.xyz, R0.y, R2;
MUL R1.xyz, R0.x, R1;
ADD R3.xyz, R1, R2;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R0.w, R2;
ADD R0.xyz, R3, R0;
ADD R0.xyz, R0, R1;
MOV R1.xyz, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
MUL R0.xyz, R0, c[5];
MUL R0.xyz, R0, c[6].w;
MAX R1.x, R1, c[7].z;
TEX R0.w, fragment.texcoord[5], texture[5], 2D;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[7].w;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 34 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
Vector 4 [_LightColor0]
Vector 5 [_Color]
Vector 6 [ExposureIBL]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_LightTexture0] 2D 5
"ps_3_0
; 28 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c7, 0.00000000, 2.00000000, 0.16666667, 255.00000000
def c8, 0.00392157, 0.00000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xy
texld r0, v0, s0
texld r2.xyz, v1, s2
texld r1.xyz, v0.zwzw, s1
mul r2.xyz, r0.y, r2
mul r1.xyz, r0.x, r1
add_pp r3.xyz, r1, r2
texld r1.xyz, v1.zwzw, s3
mul r0.xyz, r0.z, r1
texld r2.xyz, v2, s4
mul r1.xyz, r0.w, r2
add_pp r0.xyz, r3, r0
add_pp r0.xyz, r0, r1
mov_pp r1.xyz, v4
dp3_pp r1.x, v3, r1
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, c6.w
max_pp r1.x, r1, c7
texld r0.w, v5, s5
mul_pp r0.w, r1.x, r0
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c7.y
mul r0.xyz, r0, c7.z
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.x
cmp r1.x, -r0.w, c8.y, c8.z
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 1
SetTexture 1 [_Splat0] 2D 2
SetTexture 2 [_Splat1] 2D 3
SetTexture 3 [_Splat2] 2D 4
SetTexture 4 [_Splat3] 2D 5
SetTexture 5 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 304
Vector 16 [_LightColor0]
Vector 112 [_Color]
Vector 128 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefieceddfigjglafjhgkachbockddhjjjdeihdaabaaaaaalaafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchiaeaaaaeaaaaaaaboabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaa
aeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaad
mcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaafgafbaaaacaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
aeaaaaaadcaaaaajhcaabaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aeaaaaaaaagabaaaafaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaacaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaaaaaaaaaaiaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
aeaaaaaaegbcbaaaafaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
afaaaaaaaagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaa
pgapbaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdo
klkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahped
ecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaa
egacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaa
abaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassBase" "QUEUE"="Geometry-100" "RenderType"="MarmoSimpleTerrain" "SplatCount"="4" }
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Vector 9 [unity_Scale]
"3.0-!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
"vs_3_0
; 8 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
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
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefieceddgoflhcgfinoonoplgmdiabihpafgdafabaaaaaaneacaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefciaabaaaaeaaaabaagaaaaaaafjaaaaae
egiocaaaaaaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaaaaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Vector 9 [unity_Scale]
"3.0-!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
"vs_3_0
; 8 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
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
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Vector 320 [unity_Scale]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefieceddgoflhcgfinoonoplgmdiabihpafgdafabaaaaaaneacaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefciaabaaaaeaaaabaagaaaaaaafjaaaaae
egiocaaaaaaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaaaaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" }
"3.0-!!ARBfp1.0
# 2 ALU, 0 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 0.5 } };
MAD result.color.xyz, fragment.texcoord[0], c[4].y, c[4].y;
MOV result.color.w, c[4].x;
END
# 2 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" }
"ps_3_0
; 2 ALU
def c4, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xyz
mad_pp oC0.xyz, v0, c4.x, c4.x
mov_pp oC0.w, c4.y
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" }
"ps_4_0
eefiecedhbdiiogganilkmhhpogjlnaalcliljppabaaaaaadeabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcheaaaaaa
eaaaaaaabnaaaaaagcbaaaadhcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaa
dcaaaaaphccabaaaaaaaaaaaegbcbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" }
"3.0-!!ARBfp1.0
# 2 ALU, 0 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 0.5 } };
MAD result.color.xyz, fragment.texcoord[0], c[4].y, c[4].y;
MOV result.color.w, c[4].x;
END
# 2 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" }
"ps_3_0
; 2 ALU
def c4, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xyz
mad_pp oC0.xyz, v0, c4.x, c4.x
mov_pp oC0.w, c4.y
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" }
"ps_4_0
eefiecedhbdiiogganilkmhhpogjlnaalcliljppabaaaaaadeabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcheaaaaaa
eaaaaaaabnaaaaaagcbaaaadhcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaa
dcaaaaaphccabaaaaaaaaaaaegbcbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassFinal" "QUEUE"="Geometry-100" "RenderType"="MarmoSimpleTerrain" "SplatCount"="4" }
  ZWrite Off
Program "vp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 32 ALU
PARAM c[23] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.w, c[0].y;
DP3 R1.z, vertex.normal, c[7];
DP3 R1.x, vertex.normal, c[5];
DP3 R1.y, vertex.normal, c[6];
MUL R0.xyz, R1, c[17].w;
MUL R1.w, R0.y, R0.y;
MUL R2, R0.xyzz, R0.yzzx;
DP4 R3.z, R0, c[12];
DP4 R3.y, R0, c[11];
DP4 R3.x, R0, c[10];
MAD R1.w, R0.x, R0.x, -R1;
DP4 R0.z, R2, c[15];
DP4 R0.x, R2, c[13];
DP4 R0.y, R2, c[14];
ADD R4.xyz, R3, R0;
MUL R3.xyz, R1.w, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[9].x;
ADD result.texcoord[5].xyz, R4, R3;
ADD result.texcoord[4].xy, R2, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[3].xyz, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[22], c[22].zwzw;
END
# 32 instructions, 5 R-regs
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
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"vs_3_0
; 32 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c23, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c23.y
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
mul r2.xyz, r0.xyww, c23.x
mul r2.y, r2, c8.x
add o6.xyz, r4, r3
mad o5.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o5.zw, r0
mov o4.xyz, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
mad o3.xy, v2, c22, c22.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
eefiecedbhemliakobmggkbnijldnhjbkmngdnhnabaaaaaaliagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcomaeaaaaeaaaabaadlabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaa
aaaaaaaaamaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaanaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaacaaaaaamgaabaaaacaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaaaaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaaaaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaaaaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaa
cmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 9 [_Object2World]
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 27 ALU
PARAM c[21] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..20] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[4].zw, R0;
MUL result.texcoord[6].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[6].w, -R0.x, R0.y;
DP3 result.texcoord[3].z, vertex.normal, c[11];
DP3 result.texcoord[3].y, vertex.normal, c[10];
DP3 result.texcoord[3].x, vertex.normal, c[9];
END
# 27 instructions, 2 R-regs
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
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"vs_3_0
; 27 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c21, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c21.x
mul r1.y, r1, c12.x
mad o5.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c21, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o5.zw, r0
mul o7.xyz, r1, c14.w
mad o1.zw, v2.xyxy, c17.xyxy, c17
mad o1.xy, v2, c16, c16.zwzw
mad o2.zw, v2.xyxy, c19.xyxy, c19
mad o2.xy, v2, c18, c18.zwzw
mad o3.xy, v2, c20, c20.zwzw
mad o6.xy, v3, c15, c15.zwzw
mul o7.w, -r0.x, r0.y
dp3 o4.z, v1, c10
dp3 o4.y, v1, c9
dp3 o4.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
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
eefiecedjgaigefhakamjfefpjfcmmmgiiidlaepabaaaaaacaahaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
dmafaaaaeaaaabaaepabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaae
egiocaaaadaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaalmccabaaa
acaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaaaaaaaaaa
aoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
apaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaaagbebaaa
aeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o5.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o6.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedkmkcaenccahiikbkkojnjokflgemdaidabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aoaaaaaakgiocaaaaaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 32 ALU
PARAM c[23] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.w, c[0].y;
DP3 R1.z, vertex.normal, c[7];
DP3 R1.x, vertex.normal, c[5];
DP3 R1.y, vertex.normal, c[6];
MUL R0.xyz, R1, c[17].w;
MUL R1.w, R0.y, R0.y;
MUL R2, R0.xyzz, R0.yzzx;
DP4 R3.z, R0, c[12];
DP4 R3.y, R0, c[11];
DP4 R3.x, R0, c[10];
MAD R1.w, R0.x, R0.x, -R1;
DP4 R0.z, R2, c[15];
DP4 R0.x, R2, c[13];
DP4 R0.y, R2, c[14];
ADD R4.xyz, R3, R0;
MUL R3.xyz, R1.w, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[9].x;
ADD result.texcoord[5].xyz, R4, R3;
ADD result.texcoord[4].xy, R2, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[3].xyz, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[22], c[22].zwzw;
END
# 32 instructions, 5 R-regs
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
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"vs_3_0
; 32 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c23, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c23.y
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
mul r2.xyz, r0.xyww, c23.x
mul r2.y, r2, c8.x
add o6.xyz, r4, r3
mad o5.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o5.zw, r0
mov o4.xyz, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
mad o3.xy, v2, c22, c22.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
eefiecedbhemliakobmggkbnijldnhjbkmngdnhnabaaaaaaliagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcomaeaaaaeaaaabaadlabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaa
aaaaaaaaamaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaanaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaacaaaaaamgaabaaaacaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaaaaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaaaaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaaaaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaa
cmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 9 [_Object2World]
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 27 ALU
PARAM c[21] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..20] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[4].zw, R0;
MUL result.texcoord[6].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[6].w, -R0.x, R0.y;
DP3 result.texcoord[3].z, vertex.normal, c[11];
DP3 result.texcoord[3].y, vertex.normal, c[10];
DP3 result.texcoord[3].x, vertex.normal, c[9];
END
# 27 instructions, 2 R-regs
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
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"vs_3_0
; 27 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c21, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c21.x
mul r1.y, r1, c12.x
mad o5.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c21, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o5.zw, r0
mul o7.xyz, r1, c14.w
mad o1.zw, v2.xyxy, c17.xyxy, c17
mad o1.xy, v2, c16, c16.zwzw
mad o2.zw, v2.xyxy, c19.xyxy, c19
mad o2.xy, v2, c18, c18.zwzw
mad o3.xy, v2, c20, c20.zwzw
mad o6.xy, v3, c15, c15.zwzw
mul o7.w, -r0.x, r0.y
dp3 o4.z, v1, c10
dp3 o4.y, v1, c9
dp3 o4.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
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
eefiecedjgaigefhakamjfefpjfcmmmgiiidlaepabaaaaaacaahaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
dmafaaaaeaaaabaaepabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaae
egiocaaaadaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaalmccabaaa
acaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaaaaaaaaaa
aoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
apaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaaagbebaaa
aeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o5.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o6.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedkmkcaenccahiikbkkojnjokflgemdaidabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aoaaaaaakgiocaaaaaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 32 ALU
PARAM c[23] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.w, c[0].y;
DP3 R1.z, vertex.normal, c[7];
DP3 R1.x, vertex.normal, c[5];
DP3 R1.y, vertex.normal, c[6];
MUL R0.xyz, R1, c[17].w;
MUL R1.w, R0.y, R0.y;
MUL R2, R0.xyzz, R0.yzzx;
DP4 R3.z, R0, c[12];
DP4 R3.y, R0, c[11];
DP4 R3.x, R0, c[10];
MAD R1.w, R0.x, R0.x, -R1;
DP4 R0.z, R2, c[15];
DP4 R0.x, R2, c[13];
DP4 R0.y, R2, c[14];
ADD R4.xyz, R3, R0;
MUL R3.xyz, R1.w, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[9].x;
ADD result.texcoord[5].xyz, R4, R3;
ADD result.texcoord[4].xy, R2, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[3].xyz, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[22], c[22].zwzw;
END
# 32 instructions, 5 R-regs
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
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"vs_3_0
; 32 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c23, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c23.y
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
mul r2.xyz, r0.xyww, c23.x
mul r2.y, r2, c8.x
add o6.xyz, r4, r3
mad o5.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o5.zw, r0
mov o4.xyz, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
mad o3.xy, v2, c22, c22.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
eefiecedbhemliakobmggkbnijldnhjbkmngdnhnabaaaaaaliagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcomaeaaaaeaaaabaadlabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaa
aaaaaaaaamaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaanaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaacaaaaaamgaabaaaacaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaaaaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaaaaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaaaaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaa
cmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 9 [_Object2World]
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 27 ALU
PARAM c[21] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..20] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[4].zw, R0;
MUL result.texcoord[6].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[6].w, -R0.x, R0.y;
DP3 result.texcoord[3].z, vertex.normal, c[11];
DP3 result.texcoord[3].y, vertex.normal, c[10];
DP3 result.texcoord[3].x, vertex.normal, c[9];
END
# 27 instructions, 2 R-regs
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
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"vs_3_0
; 27 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c21, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c21.x
mul r1.y, r1, c12.x
mad o5.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c21, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o5.zw, r0
mul o7.xyz, r1, c14.w
mad o1.zw, v2.xyxy, c17.xyxy, c17
mad o1.xy, v2, c16, c16.zwzw
mad o2.zw, v2.xyxy, c19.xyxy, c19
mad o2.xy, v2, c18, c18.zwzw
mad o3.xy, v2, c20, c20.zwzw
mad o6.xy, v3, c15, c15.zwzw
mul o7.w, -r0.x, r0.y
dp3 o4.z, v1, c10
dp3 o4.y, v1, c9
dp3 o4.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
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
eefiecedjgaigefhakamjfefpjfcmmmgiiidlaepabaaaaaacaahaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
dmafaaaaeaaaabaaepabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaae
egiocaaaadaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaalmccabaaa
acaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaaaaaaaaaa
aoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
apaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaaagbebaaa
aeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o5.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o6.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedkmkcaenccahiikbkkojnjokflgemdaidabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aoaaaaaakgiocaaaaaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [unity_Scale]
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 32 ALU
PARAM c[23] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.w, c[0].y;
DP3 R1.z, vertex.normal, c[7];
DP3 R1.x, vertex.normal, c[5];
DP3 R1.y, vertex.normal, c[6];
MUL R0.xyz, R1, c[17].w;
MUL R1.w, R0.y, R0.y;
MUL R2, R0.xyzz, R0.yzzx;
DP4 R3.z, R0, c[12];
DP4 R3.y, R0, c[11];
DP4 R3.x, R0, c[10];
MAD R1.w, R0.x, R0.x, -R1;
DP4 R0.z, R2, c[15];
DP4 R0.x, R2, c[13];
DP4 R0.y, R2, c[14];
ADD R4.xyz, R3, R0;
MUL R3.xyz, R1.w, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[9].x;
ADD result.texcoord[5].xyz, R4, R3;
ADD result.texcoord[4].xy, R2, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[3].xyz, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[22], c[22].zwzw;
END
# 32 instructions, 5 R-regs
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
Vector 18 [_Control_ST]
Vector 19 [_Splat0_ST]
Vector 20 [_Splat1_ST]
Vector 21 [_Splat2_ST]
Vector 22 [_Splat3_ST]
"vs_3_0
; 32 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c23, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0.w, c23.y
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
mul r2.xyz, r0.xyww, c23.x
mul r2.y, r2, c8.x
add o6.xyz, r4, r3
mad o5.xy, r2.z, c9.zwzw, r2
mov o0, r0
mov o5.zw, r0
mov o4.xyz, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
mad o3.xy, v2, c22, c22.zwzw
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 160 [_Control_ST]
Vector 176 [_Splat0_ST]
Vector 192 [_Splat1_ST]
Vector 208 [_Splat2_ST]
Vector 224 [_Splat3_ST]
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
eefiecedbhemliakobmggkbnijldnhjbkmngdnhnabaaaaaaliagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcomaeaaaaeaaaabaadlabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagfaaaaadhccabaaaagaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaamaaaaaaogikcaaa
aaaaaaaaamaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaanaaaaaakgiocaaaaaaaaaaaanaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaacaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaaeaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaacaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaacaaaaaamgaabaaaacaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaaaaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaaaaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaaaaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
dkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaagaaaaaaegiccaaaacaaaaaa
cmaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 9 [_Object2World]
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Vector 15 [unity_LightmapST]
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 27 ALU
PARAM c[21] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..20] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[4].zw, R0;
MUL result.texcoord[6].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[6].w, -R0.x, R0.y;
DP3 result.texcoord[3].z, vertex.normal, c[11];
DP3 result.texcoord[3].y, vertex.normal, c[10];
DP3 result.texcoord[3].x, vertex.normal, c[9];
END
# 27 instructions, 2 R-regs
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
Vector 16 [_Control_ST]
Vector 17 [_Splat0_ST]
Vector 18 [_Splat1_ST]
Vector 19 [_Splat2_ST]
Vector 20 [_Splat3_ST]
"vs_3_0
; 27 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c21, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c21.x
mul r1.y, r1, c12.x
mad o5.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c21, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o5.zw, r0
mul o7.xyz, r1, c14.w
mad o1.zw, v2.xyxy, c17.xyxy, c17
mad o1.xy, v2, c16, c16.zwzw
mad o2.zw, v2.xyxy, c19.xyxy, c19
mad o2.xy, v2, c18, c18.zwzw
mad o3.xy, v2, c20, c20.zwzw
mad o6.xy, v3, c15, c15.zwzw
mul o7.w, -r0.x, r0.y
dp3 o4.z, v1, c10
dp3 o4.y, v1, c9
dp3 o4.x, v1, c8
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
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
eefiecedjgaigefhakamjfefpjfcmmmgiiidlaepabaaaaaacaahaaaaadaaaaaa
cmaaaaaapeaaaaaanmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheooaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaneaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
dmafaaaaeaaaabaaepabaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaae
egiocaaaadaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadcaaaaalmccabaaa
acaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaakgiocaaaaaaaaaaa
aoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
apaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaalmccabaaaadaaaaaaagbebaaa
aeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaacaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaagaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaagaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP3 result.texcoord[3].z, vertex.normal, c[7];
DP3 result.texcoord[3].y, vertex.normal, c[6];
DP3 result.texcoord[3].x, vertex.normal, c[5];
END
# 18 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_Control_ST]
Vector 12 [_Splat0_ST]
Vector 13 [_Splat1_ST]
Vector 14 [_Splat2_ST]
Vector 15 [_Splat3_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c8.x
mad o5.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v2, c15, c15.zwzw
mad o6.xy, v3, c10, c10.zwzw
dp3 o4.z, v1, c6
dp3 o4.y, v1, c5
dp3 o4.x, v1, c4
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
ConstBuffer "$Globals" 288
Vector 160 [unity_LightmapST]
Vector 176 [_Control_ST]
Vector 192 [_Splat0_ST]
Vector 208 [_Splat1_ST]
Vector 224 [_Splat2_ST]
Vector 240 [_Splat3_ST]
ConstBuffer "UnityPerCamera" 128
Vector 80 [_ProjectionParams]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
eefiecedkmkcaenccahiikbkkojnjokflgemdaidabaaaaaadeafaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcgiadaaaaeaaaabaankaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
apaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aoaaaaaakgiocaaaaaaaaaaaaoaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadcaaaaal
mccabaaaadaaaaaaagbebaaaaeaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaacaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaacaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"3.0-!!ARBfp1.0
# 54 ALU, 7 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 0.75341797, 0.24682617, 0.45454544 },
		{ 0.16666667, 255, 0.0039215689, 1 },
		{ 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
ADD R0.xyz, R1, R0;
TEX R1, R2, texture[5], CUBE;
MUL R3.x, R1.w, R1.w;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R0.xyz, R0, R2;
MUL R3.y, R1.w, R3.x;
MUL R2.xy, R3, c[7].yzzw;
ADD R0.w, R2.x, R2.y;
MUL R1.xyz, R1, R0.w;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0, c[5].w;
MUL R2.xyz, R0, R1;
TXP R1.xyz, fragment.texcoord[4], texture[6], 2D;
MOV R0.w, c[6].x;
MUL R0.w, R0, c[5].x;
MUL R2.xyz, R2, R0.w;
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
ADD R1.xyz, -R1, fragment.texcoord[5];
MAD R0.xyz, R0, R1, R2;
POW R0.x, R0.x, c[7].w;
POW R0.z, R0.z, c[7].w;
POW R0.y, R0.y, c[7].w;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[8].z;
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[8];
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].x;
POW result.color.y, R0.y, c[9].x;
POW result.color.z, R0.z, c[9].x;
MOV result.color.w, R0;
END
# 54 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"ps_3_0
; 63 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 0.75341797, 0.24682617, 0.45454544, 0.16666667
def c8, 255.00000000, 0.00392157, 0.00000000, 1.00000000
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
mad r2.xyz, v3.x, c0, r2
add_pp r0.xyz, r1, r0
texld r1, r2, s5
mul_pp r3.x, r1.w, r1.w
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r0.xyz, r0, r2
mul_pp r3.y, r1.w, r3.x
mul_pp r2.xy, r3, c7
add_pp r0.w, r2.x, r2.y
mul_pp r1.xyz, r1, r0.w
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, c5.w
mul_pp r2.xyz, r0, r1
texldp r1.xyz, v4, s6
mov_pp r0.w, c5.x
mul_pp r0.w, c6.x, r0
mul_pp r2.xyz, r2, r0.w
log_pp r1.x, r1.x
log_pp r1.z, r1.z
log_pp r1.y, r1.y
add_pp r1.xyz, -r1, v5
mad_pp r1.xyz, r0, r1, r2
pow r0, r1.x, c7.z
pow r2, r1.y, c7.z
mov r1.x, r0
pow r0, r1.z, c7.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.z, c8.w
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.z, r0
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
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedohkdpfobdkfecmpfghhabfdelnlbelodabaaaaaapmaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmeahaaaaeaaaaaaapbabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadlcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaa
abaaaaaaapaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaa
aaaaaaaaegaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaa
ogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaakgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
dcaaaaajhcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
cpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaiaebaaaaaaacaaaaaaegbcbaaaagaaaaaadcaaaaajhcaabaaaaaaaaaaa
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
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"3.0-!!ARBfp1.0
# 65 ALU, 9 TEX
PARAM c[11] = { program.local[0..7],
		{ 0, 8, 0.75341797, 0.24682617 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
ADD R1.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R0, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
MUL R3.y, R0.w, R3.x;
MUL R3.xy, R3, c[8].zwzw;
ADD R0.w, R3.x, R3.y;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R1.xyz, R1, R2;
MUL R1.xyz, R1, c[4];
MUL R2.xyz, R1, c[5].w;
MUL R0.xyz, R0, R0.w;
MOV R1.x, c[6];
MUL R0.w, R1.x, c[5].x;
MUL R0.xyz, R2, R0;
MUL R3.xyz, R0, R0.w;
TEX R0, fragment.texcoord[5], texture[7], 2D;
MUL R0.xyz, R0.w, R0;
TEX R1, fragment.texcoord[5], texture[8], 2D;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, c[8].y;
MAD R4.xyz, R0, c[8].y, -R1;
TXP R0.xyz, fragment.texcoord[4], texture[6], 2D;
DP4 R0.w, fragment.texcoord[6], fragment.texcoord[6];
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD_SAT R0.w, R0, c[7].z, c[7];
MAD R1.xyz, R0.w, R4, R1;
LG2 R0.x, R0.x;
LG2 R0.y, R0.y;
LG2 R0.z, R0.z;
ADD R0.xyz, -R0, R1;
MAD R0.xyz, R2, R0, R3;
POW R0.x, R0.x, c[9].x;
POW R0.z, R0.z, c[9].x;
POW R0.y, R0.y, c[9].x;
MUL R0.xyz, R0, c[9].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[9].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[9].w;
RCP R1.z, R1.x;
SLT R1.y, c[8].x, R1.x;
MOV R0.w, c[10].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[8].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[8].x, R0;
POW result.color.x, R0.x, c[10].y;
POW result.color.y, R0.y, c[10].y;
POW result.color.z, R0.z, c[10].y;
MOV result.color.w, R0;
END
# 65 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"ps_3_0
; 72 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
dcl_2d s8
def c8, 8.00000000, 0.75341797, 0.24682617, 0.45454544
def c9, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c10, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
mul r2.xyz, v3.z, c2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
add_pp r1.xyz, r1, r0
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r1.xyz, r1, r2
mul_pp r1.xyz, r1, c4
mov_pp r0.w, c5.x
mul_pp r2.xyz, r1, c5.w
mul_pp r3.xy, r3, c8.yzzw
add_pp r1.x, r3, r3.y
mul_pp r0.xyz, r0, r1.x
texld r1, v5, s8
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r2, r0
mul_pp r0.w, c6.x, r0
mul_pp r3.xyz, r0, r0.w
texld r0, v5, s7
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r1, c8.x
mad_pp r4.xyz, r0, c8.x, -r1
texldp r0.xyz, v4, s6
dp4 r0.w, v6, v6
rsq r0.w, r0.w
rcp r0.w, r0.w
mad_sat r0.w, r0, c7.z, c7
mad_pp r1.xyz, r0.w, r4, r1
log_pp r0.x, r0.x
log_pp r0.y, r0.y
log_pp r0.z, r0.z
add_pp r0.xyz, -r0, r1
mad_pp r1.xyz, r2, r0, r3
pow r0, r1.x, c8.w
pow r2, r1.y, c8.w
mov r1.x, r0
pow r0, r1.z, c8.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c9.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c9.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c9.z
rcp r1.y, r0.w
cmp r1.x, -r0.w, c10, c10.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c9.w, r0
pow r0, r1.x, c10.z
mov oC0.x, r0
pow r0, r1.y, c10.z
pow r2, r1.z, c10.z
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
Vector 256 [unity_LightmapFade]
BindCB  "$Globals" 0
"ps_4_0
eefiecedjbohcoolgpigkbkddljboffbgdhfbgbdabaaaaaajmakaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaneaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcemajaaaaeaaaaaaafdacaaaafjaaaaaeegiocaaa
aaaaaaaabbaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafkaaaaad
aagabaaaahaaaaaafkaaaaadaagabaaaaiaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaafidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaa
ffffaaaafibiaaaeaahabaaaahaaaaaaffffaaaafibiaaaeaahabaaaaiaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadlcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabbaaaaah
icaabaaaaaaaaaaaegbobaaaagaaaaaaegbobaaaagaaaaaaelaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadccaaaalicaabaaaaaaaaaaadkaabaaaaaaaaaaa
ckiacaaaaaaaaaaabaaaaaaadkiacaaaaaaaaaaabaaaaaaaefaaaaajpcaabaaa
acaaaaaaogbkbaaaadaaaaaaeghobaaaaiaaaaaaaagabaaaaiaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaadaaaaaa
ogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaadaaaaaa
pgapbaaaabaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaaj
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
aoaaaaahdcaabaaaadaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaaj
pcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
cpaaaaafhcaabaaaadaaaaaaegacbaaaadaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaiaebaaaaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
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
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 56 ALU, 8 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 8, 0.75341797, 0.24682617 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
ADD R1.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R0, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
MUL R3.y, R0.w, R3.x;
MUL R3.xy, R3, c[7].zwzw;
ADD R0.w, R3.x, R3.y;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R1.xyz, R1, R2;
MUL R1.xyz, R1, c[4];
MUL R2.xyz, R1, c[5].w;
MUL R0.xyz, R0, R0.w;
MOV R1.x, c[6];
MUL R0.w, R1.x, c[5].x;
TXP R1.xyz, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R2, R0;
MUL R3.xyz, R0, R0.w;
TEX R0, fragment.texcoord[5], texture[7], 2D;
MUL R0.xyz, R0.w, R0;
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
MAD R0.xyz, R0, c[7].y, -R1;
MAD R0.xyz, R2, R0, R3;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[8].w;
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[9].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].y;
POW result.color.y, R0.y, c[9].y;
POW result.color.z, R0.z, c[9].y;
MOV result.color.w, R0;
END
# 56 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 64 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 0.75341797, 0.24682617, 0.45454544
def c8, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c9, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
mul r2.xyz, v3.z, c2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
add_pp r1.xyz, r1, r0
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r1.xyz, r1, r2
mul_pp r1.xyz, r1, c4
mov_pp r0.w, c5.x
mul_pp r2.xyz, r1, c5.w
mul_pp r3.xy, r3, c7.yzzw
add_pp r1.x, r3, r3.y
mul_pp r0.xyz, r0, r1.x
texldp r1.xyz, v4, s6
mul_pp r0.xyz, r2, r0
mul_pp r0.w, c6.x, r0
mul_pp r3.xyz, r0, r0.w
texld r0, v5, s7
mul_pp r0.xyz, r0.w, r0
log_pp r1.x, r1.x
log_pp r1.z, r1.z
log_pp r1.y, r1.y
mad_pp r0.xyz, r0, c7.x, -r1
mad_pp r1.xyz, r2, r0, r3
pow r0, r1.x, c7.w
pow r2, r1.y, c7.w
mov r1.x, r0
pow r0, r1.z, c7.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
rcp r1.y, r0.w
cmp r1.x, -r0.w, c9, c9.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.w, r0
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
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_LINEAR" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedkhhlnineidjnojladnhkepcgjlmnampiabaaaaaagaajaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcciaiaaaaeaaaaaaaakacaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaacpaaaaaf
hcaabaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaa
adaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaackaabaaa
aaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaa
abeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaaabaaaaah
pcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaafhcaabaaa
aaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmameamnmmamea
mnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"3.0-!!ARBfp1.0
# 51 ALU, 7 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 0.75341797, 0.24682617, 0.45454544 },
		{ 0.16666667, 255, 0.0039215689, 1 },
		{ 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
ADD R0.xyz, R1, R0;
TEX R1, R2, texture[5], CUBE;
MUL R3.x, R1.w, R1.w;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R0.xyz, R0, R2;
MUL R3.y, R1.w, R3.x;
MUL R2.xy, R3, c[7].yzzw;
ADD R0.w, R2.x, R2.y;
MUL R1.xyz, R1, R0.w;
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0, c[5].w;
MUL R2.xyz, R0, R1;
MOV R0.w, c[6].x;
MUL R0.w, R0, c[5].x;
TXP R1.xyz, fragment.texcoord[4], texture[6], 2D;
ADD R1.xyz, R1, fragment.texcoord[5];
MUL R2.xyz, R2, R0.w;
MAD R0.xyz, R0, R1, R2;
POW R0.x, R0.x, c[7].w;
POW R0.z, R0.z, c[7].w;
POW R0.y, R0.y, c[7].w;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[8].z;
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[8];
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].x;
POW result.color.y, R0.y, c[9].x;
POW result.color.z, R0.z, c[9].x;
MOV result.color.w, R0;
END
# 51 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"ps_3_0
; 60 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 0.75341797, 0.24682617, 0.45454544, 0.16666667
def c8, 255.00000000, 0.00392157, 0.00000000, 1.00000000
def c9, 2.20000005, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
mad r2.xyz, v3.x, c0, r2
add_pp r0.xyz, r1, r0
texld r1, r2, s5
mul_pp r3.x, r1.w, r1.w
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r0.xyz, r0, r2
mul_pp r3.y, r1.w, r3.x
mul_pp r2.xy, r3, c7
add_pp r0.w, r2.x, r2.y
mul_pp r1.xyz, r1, r0.w
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, c5.w
mul_pp r2.xyz, r0, r1
mov_pp r0.w, c5.x
mul_pp r0.w, c6.x, r0
texldp r1.xyz, v4, s6
mul_pp r2.xyz, r2, r0.w
add_pp r1.xyz, r1, v5
mad_pp r1.xyz, r0, r1, r2
pow r0, r1.x, c7.z
pow r2, r1.y, c7.z
mov r1.x, r0
pow r0, r1.z, c7.z
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c7.w
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.x
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.y
rcp r1.y, r0.w
cmp r1.x, -r0.w, c8.z, c8.w
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.z, r0
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
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedjoakohnagmglogffnjojjenldoepapeaabaaaaaaoeaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckmahaaaaeaaaaaaaolabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadlcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaa
abaaaaaaapaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaa
aaaaaaaaegaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaa
ogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaakgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
dcaaaaajhcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaaagaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaa
cpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaa
aaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
abaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmamea
mnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"3.0-!!ARBfp1.0
# 62 ALU, 9 TEX
PARAM c[11] = { program.local[0..7],
		{ 0, 8, 0.75341797, 0.24682617 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
ADD R1.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R2, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R1.xyz, R1, R2;
MUL R3.y, R0.w, R3.x;
MUL R2.xy, R3, c[8].zwzw;
ADD R0.w, R2.x, R2.y;
MUL R0.xyz, R0, R0.w;
MOV R0.w, c[6].x;
MUL R1.xyz, R1, c[4];
MUL R1.xyz, R1, c[5].w;
MUL R2.xyz, R1, R0;
MUL R1.w, R0, c[5].x;
MUL R3.xyz, R2, R1.w;
TEX R0, fragment.texcoord[5], texture[7], 2D;
MUL R2.xyz, R0.w, R0;
TEX R0, fragment.texcoord[5], texture[8], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].y;
DP4 R1.w, fragment.texcoord[6], fragment.texcoord[6];
RSQ R0.w, R1.w;
RCP R0.w, R0.w;
MAD R2.xyz, R2, c[8].y, -R0;
MAD_SAT R0.w, R0, c[7].z, c[7];
MAD R2.xyz, R0.w, R2, R0;
TXP R0.xyz, fragment.texcoord[4], texture[6], 2D;
ADD R0.xyz, R0, R2;
MAD R0.xyz, R1, R0, R3;
POW R0.x, R0.x, c[9].x;
POW R0.z, R0.z, c[9].x;
POW R0.y, R0.y, c[9].x;
MUL R0.xyz, R0, c[9].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[9].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[9].w;
RCP R1.z, R1.x;
SLT R1.y, c[8].x, R1.x;
MOV R0.w, c[10].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[8].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[8].x, R0;
POW result.color.x, R0.x, c[10].y;
POW result.color.y, R0.y, c[10].y;
POW result.color.z, R0.z, c[10].y;
MOV result.color.w, R0;
END
# 62 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"ps_3_0
; 69 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
dcl_2d s8
def c8, 8.00000000, 0.75341797, 0.24682617, 0.45454544
def c9, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c10, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
add_pp r1.xyz, r1, r0
mad r2.xyz, v3.x, c0, r2
texld r0, r2, s5
mul_pp r3.x, r0.w, r0.w
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r1.xyz, r1, r2
mul_pp r3.y, r0.w, r3.x
mul_pp r2.xy, r3, c8.yzzw
add_pp r0.w, r2.x, r2.y
mul_pp r2.xyz, r0, r0.w
mov_pp r0.x, c5
mul_pp r1.w, c6.x, r0.x
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, c5.w
mul_pp r2.xyz, r1, r2
mul_pp r3.xyz, r2, r1.w
texld r0, v5, s7
mul_pp r2.xyz, r0.w, r0
texld r0, v5, s8
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
dp4 r1.w, v6, v6
rsq r0.w, r1.w
rcp r0.w, r0.w
mad_pp r2.xyz, r2, c8.x, -r0
mad_sat r0.w, r0, c7.z, c7
mad_pp r2.xyz, r0.w, r2, r0
texldp r0.xyz, v4, s6
add_pp r0.xyz, r0, r2
mad_pp r1.xyz, r1, r0, r3
pow r0, r1.x, c8.w
pow r2, r1.y, c8.w
mov r1.x, r0
pow r0, r1.z, c8.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c9.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c9.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c9.z
rcp r1.y, r0.w
cmp r1.x, -r0.w, c10, c10.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c9.w, r0
pow r0, r1.x, c10.z
mov oC0.x, r0
pow r0, r1.y, c10.z
pow r2, r1.z, c10.z
mov oC0.y, r0
mov oC0.z, r2
mov oC0.w, r1
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
Vector 256 [unity_LightmapFade]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmffhgjoddpbmaododcokeijlflcoalaeabaaaaaaieakaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaneaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcdeajaaaaeaaaaaaaenacaaaafjaaaaaeegiocaaa
aaaaaaaabbaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafkaaaaad
aagabaaaahaaaaaafkaaaaadaagabaaaaiaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaafidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaa
ffffaaaafibiaaaeaahabaaaahaaaaaaffffaaaafibiaaaeaahabaaaaiaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadlcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabbaaaaah
icaabaaaaaaaaaaaegbobaaaagaaaaaaegbobaaaagaaaaaaelaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadccaaaalicaabaaaaaaaaaaadkaabaaaaaaaaaaa
ckiacaaaaaaaaaaabaaaaaaadkiacaaaaaaaaaaabaaaaaaaefaaaaajpcaabaaa
acaaaaaaogbkbaaaadaaaaaaeghobaaaaiaaaaaaaagabaaaaiaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaadaaaaaa
ogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaadaaaaaa
pgapbaaaabaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaaj
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
aoaaaaahdcaabaaaadaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaaj
pcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaa
cpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaabjaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaa
ckaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaa
aaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaaaaa
abaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaacpaaaaaf
hcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaamnmmamea
mnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 53 ALU, 8 TEX
PARAM c[10] = { program.local[0..6],
		{ 0, 8, 0.75341797, 0.24682617 },
		{ 0.45454544, 0.16666667, 255, 0.0039215689 },
		{ 1, 2.2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
TEX R3, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R3.x, R0;
MUL R1.xyz, R3.y, R1;
ADD R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R0.xyz, R3.z, R0;
ADD R1.xyz, R1, R0;
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R0.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R0, texture[5], CUBE;
MUL R3.x, R0.w, R0.w;
MUL R3.y, R0.w, R3.x;
MUL R3.xy, R3, c[7].zwzw;
ADD R0.w, R3.x, R3.y;
TEX R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R2.xyz, R3.w, R2;
ADD R1.xyz, R1, R2;
MUL R1.xyz, R1, c[4];
MUL R2.xyz, R1, c[5].w;
MUL R0.xyz, R0, R0.w;
MOV R1.x, c[6];
MUL R0.w, R1.x, c[5].x;
MUL R0.xyz, R2, R0;
MUL R3.xyz, R0, R0.w;
TEX R0, fragment.texcoord[5], texture[7], 2D;
TXP R1.xyz, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R0.w, R0;
MAD R0.xyz, R0, c[7].y, R1;
MAD R0.xyz, R2, R0, R3;
POW R0.x, R0.x, c[8].x;
POW R0.z, R0.z, c[8].x;
POW R0.y, R0.y, c[8].x;
MUL R0.xyz, R0, c[8].y;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].z;
FLR R0.w, -R0;
MUL R1.x, -R0.w, c[8].w;
RCP R1.z, R1.x;
SLT R1.y, c[7].x, R1.x;
MOV R0.w, c[9].x;
ABS R1.y, R1;
CMP R1.y, -R1, c[7].x, R0.w;
MUL_SAT R0.xyz, R0, R1.z;
MOV R0.w, R1.x;
CMP R0, -R1.y, c[7].x, R0;
POW result.color.x, R0.x, c[9].y;
POW result.color.y, R0.y, c[9].y;
POW result.color.z, R0.z, c[9].y;
MOV result.color.w, R0;
END
# 53 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 61 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 0.75341797, 0.24682617, 0.45454544
def c8, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c9, 0.00000000, 1.00000000, 2.20000005, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
mul r2.xyz, v3.z, c2
texld r3, v0, s0
texld r1.xyz, v1, s2
texld r0.xyz, v0.zwzw, s1
mul r0.xyz, r3.x, r0
mul r1.xyz, r3.y, r1
add_pp r1.xyz, r0, r1
texld r0.xyz, v1.zwzw, s3
mul r0.xyz, r3.z, r0
add_pp r1.xyz, r1, r0
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r3.x, r0.w, r0.w
mul_pp r3.y, r0.w, r3.x
texld r2.xyz, v2, s4
mul r2.xyz, r3.w, r2
add_pp r1.xyz, r1, r2
mul_pp r1.xyz, r1, c4
mov_pp r0.w, c5.x
mul_pp r2.xyz, r1, c5.w
mul_pp r3.xy, r3, c7.yzzw
add_pp r1.x, r3, r3.y
mul_pp r0.xyz, r0, r1.x
mul_pp r0.xyz, r2, r0
mul_pp r0.w, c6.x, r0
mul_pp r3.xyz, r0, r0.w
texld r0, v5, s7
texldp r1.xyz, v4, s6
mul_pp r0.xyz, r0.w, r0
mad_pp r0.xyz, r0, c7.x, r1
mad_pp r1.xyz, r2, r0, r3
pow r0, r1.x, c7.w
pow r2, r1.y, c7.w
mov r1.x, r0
pow r0, r1.z, c7.w
mov r1.z, r0
mov r1.y, r2
mul r0.xyz, r1, c8.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8.z
rcp r1.y, r0.w
cmp r1.x, -r0.w, c9, c9.y
mul_sat r0.xyz, r0, r1.y
abs_pp r1.x, r1
cmp r1, -r1.x, c8.w, r0
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
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_LINEAR" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedfcgnledhkjhdckdjompeemkgnkaaepllabaaaaaaeiajaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbaaiaaaaeaaaaaaaaeacaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
apaaaaakicaabaaaaaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaa
egaabaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaaefaaaaaj
pcaabaaaadaaaaaaogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaaj
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaa
aaaaaaaacpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaa
bjaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaadeaaaaah
icaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaa
aaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaaddaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaah
icaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaacaaaaaaddaaaaak
hcaabaaaabaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaaaaaabaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaa
cpaaaaafhcaabaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
mnmmameamnmmameamnmmameaaaaaaaaabjaaaaafhccabaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"3.0-!!ARBfp1.0
# 41 ALU, 7 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 0.16666667 },
		{ 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R3.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R2.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R0.x, R1;
ADD R0.xyz, R0, R2;
ADD R1.xyz, R0, R3;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R1.xyz, R0, c[4];
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R2, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MUL R1.xyz, R1, c[5].w;
MUL R2.xyz, R1, R0;
TXP R0.xyz, fragment.texcoord[4], texture[6], 2D;
MOV R0.w, c[6].x;
MUL R0.w, R0, c[5].x;
MUL R2.xyz, R2, R0.w;
LG2 R0.x, R0.x;
LG2 R0.z, R0.z;
LG2 R0.y, R0.y;
ADD R0.xyz, -R0, fragment.texcoord[5];
MAD R0.xyz, R1, R0, R2;
MUL R0.xyz, R0, c[7].w;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].x;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 41 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"ps_3_0
; 34 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r1.xyz, v1.zwzw, s3
mul r3.xyz, r0.z, r1
texld r2.xyz, v1, s2
mul r2.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r0.xyz, r0.x, r1
add_pp r0.xyz, r0, r2
add_pp r1.xyz, r0, r3
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r1.xyz, r1, r0
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, c5.w
mul_pp r2.xyz, r1, r0
texldp r0.xyz, v4, s6
mov_pp r0.w, c5.x
mul_pp r0.w, c6.x, r0
mul_pp r2.xyz, r2, r0.w
log_pp r0.x, r0.x
log_pp r0.z, r0.z
log_pp r0.y, r0.y
add_pp r0.xyz, -r0, v5
mad_pp r0.xyz, r1, r0, r2
mul r0.xyz, r0, c7.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7.z
cmp r1.x, -r0.w, c8, c8.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedpjapmnodkmlbagciinhmcghbefidegbnabaaaaaakeahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgmagaaaaeaaaaaaajlabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadlcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaa
ogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaakgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
dcaaaaajhcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
cpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaiaebaaaaaaacaaaaaaegbcbaaaagaaaaaadcaaaaajhcaabaaaaaaaaaaa
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
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"3.0-!!ARBfp1.0
# 52 ALU, 9 TEX
PARAM c[10] = { program.local[0..7],
		{ 0.0039215689, 1, 0, 8 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R3.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R1.xyz, R0.x, R1;
TEX R2.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R0.z, R2;
ADD R1.xyz, R1, R3;
ADD R1.xyz, R1, R2;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R1.xyz, fragment.texcoord[3].y, c[1], R2;
MUL R0.xyz, R0, c[4];
MAD R1.xyz, fragment.texcoord[3].x, c[0], R1;
MUL R2.xyz, R0, c[5].w;
TEX R0, R1, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MOV R1.x, c[6];
MUL R0.w, R1.x, c[5].x;
MUL R0.xyz, R2, R0;
MUL R3.xyz, R0, R0.w;
TEX R0, fragment.texcoord[5], texture[8], 2D;
MUL R0.xyz, R0.w, R0;
TEX R1, fragment.texcoord[5], texture[7], 2D;
DP4 R0.w, fragment.texcoord[6], fragment.texcoord[6];
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0, c[8].w;
MAD R4.xyz, R1, c[8].w, -R0;
TXP R1.xyz, fragment.texcoord[4], texture[6], 2D;
MAD_SAT R0.w, R0, c[7].z, c[7];
MAD R0.xyz, R0.w, R4, R0;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
ADD R0.xyz, -R1, R0;
MAD R0.xyz, R2, R0, R3;
MUL R0.xyz, R0, c[9].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[9].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[8].x;
SLT R1.x, c[8].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[8].z, c[8];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[8].z, R0;
END
# 52 instructions, 5 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"ps_3_0
; 43 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
dcl_2d s8
def c8, 8.00000000, 0.16666667, 255.00000000, 0.00392157
def c9, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0, v0, s0
texld r2.xyz, v1, s2
mul r3.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r1.xyz, r0.x, r1
texld r2.xyz, v1.zwzw, s3
mul r2.xyz, r0.z, r2
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r1, r2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mul r2.xyz, v3.z, c2
mul_pp r1.xyz, r0, c4
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
mul_pp r2.xyz, r1, c5.w
texld r0, r0, s5
mul_pp r3.xyz, r0, r0.w
mov_pp r1.x, c5
mul_pp r0.x, c6, r1
mul_pp r1.xyz, r2, r3
mul_pp r3.xyz, r1, r0.x
texld r0, v5, s8
mul_pp r0.xyz, r0.w, r0
texld r1, v5, s7
dp4 r0.w, v6, v6
rsq r0.w, r0.w
rcp r0.w, r0.w
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r0, c8.x
mad_pp r4.xyz, r1, c8.x, -r0
texldp r1.xyz, v4, s6
mad_sat r0.w, r0, c7.z, c7
mad_pp r0.xyz, r0.w, r4, r0
log_pp r1.x, r1.x
log_pp r1.y, r1.y
log_pp r1.z, r1.z
add_pp r0.xyz, -r1, r0
mad_pp r0.xyz, r2, r0, r3
mul r0.xyz, r0, c8.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8
cmp r1.x, -r0.w, c9, c9.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c9.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
Vector 256 [unity_LightmapFade]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbdaiggoldojinchbgelkmapinlnknmblabaaaaaaeeajaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaneaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcpeahaaaaeaaaaaaapnabaaaafjaaaaaeegiocaaa
aaaaaaaabbaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafkaaaaad
aagabaaaahaaaaaafkaaaaadaagabaaaaiaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaafidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaa
ffffaaaafibiaaaeaahabaaaahaaaaaaffffaaaafibiaaaeaahabaaaaiaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadlcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacafaaaaaabbaaaaahbcaabaaaaaaaaaaaegbobaaaagaaaaaa
egbobaaaagaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadccaaaal
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaaaaaaaaaabaaaaaaadkiacaaa
aaaaaaaabaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
aiaaaaaaaagabaaaaiaaaaaadiaaaaahccaabaaaaaaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaafgafbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaahaaaaaa
aagabaaaahaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaebdcaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
jgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaajgahbaaaaaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaa
afaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaagaaaaaaaagabaaaagaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaa
agaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaa
ahaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaaeaaaaaabkiacaaaaaaaaaaa
aiaaaaaadiaaaaaibcaabaaaacaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaa
agaaaaaadiaaaaaiccaabaaaacaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaa
ahaaaaaadiaaaaaiecaabaaaacaaaaaackbabaaaaeaaaaaackiacaaaaaaaaaaa
aiaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaibcaabaaaacaaaaaaakbabaaaaeaaaaaaakiacaaaaaaaaaaaagaaaaaa
diaaaaaiccaabaaaacaaaaaaakbabaaaaeaaaaaaakiacaaaaaaaaaaaahaaaaaa
diaaaaaiecaabaaaacaaaaaaakbabaaaaeaaaaaaakiacaaaaaaaaaaaaiaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegacbaaaabaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaadaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaaefaaaaajpcaabaaaaeaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaafgafbaaa
aeaaaaaadcaaaaajhcaabaaaacaaaaaaagaabaaaaeaaaaaaegacbaaaacaaaaaa
egacbaaaadaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaaacaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaacaaaaaakgakbaaaaeaaaaaa
egacbaaaadaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
adaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaajhcaabaaaacaaaaaa
pgapbaaaaeaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaapgipcaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaajicaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaakhcaabaaa
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
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 43 ALU, 8 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 8 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R3.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R1.xyz, R0.x, R1;
TEX R2.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R0.z, R2;
ADD R1.xyz, R1, R3;
ADD R1.xyz, R1, R2;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R1.xyz, fragment.texcoord[3].y, c[1], R2;
MUL R0.xyz, R0, c[4];
MAD R1.xyz, fragment.texcoord[3].x, c[0], R1;
MUL R2.xyz, R0, c[5].w;
TEX R0, R1, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MOV R1.x, c[6];
MUL R0.w, R1.x, c[5].x;
TXP R1.xyz, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R2, R0;
MUL R3.xyz, R0, R0.w;
TEX R0, fragment.texcoord[5], texture[7], 2D;
MUL R0.xyz, R0.w, R0;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
MAD R0.xyz, R0, c[7].w, -R1;
MAD R0.xyz, R2, R0, R3;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 43 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 35 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 0.16666667, 255.00000000, 0.00392157
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0, v0, s0
texld r2.xyz, v1, s2
mul r3.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r1.xyz, r0.x, r1
texld r2.xyz, v1.zwzw, s3
mul r2.xyz, r0.z, r2
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r1, r2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mul r2.xyz, v3.z, c2
mul_pp r1.xyz, r0, c4
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
mul_pp r2.xyz, r1, c5.w
texld r0, r0, s5
mul_pp r3.xyz, r0, r0.w
mov_pp r1.x, c5
mul_pp r0.x, c6, r1
mul_pp r1.xyz, r2, r3
mul_pp r3.xyz, r1, r0.x
texldp r1.xyz, v4, s6
texld r0, v5, s7
mul_pp r0.xyz, r0.w, r0
log_pp r1.x, r1.x
log_pp r1.y, r1.y
log_pp r1.z, r1.z
mad_pp r0.xyz, r0, c7.x, -r1
mad_pp r0.xyz, r2, r0, r3
mul r0.xyz, r0, c7.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7
cmp r1.x, -r0.w, c8, c8.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c8.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "MARMO_GAMMA" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedjmmhpncmobfkjckgjhmdilniapgglkkhabaaaaaaaiaiaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcnaagaaaaeaaaaaaaleabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaacpaaaaaf
hcaabaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaa
adaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaahicaabaaaaaaaaaaa
dkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdo
aaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaa
decaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaa
abeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaa
aaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaa
agaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaa
aaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"3.0-!!ARBfp1.0
# 38 ALU, 7 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 0.16666667 },
		{ 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R3.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R2.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R0.x, R1;
ADD R0.xyz, R0, R2;
ADD R1.xyz, R0, R3;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R1.xyz, R0, c[4];
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R2, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MUL R1.xyz, R1, c[5].w;
MUL R2.xyz, R1, R0;
MOV R0.w, c[6].x;
MUL R0.w, R0, c[5].x;
TXP R0.xyz, fragment.texcoord[4], texture[6], 2D;
MUL R2.xyz, R2, R0.w;
ADD R0.xyz, R0, fragment.texcoord[5];
MAD R0.xyz, R1, R0, R2;
MUL R0.xyz, R0, c[7].w;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].x;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 38 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
"ps_3_0
; 31 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
def c7, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
texld r0, v0, s0
texld r1.xyz, v1.zwzw, s3
mul r3.xyz, r0.z, r1
texld r2.xyz, v1, s2
mul r2.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r0.xyz, r0.x, r1
add_pp r0.xyz, r0, r2
add_pp r1.xyz, r0, r3
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
mad r1.xyz, v3.x, c0, r2
mul_pp r0.xyz, r0, c4
texld r1, r1, s5
mov_pp r0.w, c5.x
mul_pp r0.xyz, r0, c5.w
mul_pp r1.xyz, r1, r1.w
mul_pp r2.xyz, r0, r1
mul_pp r0.w, c6.x, r0
texldp r1.xyz, v4, s6
add_pp r1.xyz, r1, v5
mul_pp r2.xyz, r2, r0.w
mad_pp r0.xyz, r0, r1, r2
mul r0.xyz, r0, c7.x
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.y
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7.z
cmp r1.x, -r0.w, c8, c8.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c7.w, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
ConstBuffer "$Globals" 256
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedfmcjphcekfiggpdkioeldkjkeedanbanabaaaaaaimahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfeagaaaaeaaaaaaajfabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaaeaahabaaaafaaaaaa
ffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadlcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaa
aeaaaaaabkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
aeaaaaaackiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaa
akiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaa
adaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaa
ogbkbaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaakgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
dcaaaaajhcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaajicaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaaagaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
aaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaa
aaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaa
pgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"3.0-!!ARBfp1.0
# 49 ALU, 9 TEX
PARAM c[10] = { program.local[0..7],
		{ 0.0039215689, 1, 0, 8 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R3.xyz, R0.z, R1;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R2.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0.xyz, R0.x, R1;
ADD R0.xyz, R0, R2;
ADD R1.xyz, R0, R3;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R1.xyz, R0, c[4];
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R2.xyz, fragment.texcoord[3].y, c[1], R2;
MAD R2.xyz, fragment.texcoord[3].x, c[0], R2;
TEX R0, R2, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MUL R1.xyz, R1, c[5].w;
MOV R0.w, c[6].x;
MUL R2.xyz, R1, R0;
MUL R1.w, R0, c[5].x;
MUL R3.xyz, R2, R1.w;
TEX R0, fragment.texcoord[5], texture[7], 2D;
MUL R2.xyz, R0.w, R0;
TEX R0, fragment.texcoord[5], texture[8], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].w;
DP4 R1.w, fragment.texcoord[6], fragment.texcoord[6];
RSQ R0.w, R1.w;
RCP R0.w, R0.w;
MAD R2.xyz, R2, c[8].w, -R0;
MAD_SAT R0.w, R0, c[7].z, c[7];
MAD R2.xyz, R0.w, R2, R0;
TXP R0.xyz, fragment.texcoord[4], texture[6], 2D;
ADD R0.xyz, R0, R2;
MAD R0.xyz, R1, R0, R3;
MUL R0.xyz, R0, c[9].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[9].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[8].x;
SLT R1.x, c[8].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[8].z, c[8];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[8].z, R0;
END
# 49 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
"ps_3_0
; 40 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
dcl_2d s8
def c8, 8.00000000, 0.16666667, 255.00000000, 0.00392157
def c9, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0, v0, s0
texld r1.xyz, v1.zwzw, s3
mul r3.xyz, r0.z, r1
texld r2.xyz, v1, s2
mul r2.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r0.xyz, r0.x, r1
add_pp r0.xyz, r0, r2
add_pp r1.xyz, r0, r3
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r1.xyz, r1, r0
mul r2.xyz, v3.z, c2
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
texld r0, r0, s5
mul_pp r2.xyz, r0, r0.w
mov_pp r0.x, c5
mul_pp r1.w, c6.x, r0.x
texld r0, v5, s7
mul_pp r3.xyz, r0.w, r0
texld r0, v5, s8
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.x
mul_pp r1.xyz, r1, c4
mul_pp r1.xyz, r1, c5.w
mul_pp r2.xyz, r1, r2
mul_pp r2.xyz, r2, r1.w
dp4 r1.w, v6, v6
rsq r0.w, r1.w
rcp r0.w, r0.w
mad_pp r3.xyz, r3, c8.x, -r0
mad_sat r0.w, r0, c7.z, c7
mad_pp r3.xyz, r0.w, r3, r0
texldp r0.xyz, v4, s6
add_pp r0.xyz, r0, r3
mad_pp r0.xyz, r1, r0, r2
mul r0.xyz, r0, c8.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c8.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c8
cmp r1.x, -r0.w, c9, c9.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c9.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
SetTexture 8 [unity_LightmapInd] 2D 8
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
Vector 256 [unity_LightmapFade]
BindCB  "$Globals" 0
"ps_4_0
eefiecedmkmconnhikilccleknfgdpiolbbnciliabaaaaaacmajaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaneaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaaneaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaagaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcnmahaaaaeaaaaaaaphabaaaafjaaaaaeegiocaaa
aaaaaaaabbaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaaagaaaaaafkaaaaad
aagabaaaahaaaaaafkaaaaadaagabaaaaiaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaafidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaa
ffffaaaafibiaaaeaahabaaaahaaaaaaffffaaaafibiaaaeaahabaaaaiaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadlcbabaaaafaaaaaagcbaaaadpcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabbaaaaah
icaabaaaaaaaaaaaegbobaaaagaaaaaaegbobaaaagaaaaaaelaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadccaaaalicaabaaaaaaaaaaadkaabaaaaaaaaaaa
ckiacaaaaaaaaaaabaaaaaaadkiacaaaaaaaaaaabaaaaaaaefaaaaajpcaabaaa
acaaaaaaogbkbaaaadaaaaaaeghobaaaaiaaaaaaaagabaaaaiaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaapgapbaaaabaaaaaaefaaaaajpcaabaaaadaaaaaa
ogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaadaaaaaa
pgapbaaaabaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaaj
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
aoaaaaahdcaabaaaadaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaaj
pcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaa
diaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdo
klkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
aaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaa
aaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaa
pgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"3.0-!!ARBfp1.0
# 40 ALU, 8 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.0039215689, 1, 0, 8 },
		{ 0.16666667, 255 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R3.xyz, R0.y, R2;
TEX R1.xyz, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R1.xyz, R0.x, R1;
TEX R2.xyz, fragment.texcoord[1].zwzw, texture[3], 2D;
MUL R2.xyz, R0.z, R2;
ADD R1.xyz, R1, R3;
ADD R1.xyz, R1, R2;
TEX R0.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
ADD R0.xyz, R1, R0;
MUL R2.xyz, fragment.texcoord[3].z, c[2];
MAD R1.xyz, fragment.texcoord[3].y, c[1], R2;
MUL R0.xyz, R0, c[4];
MAD R1.xyz, fragment.texcoord[3].x, c[0], R1;
MUL R2.xyz, R0, c[5].w;
TEX R0, R1, texture[5], CUBE;
MUL R0.xyz, R0, R0.w;
MOV R1.x, c[6];
MUL R0.w, R1.x, c[5].x;
MUL R0.xyz, R2, R0;
MUL R3.xyz, R0, R0.w;
TEX R0, fragment.texcoord[5], texture[7], 2D;
TXP R1.xyz, fragment.texcoord[4], texture[6], 2D;
MUL R0.xyz, R0.w, R0;
MAD R0.xyz, R0, c[7].w, R1;
MAD R0.xyz, R2, R0, R3;
MUL R0.xyz, R0, c[8].x;
MAX R0.w, R0.x, R0.y;
MAX_SAT R0.w, R0, R0.z;
MUL R0.w, R0, c[8].y;
FLR R0.w, -R0;
MUL R0.w, -R0, c[7].x;
SLT R1.x, c[7].z, R0.w;
ABS R1.y, R1.x;
RCP R1.x, R0.w;
CMP R1.y, -R1, c[7].z, c[7];
MUL_SAT R0.xyz, R0, R1.x;
CMP result.color, -R1.y, c[7].z, R0;
END
# 40 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
Matrix 0 [SkyMatrix]
Vector 4 [_Color]
Vector 5 [ExposureIBL]
Vector 6 [UniformOcclusion]
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
"ps_3_0
; 32 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
dcl_2d s6
dcl_2d s7
def c7, 8.00000000, 0.16666667, 255.00000000, 0.00392157
def c8, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0, v0, s0
texld r2.xyz, v1, s2
mul r3.xyz, r0.y, r2
texld r1.xyz, v0.zwzw, s1
mul r1.xyz, r0.x, r1
texld r2.xyz, v1.zwzw, s3
mul r2.xyz, r0.z, r2
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r1, r2
texld r0.xyz, v2, s4
mul r0.xyz, r0.w, r0
add_pp r0.xyz, r1, r0
mul r2.xyz, v3.z, c2
mul_pp r1.xyz, r0, c4
mad r2.xyz, v3.y, c1, r2
mad r0.xyz, v3.x, c0, r2
mul_pp r2.xyz, r1, c5.w
texld r0, r0, s5
mul_pp r3.xyz, r0, r0.w
mov_pp r1.x, c5
mul_pp r0.x, c6, r1
mul_pp r1.xyz, r2, r3
mul_pp r3.xyz, r1, r0.x
texld r0, v5, s7
texldp r1.xyz, v4, s6
mul_pp r0.xyz, r0.w, r0
mad_pp r0.xyz, r0, c7.x, r1
mad_pp r0.xyz, r2, r0, r3
mul r0.xyz, r0, c7.y
max r0.w, r0.x, r0.y
max_sat r0.w, r0, r0.z
mul r0.w, r0, c7.z
frc r1.x, -r0.w
add r0.w, -r0, -r1.x
mul r0.w, -r0, c7
cmp r1.x, -r0.w, c8, c8.y
rcp r1.y, r0.w
abs_pp r1.x, r1
mul_sat r0.xyz, r0, r1.y
cmp oC0, -r1.x, c8.x, r0
"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" "MARMO_GAMMA" }
SetTexture 0 [_Control] 2D 0
SetTexture 1 [_Splat0] 2D 1
SetTexture 2 [_Splat1] 2D 2
SetTexture 3 [_Splat2] 2D 3
SetTexture 4 [_Splat3] 2D 4
SetTexture 5 [_DiffCubeIBL] CUBE 5
SetTexture 6 [_LightBuffer] 2D 6
SetTexture 7 [unity_Lightmap] 2D 7
ConstBuffer "$Globals" 288
Matrix 96 [SkyMatrix]
Vector 48 [_Color]
Vector 64 [ExposureIBL]
Vector 80 [UniformOcclusion] 2
BindCB  "$Globals" 0
"ps_4_0
eefiecedncnlfojmamgmonmgmceioneiejmfeledabaaaaaapaahaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcliagaaaaeaaaaaaakoabaaaa
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaafkaaaaadaagabaaa
agaaaaaafkaaaaadaagabaaaahaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fidaaaaeaahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaa
fibiaaaeaahabaaaahaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaabkbabaaaaeaaaaaa
bkiacaaaaaaaaaaaaiaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaaeaaaaaa
ckiacaaaaaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaaeaaaaaaakiacaaa
aaaaaaaaaiaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaaefaaaaajpcaabaaaaaaaaaaaegacbaaaaaaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaafgafbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaagaabaaaadaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
acaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaabaaaaaa
kgakbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaaj
hcaabaaaabaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaa
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaj
icaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaagaaaaaaaagabaaaagaaaaaaefaaaaaj
pcaabaaaadaaaaaaogbkbaaaadaaaaaaeghobaaaahaaaaaaaagabaaaahaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaaj
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaaegacbaaa
aaaaaaaadiaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdo
klkkckdoklkkckdoaaaaaaaadeaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadecaaaahicaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahped
ecaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaadkaabaaaaaaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaa
egacbaaaaaaaaaaaagaabaaaacaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaa
abaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
}
 }
}
Fallback "Hidden/Marmoset/RGBM Tree"
}