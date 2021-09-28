using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudMove : MonoBehaviour
{
    private Transform cloudTransform;

    private bool isFinish = false;
    private Vector3 randPos;
    //移动的插值系数
    public float lerpCoefficient = 0.0002f;
    //随机范围最值
    public float randMin;
    public float randMax;
    //完成一轮后的等待时间
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
