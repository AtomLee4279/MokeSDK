//
//  AMLinkerViewController.m
//  AnimSDK
//
//  Created by  Yvan Hall on 2019/3/1.
//  Copyright © 2019  Yvan Hall. All rights reserved.
//

#import "MokeLinkerViewController.h"
#import <WebKit/WebKit.h>
#import "InitRespondData.h"
#import "HTTPServer.h"

@interface MokeLinkerViewController ()
{
    HTTPServer *httpServer;
}

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation MokeLinkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - 创建WKWebView
    {
        self.webview = [WKWebView new];
        self.view.backgroundColor = [UIColor redColor];
        /* 横竖屏调整UI */
        if(ORIENTATION == UIInterfaceOrientationPortrait ||
           ORIENTATION == UIInterfaceOrientationPortraitUpsideDown) {
            self.webview.frame = SCREEN_BOUNDS;
        } else {
            self.webview.frame = CGRectMake(0, 0, SCREEN_BOUNDS.size.height, SCREEN_BOUNDS.size.width);
        }
        
        self.webview.scrollView.scrollEnabled = NO;
        self.webview.scrollView.pagingEnabled = NO;
        self.webview.backgroundColor = [UIColor whiteColor];
        [self.webview setOpaque:NO];
        [self.view addSubview:self.webview];
        InitRespondData *initRespondData = [InitRespondData new];
        //如果本地调试开关打开，则优先切本地
        if (ISLOCAL){
            [self MK_loadLocalGame];
        }
        //否则看激活返回link
        else{
            //若激活返回link，切Link
            if (initRespondData.openUrl) {
                NSString *openUrl = @"http://d56dx.com/h5game/public/?pid=1&gid=1003823&sversion=4.5.0S&skinId=2";
//                NSURL *baseURL = [NSURL URLWithString:initRespondData.openUrl];
                NSURL *baseURL = [NSURL URLWithString:openUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
                [self.webview loadRequest:request];
            }
            //否则加载本地
            else{
                [self MK_loadLocalGame];
            }
            
        }
    }
}

#pragma mark - Method

- (void)MK_loadLocalGame{
    //    TrashRun_Five();
    // Create server using our custom MyHTTPServer class
    httpServer = [[HTTPServer alloc] init];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_http._tcp."];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: gamePathName];
    [httpServer setDocumentRoot:webPath];
    [self MK_startServer];
    
    // 直接加载本地的url:直接加载NSURL，可以 --- for WKWebView
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:%@/%@.%@", @(httpServer.listeningPort), gameIndexName, gameIndexSuffix];
    DBLog(@"urlString == %@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webview loadRequest:request];
}

- (void)MK_startServer {
    // Start the server (and check for problems)
    NSError *error;
    if([httpServer start:&error]) {
        
        DBLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else {
        
        DBLog(@"Error starting HTTP Server: %@", error);
    }
}

#pragma mark - WKWebView代理

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    
    NSString *green = XOR_NSSTRING(((char []) {125, 111, 99, 114, 99, 100, 0}));
    NSString *blue  = XOR_NSSTRING(((char []) {107, 102, 99, 122, 107, 115, 0}));
    
    if ([urlStr hasPrefix:green]) {
        [self MKGreenGift:urlStr];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ([urlStr hasPrefix:blue]) {
        [self MKBlueGift:urlStr];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}





#pragma mark - 蓝绿🎁

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)MKGreenGift:(NSString *)str {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
}

- (void)MKBlueGift:(NSString *)str {
    /* 不做妈爸爸回app操作，URLScheme太过敏感 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
}

#pragma mark - 滚动条延迟响应
-(UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return UIRectEdgeAll;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//- Fix bug: the UIWebView Content is scroll up when the keyboard appears
- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self.webview evaluateJavaScript:@"window.scrollTo(0, 0);" completionHandler:^(id _Nullable respone, NSError * _Nullable error) {
        NSLog(@"evaluate complete!");
    }];
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
