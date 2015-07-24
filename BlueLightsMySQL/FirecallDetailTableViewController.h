//
//  FirecallDetailTableViewController.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/18/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBFirecall.h"
#import "DBResponse.h"
#import "DBDepartment.h"
#import "DBDestination.h"
#import <MapKit/MapKit.h>

@interface FirecallDetailTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) DBFirecall * firecall;
@property (strong, nonatomic) DBDepartment * department;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *responseView;
@property (weak, nonatomic) IBOutlet UICollectionView *responseCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *pullDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *openInMapsButton;
- (IBAction)openInMapsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeMapButton;
- (IBAction)closeMapsAction:(id)sender;

@end
