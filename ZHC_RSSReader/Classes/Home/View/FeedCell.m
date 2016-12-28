//
//  FeedCell.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/12/12.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "FeedCell.h"
#import "XmlModel.h"

static NSString *Identifier = @"FeedCell";

@interface FeedCell ()

@property (nonatomic, strong) UIImageView *iconImgview;

@property (nonatomic, strong) UIImageView *coverImgview;

@property (nonatomic, strong) UILabel *authorName;

@property (nonatomic, strong) UILabel *feedName;

@property (nonatomic, strong) UILabel *articleTitle;

@property (nonatomic, strong) UILabel *articleDetail;

@property (nonatomic, strong) UIView *likeview;

@property (nonatomic, strong) UIView *commentview;

@end


@implementation FeedCell

+ (instancetype)cellWithTableView:(UITableView *)tableview{
    
    FeedCell *cell = [tableview dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat spacing = 5.0f;
        
        _iconImgview = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgview];
        [_iconImgview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing,spacing,0,0));
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            //            self.cB = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        _authorName = [[UILabel alloc] init];
        _authorName.font = [UIFont systemFontOfSize:12];
        _authorName.textColor = [UIColor blueColor];
        [self.contentView addSubview:_authorName];
        [_authorName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_iconImgview.mas_right).offset(spacing);
            make.top.equalTo(self.contentView).offset(spacing);
            make.height.equalTo(@25).priorityLow();
            //            self.cY = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        _feedName = [[UILabel alloc] init];
        _feedName.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_feedName];
        [_feedName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_authorName.mas_bottom).offset(2);
            make.left.equalTo(_iconImgview.mas_right).offset(spacing);
            make.height.equalTo(@20).priorityLow();
        }];
        
        _articleTitle = [[UILabel alloc] init];
        _articleTitle.font = [UIFont systemFontOfSize:18];
        _articleTitle.numberOfLines = 2;
        [self.contentView addSubview:_articleTitle];
        [_articleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_iconImgview.mas_bottom).offset(spacing);
            make.left.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing,spacing,0,spacing));
            make.height.equalTo(@25).priorityLow();
            //            self.cR = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        _articleDetail = [[UILabel alloc] init];
        _articleDetail.numberOfLines = 3;
        _articleDetail.textColor = [UIColor grayColor];
        _articleDetail.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_articleDetail];
        [_articleDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_articleTitle.mas_bottom).offset(spacing);
            make.left.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing, spacing, 0, spacing));
            make.height.equalTo(@35).priorityLow();
        }];
        
        _likeview = [[UIView alloc] init];
        [self.contentView addSubview:_likeview];
        [_likeview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_articleDetail.mas_bottom).offset(spacing);
            make.left.equalTo(self.contentView).offset(spacing);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.width.equalTo(@25);
            make.height.equalTo(@25).priorityLow();
        }];
        
        _commentview = [[UIView alloc] init];
        [self.contentView addSubview:_commentview];
        [_commentview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_articleDetail.mas_bottom).offset(spacing);
            make.left.equalTo(_likeview.mas_right).offset(spacing);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.width.equalTo(@25);
            make.height.equalTo(@25).priorityLow();
        }];

    }
    return self;
}

- (void)config:(FeedModel *)model{
    
    [self.iconImgview setImage:[UIImage imageNamed:@"zhanwei.jpeg"]];
    
    self.authorName.text = model.authorName;
    self.articleTitle.text = model.title;
    self.feedName.text = model.feedName;
    self.articleDetail.text = model.summary;
    
    
    //self.cellHeight = 5 + 40 + 5 + self.articleTitle.font.lineHeight * 2 + 5 + self.articleDetail.font.lineHeight * 3 + 5 + 25;
    self.likeview.backgroundColor = [UIColor greenColor];
    self.commentview.backgroundColor = [UIColor redColor];
}

-(void)setFrame:(CGRect)frame{
    
    //frame.origin.x = 5;//这里间距为10，可以根据自己的情况调整
    //frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * 5;
    [super setFrame:frame];
}


- (CGFloat )CalculationLabelHight:(UILabel*) label{

    CGSize labelSize = [self ZFYtextHeightFromTextString:label.text width:ZHAppWidth fontSize:label.font.pointSize];
    CGFloat rate = label.font.lineHeight; //每一行需要的高度
    CGRect frame= label.frame;
    if (labelSize.height >= rate * label.numberOfLines) {
        frame.size.height = rate * label.numberOfLines;
    }else{
        frame.size.height = labelSize.height;
    }
    return frame.size.height;
    //label.frame = frame;
}


//计算 label需要的宽度和高度方法
-(CGSize)ZFYtextHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    
    //计算 label需要的宽度和高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
}

@end
