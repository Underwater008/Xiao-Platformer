// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprite Shaders Ultimate/URP Lit/Effect/Frozen Lit"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_MaskMap("Mask Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 3)) = 1
		[KeywordEnum(UV,UV_Raw,Object,Object_Scaled,World,UI_Element,Screen)] _ShaderSpace("Shader Space", Float) = 0
		_PixelsPerUnit("Pixels Per Unit", Float) = 100
		_ScreenWidthUnits("Screen Width Units", Float) = 10
		_RectWidth("Rect Width", Float) = 100
		_RectHeight("Rect Height", Float) = 100
		[KeywordEnum(Linear_Default,Linear_Scaled,Linear_FPS,Frequency,Frequency_FPS,Custom_Value)] _TimeSettings("Time Settings", Float) = 0
		_TimeScale("Time Scale", Float) = 1
		_TimeFrequency("Time Frequency", Float) = 2
		_TimeRange("Time Range", Float) = 0.5
		_TimeFPS("Time FPS", Float) = 5
		_TimeValue("Time Value", Float) = 0
		_FrozenFade("Frozen: Fade", Range( 0 , 1)) = 1
		[HDR]_FrozenTint("Frozen: Tint", Color) = (1.819608,4.611765,5.992157,0)
		_FrozenContrast("Frozen: Contrast", Float) = 2
		[HDR]_FrozenSnowColor("Frozen: Snow Color", Color) = (1.123529,1.373203,1.498039,0)
		_FrozenSnowContrast("Frozen: Snow Contrast", Float) = 1
		_FrozenSnowDensity("Frozen: Snow Density", Range( 0 , 1)) = 0.25
		_FrozenSnowScale("Frozen: Snow Scale", Vector) = (0.1,0.1,0,0)
		[HDR]_FrozenHighlightColor("Frozen: Highlight Color", Color) = (1.797647,4.604501,5.992157,1)
		_FrozenHighlightContrast("Frozen: Highlight Contrast", Float) = 2
		_FrozenHighlightDensity("Frozen: Highlight Density", Range( 0 , 1)) = 1
		_FrozenHighlightSpeed("Frozen: Highlight Speed", Vector) = (0.1,0.1,0,0)
		_FrozenHighlightScale("Frozen: Highlight Scale", Vector) = (0.2,0.2,0,0)
		_FrozenHighlightDistortion("Frozen: Highlight Distortion", Vector) = (0.5,0.5,0,0)
		_FrozenHighlightDistortionSpeed("Frozen: Highlight Distortion Speed", Vector) = (-0.05,-0.05,0,0)
		_FrozenHighlightDistortionScale("Frozen: Highlight Distortion Scale", Vector) = (0.2,0.2,0,0)
		[ASEEnd]_FrozenNoiseTexture("Frozen: Noise Texture", 2D) = "white" {}
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

			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _SHADERSPACE_UV _SHADERSPACE_UV_RAW _SHADERSPACE_OBJECT _SHADERSPACE_OBJECT_SCALED _SHADERSPACE_WORLD _SHADERSPACE_UI_ELEMENT _SHADERSPACE_SCREEN
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _FrozenNoiseTexture;
			sampler2D _MaskMap;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _FrozenTint;
			float4 _FrozenHighlightColor;
			float4 _FrozenSnowColor;
			float4 _MainTex_TexelSize;
			float2 _FrozenHighlightScale;
			float2 _FrozenHighlightSpeed;
			float2 _FrozenHighlightDistortion;
			float2 _FrozenHighlightDistortionScale;
			float2 _FrozenHighlightDistortionSpeed;
			float2 _FrozenSnowScale;
			float _FrozenHighlightContrast;
			float _TimeValue;
			float _TimeRange;
			float _TimeFrequency;
			float _TimeScale;
			float _FrozenFade;
			float _FrozenHighlightDensity;
			float _ScreenWidthUnits;
			float _RectHeight;
			float _RectWidth;
			float _PixelsPerUnit;
			float _FrozenSnowDensity;
			float _FrozenSnowContrast;
			float _FrozenContrast;
			float _TimeFPS;
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
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
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
				o.ase_texcoord4.xyz = ase_worldPos;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord5 = screenPos;
				
				o.ase_texcoord3 = v.vertex;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
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
				float4 temp_output_1_0_g431 = tex2D( _MainTex, uv_MainTex );
				float4 break2_g434 = temp_output_1_0_g431;
				float temp_output_7_0_g431 = ( ( break2_g434.x + break2_g434.y + break2_g434.z ) / 3.0 );
				float temp_output_9_0_g436 = max( _FrozenContrast , 0.0 );
				float saferPower7_g436 = max( ( temp_output_7_0_g431 + ( 0.1 * max( ( 1.0 - temp_output_9_0_g436 ) , 0.0 ) ) ) , 0.0001 );
				float saferPower20_g431 = max( temp_output_7_0_g431 , 0.0001 );
				float2 texCoord2_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord22_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float3 ase_worldPos = IN.ase_texcoord4.xyz;
				float2 texCoord23_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult28_g422 = (float2(_RectWidth , _RectHeight));
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				#if defined(_SHADERSPACE_UV)
				float2 staticSwitch1_g422 = ( texCoord2_g422 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#elif defined(_SHADERSPACE_UV_RAW)
				float2 staticSwitch1_g422 = texCoord22_g422;
				#elif defined(_SHADERSPACE_OBJECT)
				float2 staticSwitch1_g422 = (IN.ase_texcoord3.xyz).xy;
				#elif defined(_SHADERSPACE_OBJECT_SCALED)
				float2 staticSwitch1_g422 = ( (IN.ase_texcoord3.xyz).xy * (ase_objectScale).xy );
				#elif defined(_SHADERSPACE_WORLD)
				float2 staticSwitch1_g422 = (ase_worldPos).xy;
				#elif defined(_SHADERSPACE_UI_ELEMENT)
				float2 staticSwitch1_g422 = ( texCoord23_g422 * ( appendResult28_g422 / _PixelsPerUnit ) );
				#elif defined(_SHADERSPACE_SCREEN)
				float2 staticSwitch1_g422 = ( ( (ase_screenPosNorm).xy * (_ScreenParams).xy ) / ( _ScreenParams.x / _ScreenWidthUnits ) );
				#else
				float2 staticSwitch1_g422 = ( texCoord2_g422 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#endif
				float2 temp_output_72_0_g431 = staticSwitch1_g422;
				float mulTime5_g437 = _TimeParameters.x * _TimeScale;
				float mulTime7_g437 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g437 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g437 = mulTime5_g437;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g437 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g437 = ( ( sin( mulTime7_g437 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g437 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g437 = _TimeValue;
				#else
				float staticSwitch1_g437 = _TimeParameters.x;
				#endif
				float temp_output_73_0_g431 = staticSwitch1_g437;
				float saferPower42_g431 = max( temp_output_7_0_g431 , 0.0001 );
				float3 lerpResult57_g431 = lerp( (temp_output_1_0_g431).rgb , ( ( pow( saferPower7_g436 , temp_output_9_0_g436 ) * (_FrozenTint).rgb ) + ( pow( saferPower20_g431 , _FrozenSnowContrast ) * ( (_FrozenSnowColor).rgb * max( ( _FrozenSnowDensity - tex2D( _FrozenNoiseTexture, ( temp_output_72_0_g431 * _FrozenSnowScale ) ).r ) , 0.0 ) ) ) + (( max( ( ( _FrozenHighlightDensity - tex2D( _FrozenNoiseTexture, ( ( ( ( tex2D( _FrozenNoiseTexture, ( ( ( temp_output_73_0_g431 * _FrozenHighlightDistortionSpeed ) + temp_output_72_0_g431 ) * _FrozenHighlightDistortionScale ) ).r - 0.25 ) * _FrozenHighlightDistortion ) + ( ( temp_output_73_0_g431 * _FrozenHighlightSpeed ) + temp_output_72_0_g431 ) ) * _FrozenHighlightScale ) ).r ) / max( _FrozenHighlightDensity , 0.01 ) ) , 0.0 ) * _FrozenHighlightColor * pow( saferPower42_g431 , _FrozenHighlightContrast ) )).rgb ) , _FrozenFade);
				float4 appendResult26_g431 = (float4(lerpResult57_g431 , temp_output_1_0_g431.a));
				
				float2 temp_output_8_0_g430 = IN.texCoord0.xy;
				
				float3 unpack14_g430 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g430 ), _NormalIntensity );
				unpack14_g430.z = lerp( 1, unpack14_g430.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult26_g431 * IN.ase_color );
				float Mask = tex2D( _MaskMap, temp_output_8_0_g430 ).r;
				float3 Normal = unpack14_g430;

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
			
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _SHADERSPACE_UV _SHADERSPACE_UV_RAW _SHADERSPACE_OBJECT _SHADERSPACE_OBJECT_SCALED _SHADERSPACE_WORLD _SHADERSPACE_UI_ELEMENT _SHADERSPACE_SCREEN
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _FrozenNoiseTexture;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _FrozenTint;
			float4 _FrozenHighlightColor;
			float4 _FrozenSnowColor;
			float4 _MainTex_TexelSize;
			float2 _FrozenHighlightScale;
			float2 _FrozenHighlightSpeed;
			float2 _FrozenHighlightDistortion;
			float2 _FrozenHighlightDistortionScale;
			float2 _FrozenHighlightDistortionSpeed;
			float2 _FrozenSnowScale;
			float _FrozenHighlightContrast;
			float _TimeValue;
			float _TimeRange;
			float _TimeFrequency;
			float _TimeScale;
			float _FrozenFade;
			float _FrozenHighlightDensity;
			float _ScreenWidthUnits;
			float _RectHeight;
			float _RectWidth;
			float _PixelsPerUnit;
			float _FrozenSnowDensity;
			float _FrozenSnowContrast;
			float _FrozenContrast;
			float _TimeFPS;
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
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
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
				o.ase_texcoord6.xyz = ase_worldPos;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord7 = screenPos;
				
				o.ase_texcoord5 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord6.w = 0;
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
				float4 temp_output_1_0_g431 = tex2D( _MainTex, uv_MainTex );
				float4 break2_g434 = temp_output_1_0_g431;
				float temp_output_7_0_g431 = ( ( break2_g434.x + break2_g434.y + break2_g434.z ) / 3.0 );
				float temp_output_9_0_g436 = max( _FrozenContrast , 0.0 );
				float saferPower7_g436 = max( ( temp_output_7_0_g431 + ( 0.1 * max( ( 1.0 - temp_output_9_0_g436 ) , 0.0 ) ) ) , 0.0001 );
				float saferPower20_g431 = max( temp_output_7_0_g431 , 0.0001 );
				float2 texCoord2_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord22_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float3 ase_worldPos = IN.ase_texcoord6.xyz;
				float2 texCoord23_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult28_g422 = (float2(_RectWidth , _RectHeight));
				float4 screenPos = IN.ase_texcoord7;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				#if defined(_SHADERSPACE_UV)
				float2 staticSwitch1_g422 = ( texCoord2_g422 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#elif defined(_SHADERSPACE_UV_RAW)
				float2 staticSwitch1_g422 = texCoord22_g422;
				#elif defined(_SHADERSPACE_OBJECT)
				float2 staticSwitch1_g422 = (IN.ase_texcoord5.xyz).xy;
				#elif defined(_SHADERSPACE_OBJECT_SCALED)
				float2 staticSwitch1_g422 = ( (IN.ase_texcoord5.xyz).xy * (ase_objectScale).xy );
				#elif defined(_SHADERSPACE_WORLD)
				float2 staticSwitch1_g422 = (ase_worldPos).xy;
				#elif defined(_SHADERSPACE_UI_ELEMENT)
				float2 staticSwitch1_g422 = ( texCoord23_g422 * ( appendResult28_g422 / _PixelsPerUnit ) );
				#elif defined(_SHADERSPACE_SCREEN)
				float2 staticSwitch1_g422 = ( ( (ase_screenPosNorm).xy * (_ScreenParams).xy ) / ( _ScreenParams.x / _ScreenWidthUnits ) );
				#else
				float2 staticSwitch1_g422 = ( texCoord2_g422 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#endif
				float2 temp_output_72_0_g431 = staticSwitch1_g422;
				float mulTime5_g437 = _TimeParameters.x * _TimeScale;
				float mulTime7_g437 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g437 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g437 = mulTime5_g437;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g437 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g437 = ( ( sin( mulTime7_g437 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g437 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g437 = _TimeValue;
				#else
				float staticSwitch1_g437 = _TimeParameters.x;
				#endif
				float temp_output_73_0_g431 = staticSwitch1_g437;
				float saferPower42_g431 = max( temp_output_7_0_g431 , 0.0001 );
				float3 lerpResult57_g431 = lerp( (temp_output_1_0_g431).rgb , ( ( pow( saferPower7_g436 , temp_output_9_0_g436 ) * (_FrozenTint).rgb ) + ( pow( saferPower20_g431 , _FrozenSnowContrast ) * ( (_FrozenSnowColor).rgb * max( ( _FrozenSnowDensity - tex2D( _FrozenNoiseTexture, ( temp_output_72_0_g431 * _FrozenSnowScale ) ).r ) , 0.0 ) ) ) + (( max( ( ( _FrozenHighlightDensity - tex2D( _FrozenNoiseTexture, ( ( ( ( tex2D( _FrozenNoiseTexture, ( ( ( temp_output_73_0_g431 * _FrozenHighlightDistortionSpeed ) + temp_output_72_0_g431 ) * _FrozenHighlightDistortionScale ) ).r - 0.25 ) * _FrozenHighlightDistortion ) + ( ( temp_output_73_0_g431 * _FrozenHighlightSpeed ) + temp_output_72_0_g431 ) ) * _FrozenHighlightScale ) ).r ) / max( _FrozenHighlightDensity , 0.01 ) ) , 0.0 ) * _FrozenHighlightColor * pow( saferPower42_g431 , _FrozenHighlightContrast ) )).rgb ) , _FrozenFade);
				float4 appendResult26_g431 = (float4(lerpResult57_g431 , temp_output_1_0_g431.a));
				
				float2 temp_output_8_0_g430 = IN.texCoord0.xy;
				float3 unpack14_g430 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g430 ), _NormalIntensity );
				unpack14_g430.z = lerp( 1, unpack14_g430.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult26_g431 * IN.color );
				float3 Normal = unpack14_g430;
				
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

			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _SHADERSPACE_UV _SHADERSPACE_UV_RAW _SHADERSPACE_OBJECT _SHADERSPACE_OBJECT_SCALED _SHADERSPACE_WORLD _SHADERSPACE_UI_ELEMENT _SHADERSPACE_SCREEN
			#pragma shader_feature _TIMESETTINGS_LINEAR_DEFAULT _TIMESETTINGS_LINEAR_SCALED _TIMESETTINGS_LINEAR_FPS _TIMESETTINGS_FREQUENCY _TIMESETTINGS_FREQUENCY_FPS _TIMESETTINGS_CUSTOM_VALUE


			sampler2D _MainTex;
			sampler2D _FrozenNoiseTexture;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _FrozenTint;
			float4 _FrozenHighlightColor;
			float4 _FrozenSnowColor;
			float4 _MainTex_TexelSize;
			float2 _FrozenHighlightScale;
			float2 _FrozenHighlightSpeed;
			float2 _FrozenHighlightDistortion;
			float2 _FrozenHighlightDistortionScale;
			float2 _FrozenHighlightDistortionSpeed;
			float2 _FrozenSnowScale;
			float _FrozenHighlightContrast;
			float _TimeValue;
			float _TimeRange;
			float _TimeFrequency;
			float _TimeScale;
			float _FrozenFade;
			float _FrozenHighlightDensity;
			float _ScreenWidthUnits;
			float _RectHeight;
			float _RectWidth;
			float _PixelsPerUnit;
			float _FrozenSnowDensity;
			float _FrozenSnowContrast;
			float _FrozenContrast;
			float _TimeFPS;
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
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
				o.ase_texcoord3.xyz = ase_worldPos;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
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
				float4 temp_output_1_0_g431 = tex2D( _MainTex, uv_MainTex );
				float4 break2_g434 = temp_output_1_0_g431;
				float temp_output_7_0_g431 = ( ( break2_g434.x + break2_g434.y + break2_g434.z ) / 3.0 );
				float temp_output_9_0_g436 = max( _FrozenContrast , 0.0 );
				float saferPower7_g436 = max( ( temp_output_7_0_g431 + ( 0.1 * max( ( 1.0 - temp_output_9_0_g436 ) , 0.0 ) ) ) , 0.0001 );
				float saferPower20_g431 = max( temp_output_7_0_g431 , 0.0001 );
				float2 texCoord2_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord22_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float3 ase_worldPos = IN.ase_texcoord3.xyz;
				float2 texCoord23_g422 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult28_g422 = (float2(_RectWidth , _RectHeight));
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				#if defined(_SHADERSPACE_UV)
				float2 staticSwitch1_g422 = ( texCoord2_g422 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#elif defined(_SHADERSPACE_UV_RAW)
				float2 staticSwitch1_g422 = texCoord22_g422;
				#elif defined(_SHADERSPACE_OBJECT)
				float2 staticSwitch1_g422 = (IN.ase_texcoord2.xyz).xy;
				#elif defined(_SHADERSPACE_OBJECT_SCALED)
				float2 staticSwitch1_g422 = ( (IN.ase_texcoord2.xyz).xy * (ase_objectScale).xy );
				#elif defined(_SHADERSPACE_WORLD)
				float2 staticSwitch1_g422 = (ase_worldPos).xy;
				#elif defined(_SHADERSPACE_UI_ELEMENT)
				float2 staticSwitch1_g422 = ( texCoord23_g422 * ( appendResult28_g422 / _PixelsPerUnit ) );
				#elif defined(_SHADERSPACE_SCREEN)
				float2 staticSwitch1_g422 = ( ( (ase_screenPosNorm).xy * (_ScreenParams).xy ) / ( _ScreenParams.x / _ScreenWidthUnits ) );
				#else
				float2 staticSwitch1_g422 = ( texCoord2_g422 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#endif
				float2 temp_output_72_0_g431 = staticSwitch1_g422;
				float mulTime5_g437 = _TimeParameters.x * _TimeScale;
				float mulTime7_g437 = _TimeParameters.x * _TimeFrequency;
				#if defined(_TIMESETTINGS_LINEAR_DEFAULT)
				float staticSwitch1_g437 = _TimeParameters.x;
				#elif defined(_TIMESETTINGS_LINEAR_SCALED)
				float staticSwitch1_g437 = mulTime5_g437;
				#elif defined(_TIMESETTINGS_LINEAR_FPS)
				float staticSwitch1_g437 = ( _TimeScale * ( floor( ( _TimeParameters.x * _TimeFPS ) ) / _TimeFPS ) );
				#elif defined(_TIMESETTINGS_FREQUENCY)
				float staticSwitch1_g437 = ( ( sin( mulTime7_g437 ) * _TimeRange ) + 100.0 );
				#elif defined(_TIMESETTINGS_FREQUENCY_FPS)
				float staticSwitch1_g437 = ( ( _TimeRange * sin( ( _TimeFrequency * ( floor( ( _TimeFPS * _TimeParameters.x ) ) / _TimeFPS ) ) ) ) + 100.0 );
				#elif defined(_TIMESETTINGS_CUSTOM_VALUE)
				float staticSwitch1_g437 = _TimeValue;
				#else
				float staticSwitch1_g437 = _TimeParameters.x;
				#endif
				float temp_output_73_0_g431 = staticSwitch1_g437;
				float saferPower42_g431 = max( temp_output_7_0_g431 , 0.0001 );
				float3 lerpResult57_g431 = lerp( (temp_output_1_0_g431).rgb , ( ( pow( saferPower7_g436 , temp_output_9_0_g436 ) * (_FrozenTint).rgb ) + ( pow( saferPower20_g431 , _FrozenSnowContrast ) * ( (_FrozenSnowColor).rgb * max( ( _FrozenSnowDensity - tex2D( _FrozenNoiseTexture, ( temp_output_72_0_g431 * _FrozenSnowScale ) ).r ) , 0.0 ) ) ) + (( max( ( ( _FrozenHighlightDensity - tex2D( _FrozenNoiseTexture, ( ( ( ( tex2D( _FrozenNoiseTexture, ( ( ( temp_output_73_0_g431 * _FrozenHighlightDistortionSpeed ) + temp_output_72_0_g431 ) * _FrozenHighlightDistortionScale ) ).r - 0.25 ) * _FrozenHighlightDistortion ) + ( ( temp_output_73_0_g431 * _FrozenHighlightSpeed ) + temp_output_72_0_g431 ) ) * _FrozenHighlightScale ) ).r ) / max( _FrozenHighlightDensity , 0.01 ) ) , 0.0 ) * _FrozenHighlightColor * pow( saferPower42_g431 , _FrozenHighlightContrast ) )).rgb ) , _FrozenFade);
				float4 appendResult26_g431 = (float4(lerpResult57_g431 , temp_output_1_0_g431.a));
				
				float4 Color = ( appendResult26_g431 * IN.color );

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
0;0;1920;1019;1781.84;640.2244;1.582456;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;25;-1030.353,-109.1203;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;24;-736.775,33.25894;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;91;-693.2105,-112.532;Inherit;False;ShaderSpace;5;;422;be729ef05db9c224caec82a3516038dc;0;1;3;SAMPLER2D;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;93;-620.3174,-235.1156;Inherit;False;ShaderTime;11;;437;06a15e67904f217499045f361bad56e7;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;92;-384.4118,-82.23596;Inherit;False;_Frozen;18;;431;e2e3419fc0ba9f046bb64131b2b2c1ae;0;4;73;FLOAT;0;False;72;FLOAT2;0,0;False;70;SAMPLER2D;;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;22;-63.6362,70.99575;Inherit;False;TintVertex;-1;;429;b0b94dd27c0f3da49a89feecae766dcc;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;86;-68.50143,156.8532;Inherit;False;LitHandler;1;;430;851662d67a92ce04d84817ff63c501f2;0;1;8;FLOAT2;0,0;False;2;COLOR;0;FLOAT3;5
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;83;211.4418,70.685;Float;False;True;-1;2;SpriteShadersUltimate.SingleShaderGUI;0;12;Sprite Shaders Ultimate/URP Lit/Effect/Frozen Lit;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;1;Vertex Position;1;0;3;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;84;211.4418,70.685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=NormalsRendering;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;85;211.4418,70.685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;24;0;25;0
WireConnection;91;3;25;0
WireConnection;92;73;93;0
WireConnection;92;72;91;0
WireConnection;92;1;24;0
WireConnection;22;1;92;0
WireConnection;83;1;22;0
WireConnection;83;2;86;0
WireConnection;83;3;86;5
ASEEND*/
//CHKSM=039DE6B603F71F018738377A8FF5263E914E8E3B