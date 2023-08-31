/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "IMSEnum.h"
#import "IMSCurrency.h"
#import "IMSDeeplinkConfiguration.h"
#import "IMSQuickflowConfiguration.h"

/*!
 This immutable class contains information about user's profile that define the app behavior. These settings that can be broadly classified as changeable and non-changeable settings.

 ### Non-changeable settings

 The following settings are final and cannot be altered.

 1.  Collect Optional Information
 2.  Currency
 3.  Inventory Management
 4.  Manual Entry
 5.  Refund
 6.  Session Timeout
 7.  Tender Types
 8.  Void
 9.  Smart Refund
 10. Mobile Refund
 11. Pinpad Manual Entry
 12. Payment Service Group ID

 ### Changeable settings

 The following settings can be altered. If a setting is enabled the app is expected to provide that information. These settings can be further classified as hidable and non-hidable settings.

 #### Non-hidable settings

 The following settings are always available to the user to modify.

 1.  AVS Verification
 2.  Collect Geo Location
 3.  CVV Verification
 4.  Edit Email Receipt
 5.  Discount
 6.  Tip

 The boolean value returned from these methods determine the default position of the switch used for that particular setting. **Eg.** If getAvsVerification is true the switch is turned ON by default.

 #### Hidable settings

 These are special settings. They have very specific rules on how they are presented to the user.

 1.  Tax
 2.  Signature Capture
 3.  Small Ticket
 4.  Small Ticket Contactless
 5.  Capture Invoice Number
 6.  Capture Purchase Notes

 Their behavior is dictated by two properties.

 1.  Configuration Option (@see IMSConfigOptions)
 2.  Visibility

 **Note:** App will look at visibility only when configuration option is @see ConfigOptionsRequired
 **Note:** If visibility is unavailable for a setting, then it is upto the app to decide that setting's visibility

 The following table illustrates the app behavior for various combinations of above properties. 
 
 | Configuration Value | Visibility | Is setting row visible? | Default Switch Value | Can user change value?          |
 |---------------------|------------|-------------------------|----------------------|---------------------------------|
 | Optional            | NA         | Yes                     | ON                   | Yes                             |
 | Off                 | NA         | No                      | OFF                  | No (Because row is not visible) |
 | Required            | true       | Yes                     | ON                   | No (Because row is greyed out)  |
 | Required            | false      | No                      | ON                   | No (Because row is not visible) |
 */

@interface IMSConfiguration : NSObject

/*!
 * Is a non-hidable setting.
 * Determines if the app needs to collect zip code from user while making a transaction.
 * The Address Verification System (AVS) is a system used to verify the address of a person
 * claiming to own a credit card.
 * @return true - if enabled, false - otherwise
 */
@property (readonly) bool avsVerification;

/*!
 * Is a non-hidable setting.
 * Determines if the app can collect geo location.
 * @return true - if enabled, false - otherwise
 */
@property (readonly) bool collectGeoLocation;

/*!
 * Is a non-changeable setting.
 * Determines if the app can collect optional information i.e. transaction notes and merchant invoice id
 * @return  true - if the optional information entered as part of updateTransaction
 *                            parameters is saved
 *          false - otherwise
 */
@property (readonly) bool collectOptionalInformation;

/*!
 * Is a non-changeable setting.
 * Currency setting for the user.
 * @return currency object
 */
@property (readonly) IMSCurrency *currency;

/*!
 * Is a non-hidable setting.
 * Determines if the app needs to collect cvv data from user while making a transaction.
 * A card verification value (CVV) is a term for a security feature for keyed in card transactions
 * @return true - if enabled
 *         false - otherwise
 */
@property (readonly) bool cvvVerification;

/*!
 * Provides supporting data for @see tax.
 * Recommended tax value set for this user profile.
 * It can be replaced with a custom tax value which should be saved locally.
 * **Important:** Future updates to the configuration in the user profile may overwrite the local
 * value. App code should be capable of avoiding this.
 * @return normalized recommended tax value i.e. 123 for 1.23%
 * @deprecated Use defaultTaxRate instead
 */
@property (readonly) NSInteger defaultTax __attribute__((deprecated));

/*!
* Provides supporting data for @see tax.
* Recommended tax value set for this user profile.
* It can be replaced with a custom tax value which should be saved locally.
* **Important:** Future updates to the configuration in the user profile may overwrite the local
* value. App code should be capable of avoiding this.
* @return String representation of recommended tax value eg.1.23
*/
@property (readonly) NSString* defaultTaxRate;

/**
 * Is a non-hidable setting.
 * Determines if the app can apply discount.
 * @return true - if enabled
 *         false - otherwise
 */
@property (readonly) bool discount;

/*!
 * Is a non-hidable setting.
 * Determines if the app can have a screen to accept user input for data displayed on the email
 * receipt. See @see EmailReceiptInfo.
 * @return true - if enabled 
 *          false - otherwise
 */
@property (readonly) bool editEmailReceipt;

/*!
 * Is a non-hidable setting.
 * Determines if the app can have inventory management. Inventory management is local to the app.
 * There is no SDK support for this.
 * @return true - if enabled 
 *          false - otherwise
 */
@property (readonly) bool inventoryManagement;

/*!
 * Is a non-changeable settings.
 * Determines if the app can accept keyed in transactions.
 * @return true - if enabled 
 *          false - otherwise
 */
@property (readonly) bool manualEntry;

/*!
 * Is a non-changeable settings.
 * Determines if the app is capable of refunding transactions. 
 * Refund can be done over various modes, one of which is @see mobileRefund
 * @return true - if enabled 
 *          false - otherwise
 */
@property (readonly) bool refund;

/*!
 * Is a non-changeable settings.
 * Determines if the app is capable of doing a smartRefund on transactions. 
 * Smart refund is a special type of refund where, if the refund amount is same as the original 
 * sale amount, it attempts to void the transaction before doing a refund.
 * @return true - if enabled
 *          false - otherwise
 */
@property (readonly) bool smartRefund;
/*!
 * Is a non-changeable settings.
 * Determines if the app is capable of doing a mobileRefund on transactions.
 * Is one of the mode to perform a @see refund
 * @return true - if enabled
 *          false - otherwise
 */
@property (readonly) bool mobileRefund;
/*!
 * Is a non-changeable settings.
 * Determines if the app is capable of voiding transactions.
 * @return true - if enabled
 *          false - otherwise
 */
@property (readonly) bool voidEnabled;

/*!
 * Is a non-changeable settings.
 * Returns the configured session timeout in minuets.
 * @return Default value -1
 */
@property (readonly) NSInteger sessionTimeoutInMins;

/*!
 * Is a hidable setting.
 * Determines if the app can capture signature.
 * @return See @see IMSConfigOptions
 */
@property (readonly) IMSConfigOptions signatureCapture;

/*!
 * Provides supporting data for @see signatureCapture if it returns ConfigOptionsRequired.
 * Determines if this setting is visible to the user.
 * @return true - if visible 
 *          false - otherwise
 */
@property (readonly) bool signatureCaptureVisibility;

/*!
 * Is a hidable setting.
 * Determines if the app supports small ticket transactions.
 * Small ticket transactions do not require a signature if the transaction amount is less than or
 * equal to a preset threshold amount. @see smallTicketThreshold
 * @return See @see IMSConfigOptions
 */
@property (readonly) IMSConfigOptions smallTicket;

/*!
 * Is a hidable setting.
 * Determines if the app supports small ticket contactless transactions.
 * Small ticket transactions do not require a signature if the transaction amount is less than or
 * equal to a preset threshold amount. See @see smallTicketContactlessThreshold.
 * @return See @see IMSConfigOptions
 */
@property (readonly) IMSConfigOptions smallTicketContactless;

/*!
 * Provides supporting data for @see smallTicketContactless.
 * The threshold amount for small ticket contactless transactions.
 * **Important:** This value cannot be altered.
 * @return threshold amount in cents
 */
@property (readonly) NSInteger smallTicketContactlessThreshold;

/*!
 * Provides supporting data for @see smallTicket.
 * The threshold amount for small ticket transactions.
 * **Important:** This value cannot be altered.
 * @return threshold amount in cents
 */
@property (readonly) NSInteger smallTicketThreshold;

/*!
 * Provides supporting data for @see smallTicket if it returns ConfigOptionsRequired.
 * Determines if this setting is visible to the user.
 * @return true - if visible 
 *          false - otherwise
 */
@property (readonly) bool smallTicketVisibility;

/*!
 * Provides supporting data for @see smallTicketContactless if it returns ConfigOptionsRequired.
 * Determines if this setting is visible to the user.
 * @return true - if visible 
 *          false - otherwise
 */
@property (readonly) bool smallTicketContactlessVisibility;

/*!
 * Is a hidable setting.
 * Determines if the app can apply tax.
 * @return See @see IMSConfigOptions
 */
@property (readonly) IMSConfigOptions tax;

/*!
 * Provides supporting data for @see tax if it returns ConfigOptionsRequired.
 * Determines if this setting is visible to the user.
 * @return true - if visible 
 *          false - otherwise
 */
@property (readonly) bool taxVisibility;

/*!
 * List of supported tender types.
 * @return List of @see IMSTenderType
 */
@property (readonly) NSArray *tenderTypes;

/*!
 * Is a non-hidable setting.
 * Determines if the app can have a screen to accept tip data.
 * @return true - if enabled 
 *          false - otherwise
 */
@property (readonly) bool tip;

/*!
 * Is a non-changeable setting.
 * Returns the latest version of the app using this sdk.
 * @return String representation of the app version - if available
 *         empty string - otherwise
 */
@property (readonly) NSString* latestAppVersion;

/*!
 * Is a non-changeable setting.
 * Determines if the app can accept manual keyed entry transactions from devices with pinpad (i.e. RP750x, MOBY8500)
 * @return true - if enabled
 *          false - otherwise
 */
@property (readonly) bool pinpadManualEntry;

/*!
 * Is a hidable setting.
 * Determines if the app needs to capture invoice number.
 * @return See @see IMSConfigOptions
 */
@property (readonly) IMSConfigOptions captureInvoiceNumber;

/*!
 * Is a hidable setting.
 * Determines if the app needs to capture purchase notes.
 * @return See @see IMSConfigOptions
 */
@property (readonly) IMSConfigOptions capturePurchaseNotes;

/*!
 * Is a non-changeable setting.
 * Returns the Payment Service Group Id for the user
 *
 * @return String representation of the payment service group Id, empty if not configured
 */
@property (readonly) NSString* paymentServiceGroupId;

/*!
 * Is a non-changeable setting.
 * Returns if debit transactions are supported for the user.
 *
 * @return bool true   - if debit is supported
 *              false  - debit is not supported
 */
@property (readonly) bool supportsDebit;

/*!
 * Is a hidable setting.
 * Determines if the app needs to capture custom reference.
 * @return See @see IMSConfigOptions
 */
@property (readonly) IMSConfigOptions captureCustomReference;

/*!
 * Is a non-changeable setting.
 * Determines the behavior for the deep link feature.
 *
 * @return See @see IMSDeeplinkConfiguration
 */
@property (readonly) IMSDeeplinkConfiguration *deeplinkConfiguration;

/*!
 * Is a non-changeable setting.
 * Determines the behavior for the quick flow feature.
 *
 * @return See @see IMSQuickflowConfiguration
 */
@property (readonly) IMSQuickflowConfiguration *quickflowConfiguration;

- (id)initWithAvsVerification:(bool)avsVerification
        andCollectGeoLocation:(bool)collectGeoLocation
andCollectOptionalInformation:(bool)collectOptionalInformation
                  andCurrency:(IMSCurrency *)currency
           andCvvVerification:(bool)cvvVerification
                andDefaultTaxRate:(NSString *)defaultTaxRate
                  andDiscount:(bool)discount
          andEditEmailReceipt:(bool)editEmailReceipt
       andInventoryManagement:(bool)inventoryManagement
               andManualEntry:(bool)manualEntry
                    andRefund:(bool)refund
               andSmartRefund:(bool)smartRefund
              andMobileRefund:(bool)mobileRefund
      andSessionTimeoutInMins:(NSInteger)sessionTimeoutInMins
          andSignatureCapture:(IMSConfigOptions)signatureCapture
andSignatureCaptureVisibility:(bool)signatureCaptureVisibility
               andSmallTicket:(IMSConfigOptions)smallTicket
    andSmallTicketContactless:(IMSConfigOptions)smallTicketContactless
andSmallTicketContactlessThreshold:(NSInteger)smallTicketContactlessThreshold
      andSmallTicketThreshold:(NSInteger)smallTicketThreshold
     andSmallTicketVisibility:(bool)smallTicketVisibility
 andSmallTicketContactlessVisibility:(bool)smallTicketContactlessVisibility
                       andTax:(IMSConfigOptions)tax
             andTaxVisibility:(bool)taxVisibility
               andTenderTypes:(NSArray *)tenderTypes
                       andTip:(bool)tip
          andLatestAppVersion:(NSString *)latestAppVersion
               andVoidEnabled:(bool)voidEnabled
         andPinpadManualEntry:(bool)pinpadManualEntry
      andCaptureInvoiceNumber:(IMSConfigOptions)captureInvoiceNumber
      andCapturePurchaseNotes:(IMSConfigOptions)capturePurchaseNotes
     andPaymentServiceGroupId:(NSString *)paymentServiceGroupId
             andSupportsDebit:(bool)supportsDebit
    andCaptureCustomReference:(IMSConfigOptions)captureCustomReference
     andDeeplinkConfiguration:(IMSDeeplinkConfiguration *)deeplinkConfiguration
    andQuickflowConfiguration:(IMSQuickflowConfiguration *)quickflowConfiguration;

@end
