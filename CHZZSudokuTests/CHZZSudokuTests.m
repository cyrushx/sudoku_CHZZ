//
//  CHZZSudokuTests.m
//  CHZZSudokuTests
//
//  Created by Cyrus Huang on 9/17/14.
//  Copyright (c) 2014 Cyrus Huang, Zehao Zhang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CHZZGridModel.h"

@interface CHZZSudokuTests : XCTestCase
{
    CHZZGridModel* _gridModel;
}

@end

@implementation CHZZSudokuTests


- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _gridModel = [[CHZZGridModel alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGet
{
    XCTAssertTrue([_gridModel getValueAtRow:0 colum:0] == 7, @"check top left corner");
    XCTAssertTrue([_gridModel getValueAtRow:5 colum:4] == 4, @"check a random place");
}

- (void)testSetAtBlankCell
{
    [_gridModel setValueAtRow:0 colum:1 to:3];
    XCTAssertTrue([_gridModel getValueAtRow:0 colum:1] == 3, @"check setting value");
}

- (void)testNonMutable
{
    XCTAssertTrue([_gridModel isMutableAtRow:0 colum:0] == NO, @"check nonmutable cell");
}

- (void)testMutable
{
    XCTAssertTrue([_gridModel isMutableAtRow:0 colum:1] == YES, @"check mutable cell");
}

- (void)testConsistent
{
    XCTAssertTrue([_gridModel isConsistentAtRow:0 colum:1 for:3] == YES, @"check consistency");
}

- (void)testNonConsistent
{
    XCTAssertTrue([_gridModel isConsistentAtRow:0 colum:1 for:7] == NO, @"check inconsistency in row");
    XCTAssertTrue([_gridModel isConsistentAtRow:0 colum:1 for:1] == NO, @"check inconsistency in col");
    XCTAssertTrue([_gridModel isConsistentAtRow:1 colum:1 for:7] == NO, @"check inconsistency in block");
}




@end
