//
//  LqyActionSheet.h
//  LqyActionSheetDemo
//
//  Created by admin-1 on 15/5/7.
//  Copyright (c) 2015年 rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LqyActionSheetDelegate<NSObject>
-(void)didClickButtonAtIndex:(NSInteger)buttonIndex;
@optional
-(void)didClickCancelButton;
@end

@interface LqyActionSheet : UIView
@property(nonatomic,strong)UIView *actionSheetView;
@property(nonatomic,strong) NSString *myTitle;
@property (nonatomic,assign)CGFloat LqyActionSheetHeight;
@property (nonatomic,assign)id<LqyActionSheetDelegate>delegate;


-(id)initWithTitle:(NSString *)title delegate:(id<LqyActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
-(void)showInView:(UIView *)view;
@end
