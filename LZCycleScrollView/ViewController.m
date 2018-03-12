//
//  ViewController.m
//  LZCycleScrollView
//
//  Created by apple on 2015/3/12.
//  Copyright © 2015年 LIZHAO. All rights reserved.
//

#import "ViewController.h"
#import "LZCycleScrollView.h"
@interface ViewController ()<LZCycleScrollViewDelegate>
@property(nonatomic,strong)LZCycleScrollView * lzCycleScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrol];
    self.title = @"轮播图";
}


- (void)initScrol {
    _lzCycleScroll = [[LZCycleScrollView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    _lzCycleScroll.delegate = self;
    _lzCycleScroll.backgroundColor = [UIColor redColor];
    [self.view addSubview:_lzCycleScroll];
    _lzCycleScroll.localImageUrlGroup = @[@"1",@"2",@"3"];
    _lzCycleScroll.cycleViewItemClickBlock = ^(NSInteger index) {
        NSLog(@"block--->index：%ld",index);
    };
}

#pragma mark - LZCycleScrollViewDelegate
- (void)lzCycleViewDidSelectItem:(NSInteger)index {
    NSLog(@"delegate --->index：%ld",index);
}

@end
