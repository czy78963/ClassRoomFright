//
//  GameOverViewController.m
//  ClassRoomFright
//
//  Created by rimi on 16/3/18.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "GameOverViewController.h"
#import "UIImage+ImageManage.h"
#import "StartGameViewController.h"
#import "AppDelegate.h"
#import "FitOfScreen.h"

@interface GameOverViewController ()

@property (nonatomic, strong) UIImageView * bgPic;//  背景图片
@property (nonatomic, strong) UIButton * backToHomeBtn;//  返回按钮
@property (nonatomic, strong) UILabel * gamerLogo;//  gameover
@property (nonatomic, strong) UILabel * scroalLabel;//  得分
@property (nonatomic, strong) UITextField * userName;//  输入姓名文本框
@property (nonatomic, strong) UIImageView * userNameBg;//  输入框背景
@property (nonatomic, strong) UIButton * shareBtn;//  分享按钮
@property (nonatomic, strong) UIButton * saveBtn;//  保存分数到本地按钮
@property (nonatomic, strong) UILabel * tips;//  保存成功提示
@property (nonatomic, assign) BOOL saved;//  保存成功置1

@end

@implementation GameOverViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self loadViewLayers];
}
//
- (void)loadViewLayers {
    _saved = 0;
    //  背景
    _bgPic = [[UIImageView alloc] initWithFrame:self.view.frame];
    _bgPic.image = [UIImage fuzzyImage:[UIImage imageNamed:@"bg"] byRadius:5];
    [self.view addSubview:_bgPic];
    //  gameover
    _gamerLogo = [[UILabel alloc] init];
    _gamerLogo.center = CZYCGPointMake(160, 140);
    _gamerLogo.bounds = CZYCGRectMake(0, 0, 200, 40);
    _gamerLogo.text = @"Game Over";
    _gamerLogo.textAlignment = NSTextAlignmentCenter;
    _gamerLogo.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:40];
    [self.view addSubview:_gamerLogo];
    //  得分
    _scroalLabel = [[UILabel alloc] init];
    _scroalLabel.center = CZYCGPointMake(160, 200);
    _scroalLabel.bounds = CZYCGRectMake(0, 0, 120, 50);
    _scroalLabel.text = [NSString stringWithFormat:@"scroe:  %ld",_scroal];
    _scroalLabel.textAlignment = NSTextAlignmentCenter;
    _scroalLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:22];
    [self.view addSubview:_scroalLabel];
    //  返回按钮
    _backToHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backToHomeBtn.center = CZYCGPointMake(160, 480);
    _backToHomeBtn.bounds = CZYCGRectMake(0, 0, 30, 30);
    [_backToHomeBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_backToHomeBtn addTarget:self action:@selector(backToHomeType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backToHomeBtn];
    //  输入框背景
    _userNameBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userName"]];
    _userNameBg.center = CZYCGPointMake(160, 250);
    _userNameBg.bounds = CZYCGRectMake(0, 0, 120, 40);
    [self.view addSubview:_userNameBg];
    //  输入姓名文本框
    _userName = [[UITextField alloc] init];
    _userName.center = CZYCGPointMake(165, 250);
    _userName.bounds = CZYCGRectMake(0, 0, 100, 30);
    _userName.clearButtonMode = YES;
    _userName.tintColor = [UIColor blackColor];
    _userName.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:20];
    _userName.placeholder = @"name";
    [self.view addSubview:_userName];
    //  分享按钮
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.center = CZYCGPointMake(100, 310);
    _shareBtn.bounds = CZYCGRectMake(0, 0, 40, 20);
    [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [self.view addSubview:_shareBtn];
    //  保存分数按钮
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.center = CZYCGPointMake(220, 310);
    _saveBtn.bounds = CZYCGRectMake(0, 0, 40, 20);
    [_saveBtn addTarget:self action:@selector(saveScroeToLocat:) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn setImage:[UIImage imageNamed:@"saveBtn"] forState:UIControlStateNormal];
    [self.view addSubview:_saveBtn];
    //  保存成功提示
    _tips= [[UILabel alloc] init];
    _tips.center = CZYCGPointMake(160, 380);
    _tips.bounds = CZYCGRectMake(0, 0, 100, 40);
    _tips.text = @"分数保存成功";
    _tips.textColor = [UIColor blackColor];
    _tips.font = [UIFont systemFontOfSize:15];
    _tips.layer.cornerRadius = 5;
    _tips.backgroundColor = [UIColor whiteColor];
    _tips.alpha = 0;
    [self.view addSubview:_tips];
}
//  返回
- (void)backToHomeType:(UIButton *)sender {
    StartGameViewController * startGameVC = [[StartGameViewController alloc] init];
    [UIView animateWithDuration:0.3 animations:^{
        _backToHomeBtn.center = CZYCGPointMake(160, 588);
        _scroalLabel.center = CZYCGPointMake(160, 150);
        _scroalLabel.alpha = 0;
        _gamerLogo.center = CZYCGPointMake(160, 100);
        _gamerLogo.alpha = 0;
        _userNameBg.alpha = 0;
        _userName.alpha = 0;
        _userNameBg.center = CZYCGPointMake(160, 200);
        _userName.center = CZYCGPointMake(170, 200);
        _shareBtn.alpha = 0;
        _saveBtn.alpha = 0;
        _shareBtn.center = CZYCGPointMake(100, 270);
        _saveBtn.center = CZYCGPointMake(220, 270);
    } completion:^(BOOL finished) {
        [[AppDelegate shareInstance].window setRootViewController:startGameVC];
    }];
}
//  保存分数
- (void)saveScroeToLocat:(UIButton *)sender {
    NSDictionary * myScore = @{@"name":([_userName.text isEqualToString:@""] ? @"NoName" : _userName.text), @"score":@(_scroal)};
    NSMutableArray * allScroe = [NSMutableArray array];
    if (!_saved) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"allScore"]) {
            [allScroe addObject:myScore];
            [[NSUserDefaults standardUserDefaults] setObject:allScroe forKey:@"allScore"];
        } else {
            allScroe = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allScore"] mutableCopy];
            for (int i = 0; i < allScroe.count; ++ i) {
                NSInteger scroe = [allScroe[i][@"score"] integerValue];
                if (_scroal >= scroe) {
                    [allScroe insertObject:myScore atIndex:i];
                    break;
                } else if (i == allScroe.count - 1) {
                    [allScroe addObject:myScore];
                    break;
                }
            }
            if (allScroe.count > 10) {
                for (int i = 0 ; i < allScroe.count - 10; ++ i) {
                    [allScroe removeLastObject];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:allScroe forKey:@"allScore"];
        }
        _saved = 1;
    }
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"allScore"]);
    [UIView animateWithDuration:0 animations:^{
        _tips.alpha = 1;
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.5 animations:^{
           _tips.alpha = 0;
       }];
    }];
}
//  回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_userName resignFirstResponder];
}
@end
