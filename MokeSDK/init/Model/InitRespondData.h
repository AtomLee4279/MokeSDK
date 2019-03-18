//
//  InitRespondData.h
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/18.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MokeBaseRespondData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InitRespondData : MokeBaseRespondData

//*切链用的url*//
@property(nonatomic,copy)NSString* openUrl;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
