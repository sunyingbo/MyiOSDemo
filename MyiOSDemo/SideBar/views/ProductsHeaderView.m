//
//  ProductsHeaderView.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/8.
//

#import "ProductsHeaderView.h"

@interface ProductsHeaderView ()

@property (nonatomic, strong) UIButton *headerBtn;

@end

@implementation ProductsHeaderView

+ (instancetype)productsHeaderViewWithTableView:(UITableView *)tableView
{
    static NSString *headerID = @"header";
    ProductsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[self alloc] initWithReuseIdentifier:headerID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        //布局子控件
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:headerBtn];
    self.headerBtn = headerBtn;
    [self.headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

/// 按钮的监听事件
- (void)headerBtnClick:(UIButton *)sender {
    self.groupModel.expend = !self.groupModel.expend;
    
    if (!self.groupModel.expend) {
        //没有展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }else {
        //展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickBtn:)]) {
        
        [self.delegate headerViewDidClickBtn:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerBtn.frame = self.bounds;
}

- (void)setGroupModel:(ProductGroupModel *)groupModel
{
    _groupModel = groupModel;
    [self.headerBtn setTitle:@"标题" forState:0];
    if (self.groupModel.expend) {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

@end
