/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This object contains information about currency.
 */

@interface IMSCurrency : NSObject

/*!
 * The ASCII representation of currency code.
 * Eg. USD
 */

@property (readonly) NSString *code;

/*!
 * The ISO 4217 currency code.
 * Eg: 840
 */

@property (readonly) NSInteger iso;

/*!
 * The currency symbol.
 * Eg: "$"
 */

@property (readonly) NSString *symbol;

- (id) initWithCode:(NSString *)code andIso:(NSInteger)iso andSymbol:(NSString *)symbol;

@end
