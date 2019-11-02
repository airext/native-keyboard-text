native-keyboard-text ![License MIT](http://img.shields.io/badge/license-MIT-lightgray.svg)
==========

![iOS](https://img.shields.io/badge/iOS-12.0-blue)

[AIR Native Extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) for alternate way to input text on AIR.

## Table of Contents

- [Sections](#sections)
  - [Setup](#setup)
  - [Usage](#usage)
  
## Sections

### Setup

1. Download [com.github.airext.NativeKeyboardText.ane](https://github.com/airext/native-keyboard-text/releases) ANE and [add it as dependencies](http://bit.ly/2xTSJry) to your project. Optionally you may include corresponded `com.github.airext.NativeKeyboardText.swc` library to your project.
2. Edit your [Application Descriptor](http://help.adobe.com/en_US/air/build/WS5b3ccc516d4fbf351e63e3d118666ade46-7ff1.html) file with registering new native extensions like this:
```xml
<extensions>
    <extensionID>com.github.airext.NativeKeyboardText</extensionID>
</extensions>
```

Set iOS minimum version to 12.0 in iPhone InfoAdditions:
```xml
<iPhone>
    <!-- A list of plist key/value pairs to be added to the application Info.plist -->
    <InfoAdditions>
        <![CDATA[
        <key>MinimumOSVersion</key>
        <string>12.0</string>
        ]]>
    </InfoAdditions>
</iPhone>
```

### Usage

#### Simplest Example

```actionscript3
// listen to Keyboard's Input event
NativeKeyboardText.shared.addEventListener(NativeKeyboardTextInputEvent.INPUT, function(event: NativeKeyboardTextInputEvent): void {
    log("Keyboard input: " + event.text);
});

// show Keyboard using shared instance method.
var params: NativeKeyboardTextParams = new NativeKeyboardTextParams();
NativeKeyboardText.shared.showKeyboard(params);
```

#### API

##### Shared Instance

Use `NativeKeyboardText.shared` to obtain an instance of NativeKeyboardText class, it is designed to be a singleton.

##### Utils

* `NativeKeyboardText.isSupported` indicates if NativeKeyboardText is supported on the current platform;
* `NativeKeyboardText.extensionVersion` returns extension version number;

##### Show/Hide 

* `NativeKeyboardText.shared.showKeyboard(NativeKeyboardTextParams)` shows native keyboard parametrized based on `NativeKeyboardTextParams` instance.
* `NativeKeyboardText.shared.showKeyboard.hideKeyboard()` hides native keyboard if presented from this ANE.

##### Events

* `NativeKeyboardTextShowEvent.SHOW` dispatches when native keyboard is opened.
* `NativeKeyboardTextHideEvent.HIDE` dispatches after native keyboard hides, provides `oldText: String` and `newText: String` properties that could be used to handle user input.
* `NativeKeyboardTextInputEvent.INPUT` dispatches when user taps on a return button, contains `text` property with current user input.

##### Params

The appearance of native keyboard could be changed with `NativeKeyboardTextParams` object:
* `NativeKeyboardTextParams.text` specifies initial text to display in a text field above native keyboard;
* `NativeKeyboardTextParams.isSecureTextEntry` indicates if input should be secured;
* `NativeKeyboardTextParams.keyboardType` keyboard type from `NativeKeyboardType` enum.
* `NativeKeyboardTextParams.returnKeyType` a type of return button from `ReturnKeyType` enum.
* `NativeKeyboardTextParams.autoCorrection` auto correction type from `AutoCorrection` enum.
* `NativeKeyboardTextParams.autoCapitalization` auto capitalization type from `AutoCapitalization` enum.
* `NativeKeyboardTextParams.spellChecking` spell checking type from `SpellChecking` enum.
* `NativeKeyboardTextParams.maxCharactersCount` indicates how mach characters user able to enter.

##### NativeKeyboardType

This enum maps to [UIKeyboardType](https://developer.apple.com/documentation/uikit/uikeyboardtype), next values are supported:
* `NativeKeyboardType.Default`
* `NativeKeyboardType.ASCIICapable`
* `NativeKeyboardType.NumbersAndPunctuation`
* `NativeKeyboardType.URL`
* `NativeKeyboardType.NumberPad`
* `NativeKeyboardType.PhonePad`
* `NativeKeyboardType.NamePhonePad`
* `NativeKeyboardType.EmailAddress`
* `NativeKeyboardType.DecimalPad`
* `NativeKeyboardType.Twitter`
* `NativeKeyboardType.WebSearch`
* `NativeKeyboardType.ASCIICapableNumberPad`

##### ReturnKeyType

Maps to [UIReturnKeyType](https://developer.apple.com/documentation/uikit/uireturnkeytype), next values are supported:
* `ReturnKeyType.Default`
* `ReturnKeyType.Go`
* `ReturnKeyType.Google`
* `ReturnKeyType.Join`
* `ReturnKeyType.Next`
* `ReturnKeyType.Route`
* `ReturnKeyType.Search`
* `ReturnKeyType.Send`
* `ReturnKeyType.Yahoo`
* `ReturnKeyType.Done`
* `ReturnKeyType.EmergencyCall`
* `ReturnKeyType.Continue`

##### AutoCapitalization

Maps to [UITextAutocapitalizationType](https://developer.apple.com/documentation/uikit/uitextautocapitalizationtype), next values are supported:
* `AutoCapitalization.None`
* `AutoCapitalization.Words`
* `AutoCapitalization.Sentences`
* `AutoCapitalization.AllCharacters`

##### AutoCorrection

Maps to [UITextAutocorrectionType](https://developer.apple.com/documentation/uikit/uitextautocorrectiontype), supports next values:
* `AutoCorrection.Default`
* `AutoCorrection.No`
* `AutoCorrection.Yes`

##### SpellChecking

Maps to [UITextSpellCheckingType](https://developer.apple.com/documentation/uikit/uitextspellcheckingtype), supports next values:
* `SpellChecking.Default`
* `SpellChecking.No`
* `SpellChecking.Yes`
