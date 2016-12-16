//
//  RSSHeader.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/18.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "RSSHeader.h"
#import "XmlModel.h"

@interface RSSHeader (){
    
    UILabel *titleLabel;
    
    UILabel *authorName;
    
    UILabel *pushDate;
    
    UIImageView *iconView;
}

//@property (nonatomic, strong) UILabel *titleLabel;
//
//@property (nonatomic, strong) UILabel *authorName;
//
//@property (nonatomic, strong) UILabel *pushDate;
//
//@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation RSSHeader

+ (instancetype)cellWithTableView:(UITableView *)tableview{
    
    static NSString *Identifier = @"RSSHeader";
    RSSHeader *cell = [tableview dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell = [[RSSHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat spacing = 10.0f;

        self.backgroundColor = [UIColor grayColor];
        
        titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        titleLabel.numberOfLines = 2;
        titleLabel.font= [UIFont systemFontOfSize:22];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing,spacing,0,0));
            make.width.equalTo(@(ZHAppWidth - spacing * 2));
            make.height.equalTo(@50);
            //            self.cB = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(spacing);
            make.top.equalTo(titleLabel).offset(spacing);
            make.height.equalTo(@40);
            //            self.cY = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        authorName = [[UILabel alloc] init];
        authorName.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:authorName];
        [authorName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(titleLabel.mas_bottom).offset(spacing);
            make.left.equalTo(iconView.mas_right).offset(spacing);
            make.height.equalTo(@25).priorityLow();
        }];
        
        pushDate = [[UILabel alloc] init];
        pushDate.textColor = [UIColor grayColor];
        pushDate.numberOfLines = 1;
        [self.contentView addSubview:pushDate];
        [pushDate mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(titleLabel.mas_bottom).offset(spacing);
            make.left.equalTo(authorName).offset(spacing);
            make.height.equalTo(@25).priorityLow();
            //            self.cR = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
    }
    return self;
}

- (void)configureCellWith:(FeedModel *)model{
    
    titleLabel.text = model.title;
    authorName.text = model.authorName;
    [iconView setImage:[UIImage imageNamed:@"zhanwei.jpeg"]];
    pushDate.text   = model.updatedDate;
}

@end
