using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudMove : MonoBehaviour
{
    private Transform cloudTransform;

    private bool isFinish = false;
    private Vector3 randPos;
    //�ƶ��Ĳ�ֵϵ��
    public float lerpCoefficient = 0.0002f;
    //�����Χ��ֵ
    public float randMin;
    public float randMax;
    //���һ�ֺ�ĵȴ�ʱ��
    private float interval = 2f;
    void Start()
    {
        cloudTransform = this.gameObject.transform;
        initRandPos(randMin, randMax);
    }

    
    void Update()
    {
        if(isFinish == false)
        {
            cloudTransform.position = Vector3.Lerp(cloudTransform.position, randPos, lerpCoefficient);

            if(Vector3.Distance(cloudTransform.position , randPos) <= 0.1f )
            {
                isFinish = true;
                initRandPos(randMin, randMax);
                Invoke("InvokeReset", interval);
            }
        }
    }

    private void initRandPos(float randMin , float randMax)
    {
        randPos = new Vector3(Random.Range(randMin, randMin), cloudTransform.position.y, 0);
    }

    private void InvokeReset()
    {
        isFinish = false;
    }
}
