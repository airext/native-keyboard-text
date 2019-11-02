//
//  NativeKeyboardTextConversionRoutines.h
//  NativeKeyboardText
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXNativeKeyboardTextConversionRoutines : NSObject

+(FREObject) convertNSStringToFREObject:(NSString*)string;
+(NSString*) convertFREObjectToNSString:(FREObject)string;

+(BOOL) convertFREObjectToBool:(FREObject)value;
+(FREObject) convertBoolToFREObject:(BOOL)value;

+ (NSInteger) convertFREObjectToNSInteger:(FREObject)integer withDefault:(NSInteger)defaultValue;
+ (FREObject)convertNSIntegerToFREObject:(NSInteger)integer;

+ (NSString*)readNSStringFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSString* _Nullable)defaultValue;
+ (BOOL)readBoolFrom:(FREObject)object field:(NSString*)field withDefaultValue:(BOOL)defaultValue;
+ (NSInteger)readNSIntegerFrom:(FREObject)object field:(NSString*)field withDefaultValue:(NSInteger)defaultValue;
+ (NSInteger)readNSIntegerFrom:(FREObject)object field:(NSString*)field withRawValueField:(NSString*)rawValueField withDefaultValue:(NSInteger)defaultValue;

@end

NS_ASSUME_NONNULL_END
