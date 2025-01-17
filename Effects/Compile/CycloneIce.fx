float2 NoiseOffset;
float brightness;
float MainScale;
float2 CenterPoint;
float2 TrailDirection;
float width;
float distort;
float2 Resolution;

float3 startColor;
float3 endColor;

texture sampleTexture;
sampler2D Texture1Sampler = sampler_state { texture = <sampleTexture>; magfilter = LINEAR; minfilter = LINEAR; mipfilter = LINEAR; AddressU = wrap; AddressV = wrap; };

texture sampleTexture2;
sampler2D NoiseMap = sampler_state { texture = <sampleTexture2>; magfilter = LINEAR; minfilter = LINEAR; mipfilter = LINEAR; AddressU = wrap; AddressV = wrap; };

matrix transformMatrix;

struct VertexShaderInput
{
    float4 Position : POSITION;
    float2 TexCoords : TEXCOORD0;
    float4 Color : COLOR0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION;
    float2 TexCoords : TEXCOORD0;
    float4 Color : COLOR0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
    
    output.Color = input.Color;
    output.TexCoords = input.TexCoords;
    output.Position = mul(input.Position, transformMatrix);

    return output;
}

float4 main(VertexShaderOutput input) : COLOR0 
{
	float2 uv = float2(input.TexCoords.y, input.TexCoords.x);
	float3 mainColor = lerp(startColor,endColor,uv.y * uv.y);
	//float scale = MainScale / Zoom;
	float4 original = tex2D(Texture1Sampler, uv);

	float2 uvCorrect = uv;
	uvCorrect.y *= Resolution.y / Resolution.x;
	uvCorrect.y += (1 - (Resolution.y / Resolution.x)) / 2;

	float2 centerDistance = uvCorrect - CenterPoint;

	float2 inputDirection = normalize(TrailDirection);
	float2 uvDirection = normalize(centerDistance);


	float dist = length(centerDistance);
	float distScale = dist / MainScale;


	float checkDir = dot(inputDirection, uvDirection);

	float widthTaper = width + (distScale * (1 - (width)));

	if (checkDir > widthTaper)  //checkDir > width && dist < radius
	{
		//return float4(1, 1, 1, 1);
		//return tex2D(NoiseMap, uv); //* (checkDir - widthTaper) * brightness;
		float4 secondColor = tex2D(NoiseMap, (uvCorrect - CenterPoint + NoiseOffset) + ((inputDirection + uvDirection) * checkDir * distort));
		return secondColor * float4(mainColor, 1) * (checkDir - widthTaper) * brightness;
	}

	return float4(0,0,0,0);
}


technique Technique1
{
	pass CyclonePass
	{
		VertexShader = compile vs_2_0 VertexShaderFunction();
		PixelShader = compile ps_2_0 main();
	}
};

