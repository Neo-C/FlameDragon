//
//  SelectMagicTargetState.m
//  FlameDragon
//
//  Created by sui toney on 11-11-16.
//  Copyright 2011 ms. All rights reserved.
//

#import "SelectMagicTargetState.h"
#import "SelectTransferPositionState.h"
#import "FDEnemy.h"
#import "DataDepot.h"

@implementation SelectMagicTargetState

-(id) initWithLayers:(ActionLayers *)ls Friend:(FDFriend *)frien MagicIndex:(int)m
{
	self = [super initWithLayers:ls];
	
	currentFriend = frien;
	magicIndex = m;
	
	return self;
}

-(void) clickedOn:(CGPoint)location
{
	CGPoint position = [field convertLocToPos:[field getMapLocationbyScreen:location]];
	
	if (![FDPosition isEqual:[field getCursorPos] With:position])
	{
		// Set cursor to current position
		[field setCursorTo:position];
	}
	else
	{
		if ([field isInScope:position])
		{
			int magicId = [[currentFriend.data.magicList objectAtIndex:magicIndex] intValue];
			MagicDefinition *magic = [[DataDepot depot] getMagicDefinition:magicId];
			
			NSMutableArray *targetSet = [field getCreaturesAt:position Range:magic.effectRange 
											  BadGuys:(magic.magicType == MagicType_Attack || magic.magicType == MagicType_Offensive)];
			// Transport magic cannot tranport himself/herself
			if ([targetSet count] > 0 && !(magic.identifier == 501 && [[targetSet objectAtIndex:0] getIdentifier] == [currentFriend getIdentifier])) {
				
                [field removeAllIndicators];
                [field setCursorSize:1];
                
                // Special for Transfer Magic
                if (magic.identifier == 501) {
                
                    nextState = [[SelectTransferPositionState alloc] initWithLayers:layers Friend:currentFriend Creature:[targetSet objectAtIndex:0]];
                    
                } else {
                    
                    [layers magicFrom:currentFriend TargetPos:position Id:magicId];
				
                    isFinished = TRUE;
                    shouldDispose = TRUE;
                }
			}
			else
			{
				// Do nothing
			}

		}
		else {
			// Cancel the state
			[field removeAllIndicators];
            [field setCursorSize:1];
			shouldDispose = TRUE;
		}
	}
}

-(void) pressLeft
{
}

-(void) pressRight
{
}

-(void) pressUp
{
}

-(void) pressDown
{
}

-(void) pressOk
{
}

-(void) pressCancel
{
}

-(void) consume:(id)value
{
	
}

-(void) resumeState
{
	
}


@end
