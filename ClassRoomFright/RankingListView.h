//
//  RankingListView.h
//  ClassRoomFright
//
//  Created by rimi on 16/3/21.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  RankingListViewDelegate <NSObject>
//点击maskView时调用
- (void)didTappedMaskView:(UITapGestureRecognizer *)gesture;

@end

@interface RankingListView : UIView

@property (nonatomic, strong) id<RankingListViewDelegate> delegate;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UIView * rankingListWorld;//  右
@property (nonatomic, strong) UIImageView * worldListBg;
@property (nonatomic, strong) UIView * rankingListLocal;//  左
@property (nonatomic, strong) UIImageView * localListBg;

- (void)changeViewsWithSelfView;

@end
