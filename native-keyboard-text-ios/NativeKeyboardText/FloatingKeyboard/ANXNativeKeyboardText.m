//
//  NativeKeyboardText.m
//  NativeKeyboardText
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import "ANXNativeKeyboardText.h"
#import "ANXTextField.h"

#define PADDING 8.0f

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation ANXNativeKeyboardText {
    BOOL isKeyboardPresented;  // indicates if Keyboard is statically presented
    BOOL isKeyboardInDockMode; // indicates if Keyboard is presented and docked
    BOOL isKeyboardDismissing; // indicates if Keyboard is in transition to close state
    BOOL isKeyboardAppearing;  // indicates if Keyboard is in transition to open state
}

#pragma mark - Shared Instance

static ANXNativeKeyboardText* _sharedInstance = nil;
+ (ANXNativeKeyboardText*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];

    }
    return _sharedInstance;
}

#pragma mark Synthesized Properties

@synthesize context;

#pragma mark - API

- (void)showKeyboard:(ANXNativeKeyboardTextParams*)params {
    NSLog(@"[NativeKeyboardText showKeyboard]");

    if (self.textField) {
        return;
    }

    _params = params;

    [self subscribeToNotifications];

    self.textField = [self createTextField];

    self.tapGestureRecognizer = [self createTapGestureRecognizer];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textField.superview setHidden:NO];
        [self.textField becomeFirstResponder];
        self.textField.text = self->_params.text;
    });
}

- (void)hideKeyboard:(id)sender {
    NSLog(@"[NativeKeyboardText hideKeyboard]");

    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    [view endEditing:YES];
}

- (void)subscribeToNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unsubscribeFromNotificationAndDispose {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [self.textField.superview removeFromSuperview];
    [self.tapGestureRecognizer.view removeGestureRecognizer:self.tapGestureRecognizer];
}

@end

#pragma mark - UIKeyboard

@implementation ANXNativeKeyboardText (UIKeyboard)

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    NSLog(@"[NativeKeyboardText keyboardWillShowNotification]");
    isKeyboardInDockMode = YES;

    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    NSDictionary* userInfo = notification.userInfo;

    UIViewAnimationCurve animationCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat animationDuration           = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame                = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    keyboardFrame = [view convertRect:keyboardFrame toView:view];

    [UIView animateWithDuration:animationDuration delay:0.0f options:(UIViewAnimationOptions)animationCurve animations:^{
        CGRect frame = self.textField.superview.frame;
        frame.origin.y = keyboardFrame.origin.y - CGRectGetHeight(frame);
        self.textField.superview.frame = frame;
    } completion:nil];
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    NSLog(@"[NativeKeyboardText keyboardDidShowNotification]");
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    NSLog(@"[NativeKeyboardText keyboardWillHideNotification]");
    NSLog(@"%@", notification.userInfo);

    NSDictionary* userInfo = notification.userInfo;

    BOOL isKeyboardDisappear = [self doesKeyboardDisappear:userInfo];

    UIViewAnimationCurve animationCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat animationDuration           = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:animationDuration delay:0.0f options:(UIViewAnimationOptions)animationCurve animations:^{
        [self moveTextFieldAtBottomAndHide:isKeyboardDisappear];
    } completion:nil];
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    NSLog(@"[NativeKeyboardText keyboardDidHideNotification]");
    isKeyboardInDockMode = NO;
}

#pragma mark ChangeFrame

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSLog(@"[NativeKeyboardText keyboardWillChangeFrameNotification]");
    NSLog(@"%@", notification.userInfo);

    NSDictionary* userInfo = notification.userInfo;

    BOOL willKeyboardBeHidden = [self doesKeyboardDisappear:userInfo];

    isKeyboardAppearing = !isKeyboardPresented && !willKeyboardBeHidden;
    isKeyboardDismissing = isKeyboardPresented && willKeyboardBeHidden;

    if (isKeyboardDismissing && !isKeyboardInDockMode) {
        UIViewAnimationCurve animationCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        CGFloat animationDuration           = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

        [UIView animateWithDuration:animationDuration delay:0.0f options:(UIViewAnimationOptions)animationCurve animations:^{
            [self moveTextFieldAtBottomAndHide:YES];
        } completion:nil];
    }
}

- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification {
    NSLog(@"[NativeKeyboardText keyboardDidChangeFrameNotification]");
    NSLog(@"%@", notification.userInfo);

    NSDictionary* userInfo = notification.userInfo;

    BOOL isKeyboardHidden = [self doesKeyboardDisappear:userInfo];

    isKeyboardPresented = !isKeyboardHidden;

    isKeyboardAppearing = NO;
    isKeyboardDismissing = NO;

    if (!isKeyboardPresented) {
        // Keyboard seems to be closed, but for transition to Floating state we need to wait some time to check
        // if Keyboard is not shown nor in appearing transition
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self->isKeyboardPresented || self->isKeyboardAppearing) {
                [self moveTextFieldAtBottomAndHide:NO];
            } else {
                [self unsubscribeFromNotificationAndDispose];
            }
        });
    } else if (!isKeyboardInDockMode) {
        // restore TextField visibility that could be fully hidden in `keyboardWillChangeFrameNotification` method
        [self moveTextFieldAtBottomAndHide:NO];
    }
}

@end

#pragma mark - UIDevice

@implementation ANXNativeKeyboardText (UIDevice)

- (void)deviceOrientationDidChangeNotification:(NSNotification*)notification {
    NSLog(@"[NativeKeyboardText deviceOrientationDidChangeNotification]");
    NSLog(@"%@", notification.userInfo);

    [self adjustTextFieldFrame];
}

@end

#pragma mark - Utils

@implementation ANXNativeKeyboardText (Utils)

- (UIView*)findTopmostView {
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (rootViewController == nil) {
        return nil;
    }
    return rootViewController.view;
}

- (BOOL)doesKeyboardDisappear:(NSDictionary*)userInfo {
    CGRect frame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // if Keyboard's end frame is out of screen it disappears
    if (frame.origin.y >= UIScreen.mainScreen.bounds.size.height) {
        return YES;
    }

    // if Keyboard's height is too small it disappears in Floating mode
    if (frame.size.height < 44.0) {
        return YES;
    }

    return NO;
}

#pragma mark Styles

- (UIColor*)textFieldBackgroundColor {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
        return UIColor.secondarySystemBackgroundColor;
    } else {
        return [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:247.0/255.0 alpha:1.0];
    }
}

- (UIColor*)textFieldWrapperBackgroundColor {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
        return UIColor.systemBackgroundColor;
    } else {
        return UIColor.whiteColor;
    }
}

#pragma mark TextField

- (UITextField*)createTextField {
    UIView* view = [self findTopmostView];
    if (view == nil) {
        return nil;
    }

    UITextField* inputTextField = [[ANXTextField alloc] init];
    inputTextField.delegate = self;
    inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    inputTextField.backgroundColor = self.textFieldBackgroundColor;
    inputTextField.clearButtonMode = UITextFieldViewModeAlways;
    inputTextField.returnKeyType = UIReturnKeyDone;
    inputTextField.secureTextEntry = _params.isSecureTextEntry;
    inputTextField.keyboardType = _params.keyboardType;
    inputTextField.returnKeyType = _params.returnKeyType;
    inputTextField.autocapitalizationType = _params.autoCapitalizationType;
    inputTextField.autocorrectionType = _params.autoCorrectionType;
    inputTextField.spellCheckingType = _params.spellCheckingType;
    inputTextField.inputAssistantItem.leadingBarButtonGroups = @[];
    inputTextField.inputAssistantItem.trailingBarButtonGroups = @[];

    [inputTextField sizeToFit];

    CGFloat textFieldHeight = inputTextField.frame.size.height;
    CGFloat wrapperHeight   = textFieldHeight + PADDING * 2;

    CGRect rect = CGRectMake(0.0, CGRectGetMaxY(view.bounds) - wrapperHeight,
                             CGRectGetWidth(view.bounds), wrapperHeight);

    UIView* wrapper = [[UIView alloc] initWithFrame:rect];
    wrapper.hidden = YES;
    wrapper.backgroundColor = self.textFieldWrapperBackgroundColor;
    [view addSubview:wrapper];

    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1.0, wrapper.bounds.size.width, 0.5)];
    line.backgroundColor = UIColor.systemGrayColor;
    line.alpha = 0.8;
    line.tag = 1198;
    [wrapper addSubview:line];

    UIEdgeInsets safeArea = view.safeAreaInsets;
    CGFloat left = MAX(safeArea.left, PADDING);
    CGFloat right = MAX(safeArea.right, PADDING);

    inputTextField.frame = CGRectMake(left, PADDING, wrapper.bounds.size.width - (left + right), textFieldHeight);
    [wrapper addSubview:inputTextField];

    return inputTextField;
}

- (void)moveTextFieldAtBottomAndHide:(BOOL)hide {
    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    if (!self.textField) {
        return;
    }

    CGRect frame = self.textField.superview.frame;
    if (hide) {
        frame.origin.y = CGRectGetMaxY(view.bounds);
    } else {
        frame.origin.y = CGRectGetMaxY(view.bounds) - CGRectGetHeight(frame);
    }
    self.textField.superview.frame = frame;
}

- (void)adjustTextFieldFrame {
    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    if (!self.textField) {
        return;
    }

    // wrapper

    UIView* wrapper = self.textField.superview;

    CGRect wrapperFrame = wrapper.frame;
    wrapperFrame.size.width = CGRectGetWidth(view.bounds);
    wrapper.frame = wrapperFrame;

    // line

    UIView* line = [wrapper viewWithTag:1198];

    CGRect lineFrame = line.frame;
    lineFrame.size.width = wrapper.bounds.size.width;
    line.frame = lineFrame;

    // input

    UIEdgeInsets safeArea = view.safeAreaInsets;
    CGFloat left = MAX(safeArea.left, PADDING);
    CGFloat right = MAX(safeArea.right, PADDING);

    CGRect inputFrame = self.textField.frame;
    inputFrame.origin.x = left;
    inputFrame.size.width = wrapper.bounds.size.width - (left + right);
    self.textField.frame = inputFrame;
}

#pragma mark TapGestureRecognizer

- (UITapGestureRecognizer*)createTapGestureRecognizer {
    UIView* view = [self findTopmostView];
    if (view == nil) {
        return nil;
    }

    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [view addGestureRecognizer:recognizer];

    return recognizer;
}

- (void)handleTapGesture:(UITapGestureRecognizer*)recognizer {
    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    CGPoint location = [recognizer locationInView:view];

    if (self.textField && CGRectContainsPoint(self.textField.superview.frame, location)) {
        return;
    }

    [self hideKeyboard:nil];
}

@end

#pragma mark - UITextFieldDelegate

@implementation ANXNativeKeyboardText (UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboard:nil];
    [self dispatch:@"NativeKeyboardText.Keyboard.Input" withLevel:textField.text];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_params.maxCharactersCount == 0) {
        return YES;
    }

    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;

    NSUInteger newLength = oldLength - rangeLength + replacementLength;

    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;

    return newLength <= _params.maxCharactersCount || returnKey;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"[NativeKeyboardText textFieldShouldBeginEditing]");
    [self dispatch:@"NativeKeyboardText.Keyboard.Show" withLevel:@""];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    NSLog(@"[NativeKeyboardText textFieldDidEndEditing]");
    [self dispatch:@"NativeKeyboardText.Keyboard.Hide" withLevel:[NSString stringWithFormat:@"{\"oldText\":\"%@\", \"newText\":\"%@\"}", _params.text ? _params.text : @"", textField.text]];
}

@end

#pragma mark - FREDispatcher

@implementation ANXNativeKeyboardText (FREDispatcher)

- (void)dispatch:(NSString*)code withLevel:(NSString*)level {
    FREDispatchStatusEventAsync(self.context, (const uint8_t*) [code UTF8String], (const uint8_t*) [level UTF8String]);
}

- (void)dispatchError:(NSString *)code {
    [self dispatch:code withLevel:@"error"];
}

- (void)dispatchStatus:(NSString *)code {
    [self dispatch:code withLevel:@"status"];
}

@end
