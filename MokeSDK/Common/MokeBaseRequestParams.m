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


#define TEXT @"38jmSNQTEekJkI6rgvNmyoJhcZj1xPRzWkMHJMsdS4Sn+m9T0/vI/Hm4DuoOGICO3+qmpvXj+VtmqOjdG+Vm16kumqXTCVqJhW/cwSJl3xghQobsGSaI4WNV6o1lCcnKSgsDZ4o4EfuJWZQ3pJ40+A9FRyyRqkaIzZsanvo+lDIvYNxCIikdnXx1aikvrwBzPx5MGfevCVWYguD3WgcmIVdFixFTvqWCTycVtnwcc19PKOEgllnczxRZdrAzF9pXyGPilYn/MABnGqqCv+0uiMuzpQTpMOko/t8lp0p9jZ5z5ouuAPlDgW+5b49j54J80ZQq6jn7zi7cN+BTARkcyg=="


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



- (NSString *)pid {
    
    if (_pid) {
        return _pid;
    }
    
    _pid = @"46";
    return _pid;
}

- (NSString *)gid {
    
    if (_gid) {
        return _gid;
    }
    
    _gid = @"1005388";
    return _gid;
}

- (NSString *)refer {
    
    if (_refer) {
        return _refer;
    }
    
    _refer = @"sy00000_1";
    return _refer;
}

- (NSString *)version {
    
    if (_version) {
        return _version;
    }
    
    _version = @"1.0";
    return _version;
}

- (NSString *)sversion {
    
    if (_sversion) {
        return _sversion;
    }
    
    _sversion = @"5.0.0S";
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
    
    _dev = [NSString stringWithFormat:@"%@&%@", self.idfa, self.idfv];
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
    
    _locale = @"zh-cn";
    return _locale;
}


//- (NSString *)i {
//
//    if (_i) {
//        return _i;
//    }
//    
//    _i = @"sook";
//    return _i;
//}

//- (NSString *)sign {
//
//    if (_sign) {
//        return _sign;
//    }
//    
//    _sign = [NSString stringWithFormat:@"dev=%@&gid=%@&pid=%@", self.idfa, self.idfv,self.pid];
//    _sign = [NSString stringWithFormat:@"%@&%@",_sign,signedGameKey];
//    return _sign;
//}
@end
