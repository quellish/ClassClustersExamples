//
//  CustomInitializationClusterTests.m
//  CustomInitializationClusterTests
//
//  Created by Dan Zinngrabe on 9/28/15.
//  Copyright © 2015 Dan Zinngrabe. All rights reserved.
//

@import XCTest;
@import CustomInitializationCluster;

@interface CustomInitializationClusterTests : XCTestCase

@end

@implementation CustomInitializationClusterTests

- (void) testCanInstantiatePerson {
    XCTAssertNoThrow([[Person alloc] initWithFirstName:@"Bob"], @"Instantiating a Person threw exception");
}

- (void) testReadingPersonFirstNameDoesNotThrowException {
    Person  *testPerson = nil;
    
    testPerson = [[Person alloc] initWithFirstName:@"Bob"];
    XCTAssertNoThrow([testPerson firstName], @"Accessing property firstName threw exception");
}

- (void) testReadingPersonFirstNameReturnsExpectedValue {
    Person  *testPerson = nil;
    
    testPerson = [[Person alloc] initWithFirstName:@"Bob"];
    XCTAssertTrue([[testPerson firstName] isEqualToString:@"Bob"], @"Bob is not himself today");
}

@end
