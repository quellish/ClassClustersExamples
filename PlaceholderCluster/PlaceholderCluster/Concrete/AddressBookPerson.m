//
//  AddressBookPerson.m
//  CustomInitializationCluster
//
//  Created by Dan Zinngrabe on 9/28/15.
//  Copyright © 2015 Dan Zinngrabe. All rights reserved.
//

#import "AddressBookPerson.h"

@implementation AddressBookPerson
@synthesize firstName   =   _firstName;

- (instancetype) initWithFirstName:(NSString *)firstName {
    // Calling the designated initializer in this example would cause an endless loop.
    if (self = [super init]){
        _firstName = [firstName copy];
    }
    return self;
}

@end
