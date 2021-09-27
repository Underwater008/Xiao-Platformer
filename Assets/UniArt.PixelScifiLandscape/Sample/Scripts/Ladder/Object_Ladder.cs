using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Ladder/Object_Ladder")]
	public class Object_Ladder : MonoBehaviour 
	{
		public Transform ladderTop;
		
		public Transform ladderBottom;
		
		public bool canGoOnTop = false;
		public bool canGoOnBottom = false;
		
		public Vector2 LadderUpDirection
		{
			get
			{
				return (Vector2)transform.up;
			}
		}
		
		public float DistanceToLadder(Vector2 a_f2Position)
		{
			Vector2 f2Projected = ProjectOnLadder(a_f2Position);
			
			float fDistance = Vector2.Distance(f2Projected, a_f2Position);
			return fDistance;
		}
		
		public Vector2 SnapOnLadder(Vector2 a_f2Position, Vector2 a_f2SnapTop, Vector2 a_f2SnapBottom)
		{
			bool bReachTheTop;
			bool bReachTheBottom;
			return SnapOnLadder(a_f2Position, a_f2SnapTop, a_f2SnapBottom, out bReachTheTop, out bReachTheBottom);
		}
		
		public Vector2 SnapOnLadder(Vector2 a_f2Position, Vector2 a_f2SnapTop, Vector2 a_f2SnapBottom, out bool a_bReachTheTop, out bool a_bReachTheBottom)
		{
			Vector2 f2Projected = ProjectOnLadder(a_f2Position);
			
			Vector2 f2LadderTop = ProjectOnLadder(ladderTop.position);
			Vector2 f2LadderBottom = ProjectOnLadder(ladderBottom.position);
			
			Vector2 f2SnapTop = ProjectOnLadder(a_f2SnapTop);
			Vector2 f2SnapBottom = ProjectOnLadder(a_f2SnapBottom);
			
			float fSnapMin = Mathf.Min(f2SnapTop.y, f2SnapBottom.y);
			float fSnapMax = Mathf.Max(f2SnapTop.y, f2SnapBottom.y);
			
			float fLadderMin = Mathf.Min(f2LadderTop.y, f2LadderBottom.y);
			float fLadderMax = Mathf.Max(f2LadderTop.y, f2LadderBottom.y);
			
			float fProjectionMax = fLadderMax - (fSnapMax - f2Projected.y);
			float fProjectionMin = fLadderMin - (f2Projected.y - fSnapMin);
			
			if(f2Projected.y >= fProjectionMax)
			{
				a_bReachTheTop = true;
			}
			else
			{
				a_bReachTheTop = false;
			}
			
			if(f2Projected.y <= fProjectionMin)
			{
				a_bReachTheBottom = true;
			}
			else
			{
				a_bReachTheBottom = false;
			}
			
			f2Projected.y = Mathf.Clamp(f2Projected.y, fProjectionMin, fProjectionMax);
			
			return f2Projected;
		}
		
		public Vector2 ProjectOnLadder(Vector2 a_f2Position)
		{
			Vector2 f2LadderDirection = LadderUpDirection;
			Vector2 f2LadderCenterPosition = (Vector2)transform.position;
			Vector2 f2LadderCenterToPosition = a_f2Position - f2LadderCenterPosition;
			Vector2 f2Projected = Vector2.Dot(f2LadderCenterToPosition, f2LadderDirection) * f2LadderDirection + f2LadderCenterPosition;
			
			return f2Projected;
		}
	}
}
