#import "ISTableView.h"
#import "AppInterface.h"

#define NEW_KEY  @"zz--"

@interface ISTableView () {
    NSInteger editingRow ;
    NSInteger editingColumn ;
}

@end

@implementation ISTableView


- (BOOL)textShouldEndEditing:(NSText *)textObject {
    NSString* changedText = [textObject.string copy];
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    NSMutableDictionary* allFileContents = GLOBAL.allFileContents ;
    
    NSTableColumn* tableColumn = [self.tableColumns objectAtIndex: editingColumn];
    NSString* identifiction = tableColumn.identifier;
    
    NSString* editingKey = [allLocalizeKeys objectAtIndex: editingRow];
    
    // modified key
    if (editingColumn == 0) {
        
        if ([allLocalizeKeys containsObject: changedText]) {
            NSRunAlertPanel(@"Error", @"Duplicated key", @"OK", nil, nil);
        } else {
            // modified key . change all the keys-values
            [allLocalizeKeys replaceObjectAtIndex:editingRow withObject:changedText];
            for (NSString* key in allFileContents) {
                NSMutableDictionary* content = [allFileContents objectForKey:key];
                id value = [content objectForKey: editingKey];
                [content setObject: value forKey:changedText];
                [content removeObjectForKey: editingKey];
            }
        }
        
    // modified content
    } else {
        
        NSMutableDictionary* contents = [allFileContents objectForKey: identifiction];
        [contents setObject: changedText forKey:editingKey];
        
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
    NSMutableDictionary* allFileContents = GLOBAL.allFileContents ;
    
    if (row >= allLocalizeKeys.count) {
        NSLog(@"Editing in New row");
        // add key . change all the keys-values
        [allLocalizeKeys addObject: NEW_KEY];
        for (NSString* key in allFileContents) {
            NSMutableDictionary* content = [allFileContents objectForKey:key];
            [content setObject:NEW_KEY forKey:NEW_KEY];
        }
    }
    
    
    NSArray* tableColumns = self.tableColumns;
    NSTableColumn* tableColumn = [tableColumns objectAtIndex: column];
    NSString* identifiction = tableColumn.identifier;
    
    NSString* editingKey = [allLocalizeKeys objectAtIndex: row];
    
    NSLog(@"editColumn (%d, %d)", (int)row , (int)column);
    NSLog(@"identification %@ , key %@", identifiction, editingKey);
    
    
    editingRow = row;
    editingColumn = column;
}



@end
