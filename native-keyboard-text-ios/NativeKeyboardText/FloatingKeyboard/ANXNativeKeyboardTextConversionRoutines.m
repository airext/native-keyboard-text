//
//  NativeKeyboardTextConversionRoutines.m
//  NativeKeyboardText
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import "ANXNativeKeyboardTextConversionRoutines.h"

@implementation ANXNativeKeyboardTextConversionRoutines

#pragma mark - Conversion methods

#pragma mark String

+ (FREObject) convertNSStringToFREObject:(NSString*)string {
    if (string == nil) return NULL;

    const char* utf8String = string.UTF8String;

    unsigned long length = strlen( utf8String );

    FREObject converted;
    FREResult result = FRENewObjectFromUTF8((uint32_t) length, (const uint8_t*) utf8String, &converted);

    if (result != FRE_OK)
        return NULL;

    return converted;
}

+ (NSString*)convertFREObjectToNSString:(FREObject)string {
    FREResult result;

    uint32_t length = 0;
    const uint8_t* tempValue = NULL;

    result = FREGetObjectAsUTF8(string, &length, &tempValue);

    if (result != FRE_OK)
        return nil;

    return [NSString stringWithUTF8String: (char*) tempValue];
}

#pragma mark Boolean

+ (FREObject)convertBoolToFREObject:(BOOL)value {
    FREObject result = NULL;

    if (value)
        FRENewObjectFromBool((uint32_t) 1, &result);
    else
        FRENewObjectFromBool((uint32_t) 0, &result);

    return result;
}

+ (BOOL)convertFREObjectToBool:(FREObject)value {
    uint32_t tempValue;

    FREResult result = FREGetObjectAsBool(value, &tempValue);

    if (result != FRE_OK)
        return NO;

    return tempValue > 0;
}

#pragma mark Integer

+ (NSInteger) convertFREObjectToNSInteger:(FREObject)integer withDefault:(NSInteger)defaultValue {
    FREResult result;

    int32_t tempValue;
    result = FREGetObjectAsInt32(integer, &tempValue);

    if (result != FRE_OK)
    return defaultValue;

    return (NSUInteger) tempValue;
}

+ (FREObject)convertNSIntegerToFREObject:(NSInteger)integer {
    FREObject result;
    if (FRENewObjectFromInt32((int32_t)integer, &result) == FRE_OK) {
        return result;
    } else {
        return NULL;
    }
}

#pragma mark - Read Properties

+ (NSString*)readNSStringFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSString*)defaultValue {
    FREObject propertyObject;
    if (FREGetObjectProperty(object, (const uint8_t *)[field UTF8String], &propertyObject, NULL) == FRE_OK) {
        return [self convertFREObjectToNSString:propertyObject] ?: defaultValue;
    } else {
        return defaultValue;
    }
}

+ (BOOL)readBoolFrom:(FREObject)object field:(NSString*)field withDefaultValue:(BOOL)defaultValue {
    FREObject propertyObject;
    if (FREGetObjectProperty(object, (const uint8_t *)[field UTF8String], &propertyObject, NULL) == FRE_OK) {
        return [self convertFREObjectToBool:propertyObject] ?: defaultValue;
    } else {
        return defaultValue;
    }
}

+ (NSInteger)readNSIntegerFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSInteger)defaultValue {
    FREObject propertyObject;
    if (FREGetObjectProperty(object, (const uint8_t *)[field UTF8String], &propertyObject, NULL) == FRE_OK) {
        return [self convertFREObjectToNSInteger:propertyObject withDefault:defaultValue];
    } else {
        return defaultValue;
    }
}

+ (NSInteger)readNSIntegerFrom:(FREObject)object field:(NSString*)field withRawValueField:(NSString*)rawValueField withDefaultValue:(NSInteger)defaultValue {
    FREObject propertyObject;
    if (FREGetObjectProperty(object, (const uint8_t *)[field UTF8String], &propertyObject, NULL) == FRE_OK) {
        return [self readNSIntegerFrom:propertyObject field:rawValueField withDefaultValue:defaultValue];
    } else {
        return defaultValue;
    }
}

@end
