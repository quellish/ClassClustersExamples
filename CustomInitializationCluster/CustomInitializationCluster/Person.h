//
//  Person.h
//  CustomInitializationCluster
//
//  Created by Dan Zinngrabe on 9/28/15.
//  Copyright © 2015 Dan Zinngrabe. All rights reserved.
//

@import Foundation;

@interface Person : NSObject
@property (nonatomic, readonly, copy) NSString  *firstName;

- (instancetype) initWithFirstName:(NSString *)firstName;

@end
