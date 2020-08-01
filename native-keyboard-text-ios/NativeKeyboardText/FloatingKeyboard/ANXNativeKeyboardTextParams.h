//
//  NativeKeyboardTextParams.h
//  NativeKeyboardText
//
//  Created by Max Rozdobudko on 21.10.2019.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANXNativeKeyboardTextParams : NSObject

- (instancetype)initWithFREObject:(FREObject)freObject;

@property (nonatomic, nullable) NSString* text;

@property (nonatomic) BOOL isSecureTextEntry;

@property (nonatomic) NSInteger maxCharactersCount;

@property (nonatomic) UIKeyboardType keyboardType;

@property (nonatomic) UIReturnKeyType returnKeyType;

@property (nonatomic) UITextSpellCheckingType spellCheckingType;

@property (nonatomic) UITextAutocapitalizationType autoCapitalizationType;

@property (nonatomic) UITextAutocorrectionType autoCorrectionType;

@property (nonatomic, nullable) NSCharacterSet* characterFilter;

@end

NS_ASSUME_NONNULL_END
