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
 * This object contains information about the card holder.
 */

@interface IMSCardholderInfo : NSObject

/*!
 * Card holder's first name.
 */

@property (nonatomic, strong) NSString *firstName;

/*!
 * Card holder's last name.
 */

@property (nonatomic, strong) NSString *lastName;

/*!
 * Card holder's middle name.
 */

@property (nonatomic, strong) NSString *middleName;

/*!
 * Card holder's email address.
 */

@property (nonatomic, strong) NSString *email;

/*!
 * Card holder's phone number.
 */

@property (nonatomic, strong) NSString *phone;

/*!
 * Card holder's address line 1.
 */

@property (nonatomic, strong) NSString *address1;

/*!
 * Card holder's address line 2.
 */

@property (nonatomic, strong) NSString *address2;

/*!
 * Card holder's city.
 */

@property (nonatomic, strong) NSString *city;

/*!
 * Card holder's state.
 */

@property (nonatomic, strong) NSString *state;

/*!
 * Card holder's postal code.
 */

@property (nonatomic, strong) NSString *postalCode;


- (id) initWithFirstName:(NSString *)firstName
             andLastName:(NSString *)lastName
           andMiddleName:(NSString *)middleName
                andEmail:(NSString *)email
                andPhone:(NSString *)phone
             andAddress1:(NSString *)address1
             andAddress2:(NSString *)address2
                 andCity:(NSString *)city
                andState:(NSString *)state
           andPostalCode:(NSString *)postalCode;

@end
