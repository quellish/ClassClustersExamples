//
//  Person.m
//  CustomInitializationCluster
//
//  Created by Dan Zinngrabe on 9/28/15.
//  Copyright © 2015 Dan Zinngrabe. All rights reserved.
//

#import "Person.h"
@import ObjectiveC;

#import "AddressBookPerson.h"
#import "ContactsPerson.h"

#import "PersonExceptions.h"

@implementation Person
@dynamic firstName;

- (instancetype) initWithFirstName:(NSString *)firstName {
    if (NSClassFromString(@"CNContactStore") != nil){
        return (id)[[ContactsPerson alloc] initWithFirstName:firstName];
    } else {
        return (id)[[AddressBookPerson alloc] initWithFirstName:firstName];
    }
}

- (NSString *)firstName {
    SubclassResponsibility();
}

@end
