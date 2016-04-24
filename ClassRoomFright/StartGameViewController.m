//
//  StartGameViewController.m
//  ClassRoomFright
//
//  Created by rimi on 16/3/17.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "StartGameViewController.h"
#import "AppDelegate.h"
#import "FitOfScreen.h"
#import "UIImage+ImageManage.h"
#import "PlayBodyViewController.h"
#import "RankingListView.h"//  自定义view

@interface StartGameViewController  () <RankingListViewDelegate>

@property (nonatomic, strong) UIImageView * bgPic;//  背景图片
@property (nonatomic, strong) UIImageView * bgAnime;//  背景模糊渐变动画
@property (nonatomic, strong) UIImageView * logo;//  载入logo
@property (nonatomic, strong) UIButton * startGameBtn;//  开始游戏按钮
@property (nonatomic, strong) UIButton * shareBtn;//  分享游戏按钮
@property (nonatomic, strong) UIButton * checkRangeBtn;//  查看排名按钮
@property (nonatomic, strong) UIView * choosePostion;//  选择位置
@property (nonatomic, strong) NSMutableArray * animeArr;//  模糊动画数组
@property (nonatomic, strong) RankingListView * rankingListView;//  排名
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIImageView * tips;

@end

@implementation StartGameViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadViewLayers];
    [self firstLoadThisViewAnime];
}
//  载入视图
- (void)loadViewLayers {
    //  beijing
    _bgPic = [[UIImageView alloc] initWithFrame:self.view.frame];
    _bgPic.image = [UIImage imageNamed:@"bg"];
    //  模糊渐变动画层
    _bgAnime = [[UIImageView alloc] initWithFrame:self.view.frame];
    _animeArr = [NSMutableArray array];
    for (float i = 5; i >= 0; i = i - 0.5) {
        [_animeArr addObject:[UIImage fuzzyImage:[UIImage imageNamed:@"bg"] byRadius:i]];
    }
    _bgAnime.image = [UIImage fuzzyImage:[UIImage imageNamed:@"bg"] byRadius:5];
    _bgAnime.animationImages = _animeArr;
    _bgAnime.animationDuration = 0.3;
    [self.view addSubview:_bgAnime];
    //  logo
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    _logo.alpha = 0;
    _logo.center = CZYCGPointMake(160, 200);
    _logo.bounds = CZYCGRectMake(0, 0, 200, 160);
    [self.view addSubview:_logo];
    //  开始游戏按钮
    _startGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startGameBtn setImage:[UIImage imageNamed:@"开始游戏"] forState:UIControlStateNormal];
    [_startGameBtn addTarget:self action:@selector(beginGame:) forControlEvents:UIControlEventTouchUpInside];
    _startGameBtn.center = CZYCGPointMake(380, 320);
    _startGameBtn.bounds = CZYCGRectMake(0, 0, 120, 30);
    [self.view addSubview:_startGameBtn];
    //  帮助按钮
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"帮助"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(helpView:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.center = CZYCGPointMake(25, 578);
    _shareBtn.bounds = CZYCGRectMake(0, 0, 40, 20);
    [self.view addSubview:_shareBtn];
    //  排名按钮
    _checkRangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkRangeBtn setImage:[UIImage imageNamed:@"排名"] forState:UIControlStateNormal];
    _checkRangeBtn.center = CZYCGPointMake(320 - 25, 578);
    _checkRangeBtn.bounds = CZYCGRectMake(0, 0, 40, 20);
    [_checkRangeBtn addTarget:self action:@selector(cheakRange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkRangeBtn];
    //  排名
    _rankingListView = [[RankingListView alloc] init];
    _rankingListView.center = CZYCGPointMake(160, 284);
    _rankingListView.bounds = CZYCGRectMake(0, 0, 0, 0);
    _rankingListView.alpha = 0;
    _rankingListView.delegate = self;
    [self.view addSubview:_rankingListView];
}
//  载入动画
- (void)firstLoadThisViewAnime {
    [UIView animateWithDuration:0.5 animations:^{
        _logo.alpha = 1;
       _logo.center = CZYCGPointMake(160, 120);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             _startGameBtn.center = CZYCGPointMake(160, 320);
                             _checkRangeBtn.center = CZYCGPointMake(320 - 25, 550);
                             _shareBtn.center = CZYCGPointMake(25, 550);
                         }
                         completion:nil];
    }];
}
//  开始游戏动画动画
- (void)gameStartAnime {
    [UIView animateWithDuration:0.2 animations:^{
        _logo.center = CZYCGPointMake(160, - 80);
        _startGameBtn.center = CZYCGPointMake(- 60, 320);
        _checkRangeBtn.center = CZYCGPointMake(320 - 25, 578);
        _shareBtn.center = CZYCGPointMake(25, 578);
    } completion:^(BOOL finished) {
        [_bgAnime startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view addSubview:_bgPic];
            [_bgAnime removeFromSuperview];
            [self.view addSubview:_choosePostion];
            [UIView animateWithDuration:0.3 animations:^{
                _choosePostion.alpha = 1;
            }];
        });
    }];
}
//开始游戏按钮
- (void)beginGame:(UIButton *)sender {
    //选择位置提示图层初始化
    _choosePostion = [[UIView alloc] initWithFrame:CZYCGRectMake(0, 0, 320, 568)];
    _choosePostion.alpha = 0;
      //半透明蒙版
    UILabel * maskLabel = [[UILabel alloc] initWithFrame:CZYCGRectMake(0, 0, 320, 440)];
    maskLabel.backgroundColor = [UIColor blackColor];
    maskLabel.alpha = 0.5;
    [_choosePostion addSubview:maskLabel];
      //提示语：选择位置
    UIImageView * tipsForChoosePosiTion = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选择位置"]];
    tipsForChoosePosiTion.center = CZYCGPointMake(160, 275);
    tipsForChoosePosiTion.bounds = CZYCGRectMake(0, 0, 100, 25);
    [_choosePostion addSubview:tipsForChoosePosiTion];
      //选择位置按钮
    for (int i = 0; i < 3; ++ i) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CZYCGRectMake(i * 320 / 3 + (i == 0 ? 0 : 1), 439, 320 / 3, 129);
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(choosePostionBtnType:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200 + i;
        [_choosePostion addSubview:btn];
    }
    //播放动画
    [self gameStartAnime];
}
//选择位置按钮
- (void) choosePostionBtnType:(UIButton *)sender {
    PlayBodyViewController * playbodyVC = [[PlayBodyViewController alloc] init];
    playbodyVC.choicePosition = sender.tag - 200 + 7;
    [UIView animateWithDuration:0.3 animations:^{
        _choosePostion.alpha = 0;
    } completion:^(BOOL finished) {
        [[AppDelegate shareInstance].window setRootViewController:playbodyVC];
    }];
}
//  查看排名按钮
- (void) cheakRange:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _rankingListView.bounds = CZYCGRectMake(0, 0, 320, 568);
        _rankingListView.alpha = 1;
        [_rankingListView changeViewsWithSelfView];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _rankingListView.maskView.alpha = 0.5;
        }];
    }];
}
//  bangzhuanniu
- (void)helpView:(UIButton *)sender {
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0;
    [self.view addSubview:_maskView];
    _tips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tips"]];
    _tips.center = self.view.center;
    _tips.alpha = 0;
    _tips.layer.cornerRadius = 5;
    _tips.layer.borderWidth = 2;
    _tips.clipsToBounds = YES;
    _tips.bounds = CGRectMake(0, 0, CZYCurrentScreenWidth / 5 * 4, CZYCurrentScreenHeight / 4 * 3);
    [self.view addSubview:_tips];
    _tapGesture = [[UITapGestureRecognizer alloc] init];
    [_tapGesture addTarget:self action:@selector(tapGestureType:)];
    [_maskView addGestureRecognizer:_tapGesture];
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0.5;
        _tips.alpha = 1;
    }];
}
//  tap手势
- (void)tapGestureType:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0;
        _tips.alpha = 0;
    } completion:^(BOOL finished) {
        [_maskView removeGestureRecognizer:_tapGesture];
        [_tips removeFromSuperview];
        [_maskView removeFromSuperview];
    }];
}
#pragma mark -- RankingListViewDelegate
- (void)didTappedMaskView:(UITapGestureRecognizer *)gesture {
    _rankingListView.maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _rankingListView.bounds = CZYCGRectMake(0, 0, 0, 0);
        _rankingListView.alpha = 0;
        [_rankingListView changeViewsWithSelfView];
    }];
}

@end
