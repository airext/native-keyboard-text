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

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Synthesized Properties

@synthesize context;

#pragma mark - API

- (void)showKeyboard:(ANXFloatingKeyboardParams*)params {
    NSLog(@"[ANXFloatingKeyboard showKeyboard]");

    _params = params;

    self.textField = [self createTextField];
    [self.textField.superview setHidden:YES];

    self.tapGestureRecognizer = [self createTapGestureRecognizer];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textField.superview setHidden:NO];
        [self.textField becomeFirstResponder];
        [self.textField setText:self->_params.text];
    });
}

- (void)hideKeyboard:(id)sender {
    NSLog(@"[ANXFloatingKeyboard hideKeyboard]");

    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    [view endEditing:YES];
    [view removeGestureRecognizer:self.tapGestureRecognizer];
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
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardDidShowNotification]");
    [self dispatch:@"FloatingKeyboard.Keyboard.Show" withLevel:@""];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardWillHideNotification]");

    UIView* view = [self findTopmostView];
    if (view == nil) {
        return;
    }

    NSDictionary* userInfo = notification.userInfo;

    UIViewAnimationCurve animationCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat animationDuration           = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:animationDuration delay:0.0f options:(UIViewAnimationOptions)animationCurve animations:^{
        CGRect frame = self.textField.superview.frame;
        frame.origin.y = CGRectGetMaxY(view.bounds);
        self.textField.superview.frame = frame;
    } completion:^(BOOL finished) {
        [self.textField.superview removeFromSuperview];
        [view removeGestureRecognizer:self.tapGestureRecognizer];
    }];
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    NSLog(@"[ANXFloatingKeyboard keyboardDidHideNotification]");
    [self dispatch:@"FloatingKeyboard.Keyboard.Hide" withLevel:[NSString stringWithFormat:@"{\"oldText\":\"%@\", \"newText\":\"%@\"}", _params.text ? _params.text : @"", _latestInputString]];
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

    [inputTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [inputTextField setBackgroundColor:self.textFieldBackgroundColor];
    [inputTextField setClearButtonMode:UITextFieldViewModeAlways];
    [inputTextField setReturnKeyType:UIReturnKeyDone];
    [inputTextField setSecureTextEntry:_params.isSecureTextEntry];

    [inputTextField sizeToFit];

    CGFloat textFieldHeight = inputTextField.frame.size.height;
    CGFloat wrapperHeight   = textFieldHeight + PADDING * 2;

    CGRect rect = CGRectMake(0.0, CGRectGetMaxY(view.bounds) - wrapperHeight,
                             CGRectGetWidth(view.bounds), wrapperHeight);

    UIView* wrapper = [[UIView alloc] initWithFrame:rect];
    [wrapper setBackgroundColor:self.textFieldWrapperBackgroundColor];
    [view addSubview:wrapper];

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

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    _latestInputString = textField.text;
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
