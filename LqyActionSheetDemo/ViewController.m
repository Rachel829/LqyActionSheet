//
//  ViewController.m
//  LqyActionSheetDemo
//
//  Created by admin-1 on 15/5/7.
//  Copyright (c) 2015年 rachel. All rights reserved.
//

#import "ViewController.h"
#import "LqyActionSheet.h"
@interface ViewController ()<LqyActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (strong,nonatomic)  NSMutableArray *type;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

   _myLabel.text = @"your choose";
}

- (IBAction)showActionSheetClick:(id)sender {
    NSMutableArray *type = [[NSMutableArray alloc]initWithCapacity:10];

    for (int i = 0; i < 6; i++) {
        NSString *ss = [NSString stringWithFormat:@"ssss---%d",i];
        [type addObject:ss];
    }
    _type = type;
    LqyActionSheet *action = [[LqyActionSheet alloc]initWithTitle:@"whatever" delegate:self cancelButtonTitle:@"CANCEL"otherButtonTitles:_type];
    [action showInView:self.view];
}
-(void)didClickButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == _type.count) {
        return;
    }else{
        _myLabel.text = [_type objectAtIndex:buttonIndex];
        NSLog(@"%@",_myLabel.text);
    }
}
@end
