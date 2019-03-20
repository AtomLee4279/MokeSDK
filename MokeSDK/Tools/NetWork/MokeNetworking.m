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

#define gamekey @"2PoILqbar1RZNyBh6we*79DGx8Y+3EFf"

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

    NSMutableDictionary *dict = [MokeNetworking processParameters:parameters];
    //       //AES解密
    ////        if ([mkBaseReqParams.isEnUrl boolValue]) {
    ////            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ////            NSString * responseAES = [AMAES AMECBDecrypt:responseString encryptKey:@""];
    ////            responseAES =[responseAES stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    ////            data = [responseAES dataUsingEncoding:NSUTF8StringEncoding];
    ////        }
    [[MokeNetworking new].manager POST:URLString parameters:dict progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"==MokeNetWorking:respondObject%@==",responseObject);
        if (success) {
//            NSString *nameStr =  [[NSString alloc]initWithData: responseObject encoding:NSUTF8StringEncoding];
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
//    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];//返回data
    return _manager;
}

/**
 请求参数进行处理
 
 @param parameters 参数
 */
+ (NSMutableDictionary*)processParameters:(nullable id)parameters{
    
    MokeBaseRequestParams *mkBaseReqParams = parameters;
    /* 重新整理映射了key之后的请求参数字典 */
    NSDictionary * dict = @{
                            
      PID         : mkBaseReqParams.pid,
      GID         : mkBaseReqParams.gid,
      REFER       : mkBaseReqParams.refer,
      VERSION     : mkBaseReqParams.version,
      SVERSION    : mkBaseReqParams.sversion,
      TIME        : mkBaseReqParams.time,
      DEV         : mkBaseReqParams.dev,
      IDFA        : mkBaseReqParams.idfa,
      IDFV        : mkBaseReqParams.idfv,
      LOCALE      : mkBaseReqParams.locale,
      SDKTAG      : mkBaseReqParams.sdkTag,
      
      };
    NSMutableDictionary *publicParams = [NSMutableDictionary dictionary];
    [publicParams addEntriesFromDictionary:dict];
    
//    //模型->字典
//    NSMutableDictionary *dict = [parameters mj_keyValues];
    NSArray *keys = [publicParams allKeys];
    //升序
    NSArray *dealtKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    /* 按key升序读取 */
    NSMutableString *paramStr = [NSMutableString string];
    for (NSString *key in dealtKeys) {
        [paramStr appendString:[NSString stringWithFormat:@"&%@=%@", key, publicParams[key]]];
    }
    //拼接signKey
    NSString *strBeforeSign = [NSString stringWithFormat:@"%@&%@",[paramStr substringFromIndex:1],mkBaseReqParams.gameKey];
    //md5
    NSString *md5Str = [MokeMD5 MokeHashString:strBeforeSign];
    [publicParams setObject:md5Str forKey:SIGN];
    return publicParams;

}

/**
 POST
 
 @param URLString url string
 @param parameters parameters
 @param uploadProgress upload progress
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)mk_POST:(NSString *)URLString
     parameters:(nullable id)parameters
       progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
        success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //整理传参
    NSString * tmpStr= [MokeNetworking MKDealtParams:parameters];
    //AES-Encode
    tmpStr = [AMAES AMECBEncrypt:tmpStr encryptKey:@""];
//    NSString *tmp =
    //string->data
    NSData * data=[tmpStr dataUsingEncoding:NSUTF8StringEncoding];
    //设置请求头
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:data];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //这里根据后台的配置来配置
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval=15;//设置超时时间
  
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSString *responseString =  [[NSString alloc]initWithData: responseObject encoding:NSUTF8StringEncoding];
        //ECB-Decrpt
        NSString * responseAES = [AMAES AMECBDecrypt:responseString encryptKey:@""];
        responseAES =[responseAES stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        NSData *tmpData = [responseAES dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *respondDic = [NSJSONSerialization JSONObjectWithData:tmpData options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"==mk:nameStr==%@",respondDic);
        if (success&&(![respondDic[ERRCODE] boolValue])) {
            success(NULL,respondDic);
        }
        
    }] resume];
}

+ (NSString *)MKDealtParams:(nullable id)parameters {
    
    MokeBaseRequestParams *mkBaseReqParams = parameters;
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:
                           @{
                             
                             PID         : mkBaseReqParams.pid,
                             GID         : mkBaseReqParams.gid,
                             REFER       : mkBaseReqParams.refer,
                             VERSION     : mkBaseReqParams.version,
                             SVERSION    : mkBaseReqParams.sversion,
                             TIME        : mkBaseReqParams.time,
                             DEV         : mkBaseReqParams.dev,
                             IDFA        : mkBaseReqParams.idfa,
                             IDFV        : mkBaseReqParams.idfv,
                             LOCALE      : mkBaseReqParams.locale,
                             SDKTAG      : mkBaseReqParams.sdkTag,
                             
                             }];
    
    /* Sign组装 */
    NSString *paramStr = [self AMArrangeDicToNetParams:dict];
    NSString *originalSign = [NSString stringWithFormat:@"%@&%@", paramStr, gamekey];
    NSLog(@"originalSign:%@,gamekey:%@", originalSign,gamekey);
    //MD5
    NSString *sign = [MokeMD5 MokeHashString:originalSign];
    [dict setValue:sign forKey:SIGN];
    NSLog(@"==MKDealtParams:%@==",[self AMArrangeDicToNetParams:dict]);
    return [self AMArrangeDicToNetParams:dict];
}

+ (NSString *)AMArrangeDicToNetParams:(NSDictionary *)dic {
    
    /* key升序 */
    NSArray *allKeyArray = [dic allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    /* 按key升序读取 */
    NSMutableString *paramStr = [NSMutableString string];
    for (NSString *key in afterSortKeyArray) {
        [paramStr appendString:[NSString stringWithFormat:@"&%@=%@", key, dic[key]]];
    }
    return [paramStr substringFromIndex:1];
}


@end


