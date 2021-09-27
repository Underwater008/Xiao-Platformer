using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Ladder/Character/Character_LadderTester")]
	public class Character_LadderTester : MonoBehaviour 
	{	
		private List<Object_Ladder> m_oLadders = new List<Object_Ladder>();
		
		public Object_Ladder GetNearestLadder(Vector2 a_f2Position)
		{
			Object_Ladder rNearestLadder  = null;
			
			float fDistanceMin = float.PositiveInfinity;
			foreach(Object_Ladder rLadder in m_oLadders)
			{
				float fDistance = rLadder.DistanceToLadder(a_f2Position);
				if(fDistance < fDistanceMin)
				{
					fDistanceMin = fDistance;
					rNearestLadder = rLadder;
				}
			}
			
			return rNearestLadder;
		}
		
		public void OnLadderColliderEnter(Object_Ladder_Collider a_rLadderCollider)
		{
			Object_Ladder rLadder = a_rLadderCollider.ladder;
			if(m_oLadders.Contains(rLadder) == false)
			{
				m_oLadders.Add(rLadder);
			}
		}
		
		public void OnLadderColliderExit(Object_Ladder_Collider a_rLadderCollider)
		{
			Object_Ladder rLadder = a_rLadderCollider.ladder;
			m_oLadders.Remove(rLadder);
		}
	}
}
