/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSCashSaleTransactionRequest.h"

/*!
 * This object contains information required for store and forward cash sale transaction.
 */

@interface IMSStoreAndForwardCashSaleTransactionRequest : IMSCashSaleTransactionRequest

/*!
 * Constructs a store and forward cash sale transaction request.
 * @param amount sale amount
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a store and forward cash sale transaction request.
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
 * Constructs a store and forward cash sale transaction request.
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
 * Constructs a store and forward cash sale transaction request.
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

@end

