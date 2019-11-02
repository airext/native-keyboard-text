/**
 * Created by max.rozdobudko@gmail.com on 02.11.2019.
 */
package com.github.airext.keyboard.enum {
public class ReturnKeyType {

    public static const Default: ReturnKeyType       = new ReturnKeyType(0);
    public static const Go: ReturnKeyType            = new ReturnKeyType(1);
    public static const Google: ReturnKeyType        = new ReturnKeyType(2);
    public static const Join: ReturnKeyType          = new ReturnKeyType(3);
    public static const Next: ReturnKeyType          = new ReturnKeyType(4);
    public static const Route: ReturnKeyType         = new ReturnKeyType(5);
    public static const Search: ReturnKeyType        = new ReturnKeyType(6);
    public static const Send: ReturnKeyType          = new ReturnKeyType(7);
    public static const Yahoo: ReturnKeyType         = new ReturnKeyType(8);
    public static const Done: ReturnKeyType          = new ReturnKeyType(9);
    public static const EmergencyCall: ReturnKeyType = new ReturnKeyType(10);
    public static const Continue: ReturnKeyType      = new ReturnKeyType(11);


    public static function fromRawValue(rawValue: int): ReturnKeyType {
        switch (rawValue) {
            case Default.rawValue       : return Default;
            case Go.rawValue            : return Go;
            case Google.rawValue        : return Google;
            case Join.rawValue          : return Join;
            case Next.rawValue          : return Next;
            case Route.rawValue         : return Route;
            case Search.rawValue        : return Search;
            case Send.rawValue          : return Send;
            case Yahoo.rawValue         : return Yahoo;
            case Done.rawValue          : return Done;
            case EmergencyCall.rawValue : return EmergencyCall;
            case Continue.rawValue      : return Continue;
        }
        return null;
    }


    public function ReturnKeyType(rawValue: int) {
        super();
        _rawValue = rawValue;
    }

    private var _rawValue: int;
    public function get rawValue(): int {
        return _rawValue;
    }

    public function get name(): String {
        switch (this) {
            case Default        : return "Default";
            case Go             : return "Go";
            case Google         : return "Google";
            case Join           : return "Join";
            case Next           : return "Next";
            case Route          : return "Route";
            case Search         : return "Search";
            case Send           : return "Send";
            case Yahoo          : return "Yahoo";
            case Done           : return "Done";
            case EmergencyCall  : return "EmergencyCall";
            case Continue       : return "Continue";
        }
        return null;
    }

    public function toString(): String {
        return name;
    }
}
}
