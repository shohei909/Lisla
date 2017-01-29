package litll.core.parse.string;

enum EscapeResult 
{
    Continue;
    Interpolate;
    Letter(letter:String);
}
