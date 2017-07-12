//
//  AppDelegate.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-11.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import "AppDelegate.h"
#import "FileReader.h"
#import "BitTorrent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString* torrentPath = @"/Users/wrench/Desktop/torrents/Influence.torrent";

    NSString* contents = [[[FileReader alloc] init] stringContentsAtFilepath:torrentPath];
    
    
    id dict = [BencodeParser parseString:contents].element;
 
    BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:dict];
    
    NSLog([bt availableInfos]);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
