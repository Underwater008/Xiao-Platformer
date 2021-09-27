using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_LookController")]
	public class Character_LookController : MonoBehaviour 
	{
		public Transform cameraTarget;
		
		public float smoothTime = 0.5f;
		
		private float m_fLookVelocity;
		
		private float m_fCameraTargetInitialLocalHeight;
		
		private float m_fLookOffset;
		
		public float LookOffset
		{
			get
			{
				return m_fLookOffset;
			}
			
			set
			{
				m_fLookOffset = value;
			}
		}
		
		private float CameraTargetHeight
		{
			get
			{
				return cameraTarget.localPosition.y;
			}
			
			set
			{
				Vector3 f3CameraTargetPosition = cameraTarget.localPosition;
				f3CameraTargetPosition.y = value;
				cameraTarget.localPosition = f3CameraTargetPosition;
			}
		}
		
		private void Awake()
		{
			m_fCameraTargetInitialLocalHeight = cameraTarget.localPosition.z;
		}
		
		private void Update()
		{	
			CameraTargetHeight = Mathf.SmoothDamp(CameraTargetHeight, m_fLookOffset + m_fCameraTargetInitialLocalHeight, ref m_fLookVelocity, smoothTime);
			
			m_fLookOffset = 0.0f;
		}
	}
}
