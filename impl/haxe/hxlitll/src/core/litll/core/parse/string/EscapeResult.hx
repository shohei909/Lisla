package lisla.core.parse.string;

enum EscapeResult 
{
    Continue;
    Interpolate;
    Letter(letter:String);
}
