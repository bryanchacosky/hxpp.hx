package;

/**
 * Multiset implementation.
 */
class Multiset<T>
{
    public function new ()
    {
        this.elements = [];
    }

    /**
     * Adds `occurrences` of the specified element to the multiset.
     *
     * @return updated element count
     */
    public function push (t:T, occurrences:Int = 1) : Int
    {
        Assert.check(occurrences > 0);

        // pull the existing element, creating a new one if necessary
        var element:MultisetElement<T> = getMultisetElement(t);
        if (element == null) {
            element = { element : t, count : 0 };
            this.elements.push(element);
        }

        return element.count += occurrences;
    }

    /**
     * Removes `occurrences` of the specified element from the multiset.
     *
     * @return updated element count
     */
    public function remove (t:T, occurrences:Int = 1) : Int
    {
        Assert.check(occurrences > 0);

        // pull the existing element
        var element:MultisetElement<T> = getMultisetElement(t);
        if (element == null) return 0;

        // prevent negative occurrences
        if (occurrences >= element.count) {
            this.elements.remove(element);
            return 0;
        }

        return element.count -= occurrences;
    }

    /**
     * Sets the number of occurrences of the specified element in the multiset.
     *
     * @return updated element count
     */
    public function set (t:T, occurrences:Int) : Int
    {
        Assert.check(occurrences >= 0);

        // pull the existing element, and set the count
        var element:MultisetElement<T> = getMultisetElement(t);
        if (element == null) this.elements.push({ element : t, count : occurrences });
        else                 element.count = occurrences;
        return occurrences;
    }

    /**
     * Returns the current element count.
     */
    public function count (t:T) : Int
    {
        var element:MultisetElement<T> = getMultisetElement(t);
        return element == null ? 0 : element.count;
    }

    /**
     * Returns true if the multiset contains at least one of the specified element.
     */
    public function contains (t:T) : Bool
    {
        return count(t) != 0;
    }

    /**
     * Returns an interator over the elements in the multiset.
     */
    public function iterator () : Iterator<T>
    {
        return new MultisetIterator(this);
    }

    public function toString () : String
    {
        return this.elements.map(function(e) {
                return "{ " + e.element + " => " + e.count + " }";
            }).toString();
    }

    /**
     * Returns the MultisetElement with the specified T value, or null.
     */
    private function getMultisetElement (t:T) : MultisetElement<T>
    {
        for (element in this.elements) {
            if (element.element == t) {
                return element;
            }
        }
        return null;
    }

    /** Private elements data. */
    private var elements:Array<MultisetElement<T>>;
}

/** Multiset iterator. */
@:access(Multiset)
private class MultisetIterator<T>
{
    public var multiset:Multiset<T>;    // root Multiset
    public var index:Int;               // index

    public function new (multiset:Multiset<T>)
    {
        this.multiset = multiset;
        this.index    = 0;
    }

    // override from Iterator
    public function hasNext () : Bool
    {
        return this.index < this.multiset.elements.length;
    }

    // override from Iterator
    public function next () : T
    {
        return this.multiset.elements[this.index++].element;
    }
}

/** Multiset element. */
private typedef MultisetElement<T> = {
    public var element:T;   // T element
    public var count:Int;   // occurrences
}
