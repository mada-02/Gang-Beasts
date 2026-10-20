Shader "Hidden/GlobalFog" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "black" {}
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [_FrustumCornersWS]
"!!ARBvp1.0
# 11 ALU
PARAM c[9] = { { 0.1 },
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
ADDRESS A0;
ARL A0.x, vertex.position.z;
MOV R0.xyw, vertex.position;
MOV R0.z, c[0].x;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MOV result.texcoord[2].xyz, c[A0.x + 5];
MOV result.texcoord[0].xy, vertex.texcoord[0];
MOV result.texcoord[1].xy, vertex.texcoord[0];
MOV result.texcoord[2].w, vertex.position.z;
END
# 11 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_FrustumCornersWS]
Vector 8 [_MainTex_TexelSize]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_texcoord0 v1
def c9, 0.10000000, 0.00000000, 1.00000000, 0
mov r1.x, c9.y
slt r1.x, c8.y, r1
max r1.x, -r1, r1
mova a0.x, v0.z
mov r0.xyw, v0
mov r0.z, c9.x
dp4 oPos.w, r0, c3
dp4 oPos.z, r0, c2
dp4 oPos.y, r0, c1
slt r1.x, c9.y, r1
dp4 oPos.x, r0, c0
add r0.x, -r1, c9.z
mul r0.y, v1, r0.x
add r0.x, -v1.y, c9.z
mad oT0.y, r1.x, r0.x, r0
mov oT2.xyz, c[a0.x + 4]
mov oT1.xy, v1
mov oT0.x, v1
mov oT2.w, v0.z
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedclkpljmcdnkhlgjkcnphehfieklbffpgabaaaaaaiiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaafeeffied
epepfceeaaklklklfdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaan
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdn
mnmmmmdnmnmmmmdnegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaa
aaaaaaaabkiacaaaaaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaa
aaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaa
abaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaaf
nccabaaaabaaaaaaagbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaa
aaaaaaaablaaaaafbcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaa
acaaaaaaegiocaaaaaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaaj
cccabaaaacaaaaaaegiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaa
bbaaaaajeccabaaaacaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaa
aaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedcgdcohjlkhgclkcgjimhoojfofjnbcamabaaaaaanmafaaaaaeaaaaaa
daaaaaaaiaacaaaaaaafaaaafeafaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
aiacaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaafaa
aeaaagaaaaaaaaaaabaaaaaaaeaaakaaaaaaaaaaaaaaafaaaaacpoppfbaaaaaf
aeaaapkamnmmmmdnaaaaaamaaaaaiadpaaaaaaaafbaaaaafaaaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaafbaaaaafabaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaafbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaafbaaaaaf
adaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaaciaagaaffkaamaaaaadaaaaabia
aaaaffiaaaaappkaaeaaaaaeaaaaaciaabaaffjaaeaaffkaaeaakkkaaeaaaaae
aaaaacoaaaaaaaiaaaaaffiaabaaffjaamaaaaadaaaaabiaaaaakkjaaaaakkjb
bdaaaaacaaaaaciaaaaakkjaacaaaaadaaaaaeiaaaaaffibaaaakkjaamaaaaad
aaaaaciaaaaaffibaaaaffiaaeaaaaaeaaaaabiaaaaaaaiaaaaaffiaaaaakkia
coaaaaacaaaaablaaaaaaaiaabaaaaadaaaaapiaaacaoekaaaaaaalaajaaaaad
abaaaboaahaaoekaaaaaoeiaajaaaaadabaaacoaaiaaoekaaaaaoeiaajaaaaad
abaaaeoaajaaoekaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaae
aaaaapiaakaaoekaaaaaaajaaaaaoeiaabaaaaacabaaabiaaeaaaakaaeaaaaae
aaaaapiaamaaoekaabaaaaiaaaaaoeiaaeaaaaaeaaaaapiaanaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaafaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaabaaaaacaaaaanoaabaabejaabaaaaacabaaaioaaaaakkjappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpfjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaanpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdnmnmmmmdnmnmmmmdn
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaabkiacaaa
aaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaaaaaaaaaabkbabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaaabaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaafnccabaaaabaaaaaa
agbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaaaaaaaaaablaaaaaf
bcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaaacaaaaaaegiocaaa
aaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajcccabaaaacaaaaaa
egiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajeccabaaa
acaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaaaaaaaaaadoaaaaab
ejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
faepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ZBufferParams]
Float 1 [_GlobalDensity]
Vector 2 [_FogColor]
Vector 3 [_StartDistance]
Vector 4 [_Y]
Vector 5 [_CameraWS]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 2 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 2.718282, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.x, fragment.texcoord[1], texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[1], 2D;
MAD R1.x, R1, c[0], c[0].y;
RCP R1.x, R1.x;
MUL R2.xyz, R1.x, fragment.texcoord[2];
DP3 R1.x, R2, R2;
RSQ R2.x, R1.x;
RCP R2.x, R2.x;
ADD R2.y, R2, c[5];
MUL R2.x, R2, c[3];
ADD R2.y, R2, -c[4].x;
ADD_SAT R2.x, R2, -c[6];
MUL R2.y, R2, c[4];
MUL R2.x, R2, c[3].y;
MAX R2.y, R2, c[6].z;
MUL R2.x, R2, -c[1];
MUL R2.y, R2, R2;
POW R2.x, c[6].y, R2.x;
ADD R1, -R0, c[2];
POW R2.y, c[6].y, -R2.y;
ADD R2.x, -R2, c[6];
MUL R2.x, R2, R2.y;
MAD result.color, R2.x, R1, R0;
END
# 23 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Float 1 [_GlobalDensity]
Vector 2 [_FogColor]
Vector 3 [_StartDistance]
Vector 4 [_Y]
Vector 5 [_CameraWS]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
; 27 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c6, -1.00000000, 0.00000000, 2.71828198, 1.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xyz
texld r0, t1, s0
texld r2, t0, s1
mad r0.x, r0, c0, c0.y
rcp r0.x, r0.x
mul r0.xyz, r0.x, t2
dp3 r0.x, r0, r0
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r1.x, r0, c3
add r0.y, r0, c5
add r0.x, r0.y, -c4
add_sat r1.x, r1, c6
mul r0.x, r0, c4.y
mul r1.x, r1, c3.y
mul r1.x, r1, -c1
pow r3.x, c6.z, r1.x
max r0.x, r0, c6.y
mul r0.x, r0, r0
pow r1.x, c6.z, -r0.x
mov r0.x, r3.x
add r4, -r2, c2
add r0.x, -r0, c6.w
mul r0.x, r0, r1.x
mad r0, r0.x, r4, r2
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Float 16 [_GlobalDensity]
Vector 32 [_FogColor]
Vector 48 [_StartDistance]
Vector 64 [_Y]
Vector 160 [_CameraWS]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedgdfbgnhjfphpdalchopcabcdlgjchimbabaaaaaagiaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapahaaaafdfgfpfa
gphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefchiadaaaaeaaaaaaanoaaaaaafjaaaaaeegiocaaa
aaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaaabaaaaaa
ahaaaaaaakaabaaaaaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaa
diaaaaahocaabaaaaaaaaaaaagaabaaaaaaaaaaaagbjbaaaacaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkbabaaaacaaaaaabkiacaaaaaaaaaaa
akaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaaeaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaabkiacaaa
aaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklilpbjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaajgahbaaa
aaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
dccaaaakccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaa
abeaaaaaaaaaialpdiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaabkiacaaa
aaaaaaaaadaaaaaadiaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaabaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
abeaaaaadlkklidpbjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaai
ccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaaj
pcaabaaaacaaaaaaegaobaiaebaaaaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaa
dcaaaaajpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Float 16 [_GlobalDensity]
Vector 32 [_FogColor]
Vector 48 [_StartDistance]
Vector 64 [_Y]
Vector 160 [_CameraWS]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0_level_9_1
eefiecedcnmcpkdnnofjcnlihajmdlchhgddhhmmabaaaaaakeagaaaaaeaaaaaa
daaaaaaagiacaaaaoiafaaaahaagaaaaebgpgodjdaacaaaadaacaaaaaaacpppp
oaabaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaabaaaaaa
aaababaaaaaaabaaaeaaaaaaaaaaaaaaaaaaakaaabaaaeaaaaaaaaaaabaaahaa
abaaafaaaaaaaaaaaaacppppfbaaaaafagaaapkaaaaaialpaaaaaaaadlkklidp
aaaaiadpbpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaaplabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaabaaaaacaaaaadiaaaaablla
ecaaaaadaaaaapiaaaaaoeiaabaioekaecaaaaadabaaapiaaaaaoelaaaaioeka
aeaaaaaeaaaaabiaafaaaakaaaaaaaiaafaaffkaagaaaaacaaaaabiaaaaaaaia
afaaaaadacaaahiaaaaaaaiaabaaoelaaeaaaaaeacaaaiiaaaaaaaiaabaaffla
aeaaffkaacaaaaadacaaaiiaacaappiaadaaaakbafaaaaadacaaaiiaacaappia
adaaffkaalaaaaadaaaaabiaacaappiaagaaffkaafaaaaadacaaaiiaaaaaaaia
aaaaaaiaafaaaaadacaaaiiaacaappiaagaakkkbaoaaaaacacaaaiiaacaappia
aiaaaaadaaaaabiaacaaoeiaacaaoeiaahaaaaacaaaaabiaaaaaaaiaagaaaaac
aaaaabiaaaaaaaiaabaaaaacacaaabiaagaaaakaaeaaaaaeaaaabbiaaaaaaaia
acaaaakaacaaaaiaafaaaaadaaaaabiaaaaaaaiaacaaffkaafaaaaadaaaaabia
aaaaaaiaaaaaaakbafaaaaadaaaaabiaaaaaaaiaagaakkkaaoaaaaacaaaaabia
aaaaaaiaacaaaaadaaaaabiaaaaaaaibagaappkaafaaaaadaaaaabiaacaappia
aaaaaaiabcaaaaaeacaacpiaaaaaaaiaabaaoekaabaaoeiaabaaaaacaaaicpia
acaaoeiappppaaaafdeieefchiadaaaaeaaaaaaanoaaaaaafjaaaaaeegiocaaa
aaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaaabaaaaaa
ahaaaaaaakaabaaaaaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaa
diaaaaahocaabaaaaaaaaaaaagaabaaaaaaaaaaaagbjbaaaacaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkbabaaaacaaaaaabkiacaaaaaaaaaaa
akaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaiaebaaaaaa
aaaaaaaaaeaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaabkiacaaa
aaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklilpbjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaajgahbaaa
aaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
dccaaaakccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaa
abeaaaaaaaaaialpdiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaabkiacaaa
aaaaaaaaadaaaaaadiaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaabaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
abeaaaaadlkklidpbjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaai
ccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaaj
pcaabaaaacaaaaaaegaobaiaebaaaaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaa
dcaaaaajpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
abaaaaaadoaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapahaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
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
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [_FrustumCornersWS]
"!!ARBvp1.0
# 11 ALU
PARAM c[9] = { { 0.1 },
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
ADDRESS A0;
ARL A0.x, vertex.position.z;
MOV R0.xyw, vertex.position;
MOV R0.z, c[0].x;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MOV result.texcoord[2].xyz, c[A0.x + 5];
MOV result.texcoord[0].xy, vertex.texcoord[0];
MOV result.texcoord[1].xy, vertex.texcoord[0];
MOV result.texcoord[2].w, vertex.position.z;
END
# 11 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_FrustumCornersWS]
Vector 8 [_MainTex_TexelSize]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_texcoord0 v1
def c9, 0.10000000, 0.00000000, 1.00000000, 0
mov r1.x, c9.y
slt r1.x, c8.y, r1
max r1.x, -r1, r1
mova a0.x, v0.z
mov r0.xyw, v0
mov r0.z, c9.x
dp4 oPos.w, r0, c3
dp4 oPos.z, r0, c2
dp4 oPos.y, r0, c1
slt r1.x, c9.y, r1
dp4 oPos.x, r0, c0
add r0.x, -r1, c9.z
mul r0.y, v1, r0.x
add r0.x, -v1.y, c9.z
mad oT0.y, r1.x, r0.x, r0
mov oT2.xyz, c[a0.x + 4]
mov oT1.xy, v1
mov oT0.x, v1
mov oT2.w, v0.z
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedclkpljmcdnkhlgjkcnphehfieklbffpgabaaaaaaiiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaafeeffied
epepfceeaaklklklfdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaan
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdn
mnmmmmdnmnmmmmdnegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaa
aaaaaaaabkiacaaaaaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaa
aaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaa
abaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaaf
nccabaaaabaaaaaaagbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaa
aaaaaaaablaaaaafbcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaa
acaaaaaaegiocaaaaaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaaj
cccabaaaacaaaaaaegiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaa
bbaaaaajeccabaaaacaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaa
aaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedcgdcohjlkhgclkcgjimhoojfofjnbcamabaaaaaanmafaaaaaeaaaaaa
daaaaaaaiaacaaaaaaafaaaafeafaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
aiacaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaafaa
aeaaagaaaaaaaaaaabaaaaaaaeaaakaaaaaaaaaaaaaaafaaaaacpoppfbaaaaaf
aeaaapkamnmmmmdnaaaaaamaaaaaiadpaaaaaaaafbaaaaafaaaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaafbaaaaafabaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaafbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaafbaaaaaf
adaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaaciaagaaffkaamaaaaadaaaaabia
aaaaffiaaaaappkaaeaaaaaeaaaaaciaabaaffjaaeaaffkaaeaakkkaaeaaaaae
aaaaacoaaaaaaaiaaaaaffiaabaaffjaamaaaaadaaaaabiaaaaakkjaaaaakkjb
bdaaaaacaaaaaciaaaaakkjaacaaaaadaaaaaeiaaaaaffibaaaakkjaamaaaaad
aaaaaciaaaaaffibaaaaffiaaeaaaaaeaaaaabiaaaaaaaiaaaaaffiaaaaakkia
coaaaaacaaaaablaaaaaaaiaabaaaaadaaaaapiaaacaoekaaaaaaalaajaaaaad
abaaaboaahaaoekaaaaaoeiaajaaaaadabaaacoaaiaaoekaaaaaoeiaajaaaaad
abaaaeoaajaaoekaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaae
aaaaapiaakaaoekaaaaaaajaaaaaoeiaabaaaaacabaaabiaaeaaaakaaeaaaaae
aaaaapiaamaaoekaabaaaaiaaaaaoeiaaeaaaaaeaaaaapiaanaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaafaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaabaaaaacaaaaanoaabaabejaabaaaaacabaaaioaaaaakkjappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpfjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaanpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdnmnmmmmdnmnmmmmdn
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaabkiacaaa
aaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaaaaaaaaaabkbabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaaabaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaafnccabaaaabaaaaaa
agbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaaaaaaaaaablaaaaaf
bcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaaacaaaaaaegiocaaa
aaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajcccabaaaacaaaaaa
egiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajeccabaaa
acaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaaaaaaaaaadoaaaaab
ejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
faepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ZBufferParams]
Vector 1 [_FogColor]
Vector 2 [_Y]
Vector 3 [_CameraWS]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 12 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 2.718282, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.x, fragment.texcoord[1], texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[1], 2D;
MAD R1.x, R1, c[0], c[0].y;
RCP R1.x, R1.x;
MAD R1.x, R1, fragment.texcoord[2].y, c[3].y;
ADD R1.x, R1, -c[2];
MUL R1.x, R1, c[2].y;
MAX R1.x, R1, c[4].y;
MUL R2.x, R1, R1;
ADD R1, -R0, c[1];
POW R2.x, c[4].x, -R2.x;
MAD result.color, R2.x, R1, R0;
END
# 12 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Vector 1 [_FogColor]
Vector 2 [_Y]
Vector 3 [_CameraWS]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
; 13 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00000000, 2.71828198, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r0, t1, s0
texld r1, t0, s1
mad r0.x, r0, c0, c0.y
rcp r0.x, r0.x
mad r0.y, r0.x, t2, c3
add r0.x, r0.y, -c2
mul r0.x, r0, c2.y
max r0.x, r0, c4
mul r0.x, r0, r0
pow r2.x, c4.y, -r0.x
add r0, -r1, c1
mad r0, r2.x, r0, r1
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Vector 32 [_FogColor]
Vector 64 [_Y]
Vector 160 [_CameraWS]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedhgnfgnejiadhmmcoddlpkjiafjmjbpehabaaaaaaeeadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapacaaaafdfgfpfa
gphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcfeacaaaaeaaaaaaajfaaaaaafjaaaaaeegiocaaa
aaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadccbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaaabaaaaaa
ahaaaaaaakaabaaaaaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkbabaaaacaaaaaabkiacaaa
aaaaaaaaakaaaaaaaaaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaaeaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklilp
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajpcaabaaa
acaaaaaaegaobaiaebaaaaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaadcaaaaaj
pccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaaabaaaaaa
doaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Vector 32 [_FogColor]
Vector 64 [_Y]
Vector 160 [_CameraWS]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0_level_9_1
eefiecedaijmgkbiofnnbhmailldhdhcbnfngeadabaaaaaaniaeaaaaaeaaaaaa
daaaaaaamaabaaaabmaeaaaakeaeaaaaebgpgodjiiabaaaaiiabaaaaaaacpppp
cmabaaaafmaaaaaaaeaacmaaaaaafmaaaaaafmaaacaaceaaaaaafmaaabaaaaaa
aaababaaaaaaacaaabaaaaaaaaaaaaaaaaaaaeaaabaaabaaaaaaaaaaaaaaakaa
abaaacaaaaaaaaaaabaaahaaabaaadaaaaaaaaaaaaacppppfbaaaaafaeaaapka
aaaaaaaadlkklilpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaac
aaaaaaiaabaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
abaaaaacaaaaadiaaaaabllaecaaaaadaaaaapiaaaaaoeiaabaioekaecaaaaad
abaaapiaaaaaoelaaaaioekaaeaaaaaeaaaaabiaadaaaakaaaaaaaiaadaaffka
agaaaaacaaaaabiaaaaaaaiaaeaaaaaeaaaaabiaaaaaaaiaabaafflaacaaffka
acaaaaadaaaaabiaaaaaaaiaabaaaakbafaaaaadaaaaabiaaaaaaaiaabaaffka
alaaaaadacaaaiiaaaaaaaiaaeaaaakaafaaaaadaaaaabiaacaappiaacaappia
afaaaaadaaaaabiaaaaaaaiaaeaaffkaaoaaaaacaaaaabiaaaaaaaiabcaaaaae
acaacpiaaaaaaaiaaaaaoekaabaaoeiaabaaaaacaaaicpiaacaaoeiappppaaaa
fdeieefcfeacaaaaeaaaaaaajfaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaadccbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkbabaaaacaaaaaabkiacaaaaaaaaaaaakaaaaaa
aaaaaaajbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaa
aeaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaabkiacaaaaaaaaaaa
aeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklilpbjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajpcaabaaaacaaaaaaegaobaia
ebaaaaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaadcaaaaajpccabaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheo
iaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaheaaaaaa
abaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaheaaaaaaacaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapacaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
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
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [_FrustumCornersWS]
"!!ARBvp1.0
# 11 ALU
PARAM c[9] = { { 0.1 },
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
ADDRESS A0;
ARL A0.x, vertex.position.z;
MOV R0.xyw, vertex.position;
MOV R0.z, c[0].x;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MOV result.texcoord[2].xyz, c[A0.x + 5];
MOV result.texcoord[0].xy, vertex.texcoord[0];
MOV result.texcoord[1].xy, vertex.texcoord[0];
MOV result.texcoord[2].w, vertex.position.z;
END
# 11 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_FrustumCornersWS]
Vector 8 [_MainTex_TexelSize]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_texcoord0 v1
def c9, 0.10000000, 0.00000000, 1.00000000, 0
mov r1.x, c9.y
slt r1.x, c8.y, r1
max r1.x, -r1, r1
mova a0.x, v0.z
mov r0.xyw, v0
mov r0.z, c9.x
dp4 oPos.w, r0, c3
dp4 oPos.z, r0, c2
dp4 oPos.y, r0, c1
slt r1.x, c9.y, r1
dp4 oPos.x, r0, c0
add r0.x, -r1, c9.z
mul r0.y, v1, r0.x
add r0.x, -v1.y, c9.z
mad oT0.y, r1.x, r0.x, r0
mov oT2.xyz, c[a0.x + 4]
mov oT1.xy, v1
mov oT0.x, v1
mov oT2.w, v0.z
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedclkpljmcdnkhlgjkcnphehfieklbffpgabaaaaaaiiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaafeeffied
epepfceeaaklklklfdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaan
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdn
mnmmmmdnmnmmmmdnegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaa
aaaaaaaabkiacaaaaaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaa
aaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaa
abaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaaf
nccabaaaabaaaaaaagbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaa
aaaaaaaablaaaaafbcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaa
acaaaaaaegiocaaaaaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaaj
cccabaaaacaaaaaaegiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaa
bbaaaaajeccabaaaacaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaa
aaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedcgdcohjlkhgclkcgjimhoojfofjnbcamabaaaaaanmafaaaaaeaaaaaa
daaaaaaaiaacaaaaaaafaaaafeafaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
aiacaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaafaa
aeaaagaaaaaaaaaaabaaaaaaaeaaakaaaaaaaaaaaaaaafaaaaacpoppfbaaaaaf
aeaaapkamnmmmmdnaaaaaamaaaaaiadpaaaaaaaafbaaaaafaaaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaafbaaaaafabaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaafbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaafbaaaaaf
adaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaaciaagaaffkaamaaaaadaaaaabia
aaaaffiaaaaappkaaeaaaaaeaaaaaciaabaaffjaaeaaffkaaeaakkkaaeaaaaae
aaaaacoaaaaaaaiaaaaaffiaabaaffjaamaaaaadaaaaabiaaaaakkjaaaaakkjb
bdaaaaacaaaaaciaaaaakkjaacaaaaadaaaaaeiaaaaaffibaaaakkjaamaaaaad
aaaaaciaaaaaffibaaaaffiaaeaaaaaeaaaaabiaaaaaaaiaaaaaffiaaaaakkia
coaaaaacaaaaablaaaaaaaiaabaaaaadaaaaapiaaacaoekaaaaaaalaajaaaaad
abaaaboaahaaoekaaaaaoeiaajaaaaadabaaacoaaiaaoekaaaaaoeiaajaaaaad
abaaaeoaajaaoekaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaae
aaaaapiaakaaoekaaaaaaajaaaaaoeiaabaaaaacabaaabiaaeaaaakaaeaaaaae
aaaaapiaamaaoekaabaaaaiaaaaaoeiaaeaaaaaeaaaaapiaanaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaafaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaabaaaaacaaaaanoaabaabejaabaaaaacabaaaioaaaaakkjappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpfjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaanpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdnmnmmmmdnmnmmmmdn
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaabkiacaaa
aaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaaaaaaaaaabkbabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaaabaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaafnccabaaaabaaaaaa
agbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaaaaaaaaaablaaaaaf
bcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaaacaaaaaaegiocaaa
aaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajcccabaaaacaaaaaa
egiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajeccabaaa
acaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaaaaaaaaaadoaaaaab
ejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
faepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ZBufferParams]
Float 1 [_GlobalDensity]
Vector 2 [_FogColor]
Vector 3 [_StartDistance]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 15 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 2.718282, 1 } };
TEMP R0;
TEMP R1;
TEX R1.x, fragment.texcoord[1], texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[1], 2D;
MAD R1.x, R1, c[0], c[0].y;
RCP R1.x, R1.x;
MUL R1, R1.x, fragment.texcoord[2];
DP4 R1.x, R1, R1;
RSQ R1.x, R1.x;
RCP R1.x, R1.x;
MUL R1.x, R1, c[3];
ADD_SAT R1.x, R1, -c[4].y;
MUL R1.x, R1, c[3].y;
MUL R1.x, R1, -c[1];
ADD R0, R0, -c[2];
POW R1.x, c[4].x, R1.x;
MAD result.color, R1.x, R0, c[2];
END
# 15 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Float 1 [_GlobalDensity]
Vector 2 [_FogColor]
Vector 3 [_StartDistance]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
; 17 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c4, -1.00000000, 2.71828198, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2
texld r0, t1, s0
texld r2, t0, s1
mad r0.x, r0, c0, c0.y
rcp r0.x, r0.x
mul r0, r0.x, t2
dp4 r0.x, r0, r0
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r0.x, r0, c3
add_sat r0.x, r0, c4
mul r0.x, r0, c3.y
mul r0.x, r0, -c1
pow r1.x, c4.y, r0.x
add r2, r2, -c2
mov r0.x, r1.x
mad r0, r0.x, r2, c2
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Float 16 [_GlobalDensity]
Vector 32 [_FogColor]
Vector 48 [_StartDistance]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedckgbjlbckpfbogbgbgkijmliogpmmgbgabaaaaaafmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapapaaaafdfgfpfa
gphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcgmacaaaaeaaaaaaajlaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaaabaaaaaa
ahaaaaaaakaabaaaaaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaa
diaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbobaaaacaaaaaabbaaaaah
bcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadccaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaadaaaaaaabeaaaaaaaaaialpdiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaajbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaabaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklidpbjaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaaaaaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaa
egiocaiaebaaaaaaaaaaaaaaacaaaaaadcaaaaakpccabaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Float 16 [_GlobalDensity]
Vector 32 [_FogColor]
Vector 48 [_StartDistance]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0_level_9_1
eefiecedbkcpciojmnjmcdafdinegccmjphfnjagabaaaaaapmaeaaaaaeaaaaaa
daaaaaaammabaaaaeaaeaaaamiaeaaaaebgpgodjjeabaaaajeabaaaaaaacpppp
faabaaaaeeaaaaaaacaacmaaaaaaeeaaaaaaeeaaacaaceaaaaaaeeaaabaaaaaa
aaababaaaaaaabaaadaaaaaaaaaaaaaaabaaahaaabaaadaaaaaaaaaaaaacpppp
fbaaaaafaeaaapkaaaaaialpdlkklidpaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaaplabpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaac
aaaaaajaabaiapkaabaaaaacaaaaadiaaaaabllaecaaaaadaaaaapiaaaaaoeia
abaioekaecaaaaadabaaapiaaaaaoelaaaaioekaaeaaaaaeaaaaabiaadaaaaka
aaaaaaiaadaaffkaagaaaaacaaaaabiaaaaaaaiaafaaaaadaaaaapiaaaaaaaia
abaaoelaajaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaia
agaaaaacaaaaabiaaaaaaaiaabaaaaacacaaaiiaacaaaakaaeaaaaaeaaaabbia
aaaaaaiaacaappiaaeaaaakaafaaaaadaaaaabiaaaaaaaiaacaaffkaafaaaaad
aaaaabiaaaaaaaiaaaaaaakbafaaaaadaaaaabiaaaaaaaiaaeaaffkaaoaaaaac
aaaaabiaaaaaaaiabcaaaaaeacaacpiaaaaaaaiaabaaoeiaabaaoekaabaaaaac
aaaicpiaacaaoeiappppaaaafdeieefcgmacaaaaeaaaaaaajlaaaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaa
abaaaaaaahaaaaaaakaabaaaaaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaak
bcaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaa
aaaaaaaadiaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbobaaaacaaaaaa
bbaaaaahbcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadccaaaakbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaadaaaaaaabeaaaaaaaaaialpdiaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaajbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaiaebaaaaaaaaaaaaaaabaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklidpbjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaajpcaabaaaabaaaaaaegaobaaa
abaaaaaaegiocaiaebaaaaaaaaaaaaaaacaaaaaadcaaaaakpccabaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaadoaaaaab
ejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapapaaaafdfgfpfagphdgjhegjgpgoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
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
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [_FrustumCornersWS]
"!!ARBvp1.0
# 11 ALU
PARAM c[9] = { { 0.1 },
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
ADDRESS A0;
ARL A0.x, vertex.position.z;
MOV R0.xyw, vertex.position;
MOV R0.z, c[0].x;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MOV result.texcoord[2].xyz, c[A0.x + 5];
MOV result.texcoord[0].xy, vertex.texcoord[0];
MOV result.texcoord[1].xy, vertex.texcoord[0];
MOV result.texcoord[2].w, vertex.position.z;
END
# 11 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_FrustumCornersWS]
Vector 8 [_MainTex_TexelSize]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_texcoord0 v1
def c9, 0.10000000, 0.00000000, 1.00000000, 0
mov r1.x, c9.y
slt r1.x, c8.y, r1
max r1.x, -r1, r1
mova a0.x, v0.z
mov r0.xyw, v0
mov r0.z, c9.x
dp4 oPos.w, r0, c3
dp4 oPos.z, r0, c2
dp4 oPos.y, r0, c1
slt r1.x, c9.y, r1
dp4 oPos.x, r0, c0
add r0.x, -r1, c9.z
mul r0.y, v1, r0.x
add r0.x, -v1.y, c9.z
mad oT0.y, r1.x, r0.x, r0
mov oT2.xyz, c[a0.x + 4]
mov oT1.xy, v1
mov oT0.x, v1
mov oT2.w, v0.z
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedclkpljmcdnkhlgjkcnphehfieklbffpgabaaaaaaiiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaafeeffied
epepfceeaaklklklfdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
fjaaaaaeegiocaaaaaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaan
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdn
mnmmmmdnmnmmmmdnegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaa
aaaaaaaabkiacaaaaaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaa
aaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaa
abaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaaf
nccabaaaabaaaaaaagbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaa
aaaaaaaablaaaaafbcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaa
acaaaaaaegiocaaaaaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaaj
cccabaaaacaaaaaaegiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaa
bbaaaaajeccabaaaacaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaa
aaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 176
Matrix 96 [_FrustumCornersWS]
Vector 80 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedcgdcohjlkhgclkcgjimhoojfofjnbcamabaaaaaanmafaaaaaeaaaaaa
daaaaaaaiaacaaaaaaafaaaafeafaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
aiacaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaafaa
aeaaagaaaaaaaaaaabaaaaaaaeaaakaaaaaaaaaaaaaaafaaaaacpoppfbaaaaaf
aeaaapkamnmmmmdnaaaaaamaaaaaiadpaaaaaaaafbaaaaafaaaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaafbaaaaafabaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaafbaaaaafacaaapkaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaafbaaaaaf
adaaapkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaaciaagaaffkaamaaaaadaaaaabia
aaaaffiaaaaappkaaeaaaaaeaaaaaciaabaaffjaaeaaffkaaeaakkkaaeaaaaae
aaaaacoaaaaaaaiaaaaaffiaabaaffjaamaaaaadaaaaabiaaaaakkjaaaaakkjb
bdaaaaacaaaaaciaaaaakkjaacaaaaadaaaaaeiaaaaaffibaaaakkjaamaaaaad
aaaaaciaaaaaffibaaaaffiaaeaaaaaeaaaaabiaaaaaaaiaaaaaffiaaaaakkia
coaaaaacaaaaablaaaaaaaiaabaaaaadaaaaapiaaacaoekaaaaaaalaajaaaaad
abaaaboaahaaoekaaaaaoeiaajaaaaadabaaacoaaiaaoekaaaaaoeiaajaaaaad
abaaaeoaajaaoekaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaae
aaaaapiaakaaoekaaaaaaajaaaaaoeiaabaaaaacabaaabiaaeaaaakaaeaaaaae
aaaaapiaamaaoekaabaaaaiaaaaaoeiaaeaaaaaeaaaaapiaanaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaafaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaabaaaaacaaaaanoaabaabejaabaaaaacabaaaioaaaaakkjappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaadfbiaaaabcaaaaaaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpfjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaanpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaaaceaaaaamnmmmmdnmnmmmmdnmnmmmmdnmnmmmmdn
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaabkiacaaa
aaaaaaaaafaaaaaaabeaaaaaaaaaaaaaaaaaaaaiccaabaaaaaaaaaaabkbabaia
ebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajcccabaaaabaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaadgaaaaafnccabaaaabaaaaaa
agbebaaaabaaaaaadgaaaaaficcabaaaacaaaaaackbabaaaaaaaaaaablaaaaaf
bcaabaaaaaaaaaaackbabaaaaaaaaaaabbaaaaajbccabaaaacaaaaaaegiocaaa
aaaaaaaaagaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajcccabaaaacaaaaaa
egiocaaaaaaaaaaaahaaaaaaegjojaaaakaabaaaaaaaaaaabbaaaaajeccabaaa
acaaaaaaegiocaaaaaaaaaaaaiaaaaaaegjojaaaakaabaaaaaaaaaaadoaaaaab
ejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
faepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ZBufferParams]
Float 1 [_GlobalDensity]
Vector 2 [_FogColor]
Vector 3 [_StartDistance]
Vector 4 [_Y]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 2 TEX
PARAM c[6] = { program.local[0..4],
		{ 1, 2.718282, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.x, fragment.texcoord[1], texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[1], 2D;
MAD R1.x, R1, c[0], c[0].y;
RCP R1.x, R1.x;
MUL R2.xyz, R1.x, fragment.texcoord[2];
DP3 R1.x, R2, R2;
RSQ R1.x, R1.x;
RCP R2.x, R1.x;
MUL R2.x, R2, c[3];
ADD R2.y, R2, -c[4].x;
ADD_SAT R2.x, R2, -c[5];
MUL R2.y, R2, c[4];
MUL R2.x, R2, c[3].y;
MAX R2.y, R2, c[5].z;
MUL R2.x, R2, -c[1];
MUL R2.y, R2, R2;
POW R2.x, c[5].y, R2.x;
ADD R1, -R0, c[2];
POW R2.y, c[5].y, -R2.y;
ADD R2.x, -R2, c[5];
MUL R2.x, R2, R2.y;
MAD result.color, R2.x, R1, R0;
END
# 22 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Float 1 [_GlobalDensity]
Vector 2 [_FogColor]
Vector 3 [_StartDistance]
Vector 4 [_Y]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
; 26 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c5, -1.00000000, 0.00000000, 2.71828198, 1.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xyz
texld r0, t1, s0
texld r2, t0, s1
mad r0.x, r0, c0, c0.y
rcp r0.x, r0.x
mul r0.xyz, r0.x, t2
dp3 r0.x, r0, r0
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r1.x, r0, c3
add r0.x, r0.y, -c4
add_sat r1.x, r1, c5
mul r0.x, r0, c4.y
mul r1.x, r1, c3.y
mul r1.x, r1, -c1
pow r3.x, c5.z, r1.x
max r0.x, r0, c5.y
mul r0.x, r0, r0
pow r1.x, c5.z, -r0.x
mov r0.x, r3.x
add r4, -r2, c2
add r0.x, -r0, c5.w
mul r0.x, r0, r1.x
mad r0, r0.x, r4, r2
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Float 16 [_GlobalDensity]
Vector 32 [_FogColor]
Vector 48 [_StartDistance]
Vector 64 [_Y]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedljhhmdjnkiloghobnhalbncefgljodbeabaaaaaaeiaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapahaaaafdfgfpfa
gphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcfiadaaaaeaaaaaaangaaaaaafjaaaaaeegiocaaa
aaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaaabaaaaaa
ahaaaaaaakaabaaaaaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaa
diaaaaahocaabaaaaaaaaaaaagaabaaaaaaaaaaaagbjbaaaacaaaaaadcaaaaal
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkbabaaaacaaaaaaakiacaiaebaaaaaa
aaaaaaaaaeaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaabkiacaaa
aaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklilpbjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaajgahbaaa
aaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
dccaaaakccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaadaaaaaa
abeaaaaaaaaaialpdiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaabkiacaaa
aaaaaaaaadaaaaaadiaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaabaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
abeaaaaadlkklidpbjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaai
ccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaaj
pcaabaaaacaaaaaaegaobaiaebaaaaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaa
dcaaaaajpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_CameraDepthTexture] 2D 1
SetTexture 1 [_MainTex] 2D 0
ConstBuffer "$Globals" 176
Float 16 [_GlobalDensity]
Vector 32 [_FogColor]
Vector 48 [_StartDistance]
Vector 64 [_Y]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0_level_9_1
eefiecedldcljcbmgajfjkdghgjnbonoeobmmebdabaaaaaagiagaaaaaeaaaaaa
daaaaaaaemacaaaakmafaaaadeagaaaaebgpgodjbeacaaaabeacaaaaaaacpppp
naabaaaaeeaaaaaaacaacmaaaaaaeeaaaaaaeeaaacaaceaaaaaaeeaaabaaaaaa
aaababaaaaaaabaaaeaaaaaaaaaaaaaaabaaahaaabaaaeaaaaaaaaaaaaacpppp
fbaaaaafafaaapkaaaaaialpaaaaaaaadlkklidpaaaaiadpbpaaaaacaaaaaaia
aaaaaplabpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaac
aaaaaajaabaiapkaabaaaaacaaaaadiaaaaabllaecaaaaadaaaaapiaaaaaoeia
abaioekaecaaaaadabaaapiaaaaaoelaaaaioekaaeaaaaaeaaaaabiaaeaaaaka
aaaaaaiaaeaaffkaagaaaaacaaaaabiaaaaaaaiaafaaaaadacaaahiaaaaaaaia
abaaoelaaeaaaaaeacaaaiiaaaaaaaiaabaafflaadaaaakbafaaaaadacaaaiia
acaappiaadaaffkaalaaaaadaaaaabiaacaappiaafaaffkaafaaaaadacaaaiia
aaaaaaiaaaaaaaiaafaaaaadacaaaiiaacaappiaafaakkkbaoaaaaacacaaaiia
acaappiaaiaaaaadaaaaabiaacaaoeiaacaaoeiaahaaaaacaaaaabiaaaaaaaia
agaaaaacaaaaabiaaaaaaaiaabaaaaacacaaabiaafaaaakaaeaaaaaeaaaabbia
aaaaaaiaacaaaakaacaaaaiaafaaaaadaaaaabiaaaaaaaiaacaaffkaafaaaaad
aaaaabiaaaaaaaiaaaaaaakbafaaaaadaaaaabiaaaaaaaiaafaakkkaaoaaaaac
aaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaibafaappkaafaaaaadaaaaabia
acaappiaaaaaaaiabcaaaaaeacaacpiaaaaaaaiaabaaoekaabaaoeiaabaaaaac
aaaicpiaacaaoeiappppaaaafdeieefcfiadaaaaeaaaaaaangaaaaaafjaaaaae
egiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaalbcaabaaaaaaaaaaaakiacaaa
abaaaaaaahaaaaaaakaabaaaaaaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaak
bcaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaa
aaaaaaaadiaaaaahocaabaaaaaaaaaaaagaabaaaaaaaaaaaagbjbaaaacaaaaaa
dcaaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkbabaaaacaaaaaaakiacaia
ebaaaaaaaaaaaaaaaeaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkiacaaaaaaaaaaaaeaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaadlkklilp
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaa
jgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaa
aaaaaaaadccaaaakccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaa
adaaaaaaabeaaaaaaaaaialpdiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
bkiacaaaaaaaaaaaadaaaaaadiaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaiaebaaaaaaaaaaaaaaabaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaaabeaaaaadlkklidpbjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaa
aaaaaaajpcaabaaaacaaaaaaegaobaiaebaaaaaaabaaaaaaegiocaaaaaaaaaaa
acaaaaaadcaaaaajpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaa
egaobaaaabaaaaaadoaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapahaaaafdfgfpfa
gphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}
}
 }
}
Fallback Off
}