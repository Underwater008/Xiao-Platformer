using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Ladder/Character/Character_LadderTesterListener")]
	public class Character_LadderTesterListener : MonoBehaviour 
	{	
		public Character_LadderTester ladderTester;
		
		private void OnTriggerEnter2D(Collider2D a_rCollider)
		{
			Object_Ladder_Collider rLadderCollider = a_rCollider.GetComponent<Object_Ladder_Collider>();
			if(rLadderCollider != null)
			{
				ladderTester.OnLadderColliderEnter(rLadderCollider);
			}
		}
		
		private void OnTriggerExit2D(Collider2D a_rCollider)
		{
			Object_Ladder_Collider rLadderCollider = a_rCollider.GetComponent<Object_Ladder_Collider>();
			if(rLadderCollider != null)
			{
				ladderTester.OnLadderColliderExit(rLadderCollider);
			}
		}
	}
}
