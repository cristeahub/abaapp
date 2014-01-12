//
//  ABATabBarController.m
//  abaApp
//
//  Created by Stian Jensen on 10.01.14.
//  Copyright (c) 2014 Christoffer Tønnessen. All rights reserved.
//

#import "ABATabBarController.h"

@interface ABATabBarController ()

@end

@implementation ABATabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITabBarItem *coffeeItem = [self.tabBar.items objectAtIndex:0];
    [coffeeItem setSelectedImage:[UIImage imageNamed:@"coffeeTabBarActive"]];
    
    UITabBarItem *dinnerItem = [self.tabBar.items objectAtIndex:1];
    [dinnerItem setSelectedImage:[UIImage imageNamed:@"dinnerTabBarActive"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
