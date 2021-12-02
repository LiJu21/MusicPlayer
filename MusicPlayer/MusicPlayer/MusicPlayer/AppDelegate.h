//
//  Author: Li Ju 
//  ID: 201298156  x7lj
//  AppDelegate.h
//  MusicPlayer
//
//  Created by Li Ju on 03/05/2018.
//  Copyright © 2018 Li Ju. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

// Declare outlets as properties of some objects
// Holds a album cover
@property (weak) IBOutlet NSImageView *cover;

// A search field to search for a track
@property (weak) IBOutlet NSSearchField *searchTrack;

// A volumn slider to control volumn
@property (weak) IBOutlet NSSlider *volumnSlider;

// A text field denoting the track name
@property (weak) IBOutlet NSTextField *trackName;

// A text field denoting the artist name
@property (weak) IBOutlet NSTextField *artistName;

// A text field denoting the album title
@property (weak) IBOutlet NSTextField *albumTitle;

// Display a list of the album
@property (weak) IBOutlet NSScrollView *trackList;

// A table view inside the scroll view
@property (weak) IBOutlet NSTableView *trackTable;

// A text field denoting the volumn
@property (weak) IBOutlet NSTextField *volumn;

// The button going to the next track
@property (weak) IBOutlet NSButton *nextTrack;

// The button going to the previous track
@property (weak) IBOutlet NSButton *previousTrack;

// Denote cells inside the search field
@property (weak) IBOutlet NSSearchFieldCell *searchCell;

// The button playing the track
@property (weak) IBOutlet NSButton *play;

// The Like button used to show users' preferences
@property (weak) IBOutlet NSButton *like;


// IBAction declaration exposing the method as a connection between UI elements and codes
// Declare a method going to the next track
- (IBAction)nextTrack:(NSButton *)sender;

// Declare a method going to the previous track
- (IBAction)previousTrack:(NSButton *)sender;

// Declare a method switching between the list of the album and the album cover
- (IBAction)switchView:(NSButton *)sender;

// Declare a method loading a new album
- (IBAction)loadTrack:(NSButton *)sender;

// Declare a method displaying volumn
- (IBAction)displayVolumn:(NSSlider *)sender;


@end

