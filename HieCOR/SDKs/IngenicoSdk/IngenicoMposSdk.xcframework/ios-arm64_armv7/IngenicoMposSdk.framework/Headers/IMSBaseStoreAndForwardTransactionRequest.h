/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSTokenizableSaleTransactionRequest.h"


/*!
 * This object contains information required for store and forward transaction.
 */

@interface IMSBaseStoreAndForwardTransactionRequest : IMSTokenizableSaleTransactionRequest


/*!
 * Constructs a store and forward sale transaction request.
 * @param type transaction type
 * @param amount sale amount
 * @param products list of products
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a store and forward sale transaction request.
 * @param type transaction type
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
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a store and forward sale transaction request.
 * @param type transaction type
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
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a store and forward sale transaction request.
 * @param type transaction type
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
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString*)customReference andIsCompleted:(bool)isCompleted;

/*!
 * Constructs a store and forward sale transaction request.
 * @param type transaction type
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
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString*)customReference andIsCompleted:(bool)isCompleted andOrderNumber:(NSString *)orderNumber;


/*!
 * Constructs a store and forward sale transaction request.
 * @param type transaction type
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
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 * @param tokenRequestParameters Request to enroll for a token
 *                               Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString*)customReference andIsCompleted:(bool)isCompleted andOrderNumber:(NSString *)orderNumber andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters;
@end
