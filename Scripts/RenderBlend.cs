using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderBlend : MonoBehaviour
{
    public Shader curShader;
    public Texture2D blendTexture;
    public float blendOpacity = 1f;
    private Material screenMat;

    Material ScreenMat
    {
        get
        {
            if(screenMat == null)
            {
                screenMat = new Material(curShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return screenMat;
        }
    }

    
    // Start is called before the first frame update
    void Start()
    {
       if(!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    // Update is called once per frame
    void Update()
    {
        blendOpacity = Mathf.Clamp(blendOpacity, 0f, 1f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_Opacity", blendOpacity);
            ScreenMat.SetTexture("_BlendTex", blendTexture);
            Graphics.Blit(source, destination, ScreenMat);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void OnDisable()
    {
        if(ScreenMat)
        {
            DestroyImmediate(screenMat);
        }
    }
}
