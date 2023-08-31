/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSTokenEnrollmentTransactionRequest.h"

@interface IMSStoreAndForwardTokenEnrollmentTransactionRequest : IMSTokenEnrollmentTransactionRequest

/*!
* Indicates if expiry date validation will be performed before storing the transaction.
  If false (default), transactions with expired cards will be stored.
*/
@property (nonatomic) bool validateCardExpirationDate;

/*!
 * Constructs a store and forward token enrollment request.
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
 * Constructs a store and forward token enrollment request.
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
 * Constructs a store and forward token enrollment request.
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
 * Constructs a store and forward token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number.
 * @param validateCardExpirationDate should validate card expiration date
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal
                         andUCIFormat:(IMSUCIFormat)uciFormat
                       andOrderNumber:(NSString *)orderNumber
        andValidateCardExpirationDate:(bool) validateCardExpirationDate;

@end
