using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class P_Attack : MonoBehaviour
{
    Animator anim;

    public Transform attackCheckTf;
    public float AttackRadius = 0.6f;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            anim.SetTrigger("attack");
        }
    }

    public void AttackCheck()
    {
        var colliders = Physics2D.OverlapCircleAll(attackCheckTf.position, AttackRadius, LayerMask.GetMask("Enemy"));

        foreach (var target in colliders)
        {
            if (target.CompareTag("Enemy"))
            {
                //target.GetComponent<BossAi>().Hit(0.1f);
            }
        }
    }
}
