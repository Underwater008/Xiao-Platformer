using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Mesh/SetOrderInLayer")]
	[ExecuteInEditMode()]
	public class SetOrderInLayer : MonoBehaviour 
	{	
		public int orderInLayer;
		
		private void Update()
		{
			if(GetComponent<Renderer>() != null)
			{
				GetComponent<Renderer>().sortingOrder = orderInLayer;
			}	
		}
	}
}