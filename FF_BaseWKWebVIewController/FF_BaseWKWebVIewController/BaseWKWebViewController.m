//
//  BaseWKWebViewController.m
//  FF_BaseWKWebVIewController
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018 healifeGroup. All rights reserved.
//

#import "BaseWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "MyInfoCachingView.h"

@interface BaseWKWebViewController ()<WKUIDelegate,WKNavigationDelegate>


@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation BaseWKWebViewController

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.webTitle;
    
    /// 清理webView缓存
    //[self clearWbCache];
    
    /// webView
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"skey=skeyValue" forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    /// 进度条
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    /// 监听webView的进度和标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

#pragma mark - <Private>

/**
 清理缓存
 */
- (void)clearWbCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

///这三个功能 根据需要自己来定制UI操作
-(void)goBack{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

-(void)goForward{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

-(void)reload{
    [self.webView reload];
}

#pragma mark - <Loading>
//显示loading
-(void)showOpenCachingView{
    MyInfoCachingView *cachingView = [[MyInfoCachingView alloc] init];
    [self.view addSubview:cachingView];
}
//移除loading
-(void)removeCachinigView{
    for (UIView *suv in self.view.subviews) {
        if ([suv isKindOfClass:[MyInfoCachingView class]]) {
            [suv removeFromSuperview];
        }
    }
}

#pragma mark - Observer
// 监听webView 获取到title
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.alpha = 1.0;
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.25 animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                self.progressView.progress = 0.0f;
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (!self.title && self.webTitle.length == 0) {
            NSString *title = self.webView.title;
            if (title.length > 20) {
                title = [[title substringToIndex:20] stringByAppendingString:@"…"];
            }
            self.navigationItem.title = title;
        }
    }
}

#pragma mark - <WKUIDelegate,WKNavigationDelegate>
//  页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self showOpenCachingView];
}

//  当web内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self removeCachinigView];
}

//  页面加载失败时调用 ( 【web视图加载内容时】发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self removeCachinigView];
}

// 【web视图导航过程中发生错误】时调用。
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self removeCachinigView];
}

// 当Web视图的Web内容进程终止时调用。
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [self removeCachinigView];
}

#pragma mark - <Lazy>

-(WKWebView *)webView{
    if (_webView == nil) {
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc] init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

-(UIProgressView *)progressView{
    if (_progressView == nil) {
        CGFloat progressViewHeight = 2.0f;
        CGRect navigationBarBouds = self.navigationController.navigationBar.bounds;
        CGRect progressViewFrame = CGRectMake(0, navigationBarBouds.size.height - progressViewHeight, navigationBarBouds.size.width, progressViewHeight);
        
        _progressView = [[UIProgressView alloc] initWithFrame:progressViewFrame];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor orangeColor];
    }
    return _progressView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
