//
//  MetaInfoView.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-13.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#ifndef MetaInfoView_h
#define MetaInfoView_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "BitTorrent.h"

@interface MetaInfoView : NSView

- (void) refreshWithTorrentInfo: (BitTorrent*) bt;
@end

#endif /* MetaInfoView_h */
