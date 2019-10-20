/**
 * Created by max.rozdobudko@gmail.com on 10/20/19.
 */
package com.github.airext {
import com.github.airext.core.floating_keyboard;

import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

use namespace floating_keyboard;

public class FloatingKeyboard {

    //--------------------------------------------------------------------------
    //
    //  Class methods
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

    public function showKeyboard(): void {

    }

    public function hideKeyboard(): void {

    }

}
}
