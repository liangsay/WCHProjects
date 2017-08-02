//
//  OrderListViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OrderListViewController.h"
#import "OCallCarViewController.h"
#import "ORentCarViewController.h"
#import "OBuyCarViewController.h"

@interface OrderListViewController ()
{
    NSArray *list;
}
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViewSet];
    
}

- (void)setupViewSet {
    self.layout = 1;
    self.style = 1;
    NSInteger segStyle = _layout*4 + _style;
    
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"segmentStyle%ld",(long)segStyle]);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
    
    list = @[@"叫车",@"租车",@"购车"];
    
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
    OCallCarViewController *one = [[OCallCarViewController alloc]initWithNibName:@"OCallCarViewController" bundle:nil];
    one.title = @"叫车";
    one.index = 0;
    [arr addObject:one];
    
    ORentCarViewController *two = [[ORentCarViewController alloc]initWithNibName:@"ORentCarViewController" bundle:nil];
    two.title = @"租车";
    two.index = 1;
    [arr addObject:two];
    
    OBuyCarViewController *three = [[OBuyCarViewController alloc]initWithNibName:@"OBuyCarViewController" bundle:nil];
    three.title = @"购车";
    three.index = 2;
    [arr addObject:three];
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

@end
