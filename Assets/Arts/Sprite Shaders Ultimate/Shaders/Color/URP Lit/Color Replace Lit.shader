// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprite Shaders Ultimate/URP Lit/Color/Color Replace Lit"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[ASEBegin]_MainTex("MainTex", 2D) = "white" {}
		_MaskMap("Mask Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 3)) = 1
		_ColorReplaceFade("Color Replace: Fade", Range( 0 , 1)) = 1
		_ColorReplaceTargetColor("Color Replace: Target Color", Color) = (0,0,0,0)
		_ColorReplaceBias("Color Replace: Bias", Float) = 1
		[HDR]_ColorReplaceColor("Color Replace: Color", Color) = (1,0,0,0)
		_ColorReplaceContrast("Color Replace: Contrast", Float) = 1
		_ColorReplaceHueTolerance("Color Replace: Hue Tolerance", Float) = 1
		_ColorReplaceSaturationTolerance("Color Replace: Saturation Tolerance", Float) = 1
		[ASEEnd]_ColorReplaceBrightnessTolerance("Color Replace: Brightness Tolerance", Float) = 1
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
			#define ASE_SRP_VERSION 70403

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

			

			sampler2D _MainTex;
			sampler2D _MaskMap;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _ColorReplaceColor;
			float4 _ColorReplaceTargetColor;
			float _ColorReplaceContrast;
			float _ColorReplaceHueTolerance;
			float _ColorReplaceSaturationTolerance;
			float _ColorReplaceBrightnessTolerance;
			float _ColorReplaceBias;
			float _ColorReplaceFade;
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

			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

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
				float4 temp_output_1_0_g31 = tex2D( _MainTex, uv_MainTex );
				float3 temp_output_2_0_g31 = (temp_output_1_0_g31).rgb;
				float4 break2_g32 = float4( temp_output_2_0_g31 , 0.0 );
				float temp_output_9_0_g33 = max( _ColorReplaceContrast , 0.0 );
				float saferPower7_g33 = max( ( ( ( break2_g32.x + break2_g32.y + break2_g32.z ) / 3.0 ) + ( 0.1 * max( ( 1.0 - temp_output_9_0_g33 ) , 0.0 ) ) ) , 0.0001 );
				float3 hsvTorgb7_g31 = RGBToHSV( (_ColorReplaceTargetColor).rgb );
				float3 hsvTorgb5_g31 = RGBToHSV( temp_output_2_0_g31 );
				float clampResult35_g31 = clamp( ( 1.0 - ( min( min( distance( hsvTorgb7_g31.x , hsvTorgb5_g31.x ) , distance( hsvTorgb7_g31.x , ( hsvTorgb5_g31.x + 1.0 ) ) ) , distance( hsvTorgb7_g31.x , ( hsvTorgb5_g31.x + -1.0 ) ) ) / max( ( _ColorReplaceHueTolerance * 0.15 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float clampResult30_g31 = clamp( ( 1.0 - ( distance( hsvTorgb7_g31.y , hsvTorgb5_g31.y ) / max( ( _ColorReplaceSaturationTolerance * 2.0 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float clampResult40_g31 = clamp( ( 1.0 - ( distance( hsvTorgb7_g31.z , hsvTorgb5_g31.z ) / max( ( _ColorReplaceBrightnessTolerance * 1.5 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float saferPower48_g31 = max( ( clampResult35_g31 * clampResult30_g31 * clampResult40_g31 ) , 0.0001 );
				float3 lerpResult23_g31 = lerp( temp_output_2_0_g31 , ( pow( saferPower7_g33 , temp_output_9_0_g33 ) * (_ColorReplaceColor).rgb ) , ( pow( saferPower48_g31 , max( _ColorReplaceBias , 0.001 ) ) * _ColorReplaceFade ));
				float4 appendResult4_g31 = (float4(lerpResult23_g31 , temp_output_1_0_g31.a));
				
				float2 temp_output_8_0_g34 = IN.texCoord0.xy;
				
				float3 unpack14_g34 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g34 ), _NormalIntensity );
				unpack14_g34.z = lerp( 1, unpack14_g34.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult4_g31 * IN.ase_color );
				float Mask = tex2D( _MaskMap, temp_output_8_0_g34 ).r;
				float3 Normal = unpack14_g34;

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
			#define ASE_SRP_VERSION 70403

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


			sampler2D _MainTex;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _ColorReplaceColor;
			float4 _ColorReplaceTargetColor;
			float _ColorReplaceContrast;
			float _ColorReplaceHueTolerance;
			float _ColorReplaceSaturationTolerance;
			float _ColorReplaceBrightnessTolerance;
			float _ColorReplaceBias;
			float _ColorReplaceFade;
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

			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

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
				float4 temp_output_1_0_g31 = tex2D( _MainTex, uv_MainTex );
				float3 temp_output_2_0_g31 = (temp_output_1_0_g31).rgb;
				float4 break2_g32 = float4( temp_output_2_0_g31 , 0.0 );
				float temp_output_9_0_g33 = max( _ColorReplaceContrast , 0.0 );
				float saferPower7_g33 = max( ( ( ( break2_g32.x + break2_g32.y + break2_g32.z ) / 3.0 ) + ( 0.1 * max( ( 1.0 - temp_output_9_0_g33 ) , 0.0 ) ) ) , 0.0001 );
				float3 hsvTorgb7_g31 = RGBToHSV( (_ColorReplaceTargetColor).rgb );
				float3 hsvTorgb5_g31 = RGBToHSV( temp_output_2_0_g31 );
				float clampResult35_g31 = clamp( ( 1.0 - ( min( min( distance( hsvTorgb7_g31.x , hsvTorgb5_g31.x ) , distance( hsvTorgb7_g31.x , ( hsvTorgb5_g31.x + 1.0 ) ) ) , distance( hsvTorgb7_g31.x , ( hsvTorgb5_g31.x + -1.0 ) ) ) / max( ( _ColorReplaceHueTolerance * 0.15 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float clampResult30_g31 = clamp( ( 1.0 - ( distance( hsvTorgb7_g31.y , hsvTorgb5_g31.y ) / max( ( _ColorReplaceSaturationTolerance * 2.0 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float clampResult40_g31 = clamp( ( 1.0 - ( distance( hsvTorgb7_g31.z , hsvTorgb5_g31.z ) / max( ( _ColorReplaceBrightnessTolerance * 1.5 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float saferPower48_g31 = max( ( clampResult35_g31 * clampResult30_g31 * clampResult40_g31 ) , 0.0001 );
				float3 lerpResult23_g31 = lerp( temp_output_2_0_g31 , ( pow( saferPower7_g33 , temp_output_9_0_g33 ) * (_ColorReplaceColor).rgb ) , ( pow( saferPower48_g31 , max( _ColorReplaceBias , 0.001 ) ) * _ColorReplaceFade ));
				float4 appendResult4_g31 = (float4(lerpResult23_g31 , temp_output_1_0_g31.a));
				
				float2 temp_output_8_0_g34 = IN.texCoord0.xy;
				float3 unpack14_g34 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g34 ), _NormalIntensity );
				unpack14_g34.z = lerp( 1, unpack14_g34.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult4_g31 * IN.color );
				float3 Normal = unpack14_g34;
				
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
			#define ASE_SRP_VERSION 70403

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


			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _ColorReplaceColor;
			float4 _ColorReplaceTargetColor;
			float _ColorReplaceContrast;
			float _ColorReplaceHueTolerance;
			float _ColorReplaceSaturationTolerance;
			float _ColorReplaceBrightnessTolerance;
			float _ColorReplaceBias;
			float _ColorReplaceFade;
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

			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

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
				float4 temp_output_1_0_g31 = tex2D( _MainTex, uv_MainTex );
				float3 temp_output_2_0_g31 = (temp_output_1_0_g31).rgb;
				float4 break2_g32 = float4( temp_output_2_0_g31 , 0.0 );
				float temp_output_9_0_g33 = max( _ColorReplaceContrast , 0.0 );
				float saferPower7_g33 = max( ( ( ( break2_g32.x + break2_g32.y + break2_g32.z ) / 3.0 ) + ( 0.1 * max( ( 1.0 - temp_output_9_0_g33 ) , 0.0 ) ) ) , 0.0001 );
				float3 hsvTorgb7_g31 = RGBToHSV( (_ColorReplaceTargetColor).rgb );
				float3 hsvTorgb5_g31 = RGBToHSV( temp_output_2_0_g31 );
				float clampResult35_g31 = clamp( ( 1.0 - ( min( min( distance( hsvTorgb7_g31.x , hsvTorgb5_g31.x ) , distance( hsvTorgb7_g31.x , ( hsvTorgb5_g31.x + 1.0 ) ) ) , distance( hsvTorgb7_g31.x , ( hsvTorgb5_g31.x + -1.0 ) ) ) / max( ( _ColorReplaceHueTolerance * 0.15 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float clampResult30_g31 = clamp( ( 1.0 - ( distance( hsvTorgb7_g31.y , hsvTorgb5_g31.y ) / max( ( _ColorReplaceSaturationTolerance * 2.0 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float clampResult40_g31 = clamp( ( 1.0 - ( distance( hsvTorgb7_g31.z , hsvTorgb5_g31.z ) / max( ( _ColorReplaceBrightnessTolerance * 1.5 ) , 0.001 ) ) ) , 0.0 , 1.0 );
				float saferPower48_g31 = max( ( clampResult35_g31 * clampResult30_g31 * clampResult40_g31 ) , 0.0001 );
				float3 lerpResult23_g31 = lerp( temp_output_2_0_g31 , ( pow( saferPower7_g33 , temp_output_9_0_g33 ) * (_ColorReplaceColor).rgb ) , ( pow( saferPower48_g31 , max( _ColorReplaceBias , 0.001 ) ) * _ColorReplaceFade ));
				float4 appendResult4_g31 = (float4(lerpResult23_g31 , temp_output_1_0_g31.a));
				
				float4 Color = ( appendResult4_g31 * IN.color );

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
Version=18800
200;111;1331;560;975.7965;567.2686;1.334285;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;70;-678.8817,-436.546;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;69;-368.8802,-311.4423;Inherit;True;Property;_TextureSample3;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;75;-18.09477,-180.5;Inherit;False;_ColorReplace;5;;31;626c705a4346bf34c8da30de12f2c574;0;1;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;66;220.6745,159.7954;Inherit;False;LitHandler;1;;34;851662d67a92ce04d84817ff63c501f2;0;1;8;FLOAT2;0,0;False;2;COLOR;0;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode;68;234.7509,-72.4296;Inherit;False;TintVertex;-1;;35;b0b94dd27c0f3da49a89feecae766dcc;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;16;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;12;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=NormalsRendering;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;17;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;12;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;15;506.5879,57.29841;Float;False;True;-1;2;SpriteShadersUltimate.SingleShaderGUI;0;12;Sprite Shaders Ultimate/URP Lit/Color/Color Replace Lit;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;1;Vertex Position;1;0;3;True;True;True;False;;False;0
WireConnection;69;0;70;0
WireConnection;75;1;69;0
WireConnection;68;1;75;0
WireConnection;15;1;68;0
WireConnection;15;2;66;0
WireConnection;15;3;66;5
ASEEND*/
//CHKSM=DD67812D54E48C46CFC3E13517E76C9D62DC1867