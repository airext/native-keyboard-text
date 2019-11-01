/**
 * Created by max.rozdobudko@gmail.com on 10/20/19.
 */
package com.github.airext {
import com.github.airext.core.floating_keyboard;
import com.github.airext.keyboard.FloatingKeyboardParams;
import com.github.airext.keyboard.event.FloatingKeyboardHideEvent;
import com.github.airext.keyboard.event.FloatingKeyboardInputEvent;
import com.github.airext.keyboard.event.FloatingKeyboardShowEvent;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

use namespace floating_keyboard;

[Event(name="floatingKeyboardShow", type="com.github.airext.keyboard.event.FloatingKeyboardShowEvent")]
[Event(name="floatingKeyboardHide", type="com.github.airext.keyboard.event.FloatingKeyboardHideEvent")]
[Event(name="floatingKeyboardInput", type="com.github.airext.keyboard.event.FloatingKeyboardInputEvent")]

public class FloatingKeyboard extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    floating_keyboard static const EXTENSION_ID:String = "com.github.airext.FloatingKeyboard";

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  context
    //-------------------------------------

    private static var _context: ExtensionContext;
    floating_keyboard static function get context(): ExtensionContext {
        if (_context == null) {
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
        }
        return _context;
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return context != null && context.call("isSupported");
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

    private static var _extensionVersion: String = null;

    /**
     * Returns version of extension
     * @return extension version
     */
    public static function get extensionVersion(): String {
        if (_extensionVersion == null) {
            try {
                var extension_xml: File = ExtensionContext.getExtensionDirectory(EXTENSION_ID).resolvePath("META-INF/ANE/extension.xml");
                if (extension_xml.exists) {
                    var stream: FileStream = new FileStream();
                    stream.open(extension_xml, FileMode.READ);

                    var extension: XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
                    stream.close();

                    var ns:Namespace = extension.namespace();

                    _extensionVersion = extension.ns::versionNumber;
                }
            } catch (error:Error) {
                // ignore
            }
        }

        return _extensionVersion;
    }

    //-------------------------------------
    //  Utils
    //-------------------------------------

    private static function parseParams(raw: String): Object {
        var params: Object = null;
        try {
            params = JSON.parse(raw);
        } catch (e: Error) {
            params = raw;
        }
        return params;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function FloatingKeyboard() {
        super();
        instance = this;
        context.addEventListener(StatusEvent.STATUS, statusHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function showKeyboard(params: FloatingKeyboardParams): void {
        context.call("showKeyboard", params);
    }

    public function hideKeyboard(): void {
        context.call("hideKeyboard");
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function statusHandler(event: StatusEvent):void {
        trace("FloatingKeyboard.status: ", event.code, event.level);
        switch (event.code) {
            case "FloatingKeyboard.Keyboard.Hide":
                var params: Object = parseParams(event.level);
                dispatchEvent(new FloatingKeyboardHideEvent(params.oldText, params.newText));
                break;
            case "FloatingKeyboard.Keyboard.Show":
                dispatchEvent(new FloatingKeyboardShowEvent());
                break;
            case "FloatingKeyboard.Keyboard.Input":
                var text: String = event.level;
                dispatchEvent(new FloatingKeyboardInputEvent(text));
                break;
        }
    }
}
}