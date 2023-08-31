/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "IMSConfiguration.h"
#import "IMSSession.h"
#import "IMSUserInfo.h"
#import "IMSProcessor.h"
#import "IMSCapabilities.h"

/**
 * This object contains information about the user's information, configuration etc.
 */

@interface IMSUserProfile : NSObject

/*!
 * The chain id assigned to the merchant.
 */

@property (readonly) NSString *chainID;

/*!
 * Users's configurations.
 * @see IMSConfiguration
 */

@property (readonly) IMSConfiguration *configuration;

/*!
 * Users's processor information.
 * @see IMSProcessor
 */

@property (readonly) IMSProcessor *processor;

/*!
 * The current session.
 * @see IMSSession
 */

@property (readonly) IMSSession *session;

/*!
 * The store id assigned to the merchant.
 */

@property (readonly) NSString *storeID;

/*!
 * The terminal id assigned to the users's device.
 */

@property (readonly) NSString *terminalID;

/*!
 * Users's information.
 * @see IMSUserInfo
 */

@property (readonly) IMSUserInfo *userInfo;

/*!
 * For internal use only.
 */

@property (readonly) NSString *version;

/*!
 * Current SDK capabilities
 * @see IMSCapabilities
 */

@property (readonly) IMSCapabilities *capabilities;

- (id) initWithChainID:(NSString *)chainID
      andConfiguration:(IMSConfiguration *)configiration
          andProcessor:(IMSProcessor *)processor
            andSession:(IMSSession *)session
            andStoreID:(NSString *)storeID
         andTerminalID:(NSString *)terminalID
           andUserInfo:(IMSUserInfo *)userInfo
            andVersion:(NSString *)version
       andCapabilities:(IMSCapabilities *) capabilities;

@end
