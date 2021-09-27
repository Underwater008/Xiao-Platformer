using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Ladder/Character/Character_LadderClimbAnimation")]
	public class Character_LadderClimbAnimation : MonoBehaviour 
	{
		public Animator animator;
		
		public Character_AnimationController characterAnimationController;
		
		public Character_LadderClimber ladderClimber;
		
		public float distanceByClimbLoop = 1.0f;
		
		private void Awake()
		{
			ladderClimber.onStartClimb += OnStartClimb;
			ladderClimber.onStopClimb += OnStopClimb;
			ladderClimber.onClimb += OnClimb;
		}
		
		private void OnDestroy()
		{
			if(ladderClimber != null)
			{
				ladderClimber.onStartClimb -= OnStartClimb;
				ladderClimber.onStopClimb -= OnStopClimb;
				ladderClimber.onClimb -= OnClimb;
			}
		}
		
		private void OnStartClimb()
		{
			characterAnimationController.enabled = false;
		}
		
		private void OnStopClimb()
		{
			characterAnimationController.enabled = true;
		}
		
		private void OnClimb(float a_fClimb)
		{
			animator.speed = 0.0f;
			
			AnimatorStateInfo rAnimationStateInfo = animator.GetCurrentAnimatorStateInfo(0);
			float fNormalizedTime = rAnimationStateInfo.normalizedTime;
			if(distanceByClimbLoop != 0.0f)
			{
				fNormalizedTime += a_fClimb/distanceByClimbLoop;
				fNormalizedTime = Mathf.Repeat(fNormalizedTime, 1.0f);
			}
			
			animator.Play("climb", 0, fNormalizedTime);
		}
	}
}
