//
//  BencodeTests.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-13.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Bencode.h"
    //ed13:announce-listll40:udp://tracker.leechers-paradise.org:6969eel21:udp://zer0day.ch:1337el27:udp://open.demonii.com:1337el34:udp://tracker.coppersurfer.tk:6969el28:udp://exodus.desync.com:6969ee11:magnet-infod12:display-name38:Waves+Complete+2017.07.10+macOS+[dada]9:info_hash20:1 ql¥Ÿ2fˆG¡ÓcH˜8™Àee
@interface BencodeTests : XCTestCase

@end

@implementation BencodeTests


- (void) testString{
    NSString* input = @"11:hello world";
    id sut = [BencodeParser decode:input];
    
    XCTAssert([sut isEqual:@"hello world"]);
}

- (void) testBadString{
    XCTAssertThrows([BencodeParser decode:@"11:hello world04484"]);
    XCTAssertThrows([BencodeParser decode:@"11:hello worl"]);
}

- (void) testInteger{
    NSString* input = @"i-16789e";
    id sut = [BencodeParser decode:input];
    
    XCTAssert([sut isEqual:@-16789]);
}

- (void) testBadInteger{
    XCTAssertThrows([BencodeParser decode:@"i-16789.3e"]);
    XCTAssertThrows([BencodeParser decode:@"i16789.3e"]);
    XCTAssertThrows([BencodeParser decode:@"ai-167893e"]);
    XCTAssertThrows([BencodeParser decode:@"ai-167893efgfh"]);
    XCTAssertThrows([BencodeParser decode:@"i167893efgfh"]);
}


- (void) testLists{
    NSString* input = @"li1ei2ei3ee";
    id sut = [BencodeParser decode:input];
    
    id expect = @[@1,@2,@3];
    XCTAssert([sut isEqual:expect]);
    
    
    // Another form possible: list of list of 1. Flattened.
    XCTAssert([[BencodeParser decode:@"lli1eei2ei3ee"] isEqual:expect]);

}

- (void) testManyTypeLists{
    NSString* input = @"li1ei2e11:hello worlde";
    id sut = [BencodeParser decode:input];
    
    id expect = @[@1,@2,@"hello world"];
    XCTAssert([sut isEqual:expect]);
}

- (void) testBadList{
    XCTAssertThrows([BencodeParser decode:@"li1ei2e10:hello worlde"]);
    XCTAssertThrows([BencodeParser decode:@"li1ei2e11:hello world"]);
}


- (void) testDict{
    NSString* input = @"d5:hello5:world5:halloi5ee";
    id sut = [BencodeParser decode:input];
    
    NSDictionary* dictionary = @{
                      @"hello" : @"world",
                      @"hallo" : @5
                      };
    XCTAssert([sut isEqual: dictionary]);
}

- (void) testBadDict{
    XCTAssertThrows([BencodeParser decode:@"d5:helloo5:world5:halloi5ee"]);
    XCTAssertThrows([BencodeParser decode:@"d5:hello5:worlde5:halloi5ee"]);
    XCTAssertThrows([BencodeParser decode:@"d5:hello5:world5:halloi5eee"]);
    XCTAssertThrows([BencodeParser decode:@"d5:hello5:world5:halloi5e"]);
    XCTAssertThrows([BencodeParser decode:@"sd5:hello5:world5:halloi5ee"]);
    XCTAssertThrows([BencodeParser decode:@"d5:hello4:world5:halloi5ee"]);
}
@end
