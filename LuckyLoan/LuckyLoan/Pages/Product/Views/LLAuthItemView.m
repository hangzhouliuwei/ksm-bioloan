//
//  LLAuthItemView.m
//  LuckyLoan
//
//  Created by hao on 2024/1/2.
//

#import "LLAuthItemView.h"


@interface LLAuthItemView ()
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation LLAuthItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LineLightGrayColor;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return self;
}

- (void)loadIcon:(NSString *)icon title:(NSString *)title status:(NSString *)status {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 44, 44)];
    image.image = ImageWithName(icon);
    [self addSubview:image];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.userInteractionEnabled = NO;
    _selectBtn.frame = CGRectMake(self.width - 44, 14, 44, 44);
    [_selectBtn setImage:ImageWithName(@"ic_info_unselected") forState:UIControlStateNormal];
    [_selectBtn setImage:ImageWithName(@"ic_info_selected") forState:UIControlStateSelected];
    [self addSubview:_selectBtn];
    _selectBtn.selected = [status isEqualToString:@"1"];


    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(image.right + 12, 14, _selectBtn.x - image.right - 12, 44)];
    desc.text = title;
    desc.textColor = UIColor.blackColor;
    desc.font = Font(14);
    [self addSubview:desc];
}

- (void)tap {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    _selectBtn.selected = selected;
    if (selected) {
        self.backgroundColor = COLOR(233, 245, 241);
    }else {
        self.backgroundColor = LineLightGrayColor;
    }
}

- (BOOL)isSelected {
    return _selected;
}

@end
