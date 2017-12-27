//
//  LXQQSlideController.m
//  LXQQSlide
//
//  Created by chenergou on 2017/11/1.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXQQSlideController.h"
#import "LXLeftController.h"
#import "LXTabbarController.h"
#import "LXNavController.h"

#define MAXLEFTSLIDEWIDTH (Device_Width -100)
#define MAXSPEED 800
@interface LXQQSlideController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)LXBasicController *leftVc;
@property(nonatomic,strong)UIViewController *mainVc;

@property(nonatomic,strong)UIScreenEdgePanGestureRecognizer *pan1;//开始的边缘平移手势
@property(nonatomic,strong)UIPanGestureRecognizer *pan2;//侧滑后的平移手势

@property(nonatomic,strong)UITapGestureRecognizer *tap;//轻拍手势

@property(nonatomic,strong)UIView *maskView;//蒙版




@end

@implementation LXQQSlideController
+(instancetype)initWithLeftVC:(LXBasicController *)leftVc mainVc:(UIViewController *)mainVc{
    return  [[LXQQSlideController alloc]initWithLeftVC:leftVc mainVc:mainVc];
}
-(instancetype)initWithLeftVC:(LXBasicController *)leftVc mainVc:(UIViewController *)mainVc{
    
    self = [super init];
    if (self) {
        
        self.leftVc = leftVc;
        self.mainVc = mainVc;
        
        [self setup];
    }
    return self;
}

-(void)setup{
    [self.view addSubview:self.leftVc.view];
    [self.view addSubview:self.mainVc.view];
    [self addChildViewController:self.leftVc];
    [self addChildViewController:self.mainVc];
    
    [self.mainVc didMoveToParentViewController:self];
    
    [self.leftVc didMoveToParentViewController:self];
    
    self.leftVc.view.frame = self.view.bounds;
    self.mainVc.view.frame = self.view.bounds;

    LXTabbarController *tabbarVc = (LXTabbarController *)self.mainVc;
    
    [tabbarVc.tabBar addSubview:self.maskView];
    
    //添加屏幕边缘平移手势
    [self.mainVc.view addGestureRecognizer:self.pan1];
    
    //添加平移手势
    [self.mainVc.view addGestureRecognizer:self.pan2];
    
    //添加点击手势
    [self.mainVc.view addGestureRecognizer:self.tap];
    

  
    LXLeftController *leftVc = (LXLeftController *)self.leftVc;
    
    LXWS(weakSelf);
    
    
    leftVc.typeClick = ^(NSString *type, __unsafe_unretained Class targetClass) {
        if ([weakSelf.mainVc isKindOfClass:[LXTabbarController class]]) {
            
            LXBasicController *vc = [targetClass new];
            LXNavController *nav =  (LXNavController *)[tabbarVc LX_NavController];
            vc.view.backgroundColor = LXRandomColor;
            vc.title = type;
            [nav pushViewController:vc animated:YES];
            [weakSelf closeDrawer];//关闭抽屉
        }
    };
}

#pragma mark---手势处理
-(void)screenGesture:(UIPanGestureRecognizer *)pan{
    
    //移动的距离
    CGPoint point = [pan translationInView:pan.view];
    //移动的速度
    CGPoint verPoint =  [pan velocityInView:pan.view];
    
   
    
    self.mainVc.view.lx_x += point.x;
    
    //边界限定
    if (self.mainVc.view.lx_x >= MAXLEFTSLIDEWIDTH) {
        self.mainVc.view.lx_x = MAXLEFTSLIDEWIDTH;
    }
    if (self.mainVc.view.lx_x <= 0) {
        self.mainVc.view.lx_x = 0;
    }
    
    //蒙版的阴影限定
    self.maskView.alpha = self.mainVc.view.lx_x /MAXLEFTSLIDEWIDTH;
   
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        //判断手势
        if (pan == self.pan1) {
            
            
            if (verPoint.x > MAXSPEED) {
                
                 [self showLeftVc];
                
            }else{
                
                if (self.mainVc.view.lx_x >= Device_Width/2) {
                    
                    [self showLeftVc];
                    
                }else{
                    
                    [self hideLeftVc];
                    
                }
            }
        }else{
            
            if (verPoint.x < - MAXSPEED) {
                
                [self hideLeftVc];
            }else{
                
                if (self.mainVc.view.lx_x >= Device_Width/2) {
                    
                    
                    [self showLeftVc];
                    
                }else{
                    
                    [self hideLeftVc];
                    
                }
            }
        }
        
        
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];

}
#pragma mark---点击手势----
-(void)tapGesture:(UITapGestureRecognizer *)tap{
    
    [self hideLeftVc];
}

#pragma mark--隐藏左侧视图--
-(void)hideLeftVc{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskView.alpha = 0;
        self.mainVc.view.lx_x = 0;
        
    } completion:^(BOOL finished) {
        self.pan1.enabled = YES;
        self.pan2.enabled = NO;
        self.tap.enabled = NO;
    }];
}
#pragma mark--显示左侧视图--
-(void)showLeftVc{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mainVc.view.lx_x = MAXLEFTSLIDEWIDTH;
        
    } completion:^(BOOL finished) {
        self.pan1.enabled = NO;
        self.pan2.enabled = YES;
        self.tap.enabled = YES;
    }];
}

#pragma mark--关闭抽屉--
-(void)closeDrawer{
    
    self.mainVc.view.lx_x = 0;
    self.maskView.alpha  = 0;
    self.pan1.enabled = YES;
    self.pan2.enabled = NO;
    self.tap.enabled = NO;

}
#pragma mark--打开抽屉--
-(void)openDrawer{
      [self showLeftVc];
}
#pragma mark--lazyLoad--
-(UIScreenEdgePanGestureRecognizer *)pan1{
    if (!_pan1) {
        _pan1 =[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenGesture:)];
        _pan1.edges = UIRectEdgeLeft;
        _pan1.delegate = self;
        _pan1.enabled = YES;
        
    }
    return _pan1;
}
-(UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        _tap.numberOfTapsRequired = 1;
        
    }
    return _tap;
}
-(UIPanGestureRecognizer *)pan2{
    if (!_pan2) {
        _pan2 =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(screenGesture:)];
        _pan2.delegate = self;
        
        _pan2.enabled = NO;
        
    }
    return _pan2;
}
-(UIView *)maskView{
    if (!_maskView) {
        _maskView =[[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.lx_y = -self.mainVc.view.bounds.size.height +49; //蒙版添加到tabbar上
        _maskView.backgroundColor =[[UIColor lightGrayColor]colorWithAlphaComponent:0.3];        _maskView.alpha = 0;

    }
    return _maskView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

////這個方法的意思是說：是否要 gestureRecognizer 被判定偵測失敗了，才可以偵測 otherGestureRecognizer。
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//
//    NSLog(@"1111%@",gestureRecognizer);
//    NSLog(@"other%@",gestureRecognizer);
//
//    return YES;
//}
////這個方法的意思是說：是否要 otherGestureRecognizer 被判定失敗了，才可以偵測 gestureRecognizer。
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//
////    NSLog(@"2222%@",gestureRecognizer);
////    NSLog(@"2222other%@",otherGestureRecognizer);
//
//    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"_UISystemGestureGateGestureRecognizer")]) {
//        return YES;
//    }
//    return NO;
//}

@end
