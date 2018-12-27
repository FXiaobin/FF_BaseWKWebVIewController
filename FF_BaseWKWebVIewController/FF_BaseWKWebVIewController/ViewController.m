//
//  ViewController.m
//  FF_BaseWKWebVIewController
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018 healifeGroup. All rights reserved.
//

#import "ViewController.h"
#import "BaseWKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"WKWebView基本使用";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 40)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"打开docx" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

-(void)openAction:(UIButton *)sender{
    [self showFileWebViewWithURL:@"https://blog.csdn.net/zhang522802884/article/details/79245151" title:nil];
//    [self showFileWebViewWithURL:@"http://store-pic.medmeeting.com/2018-12-19_aDrbdblq.docx" title:nil];
}

-(void)showFileWebViewWithURL:(NSString *)urlStr title:(NSString *)title{
    BaseWKWebViewController *web = [[BaseWKWebViewController alloc] init];
    web.urlStr = urlStr;
    web.webTitle = title;
    web.scrollHiddenNavBar = YES;   //滚动时隐藏导航条
    [self.navigationController pushViewController:web animated:YES];
}

@end
