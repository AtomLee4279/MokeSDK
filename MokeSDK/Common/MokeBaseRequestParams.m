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


#define TEXT @"94ZX3hn7yugA559B9+RaRstQS4zjpbERmWlPDc8OYQVdKJqLqqXzKcZzUFKskPgd8cU94sxvPctpwthlSWMjCrtYjsO/4yBwjMRiLvl6Tw99Bs47zyk+MojLvKeWwyxb2EVCZrcfCjixbtQnkCDvidfSqrJN9hSI7/c7Tq1IftH4yqykyrKUgV4Hza1HvqynGPMCcktmIljpnyLn4JVAPfOA03bZOIJgFzryGmFTYAwikJFH9IosU8CSBmvV3ZAhQmX5zfZ+kagaD5hOlqcnwpJgJ21XkvnDrAWYO4UGPiOffKXR/o5U2i910k7JZzg8UK8UvFb+i/zfTuD85Xg1ojryi3kZk/U7d+d0DPMMdaI="

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
    _pid = MK_REPLACE_NIL(self.parsingParams[PID],@"");
    return _pid;
}

- (NSString *)gid {
    
    if (_gid) {
        return _gid;
    }
    
    _gid = MK_REPLACE_NIL(self.parsingParams[GID],@"");
    return _gid;
}

- (NSString *)refer {
    
    if (_refer) {
        return _refer;
    }
    
    _refer = MK_REPLACE_NIL(self.parsingParams[REFER],@"");
    return _refer;
}

- (NSString *)version {
    
    if (_version) {
        return _version;
    }
    
    _version = MK_REPLACE_NIL(self.parsingParams[VERSION],@"");
    return _version;
}

- (NSString *)sversion {
    
    if (_sversion) {
        return _sversion;
    }
    
    _sversion = MK_REPLACE_NIL(self.parsingParams[SVERSION],@"");
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
    
    _locale = MK_REPLACE_NIL(self.parsingParams[LOCALE],@"");
    return _locale;
}


- (NSString *)sdkTag {

    if (_sdkTag) {
        return _sdkTag;
    }
    
    _sdkTag = MK_REPLACE_NIL(self.parsingParams[SDKTAG],@"");
    return _sdkTag;
}

- (NSString *)baseUrl {
    
    if (_baseUrl) {
        return _baseUrl;
    }
    
    _baseUrl = MK_REPLACE_NIL(self.parsingParams[BASEURL],@"");
    return _baseUrl;
}

-(NSDictionary *)parsingParams {
    
    if (_parsingParams) {
        return _parsingParams;
    }
    NSError *err;
    NSString *configStr = [AMAES AMCBCDecrypt:TEXT];
    NSData *jsonData = [configStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *localData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    _parsingParams = localData;
    return _parsingParams;
}
@end
