using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//*********负责摄像机的移动，挂在相机上**********
public class CameraMove : MonoBehaviour
{
    public GameObject player;  //主角

    public float minPosx;  //相机不超过背景边界允许的最小值
    public float maxPosx;  //相机不超过背景边界允许的最大值

    private Vector3 distance;

    public float minPosy;
    public float maxPosy;

    void Start()
    {
        distance = player.transform.position - transform.position;
    }

    void Update()
    {
        //函数Clamp作用： 限制第一个参数不超过两个最值并返回
        var posY = Mathf.Clamp((player.transform.position - distance).y, minPosy, maxPosy);
        var posX = Mathf.Clamp((player.transform.position - distance).x, minPosx, maxPosx);

        transform.position = new Vector3(posX, posY, transform.position.z);
    }

}
