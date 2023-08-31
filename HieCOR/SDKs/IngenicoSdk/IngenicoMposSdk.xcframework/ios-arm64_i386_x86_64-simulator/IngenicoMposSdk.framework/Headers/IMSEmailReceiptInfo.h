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
 * This object contains information which can be shown in email receipt.
 */
@interface IMSEmailReceiptInfo : NSObject

/*!
 * Base 64 encoded string representation of merchant's logo.
 */

@property (nonatomic, strong) NSString *logoBase64;

/*!
 * User's custom message.
 */

@property (nonatomic, strong) NSString *merchantMessage;

/*!
 * User's email address.
 */

@property (nonatomic, strong) NSString *email;

/*!
 * User's phone number.
 */

@property (nonatomic, strong) NSString *phoneNumber;

/*!
 * User's website URL.
 */

@property (nonatomic, strong) NSString *websiteURL;

/*!
 * User's Facebook URL.
 */

@property (nonatomic, strong) NSString *facebookURL;

/*!
 * User's Twitter URL.
 */

@property (nonatomic, strong) NSString *twitterURL;

/*!
 * User's Instagram URL.
 */

@property (nonatomic, strong) NSString *instagramURL;

/*!
 * Name of user's business.
 */

@property (nonatomic, strong) NSString *businessName;

/*!
 * Business' address line 1.
 */

@property (nonatomic, strong) NSString *address1;

/*!
 * Business' address line 2.
 */

@property (nonatomic, strong) NSString *address2;

/*!
 * Business' city.
 */

@property (nonatomic, strong) NSString *city;

/*!
 * Business' state.
 */

@property (nonatomic, strong) NSString *state;

/*!
 * Business' country.
 */

@property (nonatomic, strong) NSString *country;

/*!
 * Business' postal code.
 */

@property (nonatomic, strong) NSString *postalCode;

- (id) initWithLogoBase64:(NSString *)logoBased64
       andMerchantMessage:(NSString *)merchantMessage
                 andEmail:(NSString *)email
           andPhoneNumber:(NSString *)phoneNumber
            andWebsiteURL:(NSString *)websiteURL
           andFacebookURL:(NSString *)facebookURL
            andTwitterURL:(NSString *)twitterURL;

- (id) initWithLogoBase64:(NSString *)logoBased64
       andMerchantMessage:(NSString *)merchantMessage
                 andEmail:(NSString *)email
           andPhoneNumber:(NSString *)phoneNumber
            andWebsiteURL:(NSString *)websiteURL
           andFacebookURL:(NSString *)facebookURL
            andTwitterURL:(NSString *)twitterURL
          andBusinessName:(NSString *)businessName
              andAddress1:(NSString *)address1
              andAddress2:(NSString *)address2
                  andCity:(NSString *)city
                 andState:(NSString *)state
               andCountry:(NSString *)country
            andPostalCode:(NSString *)postalCode;

- (id) initWithLogoBase64:(NSString *)logoBased64
andMerchantMessage:(NSString *)merchantMessage
          andEmail:(NSString *)email
    andPhoneNumber:(NSString *)phoneNumber
     andWebsiteURL:(NSString *)websiteURL
    andFacebookURL:(NSString *)facebookURL
     andTwitterURL:(NSString *)twitterURL
   andInstagramURL:(NSString *)instagramURL
   andBusinessName:(NSString *)businessName
       andAddress1:(NSString *)address1
       andAddress2:(NSString *)address2
           andCity:(NSString *)city
          andState:(NSString *)state
        andCountry:(NSString *)country
     andPostalCode:(NSString *)postalCode;

@end
