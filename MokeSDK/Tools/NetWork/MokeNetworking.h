//
//  MokeNetworking.h
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/14.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MokeNetworking : NSObject

+ (void)mk_POST:(NSString *)URLString
     parameters:(nullable id)parameters
       progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
        success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
