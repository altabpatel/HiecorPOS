/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This object contains information about the amount charged/refunded for a transaction.
 */
@interface IMSAmount : NSObject

/*!
 * The total amount charged in cents.(Required filed for transactions)
 * In case of a refund, this is the refunded amount to the original Payer.
 */

@property (nonatomic) NSInteger total;

/*!
 * Subtotal amount of items being paid for in cents.
 */

@property (nonatomic) NSInteger subTotal;

/*!
 * Tax amount charged in cents.
 */

@property (nonatomic) NSInteger tax;

/*!
 * Discount amount in cents.
 */

@property (nonatomic) NSInteger discount;

/*!
 * Discount description E.g. "Summer Sale".
 */
@property (nonatomic, strong) NSString *discountDescription;

/*!
 * Tip amount in cents.
 */

@property (nonatomic) NSInteger tip;

/*!
 * ASCII representation of currency code.
 */

@property (nonatomic, strong) NSString *currency;

/*!
 * Surcharge amount in cents.
 */
@property (nonatomic) NSInteger surcharge;

- (id) initWithTotal:(NSInteger)total andSubtotal:(NSInteger)subtotal andTax:(NSInteger)tax andDiscount:(NSInteger)discount andDiscountDescription:(NSString *)discountDescription andTip:(NSInteger)tip andCurrency:(NSString *)currency;

- (id) initWithTotal:(NSInteger)total andSubtotal:(NSInteger)subtotal andTax:(NSInteger)tax andDiscount:(NSInteger)discount andDiscountDescription:(NSString *)discountDescription andTip:(NSInteger)tip andCurrency:(NSString *)currency andSurcharge:(NSInteger)surcharge;

- (NSDictionary*)toNSDictionary;
@end
