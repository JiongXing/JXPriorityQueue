//
//  LineView.m
//  JXPriorityQueueDemo
//
//  Created by JiongXing on 2016/11/7.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIsRight:(BOOL)isRight {
    _isRight = isRight;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    
    CGFloat beginX = self.isRight ? 0 : CGRectGetWidth(rect);
    CGContextMoveToPoint(ctx, beginX, 0);
    CGFloat endX = self.isRight ? CGRectGetWidth(rect) : 0;
    CGContextAddLineToPoint(ctx, endX, CGRectGetHeight(rect));
    
    CGContextStrokePath(ctx);
}

@end
