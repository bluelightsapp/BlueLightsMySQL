//
//  FirecallTableViewController.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "FirecallTableViewController.h"
#import "MainNavigationController.h"
#import "APIClient.h"
#import "constants.m"
#import "DBFirecall.h"
#import "DBDepartment.h"
#import "DBResponse.h"
#import "FirecallTableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "FirecallDetailTableViewController.h"

@implementation FirecallTableViewController {
    NSMutableDictionary * sections;
    NSArray * sortedSections;
    MBProgressHUD * HUD;
    int page;
    DBDepartment * department;
    int departmentId;
    BOOL isRefreshing;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    departmentId = 1;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    

    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    [self updateTitle];
    
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self reloadData];
}

- (void)reloadData {
    if (isRefreshing) return;
    isRefreshing = YES;
    
    [self loadFirecalls];
    [self loadDepartment];
}

- (void)loadFirecalls {
    page = -1;
    
    sections = [[NSMutableDictionary alloc] init];
    sortedSections = [[NSArray alloc] init];
    
    [self loadNextPage];
}

- (void)loadDepartment {
    NSString * url = [NSString stringWithFormat:@"department/%d", departmentId];
    NSDictionary * params = nil;
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient GET:url parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            NSLog(@"department: %@", response);
//            [self insertFirecalls:response.result];
            department = response.result;
            MainNavigationController * mnc = (MainNavigationController *)self.navigationController;
            [mnc.departments setObject:department forKey:[NSString stringWithFormat:@"department_%d", departmentId]];
            [self updateTitle];
        } else {
//            NSLog(@"error: %@", error);
//            [HUD setMode:MBProgressHUDModeText];
//            [HUD setDetailsLabelText:@"Unable to connect."];
//            [HUD show:YES];
//            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

- (void)updateTitle {
    MainNavigationController * mnc = (MainNavigationController *)self.navigationController;
    department = [mnc.departments objectForKey:[NSString stringWithFormat:@"department_%d", departmentId]];
    if (department) {
        self.title = department.name;
    }
}

- (void)loadNextPage {
    NSString * url = [NSString stringWithFormat:@"firecall/department/%d/%d", departmentId, ++page];
    NSDictionary * params = nil;
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient GET:url parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            NSLog(@"response: %@", response);
            [self insertFirecalls:response.result];
            [self.refreshControl endRefreshing];
            isRefreshing = NO;
        } else {
            NSLog(@"error: %@", error);
            [HUD setMode:MBProgressHUDModeText];
            [HUD setDetailsLabelText:@"Unable to connect."];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
            [self.refreshControl endRefreshing];
            isRefreshing = NO;
        }
    }];
}

- (void)insertFirecalls:(NSArray *)newFirecalls {
    for (DBFirecall * firecall in newFirecalls) {
        NSMutableArray * sectionObjects = [sections objectForKey:firecall.dateWithoutTime];
        if (sectionObjects == nil) {
            sectionObjects = [[NSMutableArray alloc] init];
            [sections setObject:sectionObjects forKey:firecall.dateWithoutTime];
        }
        [sectionObjects addObject:firecall];
    }
    
    NSArray * unsortedSections = [sections allKeys];
    
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    sortedSections = [unsortedSections sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[sections allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * sectionObjects = [sections objectForKey:[sortedSections objectAtIndex:section]];
    return [sectionObjects count];
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (DBFirecall *)objectForIndexPath:(NSIndexPath *)indexPath {
    NSArray * sectionObjects = [sections objectForKey:[sortedSections objectAtIndex:indexPath.section]];
    return sectionObjects[indexPath.row];
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DBFirecall * firecall = [self objectForIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    [headerView setBackgroundColor:blueLightsColor];
    headerView.layer.shadowOffset = CGSizeMake(0, 2);
    headerView.layer.shadowRadius = 2;
    headerView.layer.shadowOpacity = 0.25;
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, self.tableView.frame.size.width - 32, 80 - 32)];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setText:@"TODAYS DATE"];
    [headerLabel setText:firecall.dayString];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirecallTableViewCell * cell = (FirecallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    DBFirecall * firecall = [self objectForIndexPath:indexPath];
    
    [cell setFirecall:firecall];
    
    return cell;
}

- (IBAction)logoutAction:(id)sender {
    MainNavigationController * mnc = (MainNavigationController *)self.navigationController;
    [mnc logOut];
}

- (IBAction)menuAction:(id)sender {
    [[SlideNavigationController sharedInstance] bounceMenu:MenuLeft withCompletion:nil];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        DBFirecall * firecall = [self objectForIndexPath:indexPath];
        FirecallDetailTableViewController * vc = (FirecallDetailTableViewController *)[segue destinationViewController];
        [vc setFirecall:firecall];
        [vc setDepartment:department];
    }
}

@end
