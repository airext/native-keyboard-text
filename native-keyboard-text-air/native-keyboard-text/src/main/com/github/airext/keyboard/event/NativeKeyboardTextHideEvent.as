/**
 * Created by max.rozdobudko@gmail.com on 23.10.2019.
 */
package com.github.airext.keyboard.event {
import flash.events.Event;

/**
 * Dispatches after native keyboard hides, provides <code>oldText</code> and
 * <code>newText</code> properties that could be used to handle user input.
 */
public class NativeKeyboardTextHideEvent extends Event {

    public static const HIDE: String = "nativeKeyboardTextHide";

    /**
     * Constructor.
     * @param oldText text that NativeKeyboardText contained before keyboard is opened.
     * @param newText text that NativeKeyboardText contains on keyboard hides.
     */
    public function NativeKeyboardTextHideEvent(oldText: String, newText: String) {
        super(HIDE);
        _oldText = oldText;
        _newText = newText;
    }

    private var _oldText: String;
    /**
     * The text that NativeKeyboardText contained before keyboard is opened.
     */
    public function get oldText(): String {
        return _oldText;
    }

    private var _newText: String;
    /**
     * The text that NativeKeyboardText contains on keyboard hides.
     */
    public function get newText(): String {
        return _newText;
    }

    override public function toString(): String {
        return "[NativeKeyboardTextHideEvent(oldText=\""+oldText+"\", newText=\""+newText+"\")]";
    }
}
}
