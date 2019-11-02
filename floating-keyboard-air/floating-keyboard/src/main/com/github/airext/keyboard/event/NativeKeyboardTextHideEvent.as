/**
 * Created by max.rozdobudko@gmail.com on 23.10.2019.
 */
package com.github.airext.keyboard.event {
import flash.events.Event;

public class NativeKeyboardTextHideEvent extends Event {

    public static const HIDE: String = "nativeKeyboardTextHide";

    public function NativeKeyboardTextHideEvent(oldText: String, newText: String) {
        super(HIDE);
        _oldText = oldText;
        _newText = newText;
    }

    private var _oldText: String;
    public function get oldText(): String {
        return _oldText;
    }

    private var _newText: String;
    public function get newText(): String {
        return _newText;
    }

    override public function toString(): String {
        return "[NativeKeyboardTextHideEvent(oldText=\""+oldText+"\", newText=\""+newText+"\")]";
    }
}
}
