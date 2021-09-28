using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BossAi : MonoBehaviour
{
    private Rigidbody2D rig;//刚体
    private Animator Anim;//动画
    public GameObject meleeDamager;

    [Header("Layers")]
    public LayerMask playerLayer;//用来开启layer
    private Transform playerPos;

    [Header("Collision")]
    private Collider2D coll;//碰撞器

    [SerializeField] private float collisionRadius = 5f;//检测碰撞半径

    Vector2 beg;//射线起点

    Vector2 down = new Vector2(0, -1);//控制射线角度的向量

    [SerializeField] private float radialLength = 25f;//射线的长度

    [Header("Speed")]
    public float moveSpeed = 200f;//移动速度

    [SerializeField] private float face;//朝向

    private float vecScale = 1.5f;

    //视距
    public float disAttack;
    private bool isReadyAttack = true;
    private bool isWait = true;
    private bool isDead;

    [Header("HP")]
    public Slider bossHpSlider;

    private void Awake()
    {
        playerPos = GameObject.FindWithTag("Player").gameObject.transform;
    }
    void Start()
    {
        rig = GetComponent<Rigidbody2D>();
        Anim = GetComponent<Animator>();
        coll = GetComponent<Collider2D>();

        if (playerPos == null)
        {
            playerPos = GameObject.FindWithTag("Player").gameObject.transform;
        }

        face = -1;
        playerLayer = 1 << 4;

        meleeDamager.gameObject.SetActive(false);

        bossHpSlider.value = 1;
    }

    void FixedUpdate()
    {
        if (!isDead)
        {
            beg = transform.position;
            Collider2D playerColl = isPlayerView();

            if (isBorder() || isWaller())
            {
                rig.velocity = new Vector2(0, 0);
                AccordingDirectionFlip(playerColl);
                Flip();
            }
            else
            {
                AccordingDirectionFlip(playerColl);
                Move();
            }
        }
    }

    void AccordingDirectionFlip(Collider2D playerColl)
    {
        if (playerColl != null)
        {
            int direction;
            if (playerColl.transform.position.x < transform.position.x)
            {
                direction = -1;
            }
            else
            {
                direction = 1;
            }


            if (direction != face)
            {
                Flip();
            }
        }
    }

    void Flip()
    {
        face = (face == 1) ? -1 : 1;
        transform.localScale = new Vector2(face * (-vecScale), vecScale);
    }

    bool isBorder()
    {
        Debug.DrawLine(beg, beg + (new Vector2(face, 0) + down) * radialLength, Color.red);
        bool isBor = !Physics2D.Raycast(beg, new Vector2(face, 0) + down, radialLength, LayerMask.GetMask("Platform"));

        if (isBor)
        {
            return true;
        }

        return false;
    }

    bool isWaller()
    {
        Debug.DrawLine(beg, beg + (new Vector2(face, 0)) * radialLength, Color.black);
        bool isBor = Physics2D.Raycast(beg, new Vector2(face, 0), radialLength, LayerMask.GetMask("Platform"));

        if (isBor)
        {
            return true;
        }

        return false;
    }


    Collider2D isPlayerView()
    {
        return Physics2D.OverlapCircle((Vector2)transform.position, collisionRadius, playerLayer);
    }


    void Move()
    {
        
        if (isWait)
        {
            rig.velocity = new Vector2(face * moveSpeed * Time.deltaTime, 0);
            Debug.Log("Move");
        }

        ChangeAnimator();

        if (Vector2.Distance(this.transform.position, playerPos.position) <= disAttack && isReadyAttack)
        {
            rig.velocity = new Vector2(face * 15 , 0);

            Anim.SetBool("distance", true);
            isReadyAttack = false;

            isWait = false;
        }
    }

    void attackTime()
    {
        isReadyAttack = true;
    }

    void waitTime()
    {
        isWait = true;
    }

    public void setTurnToRun()
    {
        Anim.SetBool("distance", false);
        Invoke("waitTime", 1f);
        Invoke("attackTime", 2f);
    }

    void ChangeAnimator()
    {
        Anim.SetFloat("speed", Mathf.Abs(rig.velocity.x));
    }


    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere((Vector2)transform.position, collisionRadius);
        Gizmos.DrawLine((Vector2)transform.position, (Vector2)transform.position + (new Vector2(face, 0) + down) * radialLength);
        Gizmos.DrawLine((Vector2)transform.position, (Vector2)transform.position + (new Vector2(face, 0)) * radialLength);
    }


    public void Hit(float damageValue)
    {
        bossHpSlider.value -= damageValue;

        if (bossHpSlider.value <= 0)
        {
            bossHpSlider.value = 0;
            Anim.SetBool("isDead", true);
            isDead = true;

            rig.bodyType = RigidbodyType2D.Static;
            return;
        }
    }

    public void StartAttack()
    {
        Debug.Log("StartAttack");
        meleeDamager.gameObject.SetActive(true);
    }

    public void EndAttack()
    {
        Debug.Log("EndAttack");
        if (meleeDamager != null)
        {
            meleeDamager.gameObject.SetActive(false);
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        switch (collision.tag)
        {
            case "playerWeapon":
                Hit(0.25f);
                break;
            default:
                break;
        }
    }
}
