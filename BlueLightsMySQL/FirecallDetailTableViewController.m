//
//  FirecallDetailTableViewController.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/18/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import "FirecallDetailTableViewController.h"
#import "constants.m"
#import "MainNavigationController.h"
#import "APIClient.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ResponsePointAnnotation.h"
#import "FirecallPointAnnotation.h"

@interface FirecallDetailTableViewController () {
    CLLocationManager * locationManager;
    CLLocation * currentLocation;
    NSMutableArray * sections;
    BOOL responseExpanded;
    CGRect headerFrameOriginal;
    BOOL mapExpanded;
    UITapGestureRecognizer * mapTapGesture;
    DBResponse * userResponse;
    MBProgressHUD * HUD;
}

@end

@implementation FirecallDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    NSTimer * loadFirecallTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                     target:self
                                                                   selector:@selector(loadFirecall)
                                                                   userInfo:nil
                                                                    repeats:YES];
    [loadFirecallTimer fire];
    
    [self getUserResponse];
    [self loadFirecall];
    [self loadAnnotations];
    [self addCallToMap];
    
    [self.pullDownLabel setAlpha:0.0];
    headerFrameOriginal = CGRectMake(0, self.tableView.frame.origin.y, self.view.frame.size.width, 120);
    [self.headerView setFrame:headerFrameOriginal];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top + headerFrameOriginal.size.height,
                                                     self.tableView.contentInset.left,
                                                     self.tableView.contentInset.bottom,
                                                     self.tableView.contentInset.right)];
    
    [self.view insertSubview:self.headerView aboveSubview:self.tableView];
    
    [self.openInMapsButton setAlpha:0.0];
    [self.openInMapsButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:0.5]] forState:UIControlStateNormal];
    [self.closeMapButton setAlpha:0.0];
    [self.closeMapButton setBackgroundImage:[self imageWithColor:blueLightsColor] forState:UIControlStateNormal];
    
    if (self.firecall)
        [self createSections];
    
    mapTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandMap)];
    [mapTapGesture setCancelsTouchesInView:NO];
    mapTapGesture.numberOfTapsRequired = 1;
    mapTapGesture.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:mapTapGesture];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.responseView];
    [self.responseView addSubview:HUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
    currentLocation = [locations lastObject];
    
    if (userResponse.destination)
        [self setDestination:userResponse.destination];
    
    if (!mapExpanded)
        [self zoomToFitMapAnnotations:self.mapView];
}

-(void)zoomToFitMapAnnotations:(MKMapView*)aMapView {
    if([aMapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
//    MKMapRect mapRect = MKMapRectMake(topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5,
//                                      topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5,
//                                      fabs(topLeftCoord.latitude - bottomRightCoord.latitude),
//                                      fabs(bottomRightCoord.longitude - topLeftCoord.longitude));
//    
//    [aMapView setVisibleMapRect:mapRect edgePadding:UIEdgeInsetsMake(32, 32, 32, 32) animated:YES];
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3; // Add a little extra space on the sides
    
    region = [aMapView regionThatFits:region];
    [aMapView setRegion:region animated:YES];
}

- (void)createSections {
    sections = [[NSMutableArray alloc] init];
    
    NSDictionary * section1 = @{
                                @"type" : @"response",
                                @"identifier" : @"ViewResponsesCell",
                                @"title" : @"Responses",
                                @"values" : self.firecall.responses
                                };
    
    [sections addObject:section1];
    
    NSDictionary * section2 = @{
                                @"type" : @"details",
                                @"identifier" : @"DetailCell",
                                @"values" : self.firecall.detailsArray};
    
    [sections addObject:section2];
    
    NSDictionary * section3 = @{
                                @"type" : @"message",
                                @"identifier" : @"MessageCell",
                                @"value" : self.firecall.message
                                };
    
    [sections addObject:section3];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString * type = [sections[section] objectForKey:@"type"];
    
    if ([type isEqualToString:@"response"]) {
        if (responseExpanded)
            return 1 + self.firecall.responses.count;
        else
            return 1;
    } else if ([type isEqualToString:@"details"]) {
        return [[sections[section] objectForKey:@"values"] count];
    } else if ([type isEqualToString:@"message"]) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * type = [sections[indexPath.section] objectForKey:@"type"];
    NSString * identifier = [sections[indexPath.section] objectForKey:@"identifier"];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([type isEqualToString:@"response"]) {
        if (indexPath.row == 0) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.firecall.responses.count]];
        } else {
            DBResponse * response = self.firecall.responses[indexPath.row - 1];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"ResponseCell" forIndexPath:indexPath];
            UILabel * nameLabel = (UILabel *)[cell viewWithTag:10];
            UILabel * destinationLabel = (UILabel *)[cell viewWithTag:11];
            UILabel * timeLabel = (UILabel *)[cell viewWithTag:12];
            
            [nameLabel setText:response.user.fullName];
            [destinationLabel setText:response.destination.name];
            [timeLabel setText:response.timeString];
        }
    } else if ([type isEqualToString:@"details"]) {
        NSDictionary * detail = [sections[indexPath.section] objectForKey:@"values"][indexPath.row];
        UILabel * textLabel = (UILabel *)[cell viewWithTag:10];
        UILabel * detailTextLabel = (UILabel *)[cell viewWithTag:20];
        [textLabel setText:[detail objectForKey:@"title"]];
        [detailTextLabel setText:[detail objectForKey:@"detail"]];
    } else if ([type isEqualToString:@"message"]) {
        [cell.textLabel setText:[sections[indexPath.section] objectForKey:@"value"]];
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"ViewResponsesCell"]) {
        if (responseExpanded) {
            responseExpanded = NO;
            NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.firecall.responses.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForItem:i+1 inSection:indexPath.section]];
            }
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            responseExpanded = YES;
            NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.firecall.responses.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForItem:i+1 inSection:indexPath.section]];
            }
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView reloadData];
        }
    }
}

- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat offset = scrollView.contentOffset.y + self.tableView.contentInset.top;
        
//        NSLog(@"offset: %f", offset);
        
        if (!mapExpanded) {
            CGRect headerFrame = self.headerView.frame;
            if (offset >= 0) {
//                headerFrame.origin.y = headerFrameOriginal.origin.y + offset;
                headerFrame.size.height = headerFrameOriginal.size.height;
            } else {
//                headerFrame.origin.y = headerFrameOriginal.origin.y + offset;
                headerFrame.size.height = headerFrameOriginal.size.height - offset;
            }
            [self.headerView setFrame:headerFrame];
            
            if (offset >= -100) {
                [self.pullDownLabel setAlpha:-(offset)/100.0];
                if (![self.pullDownLabel.text isEqualToString:@"Pull down to expand"]) [self.pullDownLabel setText:@"Pull down to expand"];
            } else {
                if (![self.pullDownLabel.text isEqualToString:@"Release to expand"]) [self.pullDownLabel setText:@"Release to expand"];
            }
        }
        
        [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(self.mapView.frame.size.height + self.responseView.frame.size.height + self.tableView.contentInset.top, 0, 0, 0)];
    }
}

- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableView) {
        CGFloat offset = scrollView.contentOffset.y + self.tableView.contentInset.top;
        
        NSLog(@"ended dragging with offset: %f", offset);
        
        if (offset < -100) {
            [self expandMap];
        }
    }
}

- (void)expandMap {
    if (!mapExpanded) {
        mapExpanded = YES;
        
        [self.tableView setScrollEnabled:NO];
        [self.mapView setScrollEnabled:YES];
        [self.mapView setZoomEnabled:YES];
        [self.mapView removeGestureRecognizer:mapTapGesture];
        
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = headerFrameOriginal.origin.y;
        headerFrame.size.height = self.tableView.frame.size.height + 48;
        
        [self.headerView setFrame:headerFrame];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
            [self.openInMapsButton setAlpha:1.0];
            [self.closeMapButton setAlpha:1.0];
            [self.pullDownLabel setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self zoomToFitMapAnnotations:self.mapView];
        }];
        
    }
}

- (void)minimizeMap {
    if (mapExpanded) {
        mapExpanded = NO;
        [self.tableView setScrollEnabled:YES];
        [self.mapView setScrollEnabled:NO];
        [self.mapView setZoomEnabled:NO];
        [self.mapView addGestureRecognizer:mapTapGesture];
        
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = headerFrameOriginal.origin.y;
        headerFrame.size.height = headerFrameOriginal.size.height;
        
        [self.headerView setFrame:headerFrame];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
            [self.openInMapsButton setAlpha:0.0];
            [self.closeMapButton setAlpha:0.0];
            [self.pullDownLabel setAlpha:0.0];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (DBDestination *)destinationForIndexPath:(NSIndexPath *)indexPath {
    DBDestination * destination;
    if (indexPath.row == 0) {
        destination = [[DBDestination alloc] initWithObjectId:@(-1)];
        destination.name = @"Cancel";
    } else {
        destination = self.department.destinations[indexPath.row - 1];
    }
    
    return destination;
}

- (void)getUserResponse {
    NSString * url = [NSString stringWithFormat:@"response/firecall/%@/user/%@", self.firecall.objectId, [DBUser currentUser].objectId];
    NSDictionary * params = nil;
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient GET:url parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            NSLog(@"response: %@", response);
            DBResponse * oldResponse = userResponse;
            userResponse = response.result;
            
            [self.responseCollectionView reloadData];
            
            for (int i = 0; i <= self.department.destinations.count; i++) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                DBDestination * destination = [self destinationForIndexPath:indexPath];
                if (![oldResponse.destination isEqual:userResponse.destination] && [destination.name isEqualToString:userResponse.destination.name]) {
                    [self.responseCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                }
            }
        } else {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Unable to connect."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

- (void)loadFirecall {
    NSString * url = [NSString stringWithFormat:@"firecall/%@", self.firecall.objectId];
    NSDictionary * params = nil;
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient GET:url parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            NSLog(@"response: %@", response);
            DBFirecall * oldFirecall = self.firecall;
            self.firecall = response.result;
            
            if (![self.firecall isEqual:oldFirecall]) {
                CGPoint contentOffset = self.tableView.contentOffset;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView setContentOffset:contentOffset];
            }
            
            [self loadAnnotations];
        } else {
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Unable to connect."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];

}

- (void)loadAnnotations {
    if (!self.firecall) return;
    
    NSMutableArray * responses = self.firecall.responses.mutableCopy;
    NSMutableArray * annotations = self.mapView.annotations.mutableCopy;
    
    for (DBResponse * response in self.firecall.responses) {
        for (ResponsePointAnnotation * annotation in self.mapView.annotations) {
            if ([annotation isKindOfClass:[ResponsePointAnnotation class]] && [annotation.response.objectId isEqual:response.objectId]) {
                [responses removeObject:response];
                [annotations removeObject:annotation];
                [UIView animateWithDuration:1.0 animations:^{
                    [annotation setResponse:response];
                }];
            }
        }
    }
    
    for (DBResponse * response in responses) {
        if (![response.user.objectId isEqual:[DBUser currentUser].objectId]) {
            if ([[NSDate date] timeIntervalSinceDate:response.updatedAt] < 5*60) {
                [self.mapView addAnnotation:[[ResponsePointAnnotation alloc] initWithResponse:response]];
            }
        }
    }
    
    for (ResponsePointAnnotation * annotation in annotations) {
        if ([annotation isKindOfClass:[ResponsePointAnnotation class]])
            [self.mapView removeAnnotation:annotation];
        else if ([annotation isKindOfClass:[FirecallPointAnnotation class]]) {
//            [(FirecallPointAnnotation *)annotation setFirecall:self.firecall];
        }
    }
}

- (void)addCallToMap {
    if (self.firecall.coordinate.latitude == 0 && self.firecall.coordinate.longitude == 0) {
        NSString * address = [NSString stringWithFormat:@"%@, %@, NEW YORK", self.firecall.address, self.firecall.city];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray * placemarks, NSError * error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *location = placemark.location;
                CLLocationCoordinate2D coordinate = location.coordinate;
                
                [self.firecall setLatitude:@(coordinate.latitude)];
                [self.firecall setLongitude:@(coordinate.longitude)];
                [self.mapView addAnnotation:[[FirecallPointAnnotation alloc] initWithFirecall:self.firecall]];
            }
        }];
    } else {
        [self.mapView addAnnotation:[[FirecallPointAnnotation alloc] initWithFirecall:self.firecall]];
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.department.destinations count] + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    DBDestination * destination = [self destinationForIndexPath:indexPath];
    
    UILabel * label = (UILabel *)[cell viewWithTag:10];
    [label setText:destination.name];
    
    if (indexPath.row != 0 && [destination.name isEqualToString:userResponse.destination.name]) {
        [cell setBackgroundColor:blueLightsColor];
        UILabel * label = (UILabel *)[cell viewWithTag:10];
        [label setTextColor:[UIColor whiteColor]];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
        UILabel * label = (UILabel *)[cell viewWithTag:10];
        [label setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [(NSString*)[self destinationForIndexPath:indexPath].name sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17.0] }];
    size.height = self.responseCollectionView.frame.size.height - 1;
    size.width += 30;
    
    return size;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (![[collectionView cellForItemAtIndexPath:indexPath] isSelected]) {
        UICollectionViewCell * cell = [self.responseCollectionView cellForItemAtIndexPath:indexPath];
        [cell setBackgroundColor:blueLightsColor];
        UILabel * label = (UILabel *)[cell viewWithTag:10];
        [label setTextColor:[UIColor whiteColor]];
    }
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (![[collectionView cellForItemAtIndexPath:indexPath] isSelected]) {
        UICollectionViewCell * cell = [self.responseCollectionView cellForItemAtIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        UILabel * label = (UILabel *)[cell viewWithTag:10];
        [label setTextColor:[UIColor blackColor]];
    }
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DBDestination * destination = [self destinationForIndexPath:indexPath];
    
    if (![userResponse.destination.name isEqualToString:destination.name]) {
        if (indexPath.row == 0) {
            userResponse.destination = destination;
            NSLog(@"cancelled");
        } else {
            NSLog(@"selected %@", destination.name);
        }
        
        [self.responseCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [self setDestination:destination];
    }
}

- (void)setDestination:(DBDestination *)destination {
    NSString * url = [NSString stringWithFormat:@"response/firecall/%@/user/%@", self.firecall.objectId, [DBUser currentUser].objectId];
    NSDictionary * params = @{@"destination_id": destination.objectId,
                              @"latitude": @(currentLocation.coordinate.latitude),
                              @"longitude": @(currentLocation.coordinate.longitude)};
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient POST:url parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            NSLog(@"response: %@", response);
            
            userResponse.destination = destination;
            [self.responseCollectionView reloadData];
//            [self loadFirecall];
//            [self getUserResponse];
        } else {
            NSLog(@"error: %@", error);
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Unable to connect."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

- (IBAction)closeMapsAction:(id)sender {
    [self minimizeMap];
}

- (IBAction)openInMapsAction:(id)sender {
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
//    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
//    MKPinAnnotationView *pinView =
//    (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
//    if (!pinView)
//    {
//        MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
//                                                                         reuseIdentifier:SFAnnotationIdentifier] autorelease];
//        UIImage *flagImage = [UIImage imageNamed:@"flag.png"];
//        // You may need to resize the image here.
//        annotationView.image = flagImage;
//        return annotationView;
//    }
//    else
//    {
//        pinView.annotation = annotation;
//    }
//    return pinView;
//}

@end
