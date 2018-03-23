//
//  JLStarView.m
//  Test
//
//  Created by Jack on 2018/3/23.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "JLStarView.h"

@interface JLStar : NSObject
{
    @public
    CGPoint _pointA[5];
    CGPoint _pointB[5];
}
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) CGFloat value;

@end

@implementation JLStar

@end

@interface JLStarView ()

@property (nonatomic,strong) NSMutableArray *stars;

@end

@implementation JLStarView

- (NSMutableArray *)stars {
    if (!_stars) {
        _stars = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            JLStar *star = [[JLStar alloc] init];
            star.rect = CGRectZero;
            if (i >= self.score) {
                star.value = 0.f;
            } else {
                if (i + 1 > self.score) {
                    star.value = 0.5f;
                } else {
                    star.value = 1.f;
                }
            }
            [self.stars addObject:star];
        }
    }
    return _stars;
}

- (void)setStarCount:(NSUInteger)starCount {
    _starCount = starCount;
    [self.stars removeAllObjects];
    for (int i = 0; i < starCount; i++) {
        JLStar *star = [[JLStar alloc] init];
        star.rect = CGRectZero;
        if (i >= self.score) {
            star.value = 0.f;
        } else {
            if (i + 1 > self.score) {
                star.value = 0.5f;
            } else {
                star.value = 1.f;
            }
        }
        [self.stars addObject:star];
    }
}

- (void)setScore:(float)score {
    _score = score;
    for (int i = 0; i < self.stars.count; i++) {
        JLStar *star = [self.stars objectAtIndex:i];
        if (i >= self.score) {
            star.value = 0.f;
        } else {
            if (i + 1 > self.score) {
                star.value = 0.5f;
            } else {
                star.value = 1.f;
            }
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat star_w = (width - 5 * self.starCount) / self.starCount;
    CGFloat star_h = height - 2 * 2;
    CGFloat star_size = MIN(star_w, star_h);
    
    CGFloat offset_x = 5;
    CGFloat offset_y = 2;
    
    for (int i = 0; i < self.starCount; i++) {
        
        JLStar *star = [self.stars objectAtIndex:i];
        CGRect star_rect = CGRectMake(offset_x, offset_y, star_size, star_size);
        offset_x += star_size + 5;
        
        star.rect = star_rect;
        [self drawStar:star];
        
    }
    
}

- (void)drawStar:(JLStar *)star {
    if (star == nil || CGRectEqualToRect(CGRectZero, star.rect)) {
        return;
    }
    CGRect rect = star.rect;
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) * 0.5;
    CGFloat radius_inner = 0.4 * radius;
    
    // 计算使用的坐标系与屏幕显示坐标系不同，y值正负相反
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < 5; i++) {
        
        CGFloat angle = M_PI_2 + M_PI * 2 / 5 * i;
        CGFloat x = radius * cos(angle) + centerX;
        CGFloat y = -radius * sin(angle) + centerY;
        star->_pointA[i] = CGPointMake(x, y);
        
        if (i == 0) {
            [path moveToPoint:star->_pointA[i]];
        } else {
            [path addLineToPoint:star->_pointA[i]];
        }
        
        CGFloat angle_inner = M_PI / 5 + M_PI_2 + M_PI * 2 / 5 * i;
        CGFloat x_inner = radius_inner * cos(angle_inner) + centerX;
        CGFloat y_inner = -radius_inner * sin(angle_inner) + centerY;
        star->_pointB[i] = CGPointMake(x_inner, y_inner);
        
        [path addLineToPoint:star->_pointB[i]];
    }
    [path closePath];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *starColor = [UIColor colorWithRed:0.84 green:0.68 blue:0.1 alpha:1];
    
    CGContextSetStrokeColorWithColor(ctx, starColor.CGColor);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, .5f);
    CGContextAddPath(ctx, path.CGPath);
    if (star.value >= 1.0) {
        CGContextSetFillColorWithColor(ctx, starColor.CGColor);
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    if (star.value > 0.25 && star.value < 0.75) {
        
        CGContextSaveGState(ctx);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:star->_pointA[0]];
        [path addLineToPoint:star->_pointB[0]];
        [path addLineToPoint:star->_pointA[1]];
        [path addLineToPoint:star->_pointB[1]];
        [path addLineToPoint:star->_pointA[2]];
        [path addLineToPoint:star->_pointB[2]];
        [path addLineToPoint:star->_pointA[0]];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, starColor.CGColor);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGContextRestoreGState(ctx);
    }
    
}

#pragma mark - Tracking Touch

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint lastPoint = [touch locationInView:self];
    for (JLStar *star in self.stars) {
        if (CGRectContainsPoint(star.rect, lastPoint)) {
            
            NSInteger index = [self.stars indexOfObject:star];
            CGFloat minX = CGRectGetMinX(star.rect);
            CGFloat width = CGRectGetWidth(star.rect);
            
            if (lastPoint.x <= minX + width * 0.25) {
                star.value = 0.0f;
            } else if (lastPoint.x >= minX + width * 0.75) {
                star.value = 1.0f;
            } else {
                star.value = 0.5f;
            }
            
            [self updateScore:index + star.value];
            
            if (index > 0) {
                for (NSInteger i = 0; i < index; i++) {
                    JLStar *pretStar = [self.stars objectAtIndex:i];
                    pretStar.value = 1.f;
                }
            }
            
            if (index < self.starCount - 1) {
                for (NSInteger i = index + 1; i < self.starCount; i++) {
                    JLStar *nextStar = [self.stars objectAtIndex:i];
                    nextStar.value = 0.f;
                }
            }
            
            break;
        }
    }
    [self setNeedsDisplay];
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark - Private

- (void)updateScore:(float)score {
    self.score = score;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(starView:scoreDidChange:)]) {
        [self.delegate starView:self scoreDidChange:score];
    }
}


@end
