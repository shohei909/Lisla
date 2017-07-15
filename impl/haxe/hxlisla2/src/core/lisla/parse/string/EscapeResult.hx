package lisla.parse.string;

enum EscapeResult 
{
    Continue;
    Interpolate;
    Letter(letter:String);
}
