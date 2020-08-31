using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class OnDragHandler : MonoBehaviour, IDragHandler, IEndDragHandler, IBeginDragHandler
{
    //Load in -Room
    //        -Position of mouse in world
    //        -Whether or not the current object is a UI panel
    public GameObject Room;
    public GameObject NewRoom;
    Vector3 worldPosition;
    public bool isPanel;

    //Function that snaps object to grid overlay
    public Vector3 SnapToGrid(Vector3 pos)
    {
        pos.x = 4 * (Mathf.Round(pos.x / 4));
        pos.y = 4 * (Mathf.Round(pos.y / 4));
        pos.z = 4 * (Mathf.Round(pos.z / 4));
        return pos;
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        //Create Room
        if (isPanel == true)
        {
            NewRoom = (GameObject)Instantiate(Room);
            NewRoom.name = "NewRoom";
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (isPanel == true)
        {
            NewRoom.transform.position = SnapToGrid(worldPosition);
        }
        else
        {
            transform.position = SnapToGrid(worldPosition);
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        if (isPanel == true)
        {
            NewRoom.transform.position = SnapToGrid(worldPosition);
        }
        else
        {
            transform.position = SnapToGrid(worldPosition);
        }
    }

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        Vector3 mousePos = Input.mousePosition;
        mousePos.z = Camera.main.nearClipPlane;
        worldPosition = Camera.main.ScreenToWorldPoint(mousePos);
    }
}
