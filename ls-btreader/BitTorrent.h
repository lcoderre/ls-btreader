//
//  BitTorrent.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-12.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#ifndef BitTorrent_h
#define BitTorrent_h

#import "Bencode.h"

@interface BitTorrent : NSObject
@property NSDictionary* torrentInfo;

+ (BitTorrent*) initWithTorrentInfoDictionary: (NSDictionary*) dict ;

- (NSArray *) urlTrackers ;
- (NSString *) torrentName ;
- (NSDate *) creationDate ;
- (NSString *) createdBy ;
- (NSArray *) files;
- (NSNumber *) pieceLength ;
- (NSArray *) pieces ;

- (NSString* ) availableInfos;

@end



#endif /* BitTorrent_h */
