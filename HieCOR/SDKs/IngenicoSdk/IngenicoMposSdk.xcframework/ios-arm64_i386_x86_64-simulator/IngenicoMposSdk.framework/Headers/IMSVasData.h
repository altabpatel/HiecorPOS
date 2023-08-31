/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/

#import <Foundation/Foundation.h>

/**
* This immutable class contains information about Apple VAS Data..
*/
@interface IMSVasData : NSObject

/*!
* Merchant identifer
*/
@property(nonatomic, strong, readonly) NSString* merchantID;
/*!
* Mobile Token
*/
@property(nonatomic, strong, readonly) NSString* mobileToken;
/*!
* Apple VAS Data
*/
@property(nonatomic, strong, readonly) NSString* vasData;

-(instancetype)initWithMerchantID:(NSString*)merchantID mobileToken:(NSString*)mobileToken vasData:(NSString*)data;

-(NSDictionary*)toNSDictionary;

@end
