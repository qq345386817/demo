//
//  WebViewCookieController.m
//  JavaScriptCoreDemo
//
//  Created by mac on 2019/5/5.
//  Copyright © 2019 ikangtai. All rights reserved.
//

#import "WebViewCookieController.h"
#import <WebKit/WebKit.h>

@interface WebViewCookieController ()<WKNavigationDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;
@property (assign, nonatomic) double lastProgress;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation WebViewCookieController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"index_cookie" ofType:@"html"];
//    NSString * html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:html baseURL:nil];
    
    //请求
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    //[request setHTTPShouldHandleCookies:YES];
//    [request setValue:[NSString stringWithFormat:@"%@=%@",@"TeskCookieKey3", @"TeskCookieValue3"] forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:request];
}

-(void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    NSLog(@"%@---%s", [self class], __FUNCTION__);
}

- (void)updateProgress:(double)progress {
    self.progressView.alpha = 1.0;
    if (progress > self.lastProgress) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    } else {
        [self.progressView setProgress:self.webView.estimatedProgress];
    }
    self.lastProgress = progress;
    if (progress >= 1.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.alpha = 0.0;
            [self.progressView setProgress:0.0];
            self.lastProgress = 0.0;
        });
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self updateProgress:self.webView.estimatedProgress];
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WebView Delegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self updateProgress:webView.estimatedProgress];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self updateProgress:webView.estimatedProgress];
    
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self updateProgress:webView.estimatedProgress];
    if (error.code == -999) {
        NSAssert(true, @"Network Error: -999");
        return;
    }
    
    NSLog(@"Error: %@", error);
}

#pragma mark - WKScriptMessageHandler

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

#pragma mark - lazy load

-(UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.tintColor = [UIColor colorWithRed:0x5B/255 green:0xDD/255 blue:0x67/255 alpha:1.0];
        _progressView.trackTintColor = [UIColor clearColor];
        [self.webView addSubview:_progressView];
        _progressView.frame = CGRectMake(0, 0, self.webView.bounds.size.width, 3);
    }
    return _progressView;
}

-(WKWebView *)webView {
    if (_webView == nil) {
        //初始化
        WKUserContentController* userContentController = [[WKUserContentController alloc] init];
        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: @"document.cookie ='TeskCookieKey3=TeskCookieValue3';" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        
        WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
        webViewConfig.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.5) configuration:webViewConfig];
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
