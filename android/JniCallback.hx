package android;

#if android

/**
 * Callback utility to make responding to native async Android methods easier.
 *
 * Haxe:
 *      jni_method(new JniCallback(function(arg:Dynamic) {
 *              // callback called from native Android!
 *          });
 *
 * Android:
 *      public static void jni_method (HaxeObject callback) {
 *          // do async stuff
 *          callback.call1("call1", arg);
 *      }
 */
class JniCallback
{
    public static function with (action:Dynamic) : JniCallback { return new JniCallback(action); }
    public function new (action:Dynamic) { this.action = action; }
    private var action:Dynamic;

    // Methods to be called from native Android.
    private function call0 () { this.action(); }
    private function call1 (arg1:Dynamic) { this.action(arg1); }
    private function call2 (arg1:Dynamic, arg2:Dynamic) { this.action(arg1, arg2); }
    private function call3 (arg1:Dynamic, arg2:Dynamic, arg3:Dynamic) { this.action(arg1, arg2, arg3); }
    private function call4 (arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic) { this.action(arg1, arg2, arg3, arg4); }
    private function call5 (arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic, arg5:Dynamic) { this.action(arg1, arg2, arg3, arg4, arg5); }
}

#end
