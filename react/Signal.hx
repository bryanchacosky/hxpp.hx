package react;

/**
 * Asynchronous signal implementation.
 *
 * Usage:
 *      var signal = new Signal<String>();
 *      signal
 *          .push(function(r) { ... use result ... })
 *          .setPredicate(function(r) { ... check result value })
 *          .once();
 *      signal.dispatch("result");
 */
@:generic
class Signal<T>
{
    public function new ()
    {
        this.callbacks = [];
    }

    /**
     * Pushes a callback to be called when `dispatch()` is called.
     *
     * @return Signal.Callback
     */
    public function push (callback:T -> Void) : Callback<T>
    {
        var disconnect = function(c) { this.callbacks.remove(c); };
        var instance = new Callback<T>(callback, disconnect);
        this.callbacks.push(instance);
        return instance;
    }

    /**
     * Removes the first callback with the given callback function.
     *
     * @return this
     */
    public function remove (callback:T -> Void) : Signal<T>
    {
        for (c in this.callbacks) {
            if (c.callback == callback) {
                c.disconnect();
                break;
            }
        }
        return this;
    }

    /**
     * Removes all callbacks.
     *
     * @return this
     */
    public function clear () : Signal<T>
    {
        for (callback in this.callbacks) {
            callback.disconnect();
        }
        return this;
    }

    /**
     * Dispatches the value to the registered callbacks.
     *
     * @return this
     */
    public function dispatch (?value:T) : Signal<T>
    {
        for (callback in this.callbacks) {
            callback.notify(value);
        }
        return this;
    }

    private var callbacks:Array<Callback<T>>;   // registered callbacks
}

/**
 * Signal callback.
 */
@:generic @:allow(react.Signal)
class Callback<T>
{
    /**
     * Sets the predicate using object equality.
     *
     * @see setPredicate()
     * @return this
     */
    public function setValuePredicate (value:T) : Callback<T>
    {
        return setPredicate(function(v) { return v == value; });
    }

    /**
     * Sets the predicate to be checked before the callback is notified.
     * If the dispatched value fails the predicate, the callback function
     * will not be called.
     *
     * @return this
     */
    public function setPredicate (predicate:T -> Bool) : Callback<T>
    {
        this.predicate = predicate;
        return this;
    }

    /**
     * Sets this callback to be disconnected after the next successful
     * dispatch.
     *
     * @return this
     */
    public function once () : Callback<T>
    {
        var ocallback = this.callback;
        this.callback = function(value) {
                ocallback(value);   // call the original callback
                disconnect();       // disconnect the listener
            };
        return this;
    }

    /**
     * Disconnects the callback from the Signal.
     * Multiple calls to disconnect() are safe.
     */
    public function disconnect ()
    {
        this.callback = null;
        if (this.signal_disconnect != null) {
            this.signal_disconnect(this);
            this.signal_disconnect = null;
        }
    }

    private function new (callback:T -> Void, signal_disconnect:Callback<T> -> Void)
    {
        this.signal_disconnect = signal_disconnect;
        this.callback          = callback;
    }

    /**
     * Notifies the callback function with the given value.
     *
     * @return true if the callback was called
     */
    private function notify (value:T) : Bool
    {
        if (this.predicate == null || this.predicate(value)) {
            this.callback(value);
            return true;
        }
        return false;
    }

    private var signal_disconnect:Callback<T> -> Void;  // disconnects from the parent
    private var          callback:T -> Void;            // callback function
    private var         predicate:T -> Bool;            // callback predicate
}

/** Signal specialization for Void. */
class Signal_Void
{
    public function new ()
    {
        this.callbacks = [];
    }

    /** @see Signal<T>.push */
    public function push (callback:Void -> Void) : Callback<Void>
    {
        var disconnect = function(c) { this.callbacks.remove(c); };
        var instance = new Callback<Void>(callback, disconnect);
        this.callbacks.push(instance);
        return instance;
    }

    /** @see Signal<T>.remove */
    public function remove (callback:Void -> Void) : Signal<Void>
    {
        for (c in this.callbacks) {
            if (c.callback == callback) {
                c.disconnect();
                break;
            }
        }
        return this;
    }

    /** @see Signal<T>.clear */
    public function clear () : Signal<Void>
    {
        for (callback in this.callbacks) {
            callback.disconnect();
        }
        return this;
    }

    /** @see Signal<T>.dispatch */
    public function dispatch () : Signal<Void>
    {
        for (callback in this.callbacks) {
            callback.notify();
        }
        return this;
    }

    private var callbacks:Array<Callback<Void>>;   // registered callbacks
}

/** Callback specialization for Void. */
@:allow(react.Signal_Void)
class Callback_Void
{
    /** @see Callback<T>.once */
    public function once () : Callback<Void>
    {
        var ocallback = this.callback;
        this.callback = function() {
                ocallback();    // call the original callback
                disconnect();   // disconnect the listener
            };
        return this;
    }

    /** @see Callback<T>.disconnect */
    public function disconnect ()
    {
        this.callback = null;
        if (this.signal_disconnect != null) {
            this.signal_disconnect(this);
            this.signal_disconnect = null;
        }
    }

    private function new (callback:Void -> Void, signal_disconnect:Callback<Void> -> Void)
    {
        this.signal_disconnect = signal_disconnect;
        this.callback          = callback;
    }

    /** @see Callback<T>.notify */
    private function notify () : Bool
    {
        this.callback();
        return true;
    }

    private var signal_disconnect:Callback<Void> -> Void;   // disconnects from the parent
    private var          callback:Void -> Void;             // callback function
}
