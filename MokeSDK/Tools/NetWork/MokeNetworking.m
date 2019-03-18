//
//  MokeNetworking.m
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/14.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import "MokeNetworking.h"
#import <AFNetworking.h>
#import "MokeBaseRequestParams.h"
#import <MJExtension.h>
#import "MokeMD5.h"
#import "AMAES.h"

#define signedGameKey @"2PoILqbar1RZNyBh6we*79DGx8Y+3EFf"

@interface MokeNetworking ()

@property(strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation MokeNetworking

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static MokeNetworking *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

/**
 POST
 
 @param URLString url string
 @param parameters parameters
 @param uploadProgress upload progress
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)kk_POST:(NSString *)URLString
     parameters:(nullable id)parameters
       progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
        success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {

    NSMutableDictionary *dict = [MokeNetworking processParameters:parameters] ;
    //       //AES解密
    ////        if ([LocalData.isEnUrl boolValue]) {
    ////            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ////            NSString * responseAES = [AMAES AMECBDecrypt:responseString encryptKey:@""];
    ////            responseAES =[responseAES stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    ////            data = [responseAES dataUsingEncoding:NSUTF8StringEncoding];
    ////        }
    [[MokeNetworking new].manager POST:URLString parameters:dict progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"==MokeNetWorking:respondObject%@==",responseObject);
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task,error);
        }
        
    }];
}

//#pragma mark - Getter & Setter
- (AFHTTPSessionManager *)manager {

    if (_manager) {
        return _manager;
    }

    // 设置base url
//    NSString *baseUrlString = BaseURLString;
//    NSURL *basrUrl = [NSURL URLWithString:baseUrlString];
    
    _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    _manager.requestSerializer.timeoutInterval = 30.f;
//    _manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
//    _manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回json格式
    return _manager;
}

/**
 请求参数进行处理
 
 @param parameters 参数
 */
+ (NSMutableDictionary*)processParameters:(nullable id)parameters{
    
    //模型->字典
    NSMutableDictionary *dict = [parameters mj_keyValues];
    NSArray *keys = [dict allKeys];
    //升序
    NSArray *dealtKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    /* 按key升序读取 */
    NSMutableString *paramStr = [NSMutableString string];
    for (NSString *key in dealtKeys) {
        [paramStr appendString:[NSString stringWithFormat:@"&%@=%@", key, dict[key]]];
    }
    //拼接signKey
    NSString *strBeforeSign = [NSString stringWithFormat:@"%@&%@",[paramStr substringFromIndex:1],signedGameKey];
    //md5
    NSString *md5Str = [MokeMD5 MokeHashString:strBeforeSign];
    [dict setObject:md5Str forKey:@"sign"];
    return dict;

}


@end


