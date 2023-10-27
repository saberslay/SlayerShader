Shader "Saberslay shaders/TextureTransition"
{
    Properties
    {
        _MainTex1 ("Texture 1", 2D) = "white" {}
        _MainTex2 ("Texture 2", 2D) = "white" {}
        _MainTex3 ("Texture 3", 2D) = "white" {}
        _Progress ("Transition Progress", Range(0, 1)) = 0.0
        [Toggle] _EnableTransition("Enable Therd Texture", Int) = 0.0
    }
 
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
 
            sampler2D _MainTex1;
            sampler2D _MainTex2;
            sampler2D _MainTex3;
            float _Progress;
            bool _EnableTransition;
 
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = lerp(v.uv, v.uv, _Progress);
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col1 = tex2D(_MainTex1, i.uv);
                fixed4 col2 = tex2D(_MainTex2, i.uv);
                fixed4 col3 = tex2D(_MainTex3, i.uv);

                if(_EnableTransition > 0.0){
                    return lerp(col1, col3, _Progress);
                } else {
                    return lerp(col1, col2, _Progress);
                }
            }
            ENDCG
        }
    }
        CustomEditor "Slayer"
}
