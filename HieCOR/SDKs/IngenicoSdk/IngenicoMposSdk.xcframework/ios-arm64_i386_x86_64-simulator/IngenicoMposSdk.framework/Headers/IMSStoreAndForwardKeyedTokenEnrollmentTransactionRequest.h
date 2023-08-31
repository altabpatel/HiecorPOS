/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSTokenEnrollmentTransactionRequest.h"

@interface IMSStoreAndForwardKeyedTokenEnrollmentTransactionRequest : IMSTokenEnrollmentTransactionRequest

/*!
 * Indicates whether the card security code is requested from the customer or not.
 */
@property (nonatomic) bool isCardCVVRequested;

/*!
 * Indicates whether the zipcode is requested from the customer or not
 */
@property (nonatomic) bool isCardAVSRequested;

/*!
 * Indicates whether card was present for this transaction
 */
@property (nonatomic) bool isCardPresent;

/*!
 * Constructs a keyed store and forward token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal;

/*!
 * Constructs a keyed store and forward token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal
                         andUCIFormat:(IMSUCIFormat)uciFormat;

/*!
 * Constructs a keyed store and forward token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number.
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal
                         andUCIFormat:(IMSUCIFormat)uciFormat
                       andOrderNumber:(NSString *)orderNumber;

/*!
 * Constructs a keyed store and forward token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number.
 * @param isCardAVSRequested           indicates if the zipcode is requested
 * @param isCardCVVRequested           indicates if the card cvv is requested
 * @param isCardPresent                indicate if this transaction was done manually because prior swipe attempts have failed. <br>
 *                            true - if card is present <br>
 *                            false - if card is not present
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal
                         andUCIFormat:(IMSUCIFormat)uciFormat
                       andOrderNumber:(NSString *)orderNumber
                andIsCardAVSRequested:(bool)isCardAVSRequested
                andIsCardCVVRequested:(bool)isCardCVVRequested
                     andIsCardPresent:(bool)isCardPresent;

@end
