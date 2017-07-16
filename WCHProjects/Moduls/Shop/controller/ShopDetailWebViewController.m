//
//  ShopDetailWebViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/8.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopDetailWebViewController.h"
#import "JWCacheURLProtocol.h"
#import "UIWebView+Clean.h"
@interface ShopDetailWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ShopDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JWCacheURLProtocol startListeningNetWorking];
    // Do any additional setup after loading the view from its nib.
    _webView.scalesPageToFit = YES;
    _webView.scrollView.directionalLockEnabled = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self loadWebDetail];
}

- (void)onBackButton {
    [self.webView cleanForDealloc];
    [super onBackButton];
}

#pragma mark - setter/getter
- (void)loadWebDetail {
    NSURLRequest* webReq = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.webUrlString]];
    [self.webView loadRequest:webReq];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
