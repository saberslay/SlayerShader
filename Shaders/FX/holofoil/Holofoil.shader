Shader "Saberslay shaders/FX/Holofoil" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _HoloFoilTex ("Foil Texture", 2D) = "white" {}
        _Scale ("Plasma Scale", float) = 10
        _Intensity ("Foil Intensity", float) = 0.5
        _ColourOne ("Colour One", Color) = (1,0,0,1)
        _ColourTwo ("Colour Two", Color) = (0,1,0,1)
        _ColourThree ("Colour Three", Color) = (1,1,1,1)
    }

    SubShader {
        Tags {"RenderType"="Opaque"}
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 viewDir : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _HoloFoilTex;
            float _Scale, _Intensity;
            float4 _ColourOne,_ColourTwo,_ColourThree;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.viewDir = UnityWorldSpaceViewDir(v.vertex);
                return o;
            }

            float3 Plasma(float2 uv, float o) {
                uv = uv * _Scale - _Scale / 2;
                float time = 0;
                float w1 = sin(uv.x + time);
                float w2 = sin(uv.y + time);
                float w3 = sin(uv.x + uv.y + time);

                float r = sin(sqrt(uv.x * uv.x + uv.y * uv.y) + time) * 2;

                float finalValue = w1 + w2 + w3 + r;

                float c1 = sin(finalValue * UNITY_PI) * _ColourOne;
                float c2 = cos(finalValue * UNITY_PI) * _ColourTwo;
                float c3 = sin(finalValue) * _ColourThree;
                return c1 + c2 + c3;

            }


            fixed4 frag (v2f i) : SV_Target {
                fixed4 foil = tex2D(_HoloFoilTex, i.uv);
                float2 newuv = i.viewDir.xy + foil.rg;
                float3 plasma = Plasma(newuv, i.viewDir.z) * _Intensity;
                fixed4 col = tex2D(_MainTex, i.uv);
                return fixed4(col.rgb + col.rgb * plasma.rgb, 1);
            }
            ENDCG
        }
    }
    CustomEditor "Slayer"
}
