//
//  FirecallPointAnnotation.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/26/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DBFirecall.h"

@interface FirecallPointAnnotation : MKPointAnnotation

- (id)initWithFirecall:(DBFirecall *)firecall;

@property (strong, nonatomic) DBFirecall * firecall;

@end
