//
//  privilegedMemberView.m
//  DoLifeApp
//
//  Created by sxf_pro on 2018/11/14.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "sxfFloatingView.h"
#import <Masonry.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface sxfFloatingView()<UITableViewDelegate, UITableViewDataSource>
//添加悬浮按钮
@property (nonatomic ,strong) UIImageView *suspensionImageV;
@property (nonatomic ,strong) CADisplayLink *dispalyLink;//计时器
@property (nonatomic ,strong) UITableView *tableView;
@end
@implementation sxfFloatingView
{
    NSArray *sectionTitleArr;
    NSArray <NSString *>*sectionSubTitleArr;
    
    //储存悬浮窗的位置
    CGPoint enterPoint;
    CGRect beSureFrame;//存储可视区域位置
    CGPoint initPoint;//储存初始化位置
    BOOL isinLeft;//记录在那一边
    
}




- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (void) addChildrenViews{
    
    UITableView *tab = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.estimatedRowHeight = 100;
    self.tableView = tab;
    [self addSubview:self.tableView];
    
    
    
    
    
    
    
    
    [self addBottomTitle:@"到底了" height:60];
    
    
    
    
    
    //添加悬浮窗
    [self addSubview:self.suspensionImageV];
    self.suspensionImageV.image = [UIImage imageNamed:@"privilage悬浮"];
    self.suspensionImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.suspensionImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageV:)];
    [self.suspensionImageV addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageV:)];
    [self.suspensionImageV addGestureRecognizer:pan];
    
    //默认的悬浮窗在右边
    isinLeft = NO;
    
    
    
}














- (void) tapImageV:(UIGestureRecognizer *)gesture{
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
         NSLog(@"点击悬浮按钮");
        
    }else if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
        CGPoint p = [pan velocityInView:self];
        
        
        p = [pan translationInView:self];
        if (pan.state == UIGestureRecognizerStateBegan) {
            //储存位置
            NSLog(@"开始");
        }else if (pan.state == UIGestureRecognizerStateChanged){
//            NSLog(@"正在移动");
//            NSLog(@"拖拽 x= %lf   y = %f", p.x, p.y);
            //判断点是否在约束内
            CGPoint center = ({
                CGPoint point = enterPoint;
                point.x = enterPoint.x + p.x;
                point.y = enterPoint.y + p.y;
                point;
            });
            if (CGRectContainsPoint(beSureFrame, center)) {
                self.suspensionImageV.center = center;
            }else{
                //不在内部
                self.suspensionImageV.center = ({
                    CGPoint newP = center;
                    if (center.x < beSureFrame.origin.x) {
                        newP.x = beSureFrame.origin.x;
                    }
                    if (center.x > (beSureFrame.origin.x + beSureFrame.size.width)) {
                        newP.x = (beSureFrame.origin.x + beSureFrame.size.width);
                    }
                    if (center.y > (beSureFrame.origin.y + beSureFrame.size.height)) {
                        newP.y = (beSureFrame.origin.y + beSureFrame.size.height);
                    }
                    if (center.y < beSureFrame.origin.y) {
                        newP.y = beSureFrame.origin.y;
                    }
                    newP;
                });
            }
        }else if (pan.state == UIGestureRecognizerStateEnded){
            NSLog(@"结束");
            //判断点是偏向哪边 这里只显示在左边或者右边
            //判断距离那边近
            if ((self.suspensionImageV.center.x - self.center.x) > 0) {
                //靠近右边 停止后向右边平移移动
                //修改重点center
                 [self starAnimationFromePoint:self.suspensionImageV.center to:CGPointMake(beSureFrame.origin.x + beSureFrame.size.width, self.suspensionImageV.center.y)];
                isinLeft = NO;
            }else{
                //靠近左边 向左边移动
                //修改终点center
                [self starAnimationFromePoint:self.suspensionImageV.center to:CGPointMake(beSureFrame.origin.x, self.suspensionImageV.center.y)];
                isinLeft = YES;
            }
        }
    }
}
//执行悬浮窗动画
- (void) starAnimationFromePoint:(CGPoint)fPoint to:(CGPoint)toPoint{
    //匀速运动
    CGFloat v = WIDTH * 0.5 / 0.5;//恒定速率
    CGFloat destence = ABS(fPoint.x - toPoint.x);
    CGFloat t = destence / v;
    [UIView animateWithDuration:t animations:^{
        self.suspensionImageV.center = toPoint;
    } completion:^(BOOL finished) {
        enterPoint = self.suspensionImageV.center;
        //执行timer复位
        self.dispalyLink.paused = NO;
    }];
}

//计时器
- (void) timerRun{
    NSLog(@"----");
    //暂定执行
    self.dispalyLink.paused = YES;
    
    
//    [UIView animateWithDuration:1 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        NSLog(@"%@", NSStringFromCGPoint(initPoint));
//        self.suspensionImageV.center = initPoint;
//    } completion:^(BOOL finished) {
//        enterPoint = initPoint;
//        self.dispalyLink.paused = YES;
//        isinLeft = NO;
//
//    }];
};

- (void) goOut{
    CGPoint goOutPoint;
    if (isinLeft) {
        //左边
        goOutPoint = CGPointMake(enterPoint.x - self.suspensionImageV.bounds.size.width, self.suspensionImageV.center.y);
    }else{
        //右边
        goOutPoint = CGPointMake(enterPoint.x + self.suspensionImageV.bounds.size.width, self.suspensionImageV.center.y);
    }
    [UIView animateWithDuration:1 animations:^{
        self.suspensionImageV.center = goOutPoint;
    } completion:^(BOOL finished) {

    }];
    
    
//    [UIView beginAnimations:nil context:nil]; // 开始动画
//    [UIView setAnimationDuration:1.0]; // 动画时长
//    self.suspensionImageV.center = goOutPoint;
//    [UIView commitAnimations]; // 提交动画
    
}
- (void) goBack{
    CGPoint goOutPoint;
    if (isinLeft) {
        //左边
        goOutPoint = CGPointMake(self.suspensionImageV.center.x + self.suspensionImageV.bounds.size.width, self.suspensionImageV.center.y);
    }else{
        //右边
        goOutPoint = CGPointMake(self.suspensionImageV.center.x - self.suspensionImageV.bounds.size.width, self.suspensionImageV.center.y);
    }
    [UIView animateWithDuration:1 animations:^{
        self.suspensionImageV.center = goOutPoint;
    } completion:^(BOOL finished) {

    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self goOut];
    NSLog(@"将要结束拖拽");
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self goBack];
    //当迅停止的时候不会调用
    NSLog(@"减速结束");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //当突然停止
    if (!decelerate) {
        [self goBack];//调用动画不正常
    }
    NSLog(@"scrollViewDidEndDragging");
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //添加悬浮窗
    [self.suspensionImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-64);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(83);
        make.height.mas_equalTo(91);
    }];
    [self layoutIfNeeded];
    
    enterPoint = self.suspensionImageV.center;
    initPoint = ({
        CGPoint p = CGPointZero;
        p.x = self.suspensionImageV.center.x;
        p.y = self.suspensionImageV.center.y;
        p;
    });
    //计算显示位置
    beSureFrame = ({
        CGRect frame = CGRectZero;
        frame.origin.x = self.suspensionImageV.bounds.size.width * 0.5 -1 ;
        frame.origin.y = self.suspensionImageV.bounds.size.height * 0.5 -1;
        frame.size.width = self.bounds.size.width - self.suspensionImageV.bounds.size.width + 1;
        frame.size.height = self.bounds.size.height - self.suspensionImageV.bounds.size.height + 1;
        frame;
    });
    
}





- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void) addBottomTitle:(NSString *)title height:(CGFloat)H{
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, H )];
    bottomV.backgroundColor = [UIColor clearColor];
    bottomV.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 12)];
    [bottomV addSubview:titleLb];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor grayColor];
    titleLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    titleLb.text = @"到底了";
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomV.mas_centerX);
        make.top.mas_equalTo(bottomV.mas_top).offset(15);
    }];
    
    self.tableView.tableFooterView = bottomV;
}



- (UIImageView *)suspensionImageV{
    if (!_suspensionImageV) {
        _suspensionImageV = [[UIImageView alloc] init];
    }
    return _suspensionImageV;
}

- (CADisplayLink *)dispalyLink{
    if (!_dispalyLink) {
        _dispalyLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerRun)];
        if (@available(iOS 10.0, *)) {
            _dispalyLink.preferredFramesPerSecond = 2;
        } else {
            _dispalyLink.frameInterval = 2;
        }
        [_dispalyLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_dispalyLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    }
    return _dispalyLink;
}
@end
