using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Camera/CameraRestrictToSafeZone")]
	public class CameraRestrictToSafeZone : MonoBehaviour
	{
		public Transform safeZoneCenter;
		
		public Vector2 safeZoneSize = new Vector2(1.5f, 1.5f);
		public Vector2 safeZoneOffsetFromTarget = new Vector2(0.0f, 0.0f);
		
		private Vector3 m_f3FollowVelocity;
		
		private void FixedUpdate()
		{
			ConstraintInSafeZone();
		}
		
		private void LateUpdate()
		{
			ConstraintInSafeZone();
		}
		
		private void ConstraintInSafeZone()
		{
			Vector3 f3Position = transform.position;
			
			Vector2 f2TargetPosition = safeZoneCenter.position;
			
			f3Position.x = Mathf.Clamp(f3Position.x, f2TargetPosition.x - safeZoneOffsetFromTarget.x - safeZoneSize.x, f2TargetPosition.x - safeZoneOffsetFromTarget.x + safeZoneSize.x);
			f3Position.y = Mathf.Clamp(f3Position.y, f2TargetPosition.y - safeZoneOffsetFromTarget.y - safeZoneSize.y, f2TargetPosition.y - safeZoneOffsetFromTarget.y + safeZoneSize.y);
			
			transform.position = f3Position;
		}
		
		private void OnDrawGizmos()
		{
			Vector2 f2Extent = safeZoneSize;
			Vector3 f3Offset = transform.position + (Vector3)safeZoneOffsetFromTarget;
			f3Offset.z = 0.0f;
			Vector3 f3TopLeft = new Vector3(-f2Extent.x, f2Extent.y, 0) + f3Offset;
			Vector3 f3TopRight = new Vector3(f2Extent.x, f2Extent.y, 0) + f3Offset;
			Vector3 f3BottomRight = new Vector3(f2Extent.x, -f2Extent.y, 0) + f3Offset;
			Vector3 f3BottomLeft = new Vector3(-f2Extent.x, -f2Extent.y, 0) + f3Offset;
			
			Gizmos.color = Color.blue;
			
			Gizmos.DrawLine(f3TopLeft, f3TopRight);
			Gizmos.DrawLine(f3TopRight, f3BottomRight);
			Gizmos.DrawLine(f3BottomRight, f3BottomLeft);
			Gizmos.DrawLine(f3BottomLeft, f3TopLeft);
		}
	}
}