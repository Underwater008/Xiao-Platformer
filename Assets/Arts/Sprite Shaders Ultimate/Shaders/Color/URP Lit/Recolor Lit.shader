// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprite Shaders Ultimate/URP Lit/Color/Recolor Lit"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[ASEBegin]_MainTex("MainTex", 2D) = "white" {}
		_MaskMap("Mask Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 3)) = 1
		_RecolorFade("Recolor: Fade", Range( 0 , 1)) = 1
		_RecolorTintAreas("Recolor: Tint Areas", 2D) = "white" {}
		[HDR]_RecolorRedTint("Recolor: Red Tint", Color) = (1,1,1,0.5019608)
		[HDR]_RecolorYellowTint("Recolor: Yellow Tint", Color) = (1,1,1,0.5019608)
		[HDR]_RecolorGreenTint("Recolor: Green Tint", Color) = (1,1,1,0.5019608)
		[HDR]_RecolorCyanTint("Recolor: Cyan Tint", Color) = (1,1,1,0.5019608)
		[HDR]_RecolorBlueTint("Recolor: Blue Tint", Color) = (1,1,1,0.5019608)
		[ASEEnd][HDR]_RecolorPurpleTint("Recolor: Purple Tint", Color) = (1,1,1,0.5019608)
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
			sampler2D _RecolorTintAreas;
			sampler2D _MaskMap;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _RecolorTintAreas_ST;
			float4 _RecolorPurpleTint;
			float4 _RecolorBlueTint;
			float4 _RecolorCyanTint;
			float4 _RecolorGreenTint;
			float4 _RecolorYellowTint;
			float4 _RecolorRedTint;
			float _RecolorFade;
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
				float4 temp_output_1_0_g24 = tex2D( _MainTex, uv_MainTex );
				float2 uv_RecolorTintAreas = IN.texCoord0.xy * _RecolorTintAreas_ST.xy + _RecolorTintAreas_ST.zw;
				float3 hsvTorgb33_g24 = RGBToHSV( tex2D( _RecolorTintAreas, uv_RecolorTintAreas ).rgb );
				float temp_output_43_0_g24 = ( ( hsvTorgb33_g24.x + 0.08333334 ) % 1.0 );
				float4 ifLocalVar46_g24 = 0;
				if( temp_output_43_0_g24 >= 0.8333333 )
				ifLocalVar46_g24 = _RecolorPurpleTint;
				else
				ifLocalVar46_g24 = _RecolorBlueTint;
				float4 ifLocalVar44_g24 = 0;
				if( temp_output_43_0_g24 <= 0.6666667 )
				ifLocalVar44_g24 = _RecolorCyanTint;
				else
				ifLocalVar44_g24 = ifLocalVar46_g24;
				float4 ifLocalVar47_g24 = 0;
				if( temp_output_43_0_g24 <= 0.3333333 )
				ifLocalVar47_g24 = _RecolorYellowTint;
				else
				ifLocalVar47_g24 = _RecolorGreenTint;
				float4 ifLocalVar45_g24 = 0;
				if( temp_output_43_0_g24 <= 0.1666667 )
				ifLocalVar45_g24 = _RecolorRedTint;
				else
				ifLocalVar45_g24 = ifLocalVar47_g24;
				float4 ifLocalVar35_g24 = 0;
				if( temp_output_43_0_g24 >= 0.5 )
				ifLocalVar35_g24 = ifLocalVar44_g24;
				else
				ifLocalVar35_g24 = ifLocalVar45_g24;
				float4 break55_g24 = ifLocalVar35_g24;
				float3 appendResult56_g24 = (float3(break55_g24.r , break55_g24.g , break55_g24.b));
				float4 break2_g25 = temp_output_1_0_g24;
				float3 lerpResult26_g24 = lerp( (temp_output_1_0_g24).rgb , ( appendResult56_g24 * pow( ( ( break2_g25.x + break2_g25.y + break2_g25.z ) / 3.0 ) , max( ( break55_g24.a * 2.0 ) , 0.01 ) ) ) , ( hsvTorgb33_g24.z * _RecolorFade ));
				float4 appendResult30_g24 = (float4(lerpResult26_g24 , temp_output_1_0_g24.a));
				
				float2 temp_output_8_0_g26 = IN.texCoord0.xy;
				
				float3 unpack14_g26 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g26 ), _NormalIntensity );
				unpack14_g26.z = lerp( 1, unpack14_g26.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult30_g24 * IN.ase_color );
				float Mask = tex2D( _MaskMap, temp_output_8_0_g26 ).r;
				float3 Normal = unpack14_g26;

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
			sampler2D _RecolorTintAreas;
			sampler2D _NormalMap;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _RecolorTintAreas_ST;
			float4 _RecolorPurpleTint;
			float4 _RecolorBlueTint;
			float4 _RecolorCyanTint;
			float4 _RecolorGreenTint;
			float4 _RecolorYellowTint;
			float4 _RecolorRedTint;
			float _RecolorFade;
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
				float4 temp_output_1_0_g24 = tex2D( _MainTex, uv_MainTex );
				float2 uv_RecolorTintAreas = IN.texCoord0.xy * _RecolorTintAreas_ST.xy + _RecolorTintAreas_ST.zw;
				float3 hsvTorgb33_g24 = RGBToHSV( tex2D( _RecolorTintAreas, uv_RecolorTintAreas ).rgb );
				float temp_output_43_0_g24 = ( ( hsvTorgb33_g24.x + 0.08333334 ) % 1.0 );
				float4 ifLocalVar46_g24 = 0;
				if( temp_output_43_0_g24 >= 0.8333333 )
				ifLocalVar46_g24 = _RecolorPurpleTint;
				else
				ifLocalVar46_g24 = _RecolorBlueTint;
				float4 ifLocalVar44_g24 = 0;
				if( temp_output_43_0_g24 <= 0.6666667 )
				ifLocalVar44_g24 = _RecolorCyanTint;
				else
				ifLocalVar44_g24 = ifLocalVar46_g24;
				float4 ifLocalVar47_g24 = 0;
				if( temp_output_43_0_g24 <= 0.3333333 )
				ifLocalVar47_g24 = _RecolorYellowTint;
				else
				ifLocalVar47_g24 = _RecolorGreenTint;
				float4 ifLocalVar45_g24 = 0;
				if( temp_output_43_0_g24 <= 0.1666667 )
				ifLocalVar45_g24 = _RecolorRedTint;
				else
				ifLocalVar45_g24 = ifLocalVar47_g24;
				float4 ifLocalVar35_g24 = 0;
				if( temp_output_43_0_g24 >= 0.5 )
				ifLocalVar35_g24 = ifLocalVar44_g24;
				else
				ifLocalVar35_g24 = ifLocalVar45_g24;
				float4 break55_g24 = ifLocalVar35_g24;
				float3 appendResult56_g24 = (float3(break55_g24.r , break55_g24.g , break55_g24.b));
				float4 break2_g25 = temp_output_1_0_g24;
				float3 lerpResult26_g24 = lerp( (temp_output_1_0_g24).rgb , ( appendResult56_g24 * pow( ( ( break2_g25.x + break2_g25.y + break2_g25.z ) / 3.0 ) , max( ( break55_g24.a * 2.0 ) , 0.01 ) ) ) , ( hsvTorgb33_g24.z * _RecolorFade ));
				float4 appendResult30_g24 = (float4(lerpResult26_g24 , temp_output_1_0_g24.a));
				
				float2 temp_output_8_0_g26 = IN.texCoord0.xy;
				float3 unpack14_g26 = UnpackNormalScale( tex2D( _NormalMap, temp_output_8_0_g26 ), _NormalIntensity );
				unpack14_g26.z = lerp( 1, unpack14_g26.z, saturate(_NormalIntensity) );
				
				float4 Color = ( appendResult30_g24 * IN.color );
				float3 Normal = unpack14_g26;
				
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
			sampler2D _RecolorTintAreas;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _RecolorTintAreas_ST;
			float4 _RecolorPurpleTint;
			float4 _RecolorBlueTint;
			float4 _RecolorCyanTint;
			float4 _RecolorGreenTint;
			float4 _RecolorYellowTint;
			float4 _RecolorRedTint;
			float _RecolorFade;
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
				float4 temp_output_1_0_g24 = tex2D( _MainTex, uv_MainTex );
				float2 uv_RecolorTintAreas = IN.texCoord0.xy * _RecolorTintAreas_ST.xy + _RecolorTintAreas_ST.zw;
				float3 hsvTorgb33_g24 = RGBToHSV( tex2D( _RecolorTintAreas, uv_RecolorTintAreas ).rgb );
				float temp_output_43_0_g24 = ( ( hsvTorgb33_g24.x + 0.08333334 ) % 1.0 );
				float4 ifLocalVar46_g24 = 0;
				if( temp_output_43_0_g24 >= 0.8333333 )
				ifLocalVar46_g24 = _RecolorPurpleTint;
				else
				ifLocalVar46_g24 = _RecolorBlueTint;
				float4 ifLocalVar44_g24 = 0;
				if( temp_output_43_0_g24 <= 0.6666667 )
				ifLocalVar44_g24 = _RecolorCyanTint;
				else
				ifLocalVar44_g24 = ifLocalVar46_g24;
				float4 ifLocalVar47_g24 = 0;
				if( temp_output_43_0_g24 <= 0.3333333 )
				ifLocalVar47_g24 = _RecolorYellowTint;
				else
				ifLocalVar47_g24 = _RecolorGreenTint;
				float4 ifLocalVar45_g24 = 0;
				if( temp_output_43_0_g24 <= 0.1666667 )
				ifLocalVar45_g24 = _RecolorRedTint;
				else
				ifLocalVar45_g24 = ifLocalVar47_g24;
				float4 ifLocalVar35_g24 = 0;
				if( temp_output_43_0_g24 >= 0.5 )
				ifLocalVar35_g24 = ifLocalVar44_g24;
				else
				ifLocalVar35_g24 = ifLocalVar45_g24;
				float4 break55_g24 = ifLocalVar35_g24;
				float3 appendResult56_g24 = (float3(break55_g24.r , break55_g24.g , break55_g24.b));
				float4 break2_g25 = temp_output_1_0_g24;
				float3 lerpResult26_g24 = lerp( (temp_output_1_0_g24).rgb , ( appendResult56_g24 * pow( ( ( break2_g25.x + break2_g25.y + break2_g25.z ) / 3.0 ) , max( ( break55_g24.a * 2.0 ) , 0.01 ) ) ) , ( hsvTorgb33_g24.z * _RecolorFade ));
				float4 appendResult30_g24 = (float4(lerpResult26_g24 , temp_output_1_0_g24.a));
				
				float4 Color = ( appendResult30_g24 * IN.color );

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
270;114;1338;608;838.0188;599.0405;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;70;-678.8817,-437.8803;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;69;-368.8802,-311.4423;Inherit;True;Property;_TextureSample3;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;71;-28.88196,-266.1295;Inherit;False;_Recolor;5;;24;d648533a061de38468cb13630c8ea7cf;0;1;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;66;220.6745,159.7954;Inherit;False;LitHandler;1;;26;851662d67a92ce04d84817ff63c501f2;0;1;8;FLOAT2;0,0;False;2;COLOR;0;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode;68;234.7509,-72.4296;Inherit;False;TintVertex;-1;;27;b0b94dd27c0f3da49a89feecae766dcc;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;16;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;12;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=NormalsRendering;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;17;112,96;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;12;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;15;506.5879,57.29841;Float;False;True;-1;2;SpriteShadersUltimate.SingleShaderGUI;0;12;Sprite Shaders Ultimate/URP Lit/Color/Recolor Lit;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;1;Vertex Position;1;0;3;True;True;True;False;;False;0
WireConnection;69;0;70;0
WireConnection;71;1;69;0
WireConnection;68;1;71;0
WireConnection;15;1;68;0
WireConnection;15;2;66;0
WireConnection;15;3;66;5
ASEEND*/
//CHKSM=649CBA9CB82004C02A80BCE1299143B3BF67DBF0