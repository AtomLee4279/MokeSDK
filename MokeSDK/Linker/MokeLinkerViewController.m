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
        //切本地
        if (ISLOCAL){
            [self MK_loadLocalGame];
        }
        else{
            //切Link
            if (initRespondData.openUrl) {
                NSURL *baseURL = [NSURL URLWithString:initRespondData.openUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
                [self.webview loadRequest:request];
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
    
//    NSString *urlStr = navigationAction.request.URL.absoluteString;
    
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
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
        DBLog(@"evaluate complete!");
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
