/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This class contains information about a card returned from getCardDetails API
 */
@interface IMSCardDetails : NSObject

/*!
 * The cardholder's name
 */
@property (readonly) NSString *cardholderName;

/*!
 * The redacted card number
 */
@property (readonly) NSString *redactedCardNumber;


- (id) initWithCardholderName:(NSString *) cardholderName redactedCardNumber:(NSString *) redactedCardNumber;

@end

