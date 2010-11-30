
// this is an effect template. use it to start writing your own effects.

// -------------------------------------------------------------------------------------------------------------------------------------
// PARAMETERS:
// -------------------------------------------------------------------------------------------------------------------------------------

//transforms
float4x4 tW: WORLD;                  //the models world matrix
float4x4 tV: VIEW;                   //view matrix as set via Renderer (DX9)
float4x4 tP: PROJECTION;             //projection matrix as set via Renderer (DX9)
float4x4 tWVP: WORLDVIEWPROJECTION;  //WORLD*VIEW*PROJECTION


//the vvvv pins are defined here:
texture Tex <string uiname="Texture";>;
float4x4 tTex <string uiname="Texture Transform";>; //Texture Transform
//

float time <string uiname="Time";>;
float4 bodycolor: color <string uiname="Body Color";> ;



sampler Samp = sampler_state    //sampler for doing the texture-lookup
{
    Texture   = (Tex);          //apply a texture to the sampler
    MipFilter = LINEAR;         //set the sampler states
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};


// -------------------------------------------------------------------------------------------------------------------------------------
// VERTEXSHADERS
// -------------------------------------------------------------------------------------------------------------------------------------

struct VS_OUTPUT
{
    float4 Pos  : POSITION;
    float2 TexC : TEXCOORD0;
};


VS_OUTPUT VS(
    float4 Pos  : POSITION,
    float2 TexC : TEXCOORD)
{
    //inititalize all fields of output struct with 0
    VS_OUTPUT Out = (VS_OUTPUT)0;



    ///
 //   float angle=(time%360)*100;
    //Pos.z = sin(Pos.x*angle*10);
    //Pos.y = tan(Pos.y);
   // Pos.z+= sin(Pos.y/2+angle);
    //Pos.x  = sin( Pos.x+angle);
    //Pos.x = cos(Pos.y*angle*10);

    ////

      //transform vertex position
    Pos = mul(Pos, tWVP);

    //transform texturecoordinates
    TexC = mul(TexC, tTex);
        Out.Pos  = Pos;
    Out.TexC = TexC;

    return Out;
}

// -------------------------------------------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// -------------------------------------------------------------------------------------------------------------------------------------

float4 PS(float4 TexC: TEXCOORD0): COLOR
{
    float4 col = bodycolor;



    return col;
}

// -------------------------------------------------------------------------------------------------------------------------------------
// TECHNIQUES:
// -------------------------------------------------------------------------------------------------------------------------------------

technique ColorChange
{
    pass P0
    {
        VertexShader = compile vs_1_1 VS();
        PixelShader  = compile ps_1_4 PS();
    }
}
