/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This immutable class contains flags for account setup.
 */

@interface IMSAccountFlags : NSObject

/*!
 *  Indicates whether email change is required.
 */

@property (readonly) bool changeEmailRequired;

/*!
 *  Indicates whether password change is required.
 */

@property (readonly) bool changePasswordRequired;

/*!
 *  Indicates whether security questions are required to be updated.
 */

@property (readonly) bool changeSecurityQuestionsRequired;

/*!
 * Indicates whether terms and conditions should be accepted
 */

@property (readonly) bool acceptTermsAndConditionsRequired;

- (id) initWithChangeEmailRequired:(bool)changeEmailRequired
         andChangePasswordRequired:(bool)changePasswordRequired
andChangeSecurityQuestionsRequired:(bool)changeSecurityQuestionsRequired
andAcceptTermsAndConditionsRequired:(bool)acceptTermsAndConditionsRequired;

@end
