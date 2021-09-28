using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public enum EEnemyState
{
    Idle,
    Patrol,
    Chase,
    Hit,
    Dead
}


public class EnemyBase : MonoBehaviour
{
    public Rigidbody2D rb;
    public Animator anim;

    public int health = 100;

    public float speed = 1.0f;

    bool isIdle;
    bool isWalk;
    bool isPatrol;      //Ñ²Âß×´Ì¬
    bool isChase;       //×·»÷×´Ì¬
    bool isAttacking;   //¹¥»÷×´Ì¬

    bool isDead;        //ËÀÍö×´Ì¬

    public GameObject healthBarPoint;
    public GameObject healthBarObj;
    public GameObject healthBarPrefab;
    public Image imgHealth;


    public float patrolMinRange = -5.0f;
    public float patrolMaxRange = 5.0f;

    public Vector2 targetPos;
    public Vector2 currentPos;

    Transform camera;

    public Transform attackCheckTf;

    private void Awake()
    {
        rb = GetComponent<Rigidbody2D>();
        anim = GetComponent<Animator>();
    }

    private void OnEnable()
    {
        camera = Camera.main.transform;

        foreach (Canvas canvas in FindObjectsOfType<Canvas>())
        {
            healthBarObj = Instantiate(healthBarPrefab, canvas.transform);
            imgHealth = healthBarObj.transform.GetChild(0).GetComponent<Image>();
            healthBarObj.SetActive(healthBarPrefab);
        }
    }

    void Start()
    {
        targetPos = this.transform.position;

        GameManager.Instance.RegisterEnemy();
    }

    void Update()
    {
        currentPos = this.transform.position;
        //SwitchAnimation();

        if (isDead)
            return;

        SwitchAnimation();
        Move();
    }

    private void LateUpdate()
    {
        if (healthBarObj != null)
            healthBarObj.transform.position = healthBarPoint.transform.position;
    }

    //ÇÐ»»¶¯»­
    void SwitchAnimation()
    {
        anim.SetBool("walk", isWalk);
        anim.SetBool("dead", isDead);
    }

    void Move()
    {
        if (isAttacking)
            return;

        var collision = Physics2D.OverlapCircle(this.transform.position, 5.0f, LayerMask.GetMask("Player"));

        if(collision)
        {
            if(Vector2.SqrMagnitude(collision.GetComponent<P_Move>().centerPos.transform.position - this.transform.position) <= 1.5f)
            {
                print("¿ªÊ¼¹¥»÷");
                ChangeOrientation(collision.transform.position);
                Attack();
                return;
            }
            else
            {
                print("¿ªÊ¼×·»÷");
                ChangeOrientation(collision.transform.position);
                isChase = true;
                speed = 3.0f;
            }
        }
        else
        {
            isChase = false;
            speed = 1.0f;
        }



        if(Vector2.SqrMagnitude(currentPos - targetPos) <= 0.1f)
        {
            isWalk = false;
            if(isChase == true)
            {
                targetPos = collision.GetComponent<P_Move>().centerPos.transform.position;
            }
            else
            {
                GetNextPos();
            }

        }
        else
        {
            isWalk = true;
            this.transform.position = Vector2.MoveTowards(this.transform.position, targetPos, speed * Time.deltaTime);
        }
    }

    //¸Ä±äÈËÎï³¯Ïò
    void ChangeOrientation(Vector2 DesPos)
    {
        Vector3 localScale = this.transform.localScale;
        localScale.x = currentPos.x - DesPos.x >= 0 ? -2 : 2;
        this.transform.localScale = localScale;
    }

    //»ñÈ¡Ä¿±êµã
    void GetNextPos()
    {
        targetPos = currentPos;
        targetPos.x = Random.Range(patrolMinRange, patrolMaxRange);
        targetPos.x += currentPos.x;

        ChangeOrientation(targetPos);
    }

    void Attack()
    {
        isChase = false;
        isWalk = false;
        isAttacking = true;
        anim.SetTrigger("attack");
    }

    public void AttackEnd()
    {
        isAttacking = false;
    }

    public void AttackCheck()
    {
        var collision = Physics2D.OverlapCircle(attackCheckTf.position, 0.5f, LayerMask.GetMask("Player"));
        if(collision)
        {
            collision.GetComponent<P_Move>().Hit();
        }
        
    }

    public void Hit(Vector2 attackPos,int damge = 100)
    {
        health -= damge;
        UpdateHealthBar();

        if (health <= 0)
        {
            isWalk = false;
            isDead = true;
            anim.SetBool("dead", isDead);
            rb.gravityScale = 1.0f;
            this.transform.GetComponent<Collider2D>().enabled = false;
            GameManager.Instance.RemoveEnemy();
            Invoke("Dead", 3.0f);
            return;
        }
    }

    private void UpdateHealthBar()
    {
        imgHealth.fillAmount = health / 100.0f;

        if (health <= 0)
        {
            Destroy(healthBarObj,1.0f);
            return;
        }
    }

    public void Dead()
    {
        this.gameObject.SetActive(false);
        return;
    }



}
