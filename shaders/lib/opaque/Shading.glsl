/*
  JCM2606.
  HALCYON.
  PLEASE READ "LICENSE.MD" BEFORE EDITING.
*/

#ifndef INTERNAL_INCLUDED_OPAQUE_SHADING
  #define INTERNAL_INCLUDED_OPAQUE_SHADING

  #include "/lib/opaque/Shadows.glsl"

  #include "/lib/common/DiffuseModel.glsl"

  #include "/lib/common/Lightmaps.glsl"

  float getDirectShading(io GbufferObject gbuffer, io MaskObject mask, io PositionObject position) {
    return (mask.foliage) ? 1.0 : lambert(normalize(position.viewPositionBack), lightVector, normalize(gbuffer.normal), gbuffer.roughness);
  }

  vec3 getAmbientLighting(io PositionObject position, in vec2 screenCoord) {
    vec3 ambientLighting = vec3(0.0);

    c(int) width = 3;
    cRCP(float, width);
    c(float) filterRadius = 0.001;
    c(vec2) filterOffset = vec2(filterRadius) * widthRCP;
    c(vec2) radius = filterOffset;

    c(float) weight = 1.0 / pow(float(width) * 2.0 + 1.0, 2.0);

    for(int i = -width; i <= width; i++) {
      for(int j = -width; j <= width; j++) {
        vec2 offset = vec2(i, j) * radius + screenCoord;

        if(texture2D(depthtex1, offset).x - position.depthBack > 0.001) continue;

        ambientLighting += texture2DLod(colortex4, offset, 0).rgb;
      }
    }

    return ambientLighting * weight * SKY_LIGHT_STRENGTH;
  }

  vec3 getFinalShading(out vec4 highlightTint, io GbufferObject gbuffer, io MaskObject mask, io PositionObject position, in vec2 screenCoord, in vec3 albedo, in mat2x3 atmosphereLighting) {
    //return getAmbientLighting(position, screenCoord);

    NewShadowObject(shadowObject);

    float cloudShadow = getCloudShadow(viewToWorld(position.viewPositionBack) + cameraPosition);

    getShadows(shadowObject, position.viewPositionFront, position.viewPositionBack, cloudShadow);

    highlightTint = vec4(shadowObject.colour, shadowObject.occlusionBack);

    #ifdef VISUALISE_PCSS_EDGE_PREDICTION
      if(screenCoord.x > 0.5) return vec3(shadowObject.edgePrediction);
    #endif

    //vec3 direct = atmosphereLighting[0] * shadowObject.occlusionBack * mix(vec3(shadowObject.occlusionFront), shadowObject.colour, shadowObject.difference) * getDirectShading(gbuffer, mask, position);
    vec3 direct = atmosphereLighting[0];
    direct *= mix(vec3(shadowObject.occlusionFront), shadowObject.colour, shadowObject.difference);
    direct *= getDirectShading(gbuffer, mask, position);
    direct *= cloudShadow;
    direct *= shadowObject.occlusionBack;

    vec3 sky = getAmbientLighting(position, screenCoord) * atmosphereLighting[1] * getRawSkyLightmap(gbuffer.skyLight);
    vec3 block = blockLightColour * max(((mask.emissive) ? 32.0 : 1.0) * gbuffer.emission, getBlockLightmap(gbuffer.blockLight));

    return albedo * (direct + sky + block);
  }

#endif /* INTERNAL_INCLUDED_OPAQUE_SHADING */
