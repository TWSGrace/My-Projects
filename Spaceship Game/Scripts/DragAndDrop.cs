using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class DragAndDrop : MonoBehaviour, IPointerDownHandler, IBeginDragHandler, IEndDragHandler, IDragHandler
{

    public GameObject myPrefab;

    public void OnBeginDrag(PointerEventData eventData)
    {
        Debug.Log("Begin Drag");
    }
    public void OnDrag(PointerEventData eventData)
    {
            Debug.Log("Being Dragged");
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        Debug.Log("End Drag");
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        Debug.Log("Click");
    }
}
