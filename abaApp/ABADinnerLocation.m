//
//  ABADinnerMenu.m
//  abaApp
//
//  Created by Stian Jensen on 07.01.14.
//  Copyright (c) 2014 Christoffer Tønnessen. All rights reserved.
//

#import "ABADinnerLocation.h"

@implementation ABADinnerLocation

+ (ABADinnerLocation *)dinnerLocationWithName:(NSString *)name andIdentifier:(NSString *)identifier
{
    ABADinnerLocation *dinnerLocation = [[ABADinnerLocation alloc] init];
    dinnerLocation.identifier = identifier;
    dinnerLocation.name = name;
    return dinnerLocation;
}

- (void)updateMenu:(NSDictionary *)aMenu
{
    NSMutableDictionary *menu = [[NSMutableDictionary alloc] initWithDictionary:aMenu];
    for (NSString *weekday in aMenu) {
        if ([menu[weekday] isEqualToString:@""]) {
            [menu setValue:@"Ingen måltider funnet" forKey:weekday];
        }
    }
    self.menu = menu;
}

@end
