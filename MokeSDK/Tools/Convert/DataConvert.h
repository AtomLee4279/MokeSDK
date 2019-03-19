//
//  DataConvert.h
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/18.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataConvert : NSObject

//字典->json
+(NSString *)convertToJsonData:(NSDictionary *)dict;

//json->字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
