/**
 * Created by max.rozdobudko@gmail.com on 01.11.2019.
 */
package com.github.airext.keyboard.event {
import flash.events.TextEvent;

public class FloatingKeyboardInputEvent extends TextEvent {

    public static const INPUT: String = "floatingKeyboardInput";

    public function FloatingKeyboardInputEvent(text: String = "") {
        super(INPUT, false, false, text);
    }

    override public function toString(): String {
        return "[FloatingKeyboardInputEvent(text=\""+text+"\")]";
    }
}
}
