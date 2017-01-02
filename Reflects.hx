package;

/**
 * Reflection utility methods.
 */
class Reflects
{
    /**
     * Returns the result of Reflect.getProperty(), or <code>defvalue</code>
     * if the result is null.
     */
    public static function getProperty (object:Dynamic, property:String, ?defvalue:Dynamic) : Dynamic
    {
        var result:Dynamic = Reflect.getProperty(object, property);
        return result == null ? defvalue : result;
    }

    /**
     * Returns true if the two objects are equal.
     *
     * Objects are considered equal if they have the same reflection fields
     * and each respective value for the field is equal.
     */
    public static function equals (a:Dynamic, b:Dynamic) : Bool
    {
        // basic object equality
        if (a == b) {
            return true;
        }

        // pull the fields in a, return false for plain-old datas
        var afields:Array<String> = Reflect.fields(a);
        if (afields.length == 0) {
            return false;
        }

        // fields in a must exist in b
        for (afieldname in afields) {
            if (Reflect.hasField(b, afieldname) == false) {
                return false;
            }

            // value in a must equal value in b
            var avalue:Dynamic = Reflect.field(a, afieldname);
            var bvalue:Dynamic = Reflect.field(b, afieldname);
            if (equals(avalue, bvalue) == false) {
                return false;
            }
        }

        // fields in b must exist in a
        for (bfieldname in Reflect.fields(b)) {
            if (Reflect.hasField(a, bfieldname) == false) {
                return false;
            }
        }

        return true;
    }
}
