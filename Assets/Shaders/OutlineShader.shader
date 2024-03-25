Shader"Unlit/OutlineTexture"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Outline("Outline Value", Range(0.0, 1.0)) = 0.1
        _OutlineColor("Outline Color", Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags { 
                "Queue" = "Transparent"
                "RenderType"="Transparent" 
                "IgnoreProjector" = "True"
             }
        //Outline
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull front
            Zwrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _Outline;
            uniform float4 _OutlineColor;

            #include "UnityCG.cginc"

            

            struct VertexInput
            {
                float4 vertex : POSITION;
	            float4 texcoord : TEXCOORD0;

            };

            struct VertexOutput
            {
                 float4 vertex : SV_POSITION;
	             float4 texcoord : TEXCOORD0;

            };

            float4 outline(float4 vertexPos, float outValue)
            {
	             float4x4 scale =  float4x4
	             (	
	                1 + outValue, 0, 0, 0,
                    0, 1 + outValue, 0, 0,
                    0, 0, 1 + outValue, 0,
                    0, 0, 0, 1 + outValue
	             );
    
	                 return mul(scale, vertexPos);
            }

            VertexOutput vert(VertexInput v)
            {
	           VertexOutput o;
	           float4 vertexPos = outline(v.vertex, _Outline);
	           o.vertex = UnityObjectToClipPos(v.vertex * (1 + _Outline));
	           o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
    
               return o;

            }

            half4 frag (VertexOutput i) : COLOR
            {
	            //half4 col =  tex2D(_MainTex, i.texcoord) * _Color;
	            return _OutlineColor; //(_Outline.r, _Outline.g, _Outline.b, col.a);

            }
            ENDCG
        }

        //Texture
        Pass
        {
Blend SrcAlpha
OneMinusSrcAlpha
     

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
uniform half4 _Color;
uniform sampler2D _MainTex;
uniform float4 _MainTex_ST;

#include "UnityCG.cginc"

struct VertexInput
{
	float4 vertex : POSITION;
	float4 texcoord : TEXCOORD0;

};

struct VertexOutput
{
	float4 vertex : SV_POSITION;
	float4 texcoord : TEXCOORD0;

};

VertexOutput vert(VertexInput v)
{
	VertexOutput o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
	return o;

}

half4 frag(VertexOutput i) : COLOR
{
	return tex2D(_MainTex, i.texcoord) * _Color;
}
            ENDCG
        }

    }
}
