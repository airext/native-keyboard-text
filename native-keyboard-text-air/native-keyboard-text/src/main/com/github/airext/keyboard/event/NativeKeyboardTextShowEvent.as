/**
 * Created by max.rozdobudko@gmail.com on 23.10.2019.
 */
package com.github.airext.keyboard.event {
import flash.events.Event;

/**
 * Dispatches when native keyboard is opened.
 */
public class NativeKeyboardTextShowEvent extends Event {

    public static const SHOW: String = "nativeKeyboardTextShow";

    public function NativeKeyboardTextShowEvent() {
        super(SHOW);
    }

    override public function toString(): String {
        return "[NativeKeyboardTextShowEvent()]";
    }
}
}
