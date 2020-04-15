Shader "TwoBit/ScreenBSC"
{
    Properties
    {
       
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Brightness ("Brightness", Range(0,1)) = 1
		_Saturation ("Saturation", Range(0,1)) = 1
		_Contrast ("Depth Power", Range(0,1)) = 1
 
    }
    SubShader
    {
        pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ABB_precision_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			fixed _Brightness;
			fixed _Saturation;
			fixed _Contrast;
			
			float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
			{
				float AvgLumR = .5;
				float AvgLumG = .5;
				float AvgLumB = .5;
				//brightness
				float3 LuminanceCoeff = float3(.2125, .7154, .0721);
				float3 AvgLumin = float3(AvgLumR, AvgLumG, AvgLumB);
				float3 brtColor = color * brt;
				float intensityf = dot(brtColor, LuminanceCoeff);
				float3 intensity = float3(intensityf, intensityf, intensityf);
				//Saturation
				float3 satColor = lerp(intensity, brtColor, sat);
				//Contrast
				float3 conColor = lerp(AvgLumin, satColor, con);
				return conColor;

			}
			fixed4 frag(v2f_img i) : COLOR
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, _Brightness, _Saturation, _Contrast);
				return renderTex;
			}
			ENDCG
		}
    }
    FallBack off
}
