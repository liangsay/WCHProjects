//
//  OtherWebViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/22.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "OtherWebViewController.h"

@interface OtherWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation OtherWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:kURLFromString(@"http://www.66weihuo.com/common/agreement.html")];
    [self.webView loadRequest:requestUrl];
    self.title = @"协议";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnAction)];
}

- (void)closeBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
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
