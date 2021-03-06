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

#define gamekey @"npLoAk8l93JDsiwjN/5XIghSmKt;Efde"

@implementation MokeNetworking

#pragma  mark - Method
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
    NSString * tmpStr= [MokeNetworking MKProcessParams:parameters];
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
         DBLog(@"==mk:nameStr==%@",respondDic);
        //请求成功，激活成功
        if (success&&respondDic) {
            success(NULL,respondDic);
        }
        //激活失败（网络原因的激活失败）
        if (error&&failure) {
            
            failure(NULL,error);
        }
        
    }] resume];
}


+ (NSString *)MKProcessParams:(nullable id)parameters {
    
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
    DBLog(@"originalSign:%@,gamekey:%@", originalSign,gamekey);
    //MD5
    NSString *sign = [MokeMD5 MokeHashString:originalSign];
    [dict setValue:sign forKey:SIGN];
    DBLog(@"==MKDealtParams:%@==",[self AMArrangeDicToNetParams:dict]);
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


