using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[RequireComponent(typeof(Animal))]
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Animal/Bird")]
	public class Bird : MonoBehaviour 
	{	
		public System.Action onStartFlying;
		
		public string flyingAnimationStateName = "fly";
		public float flyingSpeed = 1.0f;
		public float flyDirectionAngle = 25.0f;
		
		private Animal m_rAnimal;
		
		private Vector3 m_f3FlyingDirection;
		
		private bool m_bFlying;
		
		private Animator m_rAnimator;
		
		private Vector3 m_f3SpawnPoint;
		
		private void Awake()
		{
			m_rAnimal = GetComponent<Animal>();
			m_rAnimator = GetComponent<Animator>();
			m_f3SpawnPoint = transform.position;
		}
		
		private void Update()
		{
			if(m_bFlying)
			{
				// Move
				Vector3 f3Position = transform.position;
				
				f3Position += m_f3FlyingDirection * Time.deltaTime * flyingSpeed;
				
				transform.position = f3Position;
				
				// Animate
				m_rAnimator.Play(flyingAnimationStateName);
				
				// Orient
				UpdateFlip();
				
				// Check for flying end
				if(CanRespawn())
				{
					StopFlying();
				}
			}
		}
		
		private void OnTriggerEnter2D()
		{
			if(m_bFlying == false)
			{
				StartFlying();
			}
		}
		
		private void UpdateFlip()
		{
			Vector3 f3LocalScale = transform.localScale;
			f3LocalScale.x = -Mathf.Abs(f3LocalScale.x) * Mathf.Sign(m_f3FlyingDirection.x);
			transform.localScale = f3LocalScale;
		}
		
		private void StartFlying()
		{
			m_rAnimal.enabled = false;
			m_bFlying = true;
			m_f3FlyingDirection = Matrix4x4.TRS(Vector3.zero, Quaternion.Euler(0.0f, 0.0f, Random.Range(-flyDirectionAngle, flyDirectionAngle)), Vector3.one).MultiplyVector(Vector3.up);
			
			if(onStartFlying != null)
			{
				onStartFlying();
			}
		}
		
		private void StopFlying()
		{
			m_rAnimal.enabled = true;
			m_bFlying = false;
			transform.position = m_f3SpawnPoint;
		}
		
		private bool CanRespawn()
		{
			if(GetComponent<Renderer>().isVisible == false)
			{
				Camera rCamera = Camera.main;
				if(rCamera == null)
				{
					return true;
				}
				else
				{
					Vector3 f3SpawnPoint_ViewportPosition = rCamera.WorldToViewportPoint(m_f3SpawnPoint);
					if(f3SpawnPoint_ViewportPosition.x < 0.0f || f3SpawnPoint_ViewportPosition.x > 1.0f
					   || f3SpawnPoint_ViewportPosition.y < 0.0f || f3SpawnPoint_ViewportPosition.y > 1.0f)
				   	{
				   		return true;
				   	}
				}
			}

			return false;
		}
	}
}
