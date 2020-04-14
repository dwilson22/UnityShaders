﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TwoBit/WaterShader"
{
    Properties
    {
        _Period("Period", Range(0,50)) = 1
		_Color("Color tint", Color) = (1,1,1,1)
		_NoiseTex("Noise texture", 2D) = "bump" {}
		_Magnitude("Magnitude", Range(0,1)) = .05
		_Scale("Scale", Range(0,10)) = 1
    }
    SubShader
    {
		Tags{"Queue" = "Transparent"
			 "IgnoreProjector" = "True"
			 "RenderType" = "Opaque"}
		GrabPass{ }
        pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
			sampler2D _NoiseTex;
			fixed4 _Color;
			float _Magnitude;
			float _Scale;
			float _Period;

			struct vertInput
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct vertOutput
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
				float4 uvgrab : TEXCOORD2;
			};

			vertOutput vert(vertInput v)
			{
				vertOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			half4 frag(vertOutput i) : COLOR
			{
				float sinT = sin(_Time.w / _Period);
				float distX = tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(sinT, 0)).r - .5;
				float distY = tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(0, sinT)).r - .5;
				float2 distortion = float2(distX, distY);
				i.uvgrab.xy += distortion * _Magnitude;
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col * _Color;
			}

			ENDCG
		}        
    }
    FallBack "Diffuse"
}
