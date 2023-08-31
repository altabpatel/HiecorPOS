/*
 *
 * Copyright (c) 2015 - 2018 All Rights Reserved, Ingenico Inc.
 *
 */

#import "IMSBaseTransactionRequest.h"

@interface IMSAVSOnlyTransactionRequest : IMSBaseTransactionRequest

/*!
 * Zip code to be used for address verification.
 */

@property (nonatomic, strong) NSString* avsZipCode;

/*!
 * Address line to be used for address verification.
 */

@property (nonatomic, strong) NSString* avsAddress;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */

@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Constructs an AVS only request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLat latitude of the device location
 * @param avsZipCode AVS zip code
 * @param avsAddress AVS address
 */

- (id) initWithClerkID:(NSString *)clerkID
          andLongitude:(NSString *)gpsLong
           andLatitude:(NSString *)gpsLat
         andAVSZipCode:(NSString *)avsZipCode
         andAVSAddress:(NSString *)avsAddress;

/*!
 * Constructs an AVS only request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLat latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param avsZipCode AVS zip code
 * @param avsAddress AVS address
 */

- (id) initWithClerkID:(NSString *)clerkID
          andLongitude:(NSString *)gpsLong
           andLatitude:(NSString *)gpsLat
    andCustomReference:(NSString *)customReference
         andAVSZipCode:(NSString *)avsZipCode
         andAVSAddress:(NSString *)avsAddress;

/*!
 * Constructs an AVS only request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLat latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param avsZipCode AVS zip code
 * @param avsAddress AVS address
 */

- (id) initWithClerkID:(NSString *)clerkID
          andLongitude:(NSString *)gpsLong
           andLatitude:(NSString *)gpsLat
    andCustomReference:(NSString *)customReference
          andUCIFormat:(IMSUCIFormat)uciFormat
         andAVSZipCode:(NSString *)avsZipCode
         andAVSAddress:(NSString *)avsAddress;

/*!
 * Constructs an AVS only request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLat latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param avsZipCode AVS zip code
 * @param avsAddress AVS address
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithClerkID:(NSString *)clerkID
          andLongitude:(NSString *)gpsLong
           andLatitude:(NSString *)gpsLat
    andCustomReference:(NSString *)customReference
          andUCIFormat:(IMSUCIFormat)uciFormat
         andAVSZipCode:(NSString *)avsZipCode
         andAVSAddress:(NSString *)avsAddress
         andOrderNumber:(NSString *)orderNumber;
@end


