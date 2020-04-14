// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TwoBit/GrabShader"
{
    Properties
    {
        
    }
    SubShader
    {
		Tags{"Queue" = "Transparent"}
		GrabPass{ }
        pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _GrabTexture;

			struct vertInput
			{
				float4 vertex : POSITION;
			};

			struct vertOutput
			{
				float4 vertex : POSITION;
				float4 uvgrab : TEXCOORD1;
			};

			vertOutput vert(vertInput input)
			{
				vertOutput o;
				o.vertex = UnityObjectToClipPos(input.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			half4 frag(vertOutput output) : COLOR
			{
				half4 mainColour = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(output.uvgrab));
				return mainColour + half4(.5,0,0,0);
			}

			ENDCG
		}        
    }
    FallBack "Diffuse"
}
