using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[ExecuteInEditMode()]
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Animal/Animal")]
	public class Animal : MonoBehaviour 
	{
		public enum EState
		{
			stand,
			eat,
			walk,
			
			count
		}
			
		public string standAnimationStateName = "stand";
		public float standDurationMin = 2.0f;
		public float standDurationMax = 6.0f;
		
		public string eatAnimationStateName = "eat";
		public float eatDurationMin = 2.0f;
		public float eatDurationMax = 6.0f;
		
		public bool canEat = true;
		
		public string walkingAnimationStateName = "walk";
		public float walkingDurationMin = 4.0f;
		public float walkingDurationMax = 8.0f;
		
		public float walkingSpeed = 0.07f;
		public float walkingZoneLeft = -0.46f;
		public float walkingZoneRight = 0.97f;
		
		private EState m_eState = EState.stand;
		
		private float m_fZoneCenter;
		
		private float m_fWalkingDirection;
		
		private float m_fStateTimeRemaining;
			
		private Animator m_rAnimator;
		
		private bool m_bWaitForEatEnd;
		private int m_iWaitForEatEndCycle;
		
		private void Awake()
		{
			if(Application.isPlaying == false)
			{
				return;
			}
			
			m_rAnimator = GetComponent<Animator>();
			StartStand();
			m_fZoneCenter = transform.position.x;
			
			m_fWalkingDirection = -Mathf.Sign(transform.localScale.x);
			
			UpdateFlip();
		}
		
		private void Update()
		{
			EnsureWalkingZoneCoherence();
			
			if(Application.isPlaying == false)
			{
				return;
			}
			
			switch(m_eState)
			{
				case EState.stand:
				{
					UpdateStand();
				}
				break;
				
				case EState.eat:
				{
					UpdateEat();
				}
				break;
				
				case EState.walk:
				{
					UpdateWalk();
				}
				break;
			}
			
			UpdateAnimation();
		}
		
		private void UpdateAnimation()
		{
			if(m_rAnimator != null)
			{
				m_rAnimator.Play(GetAnimationStateName());
			}
		}
		
		private string GetAnimationStateName()
		{
			switch(m_eState)
			{
				case EState.eat:
				{
					return eatAnimationStateName;
				}
				
				case EState.walk:
				{
					return walkingAnimationStateName;
				}
				
				default:
				case EState.stand:
				{
					return standAnimationStateName;
				}
			}
		}
		
		private void SelectDirection()
		{
			if(Random.Range(0, 1)%2 == 0)
			{
				m_fWalkingDirection = 1.0f;
			}
			else
			{
				m_fWalkingDirection = -1.0f;
			}
		}
		
		private void UpdateFlip()
		{
			Vector3 f3LocalScale = transform.localScale;
			f3LocalScale.x = -Mathf.Abs(f3LocalScale.x) * m_fWalkingDirection;
			transform.localScale = f3LocalScale;
		}
		
		private void EnsureWalkingZoneCoherence()
		{
			if(walkingZoneLeft > walkingZoneRight)
			{
				float fSaveWalkingZoneLeft = walkingZoneLeft;
				walkingZoneLeft = walkingZoneRight;
				walkingZoneRight = fSaveWalkingZoneLeft;
			}
		}
		
		private void StartRandomState()
		{
			List<EState> oAvailableStates = new List<EState>();
			
			for(int i = 0; i < (int)EState.count; ++i)
			{
				EState eState = (EState)i;
				
				if(canEat == false && eState == EState.eat)
				{
					continue;
				}
				
				if(eState != m_eState)
				{
					oAvailableStates.Add(eState);
				}
			}
			
			EState eRandomState = oAvailableStates[Random.Range(0, oAvailableStates.Count)];
			
			StartState(eRandomState);
		}
		
		private void StartState(EState a_eState)
		{
			switch(a_eState)
			{
				case EState.stand:
				{
					StartStand();
				}
				break;
				
				case EState.eat:
				{
					StartEat();
				}
				break;
				
				case EState.walk:
				{
					StartWalk();
				}
				break;
			}
		}
		
		// Stand
		private void StartStand()
		{
			m_eState = EState.stand;
			m_fStateTimeRemaining = Random.Range(standDurationMin, standDurationMax);
		}
		
		private void StopStand()
		{
			m_fStateTimeRemaining = 0.0f;
			StartRandomState();
		}
		
		private void UpdateStand()
		{
			m_fStateTimeRemaining -= Time.deltaTime;
			if(m_fStateTimeRemaining <= 0.0f)
			{
				StopStand();
			}
		}
		
		// Eat
		private void StartEat()
		{
			m_eState = EState.eat;
			m_fStateTimeRemaining = Random.Range(eatDurationMin, eatDurationMax);
		}
		
		private void StopEat()
		{
			m_bWaitForEatEnd = false;
			m_fStateTimeRemaining = 0.0f;
			StartRandomState();
		}
		
		private void UpdateEat()
		{
			if(m_bWaitForEatEnd)
			{
				if(m_rAnimator == null)
				{
					StopEat();
				}
				else
				{
					if(GetCurrentCycle() >= m_iWaitForEatEndCycle)
					{
						StopEat();
					}
				}
			}
			else
			{
				m_fStateTimeRemaining -= Time.deltaTime;
				if(m_fStateTimeRemaining <= 0.0f)
				{
					if(m_rAnimator == null)
					{
						StopEat();
					}
					else
					{
						m_iWaitForEatEndCycle = GetCurrentCycle() + 1;
						m_bWaitForEatEnd = true;
					}
				}
			}
		}
		
		private int GetCurrentCycle()
		{
			return Mathf.FloorToInt(m_rAnimator.GetCurrentAnimatorStateInfo(0).normalizedTime);
		}
		
		
		// Walk
		private void StartWalk()
		{
			m_eState = EState.walk;
			m_fStateTimeRemaining = Random.Range(walkingDurationMin, walkingDurationMax);
			SelectDirection();
		}
		
		private void StopWalk()
		{
			m_fStateTimeRemaining = 0.0f;
			StartStand();
		}
		
		private void UpdateWalk()
		{
			Vector3 f3Position = transform.position;
			
			f3Position.x += walkingSpeed * m_fWalkingDirection * Time.deltaTime;
			
			// Rebound
			float fLeft = m_fZoneCenter + walkingZoneLeft;
			float fRight = m_fZoneCenter + walkingZoneRight;
			if(f3Position.x < fLeft)
			{
				f3Position.x = fLeft + (fLeft - f3Position.x);
				m_fWalkingDirection = 1.0f;
			}
			
			if(f3Position.x > fRight)
			{
				f3Position.x = fRight + (fRight - f3Position.x);
				m_fWalkingDirection = -1.0f;
			}
			
			f3Position.x = Mathf.Clamp(f3Position.x, fLeft, fRight);
			
			transform.position = f3Position;
			
			// Flip
			UpdateFlip();
			
			m_fStateTimeRemaining -= Time.deltaTime;
			if(m_fStateTimeRemaining <= 0.0f)
			{
				StopWalk();
			}
		}
		
		private void OnDrawGizmos()
		{		
			EnsureWalkingZoneCoherence();
			
			float fZoneCenterSet;
			if(Application.isPlaying)
			{
				fZoneCenterSet = m_fZoneCenter;
			}
			else
			{
				fZoneCenterSet = transform.position.x;
			}
			
			Gizmos.color = Color.blue;
			
			Vector3 f3Left = transform.position;
			f3Left.x = fZoneCenterSet + walkingZoneLeft;
			
			Vector3 f3Right = transform.position;
			f3Right.x = fZoneCenterSet + walkingZoneRight;
			
			Gizmos.DrawLine(f3Left, f3Right);
		}
	}
}
