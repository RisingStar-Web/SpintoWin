//
//  RoundedView.m
//  SpinToWin
//
//  Created by Sergey on 20/01/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

#import "RoundedView.h"

@implementation RoundedView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        self.layer.borderColor = self.tintColor.CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
