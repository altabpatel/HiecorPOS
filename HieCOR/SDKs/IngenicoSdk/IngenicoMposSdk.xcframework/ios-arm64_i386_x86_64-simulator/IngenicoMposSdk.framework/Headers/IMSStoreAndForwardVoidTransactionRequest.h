/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseTransactionRequest.h"

/*!
 * This class contains information required for a store and forward void transaction.
 */

@interface IMSStoreAndForwardVoidTransactionRequest : IMSBaseTransactionRequest

/*!
 * Client Transaction ID of the original transaction
 */

@property (nonatomic, strong) NSString * _Nonnull originalClientTransactionID;

/*!
 * Constructs a void request
 * @param originalClientTransactionID id of the transaction to void
 */

- (id _Nullable) initWithOriginalClientTransactionID:(NSString *_Nonnull)originalClientTransactionID;

/*!
 * Constructs a void request with mandatory fields that are common for all void transaction requests.
 * @param originalClientTransactionID id of the transaction to void
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional)
 */

- (id _Nullable) initWithOriginalClientTransactionID:(NSString *_Nonnull)originalClientTransactionID andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andCustomReference:(NSString * _Nullable)customReference;

/*!
 * Constructs a void request with mandatory fields that are common for all void transaction requests.
 * @param originalClientTransactionID id of the transaction to void
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id _Nullable) initWithOriginalClientTransactionID:(NSString *_Nonnull)originalClientTransactionID andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andCustomReference:(NSString * _Nullable)customReference andOrderNumber:(NSString * _Nullable)orderNumber;

/*!
 * Constructs a void request with mandatory fields that are common for all void transaction requests.
 * @param originalClientTransactionID id of the transaction to void
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id _Nullable) initWithOriginalClientTransactionID:(NSString *_Nonnull)originalClientTransactionID andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andCustomReference:(NSString * _Nullable)customReference andOrderNumber:(NSString * _Nullable)orderNumber andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

@end
