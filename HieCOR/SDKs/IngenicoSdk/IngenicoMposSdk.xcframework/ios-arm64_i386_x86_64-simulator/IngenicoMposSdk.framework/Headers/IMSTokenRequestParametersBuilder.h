/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */
#import <Foundation/Foundation.h>
#import "IMSTokenRequestParameters.h"

/*!
 * This class can be used to build token request parameters (@see IMSTokenRequestParameters) to enroll for
 * a token.
 */
@interface IMSTokenRequestParametersBuilder : NSObject

@property (nonatomic) IMSTokenRequestType requestType;
@property (nonatomic, strong) NSString *tokenIdentifier;
@property (nonatomic) NSInteger tokenFeeInCents;
@property (nonatomic, strong) NSString *tokenReferenceNumber;
@property (nonatomic, strong) NSString *cardholderFirstName;
@property (nonatomic, strong) NSString *cardholderLastName;
@property (nonatomic, strong) NSString *billToEmail;
@property (nonatomic, strong) NSString *billToAddress1;
@property (nonatomic, strong) NSString *billToAddress2;
@property (nonatomic, strong) NSString *billToCity;
@property (nonatomic, strong) NSString *billToState;
@property (nonatomic, strong) NSString *billToCountry;
@property (nonatomic, strong) NSString *billToZip;
@property (nonatomic) bool ignoreAVSResult;

/*!
 * Builds and returns the token request parameters for token enroll.
 * @return (@see IMSTokenRequestParameters) object
 */
- (IMSTokenRequestParameters *) createTokenEnrollmentRequestParameters;

/*!
 * Builds and returns the token request parameters for token update.
 * @return (@see IMSTokenRequestParameters) object
 */
- (IMSTokenRequestParameters *) createTokenUpdateRequestParameters;

@end
