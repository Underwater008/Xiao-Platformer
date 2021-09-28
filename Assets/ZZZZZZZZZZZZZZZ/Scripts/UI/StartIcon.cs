using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
public class StartIcon : MonoBehaviour
{
    //ͼ��
    public Image iconImage;
    //��ֵϵ��
    private float lerpSpeed = 0.0025f;
    //���غ�ĵȴ�ʱ��
    private float waitTime = 0.2f;

    private bool isFinish = false;
    void Start()
    {
        iconImage.color = new Color(0,0,0,0);
    }

    void Update()
    {
        if (isFinish) return;

        iconImage.color = Color.Lerp(iconImage.color, Color.white, lerpSpeed);

        if(iconImage.color.a >= 0.95f)
        {
            isFinish = true;
        }

        if(isFinish)
        {
            Invoke("InvokeWaitLoad", waitTime);
        }
    }

    private void InvokeWaitLoad()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }
}
