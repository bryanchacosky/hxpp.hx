package;

import haxe.PosInfos;

/** Log configuration properties. */
typedef LogConfig = {
    public var color:String;    // ANSI color
    public var enabled:Bool;    // enabled state
}

/**
 * Logging utility methods.
 */
class Log
{
    /** ANSI color constants. */
    public static inline var COLOR_BLACK    = "\033[0;30m";
    public static inline var COLOR_RED      = "\033[31m";
    public static inline var COLOR_GREEN    = "\033[32m";
    public static inline var COLOR_YELLOW   = "\033[33m";
    public static inline var COLOR_BLUE     = "\033[1;34m";
    public static inline var COLOR_MAGENTA  = "\033[1;35m";
    public static inline var COLOR_CYAN     = "\033[0;36m";
    public static inline var COLOR_GREY     = "\033[0;37m";
    public static inline var COLOR_WHITE    = "\033[1;37m";
    public static inline var COLOR_NONE     = "\033[0m";
    public static inline var COLOR_DEFAULT  = COLOR_NONE;

    /** Log level constants. */
    public static inline var LEVEL_DEBUG    = "debug";
    public static inline var LEVEL_INFO     = "info";
    public static inline var LEVEL_WARN     = "warn";
    public static inline var LEVEL_ERROR    = "error";

    /** Maps log level -> configuration properties. */
    public static var config (default, null) : Map<String, LogConfig> = {
            var instance = new Map();
            instance[LEVEL_DEBUG] = { color:COLOR_GREEN,    enabled: true };
            instance[LEVEL_INFO]  = { color:COLOR_DEFAULT,  enabled: true };
            instance[LEVEL_WARN]  = { color:COLOR_YELLOW,   enabled: true };
            instance[LEVEL_ERROR] = { color:COLOR_RED,      enabled: true };
            instance;
        };

    /** Print methods. */
    public static function debug (message:Dynamic = "", ?args:Map<String, Dynamic>, ?error:Dynamic, ?pos:PosInfos) { Log.instance.print(LEVEL_DEBUG, Log.format(message, args, error, pos), pos); }
    public static function info  (message:Dynamic = "", ?args:Map<String, Dynamic>, ?error:Dynamic, ?pos:PosInfos) { Log.instance.print(LEVEL_INFO,  Log.format(message, args, error, pos), pos); }
    public static function warn  (message:Dynamic = "", ?args:Map<String, Dynamic>, ?error:Dynamic, ?pos:PosInfos) { Log.instance.print(LEVEL_WARN,  Log.format(message, args, error, pos), pos); }
    public static function error (message:Dynamic = "", ?args:Map<String, Dynamic>, ?error:Dynamic, ?pos:PosInfos) { Log.instance.print(LEVEL_ERROR, Log.format(message, args, error, pos), pos); }

    /** Prints the current stacktrace. */
    public static function stacktrace (?pos:PosInfos)
    {
        Log.instance.print(LEVEL_DEBUG, "Stacktrace:\n" + Strings.stacktrace(1), pos);
    }

    /** Formats a log message. */
    private static function format (message:Dynamic, ?args:Map<String, Dynamic>, ?error:Dynamic, ?pos:PosInfos) : String
    {
        // if an error is present, register it within the args
        if (error != null) {
            args = args == null ? new Map() : args;
            args.set("error", error);
        }

        // append the color and level
        var stringbuffer = new StringBuf();
        stringbuffer.add(Std.string(message));

        // append the arguments to the string
        if (args != null) {
            stringbuffer.add(" ");
            stringbuffer.add(Maps.toString(args));
        }

        // print the stack trace if this is an error message
        if (error != null) {
            stringbuffer.add("\n");
            stringbuffer.add(Strings.stacktrace(2));
        }

        return stringbuffer.toString();
    }

    /** Prints the message. */
    private function print (level:String, message:String, ?pos:PosInfos) : Bool
    {
        var config:LogConfig = Log.config.get(level);
        if (config == null || config.enabled == false) {
            return false;
        }

        var stringbuffer = new StringBuf();
        stringbuffer.add(config.color);
        stringbuffer.add("[");
        stringbuffer.add(level);
        stringbuffer.add("] ");
        stringbuffer.add(message);
        stringbuffer.add(COLOR_NONE);
        __trace(stringbuffer.toString(), pos);
        return true;
    }

    /** Singleton instance. */
    private function new () {}
    private static var instance(get, null):Log;
    private static function get_instance () : Log {
        if (instance == null) {
            instance = new Log();
            instance.__trace = haxe.Log.trace;
            haxe.Log.trace = function(message, ?pos) {
                    Log.info(message, null, null, pos);
                };
        }
        return instance;
    }

    /** Haxe trace reference. */
    private var __trace:Dynamic -> ?PosInfos -> Void;
}
