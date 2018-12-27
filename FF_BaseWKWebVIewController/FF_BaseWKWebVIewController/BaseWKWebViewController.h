//
//  BaseWKWebViewController.h
//  FF_BaseWKWebVIewController
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018 healifeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseWKWebViewController : UIViewController

@property (nonatomic,copy) NSString *urlStr;

@property (nonatomic,copy) NSString *webTitle;

///滚动webview的时候是否隐藏导航条
@property (nonatomic,assign) BOOL scrollHiddenNavBar;

-(void)goBack;
-(void)goForward;
-(void)reload;

@end

NS_ASSUME_NONNULL_END
