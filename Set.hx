package;

/**
 * Set implementation.
 */
class Set<T>
{
    /**
     * Creates a new Set with the contents of an array.
     */
    public static function withArray<T> (array:Array<T>) : Set<T>
    {
        var instance = new Set<T>();
        for (item in array) instance.push(item);
        return instance;
    }

    /** Returns the length of the set. */
    public var length (get, never) : Int;
        function get_length () : Int { return _values.length; }

    public function new ()
    {
        _values = [];
    }

    /**
     * Returns an iterator over the values in the set.
     */
    public function iterator () : Iterator<T>
    {
        return _values.iterator();
    }

    /**
     * Returns true if this set is empty.
     */
    public function isEmpty () : Bool
    {
        return this.length == 0;
    }

    /**
     * Returns true if the value is contained in the set.
     */
    public function contains (x:T) : Bool
    {
        return Arrays.contains(_values, x);
    }

    /**
     * Pushes a value into the set.
     *
     * @return success
     */
    public function push (x:T) : Bool
    {
        if (contains(x) == false) {
            _values.push(x);
            return true;
        }
        return false;
    }

    /**
     * Removes a value from the set.
     *
     * @return success
     */
    public function remove (x:T) : Bool
    {
        var index:Int = _values.indexOf(x);
        if (index == -1) return false;
        _values = _values.splice(index, 1);
        return true;
    }

    public function toString () : String
    {
        return _values.toString();
    }

    /** Internal values. */
    private var _values:Array<T>;
}
