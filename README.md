floating-keyboard ![License MIT](http://img.shields.io/badge/license-MIT-lightgray.svg)
==========

![iOS](https://img.shields.io/badge/iOS-10.0-blue)

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

Set iOS minimum version to 11.0 in iPhone InfoAdditions:
```xml
<iPhone>
    <!-- A list of plist key/value pairs to be added to the application Info.plist -->
    <InfoAdditions>
        <![CDATA[
        <key>MinimumOSVersion</key>
        <string>11.0</string>
        ]]>
    </InfoAdditions>
</iPhone>
```

### Usage
