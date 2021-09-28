// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprite Shaders Ultimate/URP Lit/Color/Outer Outline Lit"
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
		_OuterOutlineFade("Outer Outline: Fade", Range( 0 , 1)) = 1
		[HDR]_OuterOutlineColor("Outer Outline: Color", Color) = (0,0,0,1)
		_OuterOutlineWidth("Outer Outline: Width", Float) = 0.04
		[Toggle(_OUTEROUTLINEDISTORTIONTOGGLE_ON)] _OuterOutlineDistortionToggle("Outer Outline: Distortion Toggle", Float) = 0
		_OuterOutlineDistortionIntensity("Outer Outline: Distortion Intensity", Vector) = (0.01,0.01,0,0)
		_OuterOutlineNoiseScale("Outer Outline: Noise Scale", Vector) = (4,4,0,0)
		_OuterOutlineNoiseSpeed("Outer Outline: Noise Speed", Vector) = (0,0.1,0,0)
		[ASEEnd]_OuterOutlineNoiseTexture("Outer Outline: Noise Texture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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

			#pragma shader_feature_local _OUTEROUTLINEDISTORTIONTOGGLE_ON
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _OuterOutlineNoiseTexture;
			sampler2D _MaskMap;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _OuterOutlineColor;
			float4 _MainTex_TexelSize;
			float2 _OuterOutlineNoiseSpeed;
			float2 _OuterOutlineNoiseScale;
			float2 _OuterOutlineDistortionIntensity;
			float _OuterOutlineFade;
			float _TimeScale;
			float _TimeFPS;
			float _TimeFrequency;
			float _TimeRange;
			float _TimeValue;
			float _OuterOutlineWidth;
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

				o.ase_color = v.color;
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

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_output_15_0_g36 = tex2D( _MainTex, uv_MainTex );
				float3 temp_output_82_0_g36 = (_OuterOutlineColor).rgb;
				float temp_output_182_0_g36 = ( ( 1.0 - temp_output_15_0_g36.a ) * min( ( _OuterOutlineFade * 3.0 ) , 1.0 ) );
				float3 lerpResult178_g36 = lerp( (temp_output_15_0_g36).rgb , temp_output_82_0_g36 , temp_output_182_0_g36);
				float3 lerpResult170_g36 = lerp( lerpResult178_g36 , temp_output_82_0_g36 , temp_output_182_0_g36);
				float mulTime5_g39 = _TimeParameters.x * _TimeScale;
				float mulTime7_g39 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g39 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g39 = mulTime5_g39;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g39 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g39 = ( ( sin( mulTime7_g39 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g39 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g39 = _TimeValue;
				#else
				float staticSwitch1_g39 = _TimeParameters.x;
				#endif
				float2 temp_output_7_0_g36 = IN.texCoord0.xy;
				#ifdef _OUTEROUTLINEDISTORTIONTOGGLE_ON
				float2 staticSwitch157_g36 = ( ( tex2D( _OuterOutlineNoiseTexture, ( ( ( staticSwitch1_g39 * _OuterOutlineNoiseSpeed ) + temp_output_7_0_g36 ) * _OuterOutlineNoiseScale ) ).r - 0.5 ) * _OuterOutlineDistortionIntensity );
				#else
				float2 staticSwitch157_g36 = float2( 0,0 );
				#endif
				float2 temp_output_131_0_g36 = ( staticSwitch157_g36 + temp_output_7_0_g36 );
				float2 appendResult2_g38 = (float2(_MainTex_TexelSize.z , _MainTex_TexelSize.w));
				float2 temp_output_25_0_g36 = ( 100.0 / appendResult2_g38 );
				float lerpResult168_g36 = lerp( temp_output_15_0_g36.a , min( ( max( max( max( max( max( max( max( tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0,-1 ) ) * temp_output_25_0_g36 ) ) ).a , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0,1 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -1,0 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 1,0 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0.705,0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -0.705,0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0.705,-0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -0.705,-0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) * 3.0 ) , 1.0 ) , _OuterOutlineFade);
				float4 appendResult174_g36 = (float4(lerpResult170_g36 , lerpResult168_g36));
				
				float2 temp_output_8_0_g31 = IN.texCoord0.xy;
				
				float3 unpack14_g31 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g31 ), _NormalIntensity );
				unpack14_g31.z = lerp( 1, unpack14_g31.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult174_g36 * IN.ase_color );
				float Mask = tex2D( _MaskMap, temp_output_8_0_g31 ).r;
				float3 Normal = unpack14_g31;

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
			#pragma shader_feature_local _OUTEROUTLINEDISTORTIONTOGGLE_ON
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _OuterOutlineNoiseTexture;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _OuterOutlineColor;
			float4 _MainTex_TexelSize;
			float2 _OuterOutlineNoiseSpeed;
			float2 _OuterOutlineNoiseScale;
			float2 _OuterOutlineDistortionIntensity;
			float _OuterOutlineFade;
			float _TimeScale;
			float _TimeFPS;
			float _TimeFrequency;
			float _TimeRange;
			float _TimeValue;
			float _OuterOutlineWidth;
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
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

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_output_15_0_g36 = tex2D( _MainTex, uv_MainTex );
				float3 temp_output_82_0_g36 = (_OuterOutlineColor).rgb;
				float temp_output_182_0_g36 = ( ( 1.0 - temp_output_15_0_g36.a ) * min( ( _OuterOutlineFade * 3.0 ) , 1.0 ) );
				float3 lerpResult178_g36 = lerp( (temp_output_15_0_g36).rgb , temp_output_82_0_g36 , temp_output_182_0_g36);
				float3 lerpResult170_g36 = lerp( lerpResult178_g36 , temp_output_82_0_g36 , temp_output_182_0_g36);
				float mulTime5_g39 = _TimeParameters.x * _TimeScale;
				float mulTime7_g39 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g39 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g39 = mulTime5_g39;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g39 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g39 = ( ( sin( mulTime7_g39 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g39 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g39 = _TimeValue;
				#else
				float staticSwitch1_g39 = _TimeParameters.x;
				#endif
				float2 temp_output_7_0_g36 = IN.texCoord0.xy;
				#ifdef _OUTEROUTLINEDISTORTIONTOGGLE_ON
				float2 staticSwitch157_g36 = ( ( tex2D( _OuterOutlineNoiseTexture, ( ( ( staticSwitch1_g39 * _OuterOutlineNoiseSpeed ) + temp_output_7_0_g36 ) * _OuterOutlineNoiseScale ) ).r - 0.5 ) * _OuterOutlineDistortionIntensity );
				#else
				float2 staticSwitch157_g36 = float2( 0,0 );
				#endif
				float2 temp_output_131_0_g36 = ( staticSwitch157_g36 + temp_output_7_0_g36 );
				float2 appendResult2_g38 = (float2(_MainTex_TexelSize.z , _MainTex_TexelSize.w));
				float2 temp_output_25_0_g36 = ( 100.0 / appendResult2_g38 );
				float lerpResult168_g36 = lerp( temp_output_15_0_g36.a , min( ( max( max( max( max( max( max( max( tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0,-1 ) ) * temp_output_25_0_g36 ) ) ).a , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0,1 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -1,0 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 1,0 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0.705,0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -0.705,0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0.705,-0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -0.705,-0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) * 3.0 ) , 1.0 ) , _OuterOutlineFade);
				float4 appendResult174_g36 = (float4(lerpResult170_g36 , lerpResult168_g36));
				
				float2 temp_output_8_0_g31 = IN.texCoord0.xy;
				float3 unpack14_g31 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g31 ), _NormalIntensity );
				unpack14_g31.z = lerp( 1, unpack14_g31.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult174_g36 * IN.color );
				float3 Normal = unpack14_g31;
				
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
			#pragma shader_feature_local _OUTEROUTLINEDISTORTIONTOGGLE_ON
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _OuterOutlineNoiseTexture;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _OuterOutlineColor;
			float4 _MainTex_TexelSize;
			float2 _OuterOutlineNoiseSpeed;
			float2 _OuterOutlineNoiseScale;
			float2 _OuterOutlineDistortionIntensity;
			float _OuterOutlineFade;
			float _TimeScale;
			float _TimeFPS;
			float _TimeFrequency;
			float _TimeRange;
			float _TimeValue;
			float _OuterOutlineWidth;
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

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_output_15_0_g36 = tex2D( _MainTex, uv_MainTex );
				float3 temp_output_82_0_g36 = (_OuterOutlineColor).rgb;
				float temp_output_182_0_g36 = ( ( 1.0 - temp_output_15_0_g36.a ) * min( ( _OuterOutlineFade * 3.0 ) , 1.0 ) );
				float3 lerpResult178_g36 = lerp( (temp_output_15_0_g36).rgb , temp_output_82_0_g36 , temp_output_182_0_g36);
				float3 lerpResult170_g36 = lerp( lerpResult178_g36 , temp_output_82_0_g36 , temp_output_182_0_g36);
				float mulTime5_g39 = _TimeParameters.x * _TimeScale;
				float mulTime7_g39 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g39 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g39 = mulTime5_g39;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g39 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g39 = ( ( sin( mulTime7_g39 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g39 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g39 = _TimeValue;
				#else
				float staticSwitch1_g39 = _TimeParameters.x;
				#endif
				float2 temp_output_7_0_g36 = IN.texCoord0.xy;
				#ifdef _OUTEROUTLINEDISTORTIONTOGGLE_ON
				float2 staticSwitch157_g36 = ( ( tex2D( _OuterOutlineNoiseTexture, ( ( ( staticSwitch1_g39 * _OuterOutlineNoiseSpeed ) + temp_output_7_0_g36 ) * _OuterOutlineNoiseScale ) ).r - 0.5 ) * _OuterOutlineDistortionIntensity );
				#else
				float2 staticSwitch157_g36 = float2( 0,0 );
				#endif
				float2 temp_output_131_0_g36 = ( staticSwitch157_g36 + temp_output_7_0_g36 );
				float2 appendResult2_g38 = (float2(_MainTex_TexelSize.z , _MainTex_TexelSize.w));
				float2 temp_output_25_0_g36 = ( 100.0 / appendResult2_g38 );
				float lerpResult168_g36 = lerp( temp_output_15_0_g36.a , min( ( max( max( max( max( max( max( max( tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0,-1 ) ) * temp_output_25_0_g36 ) ) ).a , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0,1 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -1,0 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 1,0 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0.705,0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -0.705,0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( 0.705,-0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) , tex2D( _MainTex, ( temp_output_131_0_g36 + ( ( _OuterOutlineWidth * float2( -0.705,-0.705 ) ) * temp_output_25_0_g36 ) ) ).a ) * 3.0 ) , 1.0 ) , _OuterOutlineFade);
				float4 appendResult174_g36 = (float4(lerpResult170_g36 , lerpResult168_g36));
				
				float4 Color = ( appendResult174_g36 * IN.color );

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
0;0;1920;1019;1555.983;821.6072;1.71665;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;70;-897.3215,-161.1684;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexCoordVertexDataNode;72;-347.0665,-248.9013;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;-408.8556,-503.6472;Inherit;True;Property;_TextureSample3;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;76;-301.1118,-677.409;Inherit;False;ShaderTime;5;;39;06a15e67904f217499045f361bad56e7;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;75;-64.24355,-194.9285;Inherit;False;_OuterOutline;12;;36;c63fd6271f1306b46aa2076a150659b5;0;5;186;FLOAT;0;False;15;COLOR;0,0,0,0;False;161;SAMPLER2D;;False;7;FLOAT2;0,0;False;4;SAMPLER2D;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;66;220.6745,159.7954;Inherit;False;LitHandler;1;;31;851662d67a92ce04d84817ff63c501f2;0;1;8;FLOAT2;0,0;False;2;COLOR;0;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode;68;234.7509,-72.4296;Inherit;False;TintVertex;-1;;32;b0b94dd27c0f3da49a89feecae766dcc;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;16;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;12;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=NormalsRendering;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;17;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;12;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;15;506.5879,57.29841;Float;False;True;-1;2;SpriteShadersUltimate.SingleShaderGUI;0;12;Sprite Shaders Ultimate/URP Lit/Color/Outer Outline Lit;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;1;Vertex Position;1;0;3;True;True;True;False;;False;0
WireConnection;69;0;70;0
WireConnection;75;186;76;0
WireConnection;75;15;69;0
WireConnection;75;7;72;0
WireConnection;75;4;70;0
WireConnection;68;1;75;0
WireConnection;15;1;68;0
WireConnection;15;2;66;0
WireConnection;15;3;66;5
ASEEND*/
//CHKSM=970CB01F7EB4D2E2AAF9BDBCD912D0F6BA601B91