//
//  Shopping2ShowTransferDialog.h
//  FlameDragon
//
//  Created by sui toney on 12-9-13.
//  Copyright 2012 ms. All rights reserved.
//

#import "cocos2d.h"
#import "Shopping2ScrollDialog.h"

@interface Shopping2ShowTransferDialog : Shopping2ScrollDialog {
	
	NSMutableArray *transferList;
	
}

-(id) initWithFriends:(NSMutableArray *)list pageIndex:(int)pIndex;

@end