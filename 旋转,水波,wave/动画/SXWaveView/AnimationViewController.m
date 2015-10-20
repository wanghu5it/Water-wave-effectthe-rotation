//
//  AnimationViewController.m
//  one2one
//
//  Created by wanghu on 15/8/20.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "AnimationViewController.h"
#import "SXWaveView.h"  // -----步骤1 引入自定义view头文件
#import "SXHalfWaveView.h"
#import "UIViewAdditions.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SIDES SCREEN_WIDTH/3.5
#define MARGIN SCREEN_WIDTH/28
#define COLOR(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

@interface AnimationViewController ()
@property(nonatomic,strong)SXWaveView *animateView1; // ------步骤2 建一个成员变量
/**
 *  最低下的视图
 */
@property (weak, nonatomic) IBOutlet UIView *Animation;
@property (weak, nonatomic) IBOutlet UIImageView *AnimationRoation;
@property (weak, nonatomic) IBOutlet UIImageView *AlertImageViwe;
@property(nonatomic,retain) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *SeekHead;
/**
 *  星星视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *xinxinImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *xinxinImage2;
/**
 *  文字
 */
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property(nonatomic,copy)NSString *chatId;

@property (atomic, assign) BOOL requestCancled;
@property(nonatomic,assign) int speed;
@property (weak, nonatomic) IBOutlet UILabel *timeStr;
@property (weak, nonatomic) IBOutlet UIImageView *WaveTranst;
@property(nonatomic,strong) NSString * simpleOrderId;

@property(nonatomic,copy)NSString *headIcon;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
- (IBAction)Start:(UIButton *)sender;
- (IBAction)Show:(UIButton *)sender;
@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _speed=180;
    [self CreatUI];
    [self ShuiBoxiaoguo];
       self.navigationController.navigationBarHidden=YES;
 }
-(void)CreatUI{
    //刚进入的时候隐藏不需要的东西
    self.SeekHead.hidden=YES;
    self.xinxinImageView1.hidden=YES;
    self.xinxinImage2.hidden=YES;
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:@"旋转加水波"];
    [attriString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25.0f],NSForegroundColorAttributeName:[UIColor colorWithRed:0.0f /255.0f green:191.0f / 255.0f blue:191.0f / 255.0f alpha:1.0f]} range:NSMakeRange(1, 3)];
    [self.label1 setAttributedText:attriString];
     self.label2.text=@"效果特别酷哦";
}
/**
 *  水波效果
 */
-(void)ShuiBoxiaoguo
{
    SXWaveView *animateView1 = [[SXWaveView alloc]initWithFrame:CGRectMake(58,72.49-5,165.5+2, 155)];
    [self.Animation addSubview:animateView1];
   self.precent=80;
    self.animateView1 = animateView1;
    [self.Animation  addSubview:self.timeStr];
    [self.animateView1 setPrecent:self.precent description:nil textColor:[UIColor yellowColor] bgColor:[UIColor clearColor] alpha:1 clips:NO];

}
/**
 *  小人转动的动画
 */
-(void)Anitiontest
{
        CABasicAnimation * transformRoate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        transformRoate.byValue = [NSNumber numberWithDouble:(-2 * M_PI)];
        transformRoate.duration = 18;
    transformRoate.repeatCount=10;
        [self.AnimationRoation.layer addAnimation:transformRoate forKey:@"rotationAnimation"];
    
}
/**
 *  显示动画
 */
-(void)Anitiontest2{
    CABasicAnimation * transformRoate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    transformRoate.byValue = [NSNumber numberWithDouble:( M_PI)];
    transformRoate.duration = 0.15;
    [self.AlertImageViwe.layer addAnimation:transformRoate forKey:@"rotationAnimation"];

}
/**
 *  缩放动画
 */
-(void)ZoomImage{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
    anim.duration = 2;
    anim.removedOnCompletion=NO;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate=self;
 anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 152, 149)];
  [self.SeekHead.layer addAnimation:anim forKey:nil];
    
}
/**
 *  星星效果
 */
-(void)Star
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
    anim.duration = 1;
      anim.toValue = [NSValue valueWithCGRect:CGRectMake(55, 77, 44, 31)];
    [self.xinxinImageView1.layer addAnimation:anim forKey:nil];
}
-(void)Star1
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
    anim.duration = 1;
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(88, 77, 36, 29)];
    [self.xinxinImage2.layer addAnimation:anim forKey:nil];
}
#pragma 动画的代理
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.xinxinImageView1.hidden=NO;
    self.xinxinImage2.hidden=NO;
    [self Star];
    [self Star1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)Annbtn:(id)sender {
   
}
- (void)startTimer{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //实例化定时器
        _timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(reduceSpeed) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
    
}

-(void)reduceSpeed{
    [self Anitiontest2];
    
    self.speed=_speed-1;
    int seconds = _speed % 60;
    int minutes = (_speed / 60) % 60;
    NSLog(@"ddd  %@",[NSString stringWithFormat:@"0%d:%02d",minutes,seconds]);
self.timeStr.text=[NSString stringWithFormat:@"0%d:%02d",minutes,seconds];
    if (self.speed==0) {
        [self performSegueWithIdentifier:@"aginfind" sender:self];
    }
}

#pragma mark  确保在退出该界面的时候销毁NStimer
-(void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer=nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self cancleRequest];
}

-(void)StartAnimation
{
    [self.animateView1 addAnimateWithType:1];
    //开启定时器
    [self startTimer];
    [self Anitiontest];
}
-(void)showSuccessAlert
{
   
        self.AnimationRoation.hidden=YES;
        self.AlertImageViwe.hidden=YES;
        self.animateView1.hidden=YES;
        self.SeekHead.hidden=NO;
        [self ZoomImage];
        self.label1.text=@"已经成功匹配到";
        self.label2.text=@"最适合您的顾问";
        
    }


#pragma mark -
- (void)cancleRequest
{
    self.requestCancled = YES;
}

- (void)pullRequest:(NSInteger)delay
{
    if (self.requestCancled) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            });
}

   - (IBAction)Start:(UIButton *)sender {
     [self StartAnimation];

}

- (IBAction)Show:(UIButton *)sender {
    [self showSuccessAlert];
}
@end
