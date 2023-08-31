//
//  Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
//

#import <Foundation/Foundation.h>

@interface IMSQuickflowConfiguration : NSObject

/*!
 * Is a non-changeable setting.
 * Returns if Quick flow is enabled for the user.
 * @return true  - if enabled
 *         false - otherwise
 */
@property (readonly) bool enabled;

- (id)  initWithIsEnabled:(bool)enabled;

@end

