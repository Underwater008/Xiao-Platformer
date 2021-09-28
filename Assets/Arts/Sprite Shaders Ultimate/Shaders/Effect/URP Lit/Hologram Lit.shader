// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprite Shaders Ultimate/URP Lit/Effect/Hologram Lit"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_MaskMap("Mask Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 3)) = 1
		[KeywordEnum(Linear_Default,Linear_Scaled,Linear_FPS,Frequency,Frequency_FPS,Custom_Value)] _TimeSettings("Time Settings", Float) = 0
		_TimeScale("Time Scale", Float) = 1
		_TimeFrequency("Time Frequency", Float) = 2
		_TimeRange("Time Range", Float) = 0.5
		_TimeFPS("Time FPS", Float) = 5
		_TimeValue("Time Value", Float) = 0
		_HologramFade("Hologram: Fade", Range( 0 , 1)) = 1
		[HDR]_HologramTint("Hologram: Tint", Color) = (0.3137255,1.662745,2.996078,1)
		_HologramContrast("Hologram: Contrast", Float) = 1
		_HologramLineFrequency("Hologram: Line Frequency", Float) = 500
		_HologramLineGap("Hologram: Line Gap", Range( 0 , 5)) = 3
		_HologramLineSpeed("Hologram: Line Speed", Float) = 0.01
		_HologramMinAlpha("Hologram: Min Alpha", Range( 0 , 1)) = 0.2
		_HologramDistortionOffset("Hologram: Distortion Offset", Float) = 0.5
		_HologramDistortionSpeed("Hologram: Distortion Speed", Float) = 2
		_HologramDistortionDensity("Hologram: Distortion Density", Float) = 0.5
		_HologramDistortionScale("Hologram: Distortion Scale", Float) = 10
		[ASEEnd]_HologramNoiseTexture("Hologram: Noise Texture", 2D) = "white" {}

	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" "PreviewType"="Plane" }

		Cull Off
		HLSLINCLUDE
		#pragma target 2.0
		ENDHLSL

		
		Pass
		{
			Name "Sprite Lit"
			Tags { "LightMode"="Universal2D" }
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_0
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_1
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_2
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_3

			#define _SURFACE_TYPE_TRANSPARENT 1
			#define SHADERPASS_SPRITELIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/LightingUtility.hlsl"
			
			#if USE_SHAPE_LIGHT_TYPE_0
			SHAPE_LIGHT(0)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_1
			SHAPE_LIGHT(1)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_2
			SHAPE_LIGHT(2)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_3
			SHAPE_LIGHT(3)
			#endif

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/CombinedShapeLightShared.hlsl"

			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _HologramNoiseTexture;
			sampler2D _MaskMap;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _HologramTint;
			float4 _MainTex_TexelSize;
			float _TimeScale;
			float _HologramLineGap;
			float _HologramLineFrequency;
			float _HologramLineSpeed;
			float _HologramContrast;
			float _HologramFade;
			float _HologramDistortionOffset;
			float _HologramDistortionScale;
			float _HologramDistortionDensity;
			float _HologramDistortionSpeed;
			float _TimeValue;
			float _TimeRange;
			float _TimeFrequency;
			float _TimeFPS;
			float _HologramMinAlpha;
			float _NormalIntensity;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float4 screenPosition : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			
			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord3.xyz = ase_worldPos;
				
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.clipPos = vertexInput.positionCS;
				o.screenPosition = ComputeScreenPos( o.clipPos, _ProjectionParams.x );
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float mulTime5_g430 = _TimeParameters.x * _TimeScale;
				float mulTime7_g430 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g430 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g430 = mulTime5_g430;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g430 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g430 = ( ( sin( mulTime7_g430 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g430 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g430 = _TimeValue;
				#else
				float staticSwitch1_g430 = _TimeParameters.x;
				#endif
				float temp_output_96_0 = staticSwitch1_g430;
				float3 ase_worldPos = IN.ase_texcoord3.xyz;
				float temp_output_8_0_g338 = ( ( ( temp_output_96_0 * _HologramDistortionSpeed ) + ase_worldPos.y ) / unity_OrthoParams.y );
				float2 temp_cast_0 = (temp_output_8_0_g338).xx;
				float2 temp_cast_1 = (_HologramDistortionDensity).xx;
				float clampResult75_g338 = clamp( tex2D( _HologramNoiseTexture, ( temp_cast_0 * temp_cast_1 ) ).r , 0.075 , 0.6 );
				float2 temp_cast_2 = (temp_output_8_0_g338).xx;
				float2 temp_cast_3 = (_HologramDistortionScale).xx;
				float2 appendResult2_g339 = (float2(_MainTex_TexelSize.z , _MainTex_TexelSize.w));
				float2 appendResult44_g338 = (float2(( ( ( clampResult75_g338 * ( tex2D( _HologramNoiseTexture, ( temp_cast_2 * temp_cast_3 ) ).r - 0.25 ) ) * _HologramDistortionOffset * ( 100.0 / appendResult2_g339 ).x ) * _HologramFade ) , 0.0));
				float4 temp_output_1_0_g342 = tex2D( _MainTex, ( IN.texCoord0.xy + appendResult44_g338 ) );
				float4 break2_g343 = temp_output_1_0_g342;
				float temp_output_9_0_g344 = max( _HologramContrast , 0.0 );
				float saferPower7_g344 = max( ( ( ( break2_g343.x + break2_g343.y + break2_g343.z ) / 3.0 ) + ( 0.1 * max( ( 1.0 - temp_output_9_0_g344 ) , 0.0 ) ) ) , 0.0001 );
				float4 appendResult22_g342 = (float4(( (_HologramTint).rgb * pow( saferPower7_g344 , temp_output_9_0_g344 ) ) , ( max( pow( abs( sin( ( ( ( ( temp_output_96_0 * _HologramLineSpeed ) + ase_worldPos.y ) / unity_OrthoParams.y ) * _HologramLineFrequency ) ) ) , _HologramLineGap ) , _HologramMinAlpha ) * temp_output_1_0_g342.a )));
				float4 lerpResult37_g342 = lerp( temp_output_1_0_g342 , appendResult22_g342 , _HologramFade);
				
				float2 temp_output_8_0_g337 = IN.texCoord0.xy;
				
				float3 unpack14_g337 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g337 ), _NormalIntensity );
				unpack14_g337.z = lerp( 1, unpack14_g337.z, saturate(_NormalIntensity) );
				
				float4 Color = ( lerpResult37_g342 * IN.ase_color );
				float Mask = tex2D( _MaskMap, temp_output_8_0_g337 ).r;
				float3 Normal = unpack14_g337;

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.texCoord0.xy);
					Color.a = lerp ( Color.a, alpha.r, _EnableAlphaTexture);
				#endif
				
				Color *= IN.color;

				return CombinedShapeLightShared( Color, Mask, IN.screenPosition.xy / IN.screenPosition.w );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Sprite Normal"
			Tags { "LightMode"="NormalsRendering" }
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define _SURFACE_TYPE_TRANSPARENT 1
			#define SHADERPASS_SPRITENORMAL

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/NormalsRenderingShared.hlsl"
			
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _HologramNoiseTexture;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _HologramTint;
			float4 _MainTex_TexelSize;
			float _TimeScale;
			float _HologramLineGap;
			float _HologramLineFrequency;
			float _HologramLineSpeed;
			float _HologramContrast;
			float _HologramFade;
			float _HologramDistortionOffset;
			float _HologramDistortionScale;
			float _HologramDistortionDensity;
			float _HologramDistortionSpeed;
			float _TimeValue;
			float _TimeRange;
			float _TimeFrequency;
			float _TimeFPS;
			float _HologramMinAlpha;
			float _NormalIntensity;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 normalWS : TEXCOORD2;
				float4 tangentWS : TEXCOORD3;
				float3 bitangentWS : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord5.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.clipPos = vertexInput.positionCS;

				float3 normalWS = TransformObjectToWorldNormal( v.normal );
				o.normalWS = NormalizeNormalPerVertex( normalWS );
				float4 tangentWS = float4( TransformObjectToWorldDir( v.tangent.xyz ), v.tangent.w );
				o.tangentWS = normalize( tangentWS );
				o.bitangentWS = cross( normalWS, tangentWS.xyz ) * tangentWS.w;
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float mulTime5_g430 = _TimeParameters.x * _TimeScale;
				float mulTime7_g430 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g430 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g430 = mulTime5_g430;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g430 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g430 = ( ( sin( mulTime7_g430 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g430 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g430 = _TimeValue;
				#else
				float staticSwitch1_g430 = _TimeParameters.x;
				#endif
				float temp_output_96_0 = staticSwitch1_g430;
				float3 ase_worldPos = IN.ase_texcoord5.xyz;
				float temp_output_8_0_g338 = ( ( ( temp_output_96_0 * _HologramDistortionSpeed ) + ase_worldPos.y ) / unity_OrthoParams.y );
				float2 temp_cast_0 = (temp_output_8_0_g338).xx;
				float2 temp_cast_1 = (_HologramDistortionDensity).xx;
				float clampResult75_g338 = clamp( tex2D( _HologramNoiseTexture, ( temp_cast_0 * temp_cast_1 ) ).r , 0.075 , 0.6 );
				float2 temp_cast_2 = (temp_output_8_0_g338).xx;
				float2 temp_cast_3 = (_HologramDistortionScale).xx;
				float2 appendResult2_g339 = (float2(_MainTex_TexelSize.z , _MainTex_TexelSize.w));
				float2 appendResult44_g338 = (float2(( ( ( clampResult75_g338 * ( tex2D( _HologramNoiseTexture, ( temp_cast_2 * temp_cast_3 ) ).r - 0.25 ) ) * _HologramDistortionOffset * ( 100.0 / appendResult2_g339 ).x ) * _HologramFade ) , 0.0));
				float4 temp_output_1_0_g342 = tex2D( _MainTex, ( IN.texCoord0.xy + appendResult44_g338 ) );
				float4 break2_g343 = temp_output_1_0_g342;
				float temp_output_9_0_g344 = max( _HologramContrast , 0.0 );
				float saferPower7_g344 = max( ( ( ( break2_g343.x + break2_g343.y + break2_g343.z ) / 3.0 ) + ( 0.1 * max( ( 1.0 - temp_output_9_0_g344 ) , 0.0 ) ) ) , 0.0001 );
				float4 appendResult22_g342 = (float4(( (_HologramTint).rgb * pow( saferPower7_g344 , temp_output_9_0_g344 ) ) , ( max( pow( abs( sin( ( ( ( ( temp_output_96_0 * _HologramLineSpeed ) + ase_worldPos.y ) / unity_OrthoParams.y ) * _HologramLineFrequency ) ) ) , _HologramLineGap ) , _HologramMinAlpha ) * temp_output_1_0_g342.a )));
				float4 lerpResult37_g342 = lerp( temp_output_1_0_g342 , appendResult22_g342 , _HologramFade);
				
				float2 temp_output_8_0_g337 = IN.texCoord0.xy;
				float3 unpack14_g337 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g337 ), _NormalIntensity );
				unpack14_g337.z = lerp( 1, unpack14_g337.z, saturate(_NormalIntensity) );
				
				float4 Color = ( lerpResult37_g342 * IN.color );
				float3 Normal = unpack14_g337;
				
				Color *= IN.color;

				return NormalsRenderingShared( Color, Normal, IN.tangentWS.xyz, IN.bitangentWS, IN.normalWS);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Sprite Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA

			#define _SURFACE_TYPE_TRANSPARENT 1
			#define SHADERPASS_SPRITEFORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _HologramNoiseTexture;
			CBUFFER_START( UnityPerMaterial )
			float4 _HologramTint;
			float4 _MainTex_TexelSize;
			float _TimeScale;
			float _HologramLineGap;
			float _HologramLineFrequency;
			float _HologramLineSpeed;
			float _HologramContrast;
			float _HologramFade;
			float _HologramDistortionOffset;
			float _HologramDistortionScale;
			float _HologramDistortionDensity;
			float _HologramDistortionSpeed;
			float _TimeValue;
			float _TimeRange;
			float _TimeFrequency;
			float _TimeFPS;
			float _HologramMinAlpha;
			float _NormalIntensity;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord2.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.normal = v.normal;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.vertex.xyz );

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.clipPos = vertexInput.positionCS;

				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float mulTime5_g430 = _TimeParameters.x * _TimeScale;
				float mulTime7_g430 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g430 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g430 = mulTime5_g430;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g430 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g430 = ( ( sin( mulTime7_g430 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g430 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g430 = _TimeValue;
				#else
				float staticSwitch1_g430 = _TimeParameters.x;
				#endif
				float temp_output_96_0 = staticSwitch1_g430;
				float3 ase_worldPos = IN.ase_texcoord2.xyz;
				float temp_output_8_0_g338 = ( ( ( temp_output_96_0 * _HologramDistortionSpeed ) + ase_worldPos.y ) / unity_OrthoParams.y );
				float2 temp_cast_0 = (temp_output_8_0_g338).xx;
				float2 temp_cast_1 = (_HologramDistortionDensity).xx;
				float clampResult75_g338 = clamp( tex2D( _HologramNoiseTexture, ( temp_cast_0 * temp_cast_1 ) ).r , 0.075 , 0.6 );
				float2 temp_cast_2 = (temp_output_8_0_g338).xx;
				float2 temp_cast_3 = (_HologramDistortionScale).xx;
				float2 appendResult2_g339 = (float2(_MainTex_TexelSize.z , _MainTex_TexelSize.w));
				float2 appendResult44_g338 = (float2(( ( ( clampResult75_g338 * ( tex2D( _HologramNoiseTexture, ( temp_cast_2 * temp_cast_3 ) ).r - 0.25 ) ) * _HologramDistortionOffset * ( 100.0 / appendResult2_g339 ).x ) * _HologramFade ) , 0.0));
				float4 temp_output_1_0_g342 = tex2D( _MainTex, ( IN.texCoord0.xy + appendResult44_g338 ) );
				float4 break2_g343 = temp_output_1_0_g342;
				float temp_output_9_0_g344 = max( _HologramContrast , 0.0 );
				float saferPower7_g344 = max( ( ( ( break2_g343.x + break2_g343.y + break2_g343.z ) / 3.0 ) + ( 0.1 * max( ( 1.0 - temp_output_9_0_g344 ) , 0.0 ) ) ) , 0.0001 );
				float4 appendResult22_g342 = (float4(( (_HologramTint).rgb * pow( saferPower7_g344 , temp_output_9_0_g344 ) ) , ( max( pow( abs( sin( ( ( ( ( temp_output_96_0 * _HologramLineSpeed ) + ase_worldPos.y ) / unity_OrthoParams.y ) * _HologramLineFrequency ) ) ) , _HologramLineGap ) , _HologramMinAlpha ) * temp_output_1_0_g342.a )));
				float4 lerpResult37_g342 = lerp( temp_output_1_0_g342 , appendResult22_g342 , _HologramFade);
				
				float4 Color = ( lerpResult37_g342 * IN.color );

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D( _AlphaTex, sampler_AlphaTex, IN.texCoord0.xy );
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture );
				#endif

				Color *= IN.color;

				return Color;
			}

			ENDHLSL
		}
		
	}
	CustomEditor "SpriteShadersUltimate.SingleShaderGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18900
0;0;1920;1019;2013.546;649.7104;1.232788;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;88;-1523,-13.52876;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;90;-1419.446,-516.6273;Inherit;False;Property;_HologramFade;Hologram: Fade;12;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;89;-1466.461,-287.8126;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;96;-1346.607,-429.0414;Inherit;False;ShaderTime;5;;430;06a15e67904f217499045f361bad56e7;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;94;-1145.167,-20.02304;Inherit;False;_HologramUV;20;;338;7c71b1b031ffcbe48805e17b94671163;0;5;77;FLOAT;0;False;55;FLOAT;0;False;76;SAMPLER2D;;False;37;FLOAT2;0,0;False;39;SAMPLER2D;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;92;-852.9034,-143.6842;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;95;-469.3445,-158.609;Inherit;False;_Hologram;13;;342;76082a965d84d0e4da33b2cff51b3691;0;3;42;FLOAT;0;False;40;FLOAT;0;False;1;COLOR;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;22;-63.6362,70.99575;Inherit;False;TintVertex;-1;;336;b0b94dd27c0f3da49a89feecae766dcc;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;86;-68.50143,156.8532;Inherit;False;LitHandler;1;;337;851662d67a92ce04d84817ff63c501f2;0;1;8;FLOAT2;0,0;False;2;COLOR;0;FLOAT3;5
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;83;211.4418,70.685;Float;False;True;-1;2;SpriteShadersUltimate.SingleShaderGUI;0;12;Sprite Shaders Ultimate/URP Lit/Effect/Hologram Lit;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;1;Vertex Position;1;0;3;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;84;211.4418,70.685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=NormalsRendering;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;85;211.4418,70.685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;94;77;96;0
WireConnection;94;55;90;0
WireConnection;94;37;88;0
WireConnection;94;39;89;0
WireConnection;92;0;89;0
WireConnection;92;1;94;0
WireConnection;95;42;96;0
WireConnection;95;40;90;0
WireConnection;95;1;92;0
WireConnection;22;1;95;0
WireConnection;83;1;22;0
WireConnection;83;2;86;0
WireConnection;83;3;86;5
ASEEND*/
//CHKSM=2E2CD9CD7047F1008873A0F897E3DE4FB39F8817