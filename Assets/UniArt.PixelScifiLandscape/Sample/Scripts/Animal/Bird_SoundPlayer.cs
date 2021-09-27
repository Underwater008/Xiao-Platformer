using UnityEngine;
using System.Collections;

namespace UniArt.PixelScifiLandscape.Sample
{
	[AddComponentMenu("UniArt/PixelScifiLandscape/Sample/Animal/Bird_SoundPlayer")]
	public class Bird_SoundPlayer : MonoBehaviour 
	{	
		[System.Serializable]
		public class Sound
		{
			public AudioClip clip;
			public float volume = 1.0f;
		}
		
		public Bird bird;
		
		public AudioSource audioSource;
		
		public Sound fly;
		
		public void FlySound()
		{
			PlaySound(fly);
		}
		
		private void Awake()
		{
			if(bird != null)
			{
				bird.onStartFlying += OnStartFlying;
			}
		}
		
		private void OnDestroy()
		{
			if(bird != null)
			{
				bird.onStartFlying -= OnStartFlying;
			}
		}
		
		private void PlaySound(Sound a_rSound)
		{
			audioSource.PlayOneShot(a_rSound.clip, a_rSound.volume);
		}
		
		private void OnStartFlying()
		{
			FlySound();
		}
	}
}