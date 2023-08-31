/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "IMSEnum.h"

/*!
 * This object contains information about the card used for making the purchase.
 * This is used for transactions made by both manual entry (keyed) and using card reader.
 */

@interface IMSCard : NSObject

/*!
 * Clear Primary Account Number (PAN) for keyed transactions
 * and redacted PAN for card transactions.
 */

@property (nonatomic, strong) NSString *cardNumber;

/*!
 * Card expiration date.
 */

@property (nonatomic, strong) NSString *cardExpirationDate;

/*!
 * Card CVV.
 */

@property (nonatomic, strong) NSString *cardCVV;

/*!
 * Card AVS. Accepts zip code only.
 */

@property (nonatomic, strong) NSString *cardAVS;

/*!
 * Returns point of sale entry mode.
 * @see IMSPOSEntryMode
 */

@property (nonatomic) IMSPOSEntryMode posEntryMode;


- (id) initWithNumber:(NSString *)number andExpirationDate:(NSString *)expirationDate andCVV:(NSString *)cvv andAVS:(NSString *)avs andPOSEntryMode:(IMSPOSEntryMode)posEntryMode;

@end
