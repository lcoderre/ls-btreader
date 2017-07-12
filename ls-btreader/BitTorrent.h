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
- (NSNumber *) pieceLength ;
- (NSArray *) pieces ;

@end


@implementation BitTorrent



+ (BitTorrent*) initWithTorrentInfoDictionary: (NSDictionary*) dict {
    BitTorrent* bt = [[BitTorrent alloc] init];
    bt.torrentInfo = dict;
    return bt;
}

- (NSArray*) urlTrackers {
    NSArray* announceList = [self.torrentInfo objectForKey:@"announce-list"];
    
    if (announceList != nil) {
        return announceList;
    } else {
        NSString* announce = [self.torrentInfo objectForKey:@"announce"];
        if (announce != nil) {
            return [NSArray arrayWithObject:announce];
        }
    }

    NSLog(@"THROW? No announce or announce-list in torrent info dictionary");
    return nil;
}

- (NSString*) torrentName {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSString* name = [infoDict objectForKey:@"name"];
        
        if (name != nil) {
            return name;
        } else {
            NSLog(@"THROW? No 'name' key-value in 'info' dictionary");
        }
    } else {
        NSLog(@"THROW? No 'info' dictionary");
    }
    
    return nil;
}

- (NSDate*) creationDate {
    NSNumber* creationTimestamp = [self.torrentInfo objectForKey:@"creation date"];
    
    if (creationTimestamp != nil) {
        
        NSDate* creationDate = [NSDate dateWithTimeIntervalSince1970:creationTimestamp.doubleValue];
        
        if (creationDate != nil) {
            return creationDate;
        } else {
            NSLog(@"THROW? Could not make a NSDate from value %@", creationTimestamp);
        }
    } else {
        NSLog(@"THROW? No 'creation date' key-value");
    }
    
    return nil;
}

- (NSNumber *) pieceLength {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSNumber* pieceLength = [infoDict objectForKey:@"piece length"];
        
        if (pieceLength != nil) {
            return pieceLength;
        } else {
            NSLog(@"THROW? No 'piece length' key-value in 'info' dictionary");
        }
    } else {
        NSLog(@"THROW? No 'info' dictionary");
    }
    
    return nil;
}

- (NSArray *) pieces {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSString* bigPiece = [infoDict objectForKey:@"pieces"];
        
        if (bigPiece != nil) {
            
            NSArray* pieces = [[NSArray alloc] init];
            
            for (int i=0; i< bigPiece.length / 20; i++) {
                NSString* chunk = [[bigPiece substringFromIndex: i * 20] substringToIndex: 20];
                pieces = [pieces arrayByAddingObject:chunk];
            }
            
            return pieces;
        } else {
            NSLog(@"THROW? No 'pieces' key-value in 'info' dictionary");
        }
    } else {
        NSLog(@"THROW? No 'info' dictionary");
    }
    
    return nil;
}


@end

#endif /* BitTorrent_h */
