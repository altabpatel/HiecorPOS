/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This object represents the current session.
 */

@interface IMSSession : NSObject

/*!
 * The session token for the current session.
 */

@property (readonly) NSString *sessionToken;

/*!
 * The time when the session would expire.
 */

@property (readonly) NSString *expiresTime;

- (id) initWithSessionToken:(NSString *)sessionToken andExpiresTime:(NSString *)expiresTime;

@end
