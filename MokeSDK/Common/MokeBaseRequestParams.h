//
//  MokeParameters.h
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/14.
//  Copyright © 2019 李一贤. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "MokeMacros.h"
NS_ASSUME_NONNULL_BEGIN

@interface MokeBaseRequestParams : NSObject
/* **************** 全局公共请求参数 **************** */

/*联运商id*/
@property(nonatomic, copy) NSString *pid;

/*游戏id*/
@property(nonatomic, copy) NSString *gid;

/*位置标识*/
@property(nonatomic, copy) NSString *refer;

/*游戏版本号*/
@property(nonatomic, copy) NSString *version;

/*sdk版本号*/
@property(nonatomic, copy) NSString *sversion;

/*UNIX时间戳*/
@property(nonatomic, copy) NSString *time;

/*设备号:idfa与idfv拼接再md5*/
@property(nonatomic, copy) NSString *dev;

/*签名sign*/
@property(nonatomic, copy) NSString *sign;

/*广告标示符*/
@property(nonatomic, copy) NSString *idfa;

/*Vindor标示符*/
@property(nonatomic, copy) NSString *idfv;

/* 本机语言 */
@property(nonatomic, copy) NSString *locale;

/* 是否映射（对应具体的一套映射） */
@property(nonatomic, copy) NSString *sdkTag;

/*是否对请求传参进行AES-encode的判断标志位*/
@property(nonatomic, copy) NSString *isEnUrl;

/* 映射的url*/
@property(nonatomic, copy) NSString *baseUrl;

/*拼接计算sign值的gamekey*/
@property(nonatomic, copy) NSString *gameKey;
@end

NS_ASSUME_NONNULL_END
