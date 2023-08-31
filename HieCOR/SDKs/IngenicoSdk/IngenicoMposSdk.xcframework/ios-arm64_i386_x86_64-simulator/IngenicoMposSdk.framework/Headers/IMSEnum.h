/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This enum maps progress code to appropriate progress messages.
 */
typedef NS_ENUM(NSUInteger, IMSProgressMessage) {
    /*!
     * Code: 1999.
     * <br>
     * Deafult value
     */
    Unknown = 1999,

    /*!
     * Code: 1000.
     * <br>
     * Prompt to present card. Common message for multiple combinations.
     * Use allowedPOSEntryModes() to present accurate progress message.
     */
    PleaseInsertCard = 1000,

    /*!
     * Code: 1001.
     * <br>
     * Indicates that card was inserted
     */
    CardInserted = 1001,

    /*!
     * Code: 1002.
     * <br>
     * Other interfaces failed, fallback to swipe
     */
    ICCErrorSwipeCard = 1002,

    /*!
     * Code: 1003.
     * <br>
     * Indicates that application selection has started
     */
    ApplicationSelectionStarted = 1003,

    /*!
     * Code: 1004.
     * <br>
     * Indicates that application selection has started
     */
    ApplicationSelectionCompleted = 1004,

    /*!
     * Code: 1005.
     * <br>
     * Prompt for pin entry first attempt
     */
    FirstPinEntryPrompt = 1005,

    /*!
     * Code: 1006.
     * <br>
     * Prompt for pin entry last attempt
     */
    LastPinEntryPrompt = 1006,

    /*!
     * Code: 1007.
     * <br>
     * Indicates that pin entry has failed
     */
    PinEntryFailed = 1007,

    /*!
     * Code: 1008.
     * <br>
     * Indicates that pin entry is in progress
     */
    PinEntryInProgress = 1008,

    /*!
     * Code: 1009.
     * <br>
     * Indicates that pin entry was successful
     */
    PinEntrySuccessful = 1009,

    /*!
     * Code: 1010.
     * <br>
     * Prompt to re-enter pin
     */
    RetrytPinEntryPrompt = 1010,

    /*!
     * Code: 1011.
     * <br>
     * Prompt to remove inserted card after calling waitForCardRemoval()
     */
    PleaseRemoveCard = 1011,

    /*!
     * Code: 1012.
     * <br>
     * Prompt to present card again
     */
    PresentCardAgain = 1012,

    /*!
     * Code: 1013.
     * <br>
     * Indicates that card was removed while transaction was in progress
     */
    CardRemoved = 1013,
	
	/*!
	 * Code: 1014.
	 * <br>
	 * Reinsert the chip card properly
	 */
	ReinsertCard = 1014,
	
	/*!
	 * Code: 1015.
	 * <br>
	 * Restarting the transaction due to incorrect PIN entry
	 */
	RestartingTransactionDueToIncorrectPin = 1015,
    
    /*!
     * Code: 1016.
     * <br>
     * Indicates that a chip card was swiped instead of being inserted
     */
    ChipCardSwipFailed = 1016,
    
    /*!
     * Code: 1017.
     * <br>
     * Prompt to try contact transaction if contactless interface fails.
     */
    ContactlessInterfaceFailedTryContact = 1017,
    
    /*!
     * Code: 1018.
     * <br>
     * Indicates that the card was blocked.
     */
    CardWasBlocked = 1018,
    
    /*!
     * Code: 1019.
     * <br>
     * Indicates that the transaction was not authorized.
     */
    NotAuthorized = 1019,
    
    /*!
     * Code: 1020.
     * <br>
     * Prompt to remove card after transaction completion.
     */
    TransactionCompleteRemoveCard = 1020,
    
    /*!
     * Code: 1021.
     * <br>
     * Prompt to remove card.
     */
    RemoveCard = 1021,
    
    /*!
     * Code: 1022.
     * <br>
     * Indicates that a card with unsupported AID was tapped as a result falling back to insert or swipe
     */
    InsertOrSwipeCard = 1022,
    
    /*!
     * Code: 1023.
     * <br>
     * Indicates transaction cannot be started due to low battery.
     */
    TransactionVoid = 1023,
    
    /*!
     * Code: 1024.
     * <br>
     * Prompt to remove card if card read is OK.
     */
    CardReadOkRemoveCard = 1024,
    
    /*!
     * Code: 1025.
     * <br>
     * Indicates that transaction is processing.
     */
    ProcessingTransaction = 1025,
    
    /*!
     * Code: 1026.
     * <br>
     * Indicates that cardholder bypassed PIN.
     */
    CardHolderBypassedPIN = 1026,
    
    /*!
     * Code: 1025.
     * <br>
     * Indicates that payment is not accepted.
     */
    NotAccepted = 1027,
    
    
    /*!
     * Code: 1028.
     * <br>
     * Indicates that transaction is in process and card is not to be removed.
     */
    ProcessingDoNotRemoveCard = 1028,
    
    /*!
     * Code: 1029.
     * <br>
     * Indicates that transaction is being authorized.
     */
    Authorizing = 1029,
    
    /*!
     * Code: 1030.
     * <br>
     * Prompt to remove card if transaction is not accepted.
     */
    NotAcceptedRemoveCard = 1030,
    
    /*!
     * Code: 1031.
     * <br>
     * Indicates card error.
     */
    CardError = 1031,
    
    /*!
     * Code: 1032.
     * <br>
     * Prompt to remove card if card error occurs.
     */
    CardErrorRemoveCard = 1032,
    
    /*!
     * Code: 1033.
     * <br>
     * Indicates transaction was cancelled.
     */
    Cancelled = 1033,
    
    /*!
     * Code: 1034.
     * <br>
     * Prompt to remove card if transaction is cancelled.
     */
    CancelledRemoveCard = 1034,
    
    /*!
     * Code: 1035.
     * <br>
     * Prompt to remove card if transaction is voided.
     */
    TransactionVoidRemoveCard = 1035,
    
    /*!
     * Code: 1036.
     * <br>
     * Indicates unknown AID.
     */
    UnknownAID = 1036,

    /*!
     * Code: 1100.
     * <br>
     * Indicates that reader is waiting for card swipe
     */
    WaitingforCardSwipe = 1100,

    /*!
     * Code: 1101.
     * <br>
     * Indicates that swipe was detected
     */
    SwipeDetected = 1101,

    /*!
     * Code: 1102.
     * <br>
     * Prompt to re-swipe card due to a swipe read error
     */
    SwipeErrorReswipeMagStripe = 1102,

    /*!
     * Code: 1200.
     * <br>
     * Indicates that tap was detected
     */
    TapDetected = 1200,

    /*!
     * Code: 1201.
     * <br>
     * The result of a contactless transaction has indicated that the transaction must revert to a contact interface.
     * Only applicable when the contactless interface is enabled.
     */
    UseContactInterfaceInsteadOfContactless = 1201,

    /*!
     * Code: 1202.
     * <br>
     * Indicates that reader could not detect any response from contactless card after initial discovery.
     */
    ErrorReadingContactlessCard = 1202,

    /*!
     * Code: 1203.
     * <br>
     * Indicates that reader is restarting contactless interface
     */
    RestartingContactlessInterface = 1203,

    /*!
     * Code: 1204.
     * <br>
     * Prompt to try contact interface
     */
    TryContactInterface = 1204,

    /*!
     * Code: 1205.
     * <br>
     * Indicates that the cardholder should check his phone to authorize contactless transaction done using digital wallet (CDCVM)
     */
    PleaseSeePhone = 1205,

    /*!
     * Code: 1206.
     * <br>
     * Indicates that more than one contactless cards were detected by the reader.
     * Only applicable when the contactless interface is enabled.
     */
    MultipleContactlessCardsDetected = 1206,

    /*!
     * Code: 1300.
     * <br>
     * Indicates that device is busy processing a previous request.
     */
    DeviceBusy = 1300,

    /*!
     * Code: 1301.
     * <br>
     * Indicates that cardholder pressed the cancel key. Only applicable for pin pad devices.
     */
    CardHolderPressedCancelKey = 1301,

    /*!
     * Code: 1400.
     * <br>
     * Indicates that the cash transaction is being recorded by Ingenico payment services
     */
    RecordingTransaction = 1400,

    /*!
     * Code: 1401.
     * <br>
     * Indicates that the transaction data is being updated to Ingenico payment services
     */
    UpdatingTransaction = 1401,

    /*!
     * Code: 1402.
     * <br>
     * Indicates that mPOS SDK is requesting Ingenico payment services to authorize the transaction
     */
    GettingOnlineAuthorization = 1402,

    /*!
     * Code: 1403.
     * <br>
     * Indicates that mPOS SDK is attempting to reverse the transaction
     */
    SendingReversal = 1403,

    /*!
     * Code: 1404.
     * <br>
     * Indicates that mPOS SDK is completing the transaction by doing card verification with the reader
     */
    GettingCardVerification = 1404,

    /*!
     * Code: 1405.
     * <br>
     * Indicates that mPOS SDK is fetching the secure card entry page from Ingenico payment services
     */
    FetchingSecureCardEntryContent = 1405,

    /*!
     * Code:1406.
     * <br>
     * Indicates that mPOS SDK is loading the secure card entry page from Ingenico payment services
     */
    LoadingSecureCardEntryContent = 1406,
    
    /*!
     * Code:1407.
     * <br>
     * Indicates that mPOS SDK is retrieving device log
     */
    RetrievingDeviceLog = 1407,
    /*!
     * Code:1408.
     * <br>
     * Indicates that reader is waiting for chip card
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforChipCard = 1408,
    /*!
     * Code:1409.
     * <br>
     * Indicates that reader is waiting for card swipe
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforSwipeCard = 1409,
    /*!
     * Code:1410.
     * <br>
     * Indicates that reader is waiting for chip card or card swipe
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforChipAndSwipe = 1410,
    /*!
     * Code:1411.
     * <br>
     * Indicates that reader is waiting for card tap
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforTapCard = 1411,
    /*!
     * Code:1412.
     * <br>
     * Indicates that reader is waiting for chip card or tap
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforChipAndTap = 1412,
    /*!
     * Code:1413.
     * <br>
     * Indicates that reader is waiting for card swipe or tap
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforSwipeAndTap = 1413,
    /*!
     * Code:1414.
     * <br>
     * Indicates that reader is waiting for chip card, card swipe or tap
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforChipSwipeTap = 1414,
    /*!
     * Code:1415.
     * <br>
     * Indicates that reader is waiting for fallback swipe
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforFallbackSwipe = 1415,
    /*!
     * Code:1416.
     * <br>
     * Indicates that reader is waiting for fallback chip card
     * Note: This is available for firmware version 9.22 and greater.
     */
    WaitingforFallbackChip = 1416,
    /*!
     * Code:1500.
     * <br>
     * Indicates that mPOS SDK is updating firmware
     */
    UpdatingFirmware = 1500,
    /*!
     * Code:1501.
     * <br>
     * Indicates that mPOS SDK is setting up device
     */
    SettingUpDevice = 1501,
    /*!
     * Code:1502.
     * <br>
     * Indicates that mPOS SDK is downloading firmware
     */
    DownloadingFirmware = 1502,
    /*!
     * Code:1503.
     * <br>
     * Indicates that mPOS SDK is checking if firmware update is required
     */
    CheckingFirmwareUpdate = 1503,
    /*!
     * Code:1504.
     * <br>
     * Indicates that mPOS SDK is checking if device set up is required
     */
    CheckingDeviceSetup = 1504
};

/*!
 * Enum of supported point of sale entry modes.
 */
typedef NS_ENUM(NSUInteger, IMSPOSEntryMode) {
    /*!
     * Default value.
     */
    POSEntryModeUnKnown = 0,
    /*!
     * Card not present.
     * Card data is captured through manually entering card information (PAN, Exp Date, CVV, AVS).
     */
    POSEntryModeKeyed = 1,
    /*!
     * Card data is captured through ICC card insertion.
     */
    POSEntryModeContactEMV = 2,
    /*!
     * EMV Card data is captured through NFC (Contactless cards, ApplePay, AndroidPay, etc.,).
     */
    POSEntryModeContactlessEMV = 3,
    /*!
     * Magnetic Card data is captured through NFC (Contactless cards, ApplePay, AndroidPay, etc.,).
     */
    POSEntryModeContactlessMSR = 4,
    /*!
     * Card data is captured through magnetic card swipe.
     */
    POSEntryModeMagStripe = 5,
    /*!
     * Card data is captured through magnetic card swipe as a fall back mechanism when EMV transaction fails.
     */
    POSEntryModeMagStripeEMVFail = 6,
    /*!
     * Card data is captured through Virtual terminal on Merchant portal (myRoam aka ROAMmerchant)
     */
    POSEntryModeVirtualTerminal = 7,
    /*!
     * Token generated by capturing card data is used to perform the transaction
     */
    POSEntryModeToken = 8,
    /*!
     * Card present. Fallback to keyed entry.
     * Card data is captured through manually entering card information (PAN, Exp Date, CVV, AVS).
     */
    POSEntryModeKeyedSwipeFail = 9

};

/*!
 * Enum of possible responses for transaction processing.
 */
typedef NS_ENUM(NSUInteger, IMSCardVerificationMethod){
    /*!
     Default value.
     */
    CardVerificationMethodNone = 0,

    /*!
     Requires PIN entry for verification.
     */
    CardVerificationMethodPin = 1,

    /*!
     Requires cardholder signature for verification.
     */
    CardVerificationMethodSignature = 2,

    /*!
     Requires both PIN and signature for verification.
     */
    CardVerificationMethodPinAndSignature = 3

};

/*!
 * Enum of possible responses for transaction processing.
 */
typedef NS_ENUM(NSUInteger, IMSTransactionResponseCode){
    /*!
     * Default Value.
     */
    TransactionResponseCodeUnKnown = 0,
    /*!
     * Transaction approved.
     */
    TransactionResponseCodeApproved = 1,
    /*!
     * Transaction declined.
     */
    TransactionResponseCodeDeclined = 2,
    /*!
     * Transaction is referral.
     */
    TransactionResponseCodeReferral = 3,
    /*!
     * Verify error.
     */
    TransactionResponseCodeVerifyError = 4,
    /*!
     * Pass phrase expired.
     */
    TransactionResponseCodePassPhraseExpired = 5,
    /*!
     * Invalid pass phrase.
     */
    TransactionResponseCodeInvalidPassPhrase = 6,
    /*!
     * Binary data response.
     */
    TransactionResponseCodeBinaryDataResponse = 7
};

/*!
 * Enum of supported transaction types.
 */
typedef NS_ENUM(NSUInteger, IMSTransactionType){
    /*!
     * Default value.
     */
    TransactionTypeUnknown = 0,
    /*!
     * Card sale transaction.
     */
    TransactionTypeCreditSale = 1,
    /*!
     * Cash sale transaction.
     */
    TransactionTypeCashSale = 2,
    /*!
     * Credit Refund transaction.
     */
    TransactionTypeCreditRefund = 3,
    /*!
     * Cash Refund transaction.
     */
    TransactionTypeCashRefund = 4,
    /*!
     * Credit Void transaction.
     */
    TransactionTypeCreditSaleVoid = 5,
    /*!
     * Credit Auth transaction.
     */
    TransactionTypeCreditAuth = 6,
    /*!
     * Credit Auth Void transaction.
     */
    TransactionTypeCreditAuthVoid = 7,
    /*!
     * Credit Auth Complete transaction.
     */
    TransactionTypeCreditAuthCompletion = 8,
    /*!
     * Credit Auth Complete Void transaction.
     */
    TransactionTypeCreditAuthCompletionVoid = 9,
    /*!
     * Debit sale transaction.
     */
    TransactionTypeDebitSale = 10,
    /*!
     * Debit void transaction.
     */
    TransactionTypeDebitSaleVoid = 11,
    /*!
     * Debit refund transaction.
     */
    TransactionTypeDebitRefund = 12,
    /*!
     * Credit Refund Void transaction.
     */
    TransactionTypeCreditRefundVoid = 13,
    /*!
     * Debit Refund Void transaction.
     */
    TransactionTypeDebitRefundVoid = 14,
    /*!
     * Credit Force Sale transaction.
     * Similar to CreditSale except that payment authorized through other mediums..
     */
    TransactionTypeCreditForceSale = 15,
    /*!
     * Credit Force Sale Void transaction.
     */
    TransactionTypeCreditForceSaleVoid = 16,
    /*!
     * Credit Balance Inquiry transaction.
     */
    TransactionTypeCreditBalanceInquiry = 17,
    /*!
     * Requests for token enrollment.
     */
    TransactionTypeTokenEnrollment = 18,
    /*!
     * Credit Sale Adjust transaction.
     */
    TransactionTypeCreditSaleAdjust = 19,
    /*!
     * Credit Sale Adjust Void transaction.
     */
    TransactionTypeCreditSaleAdjustVoid = 20,
    /*!
     * Credit Auth Adjust transaction.
     */
    TransactionTypeCreditAuthAdjust = 21,
    /*!
     * Credit Auth Adjust Void transaction.
     */
    TransactionTypeCreditAuthAdjustVoid = 22,
    /*!
     * Debit Balance Inquiry.
     */
    TransactionTypeDebitBalanceInquiry = 23,
    /*!
     * AVS only transaction.
     */
    TransactionTypeAVSOnly = 24,
    /*!
     * Sale
     */
    TransactionTypeSale = 25,
    /*!
     * Refund
     */
    TransactionTypeRefund = 26,
    /*!
     * Balance Inquiry
     */
    TransactionTypeBalanceInquiry= 27,
    /*!
     * Credit auth partial void transaction.
     */
    TransactionTypeCreditAuthPartialVoid= 28,
    /*!
     * Credit auth adjust partial void transaction.
     */
    TransactionTypeCreditAuthAdjustPartialVoid= 29,
    /*!
     * VAS Only
     */
    TransactionTypeVasOnly= 30
};

/*!
 * Enum of supported image formats.
 */
typedef NS_ENUM(NSUInteger, IMSImageFormat){
    /*!
     * Default value.
     */
    ImageFormatUnknown = 0,
    /*!
     * PNG format.
     */
    ImageFormatPNG = 1,
    /*!
     * JPEG format.
     */
    ImageFormatJPEG = 2,
};

/*!
 * Enum of possible options for configuration settings.
 */
typedef NS_ENUM(NSUInteger, IMSConfigOptions) {
    /*!
     * Default value.
     */
    ConfigOptionsUnknown = 0,
    /*!
     * The configuration setting is OFF as per merchant's profile and the user cannot turn it back ON.
     */
    ConfigOptionsOff = 1,
    /*!
     * The configuration setting is ON as per merchant's profile and the user can turn it OFF.
     * In other words it is optional for the user to honor this value.
     */
    ConfigOptionsOptional = 2,
    /*!
     * The configuration setting is ON as per merchant's profile and the user cannot turn it OFF.
     * In other words the user is required to honor this value.
     */
    ConfigOptionsRequired = 3,
};

/*!
 * Enum of possible tender types.
 */
typedef NS_ENUM(NSUInteger, IMSTenderType) {
    /*!
     * Default value.
     */
    TenderTypeUnknown = 0,
    /*!
     * Cash.
     */
    TenderTypeCash = 1,
    /*!
     * Credit.
     */
    TenderTypeCredit = 2,
    /*!
     * Debit.
     */
    TenderTypeDebit = 3,
};

/*!
 * Enum of supported card types.
 */
typedef NS_ENUM(NSUInteger, IMSCardType){
    /*!
     * Default value.
     */
    CardTypeUnknown = 0,
    /*!
     * American Express.
     */
    CardTypeAMEX = 1,
    /*!
     * Discover.
     */
    CardTypeDiscover = 2,
    /*!
     * MasterCard.
     */
    CardTypeMasterCard = 3,
    /*!
     * VISA.
     */
    CardTypeVISA = 4,
    /*!
     * JCB.
     */
    CardTypeJCB = 5,
    /*!
     * Diners.
     */
    CardTypeDiners = 6,
    /*!
     * Maestro.
     */
    CardTypeMaestro = 7,
};

/*!
 * Enum of transaction status.
 */
typedef NS_ENUM(NSUInteger, IMSTransactionStatus){
    /*!
     * Default value.
     */
    TransactionStatusUnknown = 0,
    /*!
     * Auth transaction is open.
     */
    TransactionStatusActive = 1,
    /*!
     * Auth transaction is completed or
     * CreditSale/DebitSale/CashSale is not refunded or voided.
     */
    TransactionStatusCompleted = 2,
    /*!
     * Transaction has been refunded.
     */
    TransactionStatusRefunded = 3,
    /*!
     * Transaction has been voided.
     */
    TransactionStatusVoided = 4,
    /*!
     * Auth transaction has expired.
     */
    TransactionStatusExpired = 5,
    /*!
     * Void transaction has been accepted.
     */
    TransactionStatusAccepted = 6,
    /*!
     * Transaction has been declined.
     */
    TransactionStatusDeclined = 7,
    /*!
     * Transaction has been adjusted.
     */
    TransactionStatusAdjusted = 8
};

/*!
 * Enum of reversal reason.
 */
typedef NS_ENUM(NSUInteger, IMSReversalReason) {
    /*!
     * Default value.
     */
    ReversalReasonUnknown = 0,
    /*!
     * The original transaction was voided by calling processVoidTransaction.
     */
    ReversalReasonVoid = 1,
    /*!
     * The transaction was aborted by customer before completion.
     */
    ReversalReasonCustomerCancelled = 2,
    /*!
     * The original transaction was reversed because of network timeout.
     */
    ReversalReasonTimeout = 3,
    /*!
     * The original transaction was reversed because processing failed.
     */
    ReversalReasonFailure = 4,
    /*!
     * The original transaction was reversed because card was removed prematurely.
     */
    ReversalReasonCardRemoved = 5,
    /*!
     * The original transaction was reversed because card reader declined the request.
     */
    ReversalReasonChipDecline = 6,
    /*!
     * The original transaction was reversed because of card reader error.
     */
    ReversalReasonPinPadError = 7,
};

/*!
 * Enum of optional fields to be requested for the data to be part of transaction history.
 */
typedef NS_ENUM(NSUInteger, IMSOptionalTransactionHistoryField) {
    /*!
     * Returns token information of a transaction, if present
     */
    OptionalFieldTokenData = 0
};

/*!
 * Enum of possible options for Firmware update actions
 */
typedef NS_ENUM(NSUInteger, IMSFirmwareUpdateAction){
    /*!
     * Unable to determine if there is a firmware update available or not
     */
    FirmwareUpdateActionUnknown = 0,
    /*!
     * Firmware update of the card reader is required to continue processing transactions
     */
    FirmwareUpdateActionRequired = 1,
    /*!
     * Firmware update of the card reader is optional
     */
    FirmwareUpdateActionOptional = 2,
    /*!
     * No firmware update is available at this time.
     */
    FirmwareUpdateActionNo = 3
};

/*!
 * Enum of possible options for Card Presentment
 */
typedef NS_ENUM(NSUInteger, IMSCardPresentment){
    /*!
     * Unable to determine card presentment type
     */
    CardPresentmentUnknown = 0,
    /*!
     * Original
     */
    CardPresentmentOriginal = 1,
    /*!
     * Store and Forward Transaction
     */
    CardPresentmentStoreAndForward = 2,
    /*!
     * Recurring
     */
    CardPresentmentRecurring = 3,
    /*!
     * Installment
     */
    CardPresentmentInstallment = 4,
    /*!
     * Billpay
     */
    CardPresentmentBillpay = 5
};

/*!
 * Enum of AVS Responses returned as part of the transaction response
 * @see IMSTransactionResponse
 */
typedef NS_ENUM(NSUInteger, IMSAVSResponse){
    /*!
     * Unable to determine AVS response
     */
    AVSResponseUnknown = 0,
    /*!
     * Address and 9 digit zip match (MC)
     */
    AVSResponseX = 1,
    /*!
     * Address and 5 digit zip match (Visa, MC, Amex, Disc)
     */
    AVSResponseY = 2,
    /*!
     * Address match, zip did not (Visa, MC, Amex, Disc)
     */
    AVSResponseA = 3,
    /*!
     * 9 digit Zip match, address did not (MC, Disc)
     */
    AVSResponseW = 4,
    /*!
     * 5 digit Zip match, address did not (Visa, MC, Amex, Disc)
     */
    AVSResponseZ = 5,
    /*!
     * No match (Visa, MC, Amex, Disc)
     */
    AVSResponseN = 6,
    /*!
     * System unavailable (Visa, MC, Amex, Disc)
     */
    AVSResponseU = 7,
    /*!
     * Issuer timeout, retry (Visa, MC, Amex)
     */
    AVSResponseR = 8,
    /*!
     * Data invalid (Visa)
     */
    AVSResponseE = 9,
    /*!
     * Bank does not support AVS (Visa, MC, Amex)
     */
    AVSResponseS = 10,
    /*!
     * Address and Zip match, international
     */
    AVSResponseD = 11,
    /*!
     * Address and Zip match, international
     */
    AVSResponseM = 12,
    /*!
     * Address match, zip not verified, international
     */
    AVSResponseB = 13,
    /*!
     * Zip match, address not verified, international
     */
    AVSResponseP = 14,
    /*!
     * No match, international
     */
    AVSResponseC = 15,
    /*!
     * Not verified, international
     */
    AVSResponseI = 16,
    /*!
     * Not supported, international
     */
    AVSResponseG = 17
};

/*!
 * Enum of possible options for POSEntrySource
 */
typedef NS_ENUM(NSUInteger, IMSPOSEntrySource){
    /*!
     * Default
     */
    POSEntrySourceUnknown = 0,
    /*!
     * Transaction performed by capturing card data on a mobile device
     * For eg: [IMSPayment processKeyedTransaction:andOnDone:]
     */
    POSEntrySourceMobile = 1,
    /*!
     * Transaction performed using secure card entry
     */
    POSEntrySourceSecure = 2,
    /*!
     * Transaction performed by capturing card data using any payment device
     * For eg: [IMSPayment processCreditSaleTransactionWithCardReader:andUpdateProgress:andSelectApplication:andOnDone:]
     */
    POSEntrySourceDevice = 3,
    /*!
     * Transaction performed by capturing card data directly via unencrypted means, Eg: directly entered on a ecommerce page
     */
    POSEntrySourceDirect = 4,
};

/*!
 * Enum of possible formats for generating Unique Card Identifier
 */
typedef NS_ENUM(NSUInteger, IMSUCIFormat){
    /*!
     * Default
     */
    UCIFormatUnknown = 0,
    /*!
     * UCI generated by Ingenico
     */
    UCIFormatIngenico = 1
};

/*!
 * Enum of possible options for configuring application selection on the reader
 */
typedef NS_ENUM(NSUInteger, IMSApplicationSelectionOption){
    /*!
     * Application selection through the external device.
     */
    ApplicationSelectionOptionExternalDevice = 0,
    /*!
     * Application selection through the reader pin pad.
     */
    ApplicationSelectionOptionPinPad = 1
};

/*!
 *  Enum of Application ID transaction type for automatic type selection
 */
typedef NS_ENUM(NSUInteger, IMSApplicationType){
    /*!
     * ApplicationTypeUnknown
     */
    ApplicationTypeUnknown = 0,
    /*!
     * ApplicationTypeCredit
     */
    ApplicationTypeCredit = 1,
    /*!
     * ApplicationTypeDebit
     */
    ApplicationTypeDebit = 2
};

/*!
 *  Enum of deep link reply strategy
 */
typedef NS_ENUM(NSUInteger, IMSDeeplinkReplyStrategy){
    
    IMSDeeplinkReplyStrategyUnknown = 0,
    IMSDeeplinkReplyStrategyPostCallbackUrl = 1,
    IMSDeeplinkReplyStrategyQueryStringCallbackUrl = 2,
    IMSDeeplinkReplyStrategyNativeApp = 3
};

/*!
 *  Enum of deep link PII data
 */
typedef NS_ENUM(NSUInteger, IMSDeeplinkPiiData){
    
    IMSDeeplinkPiiDataUnknown = 0,
    IMSDeeplinkPiiDataCardholderName = 1,
    IMSDeeplinkPiiDataRedactedCardNumber = 2
};

/*!
 * Enum of CVV Responses returned as part of the transaction response
 * @see IMSTransactionResponse
 */
typedef NS_ENUM(NSUInteger, IMSCVVResponse){
    /*!
     * CVV not performed - default
     */
    CVVResponseUnknown = 0,
    /*!
     * CVV2 Match
     */
    CVVResponseM = 1,
    /*!
     *  CVV2 Did NOT match
     */
    CVVResponseN = 2,
    /*!
     * Not processed
     */
    CVVResponseP = 3,
    /*!
     * Issuer indicates CVV2 data should be present, but request did not supply it
     */
    CVVResponseS = 4,
    /*!
     * Issues has not certified for CVV2
     */
    CVVResponseU = 5
};

/*!
 * Enum of configuration mode that mPOS EMV SDK can implicitly set up the device or perform firmware update to ensure EMV capability
 */
typedef NS_ENUM(NSUInteger, IMSConfigMode){
    /*!
     * mPOS EMV SDK is completely responsible for ensuring the reader is EMV capable by performing device setup and firmware update
     */
    IMSConfigModeAuto = 0,
    /*!
     * mPOS EMV SDK is partially responsible for ensuring the reader is EMV capable by performing device setup and only mandatory firmware update, but delegates optional firmware update control to the consuming app
     */
    IMSConfigModeOptimal = 1,
    /*!
     * Default mode. mPOS EMV SDK is not responsible for ensuring the reader is EMV capable and delegates complete control to the consuming app
     */
    IMSConfigModeManual = 2
};

@interface IMSEnum : NSObject

@end
