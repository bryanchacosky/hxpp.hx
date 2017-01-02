package extension.reachability;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/** Receives android.net.conn.CONNECTIVITY_CHANGE */
public class ReachabilityReceiver extends BroadcastReceiver
{
    @Override // from BroadcastReceiver
    public void onReceive (Context context, Intent intent)
    {
        Reachability.onReachabilityChanged();
    }
}
