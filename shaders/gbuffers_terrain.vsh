/*
  JCM2606.
  HALCYON.
  PLEASE READ "LICENSE.MD" BEFORE EDITING.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/syntax/Shaders.glsl"
#define SHADER VSH
#define PROGRAM GBUFFERS_TERRAIN
#include "/lib/Header.glsl"

#include "/opaque.vsh"