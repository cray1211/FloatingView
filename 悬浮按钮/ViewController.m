//
//  ViewController.m
//  悬浮按钮
//
//  Created by sxf_pro on 2018/11/14.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "ViewController.h"
#import "sxfFloatingView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"悬浮按钮事件";
    sxfFloatingView *priV = [[sxfFloatingView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    
    
    [self.view addSubview:priV];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
