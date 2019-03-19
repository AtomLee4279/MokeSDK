//
//  InitRespondData.m
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/18.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import "InitRespondData.h"

@implementation InitRespondData


//-(void)setOpenUrl:(NSString *)openUrl{
//    self.openUrl = openUrl;
//}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:DATA]&&(NSDictionary*)value[@"openUrl"]) {
        self.openUrl = value[@"openUrl"];
    }
    else if ([key isEqualToString:ERRCODE]) {
        self.errcode = (NSString*)value;
    }
    else if ([key isEqualToString:ERRMSG]) {
        self.errmsg = (NSString*)value;
    }
    
}
@end
