using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class RoomScript : MonoBehaviour
{
    bool MouseExit = true;
    private void OnMouseOver()
    {
        if (Input.GetKeyDown("r"))
        {
            print("space key was pressed");
            transform.Rotate(Vector3.forward * -90);
        }
        MouseExit = false;
    }

    void Start()
    {
        
    }

    private void OnMouseExit()
    {
        if (transform.position.y < -9)
        {
            //Destroy(gameObject);
        }
        MouseExit = true;
    }
    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        Debug.Log("Collision");
        if (MouseExit == true)
        {
            Destroy(gameObject);
        }
    }

}
