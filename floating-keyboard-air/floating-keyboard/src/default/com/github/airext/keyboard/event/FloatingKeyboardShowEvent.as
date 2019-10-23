/**
 * Created by max.rozdobudko@gmail.com on 23.10.2019.
 */
package com.github.airext.keyboard.event {
import flash.events.Event;

public class FloatingKeyboardShowEvent extends Event {

    public static const SHOW: String = "floatingKeyboardShow";

    public function FloatingKeyboardShowEvent() {
        super(SHOW);
    }

    override public function toString(): String {
        return "[FloatingKeyboardShowEvent()]";
    }
}
}
