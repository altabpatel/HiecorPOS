/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * This object contains information about a product.
 */

@interface IMSProduct : NSObject

/*!
 * Product name.
 */

@property (nonatomic, strong) NSString *name;

/*!
 * Product price in cents.
 */

@property (nonatomic) NSInteger price;


/*!
 * Custom notes.
 */

@property (nonatomic, strong) NSString *note;

/*!
 * Base 64 encoded string representation of the image.
 */

@property (nonatomic, strong) NSString *base64EncodedProductImage;

/*!
 * Product quantity.
 */

@property (nonatomic) NSInteger quantity;

- (id) initWithName:(NSString *)productName andPrice:(NSInteger)productPrice andNote:(NSString *)productNote andImage:(NSString *)base64EncodedProductImage andQuantity:(NSInteger)quantity;

@end
