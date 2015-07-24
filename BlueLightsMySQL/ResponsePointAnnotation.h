//
//  ResponsePointAnnotation.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/25/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DBResponse.h"

@interface ResponsePointAnnotation : MKPointAnnotation

- (id)initWithResponse:(DBResponse *)response;

@property (strong, nonatomic) DBResponse * response;

@end
