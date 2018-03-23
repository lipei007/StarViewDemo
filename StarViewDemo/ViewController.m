//
//  ViewController.m
//  StarViewDemo
//
//  Created by Jack on 2018/3/23.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "JLStarView.h"

@interface ViewController () <JLStarViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JLStarView *star = [[JLStarView alloc] initWithFrame:CGRectMake(50, 50, 130, 24)];
    star.delegate = self;
    star.starCount = 5;
    star.score = 3.5;
//    star.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:star];
    
}

- (void)starView:(JLStarView *)starView scoreDidChange:(float)score {
    NSLog(@"scroe: %f",score);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
