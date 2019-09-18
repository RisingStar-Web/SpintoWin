//
//  GradientView.m
//  SpinToWin
//
//  Created by Sergey on 20/01/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView
CAGradientLayer *gradient;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        [gradient setStartPoint:CGPointMake(0, 0)];
        [gradient setEndPoint:CGPointMake(0, 1)];
        [gradient setColors:@[ (id)[[UIColor colorWithRed:0.1 green:0.1 blue:0.89 alpha:1.0] CGColor],
                               (id)[[UIColor colorWithRed:0.1 green:0.1 blue:0.5 alpha:1.0] CGColor],
                               (id)[[UIColor colorWithRed:0.06 green:0.13 blue:0.15 alpha:1.0] CGColor]]];
        [self.layer insertSublayer:gradient atIndex:0];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    gradient.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
