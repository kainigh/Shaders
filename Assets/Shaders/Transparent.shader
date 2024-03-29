Shader"Unlit/Transparent"
{
    Properties {
      _MainTex ("RGBA Texture Image", 2D) = "white" {} 
      _Transparency("Transparency", Range (0.0, 0.5)) = 0.25
   }
   SubShader {
      Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}

      Pass {	
         //Cull Front // first render the back faces
         ZWrite Off // don't write to depth buffer 
            // in order not to occlude other objects
         Blend SrcAlpha OneMinusSrcAlpha 
            // blend based on the fragment's alpha value
         
         CGPROGRAM
 
         #pragma vertex vert  
         #pragma fragment frag 
 
         uniform sampler2D _MainTex;
         float _Transparency;
 
         struct vertexInput {
            float4 vertex : POSITION;
            float4 texcoord : TEXCOORD0;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 tex : TEXCOORD0;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            output.tex = input.texcoord;
	        output.pos = UnityObjectToClipPos(input.vertex);
            return output;
         }

         float4 frag(vertexOutput input) : COLOR
         {
	        
    
            float4 color =  tex2D(_MainTex, input.tex);  
            if (color.a > 0.2) // opaque back face?
            {
		    color = float4(0.0, 1.0, 0.2, _Transparency);
                  // opaque dark blue
            }
            else // transparent back face?
            {
		    color = float4(0.0, 0.0, 1.0, _Transparency);
                  // semitransparent green
            }
            return color;
         }
 
         ENDCG
      }

     }
  
}
