/*
  JCM2606.
  HALCYON.
  PLEASE READ "LICENSE.MD" BEFORE EDITING.
*/

#ifndef INTERNAL_INCLUDED_OPTION_LIGHTING
  #define INTERNAL_INCLUDED_OPTION_LIGHTING

  #define BLOCK_LIGHT_COLOUR 0 // [0]

  #if   BLOCK_LIGHT_COLOUR == 0
    c(vec3) blockLightColour = vec3(1.0, 0.6, 0.3);
  #else
    c(vec3) blockLightColour = vec3(1.0, 0.1, 0.0);
  #endif

#endif /* INTERNAL_INCLUDED_OPTION_LIGHTING */