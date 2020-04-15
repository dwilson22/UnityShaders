using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderBSC : MonoBehaviour
{
    public Shader curShader;
    public float brightness = 1f;
    public float saturation = 1f;
    public float contrast = 1f;
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
        brightness = Mathf.Clamp(brightness, 0f, 2f);
        saturation = Mathf.Clamp(saturation, 0f, 2f);
        contrast = Mathf.Clamp(contrast, 0f, 3f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_Brightness", brightness);
            ScreenMat.SetFloat("_Saturation", saturation);
            ScreenMat.SetFloat("_Contrast", contrast);
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
