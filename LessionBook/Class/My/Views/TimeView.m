//
//  TimeView.m
//  LessionBook
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "TimeView.h"

@interface TimeView ()
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *timeUpView;
@property (nonatomic, strong) UILabel *timeShowLabel;
@property (nonatomic, assign) BOOL timeStart;
@property (nonatomic, assign) NSInteger tg;
@property (nonatomic, retain) NSTimer *timer;
@end

@implementation TimeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configTimeUpView];
    }
    return self;
}
- (void)configTimeUpView{
    
    
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    [self addSubview:self.blackView];
    
    //添加手势
    //初始化 创建一个轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //点击次数
    tap.numberOfTapsRequired = 1;
    //手指个数
    tap.numberOfTouchesRequired = 1;
    //把手势添加到视图上
    [self.blackView addGestureRecognizer:tap];
    
    
    self.timeUpView = [[UIView alloc] initWithFrame:CGRectMake(40, kHeight - 400, 295, 250)];
    self.timeUpView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:220/255.0 alpha:1];
    
    self.timeShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    self.timeShowLabel.text = @"定时关机";
    NSArray *timeArray = [NSArray arrayWithObjects:@"10分钟", @"20分钟", @"30分钟", @"60分钟", @"90分钟", @"120分钟", nil];
    
    UISwitch *timeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 10, 45, 30)];
    timeSwitch.on = NO;
    [timeSwitch addTarget:self action:@selector(timeUpGo:) forControlEvents:UIControlEventValueChanged];
    timeSwitch.backgroundColor = [UIColor whiteColor];
    [self.timeUpView addSubview:timeSwitch];
    
    for (int i = 0; i < 6; i++) {
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timeBtn.frame = CGRectMake((i % 3) * 100, 50 + (i / 3) * 100, 95, 95);
        [timeBtn setTitle:timeArray[i] forState:UIControlStateNormal];
        [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        timeBtn.tag = i;
        timeBtn.backgroundColor = [UIColor whiteColor];
        [timeBtn addTarget:self action:@selector(timeUpStart:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeUpView addSubview:timeBtn];
    }
    [self.timeUpView addSubview:self.timeShowLabel];
    [self addSubview:self.timeUpView];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.5;
    }];
}
//switch点击事件
- (void)timeUpGo:(UISwitch *)sswitch{
    if (sswitch.on == YES) {
        self.tg = 0;
        [self timeUpStart:nil];
    }
    else{
        
        [self.timer invalidate];
    }
}
//定时按钮点击
- (void)timeUpStart:(UIButton *)btn{
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    self.tg = btn.tag;
    self.timeStart = YES;
}
- (void)timerFireMethod:(NSTimer *)theTimer{
   
    NSArray *minuteArray = [NSArray arrayWithObjects:@"10", @"20", @"30", @"60", @"90", @"120", nil];
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];
    NSDate *date = [NSDate dateWithTimeInterval:[minuteArray[self.tg] integerValue] * 60 sinceDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
//    self.timeShowLabel.text = [NSString stringWithFormat:@"定时关机 %@", dateString];
    static int year;
    
    static int month;
    
    static int day;
    
    static int hour;
    
    static int minute;
    
    static int second;
    
    if(self.timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        
        year = [[dateString substringWithRange:NSMakeRange(0, 4)] intValue];
        
        month = [[dateString substringWithRange:NSMakeRange(5, 2)] intValue];
        
        day = [[dateString substringWithRange:NSMakeRange(8, 2)] intValue];
        
        hour = [[dateString substringWithRange:NSMakeRange(11, 2)] intValue];
        
        minute = [[dateString substringWithRange:NSMakeRange(14, 2)] intValue];
        
        second = [[dateString substringWithRange:NSMakeRange(17, 2)] intValue];
        
        self.timeStart= NO;
        
    }
    [endTime setYear:year];
    
    [endTime setMonth:month];
    
    [endTime setDay:day];
    
    [endTime setHour:hour];
    
    [endTime setMinute:minute];
    
    [endTime setSecond:second];
    
    NSDate *todate = [cal dateFromComponents:endTime];
    //用来得到具体的时差，是为了统一成北京时间
    //NSDateComponents封装在一个可扩展的，面向对象的方式的日期组件。它是用来弥补时间的日期和时间组件提供一个指定日期：小时，分钟，秒，日，月，年，等等。它也可以用来指定的时间，例如，5小时16分钟。
    unsigned int unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit| NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
//    NSInteger diffHour = [cps hour];
//    
//    NSInteger diffMin    = [cps minute];
//    
//    NSInteger diffSec   = [cps second];
    
//    NSInteger diffDay   = [cps day];
//    
//    NSInteger diffMon  = [cps month];
//    
//    NSInteger diffYear = [cps year];
    
    NSInteger shi = [d hour];
    
    NSString *fen = [NSString stringWithFormat:@"%ld", [d minute]];
    
   if([d minute] < 10) {
       
        fen = [NSString stringWithFormat:@"0%ld", [d minute]];

   }
    
    NSString *miao = [NSString stringWithFormat:@"%ld", [d second]];
    
    if([d second] < 10) {
        
        miao = [NSString stringWithFormat:@"0%ld",[d second]];
        
    }
    
    
    if(shi > 0 || [d minute] > 0 || [d second] > 0) {
    //计时尚未结束，do_something
        if (shi > 0) {
            self.timeShowLabel.text = [NSString stringWithFormat:@"定时关机  %ldh %@' %@''", shi, fen, miao];
        }else{
            self.timeShowLabel.text = [NSString stringWithFormat:@"定时关机  %@ ' %@''", fen, miao];
        }
        
    } else if(shi == 0 && [d second] == 0 && [d minute] == 0) {
    //计时1分钟结束，do_something
        
        
        
    }
      else{
        
        [theTimer invalidate];
        
    }
}
//点击屏幕隐藏timeUpView
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.5 animations:^{
//        [self removeFromSuperview];
//        self.timeUpView.hidden = YES;
//        [self.blackView removeFromSuperview];
        self.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

@end
