/**
 * Created by max.rozdobudko@gmail.com on 02.11.2019.
 */
package com.github.airext.keyboard.enum {
public class SpellChecking {

    public static const Default: SpellChecking  = new SpellChecking(0);
    public static const No: SpellChecking       = new SpellChecking(1);
    public static const Yes: SpellChecking      = new SpellChecking(2);

    public static function fromRawValue(rawValue: int): SpellChecking {
        switch (rawValue) {
            case Default.rawValue   : return Default;
            case No.rawValue        : return No;
            case Yes.rawValue       : return Yes;
        }
        return null;
    }

    public function SpellChecking(rawValue: int) {
        super();
        _rawValue = rawValue;
    }

    private var _rawValue: int;
    public function get rawValue(): int {
        return _rawValue;
    }

    public function get name(): String {
        switch (this) {
            case Default  : return "Default";
            case No       : return "No";
            case Yes      : return "Yes";
        }
        return null;
    }

    public function toString(): String {
        return name;
    }
}
}
