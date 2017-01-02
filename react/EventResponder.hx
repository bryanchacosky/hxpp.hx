package react;

import openfl.events.IEventDispatcher;

/**
 * Helper class to respond to events sent through an event dispatcher.
 *
 * Usage:
 *      EventResponder
 *          .onEvent(Lib.current.stage, KeyboardEvent.KEY_DOWN)
 *          .setPredicate(function(e) { return e.keyCode == Keyboard.ESCAPE; })
 *          .setCallback(function(e) { ... escape pressed ... })
 *          .once();
 */
class EventResponder
{
    /**
     * Creates a new EventResponder to respond to a single event.
     */
    public static function onEvent (dispatcher:IEventDispatcher, event:String) : EventResponder
    {
        return EventResponder.onEvents(dispatcher, [event]);
    }

    /**
     * Creates a new EventResponder to respond to a multiple events at once.
     */
    public static function onEvents (dispatcher:IEventDispatcher, events:Array<String>) : EventResponder
    {
        return new EventResponder(dispatcher, events);
    }

    /**
     * Sets the predicate function to be checked before executing the callback.
     *
     * @return this
     */
    public function setPredicate (predicate:Dynamic -> Bool) : EventResponder
    {
        this.predicate = predicate;
        return this;
    }

    /**
     * Sets the callback function to be called when the event is dispatched.
     *
     * @return this
     */
    public function setCallback (callback:Dynamic -> Void) : EventResponder
    {
        this.callback = callback;
        return this;
    }

    /**
     * Disconnects the EventResponder after the next successful response.
     *
     * @return this
     */
    public function once () : EventResponder
    {
        this.is_once = true;
        return this;
    }

    /**
     * Disconnects the EventResponder.
     * This method is safe to call multiple times.
     */
    public function disconnect ()
    {
        if (this.events != null) {
            for (event in this.events) {
                this.dispatcher.removeEventListener(event, notify);
            }
        }

        this.events     = null;
        this.callback   = null;
        this.predicate  = null;
        this.dispatcher = null;
    }

    private function new (dispatcher:IEventDispatcher, events:Array<String>)
    {
        this.is_once    = false;
        this.events     = events;
        this.callback   = null;
        this.predicate  = null;
        this.dispatcher = dispatcher;

        for (event in this.events) {
            this.dispatcher.addEventListener(event, notify);
        }
    }

    /**
     * Notifies the callback of the event.
     */
    private function notify (value:Dynamic)
    {
        if (this.callback == null) return;
        if (this.predicate != null && this.predicate(value) == false) return;
        this.callback(value);
        if (this.is_once) disconnect();
    }

    private var    is_once:Bool;                // if true, disconnect after the next notify
    private var     events:Array<String>;       // events being listened to
    private var   callback:Dynamic -> Void;     // callback function
    private var  predicate:Dynamic -> Bool;     // predicate function
    private var dispatcher:IEventDispatcher;    // event dispatcher
}
