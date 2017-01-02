package react;

/**
 * Represents an asynchronous result.
 *
 * Usage:
 *      public function doAsync () : Future<String> {
 *          var promise = new Future<String>();
 *          ... do async work ...
 *          if (error != null) promise.setFailure(error);
 *          else               promise.setSuccess(result);
 *          return promise;
 *      }
 *
 *      doAsync()
 *          .onSuccess(function(r) { ... use result ... })
 *          .onFailure(function(e) { ... respond to error ... });
 */
@:generic
class Future<T>
{
    /**
     * Returns a Future representing an instant success.
     */
    public static function success<T> (value:T = null) : Future<T>
    {
        return Future.withResult({ value:value, success:true });
    }

    /**
     * Returns a Future representing an instant failure.
     */
    public static function failure<T> (error:Dynamic) : Future<T>
    {
        return Future.withResult({ value:error, success:false });
    }

    /**
     * Returns the value this Future was succeeded with.
     *
     * @throw String - if the Future has failed is still pending
     */
    public function getResult () : T
    {
        if (isSuccess()) return this.result.value;
        else             throw "Future.result() cannot be called on an unsuccessful instance.";
    }

    /**
     * Returns true if this Future has been completed.
     */
    public function isComplete () : Bool
    {
        return this.result != null;
    }

    /**
     * Returns true if this Future is complete and has completed successfully.
     */
    public function isSuccess () : Bool
    {
        return isComplete() && this.result.success;
    }

    /**
     * Returns true if this Future is complete and has completed with an error.
     */
    public function isFailure () : Bool
    {
        return isComplete() && this.result.success == false;
    }

    /**
     * Sets the result of this Future to a successful value.
     *
     * @throw String - if the Future is already set (success or failure)
     */
    public function setSuccess (value:T)
    {
        this.result = { value:value, success:true };
    }

    /**
     * Sets the result of this Future to a failure.
     *
     * @throw String - if the Future is already set (success or failure)
     */
    public function setFailure (error:Dynamic)
    {
        this.result = { value:error, success:false };
    }

    /**
     * Registers a function to be called if this Future completes with a successful object.
     * If the Future is already succeeded, this method will call the callback instantly.
     *
     * @return this
     */
    public function onSuccess (callback:T -> Void) : Future<T>
    {
        if (this.result != null) {
            if (this.result.success) callback(this.result.value);   // respond to callback immediately
            else                     {}                             // Future will never succeed
        } else {
            // register the callback to be notified later
            this.callbacks.push({ type : CallbackType.SUCCESS, func : callback });
        }
        return this;
    }

    /**
     * Registers a function to be called if this Future completes with a failure.
     * If the Future is already failed, this method will call the callback instantly.
     *
     * @return this
     */
    public function onFailure (callback:Dynamic -> Void) : Future<T>
    {
        if (this.result != null) {
            if (this.result.success) {}                             // Future will never be failed
            else                     callback(this.result.value);   // respond to the callback immediately
        } else {
            // register the callback to be notified later
            this.callbacks.push({ type : CallbackType.FAILURE, func : callback });
        }
        return this;
    }

    /**
     * Registers a function to be called when the Future completes, regardless of success.
     * If the Future is already complete, this method will call the callback instantly.
     *
     * @return this
     */
    public function onComplete (callback:Void -> Void) : Future<T>
    {
        if (this.result != null) {
            // respond to the callback instantly
            callback();
        } else {
            // register the callback to be notified later
            this.callbacks.push({ type : CallbackType.COMPLETE, func : callback });
        }
        return this;
    }

    /**
     * Removes a callback registered with onSuccess, onFailure, or onComplete.
     */
    public function removeCallback (callback:Dynamic)
    {
        this.callbacks = this.callbacks.filter(function(c) {
                return c.func != callback;
            });
    }

    /**
     * Maps this Future to a new Future of a different type.
     */
    public function map<R> (mapping:T -> R) : Future<R>
    {
        var mutable = new Future<R>();
        this.onSuccess(function(t) { mutable.setSuccess(mapping(t)); });
        this.onFailure(function(e) { mutable.setFailure(e); });
        return mutable;
    }

    /**
     * Maps the value of a successful result. This can be used to chain Future events.
     * Failure on the original or mapped Future will be reported to the resulting Future.
     */
    public function flatMap<R> (mapping:T -> Future<R>) : Future<R>
    {
        var mutable = new Future<R>();
        this.onSuccess(function(t) {
                mapping(t)
                    .onSuccess(function(r) { mutable.setSuccess(r); })
                    .onFailure(function(e) { mutable.setFailure(e); });
            });
        this.onFailure(function(e) { mutable.setFailure(e); } );
        return mutable;
    }

    public function new ()
    {
        this.callbacks = [];
        this.result    = null;
    }

    /**
     * Creates a new Future with a given result.
     */
    private static function withResult<T> (result:Result<T>) : Future<T>
    {
        var instance = new Future<T>();
        instance.result = result;
        return instance;
    }

    /** Callbacks to be notified when the result is set. */
    private var callbacks:Array<Callback>;

    /** Resulting value of the Future, or null if the Future is pending. */
    private var result (default, set) : Result<T>;
        function set_result (result:Result<T>) : Result<T> {
            if (this.result != null) throw "Future result cannot be set multiple times.";
            this.result = result;

            if (this.result != null) {
                var type = this.result.success
                    ? CallbackType.SUCCESS
                    : CallbackType.FAILURE;

                // respond to the callbacks in order they're registered
                for (callback in this.callbacks) {
                         if (callback.type == CallbackType.COMPLETE) callback.func();
                    else if (callback.type == type)                  callback.func(this.result.value);
                }

                // release the callbacks
                this.callbacks = null;
            }

            return this.result;
        }
}

/** Future specialization for Void. */
class Future_Void
{
    /** @see Future.success */
    public static function success () : Future<Void>
    {
        return Future_Void.withResult({ error:null, success:true });
    }

    /** @see Future.failure */
    public static function failure (error:Dynamic) : Future<Void>
    {
        return Future_Void.withResult({ error:error, success:false });
    }

    /** @see Future.isComplete */
    public function isComplete () : Bool
    {
        return this.result != null;
    }

    /** @see Future.isSuccess */
    public function isSuccess () : Bool
    {
        return isComplete() && this.result.success;
    }

    /** @see Future.isFailure */
    public function isFailure () : Bool
    {
        return isComplete() && this.result.success == false;
    }

    /** @see Future.setSuccess */
    public function setSuccess ()
    {
        this.result = { error:null, success:true };
    }

    /** @see Future.setFailure */
    public function setFailure (error:Dynamic)
    {
        this.result = { error:error, success:false };
    }

    /** @see Future.onSuccess */
    public function onSuccess (callback:Void -> Void) : Future<Void>
    {
        if (this.result != null) {
            if (this.result.success) callback();    // respond to callback immediately
            else                     {}             // Future will never succeed
        } else {
            // register the callback to be notified later
            this.callbacks.push({ type : CallbackType.SUCCESS, func : callback });
        }
        return this;
    }

    /** @see Future.onFailure */
    public function onFailure (callback:Dynamic -> Void) : Future<Void>
    {
        if (this.result != null) {
            if (this.result.success) {}                             // Future will never be failed
            else                     callback(this.result.error);   // respond to the callback immediately
        } else {
            // register the callback to be notified later
            this.callbacks.push({ type : CallbackType.FAILURE, func : callback });
        }
        return this;
    }

    /** @see Future.onComplete */
    public function onComplete (callback:Void -> Void) : Future<Void>
    {
        if (this.result != null) {
            // respond to the callback instantly
            callback();
        } else {
            // register the callback to be notified later
            this.callbacks.push({ type : CallbackType.COMPLETE, func : callback });
        }
        return this;
    }

    /** @see Future.removeCallback */
    public function removeCallback (callback:Dynamic)
    {
        this.callbacks = this.callbacks.filter(function(c) {
                return c.func != callback;
            });
    }

    /** @see Future.map */
    public function map<R> (mapping:Void -> R) : Future<R>
    {
        var mutable = new Future<R>();
        this.onSuccess(function()  { mutable.setSuccess(mapping()); });
        this.onFailure(function(e) { mutable.setFailure(e); });
        return mutable;
    }

    /** @see Future.flatMap */
    public function flatMap<R> (mapping:Void -> Future<R>) : Future<R>
    {
        var mutable = new Future<R>();
        this.onSuccess(function() {
                mapping()
                    .onSuccess(function(r) { mutable.setSuccess(r); })
                    .onFailure(function(e) { mutable.setFailure(e); });
            });
        this.onFailure(function(e) { mutable.setFailure(e); } );
        return mutable;
    }

    public function new ()
    {
        this.callbacks = [];
        this.result    = null;
    }

    /** @see Future.withResult */
    private static function withResult (result:Result_Void) : Future<Void>
    {
        var instance = new Future<Void>();
        instance.result = result;
        return instance;
    }

    /** Callbacks to be notified when the result is set. */
    private var callbacks:Array<Callback>;

    /** Resulting value of the Future, or null if the Future is pending. */
    private var result (default, set) : Result_Void;
        function set_result (result:Result_Void) : Result_Void {
            if (this.result != null) throw "Future result cannot be set multiple times.";
            this.result = result;

            if (this.result != null) {
                var type = this.result.success
                    ? CallbackType.SUCCESS
                    : CallbackType.FAILURE;

                // respond to the callbacks in order they're registered
                for (callback in this.callbacks) {
                    if (callback.type == type || callback.type == CallbackType.COMPLETE) {
                        if (callback.type == CallbackType.FAILURE)  callback.func(this.result.error);
                        else                                        callback.func();
                    }
                }

                // release the callbacks
                this.callbacks = null;
            }

            return this.result;
        }
}

/** Callback types. */
private enum CallbackType {
    FAILURE;
    SUCCESS;
    COMPLETE;
}

/** Future resulting value. */
private typedef Result<T> = {
    public var value:T;
    public var success:Bool;
}

/** Future_Void resulting value. */
private typedef Result_Void = {
    public var error:Dynamic;
    public var success:Bool;
}

/** Future callback. */
private typedef Callback = {
    public var type:CallbackType;
    public var func:Dynamic;
}
