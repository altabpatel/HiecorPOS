/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright (c) 2015 - 2019 All Rights Reserved, Ingenico Inc
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSVoidTransactionRequest.h"
#import "IMSAmount.h"

/*!
 * This object contains information required for a partial void transaction.
 */

@interface IMSPartialVoidTransactionRequest : IMSVoidTransactionRequest

/*!
 * Amount to which the original auth amount will be reduced to
 */
@property (nonatomic, strong) IMSAmount *  _Nonnull amount;

/*!
 * Constructs a partial void request with mandatory fields.
 * @param amount                        amount to which the original auth amount should be reduced, in cents.
 *                                      Must be less than original auth amount. Will result in error otherwise.
 *                                      Eg: If amount is set to 80 for an original auth of 100
 *                                      after partial void the auth is open for 80
 * @param originalSaleTransactionID     id of the transaction to reverse
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 */

- (id) initWithAmount:(IMSAmount *)amount andOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLat;

/*!
 * Constructs a partial void request.
 * @param amount                        amount to which the original auth amount should be reduced, in cents.
 *                                      Must be less than original auth amount. Will result in error otherwise.
 *                                      Eg: If amount is set to 80 for an original auth of 100
 *                                      after partial void the auth is open for 80
 * @param originalSaleTransactionID     id of the transaction to reverse
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param customReference               20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 */

- (id) initWithAmount:(IMSAmount *)amount andOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLat andCustomReference:(NSString *)customReference;

/*!
 * Constructs a partial void request.
 * @param amount                        amount to which the original auth amount should be reduced, in cents.
 *                                      Must be less than original auth amount. Will result in error otherwise.
 *                                      Eg: If amount is set to 80 for an original auth of 100
 *                                      after partial void the auth is open for 80
 * @param originalSaleTransactionID     id of the transaction to reverse
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param customReference               20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param transactionNotes              transactionNotes
 */

- (id) initWithAmount:(IMSAmount *)amount andOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLat andCustomReference:(NSString *)customReference andTransactionNotes:(NSString *)transactionNotes;

/*!
 * Constructs a partial void request.
 * @param amount                        amount to which the original auth amount should be reduced, in cents.
 *                                      Must be less than original auth amount. Will result in error otherwise.
 *                                      Eg: If amount is set to 80 for an original auth of 100
 *                                      after partial void the auth is open for 80
 * @param originalSaleTransactionID     id of the transaction to reverse
 * @param clerkID                       ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                      The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                       longitude of the device location
 * @param gpsLat                        latitude of the device location
 * @param customReference               20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param transactionNotes              transactionNotes
 * @param orderNumber                   Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithAmount:(IMSAmount *)amount andOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLat andCustomReference:(NSString *)customReference andTransactionNotes:(NSString *)transactionNotes andOrderNumber:(NSString *)orderNumber;

@end
