package extension.reachability;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

/** Reachability extension. */
public class Reachability
{
    /** JNI callback when reachability changes. */
    private static HaxeObject jni_callback_onReachabilityChanged;

    /** Notifies the JNI callback that the reachability has changed. */
    public static void onReachabilityChanged ()
    {
        if (jni_callback_onReachabilityChanged == null) return;
        NetworkInfo networkinfo = ((ConnectivityManager)Extension.mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE)).getActiveNetworkInfo();
        if (networkinfo != null && networkinfo.isConnected()) {
            switch (networkinfo.getType()) {
                case ConnectivityManager.TYPE_WIFI:     { jni_callback_onReachabilityChanged.call1("call1", 1); break; }    // connected via wifi
                case ConnectivityManager.TYPE_MOBILE:   { jni_callback_onReachabilityChanged.call1("call1", 2);  break; }   // connected via wwan
                default:                                { jni_callback_onReachabilityChanged.call1("call1", 3);  break; }   // connected via other
            }
        } else {
            jni_callback_onReachabilityChanged.call1("call1", 0);   // not connected
        }
    }

    /** Sets the JNI callback when reachability changes. */
    public static void setReachabilityCallback (HaxeObject callback)
    {
        jni_callback_onReachabilityChanged = callback;
        onReachabilityChanged(); // notify the callback immediately
    }

    private Reachability () {
        // prevent external construction
    }
}
