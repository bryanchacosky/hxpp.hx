package;

/**
 * Map utility methods.
 */
class Maps
{
    /**
     * Returns the existing value in the map for the key, or the default value
     * if the key does not exist.
     */
    public static function get<K, V> (map:Map<K, V>, key:K, defvalue:V) : V
    {
        return map.exists(key) ? map.get(key) : defvalue;
    }

    /**
     * Map .toString() example: { key => value}
     * Maps.toString() example: { key => value }
     */
    public static function toString<K, V> (map:Map<K, V>) : String
    {
        var string:String = map.toString();
        string = string.substring(0, string.length - 1);
        return string + " }";
    }

    /**
     * Returns true if the two maps are equal.
     *
     * Maps are considered equal if they have the same set of keys and
     * each value at the respective key is equal in both maps.
     */
    public static function equals<K, V> (a:Map<K, V>, b:Map<K, V>) : Bool
    {
        // keys in a must exist in b
        for (akey in a.keys()) {
            if (b.exists(akey) == false) {
                return false;
            }

            // value in a must equal value in b
            var avalue:V = a.get(akey);
            var bvalue:V = b.get(akey);
            if (avalue != bvalue) {
                return false;
            }
        }

        // keys in b must exist in a
        for (bkey in b.keys()) {
            if (a.exists(bkey) == false) {
                return false;
            }
        }

        return true;
    }
}
