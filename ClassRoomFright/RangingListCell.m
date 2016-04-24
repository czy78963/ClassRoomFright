//
//  RangingListCell.m
//  ClassRoomFright
//
//  Created by rimi on 16/3/24.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "RangingListCell.h"

@implementation RangingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载控件
        [self initInterface];
    }
    return self;
}

- (void)initInterface {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:20];
    [self.contentView addSubview:_nameLabel];
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:20];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_scoreLabel];
    _loadUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _loadUpBtn.layer.cornerRadius = 5;
    _loadUpBtn.layer.borderWidth = 1;
    [_loadUpBtn setTitle:@"上传" forState:UIControlStateNormal];
    [_loadUpBtn setTintColor:[UIColor blackColor]];
    [self.contentView addSubview:_loadUpBtn];
}

@end
