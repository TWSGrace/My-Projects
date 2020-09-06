using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class AStar : MonoBehaviour
{
    //Declare new class type Node with variables
    // x = x cooordinate
    // y = y coordinate
    // dt = distance travelled
    // de = distance to end
    // totalcost = dt + de
    // ID = unique ID for each Node
    // previousNode = the Node that provides the shortest path to the current Node
    public class Node
    {
        public float x, y, totalcost, dt, de;
        public string ID, previousNode;
    }
    //Initialise Target position
    Vector3 Target;

    //Initialise the lists Nodes, finishedNodes and Path
    List<Node> Nodes = new List<Node>();
    List<Node> finishedNodes = new List<Node>();
    List<Node> Path = new List<Node>();
    List<string> finishedNodesID = new List<string>();
    List<string> NodesID = new List<string>();
    Node currentNode;

    //Function to getID for each Node from its x and y values
    //Node at (1, 1) would have an ID of 11
    string getID(float x, float y)
    {
        return (x.ToString() + y.ToString());
    }

    //Function to get distance between two points
    float getDistance(float x1, float y1, float x2, float y2)
    {
        return Mathf.Sqrt(Mathf.Pow((x2 - x1), 2)) + Mathf.Pow((y2 - y1), 2);
    }

    //Function to create a Node, and fill out relevant details based on relative position to currentNode
    //variable a = x offset, b = y offset
    Node createAdjacentNode(int a, int b)
    {
        if ((currentNode.x + a < 16) & (currentNode.x + a > 0) & (currentNode.y + b < 9) & (currentNode.y + b > 0))
        {
            Node ThisNode = new Node { x = currentNode.x + a, y = currentNode.y + b, dt = currentNode.dt + 1 };
            ThisNode.previousNode = currentNode.ID;
            if ((ThisNode.x == Target.x) & (ThisNode.y == Target.y))
            {
                finishedNodes.Add(ThisNode);
                currentNode = ThisNode;
            }
            ThisNode.ID = getID(ThisNode.x, ThisNode.y);
            ThisNode.dt = currentNode.dt + 1;
            ThisNode.de = getDistance(ThisNode.x, ThisNode.y, Target.x, Target.y);
            ThisNode.totalcost = ThisNode.dt + ThisNode.de;
            return ThisNode;
        }
        else return null;
    }

    void aStarAlgorithm()
    {
        if (transform.position != Target)
        {
            //Create Start Node that is position of player and fill out relevant details
            var Start = new Node();
            Start.x = Mathf.Floor(transform.position.x) + 0.5f;
            Start.y = Mathf.Floor(transform.position.y) + 0.5f;
            Start.dt = 0;
            Start.de = getDistance(Start.x, Start.y, Target.x, Target.y);
            Start.totalcost = Start.dt + Start.de;
            Start.ID = getID(Start.x, Start.y);
            Start.previousNode = null;
            Nodes.Add(Start);
            currentNode = Start;

            //Do this while currentNode is not at the Targets position
            while (((currentNode.x != Target.x) || (currentNode.y != Target.y)) || (currentNode == null))
            {
                //Sort Nodes list by total cost, and make currentNode the Node with the smallest total
                Nodes.Sort(delegate (Node x, Node y)
                {
                    return x.totalcost.CompareTo(y.totalcost);
                });
                currentNode = Nodes[0];
                //Add currentNode to the finished list and remove from the Nodes list
                finishedNodes.Add(currentNode);
                finishedNodesID.Add(currentNode.ID);
                Nodes.RemoveAt(0);

                //Create all the adjacent Nodes to currentNode
                var adjacentNodes = new List<Node>()
                {
                    (createAdjacentNode(0, 1)),
                    (createAdjacentNode(1, 0)),
                    (createAdjacentNode(0, -1)),
                    (createAdjacentNode(-1, 0)),
                };

                //Cycle through each adjacentNode created and if it hasn't already been placed into either Node list, add to Nodes 
                foreach (Node adjacentNode in adjacentNodes)
                {
                    if (adjacentNode != null)
                    {
                        if ((finishedNodesID.Contains(adjacentNode.ID) == false) & (NodesID.Contains(adjacentNode.ID) == false))
                        {
                            Nodes.Add(adjacentNode);
                            NodesID.Add(adjacentNode.ID);
                        }
                    }
                }
            }

            //Once we have found Target Node add it to the Path list
            Path.Add(finishedNodes.Last());
            
            //Cycle through finishedNodes looking for previous nodes, and adding them to Path
            while (Path.Last() != Start)
            {
                string IDofPrevious = Path.Last().previousNode;
                for (int i = 0; i < finishedNodes.Count - 1; i++)
                {
                    if (finishedNodes[i].ID == IDofPrevious)
                    {
                        Node previousNode = finishedNodes[i];
                        Path.Add(finishedNodes[i]);
                        i = finishedNodes.Count;
                    }
                }
            }

            //Print each Nodes ID from Path
            for (int i = 0; i < Path.Count - 1; i++)
            {
                Debug.Log("PathID " + Path[i].ID + " ");
            }
            Debug.Log("Path ID " + Start.ID + " ");

            //Reset all the lists
            Nodes.Clear();
            finishedNodes.Clear();
            NodesID.Clear();
            finishedNodesID.Clear();
            Path.Clear();
        }
    }


    // Update is called once per frame
    void Update()
    {
        //If mouse is clicked, set target to position of mouse and begin A Star Algorithm
        if (Input.GetMouseButtonDown(0))
        {
            Target = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            Target = new Vector3(Mathf.Floor(Target.x) + 0.5f, Mathf.Floor(Target.y) + 0.5f, Target.z);
            aStarAlgorithm();
        }
    }

}
            

