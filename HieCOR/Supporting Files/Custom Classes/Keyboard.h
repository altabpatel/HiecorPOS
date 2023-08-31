//
//  Keyboard.h
//  HieCOR
//
//  Created by Deftsoft on 11/09/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

@interface Keyboard : NSObject
+ (BOOL)_isExternalKeyboardAttached;
+ (void)_registerForExternalKeyboardChangeNotification;
@end
