//
//  RssDetailViewController.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/17.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "RssDetailViewController.h"
#import "XmlModel.h"
#import <DTCoreText/DTCoreText.h>
#import "FeedManager.h"

@interface RssDetailViewController ()< DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate, DTHTMLParserDelegate>{// UITableViewDelegate, UITableViewDataSource,
    
    NSCache *cellCache;
    BOOL _useStaticRowHeight;
}

@property (nonatomic, strong) FeedModel *model;

@property (nonatomic, strong) UIView *backButton;

@property (nonatomic, strong) UIButton *followButton;

@property (nonatomic, strong) UIImageView *iconImageView;


@property (nonatomic, strong) DTAttributedTextView *textview;

//@property (nonatomic, strong) UITableView *articleTableView;

@property (nonatomic, strong) NSString *cssString;

@end

//NSString * const AttributedTextCellReuseIdentifier = @"AttributedTextCellReuseIdentifier";

@implementation RssDetailViewController

#pragma mark - init方法
- (instancetype)initWithModel:(FeedModel *)feedModel{
    
    if (self = [super init]) {
        
        self.model = feedModel;
    }
    return self;
}

#pragma mark - 懒加载
- (UIView *)backButton{
    
    if (!_backButton) {
        
        _backButton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        UIBezierPath *path = [UIBezierPath bezierPath];// 创建路径对象
        //CAShapeLayer *backLayer = [CAShapeLayer layer];
        
        [path moveToPoint:CGPointMake(8, 8)];
        [path addLineToPoint:CGPointMake(-3, 20)];
        [path addLineToPoint:CGPointMake(8, 32)];
        
        
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineWidth = 5.0;
        //backLayer.fillColor = nil;
        //backLayer.strokeColor = [UIColor blueColor].CGColor;
        
        //backLayer.path = path.CGPath;
        //[_backButton.layer addSublayer:backLayer];
        UIColor *strokeColor = [UIColor blueColor];
        [strokeColor set];
        [path stroke];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToBack)];
        [tap setNumberOfTouchesRequired:1];
        [_backButton addGestureRecognizer:tap];

    }
    return _backButton;
}

//- (UITableView *)articleTableView{
//    
//    if (!_articleTableView) {
//        _articleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ZHAppWidth, ZHAppHeight) style:UITableViewStyleGrouped];
//    }
//    return _articleTableView;
//}

- (NSString *)cssString{
    
    if (!_cssString) {
        
        _cssString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"entry.txt" ofType:nil] encoding:4 error:nil];
    }
    return _cssString;
}

- (UIButton *)followButton{
    
    if (!_followButton) {
        _followButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    }
    return _followButton;
}

- (DTAttributedTextView *)textview{
    
    if (!_textview) {
        
        _textview = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, 0, ZHAppWidth, ZHAppHeight)];
        _textview.shouldDrawImages = NO;
        _textview.shouldDrawLinks = NO;
        _textview.textDelegate = self;
        [_textview setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
        _textview.contentInset = UIEdgeInsetsMake(10, 10, 54, 10);
        _textview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _textview;
}

#pragma mark - 加载画面
- (void)loadView{
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    // 修改Navigationbar
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.followButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //修复navigationController侧滑关闭失效的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = ZHColor(123, 191, 234);
    
//    self.articleTableView.delegate = self;
//    self.articleTableView.dataSource = self;
//    [self.view addSubview:self.articleTableView];
    
    if ([self.model.feedDescription hasSuffix:@"阅读全文</a>"]) {
        BOOL issuccess = [[FeedManager defaultManager] getAtomDescriptionWith:self.model];
        //issuccess ? [self.articleTableView reloadData] : nil;
    }
    self.textview.attributedString = [self _attributedStringForSnippetUsingiOS6Attributes:NO];
    [self.view addSubview:self.textview];
}


- (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes{
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
    void (^callBackBlock)(DTHTMLElement *elemet) = ^(DTHTMLElement *elemet){
        
        for (DTHTMLElement *oneChildElement in elemet.childNodes) {
            
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize) {
                
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = elemet.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = elemet.textAttachment.displaySize.height;
            }
        }
    };
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0],NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize, @"Times New Roman", DTDefaultFontFamily, @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor,callBackBlock, DTWillFlushBlockCallBack, nil];
    
    if (useiOS6Attributes) {
        [options setObject:[NSNumber numberWithBool:YES] forKey:DTUseiOS6Attributes];
    }
    
    NSArray *arr = [self.model.feedDescription componentsSeparatedByString:@"<div id=\"ifanr_profile"];
    if (arr.count > 1) {
        self.model.feedDescription = (NSString *)arr.firstObject;
    }
    NSString *string = [NSString stringWithFormat:@"<style type=\"text/css\">%@</style>%@", self.cssString, self.model.feedDescription];
    NSAttributedString *attributString = [[NSAttributedString alloc] initWithHTMLData:[string dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL];
    return attributString;
}

- (void)goToBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    _textview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

}

/*
#pragma mark - UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        DTAttributedTextCell *dtCell =  (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        return dtCell;
        
    }else{
        
        static NSString *cellID = @"NormalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        cell.textLabel.text = self.model.authorName;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section == 1)
    {
        DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        
        return [cell requiredRowHeightInTableView:tableView];
    }else{
        
        return 20;
    }
}

- (DTAttributedTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath{
    
    // workaround for iOS 5 bug
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    DTAttributedTextCell *cell = [cellCache objectForKey:key];
 
    if (!cell) {
        
        [self _canReuseCells] ? (cell = (DTAttributedTextCell *)[tableView dequeueReusableCellWithIdentifier:AttributedTextCellReuseIdentifier]) : nil;

        if (!cell) {
            
            cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:AttributedTextCellReuseIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hasFixedRowHeight = _useStaticRowHeight;
        
        [cellCache setObject:cell forKey:key];
    }
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DTAttributedTextCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.attributedTextContextView.shouldDrawLinks = NO;
    cell.attributedTextContextView.shouldDrawImages = NO;
    cell.attributedTextContextView.delegate = self;
    cell.attributedTextContextView.attributedString = [self _attributedStringForSnippetUsingiOS6Attributes:NO];
    cell.attributedTextContextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cell.attributedTextContextView.backgroundColor = ZHColor(239, 239, 244);
}

- (BOOL)_canReuseCells{
    
    // reuse does not work for variable height
    if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return NO;
    }
    // only reuse cells with fixed height
    return YES;
}
*/
 
#pragma mark - DTAttributedTextContentViewDelegate
#pragma mark Custom Views on Text
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame{
    
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    DTLinkButton *button = [[DTLinkButton alloc]initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25);
    button.GUID = identifier;
    
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
    
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]){
        
        DTLazyImageView *imgView = [[DTLazyImageView alloc]initWithFrame:frame];
        imgView.delegate = self;
        
        imgView.image = [(DTImageTextAttachment *)attachment image];
        imgView.url = attachment.contentURL;
        
        if (attachment.hyperLinkURL) {
            
            imgView.userInteractionEnabled = YES;
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imgView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
            // use normal push action for opening URL
            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            // demonstrate combination with long press
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
            [button addGestureRecognizer:longPress];
            
            [imgView addSubview:button];
        }
        return imgView;
        
    }else if([DTObjectTextAttachment class]){
        
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    return nil;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
    CGColorRef color = [textBlock.backgroundColor CGColor];
    if (color)
    {
        CGContextSetFillColorWithColor(context, color);
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);
        return NO;
    }
    
    return YES; // draw standard background
}

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;

    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [_textview.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            [_textview relayoutText];
        });
    }
}


#pragma mark - Other
- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    //如果系统为iOS7.0；
    CGSize labelSize;
    if (![text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        
        labelSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
    }else{
            labelSize = [text boundingRectWithSize: maxSize
                                           options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                        attributes:attributes
                                           context:nil].size;
            
    }
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

- (UIView *)drawleftBarButtonItem{
    
    UIView *authorView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 80, 44)];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [img setImage:[UIImage imageNamed:@"zhanwei.jpeg"]];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 40, 44)];
    lab.text = @"你的名字";
    
    [authorView addSubview:img];
    [authorView addSubview:lab];
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 120, 44)];
    [leftView addSubview:self.backButton];
    [leftView addSubview:authorView];
    
    
    
    return leftView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
