using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class P_MoveAnim : MonoBehaviour
{
    Animator anim;
    public float moveInputH;
    public float moveInputV;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        //Remove warning
        //myEvent.messageOptions = SendMessageOptions.DontRequireReceiver;


        moveInputH = Input.GetAxis("Horizontal");
        moveInputV = Input.GetAxis("Vertical");

        /*if (Input.GetMouseButtonDown(0))
        {
            moveInputH = 0;
            moveInputV = 0;
            return;
        }*/
        
        if (moveInputV == 0)
        {
            anim.SetBool("isRunningV", false);
        }
        else
        {
            anim.SetBool("isRunningV", true);
        }

        if (moveInputH == 0)
        {
            anim.SetBool("isRunning", false);
        }
        else
        {
            anim.SetBool("isRunning", true);
        }

        if (moveInputH < 0)
        {
            transform.eulerAngles = new Vector3(0, 180, 0);
        }
        else if (moveInputH > 0)
        {
            transform.eulerAngles = new Vector3(0, 0, 0);
        }
    }
}
