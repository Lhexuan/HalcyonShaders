/*
  JCM2606.
  HALCYON 2.
  PLEASE READ "LICENSE.MD" BEFORE EDITING THIS FILE.
*/

#ifndef INTERNAL_INCLUDED_SYNTAX_FUNCTIONS
  #define INTERNAL_INCLUDED_SYNTAX_FUNCTIONS

  #define nullop_(type) type nullop(type x) { return x; }
  DEFINE_genFType(nullop_)
  DEFINE_genIType(nullop_)
  DEFINE_genBType(nullop_)

  #define toGamma_(type) type toGamma(type x) { return _pow(x, type(gammaCurveScreenRCP)); }
  DEFINE_genFType(toGamma_)

  #define toLinear_(type) type toLinear(type x) { return _pow(x, type(gammaCurveScreen)); }
  DEFINE_genFType(toLinear_)

  #define toLDR_(type) type toLDR(type x, const in float range) { return toGamma(x * range); }
  DEFINE_genFType(toLDR_)

  #define toHDR_(type) type toHDR(type x, const in float range) { return toLinear(x) * range; }
  DEFINE_genFType(toHDR_)

  cv(vec3) lumaCoeff = vec3(0.2125, 0.7154, 0.0721);
  float luma(in vec3 x) { return dot(x, lumaCoeff); }
  #define _luma(x) ( dot(x, lumaCoeff) )

  vec3 saturation(in vec3 x, in float s) { return mix(x, vec3(dot(x, lumaCoeff)), s); }
  #define _saturation(x, s) ( mix(x, vec3(dot(x, lumaCoeff)), s) )
  
  bool compare(in float a, in float b, cin(float) width) { return abs(a - b) < width; }
  bool compare(in float a, in float b) { return abs(a - b) < ubyteMaxRCP; }

  float compareShadowDepth(in float depth, in float comparison) { return saturate(1.0 - _max0(comparison - depth) * float(shadowMapResolution)); }

  #define flatten_(type) type flatten(type x, const in float weight) { \
    const float a = 1.0 - weight; \
    return x * weight + a; \
  }
  DEFINE_genFType(flatten_)

  cv(float) ebsRCP = 1.0 / 240.0;
  #define _getEBS() ( eyeBrightnessSmooth * ebsRCP )

  float transmittedScatteringIntegral(in float od, const float coeff) {
    const float a = -coeff / log(2.0);
    const float b = -1.0 / coeff;
    const float c =  1.0 / coeff;

    return exp2(a * od) * b + c;
  }

  vec3 transmittedScatteringIntegral(in float od, const vec3 coeff) {
    const vec3 a = -coeff / log(2.0);
    const vec3 b = -1.0 / coeff;
    const vec3 c =  1.0 / coeff;

    return exp2(a * od) * b + c;
  }

  vec2 to2D(int index, const int total) {
    cRCP(float, total);
    return vec2(float(index) / total, mod(index, total));
  }

  float max3(in vec3 v) { return max(v.x, max(v.y, v.z)); }
  float min3(in vec3 v) { return min(v.x, min(v.y, v.z)); }

  float avg3(in vec3 v) { return (v.x + v.y + v.z) * 0.333333333; }

  float almostIdentity(float x, float m, float n) {
    if (x > m) return x;
    float t = x / m;
    return (((2.0 * n - m) * t + (2.0 * m - 3.0 * n)) * t * t) + n;
  }

  bool intersectSphere(in vec3 rayOrigin, in vec3 rayDirection, in vec3 sphereOrigin, in float sphereRadius, inout vec3 intersection0, inout vec3 intersection1) {
    vec3 L = sphereOrigin - rayOrigin;

    float tca = dot(L, rayDirection);

    if(tca < 0.0) return false;

    float d2 = dot(L, L) - tca * tca;
    float r2 = sphereRadius * sphereRadius;

    if(d2 > r2) return false;

    float tch = sqrt(r2 - d2);

    intersection0 = rayDirection * (tca - tch) + rayOrigin;
    intersection1 = rayDirection * (tca + tch) + rayOrigin;

    return true;
  }

#endif /* INTERNAL_INCLUDED_SYNTAX_FUNCTIONS */
