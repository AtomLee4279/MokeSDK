//
//  KKToast.m
//  KoalaGameKit
//
//  Created by kaola  on 2018/3/6.
//  Copyright © 2018年 kaola . All rights reserved.
//

#import "KKToast.h"
#import <KSToastView.h>

@interface KKToastView : KSToastView

@end

@implementation KKToast

+ (void)kk_showToast:(NSString *)toast
{
    if ([toast isEqualToString:@""])
    {
        return;
    }
    [KKToastView ks_setAppearanceTextColor:[UIColor whiteColor]];
    [KKToastView ks_setAppearanceOffsetBottom:[self screenBounds].size.height / 2];
    [KKToastView ks_showToast:toast duration:2.0f];
}
+ (CGRect)screenBounds {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect;
    if (![screen respondsToSelector:@selector(fixedCoordinateSpace)] && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        screenRect = CGRectMake(screen.bounds.origin.x, screen.bounds.origin.y, screen.bounds.size.height, screen.bounds.size.width);
    } else {
        screenRect = screen.bounds;
    }
    
    return screenRect;
}



@end


@implementation KKToastView

+ (UIView *)_keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

@end

