//
//  ViewController.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-11.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import "ViewController.h"

#import "FileReader.h"
#import "BitTorrent.h"
#import "MetaInfoView.h"

@interface ViewController()

@property (strong, nonatomic) MetaInfoView* infoView;
@property (strong, nonatomic) NSButton* selectionButton;
@end


@implementation ViewController 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectionButton = [[NSButton alloc] init];
    
    [self.view addSubview:_selectionButton];
    [_selectionButton setTitle:@"Select file"];
    [_selectionButton setTarget:self];
    [_selectionButton setAction:@selector(selectFile)];
    
    _infoView = [[MetaInfoView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_infoView];
    
    [self.view setNeedsLayout:YES];
}

- (void) viewWillLayout {
    [super viewWillLayout];
    
    CGRect frame = CGRectMake(10, 10, 70, 25);
    [_selectionButton setFrame:frame];
    
    [_infoView setFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 80)];
}


- (void) selectFile {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        NSURL *url = [panel URL];
        
        NSString* contents = [[[FileReader alloc] init] stringContentsAtFilepath:url.path];
        
        id dict = [BencodeParser parseString:contents].element;
        
        BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:dict];
        
        [self.infoView refreshWithTorrentInfo:bt];
//        [self.textView setString:[bt availableInfos]];
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


@end
