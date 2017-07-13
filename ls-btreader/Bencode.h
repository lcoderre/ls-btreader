//
//  BencodeParser.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-11.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#ifndef BencodeParser_h
#define BencodeParser_h


@interface BencodeParser : NSObject

+ (id) decode: (NSString*) input;

@end

#endif /* BencodeParser_h */
