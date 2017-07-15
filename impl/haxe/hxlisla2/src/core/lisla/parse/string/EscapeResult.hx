package lisla.parse.string;

enum EscapeResult 
{
    Continue;
    Letter(letter:String);
}
