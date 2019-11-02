/**
 * Created by max.rozdobudko@gmail.com on 02.11.2019.
 */
package com.github.airext.keyboard.enum {
public class AutoCorrection {

    public static const Default: AutoCorrection  = new AutoCorrection(0);
    public static const No: AutoCorrection       = new AutoCorrection(1);
    public static const Yes: AutoCorrection      = new AutoCorrection(2);

    public static function fromRawValue(rawValue: int): AutoCorrection {
        switch (rawValue) {
            case Default.rawValue   : return Default;
            case No.rawValue        : return No;
            case Yes.rawValue       : return Yes;
        }
        return null;
    }

    public function AutoCorrection(rawValue: int) {
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
