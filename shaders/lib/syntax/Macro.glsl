/*
  JCM2606.
  HALCYON 2.
  PLEASE READ "LICENSE.MD" BEFORE EDITING THIS FILE.
*/

#ifndef INTERNAL_INCLUDED_SYNTAX_MACRO
  #define INTERNAL_INCLUDED_SYNTAX_MACRO
  
  #define upDirection gbufferModelView[1].xyz

  #define timeNoon timeVector.x
  #define timeNight timeVector.y
  #define timeHorizon timeVector.z
  #define timeMorning timeVector.w

  #define FPS 1.0 / frameTime

  #define underWater (isEyeInWater == 1)
  #define underLava (isEyeInWater == 2)

  #define io inout

  #define globalTime ( GLOBAL_SPEED * frameTimeCounter )

  #define flat(type) flat varying type

  #define _getLandMask(x) ( x < 1.0 - near / far / far )

  #define _getSunDirection()  ( sunDirection  = _normalize( sunPosition) )
  #define _getMoonDirection() ( moonDirection = _normalize(-sunPosition) )
  #define _getLightDirection() ( lightDirection = _normalize(shadowLightPosition) )
  #define _getWorldLightDirection() ( wLightDirection = _normalize(mat3(gbufferModelViewInverse) * shadowLightPosition) )

  #define _getSmoothedMoonPhase() ( (float(moonPhase) * 24000.0 + float(worldTime)) * 0.00000595238095238 )

  #define _linearDepth(x) ( (2.0 * near) / (far + near - x * (far - near)) )
  #define _expDepth(x) ( (far * (x - near)) / (x * (far - near)) )

#endif /* INTERNAL_INCLUDED_SYNTAX_MACRO */
