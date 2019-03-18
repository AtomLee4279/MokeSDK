//
//  MokeSDK.m
//  MokeSDK
//
//  Created by 李一贤 on 2019/3/14.
//  Copyright © 2019 李一贤. All rights reserved.
//

#import "MokeSDK.h"
#import "MokeBaseRequestParams.h"
#import "MokeNetworking.h"
#import "InitRespondData.h"
#import "MokeLinkerViewController.h"


@implementation MokeSDK

+(void)MokeInit{
    
    // 初始化次数统计
    static NSInteger InitTimes = 0;
    [MokeNetworking kk_POST:BaseURLString parameters:[MokeBaseRequestParams new] progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"MokeSDK:respondObject%@",responseObject);
        InitRespondData *tmp = [InitRespondData new];
        [tmp setValuesForKeysWithDictionary:responseObject];
        NSLog(@"tmp%@",tmp);
        if (tmp.openUrl) {
            [RootVC presentViewController:[MokeLinkerViewController new] animated:NO completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //初始化失败，先静默重试n次
        NSLog(@"MokeSDK:initFail:");
        NSLog(@"==InitTimes:%ld==",(long)InitTimes);
        if (InitTimes < MokeInitRetryMaxTime) {
            
            InitTimes++;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 重试
            [self MokeInit];
                
            });
        }
        else {
            InitTimes = 0;
            // 超过n次,弹出重试确认框
            __weak __typeof(self)weakSelf = self;
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络原因，是否重试？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cofirm = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf MokeInit];
            }];
            
            [alertVc addAction:cofirm];
            [RootVC presentViewController:alertVc animated:YES completion:NULL];
        }
        
        

    }];

}

@end
