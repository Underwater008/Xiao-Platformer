using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Character/Character_Input")]
	public class Character_Input : MonoBehaviour 
	{	
		private bool m_bJumpWasPressed;
		
		private bool m_bJump;
		
		private bool m_bRun;
		
		public bool Run
		{
			get
			{
				return m_bRun;
			}
		}
		
		public bool Jump
		{
			get
			{
				return m_bJump;
			}
		}
		
		public bool JumpHeld
		{
			get
			{
				return m_bJumpWasPressed;
			}
		}
		
		public float Horizontal
		{
			get
			{
				float fValue = 0.0f;
				if(Input.GetKey(KeyCode.LeftArrow) || Input.GetKey(KeyCode.Q) || Input.GetKey(KeyCode.A))
				{
					fValue -= 1.0f;
				}
				
				if(Input.GetKey(KeyCode.RightArrow) || Input.GetKey(KeyCode.D))
				{
					fValue += 1.0f;
				}
				
				return fValue;
			}
		}
		
		public float Vertical
		{
			get
			{
				float fValue = 0.0f;
				if(Input.GetKey(KeyCode.DownArrow) || Input.GetKey(KeyCode.S))
				{
					fValue -= 1.0f;
				}
				
				if(Input.GetKey(KeyCode.UpArrow) || Input.GetKey(KeyCode.Z) || Input.GetKey(KeyCode.W))
				{
					fValue += 1.0f;
				}
				
				return fValue;
			}
		}
		
		public bool JumpInput
		{
			get
			{
				return Input.GetKey(KeyCode.Space) || Input.GetKey(KeyCode.LeftAlt) || Input.GetKey(KeyCode.RightAlt);
			}
		}
		
		public bool RunInput
		{
			get
			{
				return Input.GetKey(KeyCode.LeftControl) || Input.GetKey(KeyCode.RightControl) || Input.GetKey(KeyCode.LeftCommand) || Input.GetKey(KeyCode.RightCommand) || Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift);
			}
		}
		
		private void FixedUpdate()
		{
			UpdateRunInput();
			UpdateJumpInput();
		}
		
		private void UpdateJumpInput()
		{
			bool bJumpPressed = JumpInput;
			bool bJumpJustPressed = m_bJumpWasPressed == false && bJumpPressed;
			m_bJumpWasPressed = bJumpPressed;
			
			m_bJump = bJumpJustPressed;
		}
		
		private void UpdateRunInput()
		{
			m_bRun = RunInput;
		}
	}
}
