package react;

/**
 * Value wrapper that provides Signal-like methods to notify callbacks
 * of changes to the base value.
 *
 * Usage:
 *      var value = new Value<Int>(0);
 *      value.push(function(response) {
 *              ... use the response ...
 *              if (response == 10) {
 *                  response.disconnect();
 *              }
 *          }, true);
 *      value.set(10);
 */
abstract Value<T> ({ value:T, callbacks:Array<Response<T> -> Void> })
{
    @:to // implicit cast to T
    public function to_t () : T
    {
        return this.value;
    }

    /**
     * Explicit method to return the T value.
     */
    public function get () : T
    {
        return this.value;
    }

    /**
     * Sets the value. If the new value is different than the current
     * value or if `notify` is true, the callbacks will be notified
     * of the new value.
     */
    public function set (value:T, ?notify:Bool)
    {
        if (notify || this.value != value) {
            this.value = value;
            for (callback in this.callbacks) {
                callback(new Response(this.value, function() { remove(callback); }));
            }
        }
    }

    /**
     * Pushes a new callback to be notified of value changes.
     * If `notify` is true, the callback is called immediately
     * if the current value.
     *
     * @return callback
     */
    public function push (callback:Response<T> -> Void, ?notify:Bool) : Response<T> -> Void
    {
        this.callbacks.push(callback);
        if (notify) {
            callback(new Response(this.value, function() { remove(callback); }));
        }
        return callback;
    }

    /**
     * Removes a registered callback.
     */
    public function remove (callback:Response<T> -> Void)
    {
        this.callbacks.remove(callback);
    }

    public inline function new (value:T)
    {
        this = { value : value, callbacks : [] };
    }

    public function toString () : String
    {
        return Std.string(this.value);
    }
}

/** Value response. */
@:allow(react.Value)
abstract Response<T> ({ value:T, disconnect:Void -> Void })
{
    @:to // implicit cast to T
    public function to_t () : T
    {
        return this.value;
    }

    /**
     * Explicit method to return the T value.
     */
    public function get () : T
    {
        return this.value;
    }

    /**
     * Disconnects the callback from the Value.
     */
    public function disconnect ()
    {
        this.disconnect();
    }

    private inline function new (value:T, disconnect:Void -> Void)
    {
        this = { value : value, disconnect : disconnect };
    }

    public function toString () : String
    {
        return Std.string(this.value);
    }
}
