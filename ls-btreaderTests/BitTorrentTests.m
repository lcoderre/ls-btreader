//
//  BitTorrentTests.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-13.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BitTorrent.h"
@interface BitTorrentTests : XCTestCase

@end

@implementation BitTorrentTests

- (void) testSingleTracker {
    NSDictionary* input = @{
                            @"announce": @"SingleAnnouncer"
                            };
    BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:input];
    
    XCTAssert(bt.urlTrackers.count == 1);
    XCTAssert([bt.urlTrackers isEqual:@[@"SingleAnnouncer"]]);
}

- (void) testManyTrackers {
    NSArray* inputArray = @[@"SingleAnnouncer", @"anotherAnnouncer"];
    NSDictionary* input = @{
                            @"announce-list": inputArray
                            };
    BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:input];
    
    XCTAssert(bt.urlTrackers.count == 2);
    XCTAssert([bt.urlTrackers isEqual:inputArray]);
}


- (void) testCreator {
    NSDictionary* input = @{
                            @"created by": @"moé"
                            };
    BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:input];
    
    XCTAssert([bt.createdBy isEqual:@"moé"]);
    XCTAssert([[BitTorrent initWithTorrentInfoDictionary:@{}] createdBy] == nil);
    XCTAssert([[BitTorrent initWithTorrentInfoDictionary:@{@"created by": @""}].createdBy isEqualToString:@""]);
}

- (void) testTorrentName {
    NSDictionary* input = @{
                            @"info": @{
                                    @"name": @"un beau nom"
                                    
                                    }
                            };
    BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:input];
    
    XCTAssert([bt.torrentName isEqualToString:@"un beau nom"]);
    XCTAssertThrows([BitTorrent initWithTorrentInfoDictionary:@{}].torrentName); // No info dict
    }

@end 
