//
//  MokeBaseRespondData.m
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/18.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import "MokeBaseRespondData.h"

@implementation MokeBaseRespondData

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static MokeBaseRespondData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
    
}

@end
