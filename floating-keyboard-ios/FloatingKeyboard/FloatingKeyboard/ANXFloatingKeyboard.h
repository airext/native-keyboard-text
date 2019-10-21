//
//  ANXFloatingKeyboard.h
//  ANXFloatingKeyboard
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANXFloatingKeyboardParams.h"

@interface ANXFloatingKeyboard : NSObject {
    ANXFloatingKeyboardParams* _params;
}

#pragma mark - Shared Instance

+ (ANXFloatingKeyboard*) sharedInstance;

#pragma mark Properties

@property (weak, nonatomic) UITextField* textField;
@property (weak, nonatomic) UITapGestureRecognizer* tapGestureRecognizer;

@property (nonatomic, readonly) UIColor* textFieldBackgroundColor;

@property (nonatomic, readonly) UIColor* textFieldWrapperBackgroundColor;

@property (nonatomic, readonly) CGFloat textFieldPadding;

#pragma mark - API

- (void)showKeyboard:(ANXFloatingKeyboardParams*)params;

- (void)hideKeyboard:(id)sender;

@end

#pragma mark - UIKeyboard

@interface ANXFloatingKeyboard (UIKeyboard)

- (void)keyboardWillShowNotification:(NSNotification *)notification;

- (void)keyboardWillHideNotification:(NSNotification *)notification;

@end

#pragma mark - Utils

@interface ANXFloatingKeyboard (Utils)

- (UIView*)findTopmostView;

- (UITextField*)createTextField;
- (UITapGestureRecognizer*)createTapGestureRecognizer;

@end

#pragma mark - UITextFieldDelegate

@interface ANXFloatingKeyboard (UITextFieldDelegate) <UITextFieldDelegate>

@end
