/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/

#import <Foundation/Foundation.h>
#import "IMSEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class IMSPreference;

@interface IMSPreferenceBuilder : NSObject

@property (nonatomic) IMSConfigMode configMode;
@property (nonatomic) NSUInteger retryCount;
@property (nonatomic, strong) NSLocale * _Nullable merchantLocale;

- (IMSPreference *)build;

@end

NS_ASSUME_NONNULL_END
