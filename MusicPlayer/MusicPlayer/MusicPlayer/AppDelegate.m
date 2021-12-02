//
//  Author: Li Ju 
//  ID: 201298156  x7lj
//  AppDelegate.m
//  MusicPlayer
//
//  Created by Li Ju on 03/05/2018.
//  Copyright © 2018 Li Ju. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

// Create an outlet to a NSWindow
@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate {
    // Variable declaration
    NSArray *listItems;
    NSString *artist, *album, *track;
    int trackNumber;
    BOOL hideList;
}


/* 
 To initialize the application, the list of albums and cancel button in the search field
 is hidden. Finally, configure the tableView and set a default cover
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    hideList = true;
    [_trackList setHidden:hideList];
    [_searchCell setCancelButtonCell:nil];
    _trackTable.delegate = self;
    _trackTable.dataSource = self;
    [_trackTable setDoubleAction:@selector(doubleClick:)];
    [_cover setImage:[NSImage imageNamed:@"DefaultCover"]];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


/*
 applicationDidUpdate method will be called once the application objects updates
 the window. The method is used to monitor the current track number at any time.
 */
- (void)applicationDidUpdate:(NSNotification *)aNotification {
    /*
     When the current track is not in the album, play button, search field and buttons
     moving through tracks will be disbled.
     */
    if (trackNumber < 2) {
        _searchTrack.enabled = NO;
        _play.enabled = NO;
        _previousTrack.enabled = NO;
        _nextTrack.enabled = NO;
    } else {
        _play.enabled = YES; // Enable play button
        _searchTrack.enabled = YES; // Enable search field
        
        /*
         When there is only one track in the album, the button going through tracks
         will be both disbled.
         */
        if (trackNumber == 2 && [listItems count] == 3) {
            _previousTrack.enabled = NO;
            _nextTrack.enabled = NO;
        }
        
        /*
         When the current track is the first one in the album, the button going to the
         previous track will be disbled.
         */
        if (trackNumber == 2 && [listItems count] > 3) {
            _previousTrack.enabled = NO;
            _nextTrack.enabled = YES;
        }
        
        /*
         When the current track is in the album, but not the first or the last one, buttons
         moving through tracks will be enabled.
         */
        if ( trackNumber > 2 && trackNumber < (listItems.count - 1)) {
            _previousTrack.enabled = YES;
            _nextTrack.enabled = YES;
        }
        
        /*
         When the current track is the last one in the album, the button going to the
         next track will be disbled.
         */
        if (trackNumber != 2 && trackNumber == listItems.count - 1) {
            _previousTrack.enabled = YES;
            _nextTrack.enabled = NO;
        }
    }
}


/*
 Once the table view is double clicked, the selected row will be got and the relative
 track name will be displayed.
 */
- (void)doubleClick:(id)nid{
    NSInteger row = [_trackTable clickedRow];
    [_trackName setStringValue: [listItems objectAtIndex: row + 2]];
    trackNumber = (int)row + 2; // Update the track number
}


/*
 Once an editable text ends an editing session, the method will check whether the input is
 a valid integer. If the input is valid, the relative track name will be displayed on the screen.
 */
- (void)controlTextDidEndEditing:(NSNotification *)obj {
    // Get a string input
    NSString *input = [_searchTrack stringValue];
    BOOL validInt = true;
    
    // Check whether the input is empty or not
    if (![input isEqualToString:@""]) {
        // Check whether the input can be converted into an integer
        for (int i = 0; i < [input length]; i++) {
            if (!isdigit([input characterAtIndex:i])) {
                
                // Create an NSAlert to alert users that the input is invalid
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"Alert";
                alert.informativeText = @"Input is not a valid integer!";
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
                [_searchTrack setIntValue:trackNumber - 1];
                validInt = false;
                break;
            }
        }
        
        // Check whether the input is a valid integer
        if (validInt) {
            int inputNum = [input intValue] + 1;
            
            // Check whether the track users have selected is out of bounds or not
            if (inputNum >= 2 && inputNum <= listItems.count - 1) {
                
                // Display a relative track name
                trackNumber = inputNum;
                [_trackName setStringValue:[listItems objectAtIndex:trackNumber]];
            } else {
                
                // Create an NSAlert to alert users that the input index is out of bounds
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"Alert";
                alert.informativeText = @"Index out of bounds!";
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
            }
        }
    }
}


// Returns the number of records managed for a table view
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return listItems.count - 2;
}


// Create and configure cells displayed in tableView
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    // Get the existing identifiers
    NSString *identifier = [tableColumn identifier];
    
    // Get an cell with existing identifiers
    NSTableCellView *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    
    // If the identifier equals to 'number', a serial of indexes will be inserted into text fields.
    if ([identifier isEqualToString:@"number"]) {
        [cell.textField setStringValue:[@(row+1) stringValue]];
    }
    
    // If the identifier equals to 'trackName', the name of the track related to the row will be inserted into text fields
    if ([identifier isEqualToString:@"trackName"]) {
        [cell.textField setStringValue: [listItems objectAtIndex:row + 2]];
    }
    return cell;
}


// Go to the next track in the album
- (IBAction)nextTrack:(NSButton *)sender {
    if (trackNumber < listItems.count - 1) {
        track = [listItems objectAtIndex: ++trackNumber];
        [_trackName setStringValue:track]; // Display the track name
    }
}


// Go to the previous track in the album
- (IBAction)previousTrack:(NSButton *)sender {
    if (trackNumber > 2) {
        track = [listItems objectAtIndex: --trackNumber];
        [_trackName setStringValue:track]; // Display the track name
    }
}


// Switch between the track list and the album cover
- (IBAction)switchView:(NSButton *)sender {
    hideList = !hideList;
    [_trackList setHidden:hideList];
}


// Display the current volumn changed by a volumn slider
- (IBAction)displayVolumn:(NSSlider *)sender {
    int value = [_volumnSlider intValue]; // Get the value of an NSSlider
    [_volumn setIntValue:value]; // Display the current volumn
}


// Load a new album and the album cover
- (IBAction)loadTrack:(NSButton *)sender {
    // Allow users to select a file
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    // Check whether the OK button has been pressed after running the panel
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        
        // Get the address and the path extension of a selected file
        NSURL *albumURL = [panel URL];
        NSString *fileExt = [albumURL pathExtension];
        
        // Check whether the selected file is a text file or not
        if ([fileExt isEqual:@"txt"]) {
            /*
             Get the content of that file as a string, after checking whether the content is empty,
             remove the new line at the head and the end of the file. Then, remove all '\r' and
             seperated the string into an NSArray according to '\n'
             */
            NSString *info = [NSString stringWithContentsOfURL: albumURL encoding: NSASCIIStringEncoding error: NULL];
            if (![info isEqualToString:@""]) {
                info = [info stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                info = [info stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                listItems = [info componentsSeparatedByString:@"\n"];
                
                // Initialize the variables artist, album and track by getting the first three items in the array
                if ([listItems count] >= 3) {
                    trackNumber = 2;
                    artist = [listItems objectAtIndex:0];
                    album = [listItems objectAtIndex:1];
                    track = [listItems objectAtIndex:2];
                    [_artistName setStringValue:artist];
                    [_albumTitle setStringValue:album];
                    [_trackName setStringValue:track];
                    
                    // Reload the rows and sections of the table view
                    [_trackTable reloadData];
                    
                    // Once loading a new album, the NSImage will be initialized to be nil
                    NSImage *coverImage = nil;
                    
                    // An NSImage for displaying the album cover
                    coverImage = [[NSImage alloc] initWithContentsOfURL: [albumURL URLByAppendingPathExtension:@"jpg"]];
                    
                    // Check whether the NSImage object is empty or not
                    if (coverImage != nil) {
                        // Set the NSImage into the image view
                        [_cover setImage:coverImage];
                    } else {
                        // Set the default cover if the NSImage is empty
                        [_cover setImage:[NSImage imageNamed:@"DefaultCover"]];
                        
                        // Create an NSAlert to alert people that the relative .jpg file cannot be found
                        NSAlert *alert = [[NSAlert alloc] init];
                        alert.messageText = @"Sorry";
                        alert.informativeText = @"Can not find the relative .jpg file.";
                        [alert addButtonWithTitle:@"OK"];
                        [alert runModal];
                    }
                } else {
                    // Create an NSAlert to alert people that selected file is empty
                    NSAlert *alert = [[NSAlert alloc] init];
                    alert.messageText = @"Alert";
                    alert.informativeText = @"There is no track in the selected file!";
                    [alert addButtonWithTitle:@"OK"];
                    [alert runModal];
                }
            } else {
                // Create an NSAlert to alert people that selected file is empty
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"Alert";
                alert.informativeText = @"The selected file cannot be empty!";
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
            }
        } else {
            // Create an NSAlert to alert people that selected file is in wrong format
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"Alert";
            alert.informativeText = @"The selected file should be .txt file!";
            [alert addButtonWithTitle:@"OK"];
            [alert runModal];
        }
    }
}

@end
