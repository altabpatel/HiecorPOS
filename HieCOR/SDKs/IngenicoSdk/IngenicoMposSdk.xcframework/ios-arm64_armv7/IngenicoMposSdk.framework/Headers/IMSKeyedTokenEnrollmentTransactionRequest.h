/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseTransactionRequest.h"
#import "IMSTokenRequestParameters.h"
#import "IMSCard.h"

@interface IMSKeyedTokenEnrollmentTransactionRequest : IMSBaseTransactionRequest

/*!
 * Request to enroll for a token.
 * Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters.
 * @see IMSTokenRequestParameters
 */
@property (nonatomic, strong) IMSTokenRequestParameters *tokenRequestParameters;

/*!
 * Keyed in card data used for this request
 * @see IMSCard
 */
@property (nonatomic, strong) IMSCard *card;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */
@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Constructs a token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param card keyed in card data used for this request
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                              andCard:(IMSCard *)card
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal;

/*!
 * Constructs a token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param card keyed in card data used for this request
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                              andCard:(IMSCard *)card
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal
                         andUCIFormat:(IMSUCIFormat)uciFormat;

/*!
 * Constructs a token enrollment request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param card keyed in card data used for this request
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                              andCard:(IMSCard *)card
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal
                         andUCIFormat:(IMSUCIFormat)uciFormat
                         andOrderNumber:(NSString *)orderNumber;
@end
