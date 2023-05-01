Shader "Saberslay shaders/Greyscale" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _GreyScale ("Greyscale", Range(0, 1)) = 1
        _Color1 ("Color 1", Color) = (1, 0, 0, 1)
        _Color2 ("Color 2", Color) = (0, 1, 0, 1)
        _Range ("Range", Range(0, 1)) = 0.1
        _Threshold ("Threshold", Range(0, 1)) = 0.1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
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
            };

            sampler2D _MainTex;
            float _GreyScale;
            float4 _Color1;
            float4 _Color2;
            float _Range;
            float _Threshold;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 texcol = tex2D(_MainTex, i.uv);
                float gray = dot(texcol.rgb, float3(0.299, 0.587, 0.114));
                float4 desatcol = lerp(texcol, float4(gray, gray, gray, texcol.a), _GreyScale);

                float4 finalcol = desatcol;
                int count = 0;
                for (int x = -1; x <= 1; x++) {
                    for (int y = -1; y <= 1; y++) {
                        if (x == 0 && y == 0) continue;
                        float2 offset = float2(x, y) * _Range;
                        float4 neighborcol = tex2D(_MainTex, i.uv + offset);
                        if (length(neighborcol.rgb - texcol.rgb) < _Threshold) {
                            count++;
                            if (count == 2) {
                                finalcol = lerp(_Color1, _Color2, gray);
                                break;
                            }
                        }
                    }
                    if (count == 2) break;
                }

                return finalcol;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "Slayer"
}
