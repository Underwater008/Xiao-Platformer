using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_GroundedTester")]
	public class Character_GroundedTester : MonoBehaviour 
	{
		public string groundLayerName = "";
		public int groundLayerIndex = 8;
		
		public List<Transform> groundedTesters;
		
		private bool m_bGrounded;
		
		public bool IsGrounded
		{
			get
			{
				return m_bGrounded;
			}
		}
		
		private int GroundLayer
		{
			get
			{
				if(groundLayerName == "")
				{
					return groundLayerIndex;
				}
				else
				{
					return LayerMask.NameToLayer(groundLayerName);
				}
			}
		}
		
		private void FixedUpdate()
		{
			GroundedTest();
		}
		
		private void GroundedTest()
		{
			m_bGrounded = false;
			
			int iGroundLayer = GroundLayer;
			
			Vector2 f2Position = transform.position;
			foreach(Transform rGroundTester in groundedTesters)
			{
				Vector2 f2GroundTesterPosition = rGroundTester.position;
				Vector2 f2StartLinecast = f2Position;
				f2StartLinecast.x = f2GroundTesterPosition.x;
				if(Physics2D.Linecast(f2StartLinecast, f2GroundTesterPosition, 1 << iGroundLayer))
				{
					m_bGrounded = true;
				}
			}
		}
	}
}
