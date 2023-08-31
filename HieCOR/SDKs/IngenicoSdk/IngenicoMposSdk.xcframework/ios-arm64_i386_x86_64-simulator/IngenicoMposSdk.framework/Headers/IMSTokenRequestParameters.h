/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

@class IMSTokenRequestParametersBuilder;
/*!
 * Enum of supported token request types.
 */
typedef NS_ENUM(NSUInteger, IMSTokenRequestType){
    /*!
     * Default
     */
    IMSTokenRequestTypeUnknown = 0,
    /*!
     * Request a new token enrollment
     */
    IMSTokenRequestTypeEnroll = 1,
    /*!
     * Request a token update
     */
    IMSTokenRequestTypeUpdate = 2
};

/*!
 * This immutable class constructs a request for enrolling a token. Use @see IMSTokenRequestParametersBuilder to construct this request.
 */
@interface IMSTokenRequestParameters : NSObject

/*!
 * Type of request.
 */

@property (readonly) IMSTokenRequestType requestType;

/*!
 * Token identifier to be used when updating an existing token
 */

@property (readonly) NSString *tokenIdentifier;

/*!
 * The fee charged when the token is created. (if supported by tokenization service) (optional)
 * Numeric(1-16)
 */

@property (readonly) NSInteger tokenFeeInCents;

/*!
 * Account reference number for tokenization service. (optional)
 * Ascii(1-12)
 */

@property (readonly) NSString *tokenReferenceNumber;

/*!
 * Card holder's first name.(optional)
 * Ascii(1-30)
 */

@property (readonly) NSString *cardholderFirstName;

/*!
 * Card holder's last name.(optional)
 * Ascii(1-30)
 */

@property (readonly) NSString *cardholderLastName;

/*!
 * Billing email.(optional)
 * Ascii(1-40)
 */

@property (readonly) NSString *billToEmail;

/*!
 * Billing address line 1.(optional)
 * Alphanumeric(1-40)
 */

@property (readonly) NSString *billToAddress1;

/*!
 * Billing address line 2.(optional)
 * Alphanumeric(1-40)
 */

@property (readonly) NSString *billToAddress2;

/*!
 * Billing City.(optional)
 * Alphanumeric(1-20)
 */

@property (readonly) NSString *billToCity;

/*!
 * Billing State.(optional)
 * Alphanumeric(1-2), Eg: MA
 */

@property (readonly) NSString *billToState;

/*!
 * Sets the 3-character standard country code (optional)
 * Alphanumeric(3-3)
 */

@property (readonly) NSString *billToCountry;

/*!
 * Billing zip code.(optional)
 * Alphanumeric(1-10)
 */

@property (readonly) NSString *billToZip;

/*!
 * Whether to ignore the result of AVS check on token enrollment trasaction
 */

@property (readonly) bool ignoreAVSResult;


- (id) initWithBuilder:(IMSTokenRequestParametersBuilder *)builder;

@end
