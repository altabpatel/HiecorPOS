/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "Ingenico.h"

@interface IMSUtil : NSObject

/*Resize the image to be 100*100, make sure this method is called in the main thread*/

+ (NSString *)encodedImageToBase64String:(UIImage *)image withImageFormat:(IMSImageFormat)imageFormat;

/*Decode the base 64 encoded NSString and return an UIImage*/

+ (UIImage *)decodedBase64StringToImage:(NSString *)encodedStr;

@end
