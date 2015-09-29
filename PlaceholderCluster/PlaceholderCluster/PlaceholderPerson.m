//
//  PlaceholderPerson.m
//  PlaceholderCluster
//
//  Created by Dan Zinngrabe on 9/28/15.
//  Copyright © 2015 Dan Zinngrabe. All rights reserved.
//

#import "PlaceholderPerson.h"

#import "AddressBookPerson.h"
#import "ContactsPerson.h"

@implementation PlaceholderPerson

- (instancetype) initWithFirstName:(NSString *)firstName {
    if (NSClassFromString(@"CNContactStore") != nil){
        return (id)[[ContactsPerson alloc] initWithFirstName:firstName];
    } else {
        return (id)[[AddressBookPerson alloc] initWithFirstName:firstName];
    }
}

@end
