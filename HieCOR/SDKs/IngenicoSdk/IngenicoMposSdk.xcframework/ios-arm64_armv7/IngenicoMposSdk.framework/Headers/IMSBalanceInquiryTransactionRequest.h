/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseTransactionRequest.h"

@interface IMSBalanceInquiryTransactionRequest : IMSBaseTransactionRequest

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */

@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Constructs a credit balance inquiry request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id) initWithClerkID:(NSString *)clerkID
         andLongitude:(NSString *)gpsLong
          andLatitude:(NSString *)gpsLal;

/*!
 * Constructs a credit balance inquiry request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 */

- (id) initWithClerkID:(NSString *)clerkID
          andLongitude:(NSString *)gpsLong
           andLatitude:(NSString *)gpsLal
    andCustomReference:(NSString *)customReference;

/*!
 * Constructs a credit balance inquiry request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id) initWithClerkID:(NSString *)clerkID
          andLongitude:(NSString *)gpsLong
           andLatitude:(NSString *)gpsLal
    andCustomReference:(NSString *)customReference
          andUCIFormat:(IMSUCIFormat)uciFormat;

/*!
 * Constructs a credit balance inquiry request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithClerkID:(NSString *)clerkID
          andLongitude:(NSString *)gpsLong
           andLatitude:(NSString *)gpsLal
    andCustomReference:(NSString *)customReference
          andUCIFormat:(IMSUCIFormat)uciFormat
          andOrderNumber:(NSString *)orderNumber;

@end
