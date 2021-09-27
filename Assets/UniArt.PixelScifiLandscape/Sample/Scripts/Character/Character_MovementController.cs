using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_MovementController")]
	public class Character_MovementController : MonoBehaviour 
	{
		public System.Action onJump;
		
		public Rigidbody2D rigidbodyComponent;
		
		public Character_Input characterInput;
		
		public Character_GroundedTester groundedTester;
		
		public float moveForce = 40.0f;
		
		public float moveSpeedMax_Walk = 0.05f;
		
		public float moveSpeedMax_Run = 0.05f;
		
		public float moveSpeedMax_Fall = 1.0f;
		
		public float moveSpeedMax_FallRun = 2.0f;
		
		public float moveSpeedMax_Slide = 0.05f;
		
		public float groundDamping = 20.0f;
		
		public float groundSlideDamping = 20.0f;
		
		public float minSlideVelocity = 0.1f;
		
		public float airDamping = 20.0f;
		
		public float jump = 2.0f;
		
		public float earlyJumpToleranceDuration = 0.2f;
		
		public float lateJumpToleranceDuration = 0.2f;
		
		public float jumpGravityScale = 0.42f;
		
		public float runGravityScale = 0.9f;
		
		private float m_fWillJumpTimeRemaining;
		
		private float m_fCanJumpTimeRemaining;
		
		private bool m_bStill;
		
		private float m_fInitialGravityScale;
		
		public Vector2 Velocity
		{
			get
			{
				return rigidbodyComponent.velocity;
			}
			
			set
			{
				rigidbodyComponent.velocity = value;
			}
		}
		
		public Vector2 Position
		{
			get
			{
				return rigidbodyComponent.transform.position;
			}
			
			set
			{
				rigidbodyComponent.transform.position = value;
			}
		}
		
		public void DisableMovement()
		{
			enabled = false;
			rigidbodyComponent.isKinematic = true;
		}
		
		public void EnableMovement()
		{
			enabled = true;
			rigidbodyComponent.isKinematic = false;
		}
		
		public void CanJump(float a_fDuration)
		{
			m_fCanJumpTimeRemaining = a_fDuration;
		}
		
		public void Jump()
		{
			m_fWillJumpTimeRemaining = 0.0f;
			m_fCanJumpTimeRemaining = 0.0f;
			
			Vector2 f2Velocity = rigidbodyComponent.velocity;
			
			f2Velocity.y = jump;
			
			rigidbodyComponent.velocity = f2Velocity;
			
			if(onJump != null)
			{
				onJump();
			}
		}
		
		private void Awake()
		{
			m_fInitialGravityScale = rigidbodyComponent.gravityScale;
		}
		
		private void FixedUpdate()
		{
			ProcessHorizontalMovement();
			ProcessJump();
			ProcessGravityModification();
		}
		
		private void ProcessHorizontalMovement()
		{
			bool bCrouch = (characterInput.Vertical < 0.0f) && groundedTester.IsGrounded;
			
			float fHorizontal = characterInput.Horizontal;
			
			Vector2 f2Velocity = rigidbodyComponent.velocity;
			
			if(bCrouch == false)
			{
				f2Velocity.x += moveForce * fHorizontal * Time.fixedDeltaTime;
			}
			
			m_bStill = false;
			if(groundedTester.IsGrounded)
			{
				if(fHorizontal == 0.0f && bCrouch == false)
				{
					m_bStill = true;
					f2Velocity = Vector2.zero;
				}
				else
				{
					float fGroundDamping = groundDamping;
					if(bCrouch)
					{
						fGroundDamping = groundSlideDamping;
					}
					f2Velocity.x -= fGroundDamping * f2Velocity.x * Time.fixedDeltaTime;	
				}
			}
			else
			{
				f2Velocity.x -= airDamping * f2Velocity.x * Time.fixedDeltaTime;
			}
			
			float fMoveSpeedMax;
			if(bCrouch)
			{
				fMoveSpeedMax = moveSpeedMax_Slide;
			}
			else if(groundedTester.IsGrounded)
			{
				if(characterInput.Run)
				{
					fMoveSpeedMax = moveSpeedMax_Run;
				}
				else
				{
					fMoveSpeedMax = moveSpeedMax_Walk;
				}
			}
			else
			{
				if(characterInput.Run)
				{
					fMoveSpeedMax = moveSpeedMax_FallRun;
				}
				else
				{
					fMoveSpeedMax = moveSpeedMax_Fall;
				}
			}
			
			f2Velocity.x = Mathf.Clamp(f2Velocity.x, -fMoveSpeedMax, fMoveSpeedMax);
			
			if(bCrouch)
			{
				if(Mathf.Abs(f2Velocity.x) < minSlideVelocity)
				{
					f2Velocity.x = 0.0f;
				}
			}
			
			rigidbodyComponent.velocity = f2Velocity;
		}
		
		private void ProcessJump()
		{
			bool bGetJump = characterInput.Jump;
			
			// Early jump
			if(bGetJump && groundedTester.IsGrounded == false)
			{
				m_fWillJumpTimeRemaining = earlyJumpToleranceDuration;
			}
			else
			{
				if(m_fWillJumpTimeRemaining > 0)
				{
					m_fWillJumpTimeRemaining -= Time.fixedDeltaTime;
				}
			}
			
			// Late Jump
			if(groundedTester.IsGrounded)
			{
				m_fCanJumpTimeRemaining = lateJumpToleranceDuration;
			}
			
			if(groundedTester.IsGrounded || m_fCanJumpTimeRemaining > 0)
			{
				if(bGetJump || m_fWillJumpTimeRemaining > 0)
				{
					Jump();
				}
			}
			
			// Late Jump
			if(m_fCanJumpTimeRemaining > 0)
			{
				m_fCanJumpTimeRemaining -= Time.fixedDeltaTime;
			}
		}
		
		private void ProcessGravityModification()
		{
			float fGravityScale = m_fInitialGravityScale;
			
			if(m_bStill)
			{
				fGravityScale = 0.0f;
			}
			else
			{
				if(characterInput.JumpHeld && rigidbodyComponent.velocity.y > 0.0f)
				{
					fGravityScale *= jumpGravityScale;
				}
				
				if(characterInput.Run)
				{
					fGravityScale *= runGravityScale;
				}
			}
			
			rigidbodyComponent.gravityScale = fGravityScale;
		}
	}
}
