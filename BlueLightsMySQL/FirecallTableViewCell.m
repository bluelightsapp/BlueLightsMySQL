//
//  FirecallTableViewCell.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/18/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import "FirecallTableViewCell.h"
#import "constants.m"

@implementation FirecallTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.unreadView setBackgroundColor:blueLightsColor];
    [self.unreadView.layer setCornerRadius:self.unreadView.frame.size.height/2];
    
    [self.responseView setClipsToBounds:YES];
    [self.responseView.layer setCornerRadius:2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFirecall:(DBFirecall *)firecall {
    if (_firecall != firecall) {
        _firecall = firecall;
        
        [self updateCell];
    }
}

- (void)updateCell {
    [self.signalLabel setText:self.firecall.dispType];
    [self.addressLabel setText:self.firecall.dispAddress];
    [self.additionalLabel setText:self.firecall.additional];
    [self.dateLabel setText:self.firecall.timeString];
    [self.responseLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.firecall.responses.count]];
    if (self.firecall.responses.count > 0) {
        [self.responseView setHidden:NO];
    } else {
        [self.responseView setHidden:YES];
    }
}

@end
