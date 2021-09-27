using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_FlipController")]
	public class Character_FlipController : MonoBehaviour 
	{
		public Transform flipTransform;
		
		public Character_Input characterInput;
		
		private void LateUpdate()
		{
			Vector3 f3LocalScale = flipTransform.localScale;
			
			float fHorizontal = characterInput.Horizontal;
			
			if(fHorizontal > 0.0f)
			{
				f3LocalScale.x = 1.0f;
			}
			else if(fHorizontal < 0.0f)
			{
				f3LocalScale.x = -1.0f;
			}
		
			flipTransform.localScale = f3LocalScale;
		}
	}
}
