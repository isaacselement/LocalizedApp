#import "ISTableView.h"
#import "AppInterface.h"

@implementation ISTableView
{
    NSInteger editingRow ;
    NSInteger editingColumn ;
}


- (BOOL)textShouldEndEditing:(NSText *)textObject {
    NSString* changedText = [textObject.string copy];
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    NSString* editingKey = [allLocalizeKeys objectAtIndex: editingRow];
    
    // modified key
    if (editingColumn == 0) {
        NSString* changedKey = changedText;
        BOOL isSuccess = [GLOBAL changeKeyInAllFileContents: editingKey newKey:changedKey];
        if (! isSuccess) {
            NSRunAlertPanel(@"Error", @"Duplicated key", @"OK", nil, nil);
        }
        
    // modified content
    } else {
        
        NSString* changedContent = changedText;
        NSTableColumn* tableColumn = [self.tableColumns objectAtIndex: editingColumn];
        [GLOBAL changeContentInFile: tableColumn.identifier newContent:changedContent forKey:editingKey];
    }
    
    editingRow = editingColumn = -1;
    return YES;
}

- (void)textDidEndEditing:(NSNotification *)notification {
    [self reloadData];
}

- (void)editColumn: (NSInteger)column row:(NSInteger)row withEvent:(NSEvent *)theEvent select:(BOOL)select {
    [super editColumn:column row:row withEvent:theEvent select:select];
	if ([self selectedRow] == -1) {
		NSRunAlertPanel(@"Editor Error", @"No row is selected.", @"OK", nil, nil);
        return;
	}
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    
    // add new key and new contents
    if (row >= allLocalizeKeys.count) {
        NSLog(@"Editing in New row");
        [GLOBAL addNewKeyInAllFileContents];
    }
    
    
    NSTableColumn* tableColumn = [self.tableColumns objectAtIndex: column];
    
    NSString* editingKey = [allLocalizeKeys objectAtIndex: row];
    
    NSLog(@"editColumn (%d, %d)", (int)row , (int)column);
    
    NSString* identifiction = tableColumn.identifier;
    NSLog(@"identification %@ , key %@", identifiction, editingKey);
    
    
    editingRow = row;
    editingColumn = column;
}


- (void)keyUp:(NSEvent *)theEvent {
    
    switch ([theEvent keyCode]) {
        case 123:    // Left arrow
        NSLog(@"Left behind.");
        break;
        case 124:    // Right arrow
        NSLog(@"Right as always!");
        [self getSelectedTextField];
        break;
        case 125:    // Down arrow
        NSLog(@"Downward is Heavenward");
        break;
        case 126:    // Up arrow
        NSLog(@"Up, up, and away!");
        break;
        default:
        break;
    }
    
//    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)getSelectedTextField
{
    NSInteger selected = [self selectedRow];
    
    // Get row at specified index
    NSTableCellView *selectedRow = [self viewAtColumn:0 row:selected makeIfNecessary:YES];
    
    // Get row's text field
    NSTextField *selectedRowTextField = [selectedRow textField];
    NSLog(@"%@ , %@", selectedRow, selectedRowTextField);
    if (selectedRowTextField) [selectedRowTextField becomeFirstResponder];
    
    // Focus on text field to make it auto-editable
//    [[self window] makeFirstResponder:selectedRowTextField];
//    
//    // Set the keyboard carat to the beginning of the text field
//    [[selectedRowTextField currentEditor] setSelectedRange:NSMakeRange(0, 0)];
}



@end
