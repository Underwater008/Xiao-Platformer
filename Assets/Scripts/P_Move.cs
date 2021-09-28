using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class P_Move : MonoBehaviour
{
    public float speed;
    bool isAttacking;

    public int health = 100;
    public Image imgHealth;
    public GameObject imgDeadObj;

    public GameObject[] hideObj;

    public GameObject centerPos;

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.C))
        {
            Hit();
        }

        //≥‘“©
        if (Input.GetKeyDown(KeyCode.R))
        {
            Recovery();
        }



        if (isAttacking)
        {
            return;
        }
        if (Input.GetMouseButtonDown(0))
        {
            isAttacking = true;
        }
        //Get input
        float translationV = Input.GetAxis("Vertical") * speed;
        float translationH = Input.GetAxis("Horizontal") * speed;

        /*if (Input.GetMouseButtonDown(0))
        {
            translationH = 0;
            translationV = 0;
            return;
        }*/


        //Move per second istead of per frame
        translationV *= Time.deltaTime;
        translationH *= Time.deltaTime;

        //Move the object on Z and X axis
        //transform.Translate(0, translationV, 0);
        //transform.Translate(translationH, 0, 0);

        Vector2 pos = this.transform.position;
        pos.x += translationH;
        pos.y += translationV;
        this.transform.position = pos;

        //left is right, right is left
        float _rightBoundary = -7f;
        //float _leftBoundary = 60f;
        float _leftBoundary = 171f;

        if (transform.position.x <= _rightBoundary)
        {
            pos = this.transform.position;
            pos.x = _rightBoundary;
            this.transform.position = pos;
        }
        if (transform.position.x >= _leftBoundary)
        {
            pos = this.transform.position;
            pos.x = _leftBoundary;
            this.transform.position = pos;
        }

    }
    public void attackEnd()
    {
        isAttacking = false;
    }

    public void Hit(int damage = 10)
    {
        health -= damage;

        imgHealth.fillAmount = (float)health / (float)100;

        if(health <= 0)
        {
            Dead();
        }
    }

    //ª÷∏¥
    public void Recovery(int damage = 30)
    {
        health += damage;

        if (health >= 100)
        {
            health = 100;
        }

        imgHealth.fillAmount = (float)health / (float)100;
    }

    public void Dead()
    {
        foreach (var obj in hideObj)
        {
            obj.SetActive(false);
        }
        imgDeadObj.SetActive(true);
        Invoke("LoadScene", 3.0f);
    }

    public void LoadScene()
    {
        SceneManager.LoadScene("SampleScene");
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        switch (collision.gameObject.tag)
        {
            case "recoveryItem":
                Recovery();
                Destroy(collision.gameObject);
                break; 
            default:
                break;
        }
    }
}
