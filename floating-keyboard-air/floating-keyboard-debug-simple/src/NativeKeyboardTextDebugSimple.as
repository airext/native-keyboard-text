package {

import com.github.airext.NativeKeyboardText;
import com.github.airext.keyboard.NativeKeyboardTextParams;
import com.github.airext.keyboard.event.NativeKeyboardTextHideEvent;
import com.github.airext.keyboard.event.NativeKeyboardTextInputEvent;
import com.github.airext.keyboard.event.NativeKeyboardTextShowEvent;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.text.TextField;
import flash.text.TextFormat;

public class NativeKeyboardTextDebugSimple extends Sprite {

    public function NativeKeyboardTextDebugSimple() {
        super();

        if (NativeKeyboardText.isSupported) {
            trace(NativeKeyboardText.extensionVersion);
        } else {
            trace("NativeKeyboardText is not supported on this platform");
            return;
        }

        // setup stage

        const contentScaleFactor: Number = 2.0;

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        // output

        var textField: TextField = new TextField();
        textField.text = "";
        textField.scaleX = textField.scaleY = contentScaleFactor;
        textField.defaultTextFormat = new TextFormat("_serif", 18);
        textField.borderColor = 0x000000;
        textField.border = true;
        textField.height = 400;
        textField.width = stage.stageWidth / contentScaleFactor;
        textField.x = 0;
        textField.y = stage.stageHeight - textField.height;
        addChild(textField);

        function log(...args): void {
            textField.text += args + "\n";
            textField.scrollV = textField.maxScrollV;
            trace(args);
        }

        // subscribe to events

        NativeKeyboardText.shared.addEventListener(NativeKeyboardTextHideEvent.HIDE, function(event: NativeKeyboardTextHideEvent): void {
            log("Keyboard did hide with oldText:" + event.oldText + ", newText: " + event.newText);
        });
        NativeKeyboardText.shared.addEventListener(NativeKeyboardTextShowEvent.SHOW, function(event: NativeKeyboardTextShowEvent): void {
            log("Keyboard did show");
        });
        NativeKeyboardText.shared.addEventListener(NativeKeyboardTextInputEvent.INPUT, function(event: NativeKeyboardTextInputEvent): void {
            log("Keyboard input: " + event.text);
        });

        // buttons

        new PlainButton(this, {label: "Show Keyboard", y: 150, w: stage.stageWidth / contentScaleFactor, s: contentScaleFactor}, function(): void {
            var params: NativeKeyboardTextParams = new NativeKeyboardTextParams();
            params.text = "test";
            NativeKeyboardText.shared.showKeyboard(params);
        });
    }

}
}

//------------------------------------------------------------------------------
//
//  PlainButton
//
//------------------------------------------------------------------------------

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class PlainButton extends Sprite
{
    function PlainButton(parent:DisplayObjectContainer=null, properties:Object=null, clickHandler:Function=null)
    {
        super();

        scaleX = scaleY = 2.0;

        _props = properties || {};
        _label = _props.label || "";
        _color = _props.color || 0;

        scaleX = scaleY = _props.scale || _props.s || 1.0;

        var textColor:uint = properties ? (properties.textColor || 0xFFFFFF) : 0xFFFFFF;

        textDisplay = new TextField();
        textDisplay.defaultTextFormat = new TextFormat("_sans", 24, textColor, null, null, null, null, null, TextFormatAlign.CENTER);
        textDisplay.selectable = false;
        textDisplay.autoSize = "center";
        addChild(textDisplay);

        x = _props.x || 0;
        y = _props.y || 0;

        if (parent)
            parent.addChild(this);

        if (clickHandler != null)
        {
            addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
            {
                if (clickHandler.length == 1)
                    clickHandler(event);
                else if (clickHandler.length == 0)
                    clickHandler();
            });
        }

        sizeInvalid = true;
        labelInvalid = true;

        addEventListener(Event.ENTER_FRAME, renderHandler);
    }

    private var sizeInvalid:Boolean;
    private var labelInvalid:Boolean;

    private var _label:String;
    private var _color:uint;
    private var _props:Object;

    private var textDisplay:TextField;

    private function renderHandler(event:Event):void
    {
        if (labelInvalid)
        {
            labelInvalid = false;

            textDisplay.text = _label;
        }

        if (sizeInvalid)
        {
            sizeInvalid = false;

            var w:Number = _props.width || _props.w || 100;
            var h:Number = _props.height || _props.h || 40;

            graphics.clear();
            graphics.beginFill(_color);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();

            textDisplay.x = 0;
            textDisplay.width = w;
            textDisplay.y = (h - textDisplay.height) / 2;
        }
    }
}
