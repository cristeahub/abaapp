//
//  ABACoffeeViewController.m
//  abaApp
//
//  Created by Christoffer Tønnessen on 29/11/13.
//  Copyright (c) 2013 Christoffer Tønnessen. All rights reserved.
//

#import "ABACoffeeViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "ABAConstants.h"

@interface ABACoffeeViewController ()

@end

@implementation ABACoffeeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateOnNotification)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.status.text = @"hei";
    [self updateCoffeeStatus];
}

- (void) updateOnNotification
{
    [self updateCoffeeStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayCoffeeStatus:(NSString *)status
{
    self.status.text = status;
}

- (void) displayCoffeLastMade:(NSString *)lastMade
{
    self.lastMade.text = [NSString stringWithFormat:@"Kaffen ble sist laget\n%@", lastMade];
}

- (IBAction)updateButtonPressed:(id)sender {
    [self displayCoffeeStatus:@"Updating..."];
    [self displayCoffeLastMade:@"Updating..."];
    [self updateCoffeeStatus];
}

- (void) updateCoffeeStatus
{
    [self fetchCoffeeStatusInfoFromAbakusServerWithJSON];
}

- (void)displayCoffeeStatusWithDataFromJSON:(id)JSON
{
    NSDictionary *coffeeStatus = JSON[@"coffee"];
    
    if (coffeeStatus[@"status"]) {
        [self displayCoffeeStatus:@"Kaffen er på! LØP :D"];
    } else {
        [self displayCoffeeStatus:@"Kaffen er av! Skru den på!"];
    }
    
    [self displayCoffeLastMade:coffeeStatus[@"last_start"]];
}

- (void) fetchCoffeeStatusInfoFromAbakusServerWithJSON
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", ABAKUS_API_ENDPOINT, ABAKUS_COFFEE_STATUS_ENDPOINT] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self displayCoffeeStatusWithDataFromJSON:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self displayCoffeeStatus:@"Error, please refresh"];
    }];
}

@end
