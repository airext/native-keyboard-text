//
//  NativeKeyboardText.h
//  NativeKeyboardText
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANXNativeKeyboardTextParams.h"
#import "FlashRuntimeExtensions.h"

@interface ANXNativeKeyboardText : NSObject {
    ANXNativeKeyboardTextParams* _params;
    NSString* _latestInputString;
}

#pragma mark - Shared Instance

+ (ANXNativeKeyboardText*) sharedInstance;

#pragma mark Properties

@property (weak, nonatomic) UITextField* textField;
@property (weak, nonatomic) UITapGestureRecognizer* tapGestureRecognizer;

@property FREContext context;

#pragma mark - API

- (void)showKeyboard:(ANXNativeKeyboardTextParams*)params;

- (void)hideKeyboard:(id)sender;

@end

#pragma mark - UIKeyboard

@interface ANXNativeKeyboardText (UIKeyboard)

- (void)keyboardWillShowNotification:(NSNotification *)notification;
- (void)keyboardDidShowNotification:(NSNotification *)notification;
- (void)keyboardWillHideNotification:(NSNotification *)notification;
- (void)keyboardDidHideNotification:(NSNotification *)notification;
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification;
- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification;

@end

#pragma mark - UIDevice

@interface ANXNativeKeyboardText (UIDevice)

- (void)deviceOrientationDidChangeNotification:(NSNotification*)notification;

@end

#pragma mark - Utils

@interface ANXNativeKeyboardText (Utils)

- (UIView*)findTopmostView;

- (BOOL)doesKeyboardDisappear:(NSDictionary*)userInfo;

@property (nonatomic, readonly) UIColor* textFieldBackgroundColor;
@property (nonatomic, readonly) UIColor* textFieldWrapperBackgroundColor;

- (UITextField*)createTextField;
- (void)moveTextFieldAtBottomAndHide:(BOOL)hide;
- (void)adjustTextFieldFrame;

- (UITapGestureRecognizer*)createTapGestureRecognizer;

@end

#pragma mark - UITextFieldDelegate

@interface ANXNativeKeyboardText (UITextFieldDelegate) <UITextFieldDelegate>

@end

#pragma mark - FREDispatcher

@interface ANXNativeKeyboardText (FREDispatcher)

- (void)dispatch:(NSString*) code withLevel:(NSString*)level;

- (void)dispatchError:(NSString*)code;

- (void)dispatchStatus:(NSString*)code;

@end
