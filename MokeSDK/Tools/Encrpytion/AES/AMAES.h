//
//  AMAES.h
//  AnimSDK
//
//  Created by  Yvan Hall on 2019/1/2.
//  Copyright © 2019  Yvan Hall. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//NS_ASSUME_NONNULL_BEGIN

@interface AMAES : NSObject

/* 加密方法 */
+ (NSString *)AMCBCEncrypt:(NSString *)str;
/* 解密方法 */
+ (NSString *)AMCBCDecrypt:(NSString *)str;

/* 加密方法 */
+ (NSString *)AMECBEncrypt:(NSString *)plainText encryptKey:(NSString *)encryptkey;
/* 解密方法 */
+ (NSString *)AMECBDecrypt:(NSString *)plainText encryptKey:(NSString *)encryptkey;
@end

//NS_ASSUME_NONNULL_END
