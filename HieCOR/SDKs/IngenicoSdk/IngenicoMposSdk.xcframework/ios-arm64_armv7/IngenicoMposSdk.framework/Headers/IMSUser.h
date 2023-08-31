/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSEmailReceiptInfo.h"
#import "IMSTransactionHistoryDetail.h"
#import "IMSUserProfile.h"
#import "IMSProcessorInfo.h"
#import "IMSTransactionsSummary.h"
#import "IMSHistoryQuery.h"

/*!
 *  Hanlder to be invoked after the login request is processed.
 *
 *  @param user   current logged in user
 *  @param error nil if succeed, otherwise the code indicates the reason
 *  @see IMSUserProfile
 */
typedef void (^LoginHanlder)(IMSUserProfile* _Nullable user, NSError * _Nullable error);

/*!
 *  Handler to be invoked after the logoff request is processed.
 *
 *  @param error nil if succeed, otherwise the code indicates the reason
 */

typedef void (^LogoffHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after the refresh user session request is processed.
 *
 *  @param error nil if succeed, otherwise the code indicates the reason
 */

typedef void (^RefreshUserSessionHandler)(IMSUserProfile * _Nullable user, NSError * _Nullable error);

/*!
 *  Handler to be invoked after the forgot password request is processed.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^ForgotPasswordHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after the change password request is processed.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^ChangePasswordHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after updating the user email.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^SetUserEmailHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after updating the user's information which will be included in the email receipt.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^SetEmailReceiptInfoHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving the user's information which will be included in the email receipt.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param emailReceiptInfo  EmailReceiptInfo of the merchant
 *  @see IMSEmailReceiptInfo
 */

typedef void (^GetEmailReceiptInfoHandler)(IMSEmailReceiptInfo * _Nullable emailReceiptInfo, NSError * _Nullable error);

/*!
 *  Handler to be invoked after updating security questions.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^SetSecurityQuestionsHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving a list of security questions.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param questions    list of security questions
 */


typedef void (^GetSecurityQuestionsHandler)(NSArray * _Nullable questions, NSError * _Nullable error);

/*!
 *  Handler to be invoked after the send email receipt request is processed.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */


typedef void (^SendEmailReceiptHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after updating the transaction.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */


typedef void (^UpdateTransactionHandler) (NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving details of a processed transaction.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param transaction    details of a transaction
 *  @see IMSTransactionHistoryDetail
 */

typedef void (^GetTransactionDetailsHandler) (IMSTransactionHistoryDetail * _Nullable transaction, NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving a list of transactions matching a search query.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param totalMatches    total number of matched transactions
 *  @param transactionList    list of transactions
 */

typedef void (^GetTransactionHistoryHandler) (NSArray * _Nullable transactionList, int totalMatches, NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving a list of invoices matching a search query.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param totalMatches    total number of matched invoices
 *  @param invoicesList    list of invoices
 */

typedef void (^GetInvoicesHandler) (NSArray * _Nullable invoicesList, int totalMatches, NSError * _Nullable error);

/*!
 *  Handler to be invoked after accept terms and conditions request has been processed.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */
typedef void (^AcceptTermsAndConditionsHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving the processor information.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param processorInfo  Processor information that was configured when the merchant was boarded.
 *  @see IMSProcessorInfo
 */

typedef void (^GetProcessorInfoHandler)(IMSProcessorInfo * _Nullable processorInfo, NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving the analytics transactions summary.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param transactionsSummary  Summarized information about the transactions that occured for the query date range.
 *  @see IMSTransactionSummary
 */

typedef void (^GetTransactionsSummaryHandler)(IMSTransactionsSummary * _Nullable transactionsSummary, NSError * _Nullable error);

/**
 * This class contains methods to perform user related actions.
 * All the methods accept a callback pertaining to that action
 * to capture the response.
 */

@interface IMSUser : NSObject

/*!
 *  Logs the user into Ingenico payment services
 *  with username and password.
 *
 *  @param userName  merchant's username
 *  @param password  password
 *  @param handler   the callback used to indicate that the
 *                   login request has been processed
 */

- (void)loginwithUsername:(NSString * _Nonnull)userName andPassword:(NSString * _Nonnull)password onResponse:(LoginHanlder _Nonnull)handler;

/*!
 *  Logoff the current user.
 *
 *  @param handler  the callback used to indicate that the
 *                  logoff request has been processed.
 */

- (void)logoff:(LogoffHandler _Nonnull)handler;

/*!
 *  Refresh the session of current user.
 *
 *  @param handler  the callback used to indicate that the
 *                  refresh user session request has been processed.
 */

- (void)refreshUserSession:(RefreshUserSessionHandler _Nonnull)handler;

/*!
 *  Sends the email with a link to reset the password.
 *
 *  @param userName  the username for which the password will be reset
 *  @param handler   the callback used to indicate that the
 *                   forgot password request has been processed
 */

- (void)forgotPassword:(NSString * _Nonnull)userName andOnDone:(ForgotPasswordHandler _Nonnull)handler;

/*!
 *  Allows the user to change the password.
 *
 *  @param oldPassword current password
 *  @param newPassword new password
 *  @param handler     the callback used to indicate that the
 *                     change password request has been processed
 */

- (void)changePasswordWithOldPassword:(NSString * _Nonnull)oldPassword andNewPassword:(NSString * _Nonnull)newPassword andOnDone:(ChangePasswordHandler _Nonnull)handler;

/*!
 *  Sets email for merchant user account.
 *
 *  @param emailAddress email address to update
 *  @param handler      the callback used to indicate that update to the
 *                      email has been processed
 */

- (void)setUserEmail:(NSString * _Nonnull)emailAddress andOnDone:(SetUserEmailHandler _Nonnull)handler;

/*!
 *  Sets the information that is displayed on the email receipt.
 *
 *  @param emailReceiptInfo EmailReceiptInfo object
 *  @param handler          the callback used to indicate that update to the
 *                          email receipt information has been processed
 *  @see  IMSEmailReceiptInfo
 */

- (void)setEmailReceiptInfo:(IMSEmailReceiptInfo * _Nonnull)emailReceiptInfo andOnDone:(SetEmailReceiptInfoHandler _Nonnull)handler;

/*!
 *  Gets the information that is displayed on the email receipt.
 *
 *  @param handler the callback used to indicate that the
 *                 get email receipt information request has been processed
 */

- (void)getEmailReceiptInfo:(GetEmailReceiptInfoHandler _Nonnull)handler;

/*!
 *  Sets the security questions for the merchant user account.
 *  Must have at least two questions
 *
 *  @param securityQuestions list of answers to the security questions
 *  @param handler           the callback used to indicate that update to the
 *                           security questions has been processed
 *  @see IMSSecurityQuestion
 */

- (void)setSecurityQuestions:(NSArray * _Nonnull)securityQuestions andOnDone:(SetSecurityQuestionsHandler _Nonnull)handler;

/*!
 *  Gets security questions for the merchant user account.
 *
 *  @param handler GetSecurityQuestionsHandler
 *  @see IMSSecurityQuestion
 */

- (void)getSecurityQuestions:(GetSecurityQuestionsHandler _Nonnull)handler;

/*!
 *  Sends email receipt for a transaction to the email address provided.
 *
 *  @param transactionID the ID of the transaction for which the receipt will be sent
 *  @param emailAddress     if nil-> receipt will be sent to merchant only,
                         otherwise-> receipt will be sent to both merchant and specified email address
 *  @param handler       the callback used to indicate that the
 *                       send email receipt request has been processed
 */

- (void)sendEmailReceipt:(NSString * _Nonnull)transactionID andEmailAddress:(NSString * _Nullable)emailAddress andOnDone:(SendEmailReceiptHandler _Nonnull)handler;

/*!
 *  Upload signature for the transaction with the given parameters.
 *  Use when cardVerificationMethod in IMSTransactionResponse is either CardVerificationMethodSignature or CardVerificationMethodPinAndSignature
 *
 *  @param transactionID          the ID of the transaction to update
 *  @param signatureImage         BASE64 encoded string representing the image
 *  @param handler                the callback used to indicate that update to the
 *                                transaction has been processed
 */

- (void)uploadSignatureForTransactionWithId:(NSString * _Nonnull)transactionID andSignature:(NSString * _Nonnull)signatureImage andOnDone:(UpdateTransactionHandler _Nonnull)handler;

/*!
 *  Updates the transaction with the given parameters. A transaction can be updated in steps with a varying combination of optional parameters as and when
 *  they are available, in such case the last update needs to have the flag isComplete set to true.
 *
 *  @param transactionID          the ID of the transaction to update
 *  @param cardholderInfo         (optional) cardholder info
 *  @param transactionNote        (optional) custom notes for the transaction
 *  @param isCompleted            indicates whether the transaction is completed
 *  @param displayNotesAndInvoice indicates whether to display transaction notes and merchant invoice ID in email receipt
 *  @param handler                the callback used to indicate that update to the
 *                                transaction has been processed
 *  @see  IMSCardholderInfo
 */

- (void)updateTransactionWithTransactionID:(NSString * _Nonnull)transactionID andCardholderInfo:(IMSCardholderInfo *_Nullable)cardholderInfo andTransactionNote:(NSString *_Nullable)transactionNote andIsCompleted:(bool)isCompleted andDisplayNotesAndInvoice:(bool)displayNotesAndInvoice andOnDone:(UpdateTransactionHandler _Nonnull)handler;
/*!
 *  Gets details of an  processed transaction.
 *
 *  @param transactionID the ID of the transaction to update
 *  @param handler       the callback used to indicate that the
 *                       get transaction details request has been processed
 */

- (void)getTransactionDetailsWithTransactionID: (NSString * _Nonnull)transactionID andOnDone:(GetTransactionDetailsHandler _Nonnull)handler;

/*!
 *  Returns a list of transactions that matches the given parameters.
 *  Use @see IMSHistoryQueryQueryBuilder to build the query.
 *
 *  @param query            IMSHistoryQuery object
 *  @param handler          the callback used to indicate that the
 *                          get transactions request has been processed
 */

- (void)getTransactionHistoryWithQuery:(IMSHistoryQuery * _Nonnull)query andOnDone:(GetTransactionHistoryHandler _Nonnull)handler;

/*!
 *  Returns a list of invoices that matches the given parameters.
 *  Use @see IMSHistoryQueryBuilder to build the query.
 *
 *  @param query            IMSHistoryQuery object
 *  @param handler          the callback used to indicate that the
 *                          get invoices request has been processed
 */

- (void)getInvoiceHistoryWithQuery:(IMSHistoryQuery * _Nonnull)query andOnDone:(GetInvoicesHandler _Nonnull)handler;

/*!
 * Reports to Ingenico Payment Services that the user has accepted the terms and conditions.
 *  @param handler          the callback used to indicate that the
 *                          request has been processed
 */
- (void)acceptTermsAndConditions:(AcceptTermsAndConditionsHandler _Nonnull)handler;

/*!
 *  Gets the processor information which was configured at the time of boarding the merchant.
 *
 *  @param handler the callback used to indicate that the
 *                 get processor information request has been processed
 */

- (void)getProcessorInfo:(GetProcessorInfoHandler _Nonnull)handler;

/*!
 *  Returns the transactions summary (total number of transactions and transactions net amount) given a date range (start date and end date)
 *  Note: Date range cannot exceed 10 days
 *  @param startDate        UTC timestamp in formart yyyymmddhhmmss
 *  @param endDate          UTC timestamp in formart yyyymmddhhmmss
 *  @param handler          the callback used to indicate that the request has been processed
 */

- (void)getTransactionsSummary:(NSString *_Nonnull)startDate andEndDate:(NSString *_Nonnull)endDate andOnDone:(GetTransactionsSummaryHandler _Nonnull)handler;

@end
