//
//  MokeBaseRespondData.h
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/18.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//全局公共响应
@interface MokeBaseRespondData : NSObject

/*错误编码（0为正常）*/
@property(nonatomic,copy)NSString* yyw_errcode;

/*错误信息*/
@property(nonatomic,copy)NSString* yyw_errmsg;

@end

NS_ASSUME_NONNULL_END
