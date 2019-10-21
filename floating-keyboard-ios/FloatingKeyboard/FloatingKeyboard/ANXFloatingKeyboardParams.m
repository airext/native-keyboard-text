//
//  ANXFloatingKeyboardParams.m
//  ANXFloatingKeyboard
//
//  Created by Max Rozdobudko on 21.10.2019.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import "ANXFloatingKeyboardParams.h"
#import "ANXFloatingKeyboardConversionRoutines.h"

@implementation ANXFloatingKeyboardParams

- (instancetype)initWithFREObject:(FREObject)object {
    if (self = [super init]) {
        self.text = [ANXFloatingKeyboardConversionRoutines readNSStringFrom:object field:@"text" withDefaultValue:nil];
        self.isSecureTextEntry = [ANXFloatingKeyboardConversionRoutines readBoolFrom:object field:@"isSecureTextEntry" withDefaultValue:NO];
        self.maxCharactersCount = [ANXFloatingKeyboardConversionRoutines readNSIntegerFrom:object field:@"maxCharactersCount" withDefaultValue:0];
    }
    return self;
}

@end
