#import <Foundation/Foundation.h>
#import <hx/CFFI.h>
#import "HxReachability.h"
#import "Reachability.h"

namespace reachability {

    static Reachability * reachability;     // Reachability instance
    static AutoGCRoot   * callback;         // callback to be notified on changes

    /** Notifies the callback of the current reachability status. */
    void notify () {
        val_call1(callback->get(),
            alloc_int([reachability currentReachabilityStatus]));
    }

    /** Sets the callback to be notified when reachability changes. */
    void setReachabilityCallback (value vcallback) {
        if (callback != NULL) delete callback;
        callback = new AutoGCRoot(vcallback);

        // initialize Reachability if needed
        if (reachability == nil) {
            reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];

            // register a notification observer
            [[NSNotificationCenter defaultCenter]
                addObserverForName:kReachabilityChangedNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification * n) { notify(); }];
        }

        // notify the callback immediately
        notify();
    }

    /** Deallocates the Reachability instance. */
    void dealloc () {
        if (reachability != nil) {
            [[NSNotificationCenter defaultCenter] removeObserver:kReachabilityChangedNotification];
            [reachability stopNotifier];
            reachability = nil;
        }

        if (callback != NULL) {
            delete callback;
            callback = NULL;
        }
    }
}
