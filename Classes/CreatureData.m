//
//  CreatureData.m
//  FlameDragon
//
//  Created by sui toney on 12-3-20.
//  Copyright 2012 ms. All rights reserved.
//

#import "CreatureData.h"
#import "FDPosition.h"
#import "DataDepot.h"
#import "AITreasureParam.h"

@implementation CreatureData

@synthesize magicList, itemList;

@synthesize level,ap,dp,dx,hpCurrent,mpCurrent,hpMax,mpMax,mv,ex;
@synthesize statusEnhanceAp, statusEnhanceDp, statusEnhanceDx, statusFrozen, statusPoisoned, statusProhibited;
@synthesize attackItemIndex, defendItemIndex, dropItemId;
@synthesize aiType;
@synthesize aiParam;
@synthesize bodyStatus;

-(id) init
{
	self = [super init];
	
	itemList = [[NSMutableArray alloc] init];
	magicList = [[NSMutableArray alloc] init];
	
	[self clearAllStatus];
	
	attackItemIndex = -1;
	defendItemIndex = -1;
	
	dropItemId = 0;
	
	return self;
}

+(int) ITEM_MAX
{
	return 8;
}

+(int) MAGIC_MAX
{
	return 12;
}

-(CreatureData *) clone
{
	CreatureData *another = [[CreatureData alloc] init];
	
	another.level = level;
	another.ap = ap;
	another.dp = dp;
	another.dx = dx;
	another.mv = mv;
	another.ex = ex;
	another.hpCurrent = hpCurrent;
	another.mpCurrent = mpCurrent;
	another.hpMax = hpMax;
	another.mpMax = mpMax;
	
	[another.itemList addObjectsFromArray: itemList];
	[another.magicList addObjectsFromArray: magicList];

	another.attackItemIndex = attackItemIndex;
	another.defendItemIndex = defendItemIndex;
	
	another.dropItemId = dropItemId;
	
	another.statusEnhanceAp = statusEnhanceAp;
	another.statusEnhanceDp = statusEnhanceDp;
	another.statusEnhanceDx = statusEnhanceDx;
	another.statusFrozen = statusFrozen;
	another.statusProhibited = statusProhibited;
	another.statusPoisoned = statusPoisoned;
	
	
	//another.bodyStatus = bodyStatus;
	another.aiType = aiType;
	another.aiParam = aiParam;
	
	return [another autorelease];
}

-(void) encodeWithCoder:(NSCoder *)coder {
	
	[coder encodeInt:level forKey:@"level"];
    [coder encodeInt:ap forKey:@"ap"];
    [coder encodeInt:dp forKey:@"dp"];
    [coder encodeInt:dx forKey:@"dx"];
    [coder encodeInt:mv forKey:@"mv"];
    [coder encodeInt:ex forKey:@"ex"];
    [coder encodeInt:hpCurrent forKey:@"hpCurrent"];
    [coder encodeInt:hpMax forKey:@"hpMax"];
    [coder encodeInt:mpCurrent forKey:@"mpCurrent"];
    [coder encodeInt:mpMax forKey:@"mpMax"];
	[coder encodeObject:itemList forKey:@"itemList"];
	[coder encodeObject:magicList forKey:@"magicList"];
	
	[coder encodeInt:statusEnhanceAp forKey:@"statusEnhanceAp"];
	[coder encodeInt:statusEnhanceDp forKey:@"statusEnhanceDp"];
	[coder encodeInt:statusEnhanceDx forKey:@"statusEnhanceDx"];
	[coder encodeInt:statusPoisoned forKey:@"statusPoisoned"];
	[coder encodeInt:statusProhibited forKey:@"statusProhibited"];
	[coder encodeInt:statusFrozen forKey:@"statusFrozen"];
	
	[coder encodeInt:aiType forKey:@"aiType"];
    
    if ([aiParam isKindOfClass:[FDPosition class]]) {
        [coder encodeCGPoint:[(FDPosition *)aiParam posValue] forKey:@"aiParam"];
    }
    else if ([aiParam isKindOfClass:[AITreasureParam class]]) {
        [coder encodeCGPoint:[(AITreasureParam *)aiParam getTreasurePosition] forKey:@"aiParam_tPos"];
        [coder encodeCGPoint:[(AITreasureParam *)aiParam getEscapePosition] forKey:@"aiParam_ePos"];
    }
	[coder encodeInt:attackItemIndex forKey:@"attackItemIndex"];
    [coder encodeInt:defendItemIndex forKey:@"defendItemIndex"];
    
	[coder encodeInt:dropItemId forKey:@"dropItemId"];
    
	// NSLog(@"Encoded CreatureData");

}

-(id) initWithCoder:(NSCoder *)coder {
	
    self = [super init];
	
	level = [coder decodeIntForKey:@"level"];
    ap = [coder decodeIntForKey:@"ap"];
    dp = [coder decodeIntForKey:@"dp"];
    dx = [coder decodeIntForKey:@"dx"];
    mv = [coder decodeIntForKey:@"mv"];
    ex = [coder decodeIntForKey:@"ex"];
    hpCurrent = [coder decodeIntForKey:@"hpCurrent"];
    mpCurrent = [coder decodeIntForKey:@"mpCurrent"];
    hpMax = [coder decodeIntForKey:@"hpMax"];
	mpMax = [coder decodeIntForKey:@"mpMax"];
	
	statusEnhanceAp = [coder decodeIntForKey:@"statusEnhanceAp"];
	statusEnhanceDp = [coder decodeIntForKey:@"statusEnhanceDp"];
	statusEnhanceDx = [coder decodeIntForKey:@"statusEnhanceDx"];
	statusPoisoned =  [coder decodeIntForKey:@"statusPoisoned"];
	statusFrozen =  [coder decodeIntForKey:@"statusFrozen"];
	statusProhibited =  [coder decodeIntForKey:@"statusProhibited"];
	
    aiType = [coder decodeIntForKey:@"aiType"];
    
    if ([coder containsValueForKey:@"aiParam"])
    {
        self.aiParam = [FDPosition position:[coder decodeCGPointForKey:@"aiParam"]];
    }
    else if ([coder containsValueForKey:@"aiParam_tPos"])
    {
        CGPoint tPos = [coder decodeCGPointForKey:@"aiParam_tPos"];
        CGPoint ePos = [coder decodeCGPointForKey:@"aiParam_ePos"];
        AITreasureParam *param = [[AITreasureParam alloc] initWithTreasurePos:tPos escapeTo:ePos];
        self.aiParam = param;
        [param release];
    }
	itemList = [[coder decodeObjectForKey:@"itemList"] retain];
	magicList = [[coder decodeObjectForKey:@"magicList"] retain];
	attackItemIndex = [coder decodeIntForKey:@"attackItemIndex"];
    defendItemIndex = [coder decodeIntForKey:@"defendItemIndex"];
    
    dropItemId = [coder decodeIntForKey:@"dropItemId"];
    
	return self;
}

-(int) calculatedHit
{
	int deltaHit = 0;
	AttackItemDefinition *item = [self getAttackItem];
	if (item != nil && [item isAttackItem]) 
	{
		deltaHit = item.hit;
	}
	
	int total = dx + deltaHit;
	if (statusEnhanceDx > 0) {
		total += 0.15 * total;
	}
	
	return total;
}

-(int) hitWithItem:(int)itemId
{
	int deltaHit = 0;
	AttackItemDefinition *item = (AttackItemDefinition *)[[DataDepot depot] getItemDefinition:itemId];
	if (item != nil && [item isAttackItem]) 
	{
		deltaHit = item.hit;
		return dx + deltaHit;
	}
	else {
		return [self calculatedHit];
	}	
}

-(int) calculatedEv
{
	int deltaEv = 0;
	
	AttackItemDefinition *attackItem = [self getAttackItem];
	if (attackItem != nil && [attackItem isAttackItem]) {
		deltaEv += attackItem.ev;
	}
	
	DefendItemDefinition *defendItem = [self getDefendItem];
	if (defendItem != nil && [defendItem isDefendItem]) {
		deltaEv += defendItem.ev;
	}
	
	int total = dx + deltaEv;
	if (statusEnhanceDx > 0) {
		total += 0.15 * total;
	}
	
	return total;
}

-(int) evWithItem:(int)itemId
{
	int deltaEv = 0;
	
	ItemDefinition *item = [[DataDepot depot] getItemDefinition:itemId];
	AttackItemDefinition *attackItem = [self getAttackItem];
	DefendItemDefinition *defendItem = [self getDefendItem];
	
	if (item != nil) {
		if ([item isAttackItem]) {
			deltaEv = ((AttackItemDefinition *)item).ev;
		}
		if ([item isDefendItem]) {
			deltaEv = ((DefendItemDefinition *)item).ev;
		}
	}
	
	if ((item == nil || ![item isAttackItem]) && attackItem != nil && [attackItem isAttackItem]) {
		deltaEv = attackItem.ev;
	}
	
	if ((item == nil || ![item isDefendItem]) && defendItem != nil && [defendItem isDefendItem]) {
		deltaEv = defendItem.ev;
	}
	
	return dx + deltaEv;	
}

-(int) calculatedAp
{
	int deltaAp = 0;
	
	AttackItemDefinition *attackItem = [self getAttackItem];
	if (attackItem != nil && [attackItem isAttackItem]) {
		deltaAp = attackItem.ap;
	}
	
	int total = ap + deltaAp;
	if (statusEnhanceAp > 0) {
		total += 0.15 * total;
	}
	
	return total;
}

-(int) apWithItem:(int)itemId
{
	AttackItemDefinition *item = (AttackItemDefinition *)[[DataDepot depot] getItemDefinition:itemId];
	int deltaAp = 0;
	
	if (item != nil && [item isAttackItem]) {
		deltaAp = item.ap;
		return deltaAp + ap;
	} else {
		return [self calculatedAp];
	}
}

-(int) calculatedDp
{
	int deltaDp = 0;
	
	DefendItemDefinition *defendItem = [self getDefendItem];
	if (defendItem != nil && [defendItem isDefendItem]) {
		deltaDp = defendItem.dp;
	}
	
	int total = dp + deltaDp;
	if (statusEnhanceDp > 0) {
		total += 0.15 * total;
	}
	
	return total;
}

-(int) dpWithItem:(int)itemId
{
	DefendItemDefinition *item = (DefendItemDefinition *)[[DataDepot depot] getItemDefinition:itemId];
	int deltaDp = 0;
	
	if (item != nil && [item isDefendItem]) {
		deltaDp = item.dp;
		return dp + deltaDp;	
		
	} else {
		return [self calculatedDp];
	}
}

-(AttackItemDefinition *) getAttackItem
{
	if (attackItemIndex >= 0 && attackItemIndex < [itemList count]) {
		int itemId = [[itemList objectAtIndex: attackItemIndex] intValue];
		AttackItemDefinition *def = (AttackItemDefinition *)[[DataDepot depot] getItemDefinition:itemId];
		return def;
	}
	return nil;
}

-(DefendItemDefinition *) getDefendItem
{
	if (defendItemIndex >= 0 && defendItemIndex < [itemList count]) {
		
		int itemId = [[itemList objectAtIndex: defendItemIndex] intValue];
		DefendItemDefinition *def = (DefendItemDefinition *)[[DataDepot depot] getItemDefinition:itemId];
		return def;
	}
	return nil;
}

-(void) removeItem:(int)index
{
	if (index >= 0 && index < [itemList count]) {
		
		[itemList removeObjectAtIndex:index];
		
		if (attackItemIndex == index) {
			attackItemIndex = -1;
		} else if (attackItemIndex > index) {
			attackItemIndex --;
		}
		
		if (defendItemIndex == index) {
			defendItemIndex = -1;
		} else if (defendItemIndex > index) {
			defendItemIndex --;
		}
	}
}

-(void) removeItemWithId:(int) itemId
{
	for (int i = 0; i < [itemList count]; i++) {
		NSNumber *num = [itemList objectAtIndex:i];
		if (itemId == [num intValue]) {
			[self removeItem:i];
			return;
		}
	}
}

-(void) addItem:(int)itemId
{
	[itemList addObject:[NSNumber numberWithInt:itemId]];
}

-(BOOL) hasItem:(int)itemId
{
    for (NSNumber *num in itemList) {
        if (itemId == [num intValue]) {
			return TRUE;
		}
	}
	
	return FALSE;
}

-(void) recoverHealth
{
	if (hpCurrent > 0) {
		hpCurrent = hpMax;
	}
	
	mpCurrent = mpMax;
}

-(void) updateStatusInTurn
{
	// Poison
	if (statusPoisoned > 0) {
		hpCurrent -= hpMax / 10;
		if (hpCurrent < 1) hpCurrent = 1;
	}
	
	
	if (statusEnhanceAp > 0) statusEnhanceAp --;
	if (statusEnhanceDp > 0) statusEnhanceDp --;
	if (statusEnhanceDx > 0) statusEnhanceDx --;
	if (statusPoisoned > 0) statusPoisoned --;
	if (statusProhibited > 0) statusProhibited --;
	if (statusFrozen > 0) statusFrozen --;
}

-(void) clearAllStatus
{
	statusEnhanceAp = 0;
	statusEnhanceDp = 0;
	statusEnhanceDx = 0;
	statusPoisoned = 0;
	statusFrozen = 0;
	statusProhibited = 0;
}

-(void) clearStatusPoisoned
{
	statusPoisoned = 0;
}

-(void) clearStatusProhibited
{
	statusProhibited = 0;
}

-(void) clearStatusFrozen
{
	statusFrozen = 0;
}

-(void) addMagic:(int)magicId
{
    if (![magicList containsObject:[NSNumber numberWithInt:magicId]])
    {
        [magicList addObject:[NSNumber numberWithInt:magicId]];
    }
}

-(void) dealloc
{
	[itemList release];
	[magicList release];
	
	
	[super dealloc];
}

@end
