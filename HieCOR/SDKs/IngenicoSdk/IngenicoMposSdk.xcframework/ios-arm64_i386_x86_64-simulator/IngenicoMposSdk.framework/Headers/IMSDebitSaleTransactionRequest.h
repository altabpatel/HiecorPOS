/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseSaleTransactionRequest.h"

/*!
 * This object contains information required for debit sale transaction.
 */

@interface IMSDebitSaleTransactionRequest : IMSBaseSaleTransactionRequest

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */

@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Constructs a debit  card sale transaction request.
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

- (id) initWithAmount:(IMSAmount *)amount andProducts:(NSArray *)products andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID;

/*!
 * Constructs a debit  card sale transaction request.
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

- (id) initWithAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID;

/*!
 * Constructs a debit  card sale transaction request.
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
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id) initWithAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

/*!
* Constructs a debit  card sale transaction request.
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
* @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
*                          Alphanumeric characters only. Max length: 15 chars
* @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
* @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
*/

- (id) initWithAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference;

/*!
 * Constructs a debit  card sale transaction request.
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
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a debit  card sale transaction request.
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
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id) initWithAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andIsCompleted:(bool) isCompleted andUCIFormat:(IMSUCIFormat) uciFormat;

/*!
 * Constructs a debit  card sale transaction request.
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
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andIsCompleted:(bool) isCompleted andUCIFormat:(IMSUCIFormat) uciFormat andOrderNumber: (NSString *) orderNumber;


@end
