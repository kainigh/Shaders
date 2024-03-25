Shader"Unlit/NoiseTexture"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        //_MainTex("Main Texture", 2D) = "white"{}
        _SecondColor("Second Color", Color) = (0,0,1,1)
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _Height("Height", float) = -1.0
        _Speed("Speed", float) = 1.0
        _Frequency("Frequency", float) = 1.0
        _Amplitude("Amplitude", float) = 1.0
        

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
            uniform half4 _Color;
            uniform half4 _SecondColor;
            //uniform sampler2D _MainTex;
            //uniform float4 _MainTex_ST;
            uniform sampler2D _NoiseTex;
            uniform float4 _NoiseTex_ST;
            uniform float _Height;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;
            


            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
	            float4 normal : NORMAL;
	            float4 texcoord : TEXCOORD0;
	            

            };

            struct VertexOutput
            {
                 float4 vertex : SV_POSITION;
	             float4 texcoord : TEXCOORD0;

            };

            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
	            
	            pos.y = pos.y + sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude;
                
	            return pos;
            }

            VertexOutput vert(VertexInput v)
            {
	           VertexOutput o;
               //o.vertex = UnityObjectToClipPos(v.vertex);
	           //o.texcoord.xy = v.texcoord;
	           //o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
    
	           
                v.vertex = vertexAnimFlag(v.vertex, v.texcoord.xy);
	           float displacement = tex2Dlod(_NoiseTex, v.texcoord * _NoiseTex_ST);
	o.vertex = UnityObjectToClipPos(v.vertex + (v.normal * displacement * sin(_Height * _Time.y)));
	           o.texcoord.xy = (v.texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw);
    
	           
                
               return o;

            }

            half4 frag (VertexOutput i) : COLOR
            {
	            float4 color = tex2Dlod(_NoiseTex, i.texcoord) * _Color + (1 - tex2Dlod(_NoiseTex, i.texcoord)) * _SecondColor;
	            return color;
            }
            ENDCG
        }
    }
}
