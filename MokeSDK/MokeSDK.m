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
#import "AMAES.h"
#import "MokeMD5.h"
#import "DataConvert.h"
#import "KKToast.h"


@implementation MokeSDK

+(void)MkInit{
    
    // 激活次数统计
    static NSInteger InitTimes = 0;
    MokeBaseRequestParams *reqObj = [MokeBaseRequestParams new];
    
    [MokeNetworking mk_POST:reqObj.baseUrl parameters:reqObj progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                DBLog(@"MokeSDK:respondObject%@",responseObject);

                InitRespondData *initData = [InitRespondData new];
                [initData setValuesForKeysWithDictionary:responseObject];
                DBLog(@"tmp%@",initData);
                //请求成功，激活成功
                if (initData.errcode.intValue==0) {
                    
                        [RootVC presentViewController:[MokeLinkerViewController new] animated:NO completion:nil];
                }
                //请求成功，激活失败
                else{
                    if (initData.errmsg) {
                        //提示错误信息
                        [KKToast kk_showToast:initData.errmsg];
                    }
                }



    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                //请求失败，激活失败，先静默重试n次
                DBLog(@"MokeSDK:initFail:network");
                DBLog(@"==InitTimes:%ld==",(long)InitTimes);
                if (InitTimes < MokeInitRetryMaxTime) {

                    InitTimes++;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 重试
                    [self MkInit];

                    });
                }
                else {
                    InitTimes = 0;
                    // 超过n次,弹出重试确认框
                    __weak __typeof(self)weakSelf = self;
                    NSString *title = NSLocalizedString(@"提示", nil);
                    NSString *content = NSLocalizedString(@"网络原因，是否重试？",nil);
                    NSString *retry = NSLocalizedString(@"重试",nil);
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *cofirm = [UIAlertAction actionWithTitle:retry style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                        [weakSelf MkInit];
                    }];

                    [alertVc addAction:cofirm];
                    [RootVC presentViewController:alertVc animated:YES completion:NULL];
                }

    }];
    
    

}

@end
