/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseStoreAndForwardTransactionRequest.h"

/*!
 * This object contains information required for store and forward keyed card sale transaction.
 */

@interface IMSStoreAndForwardKeyedCardSaleTransactionRequest : IMSBaseStoreAndForwardTransactionRequest

/*!
 * Indicates whether the card security code is requested from the customer or not.
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
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID merchantInvoiceID Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt showNotesAndInvoiceOnReceipt
 * @param customReference 20 digit merchant order number (optional)
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted;

 
 /*!
  * Constructs a store and forward sale transaction request.
  * @param amount sale amount
  * @param products list of products
  * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
  *                The field can be alphanumeric and length cannot exceed 4 characters.
  * @param gpsLong longitude of the device location
  * @param gpsLal latitude of the device location
  * @param transactionGroupID a unique identifier for a group of transactions, used to link
  *                           transactions which are related (like split-tender).
  *                           If not specified in the request, it will be generated and returned in the response.
  *                           For linked transactions, the value generated from the first response
  *                           should be submitted with all related transactions.
  * @param transactionNotes transactionNotes
  * @param merchantInvoiceID merchantInvoiceID Alphanumeric characters only. Max length: 15 chars
  * @param showNotesAndInvoiceOnReceipt showNotesAndInvoiceOnReceipt
  * @param customReference 20 digit merchant order number (optional)
  * @param isCompleted indicates whether the transaction is completed,
  *                    if true the transaction cannot be updated later
  * @param isCardAVSRequested true if card AVS (zipcode) needs to be requested, false if not
  */
- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andIsCardAVSRequested:(bool) isCardAVSRequested;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID merchantInvoiceID Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt showNotesAndInvoiceOnReceipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param isCardAVSRequested true if card zipcode needs to be requested, false if not
 * @param isCardCVVRequested true if card cvv needs to be requested, false if not
 */
- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andIsCardAVSRequested:(bool) isCardAVSRequested andIsCardCVVRequested:(bool) isCardCVVRequested;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID merchantInvoiceID Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt showNotesAndInvoiceOnReceipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param isCardAVSRequested true if card zipcode needs to be requested, false if not
 * @param isCardCVVRequested true if card cvv needs to be requested, false if not
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */
- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andIsCardAVSRequested:(bool) isCardAVSRequested andIsCardCVVRequested:(bool) isCardCVVRequested andUCIFormat:(IMSUCIFormat) uciFormat;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID merchantInvoiceID Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt showNotesAndInvoiceOnReceipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param isCardAVSRequested true if card zipcode needs to be requested, false if not
 * @param isCardCVVRequested true if card cvv needs to be requested, false if not
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                indicate if this transaction was done manually because
 *                                     prior swipe attempts have failed. <br>
 *                                     true - if card is present <br>
 *                                     false - if card is not present
 */
- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andIsCardAVSRequested:(bool) isCardAVSRequested andIsCardCVVRequested:(bool) isCardCVVRequested andUCIFormat:(IMSUCIFormat) uciFormat andIsCardPresent:(bool)isCardPresent;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID merchantInvoiceID Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt showNotesAndInvoiceOnReceipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param isCardAVSRequested true if card zipcode needs to be requested, false if not
 * @param isCardCVVRequested true if card cvv needs to be requested, false if not
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                indicate if this transaction was done manually because
 *                                     prior swipe attempts have failed. <br>
 *                                     true - if card is present <br>
 *                                     false - if card is not present
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */
- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andIsCardAVSRequested:(bool) isCardAVSRequested andIsCardCVVRequested:(bool) isCardCVVRequested andUCIFormat:(IMSUCIFormat) uciFormat andIsCardPresent:(bool)isCardPresent andOrderNumber:(NSString * _Nullable)orderNumber;

/*!
 * Constructs a store and forward sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID merchantInvoiceID Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt showNotesAndInvoiceOnReceipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param isCardAVSRequested true if card zipcode needs to be requested, false if not
 * @param isCardCVVRequested true if card cvv needs to be requested, false if not
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                indicate if this transaction was done manually because
 *                                     prior swipe attempts have failed. <br>
 *                                     true - if card is present <br>
 *                                     false - if card is not present
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 * @param tokenRequestParameters Request to enroll for a token
 *                               Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 */
- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andIsCardAVSRequested:(bool) isCardAVSRequested andIsCardCVVRequested:(bool) isCardCVVRequested andUCIFormat:(IMSUCIFormat) uciFormat andIsCardPresent:(bool)isCardPresent andOrderNumber:(NSString * _Nullable)orderNumber andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters;

@end

