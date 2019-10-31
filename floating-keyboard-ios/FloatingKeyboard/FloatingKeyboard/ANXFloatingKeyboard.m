//
//  ANXFloatingKeyboard.m
//  ANXFloatingKeyboard
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import "ANXFloatingKeyboard.h"
#import "ANXTextField.h"

#define PADDING 8.0f

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation ANXFloatingKeyboard

#pragma mark - Shared Instance

static ANXFloatingKeyboard* _sharedInstance = nil;
+ (ANXFloatingKeyboard*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];

    }
    return _sharedInstance;
}

#pragma mark Synthesized Properties

@synthesize context;

#pragma mark - API

- (void)showKeyboard:(ANXFloatingKeyboardParams*)params {
    NSLog(@"[ANXFloatingKeyboard showKeyboard]");

    _params = params;

    [self subscribeToKeyboardNotifications];

    self.textField = [self createTextField];

    self.tapGestureRecognizer = [self createTapGestureRecognizer];

    [self.textField.superview setHidden:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
        self.textField.text = self->_params.text;
    });
}

- (void)hideKeyboard:(id)sender {
    NSLog(@"[ANXFloatingKeyboard hideKeyboard]");

    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    [view endEditing:YES];
}

- (void)subscribeToKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)unsubscribeFromKeyboardNotificationAndDispose {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textField.superview removeFromSuperview];
    [self.tapGestureRecognizer.view removeGestureRecognizer:self.tapGestureRecognizer];
}

@end

#pragma mark - UIKeyboard

@implementation ANXFloatingKeyboard (UIKeyboard)

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardWillShowNotification]");

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
    NSLog(@"[ANXFloatingKeyboard keyboardDidShowNotification]");
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardWillHideNotification]");
    NSLog(@"%@", notification.userInfo);

    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    NSDictionary* userInfo = notification.userInfo;

    BOOL isKeyboardDisappear = [self doesKeyboardDisappear:userInfo];

    UIViewAnimationCurve animationCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat animationDuration           = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:animationDuration delay:0.0f options:(UIViewAnimationOptions)animationCurve animations:^{
        CGRect frame = self.textField.superview.frame;
        if (isKeyboardDisappear) {
            frame.origin.y = CGRectGetMaxY(view.bounds);
        } else {
            frame.origin.y = CGRectGetMaxY(view.bounds) - frame.size.height;
        }
        self.textField.superview.frame = frame;
    } completion:nil];
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardDidHideNotification]");
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardWillChangeFrameNotification]");
    NSLog(@"%@", notification.userInfo);
}

- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardDidChangeFrameNotification]");
    NSLog(@"%@", notification.userInfo);

    if ([self doesKeyboardDisappear:notification.userInfo]) {
        [self unsubscribeFromKeyboardNotificationAndDispose];
    }
}

@end

#pragma mark - Utils

@implementation ANXFloatingKeyboard (Utils)

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
    [wrapper addSubview:line];

    inputTextField.frame = CGRectMake(PADDING, PADDING, CGRectGetWidth(wrapper.bounds) - PADDING * 2, textFieldHeight);
    [wrapper addSubview:inputTextField];

    return inputTextField;
}

- (UITapGestureRecognizer*)createTapGestureRecognizer {
    UIView* view = [self findTopmostView];
    if (view == nil) {
        return nil;
    }

    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [view addGestureRecognizer:recognizer];

    return recognizer;
}

@end

#pragma mark - UITextFieldDelegate

@implementation ANXFloatingKeyboard (UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboard:nil];
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
    NSLog(@"[ANXFloatingKeyboard textFieldShouldBeginEditing]");
    [self dispatch:@"FloatingKeyboard.Keyboard.Show" withLevel:@""];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    NSLog(@"[ANXFloatingKeyboard textFieldDidEndEditing]");
    [self dispatch:@"FloatingKeyboard.Keyboard.Hide" withLevel:[NSString stringWithFormat:@"{\"oldText\":\"%@\", \"newText\":\"%@\"}", _params.text ? _params.text : @"", textField.text]];
}

@end

#pragma mark - FREDispatcher

@implementation ANXFloatingKeyboard (FREDispatcher)

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
