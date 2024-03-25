Shader"Unlit/StartShader"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;

            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;

            };

            struct VertexOutput
            {
                 float4 vertex : SV_POSITION;

            };

            VertexOutput vert(VertexInput v)
            {
	           VertexOutput o;
               o.vertex = UnityObjectToClipPos(v.vertex);
               return o;

            }

            half4 frag (VertexOutput i) : COLOR
            {
	            return _Color;
            }
            ENDCG
        }
    }
}
