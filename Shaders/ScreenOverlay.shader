Shader "TwoBit/ScreenOverlay"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BlendTex ("Blend Texture", 2D) = "white" {}
		_Opacity("Opacity", Range(0,1)) = 1
 
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
			uniform sampler2D _BlendTex;
			fixed _Opacity;

			fixed OverlayBlendMode(fixed basePixel, fixed blendPixel)
			{
				if(basePixel < .5)
				{
					return (2 * basePixel * blendPixel);
				}
				else
				{
					return (1 - 2 * (1 - basePixel) * (1 - blendPixel));
				}
			}

			fixed4 frag(v2f_img i) : COLOR
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);
				fixed4 blendedImage = renderTex;
				blendedImage.r = OverlayBlendMode(renderTex.r, blendTex.r);
				blendedImage.g = OverlayBlendMode(renderTex.g, blendTex.g);
				blendedImage.b = OverlayBlendMode(renderTex.b, blendTex.b);				
				renderTex = lerp(renderTex, blendedImage, _Opacity);
				
				return renderTex;
			}
			ENDCG
		}
    }
    FallBack off
}
