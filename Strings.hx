package;

import haxe.CallStack;
import haxe.CallStack.StackItem;
import haxe.PosInfos;
import haxe.macro.Context;
import haxe.macro.Expr;

/** Interface that builds the Strings.macro_toString() macro. */
@:autoBuild(Strings.macro_toString())
interface ToString {}

/**
 * String utility methods.
 */
class Strings
{
    /**
     * Macro method that adds a toString() method to the class
     * if it doesn't already exist.
     */
    macro public static function macro_toString () : Array<Field>
    {
        var fields:Array<Field> = Context.getBuildFields();
        if (Macros.hasField("toString") == false) {
            fields = Macros.concatFields(fields, macro : {
                    public function toString () : String {
                        return Strings.toString(this);
                    }
                });
        }
        return fields;
    }

    /**
     * Returns a comparison result by comparing the strings in alphabetical order.
     */
    public static function compare (a:String, b:String) : Int
    {
        if (a == b) return  0;
        if (a <  b) return -1;
        else        return  1;
    }

    /**
     * Returns the class name of the object.
     */
    public static function classname (object:Dynamic, simple:Bool = true) : String
    {
        var clazz:Class<Dynamic> =
            if (Std.is(object, Class)) cast object
            else                       Type.getClass(object);
        var name:String = Type.getClassName(clazz);
        if (simple) name = Arrays.last(name.split("."));
        return name;
    }

    /**
     * Returns the stack trace to string. If `callstack` is null, the current
     * call stack is used.
     */
    public static function stacktrace (?callstack:Array<StackItem>, skip:Int = 0) : String
    {
        // if callstack is null, use the current callstack
        if (callstack == null) {
            callstack  = CallStack.callStack();
            skip      += 1; // ignore Strings.stacktrace() in the stack
        }

        var buffer = new StringBuf();
        for (stackitem in callstack.slice(skip)) {
            buffer.add(withStackItem(stackitem));
            buffer.add("\n");
        }
        return StringTools.trim(buffer.toString());
    }

    public static function withStackItem (stackitem:StackItem) : String
    {
        var buffer = new StringBuf();
        var method = Reflect.field(CallStack, "itemToString");
        Reflect.callMethod(CallStack, method, [buffer, stackitem]);
        return buffer.toString();
    }

    /**
     * Returns a formatted string containing the simple class name
     * of the object and the field name/value of all accessible
     * fields.
     */
    public static function toString (object:Dynamic) : String
    {
        var args:Map<String, Dynamic> = null;
        var fieldnames = Type.getInstanceFields(Type.getClass(object));
        if (fieldnames.length > 0) {
            args = new Map();
            for (fieldname in fieldnames) {
                var field = Reflect.field(object, fieldname);
                if (Reflect.isFunction(field) == false) {
                    args.set(fieldname, field);
                }
            }
        }
        var string:String = Strings.classname(object);
        if (args != null) string += " " + Maps.toString(args);
        return string;
    }
}
