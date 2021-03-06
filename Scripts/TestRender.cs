﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TestRender : MonoBehaviour
{
    public Shader curShader;
    public float greyScaleAmount;
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
        greyScaleAmount = Mathf.Clamp(greyScaleAmount, 0f, 1f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_Luminosity", greyScaleAmount);
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
