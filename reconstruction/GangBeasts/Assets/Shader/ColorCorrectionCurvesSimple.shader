Shader "Hidden/ColorCorrectionCurvesSimple" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "" {}
 _RgbTex ("_RgbTex (RGB)", 2D) = "" {}
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
"!!ARBvp1.0
# 5 ALU
PARAM c[5] = { program.local[0],
		state.matrix.mvp };
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 5 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 5 ALU
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecedgcclnnbgpijgpddakojponflfpghdgniabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
eaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
doaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "UnityPerDraw" 0
"vs_4_0_level_9_1
eefiecedmldjmmohbhmjmnnblgkeoagbliecmmbkabaaaaaalmacaaaaaeaaaaaa
daaaaaaaaeabaaaabaacaaaageacaaaaebgpgodjmmaaaaaammaaaaaaaaacpopp
jiaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjaafaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapia
abaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacaaaaadoaabaaoeja
ppppaaaafdeieefcaeabaaaaeaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaa
abaaaaaaegbabaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Float 0 [_Saturation]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 1
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 4 TEX
PARAM c[3] = { program.local[0],
		{ 0.125, 1, 0, 0.375 },
		{ 0.625, 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.x, R0.y;
MOV R1.z, R0;
MOV R0.y, c[1].x;
MOV R1.w, c[2].x;
MOV R1.y, c[1].w;
MOV result.color.w, R0;
TEX R2.xyz, R1.zwzw, texture[1], 2D;
TEX R0.xyz, R0, texture[1], 2D;
TEX R1.xyz, R1, texture[1], 2D;
MUL R1.xyz, R1, c[1].zyzw;
MUL R0.xyz, R0, c[1].yzzw;
ADD R0.xyz, R0, R1;
MUL R2.xyz, R2, c[1].zzyw;
ADD R0.xyz, R0, R2;
DP3 R1.x, R0, c[2].yzww;
ADD R0.xyz, R0, -R1.x;
MAD result.color.xyz, R0, c[0].x, R1.x;
END
# 18 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Float 0 [_Saturation]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 1
"ps_2_0
; 25 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
def c1, 0.12500000, 1.00000000, 0.00000000, 0.37500000
def c2, 0.62500000, 0.21997070, 0.70703125, 0.07098389
dcl t0.xy
texld r3, t0, s0
mov_pp r0.x, r3.z
mov_pp r0.y, c2.x
mov_pp r1.x, r3.y
mov_pp r2.x, r3
mov_pp r1.y, c1.w
mov_pp r2.y, c1.x
mov r3.z, c1.y
mov r3.xy, c1.z
texld r0, r0, s1
texld r2, r2, s1
texld r1, r1, s1
mul r3.xyz, r0, r3
mov r0.xz, c1.z
mov r0.y, c1
mul r1.xyz, r1, r0
mov r0.yz, c1.z
mov r0.x, c1.y
mul r0.xyz, r2, r0
add_pp r0.xyz, r0, r1
add_pp r1.xyz, r0, r3
mov r0.x, c2.y
mov r0.z, c2.w
mov r0.y, c2.z
dp3_pp r2.x, r1, r0
add_pp r0.xyz, r1, -r2.x
mov_pp r0.w, r3
mad_pp r0.xyz, r0, c0.x, r2.x
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 1
ConstBuffer "$Globals" 32
Float 16 [_Saturation]
BindCB  "$Globals" 0
"ps_4_0
eefiecedkgjihgjcnbjcgljibpaibkchgdndmcnoabaaaaaabiadaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfiacaaaa
eaaaaaaajgaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaadgaaaaaikcaabaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaadoaaaaaaaaaaaamadoefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaacghnbaaaaaaaaaaaaagabaaaaaaaaaaadgaaaaaffcaabaaaaaaaaaaa
fgagbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogakbaaaaaaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaa
acaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaacadpefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadcaaaaamhcaabaaaaaaaaaaa
egacbaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaegacbaaa
aaaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaakoehgbdo
pepndedphdgijbdnaaaaaaaaaaaaaaaihcaabaaaaaaaaaaapgapbaiaebaaaaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagiacaaaaaaaaaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 1
ConstBuffer "$Globals" 32
Float 16 [_Saturation]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
eefiecedpcenfjdklcmijiajghnnceenejdkekikabaaaaaaleaeaaaaaeaaaaaa
daaaaaaamiabaaaaciaeaaaaiaaeaaaaebgpgodjjaabaaaajaabaaaaaaacpppp
fiabaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaabaaabaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkaaaaaaado
aaaamadoaaaacadpaaaaaaaafbaaaaafacaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaafbaaaaafadaaapkakoehgbdopepndedphdgijbdnaaaaaaaabpaaaaac
aaaaaaiaaaaacdlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
ecaaaaadaaaacpiaaaaaoelaaaaioekaabaaaaacabaacciaabaaffkaabaaaaac
abaacbiaaaaaffiaabaaaaacaaaacciaabaaaakaabaaaaacacaacbiaaaaakkia
abaaaaacacaacciaabaakkkaecaaaaadabaaapiaabaaoeiaabaioekaecaaaaad
adaaapiaaaaaoeiaabaioekaecaaaaadacaaapiaacaaoeiaabaioekaafaaaaad
abaachiaabaaoeiaacaaoekaaeaaaaaeabaachiaadaaoeiaacaamjkaabaaoeia
aeaaaaaeabaachiaacaaoeiaacaanckaabaaoeiaaiaaaaadabaaciiaabaaoeia
adaaoekabcaaaaaeaaaachiaaaaaaakaabaaoeiaabaappiaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefcfiacaaaaeaaaaaaajgaaaaaafjaaaaaeegiocaaa
aaaaaaaaacaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
dgaaaaaikcaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaadoaaaaaaaaaaaamado
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaacghnbaaaaaaaaaaaaagabaaa
aaaaaaaadgaaaaaffcaabaaaaaaaaaaafgagbaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaogakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
diaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaegacbaaaacaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaabaaaaaadgaaaaafccaabaaaabaaaaaaabeaaaaaaaaacadp
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaiadpaaaaaaaaegacbaaaaaaaaaaabaaaaaakicaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaakoehgbdopepndedphdgijbdnaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaapgapbaiaebaaaaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagiacaaaaaaaaaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaadoaaaaabejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}
}
 }
}
Fallback Off
}