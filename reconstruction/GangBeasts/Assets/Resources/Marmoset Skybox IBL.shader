Shader "Hidden/Marmoset/Skybox IBL" {
SubShader { 
 Tags { "QUEUE"="Background" "RenderType"="Background" }
 Pass {
  Tags { "QUEUE"="Background" "RenderType"="Background" }
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [SkyMatrix]
"!!ARBvp1.0
# 7 ALU
PARAM c[9] = { program.local[0],
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
MUL R0.xyz, vertex.texcoord[0].z, c[7];
MAD R0.xyz, vertex.texcoord[0].y, c[6], R0;
MAD result.texcoord[0].xyz, vertex.texcoord[0].x, c[5], R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 7 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [SkyMatrix]
"vs_2_0
; 7 ALU
dcl_position0 v0
dcl_texcoord0 v1
mul r0.xyz, v1.z, c6
mad r0.xyz, v1.y, c5, r0
mad oT0.xyz, v1.x, c4, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlkdhpbnefjepphkkhjabmfnaifodhdegabaaaaaadiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklfdeieefcfiacaaaa
eaaaabaajgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaa
abaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedhimhlmijnoeedldimbclggpgdddjeaacabaaaaaamaaeaaaaaeaaaaaa
daaaaaaaleabaaaabeaeaaaagiaeaaaaebgpgodjhmabaaaahmabaaaaaaacpopp
dmabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
adaaabaaaaaaaaaaabaaaaaaaeaaaeaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaac
afaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaafaaaaadaaaaabiaabaaffja
abaaffkaafaaaaadaaaaaciaabaaffjaacaaffkaafaaaaadaaaaaeiaabaaffja
adaaffkaafaaaaadabaaabiaabaakkjaabaakkkaafaaaaadabaaaciaabaakkja
acaakkkaafaaaaadabaaaeiaabaakkjaadaakkkaacaaaaadaaaaahiaaaaaoeia
abaaoeiaafaaaaadabaaabiaabaaaajaabaaaakaafaaaaadabaaaciaabaaaaja
acaaaakaafaaaaadabaaaeiaabaaaajaadaaaakaacaaaaadaaaaahoaaaaaoeia
abaaoeiaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapiaaeaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcfiacaaaaeaaaabaa
jgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaaabaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffi
edepepfceeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [SkyMatrix]
"!!ARBvp1.0
# 7 ALU
PARAM c[9] = { program.local[0],
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
MUL R0.xyz, vertex.texcoord[0].z, c[7];
MAD R0.xyz, vertex.texcoord[0].y, c[6], R0;
MAD result.texcoord[0].xyz, vertex.texcoord[0].x, c[5], R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 7 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [SkyMatrix]
"vs_2_0
; 7 ALU
dcl_position0 v0
dcl_texcoord0 v1
mul r0.xyz, v1.z, c6
mad r0.xyz, v1.y, c5, r0
mad oT0.xyz, v1.x, c4, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlkdhpbnefjepphkkhjabmfnaifodhdegabaaaaaadiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklfdeieefcfiacaaaa
eaaaabaajgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaa
abaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedhimhlmijnoeedldimbclggpgdddjeaacabaaaaaamaaeaaaaaeaaaaaa
daaaaaaaleabaaaabeaeaaaagiaeaaaaebgpgodjhmabaaaahmabaaaaaaacpopp
dmabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
adaaabaaaaaaaaaaabaaaaaaaeaaaeaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaac
afaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaafaaaaadaaaaabiaabaaffja
abaaffkaafaaaaadaaaaaciaabaaffjaacaaffkaafaaaaadaaaaaeiaabaaffja
adaaffkaafaaaaadabaaabiaabaakkjaabaakkkaafaaaaadabaaaciaabaakkja
acaakkkaafaaaaadabaaaeiaabaakkjaadaakkkaacaaaaadaaaaahiaaaaaoeia
abaaoeiaafaaaaadabaaabiaabaaaajaabaaaakaafaaaaadabaaaciaabaaaaja
acaaaakaafaaaaadabaaaeiaabaaaajaadaaaakaacaaaaadaaaaahoaaaaaoeia
abaaoeiaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapiaaeaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcfiacaaaaeaaaabaa
jgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaaabaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffi
edepepfceeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [SkyMatrix]
"!!ARBvp1.0
# 7 ALU
PARAM c[9] = { program.local[0],
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
MUL R0.xyz, vertex.texcoord[0].z, c[7];
MAD R0.xyz, vertex.texcoord[0].y, c[6], R0;
MAD result.texcoord[0].xyz, vertex.texcoord[0].x, c[5], R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 7 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [SkyMatrix]
"vs_2_0
; 7 ALU
dcl_position0 v0
dcl_texcoord0 v1
mul r0.xyz, v1.z, c6
mad r0.xyz, v1.y, c5, r0
mad oT0.xyz, v1.x, c4, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlkdhpbnefjepphkkhjabmfnaifodhdegabaaaaaadiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklfdeieefcfiacaaaa
eaaaabaajgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaa
abaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedhimhlmijnoeedldimbclggpgdddjeaacabaaaaaamaaeaaaaaeaaaaaa
daaaaaaaleabaaaabeaeaaaagiaeaaaaebgpgodjhmabaaaahmabaaaaaaacpopp
dmabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
adaaabaaaaaaaaaaabaaaaaaaeaaaeaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaac
afaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaafaaaaadaaaaabiaabaaffja
abaaffkaafaaaaadaaaaaciaabaaffjaacaaffkaafaaaaadaaaaaeiaabaaffja
adaaffkaafaaaaadabaaabiaabaakkjaabaakkkaafaaaaadabaaaciaabaakkja
acaakkkaafaaaaadabaaaeiaabaakkjaadaakkkaacaaaaadaaaaahiaaaaaoeia
abaaoeiaafaaaaadabaaabiaabaaaajaabaaaakaafaaaaadabaaaciaabaaaaja
acaaaakaafaaaaadabaaaeiaabaaaajaadaaaakaacaaaaadaaaaahoaaaaaoeia
abaaoeiaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapiaaeaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcfiacaaaaeaaaabaa
jgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaaabaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffi
edepepfceeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [SkyMatrix]
"!!ARBvp1.0
# 7 ALU
PARAM c[9] = { program.local[0],
		state.matrix.mvp,
		program.local[5..8] };
TEMP R0;
MUL R0.xyz, vertex.texcoord[0].z, c[7];
MAD R0.xyz, vertex.texcoord[0].y, c[6], R0;
MAD result.texcoord[0].xyz, vertex.texcoord[0].x, c[5], R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 7 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [SkyMatrix]
"vs_2_0
; 7 ALU
dcl_position0 v0
dcl_texcoord0 v1
mul r0.xyz, v1.z, c6
mad r0.xyz, v1.y, c5, r0
mad oT0.xyz, v1.x, c4, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedlkdhpbnefjepphkkhjabmfnaifodhdegabaaaaaadiadaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklfdeieefcfiacaaaa
eaaaabaajgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaa
abaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaaaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaaakbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 96
Matrix 16 [SkyMatrix]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
eefiecedhimhlmijnoeedldimbclggpgdddjeaacabaaaaaamaaeaaaaaeaaaaaa
daaaaaaaleabaaaabeaeaaaagiaeaaaaebgpgodjhmabaaaahmabaaaaaaacpopp
dmabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
adaaabaaaaaaaaaaabaaaaaaaeaaaeaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaac
afaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaafaaaaadaaaaabiaabaaffja
abaaffkaafaaaaadaaaaaciaabaaffjaacaaffkaafaaaaadaaaaaeiaabaaffja
adaaffkaafaaaaadabaaabiaabaakkjaabaakkkaafaaaaadabaaaciaabaakkja
acaakkkaafaaaaadabaaaeiaabaakkjaadaakkkaacaaaaadaaaaahiaaaaaoeia
abaaoeiaafaaaaadabaaabiaabaaaajaabaaaakaafaaaaadabaaaciaabaaaaja
acaaaakaafaaaaadabaaaeiaabaaaajaadaaaakaacaaaaadaaaaahoaaaaaoeia
abaaoeiaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapiaaeaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcfiacaaaaeaaaabaa
jgaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafjaaaaaeegiocaaaabaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
aaaaaaaabkbabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaabaaaaaadiaaaaaiccaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaacaaaaaadiaaaaaiecaabaaaabaaaaaa
akbabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaaaaaaaaahhccabaaaabaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaafaepfdejfeejepeoaafeeffi
edepepfceeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 1 TEX
PARAM c[4] = { program.local[0],
		{ 0.0039215689, 1, 0, 0.45454544 },
		{ 0.75341797, 0.24682617, 0.16666667, 255 },
		{ 2.2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], CUBE;
MUL R1.x, R0.w, R0.w;
MUL R1.y, R0.w, R1.x;
MUL R1.xy, R1, c[2];
ADD R0.w, R1.x, R1.y;
MUL R0.xyz, R0, R0.w;
MUL R0.xyz, R0, c[0].z;
POW R0.x, R0.x, c[1].w;
POW R0.z, R0.z, c[1].w;
POW R0.y, R0.y, c[1].w;
MUL R1.xyz, R0, c[2].z;
MAX R0.x, R1, R1.y;
MAX_SAT R0.x, R0, R1.z;
MUL R0.x, R0, c[2].w;
FLR R0.x, -R0;
MUL R0.y, -R0.x, c[1].x;
SLT R0.x, c[1].z, R0.y;
RCP R0.z, R0.y;
ABS R0.x, R0;
CMP R0.x, -R0, c[1].z, c[1].y;
MUL_SAT R1.xyz, R1, R0.z;
MOV R1.w, R0.y;
CMP R0, -R0.x, c[1].z, R1;
POW result.color.x, R0.x, c[3].x;
POW result.color.y, R0.y, c[3].x;
POW result.color.z, R0.z, c[3].x;
MOV result.color.w, R0;
END
# 27 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"ps_2_0
; 44 ALU, 1 TEX
dcl_cube s0
def c1, 0.75341797, 0.24682617, 0.45454544, 0.16666667
def c2, 255.00000000, 0.00392157, 0.00000000, 1.00000000
def c3, 2.20000005, 0, 0, 0
dcl t0.xyz
texld r1, t0, s0
mul_pp r0.x, r1.w, r1.w
mul_pp r0.y, r1.w, r0.x
mul_pp r0.xy, r0, c1
add_pp r0.x, r0, r0.y
mul_pp r0.xyz, r1, r0.x
mul_pp r1.xyz, r0, c0.z
pow r2.x, r1.y, c1.z
pow r0.x, r1.x, c1.z
mov r1.x, r0.x
pow r0.y, r1.z, c1.z
mov r1.z, r0.y
mov r1.y, r2.x
mul r3.xyz, r1, c1.w
max r0.x, r3, r3.y
max_sat r0.x, r0, r3.z
mul r0.x, r0, c2
frc r1.x, -r0
add r0.x, -r0, -r1
mul r0.x, -r0, c2.y
cmp r1.x, -r0, c2.z, c2.w
rcp r2.x, r0.x
mov r2.w, r0.x
mul_sat r2.xyz, r3, r2.x
abs_pp r1.x, r1
cmp r1, -r1.x, c2.z, r2
pow r0.x, r1.x, c3.x
pow r2.x, r1.y, c3.x
mov r1.x, r0.x
pow r0.x, r1.z, c3.x
mov r1.y, r2.x
mov r1.z, r0.x
mov_pp oC0, r1
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedahljflcllejfnnhajlpgplkekkjcobocabaaaaaapiadaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiadaaaa
eaaaaaaamoaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafidaaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbcbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaa
abaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahccaabaaaabaaaaaa
dkaabaaaaaaaaaaaakaabaaaabaaaaaaapaaaaakicaabaaaaaaaaaaaaceaaaaa
lhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaakgikcaaaaaaaaaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaa
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
SubProgram "d3d11_9x " {
Keywords { "MARMO_LINEAR" "MARMO_RGBM" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
eefiecedahhldkomhjnamfjkdnhnedlpckmenihjabaaaaaaeeagaaaaaeaaaaaa
daaaaaaahiacaaaaliafaaaabaagaaaaebgpgodjeaacaaaaeaacaaaaaaacpppp
amacaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaaaaaabaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkalhnbeadpceljhmdo
aaaaaaaacplkoidofbaaaaafacaaapkaklkkckdoaaaahpedibiaiadlmnmmamea
bpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaajiaaaiapkaecaaaaadaaaacpia
aaaaoelaaaaioekaafaaaaadabaacbiaaaaappiaaaaappiaafaaaaadabaaccia
aaaappiaabaaaaiafkaaaaaeaaaaciiaabaaoekaabaaoeiaabaakkkaafaaaaad
aaaachiaaaaappiaaaaaoeiaafaaaaadaaaaahiaaaaaoeiaaaaakkkaapaaaaac
abaaabiaaaaaaaiaapaaaaacabaaaciaaaaaffiaapaaaaacabaaaeiaaaaakkia
afaaaaadaaaaahiaabaaoeiaabaappkaaoaaaaacabaaabiaaaaaaaiaaoaaaaac
abaaaciaaaaaffiaaoaaaaacabaaaeiaaaaakkiaafaaaaadaaaaahiaabaaoeia
acaaaakaalaaaaadabaaabiaaaaaaaiaaaaaffiaalaaaaadacaabiiaabaaaaia
aaaakkiaafaaaaadaaaaaiiaacaappiaacaaffkabdaaaaacabaaabiaaaaappib
acaaaaadaaaaaiiaaaaappiaabaaaaiaafaaaaadabaaaiiaaaaappiaacaakkka
agaaaaacacaaabiaabaappiaafaaaaadabaabhiaaaaaoeiaacaaaaiafiaaaaae
aaaaapiaaaaappibabaakkkaabaaoeiaapaaaaacabaaabiaaaaaaaiaapaaaaac
abaaaciaaaaaffiaapaaaaacabaaaeiaaaaakkiaafaaaaadabaaahiaabaaoeia
acaappkaaoaaaaacaaaacbiaabaaaaiaaoaaaaacaaaacciaabaaffiaaoaaaaac
aaaaceiaabaakkiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcdiadaaaa
eaaaaaaamoaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafidaaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbcbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaa
abaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahccaabaaaabaaaaaa
dkaabaaaaaaaaaaaakaabaaaabaaaaaaapaaaaakicaabaaaaaaaaaaaaceaaaaa
lhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaakgikcaaaaaaaaaaaaaaaaaaacpaaaaafhcaabaaaaaaaaaaa
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
bjaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheofaaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
eeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 8 ALU, 1 TEX
PARAM c[2] = { program.local[0],
		{ 1, 0.75341797, 0.24682617 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], CUBE;
MUL R1.x, R0.w, R0.w;
MUL R1.y, R0.w, R1.x;
MUL R1.xy, R1, c[1].yzzw;
ADD R0.w, R1.x, R1.y;
MUL R0.xyz, R0, R0.w;
MUL result.color.xyz, R0, c[0].z;
MOV result.color.w, c[1].x;
END
# 8 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"ps_2_0
; 8 ALU, 1 TEX
dcl_cube s0
def c1, 0.75341797, 0.24682617, 1.00000000, 0
dcl t0.xyz
texld r0, t0, s0
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c1
add_pp r1.x, r1, r1.y
mul_pp r0.xyz, r0, r1.x
mul_pp r0.xyz, r0, c0.z
mov r0.w, c1.z
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecednkdikacdkgdffnijpkidckikbbndfenbabaaaaaaomabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefccmabaaaa
eaaaaaaaelaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafidaaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbcbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaa
abaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahccaabaaaabaaaaaa
dkaabaaaaaaaaaaaakaabaaaabaaaaaaapaaaaakicaabaaaaaaaaaaaaceaaaaa
lhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihccabaaaaaaaaaaa
egacbaaaaaaaaaaakgikcaaaaaaaaaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "MARMO_LINEAR" "MARMO_RGBA" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
eefiecedbaioaaoablgilcljaepblmojlbjpegeaabaaaaaaoaacaaaaaeaaaaaa
daaaaaaacaabaaaafeacaaaakmacaaaaebgpgodjoiaaaaaaoiaaaaaaaaacpppp
leaaaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaaaaaabaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkalhnbeadpceljhmdo
aaaaaaaaaaaaiadpbpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaajiaaaiapka
ecaaaaadaaaacpiaaaaaoelaaaaioekaafaaaaadabaacbiaaaaappiaaaaappia
afaaaaadabaacciaaaaappiaabaaaaiafkaaaaaeaaaaciiaabaaoekaabaaoeia
abaakkkaafaaaaadaaaachiaaaaappiaaaaaoeiaafaaaaadaaaachiaaaaaoeia
aaaakkkaabaaaaacaaaaciiaabaappkaabaaaaacaaaicpiaaaaaoeiappppaaaa
fdeieefccmabaaaaeaaaaaaaelaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafidaaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbcbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
ccaabaaaabaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaaapaaaaakicaabaaa
aaaaaaaaaceaaaaalhnbeadpceljhmdoaaaaaaaaaaaaaaaaegaabaaaabaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
hccabaaaaaaaaaaaegacbaaaaaaaaaaakgikcaaaaaaaaaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaafdfgfpfagphdgjhegjgpgoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 1 TEX
PARAM c[3] = { program.local[0],
		{ 0.0039215689, 1, 0, 0.16666667 },
		{ 255 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], CUBE;
MUL R0.xyz, R0, R0.w;
MUL R0.xyz, R0, c[0].z;
MUL R1.xyz, R0, c[1].w;
MAX R0.x, R1, R1.y;
MAX_SAT R0.x, R0, R1.z;
MUL R0.x, R0, c[2];
FLR R0.x, -R0;
MUL R0.y, -R0.x, c[1].x;
SLT R0.x, c[1].z, R0.y;
ABS R0.x, R0;
RCP R0.z, R0.y;
CMP R0.x, -R0, c[1].z, c[1].y;
MUL_SAT R1.xyz, R1, R0.z;
MOV R1.w, R0.y;
CMP result.color, -R0.x, c[1].z, R1;
END
# 16 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"ps_2_0
; 16 ALU, 1 TEX
dcl_cube s0
def c1, 0.16666667, 255.00000000, 0.00392157, 0.00000000
def c2, 0.00000000, 1.00000000, 0, 0
dcl t0.xyz
texld r0, t0, s0
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r0, c0.z
mul r3.xyz, r0, c1.x
max r0.x, r3, r3.y
max_sat r0.x, r0, r3.z
mul r0.x, r0, c1.y
frc r1.x, -r0
add r0.x, -r0, -r1
mul r0.x, -r0, c1.z
cmp r1.x, -r0, c2, c2.y
rcp r2.x, r0.x
abs_pp r1.x, r1
mul_sat r2.xyz, r3, r2.x
mov r2.w, r0.x
cmp r0, -r1.x, c1.w, r2
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedblhjfimjcfgolfpodehbbbhiaikmjglfabaaaaaakaacaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaabaaaa
eaaaaaaahiaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafidaaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbcbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaakgikcaaaaaaaaaaaaaaaaaaadiaaaaakhcaabaaaaaaaaaaa
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
SubProgram "d3d11_9x " {
Keywords { "MARMO_GAMMA" "MARMO_RGBM" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
eefiecedighidjlbicafcggaicndkkhmoojojnpcabaaaaaapaadaaaaaeaaaaaa
daaaaaaahmabaaaageadaaaalmadaaaaebgpgodjeeabaaaaeeabaaaaaaacpppp
baabaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaaaaaabaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkaklkkckdoaaaahped
ibiaiadlaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaajiaaaiapka
ecaaaaadaaaacpiaaaaaoelaaaaioekaafaaaaadaaaachiaaaaappiaaaaaoeia
afaaaaadaaaaahiaaaaaoeiaaaaakkkaafaaaaadaaaaahiaaaaaoeiaabaaaaka
alaaaaadabaaaiiaaaaaaaiaaaaaffiaalaaaaadacaabiiaabaappiaaaaakkia
afaaaaadaaaaaiiaacaappiaabaaffkabdaaaaacabaaabiaaaaappibacaaaaad
aaaaaiiaaaaappiaabaaaaiaafaaaaadabaaaiiaaaaappiaabaakkkaagaaaaac
acaaabiaabaappiaafaaaaadabaadhiaaaaaoeiaacaaaaiafiaaaaaeaaaacpia
aaaappibabaappkaabaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
oaabaaaaeaaaaaaahiaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafkaaaaad
aagabaaaaaaaaaaafidaaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbcbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaakgikcaaaaaaaaaaaaaaaaaaadiaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaklkkckdoklkkckdoklkkckdoaaaaaaaa
deaaaaahicaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadecaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaahpedecaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
ibiaiadldbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaadkaabaaaaaaaaaaa
aoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
dkaabaaaabaaaaaadicaaaahhcaabaaaabaaaaaaegacbaaaaaaaaaaaagaabaaa
acaaaaaaabaaaaahpccabaaaaaaaaaaaegaobaaaabaaaaaapgapbaaaaaaaaaaa
doaaaaabejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahahaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 4 ALU, 1 TEX
PARAM c[2] = { program.local[0],
		{ 1 } };
TEMP R0;
TEX R0, fragment.texcoord[0], texture[0], CUBE;
MUL R0.xyz, R0, R0.w;
MUL result.color.xyz, R0, c[0].z;
MOV result.color.w, c[1].x;
END
# 4 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
Vector 0 [ExposureIBL]
SetTexture 0 [_SkyCubeIBL] CUBE 0
"ps_2_0
; 4 ALU, 1 TEX
dcl_cube s0
def c1, 1.00000000, 0, 0, 0
dcl t0.xyz
texld r0, t0, s0
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r0, c0.z
mov r0.w, c1.x
mov_pp oC0, r0
"
}
SubProgram "d3d11 " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0
eefiecedapefbhbpfpfnmbmioicnajafmhfabpgkabaaaaaaimabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmaaaaaa
eaaaaaaaddaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafidaaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbcbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihccabaaaaaaaaaaa
egacbaaaaaaaaaaakgikcaaaaaaaaaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "MARMO_GAMMA" "MARMO_RGBA" }
SetTexture 0 [_SkyCubeIBL] CUBE 0
ConstBuffer "$Globals" 96
Vector 0 [ExposureIBL]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
eefiecedbfdjcdhpljecdeceagklfipligemlajlabaaaaaaemacaaaaaeaaaaaa
daaaaaaaomaaaaaamaabaaaabiacaaaaebgpgodjleaaaaaaleaaaaaaaaacpppp
iaaaaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaaaaaabaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaajiaaaiapka
ecaaaaadaaaacpiaaaaaoelaaaaioekaafaaaaadaaaachiaaaaappiaaaaaoeia
afaaaaadaaaachiaaaaaoeiaaaaakkkaabaaaaacaaaaciiaabaaaakaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefcmmaaaaaaeaaaaaaaddaaaaaafjaaaaae
egiocaaaaaaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafidaaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbcbaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaaihccabaaaaaaaaaaaegacbaaaaaaaaaaakgikcaaa
aaaaaaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
ejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}
}
 }
}
SubShader { 
 Tags { "QUEUE"="Background" "RenderType"="Background" }
 Pass {
  Tags { "QUEUE"="Background" "RenderType"="Background" }
  Color [_Tint]
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  SetTexture [_Tex] { combine texture +- primary, texture alpha * primary alpha }
 }
}
Fallback Off
}