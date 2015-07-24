//
//  ResponsePointAnnotation.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/25/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import "ResponsePointAnnotation.h"

@implementation ResponsePointAnnotation

- (id)initWithResponse:(DBResponse *)response {
    self = [super init];
    
    self.response = response;
    
    return self;
}

- (void)setResponse:(DBResponse *)response {
    _response = response;
    
    [self setCoordinate:response.coordinate];
    [self setTitle:[NSString stringWithFormat:@"%@ %@", response.user.firstName, response.user.lastName]];
    [self setSubtitle:response.updatedTimeString];
}

@end
