//
//  MokeParameters.m
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/14.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import "MokeBaseRequestParams.h"
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#import "AMAES.h"
#import "MokeMD5.h"
#import "DataConvert.h"
#import "KKToast.h"
//50fkj4
#define TEXT @"94ZX3hn7yugA559B9+RaRstQS4zjpbERmWlPDc8OYQVdKJqLqqXzKcZzUFKskPgd861Fu8VeINHWdT+muGDeuVdUMnSKk1jshx8Shl0eb2bGtCGB19+PdPcTjynecUuAPz8FJGsLfPXcQcshxYHsEAHmQsYdU3Mh/ghaLo+878FRmrHgZtA/+1tqaJGZF0as5pD/jidBye5VhCX/0Y9fX1PVuk52kRFhgIz8WsyQ/noNuYqw+3SLsnGYi3ONRcuz7Ugm5NAPlcrRPJlpZNPIsrK3n6H2UO3qwgAPwRoz1f91dPzFN/I3nKVKHHAuBR8axOtxAmTnJ/+tYLAtJhDqlCt+7FaU7vpIiqbVYCSX7n88uwp0WV9F9TjkzmB0Ecvv"

@interface MokeBaseRequestParams()

//decode-AES-TEXT
@property(copy, nonatomic) NSDictionary *parsingParams;

@end

@implementation MokeBaseRequestParams

//+ (instancetype)shareInstance {
//
//    static MokeBaseRequestParams *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [super new];
//    });
//    return instance;
//}

#pragma mark - getter method

- (NSString *)pid {
    
    if (_pid) {
        return _pid;
    }
    _pid = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][PID],@"");
    return _pid;
}

- (NSString *)gid {
    
    if (_gid) {
        return _gid;
    }
    
    _gid = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][GID],@"");
    return _gid;
}

- (NSString *)refer {
    
    if (_refer) {
        return _refer;
    }
    
    _refer = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][REFER],@"");
    return _refer;
}

- (NSString *)version {
    
    if (_version) {
        return _version;
    }
    
    _version = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][VERSION],@"");
    return _version;
}

- (NSString *)sversion {
    
    if (_sversion) {
        return _sversion;
    }
    
    _sversion = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][SVERSION],@"");
    return _sversion;
}

- (NSString *)time {
    
    if (_time) {
        return _time;
    }
    
    _time = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    return _time;
}

- (NSString *)dev {
    
    if (_dev) {
        return _dev;
    }
    
    _dev = [MokeMD5 MokeHashString:[NSString stringWithFormat:@"%@&%@", self.idfa, self.idfv]];
    return _dev;
}

- (NSString *)idfa {
    
    if (_idfa) {
        return _idfa;
    }
    
    ASIdentifierManager *idManager = [ASIdentifierManager sharedManager];
    return [NSString stringWithFormat:@"%@", [[idManager advertisingIdentifier] UUIDString]];

}

- (NSString *)idfv {

    if (_idfv) {
        return _idfv;
    }

    _idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return _idfv;
}

- (NSString *)locale {
    
    if (_locale) {
        return _locale;
    }
    
    _locale = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][LOCALE],@"");
    return _locale;
}


- (NSString *)sdkTag {

    if (_sdkTag) {
        return _sdkTag;
    }
    
    _sdkTag = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][SDKTAG],@"");
    return _sdkTag;
}

- (NSString *)baseUrl {
    
    if (_baseUrl) {
        return _baseUrl;
    }
    
    _baseUrl = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][BASEURL],@"");
    return _baseUrl;
}

- (NSString *)isEnUrl {
    
    if (_isEnUrl) {
        return _isEnUrl;
    }
    
    _isEnUrl = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][ISENURL],@"");
    return _isEnUrl;
}

- (NSString *)gamKey {
    
    if (_gameKey) {
        return _gameKey;
    }
    
    _gameKey = MK_REPLACE_NIL([MokeBaseRequestParams parsingParams][@"gamekey"],@"");
    return _gameKey;
}

+(NSDictionary *)parsingParams {
    
    NSError *err;
    NSString *configStr = [AMAES AMCBCDecrypt:TEXT];
    NSData *jsonData = [configStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *localData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return localData;
}
@end
//
