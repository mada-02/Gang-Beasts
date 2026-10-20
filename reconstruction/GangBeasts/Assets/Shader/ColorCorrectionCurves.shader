Shader "Hidden/ColorCorrectionCurves" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "" {}
 _RgbTex ("_RgbTex (RGB)", 2D) = "" {}
 _ZCurve ("_ZCurve (RGB)", 2D) = "" {}
 _RgbDepthTex ("_RgbDepthTex (RGB)", 2D) = "" {}
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
Vector 5 [_CameraDepthTexture_ST]
"!!ARBvp1.0
# 6 ALU
PARAM c[6] = { program.local[0],
		state.matrix.mvp,
		program.local[5] };
MOV result.texcoord[0].xy, vertex.texcoord[0];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[5], c[5].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_CameraDepthTexture_ST]
Vector 5 [_MainTex_TexelSize]
"vs_2_0
; 15 ALU
def c6, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.x, c6
slt r0.x, c5.y, r0
max r0.x, -r0, r0
slt r0.z, c6.x, r0.x
mad r0.xy, v1, c4, c4.zwzw
add r0.w, -r0.z, c6.y
mul r0.w, r0.y, r0
add r0.y, -r0, c6
mad oT1.y, r0.z, r0, r0.w
mov oT0.xy, v1
mov oT1.x, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 64
Vector 16 [_CameraDepthTexture_ST]
Vector 32 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedjogjjeapifcokefllgkicklkandbflknabaaaaaalmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcmeabaaaaeaaaabaahbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaacaaaaaaabeaaaaaaaaaaaaa
dcaaaaalgcaabaaaaaaaaaaaagbbbaaaabaaaaaaagibcaaaaaaaaaaaabaaaaaa
kgilcaaaaaaaaaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpdhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaa
dkaabaaaaaaaaaaackaabaaaaaaaaaaadgaaaaafeccabaaaabaaaaaabkaabaaa
aaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 64
Vector 16 [_CameraDepthTexture_ST]
Vector 32 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedjjmgglcghhinfgbfkioalfofpejahimdabaaaaaabmaeaaaaaeaaaaaa
daaaaaaaimabaaaafiadaaaakmadaaaaebgpgodjfeabaaaafeabaaaaaaacpopp
beabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaaf
ahaaapkaaaaaaaaaaaaaaamaaaaaiadpaaaaaaaabpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaabiaahaaaakaamaaaaadaaaaabia
acaaffkaaaaaaaiaaeaaaaaeaaaaagiaabaanajaabaanakaabaapikaaeaaaaae
aaaaaiiaaaaakkiaahaaffkaahaakkkaaeaaaaaeaaaaaeoaaaaaaaiaaaaappia
aaaakkiaabaaaaacaaaaaioaaaaaffiaafaaaaadaaaaapiaaaaaffjaaeaaoeka
aeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaac
aaaaadoaabaaoejappppaaaafdeieefcmeabaaaaeaaaabaahbaaaaaafjaaaaae
egiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaai
bcaabaaaaaaaaaaabkiacaaaaaaaaaaaacaaaaaaabeaaaaaaaaaaaaadcaaaaal
gcaabaaaaaaaaaaaagbbbaaaabaaaaaaagibcaaaaaaaaaaaabaaaaaakgilcaaa
aaaaaaaaabaaaaaaaaaaaaaiicaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaadkaabaaa
aaaaaaaackaabaaaaaaaaaaadgaaaaafeccabaaaabaaaaaabkaabaaaaaaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaabejfdeheoemaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
ebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeo
aafeeffiedepepfceeaaklklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amadaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_ZBufferParams]
Float 1 [_Saturation]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
SetTexture 3 [_ZCurve] 2D 3
SetTexture 4 [_RgbDepthTex] 2D 4
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 34 ALU, 9 TEX
PARAM c[5] = { program.local[0..1],
		{ 0.5, 0.125, 1, 0 },
		{ 0.625, 0.375 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.x, fragment.texcoord[1], texture[2], 2D;
MOV R5.x, R0.y;
MOV R5.y, c[3];
MOV R6.x, R0.z;
MOV R6.y, c[3].x;
MAD R0.y, R1.x, c[0].x, c[0];
MOV R4.x, R0;
RCP R0.x, R0.y;
MOV R0.y, c[2].x;
MOV R4.y, c[2];
MOV result.color.w, R0;
TEX R1.xyz, R4, texture[4], 2D;
TEX R2.xyz, R6, texture[4], 2D;
TEX R3.xyz, R5, texture[4], 2D;
TEX R4.xyz, R4, texture[1], 2D;
TEX R5.xyz, R5, texture[1], 2D;
TEX R6.xyz, R6, texture[1], 2D;
TEX R0.x, R0, texture[3], 2D;
MUL R6.xyz, R6, c[2].wwzw;
MUL R5.xyz, R5, c[2].wzww;
MUL R4.xyz, R4, c[2].zwww;
ADD R4.xyz, R4, R5;
ADD R4.xyz, R4, R6;
MUL R3.xyz, R3, c[2].wzww;
MUL R2.xyz, R2, c[2].wwzw;
MUL R1.xyz, R1, c[2].zwww;
ADD R1.xyz, R1, R2;
ADD R1.xyz, R1, R3;
ADD R1.xyz, R1, -R4;
MAD R0.xyz, R0.x, R1, R4;
DP3 R1.x, R0, c[4];
ADD R0.xyz, R0, -R1.x;
MAD result.color.xyz, R0, c[1].x, R1.x;
END
# 34 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
Float 1 [_Saturation]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
SetTexture 3 [_ZCurve] 2D 3
SetTexture 4 [_RgbDepthTex] 2D 4
"ps_2_0
; 38 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c2, 0.50000000, 0.12500000, 1.00000000, 0.00000000
def c3, 0.62500000, 0.37500000, 0, 0
def c4, 0.21997070, 0.70703125, 0.07098389, 0
dcl t0.xy
dcl t1.xy
texld r2, t1, s2
texld r6, t0, s0
mad r3.x, r2, c0, c0.y
mov_pp r0.x, r6.z
mov_pp r0.y, c3.x
mov_pp r1.x, r6.y
mov_pp r2.x, r6
mov_pp r2.y, c2
rcp r3.x, r3.x
mov_pp r3.y, c2.x
mov_pp r1.y, c3
mov r6.z, c2
mov r6.xy, c2.w
texld r7, r3, s3
texld r5, r2, s4
texld r4, r0, s4
texld r3, r1, s4
texld r0, r0, s1
texld r2, r2, s1
texld r1, r1, s1
mul r6.xyz, r0, r6
mov r0.xz, c2.w
mov r0.y, c2.z
mul r1.xyz, r1, r0
mov r0.yz, c2.w
mov r0.x, c2.z
mul r0.xyz, r2, r0
add_pp r0.xyz, r0, r1
add_pp r1.xyz, r0, r6
mov r0.xz, c2.w
mov r0.y, c2.z
mul r2.xyz, r3, r0
mov r0.xy, c2.w
mov r0.z, c2
mul r3.xyz, r4, r0
mov r0.yz, c2.w
mov r0.x, c2.z
mul r0.xyz, r5, r0
add_pp r0.xyz, r0, r3
add_pp r0.xyz, r0, r2
add_pp r0.xyz, r0, -r1
mad_pp r1.xyz, r7.x, r0, r1
dp3_pp r0.x, r1, c4
add_pp r1.xyz, r1, -r0.x
mov_pp r0.w, r6
mad_pp r0.xyz, r1, c1.x, r0.x
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 2
SetTexture 2 [_CameraDepthTexture] 2D 1
SetTexture 3 [_ZCurve] 2D 3
SetTexture 4 [_RgbDepthTex] 2D 4
ConstBuffer "$Globals" 64
Float 48 [_Saturation]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedhacdcnfidlcicljilacjhngbkmpfdcdpabaaaaaaiaafaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckiaeaaaaeaaaaaaackabaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaae
aahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaa
abaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaighnbaaaaaaaaaaaaagabaaaaaaaaaaadgaaaaaf
bcaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaaikcaabaaaabaaaaaaaceaaaaa
aaaaaaaaaaaacadpaaaaaaaaaaaaaadpefaaaaajpcaabaaaacaaaaaaegaabaaa
abaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaaefaaaaajpcaabaaaadaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaadiaaaaakhcaabaaa
acaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadgaaaaaikcaabaaaaaaaaaaa
aceaaaaaaaaaaaaaaaaaaadoaaaaaaaaaaaamadoefaaaaajpcaabaaaaeaaaaaa
egaabaaaaaaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaamhcaabaaa
acaaaaaaegacbaaaaeaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
egacbaaaacaaaaaaefaaaaajpcaabaaaaeaaaaaaogakbaaaaaaaaaaaeghobaaa
aeaaaaaaaagabaaaaeaaaaaadcaaaaamhcaabaaaacaaaaaaegacbaaaaeaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaaeaaaaaaogakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaadiaaaaakhcaabaaaaeaaaaaaegacbaaaaeaaaaaaaceaaaaaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaegacbaaaaeaaaaaadcaaaaam
hcaabaaaaaaaaaaaegacbaaaadaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaa
aaaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogbkbaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaabaaaaaadcaaaaalicaabaaaaaaaaaaaakiacaaa
abaaaaaaahaaaaaaakaabaaaadaaaaaabkiacaaaabaaaaaaahaaaaaaaoaaaaak
ecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogakbaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaakicaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaakoehgbdopepndedphdgijbdnaaaaaaaaaaaaaaaihcaabaaaaaaaaaaa
pgapbaiaebaaaaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaa
agiacaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_RgbTex] 2D 2
SetTexture 2 [_CameraDepthTexture] 2D 1
SetTexture 3 [_ZCurve] 2D 3
SetTexture 4 [_RgbDepthTex] 2D 4
ConstBuffer "$Globals" 64
Float 48 [_Saturation]
ConstBuffer "UnityPerCamera" 128
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0_level_9_1
eefiecedljjhamndegecpejjlmflebajfagfinbiabaaaaaacmaiaaaaaeaaaaaa
daaaaaaaniacaaaaiiahaaaapiahaaaaebgpgodjkaacaaaakaacaaaaaaacpppp
faacaaaafaaaaaaaacaadiaaaaaafaaaaaaafaaaafaaceaaaaaafaaaaaaaaaaa
acababaaabacacaaadadadaaaeaeaeaaaaaaadaaabaaaaaaaaaaaaaaabaaahaa
abaaabaaaaaaaaaaaaacppppfbaaaaafacaaapkaaaaaaadoaaaamadoaaaacadp
aaaaaadpfbaaaaafadaaapkaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaafbaaaaaf
aeaaapkakoehgbdopepndedphdgijbdnaaaaaaaabpaaaaacaaaaaaiaaaaaapla
bpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaaja
acaiapkabpaaaaacaaaaaajaadaiapkabpaaaaacaaaaaajaaeaiapkaabaaaaac
aaaaadiaaaaabllaecaaaaadaaaacpiaaaaaoeiaabaioekaecaaaaadabaacpia
aaaaoelaaaaioekaaeaaaaaeaaaaabiaabaaaakaaaaaaaiaabaaffkaagaaaaac
aaaacbiaaaaaaaiaabaaaaacaaaacciaacaappkaabaaaaacacaacciaacaaffka
abaaaaacacaacbiaabaaffiaabaaaaacabaacciaacaaaakaabaaaaacadaacbia
abaakkiaabaaaaacadaacciaacaakkkaecaaaaadaaaacpiaaaaaoeiaadaioeka
ecaaaaadaeaaapiaacaaoeiaacaioekaecaaaaadacaaapiaacaaoeiaaeaioeka
ecaaaaadafaaapiaabaaoeiaacaioekaecaaaaadagaaapiaabaaoeiaaeaioeka
ecaaaaadahaaapiaadaaoeiaacaioekaecaaaaadadaaapiaadaaoeiaaeaioeka
afaaaaadaaaacoiaaeaabliaadaablkaaeaaaaaeaeaachiaafaaoeiaadaamjka
aaaabliaafaaaaadadaachiaadaaoeiaadaanckaaeaaaaaeadaachiaagaaoeia
adaamjkaadaaoeiaaeaaaaaeaaaacoiaacaabliaadaablkaadaabliaaeaaaaae
acaachiaahaaoeiaadaanckaaeaaoeiabcaaaaaeadaachiaaaaaaaiaaaaablia
acaaoeiaaiaaaaadadaaciiaadaaoeiaaeaaoekabcaaaaaeabaachiaaaaaaaka
adaaoeiaadaappiaabaaaaacaaaicpiaabaaoeiappppaaaafdeieefckiaeaaaa
eaaaaaaackabaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadmcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaighnbaaaaaaaaaaaaagabaaa
aaaaaaaadgaaaaafbcaabaaaabaaaaaabkaabaaaaaaaaaaadgaaaaaikcaabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaacadpaaaaaaaaaaaaaadpefaaaaajpcaabaaa
acaaaaaaegaabaaaabaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaaefaaaaaj
pcaabaaaadaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
diaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadgaaaaai
kcaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaadoaaaaaaaaaaaamadoefaaaaaj
pcaabaaaaeaaaaaaegaabaaaaaaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
dcaaaaamhcaabaaaacaaaaaaegacbaaaaeaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaaeaaaaaaogakbaaa
aaaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadcaaaaamhcaabaaaacaaaaaa
egacbaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaaeaaaaaaogakbaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaadiaaaaakhcaabaaaaeaaaaaaegacbaaaaeaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaadcaaaaamhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaegacbaaa
aeaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaadaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaiadpaaaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaiaebaaaaaaaaaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaa
ogbkbaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaadcaaaaalicaabaaa
aaaaaaaaakiacaaaabaaaaaaahaaaaaaakaabaaaadaaaaaabkiacaaaabaaaaaa
ahaaaaaaaoaaaaakecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpdkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogakbaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaakicaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaakoehgbdopepndedphdgijbdnaaaaaaaaaaaaaaai
hcaabaaaaaaaaaaapgapbaiaebaaaaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagiacaaaaaaaaaaaadaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaadoaaaaabejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}
}
 }
}
Fallback Off
}