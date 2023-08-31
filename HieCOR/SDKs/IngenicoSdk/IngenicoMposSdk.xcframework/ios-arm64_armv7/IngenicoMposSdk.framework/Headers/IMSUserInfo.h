/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "IMSAccountFlags.h"

/*!
 * This object contains information about the merchant.
 */

@interface IMSUserInfo : NSObject

/*!
 * Returns the account flags that determine what actions need to be performed for first time login.
 * @see IMSAccountFlags
 */

@property (readonly) IMSAccountFlags *accountFlags;

/*!
 * User's cell phone number.
 */

@property (readonly) NSString *cellPhone;

/*!
 * User's first name.
 */

@property (readonly) NSString *firstName;

/*!
 * User's last name.
 */

@property (readonly) NSString *lastName;

/*!
 * Locale set by user.
 */

@property (readonly) NSString *locale;

/*!
 * User's middle name initial.
 */

@property (readonly) NSString *middleNameInitial;

/*!
 * User's other phone number.
 */

@property (readonly) NSString *otherPhone;

/*!
 * User's primary email address.
 */

@property (readonly) NSString *primaryEmail;

/*!
 * The security questions and answers selected by the user.
 * @see IMSSecurityQuestion
 */

@property (readonly) NSArray *securityQuestions;

/*!
 * User's title.
 */

@property (readonly) NSString *title;

/*!
 * User's username.
 */
@property (readonly) NSString *userName;

/*!
 * User's work phone.
 */

@property (readonly) NSString *workPhone;

- (id) initWithAccountFlags:(IMSAccountFlags *)accountFlags
               andCellphone:(NSString *)cellphone
               andFirstName:(NSString *)firstName
                andLastName:(NSString *)lastName
                  andLocale:(NSString *)locale
       andMiddleNameInitial:(NSString *)middleNameInitial
              andOtherPhone:(NSString *)otherPhone
            andPrimaryEmail:(NSString *)primaryEmail
       andSecurityQuestions:(NSArray *)securityQuestions
                   andTitle:(NSString *)title
                andUserName:(NSString *)userName
               andWorkPhone:(NSString *)workPhone;

@end
