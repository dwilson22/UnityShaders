using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderOldFilmEffect : MonoBehaviour
{
    public Shader curShader;
    public float oldFilmEffectAmount = 1f;
    public Color sepiaColor = Color.white;
    public Texture2D vignetteTexture;
    public float vignetteAmount = 1f;
    public Texture2D scratchesTexture;
    public float scratchesYSpeed = 10f;
    public float scratchesXSpeed = 10f;
    public Texture2D dustTexture;
    public float dustYSpeed = 10f;
    public float dustXSpeed = 10f;
    private float randomValue;
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
        vignetteAmount = Mathf.Clamp01(vignetteAmount);
        oldFilmEffectAmount = Mathf.Clamp(oldFilmEffectAmount, 0f, 1.5f);
        randomValue = Random.Range(-1f, 1);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            ScreenMat.SetColor("_SepiaColor", sepiaColor);
            ScreenMat.SetFloat("_VignetteAmount", vignetteAmount);
            ScreenMat.SetFloat("_EffectAmount", oldFilmEffectAmount);
            if(vignetteTexture)
            {
                ScreenMat.SetTexture("_VignetteTex", vignetteTexture);
            }

            if(scratchesTexture)
            {
                ScreenMat.SetTexture("_ScratchesTex", scratchesTexture);
                ScreenMat.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
                ScreenMat.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
            }

            if(dustTexture)
            {
                ScreenMat.SetTexture("_DustTex", dustTexture);
                ScreenMat.SetFloat("_DustYSpeed",dustYSpeed);
                ScreenMat.SetFloat("_DustXSpeed", dustXSpeed);
                ScreenMat.SetFloat("RandomValue", randomValue);
            }
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
