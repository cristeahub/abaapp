//
//  ABACoffeeViewController.h
//  abaApp
//
//  Created by Christoffer Tønnessen on 29/11/13.
//  Copyright (c) 2013 Christoffer Tønnessen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABACoffeeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *lastMade;

- (IBAction)refreshButtonPressed:(id)sender;
- (void) updateCoffeeStatus;

@end
