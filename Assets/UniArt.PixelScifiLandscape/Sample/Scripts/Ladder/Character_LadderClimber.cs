using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Ladder/Character/Character_LadderClimber")]
	public class Character_LadderClimber : MonoBehaviour 
	{
		public System.Action onStartClimb;
		
		public System.Action onStopClimb;
		
		public System.Action<float> onClimb;
		
		public Character_MovementController movementController;
		
		public Character_Input characterInput;
		
		public Character_LadderTester ladderTester;
		
		public float climbSpeed = 0.5f;
		
		public float climbRunSpeed = 1.0f;
		
		public float quitByJumpingDuration = 0.25f;
		
		public float canJumpAfterLadderDuration = 0.2f;
		
		public float canClimbInADirectionTolerance = 0.025f;
		
		public Transform climberTop;
		
		public Transform climberBottom;
		
		private bool m_bClimbing;
		
		private Object_Ladder m_rLadder;
		
		private bool m_bQuitByJumping;
		
		private float m_fQuitByJumpingRemainingTime;
		
		public bool IsClimbing
		{
			get
			{
				return m_bClimbing;
			}
		}
		
		private Vector2 Position
		{
			get
			{
				return movementController.Position;
			}
			
			set
			{
				movementController.Position = value;
			}
		}
		
		private void FixedUpdate()
		{
			ProcessLadderClimb();
		}
		
		private void ProcessLadderClimb()
		{
			float fVertical = characterInput.Vertical;
			float fHorizontal = characterInput.Horizontal;
			
			bool bQuitLadder = (fHorizontal != 0.0f && Mathf.Abs(fHorizontal) > Mathf.Abs(fVertical)) 
			|| characterInput.Jump;
			
			if(m_bQuitByJumping)
			{
				m_fQuitByJumpingRemainingTime -= Time.fixedDeltaTime;
				if(m_fQuitByJumpingRemainingTime <= 0)
				{
					m_bQuitByJumping = false;
				}
			}
			
			if(m_bClimbing)
			{	
				if(bQuitLadder)
				{
					StopClimbing();
				}
				else
				{
					float fClimbSpeed;
					if(characterInput.Run)
					{
						fClimbSpeed = climbRunSpeed;
					}
					else
					{
						fClimbSpeed = climbSpeed;
					}
					Climb(fClimbSpeed * Time.fixedDeltaTime * fVertical);
				}
			}
			else if(bQuitLadder == false && m_bQuitByJumping == false)
			{
				if(fVertical != 0.0f)
				{
					Object_Ladder rLadder = ladderTester.GetNearestLadder(movementController.rigidbodyComponent.transform.position);
					if(rLadder != null)
					{
						if(fVertical > 0.0f)
						{
							if(climberTop.position.y > rLadder.ladderTop.position.y - canClimbInADirectionTolerance)
							{
								return;
							}
						}
						else
						{
							if(climberBottom.position.y < rLadder.ladderBottom.position.y + canClimbInADirectionTolerance)
							{
								return;
							}
						}
						
						StartClimbing(rLadder);
					}
				}
			}
		}
		
		private void StartClimbing(Object_Ladder a_rLadder)
		{
			m_bQuitByJumping = false;
			m_bClimbing = true;
			m_rLadder = a_rLadder;
			
			Position = m_rLadder.SnapOnLadder(Position, climberTop.position, climberBottom.position);
			
			movementController.DisableMovement();
			
			if(onStartClimb != null)
			{
				onStartClimb();
			}
		}
		
		private void StopClimbing()
		{
			m_bClimbing = false;
			m_rLadder = null;
			
			movementController.EnableMovement();
			
			float fVertical = characterInput.Vertical;
			float fHorizontal = characterInput.Horizontal;
			
			if(characterInput.Jump)
			{
				if(!(fVertical < 0.0f && Mathf.Abs(fVertical) >= Mathf.Abs(fHorizontal)))
				{
					movementController.Jump();
				}
				m_bQuitByJumping = true;
				m_fQuitByJumpingRemainingTime = quitByJumpingDuration;
			}
			else
			{
				movementController.CanJump(canJumpAfterLadderDuration);
			}
			
			if(onStopClimb != null)
			{
				onStopClimb();
			}
		}
		
		private void Climb(float a_fClimb)
		{
			float fClimbHeightPrevious = Position.y;
			bool bReachTheTop;
			bool bReachTheBottom;
			Position = m_rLadder.SnapOnLadder(Position + m_rLadder.LadderUpDirection * a_fClimb, climberTop.position, climberBottom.position, out bReachTheTop, out bReachTheBottom);
			float fClimbHeightNext = Position.y;
			
			if(onClimb != null)
			{
				onClimb(fClimbHeightNext - fClimbHeightPrevious);
			}
			
			if(m_rLadder.canGoOnTop && characterInput.Vertical > 0.0f && bReachTheTop)
			{
				PutOnTop();	
			}
			else if(m_rLadder.canGoOnBottom && characterInput.Vertical < 0.0f && bReachTheBottom)
			{
				PutOnBottom();
			}
		}
		
		private void PutOnTop()
		{
			Position = (Vector2)m_rLadder.ladderTop.position + (Position - (Vector2)climberBottom.position);
			StopClimbing();
		}
		
		private void PutOnBottom()
		{
			Position = (Vector2)m_rLadder.ladderBottom.position + (Position - (Vector2)climberBottom.position);
			StopClimbing();
		}
	}
}
