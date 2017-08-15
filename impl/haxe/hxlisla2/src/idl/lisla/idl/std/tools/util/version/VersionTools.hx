package lisla.idl.std.tools.util.version;

class VersionTools 
{
    public static function compare(versionString1:String, versionString2:String):Int
    {
        var array1 = versionString1.split(".");
        var array2 = versionString2.split(".");
        var len1 = array1.length;
        var len2 = array2.length;
        var min = if (len1 < len2) len1 else len2;
        
        for (i in 0...min)
        {
            var pair1 = array1[i].split("-");
            var pair2 = array2[i].split("-");
            var num1 = Std.parseInt(pair1[0]);
            var num2 = Std.parseInt(pair2[0]);
            
            if (num1 < num2) return -1;
            if (num1 > num2) return 1;
            
            if (pair1.length == 1 && pair2.length == 1) continue;
            if (pair1.length > 1 && pair2.length == 1) return -1;
            if (pair1.length == 1 && pair2.length > 1) return 1;
            
            var suffix1 = pair1[1];
            var suffix2 = pair2[1];
            
            if (suffix1 < suffix2) return -1;
            if (suffix1 > suffix2) return 1;
        }
        
        if (len1 < len2) return -1;
        if (len1 > len2) return 1;
        
        return 0;
    }
}
