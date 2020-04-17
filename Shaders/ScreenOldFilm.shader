Shader "TwoBit/ScreenOldFilm"
{
    Properties
    {
        _VignetteTex ("Vignette Tex",2D) = "white" {}
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ScratchesTex ("Scratches Texture", 2D) = "white" {}
		_DustTex ("DustTex", 2D) = "white" {}
		_SepiaColor ("Sepia Color", Color) = (1,1,1,1)
		_EffectAmount("Old Film Effect Amount", Range(0,1)) = 1
		_VignetteAmount ("Vignette Opacity", Range(0,1)) = 1
		_ScratchesYSpeed ("Scratches Y Speed", float) = 10
		_ScratchesXSpeed ("Scratches X Speed", float) = 10
		_DustYSpeed ("Dust Y Speed", float) = 10
		_DustXSpeed ("Dust X Speed", float) = 10
		_RandomValue ("Random Value", float) = 1
		_Contrast ("Contrast", float) = 3
 
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
			uniform sampler2D _VignetteTex;
			uniform sampler2D _DustTex;
			uniform sampler2D _ScratchesTex;
			fixed4 _SepiaColor;
			fixed _EffectAmount;
			fixed _VignetteAmount;
			fixed _ScratchesYSpeed;
			fixed _ScratchesXSpeed;
			fixed _DustYSpeed;
			fixed _DustXSpeed;
			fixed _RandomValue;
			fixed _Contrast;

			fixed4 frag(v2f_img i) : COLOR
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);
				half2 scratchesUV = half2(i.uv.x + (_RandomValue *  _ScratchesXSpeed), i.uv.y + (_Time.x * _ScratchesYSpeed));
				fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);
				half2 dustUV = half2(i.uv.x + (_RandomValue * ( _DustXSpeed)), i.uv.y + (_RandomValue * (_SinTime.z * _DustYSpeed)));
				fixed4 dustTex = tex2D(_DustTex, dustUV);
				fixed lum = dot (fixed3(0.299, .587, .114), renderTex.rgb);
				fixed4 finalColor = lum + lerp(_SepiaColor,_SepiaColor + fixed4(.1,.1,.1,1), _RandomValue);
				finalColor = pow(finalColor, _Contrast);
				fixed3 constantWhite = fixed3(1,1,1);
				finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
				finalColor.rgb *= lerp(scratchesTex, constantWhite,_RandomValue);
				finalColor.rgb *= lerp(dustTex.rgb, constantWhite, (_RandomValue * _SinTime.z));
				finalColor = lerp(renderTex, finalColor,_EffectAmount);
				return finalColor;
			}
			ENDCG
		}
    }
    FallBack off
}
