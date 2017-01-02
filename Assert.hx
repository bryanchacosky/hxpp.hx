package;

import haxe.PosInfos;

/**
 * Exception class thrown by Assert.
 */
@:allow(Assert)
class AssertException
{
    public var assertion (default, null) : String;      // assertion type
    public var position  (default, null) : PosInfos;    // assertion position
    public var message   (default, null) : String;      // assertion message

    private function new (assertion:String, position:PosInfos, ?message:String)
    {
        this.assertion = assertion;
        this.position  = position;
        this.message   = message;
    }

    public function toString () : String
    {
        return "AssertException " + Maps.toString([
                "assertion" => this.assertion,
                "position"  => this.position.fileName + ":" + this.position.lineNumber,
                "message"   => this.message
            ]);
    }
}

/**
 * Assertion utility methods.
 * To enable assertions, compile with `-debug` or -`Dassert`.
 */
class Assert
{
    /**
     * Asserts that this will only be called once during execution.
     *
     * @throw AssertException
     */
    public static function once (?message:String, ?pos:PosInfos)
    {
#if (debug || assert)
        var position:String = pos.fileName + ":" + pos.lineNumber;
        if (once_positions.push(position) == false) {
            throw new AssertException("once", pos, message);
        }
#end
    }

    /**
     * Asserts that the condition is true.
     *
     * @throw AssertException
     */
    public static function check (condition:Bool, ?message:String, ?pos:PosInfos)
    {
#if (debug || assert)
        if (condition == false) {
            throw new AssertException("check", pos, message);
        }
#end
    }

    /**
     * Asserts that the object is not null.
     *
     * @throw AssertException
     */
    public static function checkNotNull (object:Dynamic, ?message:String, ?pos:PosInfos)
    {
#if (debug || assert)
        if (object == null) {
            throw new AssertException("checkNotNull", pos, message);
        }
#end
    }

#if (debug || assert)
    /** Set of positions used in Assert.once */
    private static var once_positions = new Set<String>();
#end
}
