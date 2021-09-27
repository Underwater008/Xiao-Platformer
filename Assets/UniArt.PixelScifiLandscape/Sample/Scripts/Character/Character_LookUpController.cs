using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_LookUpController")]
	public class Character_LookUpController : MonoBehaviour 
	{
		public Character_Input characterInput;
		
		public Character_GroundedTester groundedTester;
		
		public Character_AnimationController animationController;
		
		public string lookUpAnimationStateName = "look.up";
		
		public float lookUpOffset = 0.5f;
		
		public Character_LookController lookController;
		
		private bool m_bLookingUp;
		
		private void Update()
		{	
			m_bLookingUp = characterInput.Vertical > 0.0f && characterInput.Horizontal == 0.0f && groundedTester.IsGrounded;
			
			if(m_bLookingUp)
			{
				lookController.LookOffset = lookUpOffset;
			}
		}
		
		private void LateUpdate()
		{
			if(m_bLookingUp)
			{
				animationController.OverrideThisFrame();
				animationController.animator.speed = 1.0f;
				animationController.animator.Play(lookUpAnimationStateName);
			}
		}
	}
}
