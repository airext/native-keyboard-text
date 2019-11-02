/**
 * Created by max.rozdobudko@gmail.com on 02.11.2019.
 */
package com.github.airext.keyboard.enum {
public class NativeKeyboardType {

    public static const Default: NativeKeyboardType               = new NativeKeyboardType(0);
    public static const ASCIICapable: NativeKeyboardType          = new NativeKeyboardType(1);
    public static const NumbersAndPunctuation: NativeKeyboardType = new NativeKeyboardType(2);
    public static const URL: NativeKeyboardType                   = new NativeKeyboardType(3);
    public static const NumberPad: NativeKeyboardType             = new NativeKeyboardType(4);
    public static const PhonePad: NativeKeyboardType              = new NativeKeyboardType(5);
    public static const NamePhonePad: NativeKeyboardType          = new NativeKeyboardType(6);
    public static const EmailAddress: NativeKeyboardType          = new NativeKeyboardType(7);
    public static const DecimalPad: NativeKeyboardType            = new NativeKeyboardType(8);
    public static const Twitter: NativeKeyboardType               = new NativeKeyboardType(9);
    public static const WebSearch: NativeKeyboardType             = new NativeKeyboardType(10);
    public static const ASCIICapableNumberPad: NativeKeyboardType = new NativeKeyboardType(11);


    public static function fromRawValue(rawValue: int): NativeKeyboardType {
        switch (rawValue) {
            case Default.rawValue               : return Default;
            case ASCIICapable.rawValue          : return ASCIICapable;
            case NumbersAndPunctuation.rawValue : return NumbersAndPunctuation;
            case URL.rawValue                   : return URL;
            case NumberPad.rawValue             : return NumberPad;
            case PhonePad.rawValue              : return PhonePad;
            case NamePhonePad.rawValue          : return NamePhonePad;
            case EmailAddress.rawValue          : return EmailAddress;
            case DecimalPad.rawValue            : return DecimalPad;
            case Twitter.rawValue               : return Twitter;
            case WebSearch.rawValue             : return WebSearch;
            case ASCIICapableNumberPad.rawValue : return ASCIICapableNumberPad;
        }
        return null;
    }


    public function NativeKeyboardType(rawValue: int) {
        super();
        _rawValue = rawValue;
    }

    private var _rawValue: int;
    public function get rawValue(): int {
        return _rawValue;
    }

    public function get name(): String {
        switch (this) {
            case Default                : return "Default";
            case ASCIICapable           : return "ASCIICapable";
            case NumbersAndPunctuation  : return "NumbersAndPunctuation";
            case URL                    : return "URL";
            case NumberPad              : return "NumberPad";
            case PhonePad               : return "PhonePad";
            case NamePhonePad           : return "NamePhonePad";
            case EmailAddress           : return "EmailAddress";
            case DecimalPad             : return "DecimalPad";
            case Twitter                : return "Twitter";
            case WebSearch              : return "WebSearch";
            case ASCIICapableNumberPad  : return "ASCIICapableNumberPad";
        }
        return null;
    }

    public function toString(): String {
        return name;
    }
}
}
