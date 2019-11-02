/**
 * Created by max.rozdobudko@gmail.com on 10/20/19.
 */
package com.github.airext {
import com.github.airext.core.keyboard;
import com.github.airext.keyboard.NativeKeyboardTextParams;
import com.github.airext.keyboard.event.NativeKeyboardTextHideEvent;
import com.github.airext.keyboard.event.NativeKeyboardTextInputEvent;
import com.github.airext.keyboard.event.NativeKeyboardTextShowEvent;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

use namespace keyboard;

[Event(name="nativeKeyboardTextShow", type="com.github.airext.keyboard.event.NativeKeyboardTextShowEvent")]
[Event(name="nativeKeyboardTextHide", type="com.github.airext.keyboard.event.NativeKeyboardTextHideEvent")]
[Event(name="nativeKeyboardTextInput", type="com.github.airext.keyboard.event.NativeKeyboardTextInputEvent")]

public class NativeKeyboardText extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    keyboard static const EXTENSION_ID:String = "com.github.airext.NativeKeyboardText";

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  context
    //-------------------------------------

    private static var _context: ExtensionContext;
    keyboard static function get context(): ExtensionContext {
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

    public function NativeKeyboardText() {
        super();
        instance = this;
        context.addEventListener(StatusEvent.STATUS, statusHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function showKeyboard(params: NativeKeyboardTextParams): void {
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
        trace("NativeKeyboardText.status: ", event.code, event.level);
        switch (event.code) {
            case "NativeKeyboardText.Keyboard.Hide":
                var params: Object = parseParams(event.level);
                dispatchEvent(new NativeKeyboardTextHideEvent(params.oldText, params.newText));
                break;
            case "NativeKeyboardText.Keyboard.Show":
                dispatchEvent(new NativeKeyboardTextShowEvent());
                break;
            case "NativeKeyboardText.Keyboard.Input":
                var text: String = event.level;
                dispatchEvent(new NativeKeyboardTextInputEvent(text));
                break;
        }
    }
}
}
