/*
  JCM2606.
  HALCYON 2.
  PLEASE READ "LICENSE.MD" BEFORE EDITING THIS FILE.
*/

#version 120

#include "/lib/Header.glsl"
#define PROGRAM COMPOSITE0
#define SHADER FSH
#include "/lib/Syntax.glsl"

/* CONST */
/* USED BUFFER */
#define IN_TEX1
#define IN_TEX2
#define IN_TEX7

/* VARYING */
varying vec2 screenCoord;

flat(vec3) sunDirection;
flat(vec3) moonDirection;
flat(vec3) lightDirection;

/* UNIFORM */
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex4;
uniform sampler2D colortex7;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;
uniform sampler2D shadowcolor1;

uniform mat4 gbufferProjection, gbufferProjectionInverse;
uniform mat4 gbufferModelView, gbufferModelViewInverse;

uniform mat4 shadowProjection, shadowProjectionInverse;
uniform mat4 shadowModelView;

uniform vec3 cameraPosition;

uniform int isEyeInWater;

uniform float sunAngle;
uniform float near;
uniform float far;

/* GLOBAL */
/* STRUCT */
#include "/lib/struct/Buffers.glsl"
#include "/lib/struct/Gbuffer.glsl"
#include "/lib/struct/Mask.glsl"
#include "/lib/struct/Position.glsl"

/* INCLUDE */
#include "/lib/deferred/Volumetrics.glsl"

#include "/lib/common/AtmosphereLighting.glsl"

#include "/lib/forward/Shading.glsl"

/* FUNCTION */
/* MAIN */
void main() {
  // CREATE STRUCT INSTANCES
  _newBufferList(bufferList);
  _newGbufferObject(gbufferData);
  _newMaskList(maskList);
  _newPositionObject(positionData);

  // POPULATE STRUCT INSTANCES
  populateBufferList(bufferList, screenCoord);
  populateGbufferData(gbufferData, bufferList);
  populateMaskList(maskList, gbufferData);
  populateDepths(positionData, screenCoord);
  populateViewPositions(positionData, screenCoord);

  // COMPUTE DITHER
  cv(float) ditherScale = pow(128.0, 2.0);
  vec2 dither = vec2(bayer128(gl_FragCoord.xy), ditherScale);

  // COMPUTE ATMOSPHERE LIGHTING
  mat2x3 atmosphereLighting = getAtmosphereLighting();

  // CREATE SHADOW DATA INSTANCE
  _newShadowData(shadowData);

  // COMPUTE SHADOWS
  if(_getLandMask(positionData.depthFront)) computeShadowing(shadowData, positionData.viewFront, dither, 0.0, true);

  // COMPUTE HIGHLIGHT OCCLUSION
  vec4 highlightOcclusion = vec4(shadowData.colour, shadowData.occlusionBack);

  bufferList.tex4.a = highlightOcclusion.a;

  // COMPUTE VOLUMETRICS
  computeVolumetrics(positionData, gbufferData, maskList, bufferList.tex6.rgb, bufferList.tex5.rgb, bufferList.tex4.rgb, dither, atmosphereLighting);

  // PUSH TRANSPARENT OBJECTS INTO LINEAR SPACE
  bufferList.tex7.rgb = toLinear(bufferList.tex7.rgb);

  // POPULATE OUTGOING BUFFERS
  /* DRAWBUFFERS:4567 */
  gl_FragData[0] = bufferList.tex4;
  gl_FragData[1] = bufferList.tex5;
  gl_FragData[2] = bufferList.tex6;
  gl_FragData[3] = bufferList.tex7;
}
