using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    private static GameManager instance;

    public static GameManager Instance { get { return instance; } }

    public int EnemyCount;

    public bool isGameSuccess;

    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }

    void Start()
    {
        
    }

    public void RegisterEnemy()
    {
        EnemyCount += 1;
    }

    public void RemoveEnemy()
    {
        EnemyCount -= 1;
        
        if(EnemyCount == 0)
        {
            isGameSuccess = true;
        }
    }
}
