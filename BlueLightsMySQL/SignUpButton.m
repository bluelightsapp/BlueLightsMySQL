//
//  SignUpButton.m
//  BlueLightsV2
//
//  Created by Alex Krush on 5/28/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "SignUpButton.h"

@implementation SignUpButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
//    [self.layer setBorderWidth:2];
//    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    //    [self.layer setCornerRadius:5];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self tweakState:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self tweakState:selected];
}

- (void)tweakState:(BOOL)state {
    if (state) {
        self.backgroundColor = [UIColor lightGrayColor];
//        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
