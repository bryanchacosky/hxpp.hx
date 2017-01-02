package;

/**
 * Array utility methods.
 */
class Arrays
{
    /**
     * Returns true if the array is empty.
     */
    public static function isEmpty<T> (array:Array<T>) : Bool
    {
        return !array.iterator().hasNext();
    }

    /**
     * Returns the first object in the array matching the predicate, or null if there
     * are no items in the array matching the predicate.
     */
    public static function first<T> (array:Array<T>, ?predicate:T -> Bool) : Null<T>
    {
        if (predicate == null) {
            return Arrays.isEmpty(array) ? null : array[0];
        } else {
            for (item in array) {
                if (predicate(item)) {
                    return item;
                }
            }
            return null;
        }
    }

    /**
     * Returns the last object in the array matching the predicate, or null if there
     * are no items in the array matching the predicate.
     */
    public static function last<T> (array:Array<T>, ?predicate:T -> Bool) : Null<T>
    {
        if (predicate == null) {
            return Arrays.isEmpty(array) ? null : array[array.length - 1];
        } else {
            for (i in 0 ... array.length) {
                var item:T = array[array.length - 1 - i];
                if (predicate(item)) {
                    return item;
                }
            }
            return null;
        }
    }

    /**
     * Returns the object in the array at the given index. If the index
     * is out of bounds of the array, null is returned.
     */
    public static function atIndex<T> (array:Array<T>, index:Int) : Null<T>
    {
        if (index < 0 || index >= array.length) return null;
        return array[index];
    }

    /**
     * Returns true if the object is containined in the array.
     */
    public static function contains<T> (array:Array<T>, t:T) : Bool
    {
        return array.indexOf(t) != -1;
    }

    /**
     * Removes the item at the given index.
     */
    public static function removeAt<T> (array:Array<T>, index:Int)
    {
        array = array.splice(index, 1);
    }

    /**
     * Returns true if the two arrays are equal.
     *
     * Arrays are considered equal if all elements are considered equal to
     * the other respective element.
     */
    public static function equals<T> (a:Array<T>, b:Array<T>) : Bool
    {
        // a must have the same number of elements are b
        if (a.length != b.length) {
            return false;
        }

        // each element in a should be equal to the respective element in b
        for (index in 0 ... a.length) {
            if (a[index] != b[index]) {
                return false;
            }
        }

        return true;
    }
}
