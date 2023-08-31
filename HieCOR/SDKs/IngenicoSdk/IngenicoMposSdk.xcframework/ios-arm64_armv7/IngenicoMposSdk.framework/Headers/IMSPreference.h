/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/

#import <Foundation/Foundation.h>
#import "IMSEnum.h"
#import "IMSPreferenceBuilder.h"

/**
* This class contains information about the user's preference of using mPOS EMV SDK.
*/
@interface IMSPreference : NSObject

/*!
 * Indicates to what degree mPOS EMV SDK can implicitly set up the device or perform firmware update to ensure EMV capability
 * @return IMSConfigMode config mode
 */
@property (nonatomic) IMSConfigMode configMode;

/*!
 * Number of times that firmware update will be attempted in case of failure. Default = 0, Max = 3
 * @ return NSUInteger retry count
 */
@property (nonatomic) NSUInteger retryCount;

/*!
 * Merchant's preferred locale
 * If set, this locale will be used as the default locale for all transactions unless explicitly overridden by
 * transaction locale field in all TransactionRequest classes or by ICC card
 */
@property (nonatomic, strong) NSLocale * _Nullable merchantLocale;

- (id)initWithConfigMode:(IMSConfigMode)configMode andRetryCount:(NSUInteger)retryCount;

-(id)initWithBuilder:(IMSPreferenceBuilder *)builder;

@end

