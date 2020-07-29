/**
 * Created by max.rozdobudko@gmail.com on 01.11.2019.
 */
package com.github.airext.keyboard.event {
import flash.events.TextEvent;

/**
 * Dispatches when user taps on a return button,
 * contains <code>text</code> property with current user input.
 */
public class NativeKeyboardTextInputEvent extends TextEvent {

    public static const INPUT: String = "nativeKeyboardTextInput";

    /**
     * Constructor
     * @param text current user input.
     */
    public function NativeKeyboardTextInputEvent(text: String = "") {
        super(INPUT, false, false, text);
    }

    override public function toString(): String {
        return "[NativeKeyboardTextInputEvent(text=\""+text+"\")]";
    }
}
}
