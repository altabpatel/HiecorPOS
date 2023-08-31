/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSTokenizableSaleTransactionRequest.h"
#import "IMSCard.h"

/*!
 * This object contains information required for keyed in credit auth transaction.
 */

@interface IMSKeyedCreditAuthTransactionRequest : IMSTokenizableSaleTransactionRequest

/*!
 * Information of card used to make the purchase.
 * @see IMSCard
 */

@property (nonatomic, strong) IMSCard * _Nonnull card;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */

@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Indicates whether card was present for this transaction
 */
@property (nonatomic) bool isCardPresent;

/*!
 * Constructs a keyed in card sale transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID;

/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param tokenRequestParameters            Request to enroll for a token.
 *                                          Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters;

/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param tokenRequestParameters            Request to enroll for a token.
 *                                          Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param customReference                   20 digit merchant order number (optional)
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andCustomReference:(NSString * _Nullable)customReference;
/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param tokenRequestParameters            Request to enroll for a token.
 *                                          Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param tokenRequestParameters            Request to enroll for a token.
 *                                          Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andUCIFormat:(IMSUCIFormat) uciFormat;

/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param tokenRequestParameters            Request to enroll for a token.
 *                                          Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 * @param uciFormat                         Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                     indicate if this transaction was done manually because
 *                                          prior swipe attempts have failed. <br>
 *                                          true - if card is present <br>
 *                                          false - if card is not present
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andUCIFormat:(IMSUCIFormat) uciFormat andIsCardPresent:(bool)isCardPresent;

/*!
 * Constructs a keyed in credit auth transaction request.
 * @param card                              keyed in card data used for this transaction
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param tokenRequestParameters            Request to enroll for a token.
 *                                          Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 * @param uciFormat                         Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                     indicate if this transaction was done manually because
 *                                          prior swipe attempts have failed. <br>
 *                                          true - if card is present <br>
 *                                          false - if card is not present
 * @param orderNumber                       Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id _Nullable) initWithCard:(IMSCard * _Nonnull)card andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andUCIFormat:(IMSUCIFormat) uciFormat andIsCardPresent:(bool)isCardPresent andOrderNumber:(NSString * _Nullable)orderNumber;

@end
