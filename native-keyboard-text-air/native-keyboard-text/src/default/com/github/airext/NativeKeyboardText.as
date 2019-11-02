/**
 * Created by max.rozdobudko@gmail.com on 10/20/19.
 */
package com.github.airext {
import com.github.airext.core.keyboard;
import com.github.airext.keyboard.NativeKeyboardTextParams;

import flash.events.EventDispatcher;
import flash.system.Capabilities;

use namespace keyboard;

[Event(name="nativeKeyboardTextShow", type="com.github.airext.keyboard.event.NativeKeyboardTextShowEvent")]
[Event(name="nativeKeyboardTextHide", type="com.github.airext.keyboard.event.NativeKeyboardTextHideEvent")]

public class NativeKeyboardText extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return false;
    }

    //-------------------------------------
    //  sharedInstance
    //-------------------------------------

    private static var instance: NativeKeyboardText;

    public static function get shared(): NativeKeyboardText {
        if (instance == null) {
            new NativeKeyboardText();
        }
        return instance;
    }

    //-------------------------------------
    //  extensionVersion
    //-------------------------------------

    public static function get extensionVersion(): String {
        trace("NativeKeyboardText extension is not supported on " + Capabilities.os);
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NativeKeyboardText() {
        super();
        instance = this;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function showKeyboard(params: NativeKeyboardTextParams): void {
        trace("NativeKeyboardText extension is not supported on " + Capabilities.os);
    }

    public function hideKeyboard(): void {
        trace("NativeKeyboardText extension is not supported on " + Capabilities.os);
    }

}
}
