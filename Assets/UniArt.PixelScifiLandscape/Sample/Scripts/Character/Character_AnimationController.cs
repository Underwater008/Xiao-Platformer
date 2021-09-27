using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_AnimationController")]
	public class Character_AnimationController : MonoBehaviour 
	{
		public Animator animator;
		
		public Character_MovementController movementController;
		
		public Character_Input characterInput;
		
		public Character_GroundedTester groundedTester;
		
		public float minVelocityWalk = 0.01f;
		
		public float walkNormalSpeedVelocity = 1.0f;
		
		public float runNormalSpeedVelocity = 4.0f;
		
		public string standAnimationStateName = "stand";
		public string walkAnimationStateName = "walk";
		public string runAnimationStateName = "run";
		public string jumpDownAnimationStateName = "jump.down";
		public string jumpUpAnimationStateName = "jump.up";
		
		private bool m_bOverrideThisFrame;
		
		public void OverrideThisFrame()
		{
			m_bOverrideThisFrame = true;
		}
		
		private void LateUpdate()
		{
			if(m_bOverrideThisFrame)
			{
				m_bOverrideThisFrame = false;
				return;
			}
			
			animator.speed = 1.0f;
			string oAnimationName;
			if(groundedTester.IsGrounded)
			{
				float fHorizontalVelocity = Mathf.Abs(movementController.Velocity.x);
				if(fHorizontalVelocity <= minVelocityWalk)
				{
					oAnimationName = standAnimationStateName;
				}
				else
				{
					float fNormalSpeedVelocity;
					if(characterInput.Run)
					{
						oAnimationName = runAnimationStateName;
						fNormalSpeedVelocity = runNormalSpeedVelocity;
					}
					else
					{
						oAnimationName = walkAnimationStateName;
						fNormalSpeedVelocity = walkNormalSpeedVelocity;
					}
					AdaptAnimationSpeedToMatchVelocity(fNormalSpeedVelocity, fHorizontalVelocity);
				}
			}
			else
			{
				if(movementController.Velocity.y > 0)
				{
					oAnimationName = jumpUpAnimationStateName;
				}
				else
				{
					oAnimationName = jumpDownAnimationStateName;
				}
			}
			
			animator.Play(oAnimationName);
		}
		
		private void AdaptAnimationSpeedToMatchVelocity(float a_fNormalSpeedVelocity, float a_fCurrentSpeed)
		{
			float fAnimationSpeedPercent = a_fCurrentSpeed/a_fNormalSpeedVelocity;
			animator.speed = fAnimationSpeedPercent;
		}
	}
}
