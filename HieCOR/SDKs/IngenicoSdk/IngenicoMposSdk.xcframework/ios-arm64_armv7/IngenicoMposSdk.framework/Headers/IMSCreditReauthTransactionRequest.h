/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSTokenizableSaleTransactionRequest.h"
#import "IMSAmount.h"

/*!
 * This object contains information required for processing a re-auth on a credit auth transaction.
 */

@interface IMSCreditReauthTransactionRequest : IMSTokenizableSaleTransactionRequest

/*!
 * Transaction ID of the original sale transaction generated by Ingenico Payment Server.
 */

@property (nonatomic, strong) NSString * _Nonnull originalSaleTransactionID;

/*!
 * Constructs a credit re-auth request.
 * @param originalSaleTransactionID     id of the credit auth transaction to do a re-auth
 * @param amount                        re-auth amount
 * @param isCompleted                   indicates whether the transaction is completed,
 *                                      if true the transaction cannot be updated later
 */

- (id _Nullable) initWithOriginalSaleTransactionID:(NSString * _Nonnull)originalSaleTransactionID andAmount:(IMSAmount * _Nonnull)amount andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a credit re-auth request.
 * @param originalSaleTransactionID     id of the credit auth transaction to do a re-auth
 * @param amount                        re-auth amount
 * @param products                      list of products
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param transactionGroupID            a unique identifier for a group of transactions, used to link
 *                                      transactions which are related (like split-tender).
 *                                      If not specified in the request, it will be generated and returned in the response.
 *                                      For linked transactions, the value generated from the first response
 *                                      should be submitted with all related transactions.
 */

- (id _Nullable) initWithOriginalSaleTransactionID:(NSString * _Nonnull)originalSaleTransactionID andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID;

/*!
 * Constructs a credit re-auth request.
 * @param originalSaleTransactionID     id of the credit auth transaction to do a re-auth
 * @param amount                        re-auth amount
 * @param products                      list of products
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param transactionGroupID            a unique identifier for a group of transactions, used to link
 *                                      transactions which are related (like split-tender).
 *                                      If not specified in the request, it will be generated and returned in the response.
 *                                      For linked transactions, the value generated from the first response
 *                                      should be submitted with all related transactions.
 */

- (id _Nullable) initWithOriginalSaleTransactionID:(NSString * _Nonnull)originalSaleTransactionID andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID;

/*!
 * Constructs a credit re-auth request.
 * @param originalSaleTransactionID     id of the credit auth transaction to do a re-auth
 * @param amount                        re-auth amount
 * @param products                      list of products
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param transactionGroupID            a unique identifier for a group of transactions, used to link
 *                                      transactions which are related (like split-tender).
 *                                      If not specified in the request, it will be generated and returned in the response.
 *                                      For linked transactions, the value generated from the first response
 *                                      should be submitted with all related transactions.
 * @param transactionNotes              transactionNotes
 * @param merchantInvoiceID             The invoice id from a third party inventory management tool linked to this transaction.
 *                                      Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt  true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id _Nullable) initWithOriginalSaleTransactionID:(NSString * _Nonnull)originalSaleTransactionID andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

/*!
 * Constructs a credit re-auth request.
 * @param originalSaleTransactionID     id of the credit auth transaction to do a re-auth
 * @param amount                        re-auth amount
 * @param products                      list of products
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param transactionGroupID            a unique identifier for a group of transactions, used to link
 *                                      transactions which are related (like split-tender).
 *                                      If not specified in the request, it will be generated and returned in the response.
 *                                      For linked transactions, the value generated from the first response
 *                                      should be submitted with all related transactions.
 * @param transactionNotes              transactionNotes
 * @param merchantInvoiceID             The invoice id from a third party inventory management tool linked to this transaction.
 *                                      Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt  true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference               20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param isCompleted                   indicates whether the transaction is completed,
 *                                      if true the transaction cannot be updated later
 */

- (id _Nullable) initWithOriginalSaleTransactionID:(NSString * _Nonnull)originalSaleTransactionID andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a credit re-auth request.
 * @param originalSaleTransactionID     id of the credit auth transaction to do a re-auth
 * @param amount                        re-auth amount
 * @param products                      list of products
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param transactionGroupID            a unique identifier for a group of transactions, used to link
 *                                      transactions which are related (like split-tender).
 *                                      If not specified in the request, it will be generated and returned in the response.
 *                                      For linked transactions, the value generated from the first response
 *                                      should be submitted with all related transactions.
 * @param transactionNotes              transactionNotes
 * @param merchantInvoiceID             The invoice id from a third party inventory management tool linked to this transaction.
 *                                      Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt  true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference               20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param isCompleted                   indicates whether the transaction is completed,
 *                                      if true the transaction cannot be updated later
 * @param tokenRequestParameters        Request to enroll/update for a token.
 *                                      Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 */

- (id _Nullable) initWithOriginalSaleTransactionID:(NSString * _Nonnull)originalSaleTransactionID andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters;

/*!
 * Constructs a credit re-auth request.
 * @param originalSaleTransactionID     id of the credit auth transaction to do a re-auth
 * @param amount                        re-auth amount
 * @param products                      list of products
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param transactionGroupID            a unique identifier for a group of transactions, used to link
 *                                      transactions which are related (like split-tender).
 *                                      If not specified in the request, it will be generated and returned in the response.
 *                                      For linked transactions, the value generated from the first response
 *                                      should be submitted with all related transactions.
 * @param transactionNotes              transactionNotes
 * @param merchantInvoiceID             The invoice id from a third party inventory management tool linked to this transaction.
 *                                      Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt  true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference               20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param isCompleted                   indicates whether the transaction is completed,
 *                                      if true the transaction cannot be updated later
 * @param tokenRequestParameters        Request to enroll/update for a token.
 *                                      Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param orderNumber                   Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id _Nullable) initWithOriginalSaleTransactionID:(NSString * _Nonnull)originalSaleTransactionID andAmount:(IMSAmount * _Nonnull)amount andProducts:(NSArray * _Nullable)products andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLat andTransactionGroupID:(NSString * _Nullable)transactionGroupID andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference andIsCompleted:(bool) isCompleted andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andOrderNumber:(NSString * _Nullable)orderNumber;

@end
