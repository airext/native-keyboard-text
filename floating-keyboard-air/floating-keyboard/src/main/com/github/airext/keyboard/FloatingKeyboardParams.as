/**
 * Created by max.rozdobudko@gmail.com on 21.10.2019.
 */
package com.github.airext.keyboard {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.registerClassAlias;

public class FloatingKeyboardParams extends EventDispatcher {

    //--------------------------------------------------------------------------
    //
    //  Static initialization
    //
    //--------------------------------------------------------------------------

    {
        registerClassAlias("com.github.airext.keyboard.FloatingKeyboardParams", FloatingKeyboardParams);
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function FloatingKeyboardParams() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  text
    //-------------------------------------

    private var _text: String = null;
    [Bindable(event="textChanged")]
    public function get text(): String {
        return _text;
    }

    public function set text(value: String): void {
        if (value == _text) return;
        _text = value;
        dispatchEvent(new Event("textChanged"));
    }

    //-------------------------------------
    //  isSecureTextEntry
    //-------------------------------------

    private var _isSecureTextEntry: Boolean = false;
    [Bindable(event="isSecureTextEntryChanged")]
    public function get isSecureTextEntry(): Boolean {
        return _isSecureTextEntry;
    }

    public function set isSecureTextEntry(value: Boolean): void {
        if (value == _isSecureTextEntry) return;
        _isSecureTextEntry = value;
        dispatchEvent(new Event("isSecureTextEntryChanged"));
    }

    //-------------------------------------
    //  maxCharactersCount
    //-------------------------------------

    private var _maxCharactersCount: int;
    [Bindable(event="maxCharactersCountChanged")]
    public function get maxCharactersCount(): int {
        return _maxCharactersCount;
    }

    public function set maxCharactersCount(value: int): void {
        if (value == _maxCharactersCount) return;
        _maxCharactersCount = value;
        dispatchEvent(new Event("maxCharactersCountChanged"));
    }

    //--------------------------------------------------------------------------
    //
    //  Description
    //
    //--------------------------------------------------------------------------

    override public function toString(): String {
        return "[FloatingKeyboardParams(text=\""+text+"\", isSecureTextEntry=\""+isSecureTextEntry+"\", maxCharactersCount=\""+maxCharactersCount+"\")]";
    }
}
}
