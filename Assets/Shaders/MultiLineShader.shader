Shader"Unlit/MultiLineShader"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1,0,0,1)
        _SecondColor("Second Color", Color) = (0,1,0,1)
        _MainTex("Main Texture", 2D) = "white"{}
        
        _LinesCount("Lines Count", int) = 5

    }
    SubShader
    {
        Tags { 
                "Queue" = "Transparent"
                "RenderType"="Transparent" 
                "IgnoreProjector" = "True"
             }
        
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float4 _BaseColor;
            uniform float4 _SecondColor;
            uniform int _LinesCount;

            

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
	            float4 texcoord : TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
	           VertexOutput o;
               o.pos = UnityObjectToClipPos(v.vertex);
	           o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;
               return o;

            }

            float drawLine(float2 uv, float lineWidth)
            {
    
	            float pattern = 2 * lineWidth;
	            if (uv.x % pattern < lineWidth || uv.y % pattern < lineWidth)
	            {
		            return _BaseColor;
        
	            }

	                return _SecondColor;
    
            }

            half4 frag (VertexOutput i) : COLOR
            {
    
	            float lineWidth = (1.0 / _LinesCount);
	            
	            half4 color = tex2D(_MainTex, i.texcoord) * drawLine(i.texcoord, lineWidth);
	            
	            
		        return color;
	        }

		ENDCG

	}
  }
}
