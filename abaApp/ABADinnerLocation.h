//
//  ABADinnerMenu.h
//  abaApp
//
//  Created by Stian Jensen on 07.01.14.
//  Copyright (c) 2014 Christoffer Tønnessen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABADinnerLocation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSDictionary *menu;

+ (ABADinnerLocation *)dinnerLocationWithName:(NSString *)name andIdentifier:(NSString *)identifier;

- (void)updateMenu:(NSDictionary *)menu;

@end
