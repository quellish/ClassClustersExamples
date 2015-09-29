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
    SubclassResponsibility();
}

- (NSString *)firstName {
    SubclassResponsibility();
}

+ (id) allocWithZone:(struct _NSZone *)__unused zone {
    id      result              = nil;
    Class   clusterClass        = NSClassFromString(@"Person");
    Class   placeholderClass    = nil;
    
    // Don't get into an infinite loop.
    if(self == clusterClass){
        static dispatch_once_t  onceToken    = 0L;
        static id               placeholder  = NULL;
        
        placeholderClass = NSClassFromString(@"PlaceholderPerson");
        dispatch_once(&onceToken, ^{
            placeholder = [placeholderClass alloc];
        });
        result = placeholder;
    } else {
        result = [super allocWithZone:zone];
    }
    return result;
}

@end
