/**
 * Created by max.rozdobudko@gmail.com on 01.11.2019.
 */
package com.github.airext.keyboard.event {
import flash.events.TextEvent;

public class NativeKeyboardTextInputEvent extends TextEvent {

    public static const INPUT: String = "nativeKeyboardTextInput";

    public function NativeKeyboardTextInputEvent(text: String = "") {
        super(INPUT, false, false, text);
    }

    override public function toString(): String {
        return "[NativeKeyboardTextInputEvent(text=\""+text+"\")]";
    }
}
}
