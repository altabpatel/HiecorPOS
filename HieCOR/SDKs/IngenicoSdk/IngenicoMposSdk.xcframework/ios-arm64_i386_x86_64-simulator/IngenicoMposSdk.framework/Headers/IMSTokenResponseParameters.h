/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * Status of the token request
 */
typedef NS_ENUM(NSUInteger, IMSTokenResponseCode){
    /*!
     * Default
     */
    IMSTokenResponseCodeUnknown = 0,
    /*!
     * Token was returned successfully.
     */
    IMSTokenResponseCodeApproved = 1,
    /*!
     * Token not requested because the transaction authorization was declined.
     */
    IMSTokenResponseCodeDeclined = 2,
    /*!
     * Service provider error. Call @see tokenSourceData for details.
     */
    IMSTokenResponseCodeError = 3,
    /*!
     * Error connecting to the tokenization service provider.
     */
    IMSTokenResponseCodeCommunicationError = 4
};

/*!
 * This object contains information about the result of the token request.
 */
@interface IMSTokenResponseParameters : NSObject

/*!
 * Present if a token was requested from any provider, contains the status of the token request
 * @see IMSTokenResponseCode
 */

@property (readonly) IMSTokenResponseCode responseCode;

/*!
 * Present if a token was requested from any provider, contains the token returned by the service
 */

@property (readonly) NSString *tokenIdentifier;

/*!
 * Present if a token was requested from any provider, contains the provider of the token request
 */

@property (readonly) NSString *tokenSource;

/*!
 * Tokenization service specified fields, if the client wants specific details about the tokenization service (Optional)
 * Returns JSON string of Tokenization service specified fields
 */

@property (readonly) NSString *tokenSourceData;

/*!
 * Present if a token was requested from any provider, contains the fee charged in cents
 */

@property (readonly) NSInteger tokenFeeInCents;

-(id) initWithTokenResponseCode:(IMSTokenResponseCode) responseCode
         andWithTokenIdentifier:(NSString *)tokenIdentifier
             andWithTokenSource:(NSString *)tokenSource
         andWithTokenSourceData:(NSString *)tokenSourceData
             andTokenFeeInCents:(NSInteger)tokenFeeInCents;

- (NSDictionary*)toNSDictionary;
@end
