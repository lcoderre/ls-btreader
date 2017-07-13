//
//  BencodeParser.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-11.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#ifndef BencodeParser_h
#define BencodeParser_h

#import "NSString+Bencode.h"

@interface BencodeParsingResult : NSObject

@property NSString* rest;
@property id element;

- (void) setElement: (id) element Rest:(NSString*) rest;

@end




@interface BencodeParser : NSObject

+ (BencodeParsingResult*) parseString: (NSString*) input;

@end

#endif /* BencodeParser_h */
