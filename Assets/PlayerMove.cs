using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{

    public float speed;
    public float jumpHeight;
    public float gravityMultiplier;

    bool onFloor;

    Rigidbody2D myBody;

    SpriteRenderer myRenderer;

    public Sprite jumpSprite;
    public Sprite walkSprite;

    // Start is called before the first frame update
    void Start()
    {
        myBody = gameObject.GetComponent<Rigidbody2D>();
        myRenderer = gameObject.GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        if(onFloor && myBody.velocity.y > 0.1f)
        {
            onFloor = false;
        }
        CheckKeys();
        JumpPhysics();
    }

    void CheckKeys()
    {
        if (Input.GetKey(KeyCode.D))
        {
            myRenderer.flipX = false;
            HandleLRMovement(speed);
        } else if (Input.GetKey(KeyCode.A))
        {
            myRenderer.flipX = true;
            HandleLRMovement(-speed);
        }

        if (Input.GetKey(KeyCode.W) && onFloor)
        {
            myRenderer.sprite = jumpSprite;
            myBody.velocity = new Vector3(myBody.velocity.x, jumpHeight);
        } 
    }

    void JumpPhysics()
    {
        if(myBody.velocity.y < 0)
        {
            myBody.velocity += Vector2.up * Physics2D.gravity.y * (gravityMultiplier - 1f) * Time.deltaTime;
        }
    }

    void HandleLRMovement(float dir)
    {
        myBody.velocity = new Vector3(dir, myBody.velocity.y);
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if(collision.gameObject.tag == "floor")
        {
            myRenderer.sprite = walkSprite;
            onFloor = true;
        }
        if(collision.gameObject.tag == "enemy")
        {
            Destroy(gameObject);
        }
    }

}
