/**
 * Created by max.rozdobudko@gmail.com on 02.11.2019.
 */
package com.github.airext.keyboard.enum {
public class AutoCapitalization {

    public static const None: AutoCapitalization            = new AutoCapitalization(0);
    public static const Words: AutoCapitalization           = new AutoCapitalization(1);
    public static const Sentences: AutoCapitalization       = new AutoCapitalization(2);
    public static const AllCharacters: AutoCapitalization   = new AutoCapitalization(3);

    public static function fromRawValue(rawValue: int): AutoCapitalization {
        switch (rawValue) {
            case None.rawValue          : return None;
            case Words.rawValue         : return Words;
            case Sentences.rawValue     : return Sentences;
            case AllCharacters.rawValue : return AllCharacters;
        }
        return null;
    }

    public function AutoCapitalization(rawValue: int) {
        super();
        _rawValue = rawValue;
    }

    private var _rawValue: int;
    public function get rawValue(): int {
        return _rawValue;
    }

    public function get name(): String {
        switch (this) {
            case None           : return "None";
            case Words          : return "Words";
            case Sentences      : return "Sentences";
            case AllCharacters  : return "AllCharacters";
        }
        return null;
    }

    public function toString(): String {
        return name;
    }
}
}
