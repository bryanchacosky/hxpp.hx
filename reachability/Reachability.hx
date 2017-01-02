package reachability;

import react.Value;
import react.Value.Response;

/**
 * Determines network reachability.
 */
class Reachability
{
    /** Network status. */
    public static var status (get, never) : Value<NetworkStatus>;
        static function get_status () : Value<NetworkStatus> {
            return Reachability.singleton._status;
        }

    /**
     * Begins listening to the device for reachability changes.
     * It is not necesary to call this method.
     */
    public static function start ()
    {
        Reachability.singleton;
    }

    /**
     * Returns true if the device is currently connected to the internet.
     */
    public static function isConnected () : Bool
    {
        return Reachability.status.get().isConnected;
    }

    /**
     * Responds to the callback when the reachability state is at a connected state.
     * If the device is currently connected to the internet, the callback is called immediately.
     *
     * To remove the callback early:
     *    var callback = Reachability.waitForConnected(...);
     *    Reachability.getNetworkStatus().remove(callback);
     *
     * @return callback needed to disconnect
     */
    public static function waitForConnected (callback:NetworkStatus -> Void) : Response<NetworkStatus> -> Void
    {
        return Reachability.status.push(function(response) {
                if (response.get().isConnected) {
                    callback(response.get());
                    response.disconnect();
                }
            }, true);
    }

    /** Singleton instance. */
    private static var singleton (get, null) : Reachability;
    private static function get_singleton () : Reachability {
        return singleton == null ? (singleton = new Reachability()) : singleton;
    }

    /** Instance network status. */
    private var _status : Value<NetworkStatus>;

    private function new ()
    {
        _status = new Value(NetworkStatus.NOT_CONNECTED);

#if android
        ///////////////////////////////////////////////////////////////////////////////////////////////
        // Android implementation
        ///////////////////////////////////////////////////////////////////////////////////////////////
        openfl.utils.JNI.createStaticMethod("extension/reachability/Reachability", "setReachabilityCallback", "(Lorg/haxe/lime/HaxeObject;)V")(new android.JniCallback(function(android_status) {
                _status.set(switch(android_status) {
                        case 0: NetworkStatus.NOT_CONNECTED;
                        case 1: NetworkStatus.CONNECTED_WIFI;
                        case 2: NetworkStatus.CONNECTED_WWAN;
                        case 3: NetworkStatus.CONNECTED_OTHER;
                        default: throw "Received unexpected reachability response: " + android_status;
                    });
            }));

#elseif ios
        ///////////////////////////////////////////////////////////////////////////////////////////////
        // iOS implementation
        ///////////////////////////////////////////////////////////////////////////////////////////////
        cpp.Lib.load("reachability", "reachability_setReachabilityCallback", 1)(function(ios_status) {
                _status.set(switch(ios_status) {
                        case 0: NetworkStatus.NOT_CONNECTED;
                        case 1: NetworkStatus.CONNECTED_WIFI;
                        case 2: NetworkStatus.CONNECTED_WWAN;
                        default: throw "Received unexpected reachability response: " + ios_status;
                    });
            });

#else
        ///////////////////////////////////////////////////////////////////////////////////////////////
        // Default implementation
        ///////////////////////////////////////////////////////////////////////////////////////////////
        _status.set(NetworkStatus.CONNECTED_WIFI);
#end
    }
}
