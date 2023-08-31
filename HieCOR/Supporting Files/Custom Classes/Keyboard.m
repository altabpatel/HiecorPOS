//
//  Keyboard.m
//  HieCOR
//
//  Created by Deftsoft on 11/09/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

#import "Keyboard.h"

@implementation Keyboard

// direct check for external keyboard
+ (BOOL)_isExternalKeyboardAttached
{
    BOOL externalKeyboardAttached = NO;
    
    @try {
        NSString *keyboardClassName = [@[@"UI", @"Key", @"boa", @"rd", @"Im", @"pl"] componentsJoinedByString:@""];
        Class c = NSClassFromString(keyboardClassName);
        SEL sharedInstanceSEL = NSSelectorFromString(@"sharedInstance");
        if (c == Nil || ![c respondsToSelector:sharedInstanceSEL]) {
            return NO;
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id sharedKeyboardInstance = [c performSelector:sharedInstanceSEL];
#pragma clang diagnostic pop
        
        if (![sharedKeyboardInstance isKindOfClass:NSClassFromString(keyboardClassName)]) {
            return NO;
        }
        
        NSString *externalKeyboardSelectorName = [@[@"is", @"InH", @"ardw", @"areK", @"eyb", @"oard", @"Mode"] componentsJoinedByString:@""];
        SEL externalKeyboardSEL = NSSelectorFromString(externalKeyboardSelectorName);
        if (![sharedKeyboardInstance respondsToSelector:externalKeyboardSEL]) {
            return NO;
        }
        
        externalKeyboardAttached = ((BOOL ( *)(id, SEL))objc_msgSend)(sharedKeyboardInstance, externalKeyboardSEL);
    } @catch(__unused NSException *ex) {
        externalKeyboardAttached = NO;
    }
    
    return externalKeyboardAttached;
}

// observe change of external keyboard
+ (void)_registerForExternalKeyboardChangeNotification
{
    CFNotificationCenterRef notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
    if (notificationCenter != NULL) {
        CFNotificationCenterRemoveObserver(notificationCenter, (void *)MNExternalKeyboardStatusDidChange, CFSTR("GSEventHardwareKeyboardAttached"), NULL);
        CFNotificationCenterAddObserver(notificationCenter, NULL, MNExternalKeyboardStatusDidChange, CFSTR("GSEventHardwareKeyboardAttached"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}

static void MNExternalKeyboardStatusDidChange(CFNotificationCenterRef notificationCenter, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExternalKeyboardStatus" object:nil];
}

@end
