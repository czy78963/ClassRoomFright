//
//  RankingListView.m
//  ClassRoomFright
//
//  Created by rimi on 16/3/21.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//   

#import "RankingListView.h"
#import "FitOfScreen.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RangingListCell.h"

@interface RankingListView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIButton * localRangBtn;//  切换到本地排名视图
@property (nonatomic, strong) UIButton * worldRangBtn;//  切换到世界排名视图
@property (nonatomic, strong) UITableView * rangingListTableView;
@property (nonatomic, strong) NSMutableArray * allScroe;//  所有本地排名
@property (nonatomic, assign) BOOL localOrWorld;//  判断载入哪一个排名

@end

@implementation RankingListView

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
//  加载控件
- (void)initUI {
    self.clipsToBounds = YES;
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0;
    [self addSubview:_maskView];
    _tapGesture = [[UITapGestureRecognizer alloc] init];
    [_tapGesture addTarget:self action:@selector(tapGestureType:)];
    [_maskView addGestureRecognizer:_tapGesture];
    //  右
    _rankingListWorld = [[UIView alloc] init];
    [self addSubview:_rankingListWorld];
    _worldListBg = [[UIImageView alloc] init];
    _worldListBg.image = [UIImage imageNamed:@"排名背景右"];
    [_rankingListWorld addSubview:_worldListBg];
    //  左
    _rankingListLocal = [[UIView alloc] init];
    [self addSubview:_rankingListLocal];
    _localListBg = [[UIImageView alloc] init];
    _localListBg.image = [UIImage imageNamed:@"排名背景左"];
    [_rankingListLocal addSubview:_localListBg];
    //  切换按钮
    _localRangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _localRangBtn.tag = 900;
    [_localRangBtn setImage:[UIImage imageNamed:@"localRangBtn"] forState:UIControlStateNormal];
    [_localRangBtn addTarget:self action:@selector(changeRangingList:) forControlEvents:UIControlEventTouchUpInside];
    [_rankingListLocal addSubview:_localRangBtn];
    _worldRangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _worldRangBtn.tag = 901;
    [_worldRangBtn setImage:[UIImage imageNamed:@"worldRangBtn"] forState:UIControlStateNormal];
    [_worldRangBtn addTarget:self action:@selector(changeRangingList:) forControlEvents:UIControlEventTouchUpInside];
    [_rankingListLocal addSubview:_worldRangBtn];
    //  显示排名的tableView
    _allScroe = [NSMutableArray array];
    _allScroe = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allScore"] mutableCopy];
    _rangingListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _rangingListTableView.rowHeight = 30 * CZYRadioHeight;
    _rangingListTableView.delegate = self;
    _rangingListTableView.dataSource = self;
    _rangingListTableView.showsVerticalScrollIndicator = NO;
    _rangingListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_rankingListLocal addSubview:_rangingListTableView];
    
}
//  tap手势
- (void)tapGestureType:(UITapGestureRecognizer *)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(didTappedMaskView:)]) {
        [_delegate didTappedMaskView:gesture];
    }
}
//  动态改变
- (void)changeViewsWithSelfView {
    _rankingListWorld.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _rankingListWorld.bounds = CGRectMake(0, 0, self.bounds.size.width / 4 * 3, self.bounds.size.height / 4 * 3);
    _worldListBg.frame = CGRectMake(0, 0, self.bounds.size.width / 4 * 3, self.bounds.size.height / 4 * 3);
    _rankingListLocal.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _rankingListLocal.bounds = CGRectMake(0, 0, self.bounds.size.width / 4 * 3, self.bounds.size.height / 4 * 3);
    _localListBg.frame = CGRectMake(0, 0, self.bounds.size.width / 4 * 3, self.bounds.size.height / 4 * 3);
    _localRangBtn.frame = CGRectMake(self.bounds.size.width / 8, self.bounds.size.height / 80, self.bounds.size.width / 5, self.bounds.size.height / 20);
    _worldRangBtn.frame = CGRectMake(self.bounds.size.width / 7 * 3, self.bounds.size.height / 80, self.bounds.size.width / 5, self.bounds.size.height / 20);
    _rangingListTableView.center = CGPointMake(_rankingListWorld.bounds.size.width / 2, _rankingListWorld.bounds.size.height / 2 + 15 * CZYRadioHeight);
    _rangingListTableView.bounds = CGRectMake(0, 0,_rankingListWorld.bounds.size.width / 5 * 4, _rankingListWorld.bounds.size.height / 5 * 4);
}
//  改变排名表
- (void)changeRangingList:(UIButton *)sender {
    if (sender.tag - 900 == 0) {
        [_rangingListTableView removeFromSuperview];
        [_localRangBtn removeFromSuperview];
        [_worldRangBtn removeFromSuperview];
        [self bringSubviewToFront:_rankingListLocal];
        [_rankingListLocal addSubview:_localRangBtn];
        [_rankingListLocal addSubview:_worldRangBtn];
        _localOrWorld = 0;
        _allScroe = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allScore"] mutableCopy];
        [_rangingListTableView reloadData];
        [_rankingListLocal addSubview:_rangingListTableView];
    } else {
        [_rangingListTableView removeFromSuperview];
        [_localRangBtn removeFromSuperview];
        [_worldRangBtn removeFromSuperview];
        [self bringSubviewToFront:_rankingListWorld];
        [_rankingListWorld addSubview:_localRangBtn];
        [_rankingListWorld addSubview:_worldRangBtn];
        _localOrWorld = 1;
        AVQuery *query = [AVQuery queryWithClassName:@"RangingList"];
        AVObject *post = [query getObjectWithId:@"56f26cdea3413100543cc4b6"];
        NSMutableDictionary * firstDic = [[post objectForKey:@"RangingList"] mutableCopy];
        _allScroe = [firstDic[@"allScore"] mutableCopy];
        [_rangingListTableView reloadData];
        [_rankingListWorld addSubview:_rangingListTableView];
    }
}
#pragma mark -- <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allScroe.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * identifier = [NSString string];
    if (!_localOrWorld) {
        identifier = @"rangingListLocal";
    } else {
        identifier = @"rangingListWorld";
    }
    RangingListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) cell = [[RangingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor whiteColor];
    cell.nameLabel.frame = CGRectMake(0, 0, tableView.frame.size.width / 5 * 2, 30 * CZYRadioHeight);
    cell.nameLabel.text = _allScroe[indexPath.row][@"name"];
    cell.scoreLabel.frame = CGRectMake(tableView.frame.size.width / 5 * 2 + 5, 0, tableView.frame.size.width / 5 * 2, 30 * CZYRadioHeight);
    cell.scoreLabel.text = [NSString stringWithFormat:@"%@", _allScroe[indexPath.row][@"score"]];
    if (!_localOrWorld) {
        cell.loadUpBtn.frame = CGRectMake(tableView.frame.size.width / 5 * 4, 2 * CZYRadioHeight, tableView.frame.size.width / 5, 26 * CZYRadioHeight);
        cell.loadUpBtn.tag = 300 + indexPath.row;
        [cell.loadUpBtn addTarget:self action:@selector(loadUpScore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 1.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView * view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"rangLogo"];
    view.backgroundColor =[UIColor whiteColor];
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
}
//  上传分数按钮
- (void)loadUpScore:(UIButton *)sender {
    NSDictionary * dic = _allScroe[sender.tag - 300];
    NSInteger scroeNow = [dic[@"score"] integerValue];
    AVQuery *query = [AVQuery queryWithClassName:@"RangingList"];
    AVObject *post = [query getObjectWithId:@"56f26cdea3413100543cc4b6"];
    NSMutableDictionary * firstDic = [[post objectForKey:@"RangingList"] mutableCopy];
    NSMutableArray * arr = [firstDic[@"allScore"] mutableCopy];
    if (arr.count == 0) {
        [arr addObject:dic];
    } else {
        for (int i = 0; i < arr.count; ++ i) {
            NSInteger scroe = [arr[i][@"score"] integerValue];
            if (scroeNow == scroe && [dic[@"name"] isEqualToString:arr[i][@"name"]]) {
                break;
            }
            if (scroeNow >= scroe && ![dic[@"name"] isEqualToString:arr[i][@"name"]]) {
                [arr insertObject:dic atIndex:i];
                break;
            } else if ((i == arr.count - 1) && ![dic[@"name"] isEqualToString:arr[i][@"name"]]) {
                [arr addObject:dic];
                break;
            }
        }
        if (arr.count > 20) {
            for (int i = 0; i < arr.count - 20; ++ i) {
                [arr removeLastObject];
            }
        }
    }
    [firstDic setObject:arr forKey:@"allScore"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [post setObject:firstDic forKey:@"RangingList"];
        [post saveInBackground];
    }];
    [sender setUserInteractionEnabled:NO];
    [sender setTitle:@"成功" forState:UIControlStateNormal];
    [sender setTintColor:[UIColor lightGrayColor]];
}


@end
