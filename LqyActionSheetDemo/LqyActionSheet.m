//
//  LqyActionSheet.m
//  LqyActionSheetDemo
//
//  Created by admin-1 on 15/5/7.
//  Copyright (c) 2015年 rachel. All rights reserved.
//

#import "LqyActionSheet.h"
#define WINDOW_COLOR            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define UISCREEN_WIDTH          [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT         [UIScreen mainScreen].bounds.size.height
#define RGB(A,B,C)              [UIColor colorWithRed:A/255.0f green:B/255.0f blue:C/255.0f alpha:1.0f]
#define RGBA(A,B,C,AL)          [UIColor colorWithRed:A/255.0f green:B/255.0f blue:C/255.0f alpha:AL]
#define TITLE_HEIGHT            40
#define DEFAULT_X               10

#define OTHER_HEIGHT            40
#define BUTTON_BORDER_WIDTH     0.3f
#define BUTTON_BORDER_CORLOR    [UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:0.8].CGColor

@interface LqyActionSheet()
{
    BOOL hasMyTitle;
    BOOL hasCancelButton;
    BOOL hasOtherButton;
    NSInteger btnIndex;

}
@end

@implementation LqyActionSheet

-(id)initWithTitle:(NSString *)title delegate:(id<LqyActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
{
    self = [super init];
    self.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = WINDOW_COLOR;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCanceled)];
    [self addGestureRecognizer:tap];
    if (delegate) {
        self.delegate =delegate;
    }

    [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle  otherButtonTitles:otherButtonTitles];
    
    return self;

}

- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
//   
    _LqyActionSheetHeight = 0.0;
    btnIndex = 0;
   // actionsheet
    _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0,  [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
   _actionSheetView.backgroundColor =[UIColor clearColor];
    
    [self addSubview:_actionSheetView];
   
    
    if(title){
        hasMyTitle = YES;
        UILabel *titleLabel = [self createTitleLabelWithTitle:title];
        _LqyActionSheetHeight += TITLE_HEIGHT;
        [self.actionSheetView addSubview:titleLabel];
    }
    if (otherButtonTitles) {
        hasOtherButton = YES;
        for(int i = 0;i < otherButtonTitles.count; i++){
            UIButton *otherBtn = [self createOtherBtnWithTitle:otherButtonTitles[i] withPostion:i];
            otherBtn.tag = btnIndex;
            [otherBtn addTarget:self action:@selector(clickBtnAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            [otherBtn setFrame:CGRectMake(otherBtn.frame.origin.x, _LqyActionSheetHeight, otherBtn.frame.size.width, otherBtn.frame.size.height)];
            if (i != otherButtonTitles.count - 1) {
                _LqyActionSheetHeight += OTHER_HEIGHT;

            }else{
                _LqyActionSheetHeight += OTHER_HEIGHT +20;
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:otherBtn.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
                maskLayer.frame = otherBtn.bounds;
                maskLayer.path = maskPath.CGPath;
                otherBtn.layer.mask= maskLayer;
            }
            [self.actionSheetView addSubview:otherBtn];
            btnIndex ++;
        }
    }
    if (cancelButtonTitle) {
        hasCancelButton = YES;
        UIButton *cancelBtn = [self createCancelBtnWithTitle:cancelButtonTitle];
        cancelBtn.tag = btnIndex;
        [cancelBtn addTarget:self action:@selector(clickBtnAtIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionSheetView addSubview:cancelBtn];
        [cancelBtn setFrame:CGRectMake(DEFAULT_X, _LqyActionSheetHeight, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
        _LqyActionSheetHeight += cancelBtn.frame.size.height + 20;
        btnIndex ++;
    }
    [UIView animateWithDuration:0.25f animations:^{
        [self.actionSheetView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _LqyActionSheetHeight,[UIScreen mainScreen].bounds.size.width,_LqyActionSheetHeight)];
    }];
     
    
}

-(UILabel *)createTitleLabelWithTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEFAULT_X, 0, [UIScreen mainScreen].bounds.size.width - 20, TITLE_HEIGHT)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = titleLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    titleLabel.layer.mask = maskLayer;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.numberOfLines = 2;
    
    return titleLabel;

}
-(UIButton *)createOtherBtnWithTitle:(NSString *)title withPostion:(NSInteger)postionIndex
{
    UIButton *otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEFAULT_X, (postionIndex * (OTHER_HEIGHT)), [UIScreen mainScreen].bounds.size.width - 20, OTHER_HEIGHT)];
    otherBtn.layer.borderWidth = BUTTON_BORDER_WIDTH;
    otherBtn.layer.borderColor = BUTTON_BORDER_CORLOR;
    otherBtn.backgroundColor = [UIColor whiteColor];
    [otherBtn setTitle:title forState:UIControlStateNormal];
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    otherBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    otherBtn.titleLabel.numberOfLines = 0;
    [otherBtn setTitleColor:RGB(51, 125, 255) forState:UIControlStateNormal];
    [otherBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [otherBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    return otherBtn;

}
-(UIButton *) createCancelBtnWithTitle:(NSString *) title
{
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(DEFAULT_X,20, [UIScreen mainScreen].bounds.size.width - 20,40)];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:title forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitleColor:RGB(51, 125, 255) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return cancelBtn;
}
-(void)clickBtnAtIndex:(UIButton *)btn
{
    NSLog(@"%lu-----",btn.tag);
    if (hasCancelButton) {
        if (self.delegate) {
            if (btn.tag == btnIndex - 1) {
                if ([self.delegate respondsToSelector:@selector(didClickCancelButton)]) {
                    [self.delegate didClickCancelButton];
                }
            }
        }
    }
    if (self.delegate) {
       
            if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
                [self.delegate didClickButtonAtIndex:(NSInteger)btn.tag];
            }
       
    }
    [self showCanceled];

}


-(void)showInView:(UIView *)view{
    [view addSubview:self];
}
-(void)showCanceled
{
    [UIView animateWithDuration:0.25f animations:^{
        [self.actionSheetView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width,0)];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

}

@end
