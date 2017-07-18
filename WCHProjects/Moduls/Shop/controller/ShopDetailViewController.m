//
//  ShopDetailViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/8.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopDetailOneViewController.h"
#import "ShopDetailWebViewController.h"
#import "ShopCommentViewController.h"

@interface ShopDetailViewController ()
{
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViewSet];
}

- (void)setupViewSet {
    NSInteger segStyle = _layout*4 + _style;
    
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"segmentStyle%ld",(long)segStyle]);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
    
    list = @[@"商品",@"详情",@"评价"];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, 200, 30) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.headColor = [UIColor clearColor];
    _segHead.selectColor = [UIColor mainColor];
    _segHead.lineColor = [UIColor mainColor];
    _segHead.fontScale = 1.0;
    _segHead.fontSize = 14;
    _segHead.lineScale = .5;
    _segHead.equalSize = YES;
    _segHead.bottomLineHeight = 0;
    
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavVCViewAndStatusHeight-48) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        self.navigationItem.titleView = _segHead;
        [self.view addSubview:_segScroll];
    }];
    
    
    
}
#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    ShopDetailOneViewController *one = [[ShopDetailOneViewController alloc]initWithNibName:@"ShopDetailOneViewController" bundle:nil];
    one.title = @"商品";
    one.index = 0;
    [arr addObject:one];
    
    ShopDetailWebViewController *two = [[ShopDetailWebViewController alloc]initWithNibName:@"ShopDetailWebViewController" bundle:nil];
    two.title = @"详情";
    two.index = 1;
    two.webUrlString = @"https://item.m.jd.com/product/2342601.html?sid=2b9de11ccb92d808eb2e1a39460f585d";
    [arr addObject:two];
    
    ShopCommentViewController *three = [[ShopCommentViewController alloc]initWithNibName:@"ShopCommentViewController" bundle:nil];
    three.title = @"评价";
    three.index = 2;
    [arr addObject:three];
//    for (NSInteger i = 0; i < count; i ++) {
//        ViewController *vc = [ViewController new];
//        vc.index = i;
//        [arr addObject:vc];
//    }
    return arr;
}


- (NSArray *)viewArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        UIView *view = [NSClassFromString(@"View") new];
        [arr addObject:view];
    }
    return arr;
}

- (NSArray *)viewNameArr {
    return @[@"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View"
             ];
}

- (NSArray *)vcnameArr {
    return @[@"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController"
             ];
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
