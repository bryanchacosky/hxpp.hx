package reachability;

/**
 * Network reachability status.
 */
class NetworkStatus
{
    public static var NOT_CONNECTED   (default, null) = new NetworkStatus(false);   // Not connected
    public static var CONNECTED_WIFI  (default, null) = new NetworkStatus(true);    // Connected via WiFi
    public static var CONNECTED_WWAN  (default, null) = new NetworkStatus(true);    // Connected via WWAN
    public static var CONNECTED_OTHER (default, null) = new NetworkStatus(true);    // Connected via other source

    /** True if this network status is connected to the internet. */
    public var isConnected (default, null) : Bool;

    private function new (isConnected:Bool)
    {
        this.isConnected = isConnected;
    }

    public function toString () : String
    {
        if (this == NOT_CONNECTED)   return "NetworkStatus.NOT_CONNECTED";
        if (this == CONNECTED_WIFI)  return "NetworkStatus.CONNECTED_WIFI";
        if (this == CONNECTED_WWAN)  return "NetworkStatus.CONNECTED_WWAN";
        if (this == CONNECTED_OTHER) return "NetworkStatus.CONNECTED_OTHER";
        throw "Unexpected NetworkStatus instance";
    }
}
