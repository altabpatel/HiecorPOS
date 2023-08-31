/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/

#import "IMSBaseTransactionRequest.h"
#import "IMSTokenRequestParameters.h"


/*!
 * This object contains information required for keyed token enrollment transaction with card reader.
 */
@interface IMSKeyedTokenEnrollmentWithCardReaderTransactionRequest : IMSBaseTransactionRequest

/*!
 * Request to enroll for a token.
 * Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters.
 * @see IMSTokenRequestParameters
 */
@property (nonatomic, strong) IMSTokenRequestParameters *tokenRequestParameters;

/*!
 * Indicates whether the card security code is requested from the customer or not
 */
@property (nonatomic) bool isCardCVVRequested;

/*!
 * Indicates whether the zipcode is requested from the customer or not
 */
@property (nonatomic) bool isCardAVSRequested;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */
@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Indicates whether card was present for this transaction
 */
@property (nonatomic) bool isCardPresent;


/*!
 * Constructs a keyed token enrollment with card reader transaction request.
 * @param tokenRequestParams Request to enroll for a token.
 *                           Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 * @param isCardAVSRequested true if card zipcode needs to be requested, false if not
 * @param isCardCVVRequested true if card CVV needs to be requested, false if not
 * @param isCardPresent                indicate if this transaction was done manually because
 *                                     prior swipe attempts have failed. <br>
 *                                     true - if card is present <br>
 *                                     false - if card is not present
 */

- (id) initWithTokenRequestParameters:(IMSTokenRequestParameters *)tokenRequestParams
                           andClerkID:(NSString *)clerkID
                         andLongitude:(NSString *)gpsLong
                          andLatitude:(NSString *)gpsLal
                         andUCIFormat:(IMSUCIFormat)uciFormat
                       andOrderNumber:(NSString *)orderNumber
                andIsCardCVVRequested:(bool) isCardCVVRequested
                andIsCardAVSRequested:(bool) isCardAVSRequested
                     andIsCardPresent:(bool)isCardPresent;

@end
