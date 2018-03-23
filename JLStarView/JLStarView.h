//
//  JLStarView.h
//  Test
//
//  Created by Jack on 2018/3/23.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLStarView;
@protocol JLStarViewDelegate <NSObject>

- (void)starView:(JLStarView *)starView scoreDidChange:(float)score;

@end

@interface JLStarView : UIControl

@property (nonatomic,assign) NSUInteger starCount;
@property (nonatomic,assign) float score;
@property (nonatomic,weak) id<JLStarViewDelegate> delegate;

@end
