/*
  JCM2606.
  HALCYON.
  PLEASE READ "LICENSE.MD" BEFORE EDITING.
*/

#ifndef INTERNAL_INCLUDED_DEFERRED_REFRACTION
  #define INTERNAL_INCLUDED_DEFERRED_REFRACTION

  vec3 getRefractPos(out float dist, in vec2 screenCoord, in vec3 viewBack, in vec3 viewFront, in vec3 normal) {
    dist = distance(viewFront, viewBack);

    if(dist == 0.0) return vec3(screenCoord, 0.0);

    vec3 refractDir = refract(normalize(viewFront), normalize(normal), 1.0 / 1.333) * clamp01(dist) + viewFront;
    
    return viewToClip(refractDir);
  }

  #if PROGRAM == COMPOSITE0
    vec3 drawRefraction(io GbufferObject gbuffer, io PositionObject position, in vec3 background, in vec2 screenCoord) {
      float dist = 0.0;
      vec3 refractPos = getRefractPos(dist, screenCoord, position.viewBack, position.viewFront, gbuffer.normal);

      if(dist == 0.0 || texture2D(depthtex1, refractPos.xy).x < position.depthFront) return background;

      return texture2D(colortex0, refractPos.xy).rgb;
    }
  #endif

#endif /* INTERNAL_INCLUDED_DEFERRED_REFRACTION */
