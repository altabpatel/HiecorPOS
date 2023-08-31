/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#ifndef RUA_MFI
#define RUA_MFI
#endif

#import "IMSProduct.h"
#import "IMSTransactionHistorySummary.h"
#import "IMSInvoiceHistorySummary.h"
#import "IMSSecurityQuestion.h"
#import "IMSFirmwareInfo.h"
#import "IMSResponseCode.h"
#import "IMSPendingTransaction.h"
#import "IMSTokenRequestParametersBuilder.h"
#import "IMSTokenRequestParameters.h"
#import "IMSTokenResponseParameters.h"
#import "IMSEmvOfflineData.h"
#import "IMSEmvData.h"
#import "IMSFirmwarePackageInfo.h"
#import "IMSSecureCardEntryViewController.h"
#import "IMSUtil.h"
#import "IMSPreference.h"
#import "IMSCardDetails.h"
#import <RUA_MFI/RUA.h>
#import <RUA_MFI/RUADeviceStatusHandler.h>
#import <RUA_MFI/RUADeviceSearchListener.h>
#import <RUA_MFI/RUALedPairingView.h>
#import <Foundation/Foundation.h>
#import "IMSPayment.h"
#import "IMSUser.h"
#import "IMSPaymentDevice.h"
#import "IMSStoreAndForward.h"
#import "DeviceStatusAndEMVConfigurationHandler.h"

static NSString * _Nonnull mPOS_Version = @"3.1.0.5";
/*!
 * This is a singleton class that acts as the entry point to access the Ingenico mPOS SDK.
 */

/*!
 * Callback to be invoked after pinging the Ingenico Payment Services
 *  @param error  nil if succeed, otherwise the code indicates the reason
 */

typedef void (^PingHanlder)(NSError * _Nullable error);

/*!
 * Callback to be invoked after calling reset API
 *  @param error  nil if succeed, otherwise the code indicates the reason
 */
typedef void (^ResetHandler)(NSError * _Nullable error);


@interface Ingenico : NSObject

/*!
 *  Returns a handler to process transactions.
 *  @see IMSPayment
 */

@property (readonly) IMSPayment * _Nonnull Payment;

/*!
 *  Returns a handler to perform user related actions.
 *  @see IMSUser
 */

@property (readonly) IMSUser * _Nonnull User;

/*!
 *  Returns a handler to manage devices.
 *  @see IMSPaymentDevice
 */

@property (readonly) IMSPaymentDevice * _Nonnull PaymentDevice;

/*!
 *  Returns a handler to perform store and forward transactions.
 *  @see IMSStoreAndForward
 */

@property (readonly) IMSStoreAndForward * _Nonnull StoreAndForward;

@property (readonly) IMSPreference * _Nullable preference;

/*!
 *  Returns an instance of this class.
 */
+ (Ingenico * _Nullable)sharedInstance;


/*!
 *  Initializes the APIs and sets URL, API Key and client version (for tracking purposes).
 *
 *  @param baseURL hostname of the Ingenico Payment Server
 *         Note: Use https URL in production.
 *  @param apiKey  API key of the client application for the Ingenico Payment Server
 *                 API Keys with the below prefixes are supported :
 *                   1. RPX
 *                   2. SDK
 *                   3. CAT
 *  @param clientVersion  version of the client application
 */
- (void)initializeWithBaseURL:(NSString * _Nonnull)baseURL apiKey:(NSString * _Nonnull)apiKey clientVersion:(NSString * _Nonnull)clientVersion;


/*!
 *  Initializes the APIs and sets URL, API Key and client version (for tracking purposes).
 *
 *  @param baseURL hostname of the Ingenico Payment Server
 *         Note: Use https URL in production.
 *  @param apiKey  API key of the client application for the Ingenico Payment Server
 *                 API Keys with the below prefixes are supported :
 *                   1. RPX
 *                   2. SDK
 *                   3. CAT
 *  @param clientVersion  version of the client application
 *  @param timeout timeout period that would be used for network requests. Accepted values 10-60 seconds
 */
- (void)initializeWithBaseURL:(NSString * _Nonnull)baseURL apiKey:(NSString * _Nonnull)apiKey clientVersion:(NSString * _Nonnull)clientVersion timeout:(NSInteger)timeout;

/*!
 *  Initializes the APIs and sets URL, API Key, client version (for tracking purposes) and user preference object.
 *
 *  @param baseURL hostname of the Ingenico Payment Server
 *         Note: Use https URL in production.
 *  @param apiKey  API key of the client application for the Ingenico Payment Server
 *                 API Keys with the below prefixes are supported :
 *                   1. RPX
 *                   2. SDK
 *                   3. CAT
 *  @param clientVersion  version of the client application
 *  @param timeout timeout period that would be used for network requests. Accepted values 10-60 seconds
 *  @param preference SDK preference
 *  @see IMSPreference
 */
- (void)initializeWithBaseURL:(NSString * _Nonnull)baseURL apiKey:(NSString * _Nonnull)apiKey clientVersion:(NSString * _Nonnull)clientVersion timeout:(NSInteger)timeout preference:(IMSPreference * _Nonnull)preference;


/*!
 * Releases all the resources held by the APIs. Also releases the device.
 * <br>
 * @deprecated Use - (void) reset:(ResetHandler _Nonnull) handler; instead.
 * <b>Note:</b> Call this method after {@link User#logOff(LogoffCallback)}.
 */
- (void)reset __deprecated;


/*!
 * Enable/Disable logging for Ingenico mPOS SDK. Logging is disabled by default.
 * For security reasons all of card holder, card and other sensitive information are masked in logs.
 * <br>
 * <b>Important:</b> Avoid logging in production
 *
 *  @param logging true - to enable, false - to disable
 */
- (void)setLogging:(BOOL)logging;

/*!
 * Enable/Disable diagnostics for Ingenico mPOS SDK. Diagnostics are enabled by default.
 *
 *  @param enable true - to enable, false - to disable
 */
- (void)sendDiagnostics:(BOOL)enable;

/*!
 *
 * Set a custom logger to override the default OS logging system
 * @param customLogger an object that conforms to the RUADebugLogListener protocol
 * @see RUADebugLogListener
 * <br>
 * <b>Important:</b> Avoid logging in production
 *
 */
- (void)setCustomLogger:(id<RUADebugLogListener> _Nonnull)customLogger;

/*!
 * Asynchronous method that checks if the Ingenico Payment Services are reachable
 *  @param handler            the callback used to indicate that the
 *                            ping action has been executed
 */
- (void)ping:(PingHanlder _Nonnull)handler;

/*!
 *  Returns the version of Ingenico mPOS SDK
 */
- (NSString *_Nonnull)getVersion;

/*!
 *  Update the SDK preference.
 *
 *  @param preference SDK preference
 *  @see IMSPreference
 */
- (void)updatePreference:(IMSPreference * _Nonnull)preference;

/*!
 *  Returns the current SDK capabilities.
 *
 *  @return IMSCapabilities
 *  @see IMSCapabilities
 */
- (IMSCapabilities *_Nonnull)getCurrentCapabilities;

/*!
 * Releases all the resources held by the APIs. Also releases the device.
 * @param handler            the callback used to indicate that the action has been executed
 * <br>
 * <b>Note:</b> Call this method after {@link User#logOff(LogoffCallback)}.
 */
- (void) reset:(ResetHandler _Nonnull) handler;

@end
