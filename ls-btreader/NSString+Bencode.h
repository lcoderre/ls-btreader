//
//  NSString+Bencode.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-13.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Bencode)
- (bool) startsWith: (unichar) character;
- (NSString*) rest;
- (NSString*) parseFirstStringValue;
- (NSString*) getRestAfterStringValue;
- (NSNumber*) parseFirstIntValue;
- (NSString*) getRestAfterIntValue;

@end
