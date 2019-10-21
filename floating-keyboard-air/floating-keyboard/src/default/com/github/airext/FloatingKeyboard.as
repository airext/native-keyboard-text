/**
 * Created by max.rozdobudko@gmail.com on 10/20/19.
 */
package com.github.airext {
import com.github.airext.core.floating_keyboard;
import com.github.airext.keyboard.FloatingKeyboardParams;

import flash.system.Capabilities;

use namespace floating_keyboard;

public class FloatingKeyboard {

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

    private static var instance: FloatingKeyboard;

    public static function get shared(): FloatingKeyboard {
        if (instance == null) {
            new FloatingKeyboard();
        }
        return instance;
    }

    //-------------------------------------
    //  extensionVersion
    //-------------------------------------

    public static function get extensionVersion(): String {
        trace("FloatingKeyboard extension is not supported on " + Capabilities.os);
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function FloatingKeyboard() {
        super();
        instance = this;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function showKeyboard(params: FloatingKeyboardParams): void {
        trace("FloatingKeyboard extension is not supported on " + Capabilities.os);
    }

    public function hideKeyboard(): void {
        trace("FloatingKeyboard extension is not supported on " + Capabilities.os);
    }

}
}
