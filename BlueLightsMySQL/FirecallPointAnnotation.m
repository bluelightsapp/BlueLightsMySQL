//
//  FirecallPointAnnotation.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/26/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import "FirecallPointAnnotation.h"

@implementation FirecallPointAnnotation

- (id)initWithFirecall:(DBFirecall *)firecall {
    self = [super init];
    
    self.firecall = firecall;
    
    return self;
}

- (void)setFirecall:(DBFirecall *)firecall {
    _firecall = firecall;
    
    [self setTitle:firecall.dispType];
    [self setSubtitle:firecall.dispAddress];
    [self setCoordinate:firecall.coordinate];
}

@end
