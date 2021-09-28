// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprite Shaders Ultimate/URP Lit/Fading/Full Distortion Lit"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_MaskMap("Mask Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 3)) = 1
		[KeywordEnum(UV,UV_Raw,Object,Object_Scaled,World,UI_Element,Screen)] _ShaderSpace("Shader Space", Float) = 0
		_PixelsPerUnit("Pixels Per Unit", Float) = 100
		_ScreenWidthUnits("Screen Width Units", Float) = 10
		_RectWidth("Rect Width", Float) = 100
		_RectHeight("Rect Height", Float) = 100
		_FullDistortionFade("Full Distortion: Fade", Range( 0 , 1)) = 1
		_FullDistortionDistortion("Full Distortion: Distortion", Vector) = (0.2,0.2,0,0)
		_FullDistortionNoiseScale("Full Distortion: Noise Scale", Vector) = (0.5,0.5,0,0)
		[ASEEnd]_FullDistortionNoiseTexture("Full Distortion: Noise Texture", 2D) = "white" {}

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


			sampler2D _MainTex;
			sampler2D _FullDistortionNoiseTexture;
			sampler2D _MaskMap;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_TexelSize;
			float2 _FullDistortionNoiseScale;
			float2 _FullDistortionDistortion;
			float _FullDistortionFade;
			float _PixelsPerUnit;
			float _RectWidth;
			float _RectHeight;
			float _ScreenWidthUnits;
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

				float2 texCoord83 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord2_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord22_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float3 ase_worldPos = IN.ase_texcoord4.xyz;
				float2 texCoord23_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult28_g195 = (float2(_RectWidth , _RectHeight));
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				#if defined(_SHADERSPACE_UV)
				float2 staticSwitch1_g195 = ( texCoord2_g195 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#elif defined(_SHADERSPACE_UV_RAW)
				float2 staticSwitch1_g195 = texCoord22_g195;
				#elif defined(_SHADERSPACE_OBJECT)
				float2 staticSwitch1_g195 = (IN.ase_texcoord3.xyz).xy;
				#elif defined(_SHADERSPACE_OBJECT_SCALED)
				float2 staticSwitch1_g195 = ( (IN.ase_texcoord3.xyz).xy * (ase_objectScale).xy );
				#elif defined(_SHADERSPACE_WORLD)
				float2 staticSwitch1_g195 = (ase_worldPos).xy;
				#elif defined(_SHADERSPACE_UI_ELEMENT)
				float2 staticSwitch1_g195 = ( texCoord23_g195 * ( appendResult28_g195 / _PixelsPerUnit ) );
				#elif defined(_SHADERSPACE_SCREEN)
				float2 staticSwitch1_g195 = ( ( (ase_screenPosNorm).xy * (_ScreenParams).xy ) / ( _ScreenParams.x / _ScreenWidthUnits ) );
				#else
				float2 staticSwitch1_g195 = ( texCoord2_g195 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#endif
				float2 temp_output_195_0_g192 = staticSwitch1_g195;
				float2 appendResult189_g192 = (float2(( tex2D( _FullDistortionNoiseTexture, ( temp_output_195_0_g192 * _FullDistortionNoiseScale ) ).r - 0.5 ) , ( tex2D( _FullDistortionNoiseTexture, ( ( temp_output_195_0_g192 + float2( 0.321,0.321 ) ) * _FullDistortionNoiseScale ) ).r - 0.5 )));
				float2 temp_output_86_174 = ( texCoord83 + ( ( 1.0 - _FullDistortionFade ) * appendResult189_g192 * _FullDistortionDistortion ) );
				float4 break4_g189 = tex2D( _MainTex, temp_output_86_174 );
				float4 appendResult5_g189 = (float4(break4_g189.r , break4_g189.g , break4_g189.b , ( break4_g189.a * _FullDistortionFade )));
				
				float2 temp_output_8_0_g190 = temp_output_86_174;
				
				float3 unpack14_g190 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g190 ), _NormalIntensity );
				unpack14_g190.z = lerp( 1, unpack14_g190.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult5_g189 * IN.ase_color );
				float Mask = tex2D( _MaskMap, temp_output_8_0_g190 ).r;
				float3 Normal = unpack14_g190;

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


			sampler2D _MainTex;
			sampler2D _FullDistortionNoiseTexture;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_TexelSize;
			float2 _FullDistortionNoiseScale;
			float2 _FullDistortionDistortion;
			float _FullDistortionFade;
			float _PixelsPerUnit;
			float _RectWidth;
			float _RectHeight;
			float _ScreenWidthUnits;
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

				float2 texCoord83 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord2_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord22_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float3 ase_worldPos = IN.ase_texcoord6.xyz;
				float2 texCoord23_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult28_g195 = (float2(_RectWidth , _RectHeight));
				float4 screenPos = IN.ase_texcoord7;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				#if defined(_SHADERSPACE_UV)
				float2 staticSwitch1_g195 = ( texCoord2_g195 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#elif defined(_SHADERSPACE_UV_RAW)
				float2 staticSwitch1_g195 = texCoord22_g195;
				#elif defined(_SHADERSPACE_OBJECT)
				float2 staticSwitch1_g195 = (IN.ase_texcoord5.xyz).xy;
				#elif defined(_SHADERSPACE_OBJECT_SCALED)
				float2 staticSwitch1_g195 = ( (IN.ase_texcoord5.xyz).xy * (ase_objectScale).xy );
				#elif defined(_SHADERSPACE_WORLD)
				float2 staticSwitch1_g195 = (ase_worldPos).xy;
				#elif defined(_SHADERSPACE_UI_ELEMENT)
				float2 staticSwitch1_g195 = ( texCoord23_g195 * ( appendResult28_g195 / _PixelsPerUnit ) );
				#elif defined(_SHADERSPACE_SCREEN)
				float2 staticSwitch1_g195 = ( ( (ase_screenPosNorm).xy * (_ScreenParams).xy ) / ( _ScreenParams.x / _ScreenWidthUnits ) );
				#else
				float2 staticSwitch1_g195 = ( texCoord2_g195 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#endif
				float2 temp_output_195_0_g192 = staticSwitch1_g195;
				float2 appendResult189_g192 = (float2(( tex2D( _FullDistortionNoiseTexture, ( temp_output_195_0_g192 * _FullDistortionNoiseScale ) ).r - 0.5 ) , ( tex2D( _FullDistortionNoiseTexture, ( ( temp_output_195_0_g192 + float2( 0.321,0.321 ) ) * _FullDistortionNoiseScale ) ).r - 0.5 )));
				float2 temp_output_86_174 = ( texCoord83 + ( ( 1.0 - _FullDistortionFade ) * appendResult189_g192 * _FullDistortionDistortion ) );
				float4 break4_g189 = tex2D( _MainTex, temp_output_86_174 );
				float4 appendResult5_g189 = (float4(break4_g189.r , break4_g189.g , break4_g189.b , ( break4_g189.a * _FullDistortionFade )));
				
				float2 temp_output_8_0_g190 = temp_output_86_174;
				float3 unpack14_g190 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g190 ), _NormalIntensity );
				unpack14_g190.z = lerp( 1, unpack14_g190.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult5_g189 * IN.color );
				float3 Normal = unpack14_g190;
				
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


			sampler2D _MainTex;
			sampler2D _FullDistortionNoiseTexture;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_TexelSize;
			float2 _FullDistortionNoiseScale;
			float2 _FullDistortionDistortion;
			float _FullDistortionFade;
			float _PixelsPerUnit;
			float _RectWidth;
			float _RectHeight;
			float _ScreenWidthUnits;
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

				float2 texCoord83 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord2_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord22_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float3 ase_worldPos = IN.ase_texcoord3.xyz;
				float2 texCoord23_g195 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult28_g195 = (float2(_RectWidth , _RectHeight));
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				#if defined(_SHADERSPACE_UV)
				float2 staticSwitch1_g195 = ( texCoord2_g195 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#elif defined(_SHADERSPACE_UV_RAW)
				float2 staticSwitch1_g195 = texCoord22_g195;
				#elif defined(_SHADERSPACE_OBJECT)
				float2 staticSwitch1_g195 = (IN.ase_texcoord2.xyz).xy;
				#elif defined(_SHADERSPACE_OBJECT_SCALED)
				float2 staticSwitch1_g195 = ( (IN.ase_texcoord2.xyz).xy * (ase_objectScale).xy );
				#elif defined(_SHADERSPACE_WORLD)
				float2 staticSwitch1_g195 = (ase_worldPos).xy;
				#elif defined(_SHADERSPACE_UI_ELEMENT)
				float2 staticSwitch1_g195 = ( texCoord23_g195 * ( appendResult28_g195 / _PixelsPerUnit ) );
				#elif defined(_SHADERSPACE_SCREEN)
				float2 staticSwitch1_g195 = ( ( (ase_screenPosNorm).xy * (_ScreenParams).xy ) / ( _ScreenParams.x / _ScreenWidthUnits ) );
				#else
				float2 staticSwitch1_g195 = ( texCoord2_g195 / ( _PixelsPerUnit * (_MainTex_TexelSize).xy ) );
				#endif
				float2 temp_output_195_0_g192 = staticSwitch1_g195;
				float2 appendResult189_g192 = (float2(( tex2D( _FullDistortionNoiseTexture, ( temp_output_195_0_g192 * _FullDistortionNoiseScale ) ).r - 0.5 ) , ( tex2D( _FullDistortionNoiseTexture, ( ( temp_output_195_0_g192 + float2( 0.321,0.321 ) ) * _FullDistortionNoiseScale ) ).r - 0.5 )));
				float2 temp_output_86_174 = ( texCoord83 + ( ( 1.0 - _FullDistortionFade ) * appendResult189_g192 * _FullDistortionDistortion ) );
				float4 break4_g189 = tex2D( _MainTex, temp_output_86_174 );
				float4 appendResult5_g189 = (float4(break4_g189.r , break4_g189.g , break4_g189.b , ( break4_g189.a * _FullDistortionFade )));
				
				float4 Color = ( appendResult5_g189 * IN.color );

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
0;0;1920;1019;2045.075;863.8265;1.42315;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;69;-1601.5,-624.2565;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-1321.702,-222.4189;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;87;-1305.037,-404.1493;Inherit;False;ShaderSpace;5;;195;be729ef05db9c224caec82a3516038dc;0;1;3;SAMPLER2D;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;86;-1029.561,-313.9366;Inherit;False;_FullDistortion;11;;192;62960fe27c1c398408207bb462ffd10e;0;3;195;FLOAT2;0,0;False;160;FLOAT2;0,0;False;194;SAMPLER2D;;False;2;FLOAT2;174;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-657.1795,-470.3953;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;84;-272.1584,-301.7776;Inherit;False;AlphaMult;-1;;189;d24974f7959982d48aab81e9e7692f35;0;2;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;66;23.38802,234.6282;Inherit;False;LitHandler;1;;190;851662d67a92ce04d84817ff63c501f2;0;1;8;FLOAT2;0,0;False;2;COLOR;0;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode;76;33.67749,-128.6291;Inherit;False;TintVertex;-1;;191;b0b94dd27c0f3da49a89feecae766dcc;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;16;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;13;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=NormalsRendering;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;17;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;13;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;15;295.6955,138.9342;Float;False;True;-1;2;SpriteShadersUltimate.SingleShaderGUI;0;12;Sprite Shaders Ultimate/URP Lit/Fading/Full Distortion Lit;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;1;Vertex Position;1;0;3;True;True;True;False;;False;0
WireConnection;87;3;69;0
WireConnection;86;195;87;0
WireConnection;86;160;83;0
WireConnection;68;0;69;0
WireConnection;68;1;86;174
WireConnection;84;1;68;0
WireConnection;84;2;86;0
WireConnection;66;8;86;174
WireConnection;76;1;84;0
WireConnection;15;1;76;0
WireConnection;15;2;66;0
WireConnection;15;3;66;5
ASEEND*/
//CHKSM=5D194333E619D186583B8E2EB3B459513B7BA5E9