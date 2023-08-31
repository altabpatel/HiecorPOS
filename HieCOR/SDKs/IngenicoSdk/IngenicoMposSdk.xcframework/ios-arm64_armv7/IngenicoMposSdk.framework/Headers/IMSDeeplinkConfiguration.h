/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "IMSEnum.h"

/*!
 * Internal use only
 * This immutable class contains configuration values specific to the RPX deep link feature
 */
@interface IMSDeeplinkConfiguration : NSObject

/*!
 * Is a non-changeable setting.
 * Returns if Deep link is enabled for the user.
 * @return true  - if enabled
 *         false - otherwise
 */
@property (readonly) bool enabled;

/*!
 * Is a non-changeable setting.
 * Returns the Deep link callback Url for the user
 * @return String representation of the callback Url, nil if not configured
*/
@property (readonly) NSString *callbackUrl;

/*!
 * Is a non-changeable setting.
 * Returns the Deep link callback secret for the user
 * @return String representation of the callback secret, nil if not configured
*/
@property (readonly) NSString *callbackSecret;

/*!
 * Is a non-changeable setting.
 * Returns the reply strategy used by RPX to send the data back to the calling application
 * @return The reply strategy used by RPX to send the data back to the calling application, Unknown if not configured
*/
@property (readonly) IMSDeeplinkReplyStrategy replyStrategy;

/*!
 * Is a non-changeable setting.
 * Returns which Personal Identifiable Information (PII) should be sent in the transaction response
 * @return The PII data to be sent in the transaction response, Unknown if not configured
*/
@property (readonly) IMSDeeplinkPiiData singularPiiDataToInclude;

- (id)  initWithIsEnabled:(bool)enabled
           andCallbackUrl:(NSString *) callbackUrl
        andCallbackSecret:(NSString *) callbackSecret
         andReplyStrategy:(IMSDeeplinkReplyStrategy) replyStrategy
andSingularPiiDataToInclude:(IMSDeeplinkPiiData) singularPiiDataToInclude;

@end
