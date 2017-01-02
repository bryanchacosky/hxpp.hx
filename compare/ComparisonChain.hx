package compare;

/**
 * Helper class to wrap multiple comparisons into a single compare function.
 *
 * Usage:
 *      array.sort(
 *          new ComparisonChain()
 *              .pushItem("first_item")
 *              .push(Strings.compare)
 *              .compare));
 *
 * @see ComparisonChain.compare
 */
class ComparisonChain<T>
{
    /**
     * Reverses a comparison function.
     */
    public static function reverse<T> (comparator:T -> T -> Int) : T -> T -> Int
    {
        return function(a, b) { return comparator(a, b) * -1; };
    }

    public function new ()
    {
        this.comparators = [];
    }

    /**
     * Pushes a comparison function to the chain.
     *
     * @return this
     */
    public function push (comparator:T -> T -> Int) : ComparisonChain<T>
    {
        this.comparators.push(comparator);
        return this;
    }

    /**
     * Helper method to push a comparison function promoting
     * a specific value.
     *
     * @return this
     */
    public function pushItem (value:T) : ComparisonChain<T>
    {
        this.comparators.push(function(a, b) {
                if (a == value) return -1;
                if (b == value) return  1;
                return 0;
            });
        return this;
    }

    /**
     * Compares two T objects using the pushed comparators. The first
     * comparator to return non-zero will be the result. If no comparators
     * return non-zero, the T objects are considered equal.
     *
     * This function can be passed directly to most sort methods.
     *
     * @return comparison result
     */
    public function compare (a:T, b:T) : Int
    {
        for (comparator in this.comparators) {
            var result:Int = comparator(a, b);
            if (result != 0) {
                return result;
            }
        }

        return 0;
    }

    /**
     * Reverses the comparison function.
     *
     * @see compare
     * @return comparison result
     */
    public function reverseCompare (a:T, b:T) : Int
    {
        return compare(a, b) * -1;
    }

    private var comparators:Array<T -> T -> Int>;   // comparator functions
}
