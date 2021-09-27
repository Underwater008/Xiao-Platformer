using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Camera/CameraFollowTarget")]
	public class CameraFollowTarget : MonoBehaviour
	{
		public Transform target;
		
		public float smoothTime = 0.5f; 
		
		private Vector3 m_f3FollowVelocity;
		
		private void FixedUpdate()
		{		
			Vector3 f3Position = transform.position;
			
			Vector2 f2TargetPosition = target.position;
			Vector2 f2Position = f3Position;
			
			Vector3 f3SmoothedPosition = Vector3.SmoothDamp(f2Position, f2TargetPosition, ref m_f3FollowVelocity, smoothTime);
			
			f3SmoothedPosition.z = f3Position.z;
			
			transform.position = f3SmoothedPosition;
		}
	}
}