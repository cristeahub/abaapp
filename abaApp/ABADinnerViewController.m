//
//  ABAMiddagViewController.m
//  abaApp
//
//  Created by Stian Jensen on 07.01.14.
//  Copyright (c) 2014 Christoffer Tønnessen. All rights reserved.
//

#import "ABADinnerViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface ABADinnerViewController ()

@end

@implementation ABADinnerViewController
{
    NSArray *weekdays;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self fetchDinnerInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDinnerInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://www.sit.no/dagensmiddag_json/?campus=%@", @"hangaren"]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self displayDinnerInfo:responseObject];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self displayDinnerError];
         }];
}

- (void)displayDinnerInfo:(id)JSON
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calendar components:(NSWeekOfYearCalendarUnit) fromDate:[NSDate date]];
    NSString *weekNumberAsString = [NSString stringWithFormat:@"%d", dateComponent.weekOfYear];
    if ([JSON objectForKey:weekNumberAsString]) {
        NSDictionary *dinnerInfo = JSON[weekNumberAsString];
        NSString *text = @"";
        for (int i=0;i<[weekdays count];i++) {
            NSString *weekdayIdentifier = weekdays[i];
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@:\n%@", weekdayIdentifier, dinnerInfo[weekdayIdentifier]]];
        }
        self.middagDisplay.text = text;
    } else {
        [self displayDinnerError];
    }
}

- (void)displayDinnerError
{
    self.middagDisplay.text = @"Fant ingen middagsinfo";
}

@end
