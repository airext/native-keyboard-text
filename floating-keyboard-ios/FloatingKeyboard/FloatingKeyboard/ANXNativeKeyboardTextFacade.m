//
//  ANXNativeKeyboardTextFacade.m
//  ANXNativeKeyboardText
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import "ANXNativeKeyboardTextFacade.h"
#import "FlashRuntimeExtensions.h"
#import "ANXNativeKeyboardTextConversionRoutines.h"
#import "ANXNativeKeyboardText.h"
#import "ANXNativeKeyboardTextParams.h"

@implementation ANXNativeKeyboardTextFacade

@end

#pragma mark API

FREObject ANXNativeKeyboardTextIsSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNativeKeyboardTextIsSupported");
    FREObject result;
    FRENewObjectFromBool(YES, &result);
    return result;
}

FREObject ANXNativeKeyboardTextShowKeyboard(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNativeKeyboardTextShowKeyboard");
    if (argc < 1) {
        return NULL;
    }

    ANXNativeKeyboardTextParams* params = [[ANXNativeKeyboardTextParams alloc] initWithFREObject:argv[0]];
    [ANXNativeKeyboardText.sharedInstance showKeyboard:params];

    return NULL;
}

FREObject ANXNativeKeyboardTextHideKeyboard(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXNativeKeyboardTextHideKeyboard");
    [ANXNativeKeyboardText.sharedInstance hideKeyboard:nil];
    return NULL;
}

#pragma mark ContextInitialize/ContextFinalizer

void ANXNativeKeyboardTextContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    NSLog(@"ANXNativeKeyboardTextContextInitializer");

    *numFunctionsToSet = 3;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));

    // functions

    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &ANXNativeKeyboardTextIsSupported;

    func[1].name = (const uint8_t*) "showKeyboard";
    func[1].functionData = NULL;
    func[1].function = &ANXNativeKeyboardTextShowKeyboard;


    func[2].name = (const uint8_t*) "hideKeyboard";
    func[2].functionData = NULL;
    func[2].function = &ANXNativeKeyboardTextHideKeyboard;

    *functionsToSet = func;

    // Store reference to the context

    ANXNativeKeyboardText.sharedInstance.context = ctx;
}

void ANXNativeKeyboardTextContextFinalizer(FREContext ctx) {
    NSLog(@"ANXNativeKeyboardTextContextFinalizer");
    ANXNativeKeyboardText.sharedInstance.context = nil;
}

#pragma mark Initializer/Finalizer

void ANXNativeKeyboardTextInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    NSLog(@"ANXNativeKeyboardTextInitializer");

    *extDataToSet = NULL;

    *ctxInitializerToSet = &ANXNativeKeyboardTextContextInitializer;
    *ctxFinalizerToSet = &ANXNativeKeyboardTextContextFinalizer;
}

void ANXNativeKeyboardTextFinalizer(void* extData) {
    NSLog(@"ANXNativeKeyboardTextFinalizer");
}
