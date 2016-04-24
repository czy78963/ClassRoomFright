//
//  PlayBordyViewController.m
//  ClassRoomFright
//
//  Created by rimi on 16/3/14.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "PlayBodyViewController.h"
#import "MacMethod.h"
#import "FitOfScreen.h"
#import "AppDelegate.h"
#import "UIImage+ImageManage.h"
#import "GameOverViewController.h"
@import AVFoundation;

@interface PlayBodyViewController () 

@property (nonatomic, assign) CGPoint startPoint, endPoint;
@property (nonatomic, strong) NSDate * endTime;
@property (nonatomic, strong) NSDate * sendTime;//  发射粉笔开始时记录时间
@property (nonatomic, assign) CGPoint sendPoint;
@property (nonatomic, strong) NSTimer * timerForSend;//  定时发射粉笔
@property (nonatomic, strong) NSTimer * timerForSleep;//  定时出现睡觉的学生
@property (nonatomic, strong) UILabel * label11;//  粉笔发射
@property (nonatomic, strong) UILabel * label10;//  玩家发射
@property (nonatomic, assign) NSInteger num;//  粉笔扔向的位置
@property (nonatomic, assign) NSInteger sleepStuPoint;//  睡觉学生位置
@property (nonatomic, assign) NSInteger choosePoint;
@property (nonatomic, assign) BOOL tapInTheRange;
@property (nonatomic, strong) UIImageView * hitEffect;//  击中效果显示
@property (nonatomic, strong) UIImageView * sleepStudent;//  睡觉学生显示
@property (nonatomic, strong) UILabel * scoralLabel;//  记分版
@property (nonatomic, assign) NSInteger scoral;//  得分
@property (nonatomic, strong) UILabel * hpLabel;//  生命值label
@property (nonatomic, assign) NSInteger hp;//  生命值
@property (nonatomic, assign) BOOL didTapped;//  同时只能发出一个
@property (nonatomic, assign) BOOL hitten;//  击中标志，击中为1，未击中为2
@property (nonatomic, strong) UIImageView * cry;//  未击中时显示
@property (nonatomic, strong) UIImageView * cool;//  击中时显示
@property (nonatomic, strong) UIImageView * angry;//  打错时显示
@property (nonatomic, strong) UIImageView * angryFire;//  打错时显示
@property (nonatomic, strong) UIImageView * bgAnime;//  背景模糊渐变动画
@property (nonatomic, strong) NSMutableArray * animeArr;//  模糊动画数组
@property (nonatomic, strong) UIImageView * bgPic;//  背景（教室）
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;//  滑动手势
//声明音效
@property (nonatomic) AVAudioPlayer * soundOfRing;//  上课铃声
@property (nonatomic) AVAudioPlayer * soundOfClassBegin;//  开始上课嘈杂声
@property (nonatomic) AVAudioPlayer * soundOfSleep;//  呼噜
@property (nonatomic) AVAudioPlayer * soundOfSend;//  发射
@property (nonatomic) AVAudioPlayer * soundOfHit;//  击中

@end

@implementation PlayBodyViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_soundOfRing play];
    [UIView animateWithDuration:.5 animations:^{
        _hpLabel.alpha = 1;
        _scoralLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self startTimer];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //手势
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panStart:)];
    [self.view addGestureRecognizer:_panGesture];
    _choosePoint = _choicePosition;                                           //  当前选择位置发射点7 8 9！！！
    _sendPoint = [MacMethod pointAtNumber:_choosePoint place:4];//  当前选择位置发射点
    //  初始化音效
    [self loadSound];
    //  载入模拟场景
    [self loadClassRoom];
    //  载入生命值和分数
    [self loadPointAndHp];
}
//  点击事件  ******有判断过程******
- (void)panStart:(UIPanGestureRecognizer *)gesture {
    if (_didTapped) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _startPoint = [gesture locationInView:self.view];
        if ((_startPoint.x < (_sendPoint.x - 50 * CZYRadioWidth) || (_startPoint.x > (_sendPoint.x + 50 * CZYRadioWidth))) || ((_startPoint.y > _sendPoint.y + 50 * CZYRadioHeight) || (_startPoint.y < _sendPoint.y - 100 * CZYRadioHeight))) {
            _tapInTheRange = 1;
            return;
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        if (_tapInTheRange) {
            _tapInTheRange = 0;
            return;
        }
        _didTapped = 1;
        _endPoint = [gesture locationInView:self.view];
        _endTime = [NSDate date];
        //  反应时间
        NSTimeInterval sendToEndTapTime = [_endTime timeIntervalSinceDate:_sendTime];
        /*
         这里判断1.滑动手势是否在范围内 2.判断反应速度
         */
        //  1.判断范围                                                        //  以出发点为标准发射点计算
        NSArray * results = [MacMethod cosineOfEndPoint:_endPoint fromStartPoint:_sendPoint ofRowPoint:_sendPoint];
        if ([results[_num] isEqual:@1] && sendToEndTapTime < 0.6) {//  击中 0.6f反应时间
            _hitten = 1;
            _label10.bounds = CZYCGRectMake(0, 0, 5, 5);
            [UIView animateWithDuration:([MacMethod pickToGoalNeedTime:_num] - sendToEndTapTime) animations:^{
                _label10.center = [MacMethod pointAtNumber:_num place:2];
            } completion:^(BOOL finished) {
                _label10.bounds = CZYCGRectMake(0, 0, 0, 0);
                _label10.center = _sendPoint;
                _didTapped = 0;
            }];
        } else {//  未击中
            _hitten = 0;
            _label10.bounds = CZYCGRectMake(0, 0, 5, 5);
            CGPoint goalPoint = [MacMethod goalPointByPointA:_sendPoint pointB:_endPoint];
            [UIView animateWithDuration:0.6 animations:^{
                _label10.center = goalPoint;
            } completion:^(BOOL finished) {
                _label10.bounds = CZYCGRectMake(0, 0, 0, 0);
                _label10.center = _sendPoint;
                _didTapped = 0;
            }];
        }
    }
}
//  随机扔出粉笔 ******有判断过程******
- (void)sendForRandom {
    _hitEffect.bounds = CZYCGRectMake(0, 0, 0, 0);
    _cool.bounds = CZYCGRectMake(0, 0, 0, 0);
    _cry.bounds = CZYCGRectMake(0, 0, 0, 0);
    _angry.bounds = CZYCGRectMake(0, 0, 0, 0);
    _angryFire.bounds = CZYCGRectMake(0, 0, 0, 0);
    _num = 0;
    _hitten = 0;//  粉笔发射时，把击中标志至0
    
    while (_num == _choosePoint || !_num) {
        _num = (arc4random() % 9) + 1;
    }
    NSTimeInterval time = [MacMethod pickToGoalNeedTime:_num];
    _label11.bounds = CZYCGRectMake(0, 0, 5, 5);
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _label11.center = [MacMethod pointAtNumber:_num place:2];
    } completion:^(BOOL finished) {
        //  粉笔轨迹结束时计算得分
        _label11.center = CZYCGPointMake(130, 90);
        _label11.bounds = CZYCGRectMake(0, 0, 0, 0);
        if ((_hitten && _num != _sleepStuPoint) || (!_hitten && _num == _sleepStuPoint)) {
            _hitEffect.center = [MacMethod pointAtNumber:_num place:2];
            _hitEffect.bounds = CZYCGRectMake(0, 0, 30, 30);
            _cool.bounds = CZYCGRectMake(0, 0, 30, 30);
            _scoral ++;
            [_soundOfHit play];
            _scoralLabel.text = [NSString stringWithFormat:@"score:%ld",_scoral];
        } else if (_hitten && _num == _sleepStuPoint) {
            _angry.bounds = CZYCGRectMake(0, 0, 30, 30);
            _angryFire.bounds = CZYCGRectMake(0, 0, 30, 30);
            _scoral --;
            [_soundOfClassBegin play];
            _scoralLabel.text = [NSString stringWithFormat:@"score:%ld",_scoral];
        } else {
            _cry.bounds = CZYCGRectMake(0, 0, 30, 30);
            _cry.center = [MacMethod pointAtNumber:_num place:2];
            _hp --;
            [_soundOfClassBegin play];
            _hpLabel.text = [NSString stringWithFormat:@"hp:%ld",_hp];
        }
        if (_hp == 0) {
            [self endTimer];
            [self gameOverAnime];
        }
    }];
}
//  自动扔粉笔
- (void)autoSend {
    [_soundOfSend play];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _sendTime = [NSDate date];
    });
    [self sendForRandom];
}
//  随机出现睡觉学生
- (void)appearSleepStudent {
    [_soundOfSleep play];
    _sleepStuPoint = 0;
    while (_sleepStuPoint == _choosePoint || !_sleepStuPoint) {
        _sleepStuPoint = (arc4random() % 9) + 1;
    }
    _sleepStudent.center = [MacMethod pointAtNumber:_sleepStuPoint place:2];
}
//  载入生命值和分数
- (void)loadPointAndHp {
    _hp = 6;
    _scoral = 0;
    _hpLabel = [[UILabel alloc] initWithFrame:CZYCGRectMake(30, 140, 50, 50)];
    _hpLabel.textAlignment = NSTextAlignmentLeft;
    _hpLabel.alpha = 0;
    _hpLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:22];
    _hpLabel.text = [NSString stringWithFormat:@"hp:%ld",_hp];
    [self.view addSubview:_hpLabel];
    _scoralLabel = [[UILabel alloc] initWithFrame:CZYCGRectMake(160, 140, 120, 50)];
    _scoralLabel.textAlignment = NSTextAlignmentRight;
    _scoralLabel.alpha = 0;
    _scoralLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:22];
    _scoralLabel.text = [NSString stringWithFormat:@"score:%ld",_scoral];
    [self.view addSubview:_scoralLabel];
}
//  载入音效
- (void)loadSound{
    //初始化音效
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"打呼噜" withExtension:@"mp3"];
    _soundOfSleep = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    _soundOfSleep.volume = 3;
    [_soundOfSleep prepareToPlay];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"惊讶声" withExtension:@"mp3"];
    _soundOfClassBegin = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    _soundOfClassBegin.volume = 1;
    [_soundOfClassBegin prepareToPlay];
    NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"上课铃声" withExtension:@"mp3"];
    _soundOfRing = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
    _soundOfRing.volume = 1;
    [_soundOfRing prepareToPlay];
    NSURL *url4 = [[NSBundle mainBundle] URLForResource:@"嗖嗖嗖" withExtension:@"mp3"];
    _soundOfSend = [[AVAudioPlayer alloc] initWithContentsOfURL:url4 error:nil];
    _soundOfSend.volume = 1;
    [_soundOfSend prepareToPlay];
    NSURL *url5 = [[NSBundle mainBundle] URLForResource:@"啪" withExtension:@"mp3"];
    _soundOfHit = [[AVAudioPlayer alloc] initWithContentsOfURL:url5 error:nil];
    _soundOfHit.volume = 1;
    [_soundOfHit prepareToPlay];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
//  载入场景
- (void)loadClassRoom {
    //模糊渐变动画层
    _bgAnime = [[UIImageView alloc] initWithFrame:self.view.frame];
    _animeArr = [NSMutableArray array];
    for (float i = 0.5; i <= 5; i = i + 0.5) {
        [_animeArr addObject:[UIImage fuzzyImage:[UIImage imageNamed:@"bg"] byRadius:i]];
    }
    _bgAnime.animationImages = _animeArr;
    _bgAnime.animationDuration = 0.3;
    //beijing
    _bgPic = [[UIImageView alloc] initWithFrame:self.view.frame];
    _bgPic.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:_bgPic];
    //  哭
    _cry = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cry"]];
    _cry.bounds = CZYCGRectMake(0, 0, 0, 0);
    [self.view addSubview:_cry];
    //  酷
    _cool = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cool"]];
    _cool.center = [MacMethod pointAtNumber:_choosePoint place:2];
    _cool.bounds = CZYCGRectMake(0, 0, 0, 0);
    [self.view addSubview:_cool];
    //  老师生气表情 位置不变
    _angry = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"angry"]];
    _angry.center = CZYCGPointMake(160, 80);
    _angry.bounds = CZYCGRectMake(0, 0, 0, 0);
    [self.view addSubview:_angry];
    _angryFire = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fire"]];
    _angryFire.center = CZYCGPointMake(160, 50);
    _angryFire.bounds = CZYCGRectMake(0, 0, 0, 0);
    [self.view addSubview:_angryFire];
    //  玩家发射位置
    _label10 = [[UILabel alloc] init];
    _label10.bounds = CZYCGRectMake(0, 0, 0, 0);
    _label10.center = _sendPoint;
    _label10.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_label10];
    //  发射位置
    _label11 = [[UILabel alloc] init];
    _label11.bounds = CZYCGRectMake(0, 0, 0, 0);
    _label11.center = CZYCGPointMake(130, 90);
    _label11.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_label11];
    //  击中效果
    _hitEffect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boom"]];
    _hitEffect.bounds = CZYCGRectMake(0, 0, 0, 0);
    [self.view addSubview:_hitEffect];
    //  睡觉学生显示
    //1.把图片放入数组
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 3; index ++) {
        NSString *string = [[NSString alloc] initWithFormat:@"zZ%ld",index];
        images[index] = [UIImage imageNamed:string];
    }
    _sleepStudent = [[UIImageView alloc] init];
    _sleepStudent.animationImages = images;
    _sleepStudent.animationDuration = 1;
    _sleepStudent.bounds = CZYCGRectMake(0, 0, 25, 25);
    [self.view addSubview:_sleepStudent];
    [_sleepStudent startAnimating];
}
//  开启定时
- (void) startTimer {
    if (!_timerForSend) {
        _timerForSend = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(autoSend) userInfo:nil repeats:YES];
    }
    if (!_timerForSleep) {
        _timerForSleep = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(appearSleepStudent) userInfo:nil repeats:YES];
    }
}
//  结束定时
- (void) endTimer {
    [_sleepStudent stopAnimating];
    _hitEffect.bounds = CZYCGRectMake(0, 0, 0, 0);
    _cool.bounds = CZYCGRectMake(0, 0, 0, 0);
    _cry.bounds = CZYCGRectMake(0, 0, 0, 0);
    _angry.bounds = CZYCGRectMake(0, 0, 0, 0);
    _angryFire.bounds = CZYCGRectMake(0, 0, 0, 0);
    _num = 0;
    _hitten = 0;//  粉笔发射时，把击中标志至0
    [self.view removeGestureRecognizer:_panGesture];
    [_timerForSend invalidate];
    _timerForSend = nil;
    [_timerForSleep invalidate];
    _timerForSleep = nil;
}
//gamevoer动画
- (void)gameOverAnime {
    [UIView animateWithDuration:.5 animations:^{
        _hpLabel.alpha = 0;
        _scoralLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view addSubview:_bgAnime];
        _bgPic.image = _animeArr[9];
        [_bgAnime startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_bgAnime removeFromSuperview];
            //延时切换根视图去跳屏bug
            [self performSelector:@selector(changeRootViewCToGameOverVC) withObject:self afterDelay:0];
        });
    }];
}
//延时切换根视图去跳屏bug
- (void) changeRootViewCToGameOverVC {
    GameOverViewController * gameOverVC = [[GameOverViewController alloc] init];
    gameOverVC.scroal = _scoral;
    [[AppDelegate shareInstance].window setRootViewController:gameOverVC];
}
@end