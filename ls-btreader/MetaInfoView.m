//
//  MetaInfoView.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-13.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import "MetaInfoView.h"

@interface MetaInfoView()

@property (strong, nonatomic) NSTextField* torrentNameTitle;
@property (strong, nonatomic) NSTextField* creationDateTitle;
@property (strong, nonatomic) NSTextField* creatorTitle;
@property (strong, nonatomic) NSTextField* urlTrackersTitle;
@property (strong, nonatomic) NSTextField* pieceLengthTitle;
@property (strong, nonatomic) NSTextField* piecesTitle;
@property (strong, nonatomic) NSTextField* filesTitle;

@property (strong, nonatomic) NSTextField* torrentName;
@property (strong, nonatomic) NSTextField* creationDate;
@property (strong, nonatomic) NSTextField* creator;
@property (strong, nonatomic) NSTextView* urlTrackers;
@property (strong, nonatomic) NSTextField* pieceLength;
@property (strong, nonatomic) NSTextView* pieces;
@property (strong, nonatomic) NSTextView* files;

@end


@implementation MetaInfoView

- (NSTextField*) createLabelWithTitle: (NSString*) title{
    NSTextField* label = [[NSTextField alloc] init];
    [label setStringValue:title];
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    
    return label;
}

- (NSTextView*) createTextView {
    NSTextView* tv = [[NSTextView alloc] init];
    [tv setEditable:NO];
    [tv setString:@" - "];
    
    return tv;
}


- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _torrentNameTitle = [self createLabelWithTitle:@"Torrent Name:"];
        _creationDateTitle = [self createLabelWithTitle:@"Creation Date:"];
        _creatorTitle = [self createLabelWithTitle:@"Creator:"];
        _urlTrackersTitle = [self createLabelWithTitle:@"Trackers:"];
        _pieceLengthTitle = [self createLabelWithTitle:@"Piece Length:"];
        _piecesTitle = [self createLabelWithTitle:@"Pieces"];
        _filesTitle = [self createLabelWithTitle:@"Files"];
        
        _torrentName = [self createLabelWithTitle:@" - "];
        _creationDate = [self createLabelWithTitle:@" - "];
        _creator = [self createLabelWithTitle:@" - "];
        _urlTrackers = [self createTextView];
        _pieceLength = [self createLabelWithTitle:@" - "];
        _pieces = [self createTextView];
        _files = [self createTextView];
        
        [self addSubview:_torrentNameTitle];
        [self addSubview:_creationDateTitle];
        [self addSubview:_creatorTitle];
        [self addSubview:_urlTrackersTitle];
        [self addSubview:_pieceLengthTitle];
        [self addSubview:_piecesTitle];
        [self addSubview:_filesTitle];
        [self addSubview:_torrentName];
        [self addSubview:_creationDate];
        [self addSubview:_creator];
        [self addSubview:_urlTrackers];
        [self addSubview:_pieceLength];
        [self addSubview:_pieces];
        [self addSubview:_files];
    }
    return self;
}

- (BOOL) isFlipped { // THANK GOD!
    return YES;
}

- (CGFloat) offsetUnderView: (NSView*) view {
    return view.frame.origin.y + view.frame.size.height + 10;
}

- (CGFloat) offsetRightOfView: (NSView*) view {
    return view.frame.origin.x + view.frame.size.width + 10;
}


- (void) setView: (NSTextField*) viewA Under: (NSView*) viewB {
    [viewA sizeToFit];
    [viewA setFrameOrigin:CGPointMake(viewB.frame.origin.x, viewB.frame.origin.y + viewB.frame.size.height + 10)];
}

- (void) setView: (NSTextField*) viewA rightOf: (NSView*) viewB {
    [viewA sizeToFit];
    [viewA setFrameOrigin:CGPointMake(viewB.frame.origin.x + viewB.frame.size.width + 10, viewB.frame.origin.y)];
}

- (void) layout {
    [super layout];
    
    CGFloat xOff = 10;
    CGFloat yOff = 10;
    
    [_torrentNameTitle sizeToFit];
    [_torrentNameTitle setFrameOrigin:CGPointMake(xOff, yOff)];
    
    [self setView:_torrentName rightOf:_torrentNameTitle];
    
    [self setView:_creationDateTitle Under:_torrentNameTitle];
    
    [self setView:_creationDate rightOf:_creationDateTitle];
    
    [self setView:_creatorTitle Under:_creationDateTitle];
    [self setView:_creator rightOf:_creatorTitle];

    [self setView:_urlTrackersTitle Under:_creatorTitle];

    [_urlTrackers setFrame:CGRectMake(_urlTrackersTitle.frame.origin.x + _urlTrackersTitle.frame.size.width + 10,
                                      _urlTrackersTitle.frame.origin.y,
                                      self.bounds.size.width * 0.75,
                                      180)]; // Will be overridden by the following sizeToFit

    [_urlTrackers sizeToFit];
    
    
    [_pieceLengthTitle sizeToFit];
    [_pieceLengthTitle setFrameOrigin:CGPointMake(xOff, _urlTrackers.frame.origin.y + _urlTrackers.frame.size.height + 10)];
    
    [self setView:_pieceLength rightOf:_pieceLengthTitle];
    
    [self setView:_filesTitle Under:_pieceLengthTitle];
    [_files setFrame:CGRectMake(_filesTitle.frame.origin.x,
                                _filesTitle.frame.origin.y + _filesTitle.frame.size.height + 10,
                                self.bounds.size.width * 0.5,
                                180)]; // Will be overridden by the following sizeToFit
    
    [_files sizeToFit];
    
    [_pieces setFrame:CGRectMake(_files.frame.origin.x + _files.frame.size.width + 10,
                                _files.frame.origin.y,
                                self.bounds.size.width * 0.25,
                                180)]; // Will be overridden by the following sizeToFit
    
    [_pieces sizeToFit];

    [_piecesTitle sizeToFit];
    [_piecesTitle setFrameOrigin:CGPointMake(_pieces.frame.origin.x, _filesTitle.frame.origin.y)];

}

- (void) refreshWithTorrentInfo: (BitTorrent*) bt {
    
    [_torrentName setStringValue: bt.torrentName ? bt.torrentName : @" - " ];
    [_creationDate setStringValue: bt.creationDate ? [NSString stringWithFormat:@"%@", bt.creationDate] : @" - " ];
    [_creator setStringValue:  bt.createdBy ? bt.createdBy : @" - " ];
    [_urlTrackers setString:[bt.urlTrackers componentsJoinedByString:@"\n"]];
    [_pieceLength setStringValue: bt.pieceLength ? [NSString stringWithFormat:@"%@ (bytes)", bt.pieceLength] : @" - " ];
    
    if (bt.files && bt.files.count > 0) {
        NSString* filesString = @"";
        for (NSDictionary* fileDict in bt.files) {
            NSString* path = [fileDict valueForKey:@"path"];
            NSNumber* bytes = [fileDict valueForKey:@"length"];
            
            filesString = [filesString stringByAppendingString:[NSString stringWithFormat:@"(%@ bytes):\n%@",bytes, path]];
            
            filesString = [filesString stringByAppendingString:@"\n\n"];
        }
        
        [_files setString:filesString];
    } else {
        [_files setString:@" - "];
    }
    
    if (bt.pieces && bt.pieces.count > 0) {
        NSString* piecesString = [bt.pieces componentsJoinedByString:@"\n"];
        

        [_pieces setString:piecesString];
    } else {
        [_pieces setString:@" - "];
    }
    
    
    [self layout];
}

@end
