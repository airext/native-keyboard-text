//
//  ANXFloatingKeyboardFacade.m
//  ANXFloatingKeyboard
//
//  Created by Max Rozdobudko on 10/20/19.
//  Copyright © 2019 AirExt. All rights reserved.
//

#import "ANXFloatingKeyboardFacade.h"
#import "FlashRuntimeExtensions.h"
#import "ANXFloatingKeyboardConversionRoutines.h"
#import "ANXFloatingKeyboard.h"
#import "ANXFloatingKeyboardParams.h"

@implementation ANXFloatingKeyboardFacade

@end

#pragma mark API

FREObject ANXFloatingKeyboardIsSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXFloatingKeyboardIsSupported");
    FREObject result;
    FRENewObjectFromBool(YES, &result);
    return result;
}

FREObject ANXFloatingKeyboardShowKeyboard(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXFloatingKeyboardShowKeyboard");
    if (argc < 1) {
        return NULL;
    }

    ANXFloatingKeyboardParams* params = [[ANXFloatingKeyboardParams alloc] initWithFREObject:argv[0]];
    [ANXFloatingKeyboard.sharedInstance showKeyboard:params];

    return NULL;
}

FREObject ANXFloatingKeyboardHideKeyboard(FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {
    NSLog(@"ANXFloatingKeyboardHideKeyboard");
    [ANXFloatingKeyboard.sharedInstance hideKeyboard:nil];
    return NULL;
}

#pragma mark ContextInitialize/ContextFinalizer

void ANXFloatingKeyboardContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    NSLog(@"ANXFloatingKeyboardContextInitializer");

    *numFunctionsToSet = 3;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));

    // functions

    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &ANXFloatingKeyboardIsSupported;

    func[1].name = (const uint8_t*) "showKeyboard";
    func[1].functionData = NULL;
    func[1].function = &ANXFloatingKeyboardShowKeyboard;


    func[2].name = (const uint8_t*) "hideKeyboard";
    func[2].functionData = NULL;
    func[2].function = &ANXFloatingKeyboardHideKeyboard;

    *functionsToSet = func;

    // Store reference to the context

    ANXFloatingKeyboard.sharedInstance.context = ctx;
}

void ANXFloatingKeyboardContextFinalizer(FREContext ctx) {
    NSLog(@"ANXFloatingKeyboardContextFinalizer");
    ANXFloatingKeyboard.sharedInstance.context = nil;
}

#pragma mark Initializer/Finalizer

void ANXFloatingKeyboardInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    NSLog(@"ANXFloatingKeyboardInitializer");

    *extDataToSet = NULL;

    *ctxInitializerToSet = &ANXFloatingKeyboardContextInitializer;
    *ctxFinalizerToSet = &ANXFloatingKeyboardContextFinalizer;
}

void ANXFloatingKeyboardFinalizer(void* extData) {
    NSLog(@"ANXFloatingKeyboardFinalizer");
}
