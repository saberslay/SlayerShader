Shader "KGL/MySpecularPhongTwoLights" {

    Properties {

        _MainTex ("Texture", 2D) = "white" {}

        _Color ("Color", Color) = (1, 0, 0, 1)

        _Ambient ("Ambient", Range(0, 1)) = 0.1

        _SpecColor ("Specular Material Color", Color) = (1, 1, 1, 1)

        _Shininess ("Shininess", Float) = 10

    }

    

    SubShader {

        

        LOD 100

        Tags {"RenderType"="Opaque"}

        

        Pass {

            Tags { "LightMode" = "ForwardBase" }

            

            CGPROGRAM

            #pragma multi_compile_fwdbase

            #pragma vertex vert

            #pragma fragment frag

            

            #include "UnityCG.cginc"

            #include "UnityLightingCommon.cginc"

            

            uniform sampler2D _MainTex;

            uniform float4 _Color;

            uniform float4 _MainTex_ST;

            uniform fixed _Ambient;

            uniform fixed _Shininess;

            

            struct appdata {

            

                float4 vertex: POSITION;

                float3 normal: NORMAL;

                fixed2 uv: TEXCOORD0;

            };

            struct v2f {

                

                float4 vertex: SV_POSITION;

                fixed2 uv: TEXCOORD0;

                float3 worldNormal: TEXCOORD1;

                float4 worldVertex: TEXCOORD2;

            };

            

            v2f vert(appdata v)

            {

                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);

                float3 wNormal = normalize(UnityObjectToWorldNormal(v.normal));

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.worldNormal = wNormal;

                o.worldVertex = mul(unity_ObjectToWorld, v.vertex);

                return o;

            }

            float4 frag(v2f i) : SV_Target

            {

                float3 normalDir = normalize(i.worldNormal);

                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldVertex));

                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldVertex));

                

                float4 texColor = tex2D(_MainTex, i.uv);

                float NdotL = max(_Ambient, dot(normalDir, _WorldSpaceLightPos0.xyz));

                float4 diffuse = NdotL * _Color * _LightColor0 * texColor;

                float3 reflectionDir = reflect(-lightDir, normalDir);

                float3 specularDot = max(0.0, dot(viewDir, reflectionDir));

                float3 specularPow = pow(specularDot, _Shininess);

                float4 specular = float4(specularPow, 1) * _SpecColor * _LightColor0;

                return diffuse + specular;

            }

            ENDCG

        }

        Pass {

        

            Tags { "LightMode" = "ForwardAdd" }

            Blend One One

            ZWrite Off  

            CGPROGRAM

            #pragma exclude_renderers d3d11

            #pragma multi_compile_fwdadd

            #pragma vertex vert

            #pragma fragment frag

            #pragma target 3.0

            #include "UnityCG.cginc"

            #include "UnityLightingCommon.cginc"

            #include "UnityShaderVariables.cginc"

            #include "Autolight.cginc"

            

            uniform sampler2D _MainTex;

            uniform float4 _Color;

            uniform float4 _MainTex_ST;

            uniform fixed _Ambient;

            uniform fixed _Shininess;

            uniform fixed _D;

            uniform sampler2D _LightTextureB0;

            

            struct appdata {

            

                float4 vertex: POSITION;

                float3 normal: NORMAL;

                fixed2 uv: TEXCOORD0;

                

            };

            struct v2f {

                

                float4 vertex: SV_POSITION;

                fixed2 uv: TEXCOORD0;

                float3 worldNormal: TEXCOORD1;

                float4 worldVertex: TEXCOORD2;

               

            };

            v2f vert(appdata v)

            {

                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);

                float3 wNormal = normalize(UnityObjectToWorldNormal(v.normal));

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.worldNormal = wNormal;

                o.worldVertex = mul(unity_ObjectToWorld, v.vertex);

               

                return o;

            }

            float4 frag(v2f i) : SV_Target

            {

                float3 normalDir = normalize(i.worldNormal);

                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldVertex.xyz));

                float3 lightDir;

                float att;

                

                if (_WorldSpaceLightPos0.w == 0.0) {

                

                    att = 1.0;

                    lightDir = normalize(_WorldSpaceLightPos0.xyz);

                }

                else {

                

                    float3 v2l = _WorldSpaceLightPos0.xyz - i.worldVertex.xyz;

                    lightDir = normalize(v2l);

                    float dist = length(v2l);

                    att = 1.0 / dist;

                }

                

               // float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldVertex));

                float4 texColor = tex2D(_MainTex, i.uv);

                float NdotL = saturate(dot(normalDir, lightDir));

                

                float4 diffuse = NdotL * _Color * texColor * _LightColor0 * att;

                float3 reflectionDir = reflect(-lightDir, normalDir);

                float3 specularDot = max(0.0, dot(viewDir, reflectionDir));

                float3 specularPow = pow(specularDot, _Shininess);

                float4 specular = float4(specularPow, 1) * _SpecColor * _LightColor0 * att;

                return diffuse + specular;

            }

            ENDCG

        }

    }

    Fallback "Specular"
    CustomEditor "Slayer"

}