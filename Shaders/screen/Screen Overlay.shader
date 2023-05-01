Shader "Saberslay shaders/Screen/Overlay Screen" {
	Properties {
      _MainTex ("Texture", Rect) = "white" {}
      _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
      _X ("X", Float) = 0.0
      _Y ("Y", Float) = 0.0
      _Width ("Width", Float) = 128
      _Height ("Height", Float) = 128
   }
   SubShader {
      Tags {
         "Queue" = "Overlay" 
      }
      
      Pass {
         Blend SrcAlpha OneMinusSrcAlpha // use alpha blending
         ZTest Always // deactivate depth test
 
         CGPROGRAM
 
         #pragma vertex vert  
         #pragma fragment frag

         #include "UnityCG.cginc" 
           // defines float4 _ScreenParams with x = width;  
           // y = height; z = 1 + 1.0/width; w = 1 + 1.0/height
           // and defines float4 _ProjectionParams 
           // with x = 1 or x = -1 for flipped projection matrix;
           // y = near clipping plane; z = far clipping plane; and
           // w = 1 / far clipping plane
 
         // User-specified uniforms
         uniform sampler2D _MainTex;
         uniform float4 _Color;
         uniform float _X;
         uniform float _Y;
         uniform float _Width;
         uniform float _Height;
 
         struct vertexInput {
            float4 vertex : POSITION;
            float4 texcoord : TEXCOORD0;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 tex : TEXCOORD0;
         };

         vertexOutput vert(vertexInput input)  {
            vertexOutput output;
            
            float2 rasterPosition = float2(
               _X + _ScreenParams.x / 2.0 + _Width * (input.vertex.x + 0.5),
               _Y + _ScreenParams.y / 2.0 + _Height * (input.vertex.y + 0.5));
            
            float4 clipPos = float4(
               2.0 * rasterPosition.x / _ScreenParams.x - 1.0,
               2.0 * rasterPosition.y / _ScreenParams.y - 1.0,
               -_ProjectionParams.y, 1.0);
            
            output.pos = UnityObjectToClipPos(input.vertex);
            output.pos = mul(UNITY_MATRIX_VP, output.pos);
            
            output.tex = float4(input.vertex.x + 0.5, 
               input.vertex.y + 0.5, 0.0, 0.0);

            return output;
         }


         float4 frag(vertexOutput input) : COLOR {
            return _Color * tex2D(_MainTex, input.tex.xy);
         }
 
         ENDCG
      }
   }
    CustomEditor "Slayer"
}