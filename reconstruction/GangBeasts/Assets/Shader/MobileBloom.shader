Shader "Hidden/FastBloom" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _Bloom ("Bloom (RGB)", 2D) = "black" {}
}
SubShader { 
 Pass {
  ZTest False
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
Vector 4 [_MainTex_TexelSize]
"vs_2_0
; 14 ALU
def c5, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.x, c5
slt r0.x, c4.y, r0
max r0.x, -r0, r0
slt r0.x, c5, r0
add r0.y, -r0.x, c5
mul r0.z, v1.y, r0.y
add r0.y, -v1, c5
mad oT0.y, r0.x, r0, r0.z
mov oT1.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT0.x, v1
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedclpmackkmlaglaimlfkokkepacielhmdabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaabaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajcccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafnccabaaaabaaaaaaagbebaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefieceddgpfdnckphnekdobmjfjpofdmgpgcpmoabaaaaaalmadaaaaaeaaaaaa
daaaaaaagmabaaaapiacaaaaemadaaaaebgpgodjdeabaaaadeabaaaaaaacpopp
peaaaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaaf
agaaapkaaaaaaaaaaaaaaamaaaaaiadpaaaaaaaabpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaabiaagaaaakaamaaaaadaaaaabia
abaaffkaaaaaaaiaaeaaaaaeaaaaaciaabaaffjaagaaffkaagaakkkaaeaaaaae
aaaaacoaaaaaaaiaaaaaffiaabaaffjaafaaaaadaaaaapiaaaaaffjaadaaoeka
aeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaac
aaaaanoaabaabejappppaaaafdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaae
egiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadbaaaaai
bcaabaaaaaaaaaaabkiacaaaaaaaaaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaai
ccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaaj
cccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaaabaaaaaa
dgaaaaafnccabaaaabaaaaaaagbebaaaabaaaaaadoaaaaabejfdeheoemaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
ebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeo
aafeeffiedepepfceeaaklklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Bloom] 2D 1
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 3 ALU, 2 TEX
TEMP R0;
TEMP R1;
TEX R1, fragment.texcoord[0], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD result.color, R0, R1;
END
# 3 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Bloom] 2D 1
"ps_2_0
; 2 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl t0.xy
dcl t1.xy
texld r0, t1, s1
texld r1, t0, s0
add r0, r1, r0
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Bloom] 2D 1
"ps_4_0
eefiecedbajopjkjnkjfmkiajdgfmeknkcigdlnmabaaaaaakmabaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcneaaaaaaeaaaaaaadfaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaaaaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaa
egaobaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Bloom] 2D 1
"ps_4_0_level_9_1
eefiecedafmkjpfjklcgnpbbbpofgkloedhflgaoabaaaaaafiacaaaaaeaaaaaa
daaaaaaaniaaaaaaleabaaaaceacaaaaebgpgodjkaaaaaaakaaaaaaaaaacpppp
heaaaaaacmaaaaaaaaaacmaaaaaacmaaaaaacmaaacaaceaaaaaacmaaaaaaaaaa
abababaaaaacppppbpaaaaacaaaaaaiaaaaacplabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaabaaaaacaaaacdiaaaaabllaecaaaaadaaaaapia
aaaaoeiaabaioekaecaaaaadabaacpiaaaaaoelaaaaioekaacaaaaadaaaacpia
aaaaoeiaabaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcneaaaaaa
eaaaaaaadfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaahpccabaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}
}
 }
 Pass {
  ZTest False
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 5 [_MainTex_TexelSize]
"!!ARBvp1.0
# 9 ALU
PARAM c[6] = { { -0.5, 0.5 },
		state.matrix.mvp,
		program.local[5] };
TEMP R0;
MOV R0.xy, c[0];
ADD result.texcoord[0].xy, vertex.texcoord[0], c[5];
MAD result.texcoord[1].xy, R0.x, c[5], vertex.texcoord[0];
MAD result.texcoord[2].xy, R0.yxzw, c[5], vertex.texcoord[0];
MAD result.texcoord[3].xy, R0, c[5], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_2_0
; 11 ALU
def c5, -0.50000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c4
mad oT1.xy, c5.x, r0, v1
mov r0.xy, c4
mov r0.zw, c4.xyxy
add oT0.xy, v1, c4
mad oT2.xy, c5.yxzw, r0, v1
mad oT3.xy, c5, r0.zwzw, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedcelcjkichjmnkoiecpldlgnjkhalnppbabaaaaaaaiadaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcoaabaaaaeaaaabaahiaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaa
fjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
mccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaaaaaaaaaidccabaaaabaaaaaaegbabaaaabaaaaaaegiacaaa
aaaaaaaaabaaaaaadcaaaaanmccabaaaabaaaaaaagiecaaaaaaaaaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaalpaaaaaalpagbebaaaabaaaaaadcaaaaan
dccabaaaacaaaaaaegiacaaaaaaaaaaaabaaaaaaaceaaaaaaaaaaadpaaaaaalp
aaaaaaaaaaaaaaaaegbabaaaabaaaaaadcaaaaanmccabaaaacaaaaaaagiecaaa
aaaaaaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaalpaaaaaadpagbebaaa
abaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedagpioedpgnpickhldlcdmjjoaajhkbbdabaaaaaafaaeaaaaaeaaaaaa
daaaaaaaheabaaaafmadaaaalaadaaaaebgpgodjdmabaaaadmabaaaaaaacpopp
pmaaaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaaf
agaaapkaaaaaaalpaaaaaadpaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaacaaaaadaaaaadoaabaaoejaabaaoekaabaaaaac
aaaaadiaabaaoekaaeaaaaaeaaaaamoaaaaabeiaagaaaakaabaabejaaeaaaaae
abaaadoaaaaaoeiaagaaobkaabaaoejaaeaaaaaeabaaamoaaaaabeiaagaabeka
abaabejaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapiaacaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcoaabaaaaeaaaabaa
hiaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaa
abaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaaaaaaaaai
dccabaaaabaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaabaaaaaadcaaaaan
mccabaaaabaaaaaaagiecaaaaaaaaaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaalpaaaaaalpagbebaaaabaaaaaadcaaaaandccabaaaacaaaaaaegiacaaa
aaaaaaaaabaaaaaaaceaaaaaaaaaaadpaaaaaalpaaaaaaaaaaaaaaaaegbabaaa
abaaaaaadcaaaaanmccabaaaacaaaaaaagiecaaaaaaaaaaaabaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaalpaaaaaadpagbebaaaabaaaaaadoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
imaaaaaaadaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_Parameter]
SetTexture 0 [_MainTex] 2D 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 4 TEX
PARAM c[2] = { program.local[0],
		{ 0.25, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[1], texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3, fragment.texcoord[3], texture[0], 2D;
TEX R2, fragment.texcoord[2], texture[0], 2D;
ADD R0, R0, R1;
ADD R0, R0, R2;
MOV R1.x, c[0].z;
ADD R0, R0, R3;
MAD R0, R0, c[1].x, -R1.x;
MAX R0, R0, c[1].y;
MUL result.color, R0, c[0].w;
END
# 11 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_Parameter]
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
; 8 ALU, 4 TEX
dcl_2d s0
def c1, 0.25000000, 0.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
texld r0, t3, s0
texld r3, t0, s0
texld r1, t2, s0
texld r2, t1, s0
add_pp r2, r3, r2
add_pp r1, r2, r1
mov_pp r2.z, c0
add_pp r0, r1, r0
mad_pp r0, r0, c1.x, -r2.z
max_pp r0, r0, c1.y
mul_pp r0, r0, c0.w
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 80
Vector 32 [_Parameter]
BindCB  "$Globals" 0
"ps_4_0
eefiecedhnffgjpefhpbljckognfmmnoekjkjcaiabaaaaaaoiacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcoaabaaaaeaaaaaaahiaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaaopcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaiado
aaaaiadoaaaaiadoaaaaiadokgikcaiaebaaaaaaaaaaaaaaacaaaaaadeaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaaipccabaaaaaaaaaaaegaobaaaaaaaaaaapgipcaaaaaaaaaaa
acaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 80
Vector 32 [_Parameter]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
eefiecedcalgcfckeoffopilooboncpammdnedgeabaaaaaaeeaeaaaaaeaaaaaa
daaaaaaaiiabaaaahaadaaaabaaeaaaaebgpgodjfaabaaaafaabaaaaaaacpppp
bmabaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaacaaabaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkaaaaaiadoaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaacplabpaaaaacaaaaaaiaabaacpla
bpaaaaacaaaaaajaaaaiapkaabaaaaacaaaacdiaaaaabllaabaaaaacabaacdia
abaabllaecaaaaadaaaaapiaaaaaoeiaaaaioekaecaaaaadacaacpiaaaaaoela
aaaioekaecaaaaadadaaapiaabaaoelaaaaioekaecaaaaadabaaapiaabaaoeia
aaaioekaacaaaaadaaaacpiaaaaaoeiaacaaoeiaacaaaaadaaaacpiaadaaoeia
aaaaoeiaacaaaaadaaaacpiaabaaoeiaaaaaoeiaabaaaaacabaaabiaabaaaaka
aeaaaaaeaaaacpiaaaaaoeiaabaaaaiaaaaakkkbafaaaaadabaacpiaaaaaoeia
aaaappkafiaaaaaeaaaacpiaaaaaoeiaabaaoeiaabaaffkaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefcoaabaaaaeaaaaaaahiaaaaaafjaaaaaeegiocaaa
aaaaaaaaadaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaaopcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaiadoaaaaiadoaaaaiadoaaaaiadokgikcaiaebaaaaaaaaaaaaaa
acaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaaipccabaaaaaaaaaaaegaobaaaaaaaaaaa
pgipcaaaaaaaaaaaacaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaa
imaaaaaaadaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
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
Vector 5 [_MainTex_TexelSize]
Vector 6 [_Parameter]
"!!ARBvp1.0
# 9 ALU
PARAM c[7] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..6] };
TEMP R0;
MOV R0.x, c[6];
MUL R0.xy, R0.x, c[5];
MOV result.texcoord[0].xy, vertex.texcoord[0];
MOV result.texcoord[0].zw, c[0].x;
MUL result.texcoord[1].xy, R0, c[0].yxzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
Vector 5 [_Parameter]
"vs_2_0
; 9 ALU
def c6, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c4
mul r0.xy, c5.x, r0
mov oT0.xy, v1
mov oT0.zw, c6.x
mul oT1.xy, r0, c6.yxzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecednmnkplfjfiofhkpekgocmehjkfihgbnmabaaaaaakmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcleabaaaaeaaaabaagnaaaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaadgaaaaaimccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaiadpdgaaaaagjcaabaaaaaaaaaaa
agiacaaaaaaaaaaaacaaaaaadgaaaaaigcaabaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaaegaabaaaaaaaaaaa
egiacaaaaaaaaaaaabaaaaaadiaaaaahdccabaaaacaaaaaaogakbaaaaaaaaaaa
egaabaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedhhgljpbaffejcjjlaalicopoklpcikjkabaaaaaapmadaaaaaeaaaaaa
daaaaaaahmabaaaadiadaaaaimadaaaaebgpgodjeeabaaaaeeabaaaaaaacpopp
aeabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaaf
ahaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaadiaahaaoekaafaaaaadaaaaapia
aaaabeiaacaaaakaacaaaaadaaaaadiaaaaaoeiaahaaobkaafaaaaadaaaaadia
aaaaoeiaabaaoekaafaaaaadabaaadoaaaaaooiaaaaaoeiaafaaaaadaaaaapia
aaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaaeaaaaaeaaaaapoaabaaaejaahaafakaahaaafkappppaaaafdeieefc
leabaaaaeaaaabaagnaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaae
egiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
abaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
dgaaaaaimccabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaiadp
dgaaaaagjcaabaaaaaaaaaaaagiacaaaaaaaaaaaacaaaaaadgaaaaaigcaabaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaaegaabaaaaaaaaaaaegiacaaaaaaaaaaaabaaaaaadiaaaaahdccabaaa
acaaaaaaogakbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaabejfdeheoemaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
ebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeo
aafeeffiedepepfceeaaklklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 7 TEX
PARAM c[2] = { { 3, 0.020492554, 0, 0.085510254 },
		{ 0.23205566, 0, 0.32397461, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
MOV R0.xy, fragment.texcoord[0];
MAD R5.xy, -fragment.texcoord[1], c[0].x, R0;
ADD R5.zw, R5.xyxy, fragment.texcoord[1].xyxy;
ADD R4.xy, R5.zwzw, fragment.texcoord[1];
ADD R3.xy, R4, fragment.texcoord[1];
ADD R2.xy, R3, fragment.texcoord[1];
ADD R1.xy, R2, fragment.texcoord[1];
ADD R0.xy, R1, fragment.texcoord[1];
TEX R6, R5.zwzw, texture[0], 2D;
TEX R0, R0, texture[0], 2D;
TEX R1, R1, texture[0], 2D;
TEX R2, R2, texture[0], 2D;
TEX R3, R3, texture[0], 2D;
TEX R4, R4, texture[0], 2D;
TEX R5, R5, texture[0], 2D;
MUL R6, R6, c[0].wwwz;
MAD R5, R5, c[0].yyyz, R6;
MAD R4, R4, c[1].xxxy, R5;
MAD R3, R3, c[1].zzzw, R4;
MAD R2, R2, c[1].xxxy, R3;
MAD R1, R1, c[0].wwwz, R2;
MAD result.color, R0, c[0].yyyz, R1;
END
# 22 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
; 30 ALU, 7 TEX
dcl_2d s0
def c0, 3.00000000, 0.08551025, 0.00000000, 0.02049255
def c1, 0.23205566, 0.00000000, 0.32397461, 1.00000000
dcl t0.xy
dcl t1.xy
mov_pp r0.xy, t0
mad_pp r0.xy, -t1, c0.x, r0
add_pp r1.xy, r0, t1
add_pp r2.xy, r1, t1
add_pp r3.xy, r2, t1
add_pp r4.xy, r3, t1
add_pp r5.xy, r4, t1
add_pp r6.xy, r5, t1
mov r0.w, c0.z
texld r7, r6, s0
texld r6, r5, s0
texld r5, r4, s0
texld r4, r3, s0
texld r3, r2, s0
texld r2, r0, s0
texld r1, r1, s0
mov r0.xyz, c0.y
mul_pp r1, r1, r0
mov r0.xyz, c0.w
mov r0.w, c0.z
mad_pp r1, r2, r0, r1
mov r0.xyz, c1.x
mov r0.w, c1.y
mad_pp r1, r3, r0, r1
mov r0.xyz, c1.z
mov r0.w, c1
mad_pp r1, r4, r0, r1
mov r0.xyz, c1.x
mov r0.w, c1.y
mad_pp r1, r5, r0, r1
mov r0.xyz, c0.y
mov r0.w, c0.z
mad_pp r1, r6, r0, r1
mov r0.xyz, c0.w
mov r0.w, c0.z
mad_pp r0, r7, r0, r1
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0
eefiecedpmidpnaopnhhgdlplnhdohjapolhdokbabaaaaaaoiacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbaacaaaaeaaaaaaaieaaaaaa
dfbiaaaaboaaaaaajoopkhdmaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaa
aaaaaaaaaaaaaaaagijbgndoaaaaaaaaaaaaaaaaaaaaaaaafeodkfdoaaaaaaaa
aaaaaaaaaaaaiadpgijbgndoaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaa
aaaaaaaaaaaaaaaajoopkhdmaaaaaaaaaaaaaaaaaaaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
dcaaaaandcaabaaaaaaaaaaaegbabaiaebaaaaaaacaaaaaaaceaaaaaaaaaeaea
aaaaeaeaaaaaaaaaaaaaaaaaegbabaaaabaaaaaadgaaaaaipcaabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaafmcaabaaaaaaaaaaa
agaebaaaaaaaaaaadgaaaaafbcaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaab
cbaaaaahccaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaahaaaaaaadaaaead
bkaabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaaaaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaadaaaaaa
agjmjaaaakaabaaaacaaaaaaegaobaaaabaaaaaaaaaaaaahmcaabaaaaaaaaaaa
kgaobaaaaaaaaaaaagbebaaaacaaaaaaboaaaaahbcaabaaaacaaaaaaakaabaaa
acaaaaaaabeaaaaaabaaaaaabgaaaaabdgaaaaafpccabaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0_level_9_1
eefiecedkefjebgeooefdcphfdeaiiolpogjdobnabaaaaaaeeafaaaaaeaaaaaa
daaaaaaaiiacaaaakaaeaaaabaafaaaaebgpgodjfaacaaaafaacaaaaaaacpppp
ciacaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
aaacppppfbaaaaafaaaaapkajoopkhdmjoopkhdmjoopkhdmaaaaaaaafbaaaaaf
abaaapkakabkkpdnkabkkpdnkabkkpdnaaaaaaaafbaaaaafacaaapkafeodkfdo
feodkfdofeodkfdoaaaaiadpfbaaaaafadaaapkagijbgndogijbgndogijbgndo
aaaaaaaafbaaaaafaeaaapkaaaaaeaeaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaacplabpaaaaacaaaaaaiaabaacdlabpaaaaacaaaaaajaaaaiapka
abaaaaacaaaaadiaabaaoelaaeaaaaaeaaaacdiaaaaaoeiaaeaaaakbaaaaoela
acaaaaadabaacdiaaaaaoeiaabaaoelaacaaaaadacaacdiaabaaoeiaabaaoela
acaaaaadadaacdiaacaaoeiaabaaoelaacaaaaadaeaacdiaadaaoeiaabaaoela
acaaaaadafaacdiaaeaaoeiaabaaoelaacaaaaadagaacdiaafaaoeiaabaaoela
ecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadabaacpiaabaaoeiaaaaioeka
ecaaaaadacaacpiaacaaoeiaaaaioekaecaaaaadadaacpiaadaaoeiaaaaioeka
ecaaaaadaeaacpiaaeaaoeiaaaaioekaecaaaaadafaacpiaafaaoeiaaaaioeka
ecaaaaadagaacpiaagaaoeiaaaaioekaafaaaaadabaacpiaabaaoeiaabaaoeka
aeaaaaaeaaaacpiaaaaaoeiaaaaaoekaabaaoeiaaeaaaaaeaaaacpiaacaaoeia
adaaoekaaaaaoeiaaeaaaaaeaaaacpiaadaaoeiaacaaoekaaaaaoeiaaeaaaaae
aaaacpiaaeaaoeiaadaaoekaaaaaoeiaaeaaaaaeaaaacpiaafaaoeiaabaaoeka
aaaaoeiaaeaaaaaeaaaacpiaagaaoeiaaaaaoekaaaaaoeiaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefcbaacaaaaeaaaaaaaieaaaaaadfbiaaaaboaaaaaa
joopkhdmaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaa
gijbgndoaaaaaaaaaaaaaaaaaaaaaaaafeodkfdoaaaaaaaaaaaaaaaaaaaaiadp
gijbgndoaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaa
joopkhdmaaaaaaaaaaaaaaaaaaaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadcaaaaandcaabaaa
aaaaaaaaegbabaiaebaaaaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaaaaa
aaaaaaaaegbabaaaabaaaaaadgaaaaaipcaabaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadgaaaaafmcaabaaaaaaaaaaaagaebaaaaaaaaaaa
dgaaaaafbcaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahccaabaaa
acaaaaaaakaabaaaacaaaaaaabeaaaaaahaaaaaaadaaaeadbkaabaaaacaaaaaa
efaaaaajpcaabaaaadaaaaaaogakbaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaadaaaaaaagjmjaaaakaabaaa
acaaaaaaegaobaaaabaaaaaaaaaaaaahmcaabaaaaaaaaaaakgaobaaaaaaaaaaa
agbebaaaacaaaaaaboaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
abaaaaaabgaaaaabdgaaaaafpccabaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab
ejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapadaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
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
Vector 5 [_MainTex_TexelSize]
Vector 6 [_Parameter]
"!!ARBvp1.0
# 9 ALU
PARAM c[7] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..6] };
TEMP R0;
MOV R0.x, c[6];
MUL R0.xy, R0.x, c[5];
MOV result.texcoord[0].xy, vertex.texcoord[0];
MOV result.texcoord[0].zw, c[0].x;
MUL result.texcoord[1].xy, R0, c[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
Vector 5 [_Parameter]
"vs_2_0
; 9 ALU
def c6, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c4
mul r0.xy, c5.x, r0
mov oT0.xy, v1
mov oT0.zw, c6.x
mul oT1.xy, r0, c6
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedknnfhnkplifkjhmkgkbpdknlkbjglmjbabaaaaaakmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcleabaaaaeaaaabaagnaaaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaadgaaaaaimccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaiadpdgaaaaaijcaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaggcaabaaaaaaaaaaa
agiacaaaaaaaaaaaacaaaaaadiaaaaaidcaabaaaaaaaaaaaegaabaaaaaaaaaaa
egiacaaaaaaaaaaaabaaaaaadiaaaaahdccabaaaacaaaaaaogakbaaaaaaaaaaa
egaabaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedibecoikdahdlolppicmcibpjggnngfooabaaaaaapmadaaaaaeaaaaaa
daaaaaaahmabaaaadiadaaaaimadaaaaebgpgodjeeabaaaaeeabaaaaaaacpopp
aeabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaaf
ahaaapkaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaabiaabaaapjaabaaaaacaaaaadiaahaaoekaafaaaaadaaaaapia
aaaabeiaacaaaakaacaaaaadaaaaadiaaaaaoeiaahaaobkaafaaaaadaaaaadia
aaaaoeiaabaaoekaafaaaaadabaaadoaaaaaooiaaaaaoeiaafaaaaadaaaaapia
aaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaaeaaaaaeaaaaapoaabaaaejaahaaafkaahaafakappppaaaafdeieefc
leabaaaaeaaaabaagnaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaae
egiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
abaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
dgaaaaaimccabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaiadp
dgaaaaaijcaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
dgaaaaaggcaabaaaaaaaaaaaagiacaaaaaaaaaaaacaaaaaadiaaaaaidcaabaaa
aaaaaaaaegaabaaaaaaaaaaaegiacaaaaaaaaaaaabaaaaaadiaaaaahdccabaaa
acaaaaaaogakbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaabejfdeheoemaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
ebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeo
aafeeffiedepepfceeaaklklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 7 TEX
PARAM c[2] = { { 3, 0.020492554, 0, 0.085510254 },
		{ 0.23205566, 0, 0.32397461, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
MOV R0.xy, fragment.texcoord[0];
MAD R5.xy, -fragment.texcoord[1], c[0].x, R0;
ADD R5.zw, R5.xyxy, fragment.texcoord[1].xyxy;
ADD R4.xy, R5.zwzw, fragment.texcoord[1];
ADD R3.xy, R4, fragment.texcoord[1];
ADD R2.xy, R3, fragment.texcoord[1];
ADD R1.xy, R2, fragment.texcoord[1];
ADD R0.xy, R1, fragment.texcoord[1];
TEX R6, R5.zwzw, texture[0], 2D;
TEX R0, R0, texture[0], 2D;
TEX R1, R1, texture[0], 2D;
TEX R2, R2, texture[0], 2D;
TEX R3, R3, texture[0], 2D;
TEX R4, R4, texture[0], 2D;
TEX R5, R5, texture[0], 2D;
MUL R6, R6, c[0].wwwz;
MAD R5, R5, c[0].yyyz, R6;
MAD R4, R4, c[1].xxxy, R5;
MAD R3, R3, c[1].zzzw, R4;
MAD R2, R2, c[1].xxxy, R3;
MAD R1, R1, c[0].wwwz, R2;
MAD result.color, R0, c[0].yyyz, R1;
END
# 22 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
; 30 ALU, 7 TEX
dcl_2d s0
def c0, 3.00000000, 0.08551025, 0.00000000, 0.02049255
def c1, 0.23205566, 0.00000000, 0.32397461, 1.00000000
dcl t0.xy
dcl t1.xy
mov_pp r0.xy, t0
mad_pp r0.xy, -t1, c0.x, r0
add_pp r1.xy, r0, t1
add_pp r2.xy, r1, t1
add_pp r3.xy, r2, t1
add_pp r4.xy, r3, t1
add_pp r5.xy, r4, t1
add_pp r6.xy, r5, t1
mov r0.w, c0.z
texld r7, r6, s0
texld r6, r5, s0
texld r5, r4, s0
texld r4, r3, s0
texld r3, r2, s0
texld r2, r0, s0
texld r1, r1, s0
mov r0.xyz, c0.y
mul_pp r1, r1, r0
mov r0.xyz, c0.w
mov r0.w, c0.z
mad_pp r1, r2, r0, r1
mov r0.xyz, c1.x
mov r0.w, c1.y
mad_pp r1, r3, r0, r1
mov r0.xyz, c1.z
mov r0.w, c1
mad_pp r1, r4, r0, r1
mov r0.xyz, c1.x
mov r0.w, c1.y
mad_pp r1, r5, r0, r1
mov r0.xyz, c0.y
mov r0.w, c0.z
mad_pp r1, r6, r0, r1
mov r0.xyz, c0.w
mov r0.w, c0.z
mad_pp r0, r7, r0, r1
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0
eefiecedpmidpnaopnhhgdlplnhdohjapolhdokbabaaaaaaoiacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbaacaaaaeaaaaaaaieaaaaaa
dfbiaaaaboaaaaaajoopkhdmaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaa
aaaaaaaaaaaaaaaagijbgndoaaaaaaaaaaaaaaaaaaaaaaaafeodkfdoaaaaaaaa
aaaaaaaaaaaaiadpgijbgndoaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaa
aaaaaaaaaaaaaaaajoopkhdmaaaaaaaaaaaaaaaaaaaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
dcaaaaandcaabaaaaaaaaaaaegbabaiaebaaaaaaacaaaaaaaceaaaaaaaaaeaea
aaaaeaeaaaaaaaaaaaaaaaaaegbabaaaabaaaaaadgaaaaaipcaabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaafmcaabaaaaaaaaaaa
agaebaaaaaaaaaaadgaaaaafbcaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaab
cbaaaaahccaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaahaaaaaaadaaaead
bkaabaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaaaaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaadaaaaaa
agjmjaaaakaabaaaacaaaaaaegaobaaaabaaaaaaaaaaaaahmcaabaaaaaaaaaaa
kgaobaaaaaaaaaaaagbebaaaacaaaaaaboaaaaahbcaabaaaacaaaaaaakaabaaa
acaaaaaaabeaaaaaabaaaaaabgaaaaabdgaaaaafpccabaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0_level_9_1
eefiecedkefjebgeooefdcphfdeaiiolpogjdobnabaaaaaaeeafaaaaaeaaaaaa
daaaaaaaiiacaaaakaaeaaaabaafaaaaebgpgodjfaacaaaafaacaaaaaaacpppp
ciacaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
aaacppppfbaaaaafaaaaapkajoopkhdmjoopkhdmjoopkhdmaaaaaaaafbaaaaaf
abaaapkakabkkpdnkabkkpdnkabkkpdnaaaaaaaafbaaaaafacaaapkafeodkfdo
feodkfdofeodkfdoaaaaiadpfbaaaaafadaaapkagijbgndogijbgndogijbgndo
aaaaaaaafbaaaaafaeaaapkaaaaaeaeaaaaaaaaaaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaacplabpaaaaacaaaaaaiaabaacdlabpaaaaacaaaaaajaaaaiapka
abaaaaacaaaaadiaabaaoelaaeaaaaaeaaaacdiaaaaaoeiaaeaaaakbaaaaoela
acaaaaadabaacdiaaaaaoeiaabaaoelaacaaaaadacaacdiaabaaoeiaabaaoela
acaaaaadadaacdiaacaaoeiaabaaoelaacaaaaadaeaacdiaadaaoeiaabaaoela
acaaaaadafaacdiaaeaaoeiaabaaoelaacaaaaadagaacdiaafaaoeiaabaaoela
ecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadabaacpiaabaaoeiaaaaioeka
ecaaaaadacaacpiaacaaoeiaaaaioekaecaaaaadadaacpiaadaaoeiaaaaioeka
ecaaaaadaeaacpiaaeaaoeiaaaaioekaecaaaaadafaacpiaafaaoeiaaaaioeka
ecaaaaadagaacpiaagaaoeiaaaaioekaafaaaaadabaacpiaabaaoeiaabaaoeka
aeaaaaaeaaaacpiaaaaaoeiaaaaaoekaabaaoeiaaeaaaaaeaaaacpiaacaaoeia
adaaoekaaaaaoeiaaeaaaaaeaaaacpiaadaaoeiaacaaoekaaaaaoeiaaeaaaaae
aaaacpiaaeaaoeiaadaaoekaaaaaoeiaaeaaaaaeaaaacpiaafaaoeiaabaaoeka
aaaaoeiaaeaaaaaeaaaacpiaagaaoeiaaaaaoekaaaaaoeiaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefcbaacaaaaeaaaaaaaieaaaaaadfbiaaaaboaaaaaa
joopkhdmaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaa
gijbgndoaaaaaaaaaaaaaaaaaaaaaaaafeodkfdoaaaaaaaaaaaaaaaaaaaaiadp
gijbgndoaaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaa
joopkhdmaaaaaaaaaaaaaaaaaaaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadcaaaaandcaabaaa
aaaaaaaaegbabaiaebaaaaaaacaaaaaaaceaaaaaaaaaeaeaaaaaeaeaaaaaaaaa
aaaaaaaaegbabaaaabaaaaaadgaaaaaipcaabaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadgaaaaafmcaabaaaaaaaaaaaagaebaaaaaaaaaaa
dgaaaaafbcaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahccaabaaa
acaaaaaaakaabaaaacaaaaaaabeaaaaaahaaaaaaadaaaeadbkaabaaaacaaaaaa
efaaaaajpcaabaaaadaaaaaaogakbaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaadaaaaaaagjmjaaaakaabaaa
acaaaaaaegaobaaaabaaaaaaaaaaaaahmcaabaaaaaaaaaaakgaobaaaaaaaaaaa
agbebaaaacaaaaaaboaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
abaaaaaabgaaaaabdgaaaaafpccabaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab
ejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapadaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
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
Vector 5 [_MainTex_TexelSize]
Vector 6 [_Parameter]
"!!ARBvp1.0
# 14 ALU
PARAM c[7] = { { 0, 1, 3, -1 },
		state.matrix.mvp,
		program.local[5..6] };
TEMP R0;
TEMP R1;
MOV R0.x, c[6];
MUL R0.xy, R0.x, c[5];
MUL R0.xy, R0, c[0];
MUL R0.zw, -R0.xyxy, c[0].z;
ADD R1.xy, R0.zwzw, R0;
ADD R0.xy, R0, R1;
MAD result.texcoord[1], R0.zwzw, c[0].yyww, vertex.texcoord[0].xyxy;
MAD result.texcoord[2], R1.xyxy, c[0].yyww, vertex.texcoord[0].xyxy;
MAD result.texcoord[3], R0.xyxy, c[0].yyww, vertex.texcoord[0].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
Vector 5 [_Parameter]
"vs_2_0
; 14 ALU
def c6, 0.00000000, 1.00000000, 3.00000000, -1.00000000
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c4
mul r0.xy, c5.x, r0
mul r0.xy, r0, c6
mul r0.zw, -r0.xyxy, c6.z
add r1.xy, r0.zwzw, r0
add r0.xy, r0, r1
mad oT1, r0.zwzw, c6.yyww, v1.xyxy
mad oT2, r1.xyxy, c6.yyww, v1.xyxy
mad oT3, r0.xyxy, c6.yyww, v1.xyxy
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
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedejhdcogpfbfempodfdhckfkgiigpgngfabaaaaaafmadaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcdeacaaaaeaaaabaainaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaa
fjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaadgaaaaag
bcaabaaaaaaaaaaaakiacaaaaaaaaaaaacaaaaaadgaaaaafccaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaaidcaabaaaaaaaaaaaegaabaaaaaaaaaaaegiacaaa
aaaaaaaaabaaaaaadiaaaaaiecaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaacaaaaaadcaaaaampccabaaaacaaaaaaigaibaaaaaaaaaaaaceaaaaa
aaaaaaiaaaaaeamaaaaaaaaaaaaaeaeaegbebaaaabaaaaaadcaaaaampccabaaa
adaaaaaaigaibaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaamaaaaaaaiaaaaaaaea
egbebaaaabaaaaaadcaaaaampccabaaaaeaaaaaaigaibaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaialpaaaaaaiaaaaaiadpegbebaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedaoblgagnopeeeoofmhnmpcgcglkkcbkpabaaaaaaaeafaaaaaeaaaaaa
daaaaaaaneabaaaabaaeaaaageaeaaaaebgpgodjjmabaaaajmabaaaaaaacpopp
fmabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaaf
ahaaapkaaaaaiadpaaaaaaaaaaaaialpaaaaaaiafbaaaaafaiaaapkaaaaaaaaa
aaaaaamaaaaaaaiaaaaaaaeafbaaaaafajaaapkaaaaaaaiaaaaaeamaaaaaaaaa
aaaaeaeabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaabaaaaac
aaaaadiaahaaoekaaeaaaaaeaaaaadiaacaaaakaaaaaoeiaaaaaobiaafaaaaad
aaaaadiaaaaaoeiaabaaoekaafaaaaadaaaaaeiaaaaaffiaacaaaakaaeaaaaae
abaaapoaaaaaiiiaajaaoekaabaaeejaaeaaaaaeacaaapoaaaaaiiiaaiaaoeka
abaaeejaaeaaaaaeadaaapoaaaaaiiiaahaadjkaabaaeejaafaaaaadaaaaapia
aaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaabaaaaacaaaaadoaabaaoejappppaaaafdeieefcdeacaaaaeaaaabaa
inaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
dccabaaaabaaaaaaegbabaaaabaaaaaadgaaaaagbcaabaaaaaaaaaaaakiacaaa
aaaaaaaaacaaaaaadgaaaaafccaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaai
dcaabaaaaaaaaaaaegaabaaaaaaaaaaaegiacaaaaaaaaaaaabaaaaaadiaaaaai
ecaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaacaaaaaadcaaaaam
pccabaaaacaaaaaaigaibaaaaaaaaaaaaceaaaaaaaaaaaiaaaaaeamaaaaaaaaa
aaaaeaeaegbebaaaabaaaaaadcaaaaampccabaaaadaaaaaaigaibaaaaaaaaaaa
aceaaaaaaaaaaaaaaaaaaamaaaaaaaiaaaaaaaeaegbebaaaabaaaaaadcaaaaam
pccabaaaaeaaaaaaigaibaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaialpaaaaaaia
aaaaiadpegbebaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 14 ALU, 7 TEX
PARAM c[2] = { { 0.32397461, 1, 0.020492554, 0 },
		{ 0.085510254, 0, 0.23205566 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R5, fragment.texcoord[3], texture[0], 2D;
TEX R6, fragment.texcoord[3].zwzw, texture[0], 2D;
TEX R3, fragment.texcoord[2], texture[0], 2D;
TEX R4, fragment.texcoord[2].zwzw, texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[0], 2D;
TEX R2, fragment.texcoord[1].zwzw, texture[0], 2D;
ADD R1, R1, R2;
MUL R0, R0, c[0].xxxy;
MAD R0, R1, c[0].zzzw, R0;
ADD R1, R3, R4;
MAD R0, R1, c[1].xxxy, R0;
ADD R1, R5, R6;
MAD result.color, R1, c[1].zzzy, R0;
END
# 14 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
; 24 ALU, 7 TEX
dcl_2d s0
def c0, 0.32397461, 1.00000000, 0.02049255, 0.00000000
def c1, 0.08551025, 0.00000000, 0.23205566, 0
dcl t0.xy
dcl t1
dcl t2
dcl t3
texld r1, t3, s0
texld r3, t2, s0
texld r6, t0, s0
texld r5, t1, s0
mov r0.y, t1.w
mov r0.x, t1.z
mov r4.xy, r0
mov r0.y, t2.w
mov r0.x, t2.z
mov r2.xy, r0
mov r0.y, t3.w
mov r0.x, t3.z
texld r0, r0, s0
texld r2, r2, s0
texld r4, r4, s0
add_pp r3, r3, r2
add_pp r1, r1, r0
add_pp r5, r5, r4
mov r4.w, c0.y
mov r4.xyz, c0.x
mul r6, r6, r4
mov r4.xyz, c0.z
mov r4.w, c0
mad_pp r4, r5, r4, r6
mov r2.xyz, c1.x
mov r2.w, c1.y
mad_pp r2, r3, r2, r4
mov r0.xyz, c1.z
mov r0.w, c1.y
mad_pp r0, r1, r0, r2
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0
eefiecedcnalanggfhdbmlmgfgfomnpjmamipbmoabaaaaaagmadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcgeacaaaaeaaaaaaajjaaaaaadfbiaaaaboaaaaaajoopkhdmaaaaaaaa
aaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaagijbgndoaaaaaaaa
aaaaaaaaaaaaaaaafeodkfdoaaaaaaaaaaaaaaaaaaaaiadpgijbgndoaaaaaaaa
aaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaajoopkhdmaaaaaaaa
aaaaaaaaaaaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacafaaaaaaflaaaaaepcbabaaaacaaaaaaadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaafeodkfdofeodkfdofeodkfdo
aaaaiadpdgaaaaafpcaabaaaabaaaaaaegaobaaaaaaaaaaadgaaaaafbcaabaaa
acaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahccaabaaaacaaaaaaakaabaaa
acaaaaaaabeaaaaaadaaaaaaadaaaeadbkaabaaaacaaaaaaefaaaaalpcaabaaa
adaaaaaaegbanaaaacaaaaaaakaabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaefaaaaalpcaabaaaaeaaaaaaogbknaaaacaaaaaaakaabaaaacaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaadaaaaaa
agjmjaaaakaabaaaacaaaaaaegaobaaaabaaaaaaboaaaaahbcaabaaaacaaaaaa
akaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabdgaaaaafpccabaaaaaaaaaaa
egaobaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0_level_9_1
eefiecedhomcjagglehhdmedklabbaaojdhjjbdhabaaaaaaieafaaaaaeaaaaaa
daaaaaaaeeacaaaalaaeaaaafaafaaaaebgpgodjamacaaaaamacaaaaaaacpppp
oeabaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
aaacppppfbaaaaafaaaaapkajoopkhdmjoopkhdmjoopkhdmaaaaaaaafbaaaaaf
abaaapkakabkkpdnkabkkpdnkabkkpdnaaaaaaaafbaaaaafacaaapkagijbgndo
gijbgndogijbgndoaaaaaaaafbaaaaafadaaapkafeodkfdofeodkfdofeodkfdo
aaaaiadpbpaaaaacaaaaaaiaaaaacdlabpaaaaacaaaaaaiaabaacplabpaaaaac
aaaaaaiaacaacplabpaaaaacaaaaaaiaadaacplabpaaaaacaaaaaajaaaaiapka
abaaaaacaaaacbiaabaakklaabaaaaacaaaacciaabaapplaabaaaaacabaacbia
acaakklaabaaaaacabaacciaacaapplaabaaaaacacaacbiaadaakklaabaaaaac
acaacciaadaapplaecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadadaacpia
abaaoelaaaaioekaecaaaaadaeaaapiaaaaaoelaaaaioekaecaaaaadabaacpia
abaaoeiaaaaioekaecaaaaadafaacpiaacaaoelaaaaioekaecaaaaadacaacpia
acaaoeiaaaaioekaecaaaaadagaacpiaadaaoelaaaaioekaacaaaaadaaaacpia
aaaaoeiaadaaoeiaafaaaaadaaaacpiaaaaaoeiaaaaaoekaaeaaaaaeaaaacpia
aeaaoeiaadaaoekaaaaaoeiaacaaaaadabaacpiaabaaoeiaafaaoeiaaeaaaaae
aaaacpiaabaaoeiaabaaoekaaaaaoeiaacaaaaadabaacpiaacaaoeiaagaaoeia
aeaaaaaeaaaacpiaabaaoeiaacaaoekaaaaaoeiaabaaaaacaaaicpiaaaaaoeia
ppppaaaafdeieefcgeacaaaaeaaaaaaajjaaaaaadfbiaaaaboaaaaaajoopkhdm
aaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaagijbgndo
aaaaaaaaaaaaaaaaaaaaaaaafeodkfdoaaaaaaaaaaaaaaaaaaaaiadpgijbgndo
aaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaajoopkhdm
aaaaaaaaaaaaaaaaaaaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacafaaaaaaflaaaaaepcbabaaaacaaaaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaafeodkfdofeodkfdo
feodkfdoaaaaiadpdgaaaaafpcaabaaaabaaaaaaegaobaaaaaaaaaaadgaaaaaf
bcaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahccaabaaaacaaaaaa
akaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeadbkaabaaaacaaaaaaefaaaaal
pcaabaaaadaaaaaaegbanaaaacaaaaaaakaabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaefaaaaalpcaabaaaaeaaaaaaogbknaaaacaaaaaaakaabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahpcaabaaaadaaaaaa
egaobaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaa
adaaaaaaagjmjaaaakaabaaaacaaaaaaegaobaaaabaaaaaaboaaaaahbcaabaaa
acaaaaaaakaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabdgaaaaafpccabaaa
aaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaapapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaa
imaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
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
Vector 5 [_MainTex_TexelSize]
Vector 6 [_Parameter]
"!!ARBvp1.0
# 14 ALU
PARAM c[7] = { { 1, 0, 3, -1 },
		state.matrix.mvp,
		program.local[5..6] };
TEMP R0;
TEMP R1;
MOV R0.x, c[6];
MUL R0.xy, R0.x, c[5];
MUL R0.xy, R0, c[0];
MUL R0.zw, -R0.xyxy, c[0].z;
ADD R1.xy, R0.zwzw, R0;
ADD R0.xy, R0, R1;
MAD result.texcoord[1], R0.zwzw, c[0].xxww, vertex.texcoord[0].xyxy;
MAD result.texcoord[2], R1.xyxy, c[0].xxww, vertex.texcoord[0].xyxy;
MAD result.texcoord[3], R0.xyxy, c[0].xxww, vertex.texcoord[0].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
Vector 5 [_Parameter]
"vs_2_0
; 14 ALU
def c6, 1.00000000, 0.00000000, 3.00000000, -1.00000000
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c4
mul r0.xy, c5.x, r0
mul r0.xy, r0, c6
mul r0.zw, -r0.xyxy, c6.z
add r1.xy, r0.zwzw, r0
add r0.xy, r0, r1
mad oT1, r0.zwzw, c6.xxww, v1.xyxy
mad oT2, r1.xyxy, c6.xxww, v1.xyxy
mad oT3, r0.xyxy, c6.xxww, v1.xyxy
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
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedibidhfkkhiggipkdlobdngnbdebbfokaabaaaaaafmadaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcdeacaaaaeaaaabaainaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaa
fjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaadgaaaaaf
ccaabaaaaaaaaaaaabeaaaaaaaaaiadpdgaaaaagecaabaaaaaaaaaaaakiacaaa
aaaaaaaaacaaaaaadiaaaaaigcaabaaaaaaaaaaafgagbaaaaaaaaaaaagibcaaa
aaaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaacaaaaaadcaaaaampccabaaaacaaaaaaigaibaaaaaaaaaaaaceaaaaa
aaaaeamaaaaaaaiaaaaaeaeaaaaaaaaaegbebaaaabaaaaaadcaaaaampccabaaa
adaaaaaaigaibaaaaaaaaaaaaceaaaaaaaaaaamaaaaaaaaaaaaaaaeaaaaaaaia
egbebaaaabaaaaaadcaaaaampccabaaaaeaaaaaaigaibaaaaaaaaaaaaceaaaaa
aaaaialpaaaaaaaaaaaaiadpaaaaaaiaegbebaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80
Vector 16 [_MainTex_TexelSize]
Vector 32 [_Parameter]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedfmkhhgkcnnncngafjkeijnngkcfionneabaaaaaaaeafaaaaaeaaaaaa
daaaaaaaneabaaaabaaeaaaageaeaaaaebgpgodjjmabaaaajmabaaaaaaacpopp
fmabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaaf
ahaaapkaaaaaaaaaaaaaiadpaaaaialpaaaaaaiafbaaaaafaiaaapkaaaaaaama
aaaaaaaaaaaaaaeaaaaaaaiafbaaaaafajaaapkaaaaaeamaaaaaaaiaaaaaeaea
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaabaaaaac
aaaaadiaahaaoekaaeaaaaaeaaaaadiaacaaaakaaaaaoeiaaaaaobiaafaaaaad
aaaaagiaaaaanaiaabaanakaafaaaaadaaaaabiaaaaaffiaacaaaakaaeaaaaae
abaaapoaaaaaiiiaajaaoekaabaaeejaaeaaaaaeacaaapoaaaaaiiiaaiaaoeka
abaaeejaaeaaaaaeadaaapoaaaaaiiiaahaanckaabaaeejaafaaaaadaaaaapia
aaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaabaaaaacaaaaadoaabaaoejappppaaaafdeieefcdeacaaaaeaaaabaa
inaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
dccabaaaabaaaaaaegbabaaaabaaaaaadgaaaaafccaabaaaaaaaaaaaabeaaaaa
aaaaiadpdgaaaaagecaabaaaaaaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaai
gcaabaaaaaaaaaaafgagbaaaaaaaaaaaagibcaaaaaaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaacaaaaaadcaaaaam
pccabaaaacaaaaaaigaibaaaaaaaaaaaaceaaaaaaaaaeamaaaaaaaiaaaaaeaea
aaaaaaaaegbebaaaabaaaaaadcaaaaampccabaaaadaaaaaaigaibaaaaaaaaaaa
aceaaaaaaaaaaamaaaaaaaaaaaaaaaeaaaaaaaiaegbebaaaabaaaaaadcaaaaam
pccabaaaaeaaaaaaigaibaaaaaaaaaaaaceaaaaaaaaaialpaaaaaaaaaaaaiadp
aaaaaaiaegbebaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 14 ALU, 7 TEX
PARAM c[2] = { { 0.32397461, 1, 0.020492554, 0 },
		{ 0.085510254, 0, 0.23205566 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R5, fragment.texcoord[3], texture[0], 2D;
TEX R6, fragment.texcoord[3].zwzw, texture[0], 2D;
TEX R3, fragment.texcoord[2], texture[0], 2D;
TEX R4, fragment.texcoord[2].zwzw, texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[0], 2D;
TEX R2, fragment.texcoord[1].zwzw, texture[0], 2D;
ADD R1, R1, R2;
MUL R0, R0, c[0].xxxy;
MAD R0, R1, c[0].zzzw, R0;
ADD R1, R3, R4;
MAD R0, R1, c[1].xxxy, R0;
ADD R1, R5, R6;
MAD result.color, R1, c[1].zzzy, R0;
END
# 14 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
; 24 ALU, 7 TEX
dcl_2d s0
def c0, 0.32397461, 1.00000000, 0.02049255, 0.00000000
def c1, 0.08551025, 0.00000000, 0.23205566, 0
dcl t0.xy
dcl t1
dcl t2
dcl t3
texld r1, t3, s0
texld r3, t2, s0
texld r6, t0, s0
texld r5, t1, s0
mov r0.y, t1.w
mov r0.x, t1.z
mov r4.xy, r0
mov r0.y, t2.w
mov r0.x, t2.z
mov r2.xy, r0
mov r0.y, t3.w
mov r0.x, t3.z
texld r0, r0, s0
texld r2, r2, s0
texld r4, r4, s0
add_pp r3, r3, r2
add_pp r1, r1, r0
add_pp r5, r5, r4
mov r4.w, c0.y
mov r4.xyz, c0.x
mul r6, r6, r4
mov r4.xyz, c0.z
mov r4.w, c0
mad_pp r4, r5, r4, r6
mov r2.xyz, c1.x
mov r2.w, c1.y
mad_pp r2, r3, r2, r4
mov r0.xyz, c1.z
mov r0.w, c1.y
mad_pp r0, r1, r0, r2
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0
eefiecedcnalanggfhdbmlmgfgfomnpjmamipbmoabaaaaaagmadaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcgeacaaaaeaaaaaaajjaaaaaadfbiaaaaboaaaaaajoopkhdmaaaaaaaa
aaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaagijbgndoaaaaaaaa
aaaaaaaaaaaaaaaafeodkfdoaaaaaaaaaaaaaaaaaaaaiadpgijbgndoaaaaaaaa
aaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaajoopkhdmaaaaaaaa
aaaaaaaaaaaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacafaaaaaaflaaaaaepcbabaaaacaaaaaaadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaafeodkfdofeodkfdofeodkfdo
aaaaiadpdgaaaaafpcaabaaaabaaaaaaegaobaaaaaaaaaaadgaaaaafbcaabaaa
acaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahccaabaaaacaaaaaaakaabaaa
acaaaaaaabeaaaaaadaaaaaaadaaaeadbkaabaaaacaaaaaaefaaaaalpcaabaaa
adaaaaaaegbanaaaacaaaaaaakaabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaefaaaaalpcaabaaaaeaaaaaaogbknaaaacaaaaaaakaabaaaacaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaadaaaaaa
agjmjaaaakaabaaaacaaaaaaegaobaaaabaaaaaaboaaaaahbcaabaaaacaaaaaa
akaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabdgaaaaafpccabaaaaaaaaaaa
egaobaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
SetTexture 0 [_MainTex] 2D 0
"ps_4_0_level_9_1
eefiecedhomcjagglehhdmedklabbaaojdhjjbdhabaaaaaaieafaaaaaeaaaaaa
daaaaaaaeeacaaaalaaeaaaafaafaaaaebgpgodjamacaaaaamacaaaaaaacpppp
oeabaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
aaacppppfbaaaaafaaaaapkajoopkhdmjoopkhdmjoopkhdmaaaaaaaafbaaaaaf
abaaapkakabkkpdnkabkkpdnkabkkpdnaaaaaaaafbaaaaafacaaapkagijbgndo
gijbgndogijbgndoaaaaaaaafbaaaaafadaaapkafeodkfdofeodkfdofeodkfdo
aaaaiadpbpaaaaacaaaaaaiaaaaacdlabpaaaaacaaaaaaiaabaacplabpaaaaac
aaaaaaiaacaacplabpaaaaacaaaaaaiaadaacplabpaaaaacaaaaaajaaaaiapka
abaaaaacaaaacbiaabaakklaabaaaaacaaaacciaabaapplaabaaaaacabaacbia
acaakklaabaaaaacabaacciaacaapplaabaaaaacacaacbiaadaakklaabaaaaac
acaacciaadaapplaecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadadaacpia
abaaoelaaaaioekaecaaaaadaeaaapiaaaaaoelaaaaioekaecaaaaadabaacpia
abaaoeiaaaaioekaecaaaaadafaacpiaacaaoelaaaaioekaecaaaaadacaacpia
acaaoeiaaaaioekaecaaaaadagaacpiaadaaoelaaaaioekaacaaaaadaaaacpia
aaaaoeiaadaaoeiaafaaaaadaaaacpiaaaaaoeiaaaaaoekaaeaaaaaeaaaacpia
aeaaoeiaadaaoekaaaaaoeiaacaaaaadabaacpiaabaaoeiaafaaoeiaaeaaaaae
aaaacpiaabaaoeiaabaaoekaaaaaoeiaacaaaaadabaacpiaacaaoeiaagaaoeia
aeaaaaaeaaaacpiaabaaoeiaacaaoekaaaaaoeiaabaaaaacaaaicpiaaaaaoeia
ppppaaaafdeieefcgeacaaaaeaaaaaaajjaaaaaadfbiaaaaboaaaaaajoopkhdm
aaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaagijbgndo
aaaaaaaaaaaaaaaaaaaaaaaafeodkfdoaaaaaaaaaaaaaaaaaaaaiadpgijbgndo
aaaaaaaaaaaaaaaaaaaaaaaakabkkpdnaaaaaaaaaaaaaaaaaaaaaaaajoopkhdm
aaaaaaaaaaaaaaaaaaaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacafaaaaaaflaaaaaepcbabaaaacaaaaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaafeodkfdofeodkfdo
feodkfdoaaaaiadpdgaaaaafpcaabaaaabaaaaaaegaobaaaaaaaaaaadgaaaaaf
bcaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahccaabaaaacaaaaaa
akaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeadbkaabaaaacaaaaaaefaaaaal
pcaabaaaadaaaaaaegbanaaaacaaaaaaakaabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaefaaaaalpcaabaaaaeaaaaaaogbknaaaacaaaaaaakaabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahpcaabaaaadaaaaaa
egaobaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaa
adaaaaaaagjmjaaaakaabaaaacaaaaaaegaobaaaabaaaaaaboaaaaahbcaabaaa
acaaaaaaakaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabdgaaaaafpccabaaa
aaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaapapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaa
imaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}
}
 }
}
Fallback Off
}