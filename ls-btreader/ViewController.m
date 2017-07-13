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
@property (strong, nonatomic) NSTextField* errorLabel;
@end


@implementation ViewController 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectionButton = [[NSButton alloc] init];
    _errorLabel = [[NSTextField alloc] init];
    [_errorLabel setBezeled:NO];
    [_errorLabel setDrawsBackground:NO];
    [_errorLabel setEditable:NO];
    [_errorLabel setSelectable:NO];
    [_errorLabel setTextColor:[NSColor colorWithRed:1 green:0 blue:0 alpha:1]];
    
    [self.view addSubview:_selectionButton];
    [_selectionButton setTitle:@"Select file"];
    [_selectionButton setTarget:self];
    [_selectionButton setAction:@selector(selectFile)];
    
    [self.view addSubview:_errorLabel];
    
    _infoView = [[MetaInfoView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_infoView];
    
    [self.view setNeedsLayout:YES];
}

- (void) viewWillLayout {
    [super viewWillLayout];
    
    [_selectionButton setFrame:CGRectMake(10, 10, 70, 25)];
    [_errorLabel setFrame:CGRectMake(90, 10, self.view.bounds.size.width - 100, 25)];
    
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
        
        
        @try {
            NSString* contents = [[[FileReader alloc] init] stringContentsAtFilepath:url.path];
            id dict = [BencodeParser decode:contents];
            BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:dict];
            [self.infoView refreshWithTorrentInfo:bt];
            [_errorLabel setStringValue:@""];
        } @catch (NSException *exception) {
            [_errorLabel setStringValue: [NSString stringWithFormat:@"%@ - %@", exception.name, exception.description]];
        } @finally {
            
        }
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


@end
