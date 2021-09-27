using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_CrouchController")]
	public class Character_CrouchController : MonoBehaviour 
	{
		public Character_Input characterInput;
		
		public Character_GroundedTester groundedTester;
		
		public Character_AnimationController animationController;
		
		public string crouchAnimationStateName = "crouch";
		
		public float lookdownOffset = 0.5f;
		
		public Character_LookController lookController;
		
		private bool m_bCrouch;
		
		private void Update()
		{	
			m_bCrouch = characterInput.Vertical < 0.0f && groundedTester.IsGrounded;
			
			if(m_bCrouch)
			{
				lookController.LookOffset = -lookdownOffset;
			}
		}
		
		private void LateUpdate()
		{
			if(m_bCrouch)
			{
				animationController.OverrideThisFrame();
				animationController.animator.speed = 1.0f;
				animationController.animator.Play(crouchAnimationStateName);
			}
		}
	}
}