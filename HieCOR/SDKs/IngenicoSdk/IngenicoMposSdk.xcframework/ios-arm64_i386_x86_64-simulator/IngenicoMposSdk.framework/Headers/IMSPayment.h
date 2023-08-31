/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSDebitSaleTransactionRequest.h"
#import "IMSCreditSaleTransactionRequest.h"
#import "IMSCashSaleTransactionRequest.h"
#import "IMSKeyedCardSaleTransactionRequest.h"
#import "IMSVoidTransactionRequest.h"
#import "IMSCashRefundTransactionRequest.h"
#import "IMSCreditRefundTransactionRequest.h"
#import "IMSCreditAuthTransactionRequest.h"
#import "IMSCreditCardRefundTransactionRequest.h"
#import "IMSCreditAuthCompleteTransactionRequest.h"
#import "IMSKeyedCreditAuthTransactionRequest.h"
#import "IMSDebitCardRefundTransactionRequest.h"
#import "IMSKeyedCardSaleTransactionWithCardReaderRequest.h"
#import "IMSKeyedCreditForceSaleTransactionRequest.h"
#import "IMSCreditForceSaleTransactionRequest.h"
#import "IMSCreditBalanceInquiryTransactionRequest.h"
#import "IMSDebitBalanceInquiryTransactionRequest.h"
#import "IMSTokenEnrollmentTransactionRequest.h"
#import "IMSKeyedTokenEnrollmentTransactionRequest.h"
#import "IMSCreditResaleTransactionRequest.h"
#import "IMSCreditReauthTransactionRequest.h"
#import "IMSCreditAuthAdjustTransactionRequest.h"
#import "IMSPartialVoidTransactionRequest.h"
#import "IMSTransactionResponse.h"
#import "IMSAVSOnlyTransactionRequest.h"
#import "IMSTokenSaleTransactionRequest.h"
#import "IMSTokenAuthTransactionRequest.h"
#import "IMSBalanceInquiryTransactionRequest.h"
#import "IMSSaleTransactionRequest.h"
#import "IMSRefundTransactionRequest.h"
#import "IMSCreditSaleAdjustTransactionRequest.h"
#import "IMSKeyedCreditAuthTransactionWithCardReaderRequest.h"
#import "IMSKeyedCreditRefundTransactionWithCardReaderRequest.h"
#import "IMSKeyedTokenEnrollmentWithCardReaderTransactionRequest.h"
#import <RUA_MFI/RUA.h>

/*!
 *  Response to send when cardholder selects an AID from a list of AIDs.
 *
 *  @param selectedAppID ApplicationID selected to continue the transaction
 *  @see RUAApplicationIdentifier
 */

typedef void (^ApplicationSelectedResponse)(RUAApplicationIdentifier * _Nullable selectedAppID);

/*!
 *  Handler to be invoked after the cardholder selects an AID
 *  from a list of available AIDs on the card.
 *
 *  @param applicationList a list of ApplicationIDs the inserted card supports
 *  @param error  nil if succeed, otherwise the code indicates the reason
 *  @param reponse  selected applicationId
 */

typedef void (^ApplicationSelectionHandler)(NSArray * _Nullable applicationList, NSError * _Nullable error, ApplicationSelectedResponse _Nullable reponse);

/*!
 *  Response to send when cardholder selects an AID from a list of AIDs.
 *
 *
 */

typedef void (^IMSTransactionTypeSelectionResponse)(IMSApplicationType applicationType);

/*!
 *  Handler to be invoked after the cardholder selects an AID
 *  from a list of available AIDs on the card.
 *
 *
 */

typedef void (^IMSTransactionTypeSelectionHandler)(NSError * _Nullable error, IMSTransactionTypeSelectionResponse _Nullable reponse);

/*!
 *  Invoked when there has been a progress in the transaction.
 *
 *  @param progressMessage progress message
 *  @see RoamProgressMessage
 *  @param extraMessage    extra message if exists
 */

typedef void (^UpdateProgress)(IMSProgressMessage progressMessage, NSString * _Nullable extraMessage);

/*!
 *  Invoked when the transaction process is complete.
 *
 *  @param response Response for the transaction
 *  @see IMSTransactionResponse
 *  @param error  nil if succeed, otherwise the code indicates the reason
 */

typedef void (^TransactionOnDone)(IMSTransactionResponse * _Nullable response, NSError * _Nullable error);

/*!
 *  Handler invoked after uploading all pending transactions in the local database.
 *
 *  @param error  nil if succeed, otherwise the code indicates the reason
 */

typedef void (^UploadPendingTransactionHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving a list of pending transactions.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param transactionList    list of transactions
 */
typedef void (^GetPendingTransactionsHandler) (NSArray * _Nullable transactionList, NSError * _Nullable error);

/*!
 * This class contains methods to perform transaction related actions.
 * All the methods accept a callback pertaining to that action to capture the response.
 */

@interface IMSPayment : NSObject

/*!
 * Processes the credit payment by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest CreditSaleTransactionRequest object.
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            credit card sale transaction request has been processed
 *  @see IMSCreditSaleTransactionRequest
 */

- (void)processCreditSaleTransactionWithCardReader:(IMSCreditSaleTransactionRequest * _Nonnull)transactionRequest
                                 andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                              andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                         andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the debit payment by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest DebitSaleTransactionRequest object.
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            debit card sale transaction request has been processed.
 *  @see IMSDebitSaleTransactionRequest
 */

- (void)processDebitSaleTransactionWithCardReader:(IMSDebitSaleTransactionRequest * _Nonnull)transactionRequest
                                andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                             andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                        andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit payment by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 * Selects Debit/Credit based on the selected AID.
 * If the type cannot be determined, user is prompted for transaction type selection.
 *
 *  @param transactionRequest CreditSaleTransactionRequest object.
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param transactionTypeSelectionHandler transaction type selection handler
 *  @param handler            the callback used to indicate that the
 *                            sale transaction request has been processed
 *  @see IMSCreditSaleTransactionRequest
 */

- (void)processSaleTransactionWithCardReader:(IMSSaleTransactionRequest * _Nonnull)transactionRequest
                                 andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                              andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                 andTransactionTypeSelection:(IMSTransactionTypeSelectionHandler _Nonnull)transactionTypeSelectionHandler
                                         andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit auth payment by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest CreditAuthTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            credit auth transaction request has been processed
 *  @see IMSCreditAuthTransactionRequest
 */

- (void)processCreditAuthTransactionWithCardReader:(IMSCreditAuthTransactionRequest * _Nonnull)transactionRequest
                           andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                        andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                   andOnDone:(TransactionOnDone _Nonnull
                                              
                                              )handler;

/*!
 *  Processes the credit auth payment using the keyed-in card information (PAN, Exp Date, CVV, AVS).
 *
 *  @param transactionRequest KeyedCreditAuthTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            keyed credit auth transaction request has been processed
 *  @see IMSKeyedCreditAuthTransactionRequest
 */

- (void)processKeyedCreditAuthTransaction:(IMSKeyedCreditAuthTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Completes the original credit auth transaction by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest CreditAuthCompleteTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            auth complete transaction request has been processed
 *  @see IMSCreditAuthCompleteTransactionRequest
 */

- (void)processCreditAuthCompleteTransaction:(IMSCreditAuthCompleteTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Processes the card payment using the keyed-in card information (PAN, Exp Date, CVV, AVS).
 *
 *  @param transactionRequest KeyedCardSaleTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            keyed transaction request has been processed
 *  @see IMSKeyedCardSaleTransactionRequest
 */

- (void)processKeyedTransaction:(IMSKeyedCardSaleTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit payment by getting manually keyed card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest KeyedCardSaleTransactionWithCardReaderRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the
 *                            credit auth transaction request has been processed
 *  @see IMSKeyedCardSaleTransactionWithCardReaderRequest
 */

- (void)processKeyedTransactionWithCardReader:(IMSKeyedCardSaleTransactionWithCardReaderRequest * _Nonnull)transactionRequest
                            andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                    andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Records a cash sale transaction.
 *
 *  @param transactionRequest CashSaleTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            cash sale transaction request has been processed
 *  @see IMSCashSaleTransactionRequest
 */

- (void)processCashTransaction:(IMSCashSaleTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Refunds the original cash sale transaction.
 *
 *  @param transactionRequest CashRefundTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            cash refund transaction request has been processed
 *  @see IMSCashRefundTransactionRequest
 */

- (void)processCashRefundTransaction:(IMSCashRefundTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit refund payment by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest CreditCardRefundTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            credit refund transaction request has been processed
 *  @see IMSCreditCardRefundTransactionRequest
 */
- (void)processCreditRefundWithCardReader:(IMSCreditCardRefundTransactionRequest * _Nonnull)transactionRequest
                        andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                     andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the debit refund payment by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest DebitCardRefundTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            credit refund transaction request has been processed
 *  @see IMSDebitCardRefundTransactionRequest
 */
- (void)processDebitRefundWithCardReader:(IMSDebitCardRefundTransactionRequest * _Nonnull)transactionRequest
                        andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                     andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the refund by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 * Selects Debit/Credit based on the selected AID.
 * If the type cannot be determined, user is prompted for transaction type selection.
 *
 *  @param transactionRequest CreditSaleTransactionRequest object.
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param transactionTypeSelectionHandler transaction type selection handler
 *  @param handler            the callback used to indicate that the
 *                            refund transaction request has been processed
 *  @see IMSCreditSaleTransactionRequest
 */

- (void)processRefundTransactionWithCardReader:(IMSRefundTransactionRequest * _Nonnull)transactionRequest
                           andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                        andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                 andTransactionTypeSelection:(IMSTransactionTypeSelectionHandler _Nonnull)transactionTypeSelectionHandler
                                   andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit balance inquiry by getting card information from the card reader
 * and then sends the card information to Ingenico payment services to get the available balance.
 *
 *  @param transactionRequest CreditBalanceInquiryTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            credit balance inquiry transaction request has been processed
 *  @see IMSCreditBalanceInquiryTransactionRequest
 */
- (void)processCreditBalanceInquiryWithCardReader:(IMSCreditBalanceInquiryTransactionRequest * _Nonnull)transactionRequest
                                andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                             andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                        andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the debit balance inquiry by getting card information from the card reader
 * and then sends the card information to Ingenico payment services to get the available balance.
 *
 *  @param transactionRequest DebitBalanceInquiryTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            debit balance inquiry transaction request has been processed
 *  @see IMSDebitBalanceInquiryTransactionRequest
 */
- (void)processDebitBalanceInquiryWithCardReader:(IMSDebitBalanceInquiryTransactionRequest * _Nonnull)transactionRequest
                                andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                             andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                        andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the balance inquiry by getting card information from the card reader
 * and then sends the card information to Ingenico payment services to get the available balance.
 * Selects Debit/Credit based on the selected AID.
 * If the type cannot be determined, user is prompted for transaction type selection.
 *
 *  @param transactionRequest DebitBalanceInquiryTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param transactionTypeSelectionHandler transaction type selection handler
 *  @param handler            the callback used to indicate that the
 *                            balance inquiry transaction request has been processed
 *  @see IMSDebitBalanceInquiryTransactionRequest
 */
- (void)processBalanceInquiryWithCardReader:(IMSBalanceInquiryTransactionRequest * _Nonnull)transactionRequest
                               andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                            andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                     andTransactionTypeSelection:(IMSTransactionTypeSelectionHandler _Nonnull)transactionTypeSelectionHandler
                                       andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Refunds the original credit sale transaction.
 *
 *  @param transactionRequest CreditRefundTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            credit refund transaction request has been processed
 *  @see IMSCreditRefundTransactionRequest
 */

- (void)processCreditRefundAgainstTransaction:(IMSCreditRefundTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Voids the original transaction.
 *
 *  @param transactionRequest IMSVoidTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            void transaction request has been processed
 *  @see IMSVoidTransactionRequest
 */

- (void)processVoidTransaction:(IMSVoidTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Reduces the open auth amount of the original transaction.
 *  Is allowed on only Auth and AuthAdjust transactions.
 *  Results in InvalidOriginalTransactionType response code otherwise
 * Important: Subsequent auth complete should refer to partial void transaction instead of the original auth
 *
 *  @param transactionRequest IMSPartialVoidTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            void transaction request has been processed
 *  @see IMSPartialVoidTransactionRequest
 */

- (void)processPartialVoidTransaction:(IMSPartialVoidTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit force sale payment by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest IMSCreditForceSaleTransactionRequest object.
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            credit force sale transaction request has been processed
 *  @see IMSCreditForceSaleTransactionRequest
 */

- (void)processCreditForceSaleTransactionWithCardReader:(IMSCreditForceSaleTransactionRequest * _Nonnull)transactionRequest
                                      andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                   andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                              andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Processes the credit force sale payment using the keyed-in card information (PAN, Exp Date, CVV, AVS).
 *
 *  @param transactionRequest IMSKeyedCreditForceSaleTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            keyed credit force sale transaction request has been processed
 *  @see IMSKeyedCreditForceSaleTransactionRequest
 */

- (void)processKeyedCreditForceSaleTransaction:(IMSKeyedCreditForceSaleTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Enrolls for a token by sending the card information captured from the card reader to Ingenico payment services.
 *
 *  @param transactionRequest IMSTokenEnrollmentTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the
 *                            token enrollment request has been processed
 *  @see IMSTokenEnrollmentTransactionRequest
 */
- (void)processTokenEnrollmentWithCardReader:(IMSTokenEnrollmentTransactionRequest * _Nonnull)transactionRequest
                            andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                         andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                    andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Enrolls for a token by sending manually entered card information to Ingenico payment services.
 *
 *  @param transactionRequest IMSKeyedTokenEnrollmentTransactionRequest object
 *  @param handler            the callback used to indicate that the
*                            token enrollment request has been processed
 *  @see IMSKeyedTokenEnrollmentTransactionRequest
 */
- (void)processKeyedTokenEnrollment:(IMSKeyedTokenEnrollmentTransactionRequest * _Nonnull)transactionRequest
                           andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Checks if pending transactions exist in the database.
 *
 *  @return True/False indicates if pending transactions exsit
 */

- (bool)hasPendingTransactions;

/*!
 *  Reverse pending transactions in the database with a default retry count of 10.
 *
 *  @param handler the callback used to indicate that the
 *                 reverse all pending transactions request has been processed
 */

- (void)reverseAllPendingTransactions:(UploadPendingTransactionHandler _Nonnull)handler;

/*!
 * Reverse pending transactions with user defined retry counter(10 if not defined)
 *
 *  @param retryCounter counter for retrying send reversal request for each pending transaction. Minimum value is 1.
 *  @param handler      the callback used to indicate that the
 *                 reverse all pending transactions request has been processed
 */

- (void)reverseAllPendingTransactionsWithRetryCounter:(int)retryCounter andOnDone:(UploadPendingTransactionHandler _Nonnull)handler;


/*!
 *  Reverses single pending transaction using the client transaction Id input. This API will attempt to reverse only once.
 *
 *  @param clientTransactionID The client transaction id of pending transaction to be reversed
 *  @param handler the callback used to indicate that the
 *                 reverse all pending transactions request has been processed
 */

- (void)reversePendingTransaction:(NSString *_Nonnull)clientTransactionID
                        andOnDone:(UploadPendingTransactionHandler _Nonnull)handler;

/*!
 * Aborts the ongoing transaction.
 * If card data is not yet captured - the transaction is cancelled immediately and the reader is no longer in waiting state
 * If card data is captured - the transaction is reversed once its processing is completed
 * If pin entry is requested (for devices with pin pad) - the transaction can be cancelled only after the device's cancel button is pressed
 */
- (void)abortTransaction;

/*!
 * Ignores the pending transactions so that the transaction processing is not blocked.
 * This call will delete the pending transactions stored locally. <br>
 * *Important* Recommended to reverse pending transactions (see [IMSPayment reverseAllPendingTransactions:],
 * [IMSPayment reverseAllPendingTransactionsWithRetryCounter:andOnDone:]) before this.
 * @param transactionID the ID of the pending reversal transaction
 */
- (void)ignorePendingTransaction:(NSString *_Nonnull)transactionID;

/*!
 * Gets the list of pending transactions.
 * @param handler  the callback used to indicate that the
 *                 pending transactions have been returned
 */
- (void)getPendingTransactions:(GetPendingTransactionsHandler _Nonnull )handler;

/*!
 * Ignores the default behaviour of reversing pending transactions before starting a new transaction.
 */
- (void)ignorePendingReversalsBeforeNextTransaction;

/**
 * Processes a sale using the provided token
 *
 * @param transactionRequest IMSTokenSaleTransactionRequest object.
 * @param handler            The callback used to indicate that the
 *                           token sale transaction request has been processed.
 */
- (void)processTokenSaleTransaction:(IMSTokenSaleTransactionRequest * _Nonnull)transactionRequest
                  andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                          andOnDone:(TransactionOnDone _Nonnull)handler;

/**
 * Processes a auth using the provided token
 *
 * @param transactionRequest IMSTokenAuthTransactionRequest object.
 * @param handler            The callback used to indicate that the
 *                           token sale transaction request has been processed.
 */
- (void)processTokenAuthTransaction:(IMSTokenAuthTransactionRequest * _Nonnull)transactionRequest
                  andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                          andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Adjusts a processed credit sale transaction.
 *
 * @param transactionRequest CreditSaleAdjustTransactionRequest object
 * @param handler            The callback used to indicate that the
 *                           credit sale adjust transaction request has been processed
 */
- (void)processCreditSaleAdjustTransaction:(IMSCreditSaleAdjustTransactionRequest * _Nonnull)transactionRequest
                         andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                 andOnDone:(TransactionOnDone _Nonnull)handler;
/*!
 *  Processes a credit resale on the original credit sale transaction.
 *
 *  @param transactionRequest CreditResaleTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the
 *                            credit resale transaction request has been processed
 *  @see IMSCreditResaleTransactionRequest
 */

- (void)processCreditResaleTransaction:(IMSCreditResaleTransactionRequest * _Nonnull)transactionRequest
                     andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                             andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Processes a credit reauth on the original credit auth transaction.
 *
 *  @param transactionRequest CreditReauthTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the
 *                            credit reauth transaction request has been processed
 *  @see IMSCreditReauthTransactionRequest
 */

- (void)processCreditReauthTransaction:(IMSCreditReauthTransactionRequest * _Nonnull)transactionRequest
                     andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                             andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Adjusts a processed credit auth transaction.
 *
 *  @param transactionRequest CreditSaleAdjustTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the
 *                            credit auth adjust transaction request has been processed
 *  @see IMSCreditAuthAdjustTransactionRequest
 */

- (void)processCreditAuthAdjustTransaction:(IMSCreditAuthAdjustTransactionRequest * _Nonnull)transactionRequest
                         andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                 andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the AVS only transaction by getting card information from the card reader
 * and then sends the card information to Ingenico payment services for address verification.
 *
 *  @param transactionRequest           IMSAVSOnlyTransactionRequest object
 *  @param progressHandler              progress handler
 *  @param applicationSelectionHandler  application selection handler
 *  @param handler                      the callback used to indicate that the
 *                                      AVS only transaction request has been processed
 *  @see IMSCreditBalanceInquiryTransactionRequest
 */
- (void)processAVSOnlyTransactionWithCardReader:(IMSAVSOnlyTransactionRequest * _Nonnull)transactionRequest
                                andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                             andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                        andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit auth by getting manually keyed card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest IMSKeyedCreditAuthTransactionWithCardReaderRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the credit auth transaction request has been processed
 *  @see IMSKeyedCreditAuthTransactionWithCardReaderRequest
 */

- (void)processKeyedCreditAuthTransactionWithCardReader:(IMSKeyedCreditAuthTransactionWithCardReaderRequest * _Nonnull)transactionRequest
                                      andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                              andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit refund by getting manually keyed card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest IMSKeyedCreditRefundTransactionWithCardReaderRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the credit refund transaction request has been processed
 *  @see IMSKeyedCreditRefundTransactionWithCardReaderRequest
 */

- (void)processKeyedCreditRefundTransactionWithCardReader:(IMSKeyedCreditRefundTransactionWithCardReaderRequest * _Nonnull)transactionRequest
                                        andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                                andOnDone:(TransactionOnDone _Nonnull)handler;


/*!
 * Processes the token enrollment by getting manually keyed card information from the card reader
 * and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest IMSKeyedTokenEnrollmentWithCardReaderTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the credit refund transaction request has been processed
 *  @see IMSKeyedTokenEnrollmentWithCardReaderTransactionRequest
 */

- (void)processKeyedTokenEnrollmentTransactionWithCardReader:(IMSKeyedTokenEnrollmentWithCardReaderTransactionRequest * _Nonnull)transactionRequest
                                           andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                                   andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes VAS only transaction by reading Apple VAS pass from the card reader.
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the VAS transaction request has been processed
 */

- (void)processVasOnlyTransactionWithCardReader:(UpdateProgress _Nonnull)progressHandler
                                      andOnDone:(TransactionOnDone _Nonnull)handler;


/*!
 *  Voids the original transaction by getting card information from the card reader
 *  and then sends the card information to Ingenico payment services for payment authorization.
 *
 *  @param transactionRequest IMSVoidTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler            the callback used to indicate that the credit card sale transaction request has been processed
 *  @see IMSVoidTransactionRequest
 */

- (void)processVoidTransactionWithCardReader:(IMSVoidTransactionRequest * _Nonnull)transactionRequest
                           andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                        andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                   andOnDone:(TransactionOnDone _Nonnull)handler;

@end
