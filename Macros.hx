package;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;

/**
 * Macro utility methods.
 */
class Macros
{
    /**
     * Returns true if the current macro context defines
     * a field with the given name.
     */
    public static function hasField (name:String) : Bool
    {
        // search in the existing build fields
        for (field in Context.getBuildFields()) {
            if (field.name == name) {
                return true;
            }
        }

        // search in the classtype fields and superclasses
        var classtype:ClassType = Context.getLocalClass().get();
        while (classtype != null) {
            // search the current classtype
            for (classfield in classtype.fields.get()) {
                if (classfield.name == name) {
                    return true;
                }
            }

            // re-assign the classtype to the superclass, if applicable
            classtype = classtype.superClass != null
                ? classtype.superClass.t.get()
                : null;
        }

        return false;
    }

    /**
     * Concats an existing array of fields with a given macro of additional fields.
     *
     * @return a new array containing the input array plus fields defined by the macro
     */
    public static function concatFields (input:Array<Field>, macrotype:ComplexType) : Array<Field>
    {
        return switch (macrotype) {
            case TAnonymous(other): input.concat(other);
            default: throw "Unexpected macro type";
        }
    }

    /**
     * Returns true if the Field is a variable.
     */
    public static function isVariable (field:Field) : Bool
    {
        return switch (field.kind) {
            case FVar(a, b): true;
            default:         false;
        }
    }

    /**
     * Returns true if the Field is a function.
     */
    public static function isFunction (field:Field) : Bool
    {
        return switch (field.kind) {
            case FFun(a): true;
            default:      false;
        }
    }
}
