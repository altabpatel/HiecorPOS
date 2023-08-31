/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/

#import "IMSTokenizableRefundTransactionRequest.h"
#import "IMSAmount.h"
/*!
 * This object contains information required for keyed credit refund transaction with card reader.
 */

@interface IMSKeyedCreditRefundTransactionWithCardReaderRequest : IMSTokenizableRefundTransactionRequest

/*!
 * Amount being collected.
 * @see IMSAmount
 */
@property (nonatomic, strong) IMSAmount *  _Nonnull amount;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */
@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Indicates whether card was present for this transaction
 */
@property (nonatomic) bool isCardPresent;

/*!
 * Constructs a keyed credit refund transaction with card reader request.
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param tokenRequestParameters Request to enroll for a token.
 *                               Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param customReference 20 digit merchant order number (optional)
 *                    if true the transaction cannot be updated later
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                indicate if this transaction was done manually because
 *                                     prior swipe attempts have failed. <br>
 *                                     true - if card is present <br>
 *                                     false - if card is not present
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */
- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andCustomReference:(NSString * _Nullable)customReference andUCIFormat:(IMSUCIFormat) uciFormat andIsCardPresent:(bool)isCardPresent andOrderNumber:(NSString * _Nullable)orderNumber;

@end
