//
//  ABAMiddagViewController.m
//  abaApp
//
//  Created by Stian Jensen on 07.01.14.
//  Copyright (c) 2014 Christoffer Tønnessen. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>

#import "ABADinnerViewController.h"
#import "ABADinnerLocation.h"

@interface ABADinnerViewController ()

@end

@implementation ABADinnerViewController
{
    NSArray *weekdays;
    NSArray *locations;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // Custom initialization
        weekdays = @[
                     @"mandag",
                     @"tirsdag",
                     @"onsdag",
                     @"torsdag",
                     @"fredag"
                     ];
        locations = @[
                      [ABADinnerLocation dinnerLocationWithName:@"Hangaren"
                                                  andIdentifier:@"hangaren"],
                      [ABADinnerLocation dinnerLocationWithName:@"Realfagskantina"
                                                  andIdentifier:@"realfag"]
                      ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.middagDisplay];
    self.middagDisplay.text = @"Laster...";
    
    for (int i=0; i < [locations count]; i++) {
        [self fetchDinnerInfo:i];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDinnerInfo:(NSInteger)index
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [NSString stringWithFormat:@"http://www.sit.no/dagensmiddag_json/?campus=%@", [locations[index] identifier]];
    [manager GET:URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self updateDinnerInfo:responseObject forLocation:index];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self displayDinnerError];
         }];
}

- (void)updateDinnerInfo:(id)JSON forLocation:(NSInteger)index
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:(NSWeekOfYearCalendarUnit|NSWeekdayCalendarUnit)
                                                  fromDate:[NSDate date]];
    NSInteger weekNumber = dateComponent.weekOfYear;
    self.dayOfWeek = dateComponent.weekday - 2;
    if (self.dayOfWeek < 0 || self.dayOfWeek > [weekdays count]) {
        weekNumber++;
    }
    NSString *weekNumberAsString = [NSString stringWithFormat:@"%d", weekNumber];
    if ([JSON objectForKey:weekNumberAsString]) {
        [locations[index] updateMenu:JSON[weekNumberAsString]];
        [self.middagDisplay removeFromSuperview];
        [self.tableView reloadData];
    } else {
        [self displayDinnerError];
    }
}

- (void)displayDinnerError
{
    [self.view addSubview:self.middagDisplay];
    self.middagDisplay.text = @"Fant ingen middagsinfo";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [weekdays count] - self.dayOfWeek; // Change to remaining weekdays
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    
    NSString *weekdayIdentifier = weekdays[indexPath.section + self.dayOfWeek];
    
    ABADinnerLocation *location = locations[indexPath.row];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.f]];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = location.menu[weekdayIdentifier];
    cell.detailTextLabel.text = location.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *weekdayIdentifier = weekdays[indexPath.section + self.dayOfWeek];
    ABADinnerLocation *location = locations[indexPath.row];
    NSString *menu = location.menu[weekdayIdentifier];

    CGRect labelSize = [menu boundingRectWithSize:CGSizeMake(300.f, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{
                                                    NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16.f]
                                                    }
                                          context:nil];
    return ceil(labelSize.size.height) + 32.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [weekdays[section + self.dayOfWeek] capitalizedString];
}

@end
