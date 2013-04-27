//
//  AIDelegate.m
//  FlameDragon
//
//  Created by sui toney on 11-12-13.
//  Copyright 2011 ms. All rights reserved.
//

#import "AIDelegate.h"
#import "FDPointMap.h"
#import "FDPath.h"
#import "FDIntMap.h"
#import "GroundBlock.h"
#import "PathResolver.h"
#import "ScopeResolver.h"
#import "DistanceResolver.h"
#import "DataDepot.h"
#import "UsableItemDefinition.h"

@implementation AIDelegate


-(id) initWithCreature:(FDCreature *)c Layers:(ActionLayers *)l
{
	self = [super init];
	
	creature = c;
	layers = l;
	
	return self;
}

-(void) takeAction
{
	
}

-(void) setParameter:(id)param
{
	
}

-(void) initDistanceResolver
{
	BattleField *field = [[layers getFieldLayer] getField];	
	int fieldHeight = [field mapSize].height;
	int fieldWidth = [field mapSize].width;
	
	FDIntMap *map = [[FDIntMap alloc] initWidth:fieldWidth Height:fieldHeight];
	for (int i = 1; i <= fieldWidth; i++) {
		for (int j = 1; j <= fieldHeight; j++) {
			
			GroundBlock *block = [[field getGroundField] blockAtX:i Y:j];
			switch ([block getBlockType])
			{
				case GroundBlockTypeGround:
				case GroundBlockTypeForest:
					[map setX:i Y:j Value: PathBlockType_Plain];
					break;
				case GroundBlockTypeChasm:
					// If creature can fly
					if (FALSE) {
						[map setX:i Y:j Value: PathBlockType_Plain];
					}
					else {
						[map setX:i Y:j Value: PathBlockType_Blocked];
					}
					break;
				case GroundBlockTypeGap:
					[map setX:i Y:j Value: PathBlockType_Blocked];
					break;
				default:
					break;
			}
		}
	}
	disResolver = [[DistanceResolver alloc] initWithMap:map Width:fieldWidth Height:fieldHeight];
	
	[map release];
}
/*
-(CGPoint) generatePos:(CGPoint)targetPos
{
	return [self generatePos:targetPos forAttack:TRUE];
}
*/
-(CGPoint) generatePos:(CGPoint)targetPos // forAttack:(BOOL)attackOnly
{
	
	NSLog(@"generatePos: target Pos: %f, %f", targetPos.x, targetPos.y);
	
	BattleField *field = [[layers getFieldLayer] getField];
	
	//[disResolver resolveDistanceFrom:targetPos terminateAt:CGPointMake(1, 1)];
	CGPoint originPos = [field getObjectPos:creature];
	[disResolver resolveDistanceFrom:targetPos terminateAt:originPos];
	
	// Find the scope
	float bestDistance = 999;
	int bestDistanceInUnit = -1;
	BOOL inAttackScope = FALSE;
	
	FDPosition *finalPos = [FDPosition positionX:originPos.x Y:originPos.y];
	NSMutableArray *scopeArray = [field searchMoveScope:creature];
	
	//FDRange *range = [creature attackRange];
	
	FDRange *range = nil;
	if ([field getCreatureByPos:targetPos] != nil) {
		range = [creature attackRange];
	} else {
		range = [FDRange rangeWithMin:0 Max:0];
	}
	
	for (FDPosition *pos in scopeArray) {
		
		int distanceInUnit = [field getDirectDistancePos:targetPos And:[pos posValue]];
		if ([range containsValue:distanceInUnit]) {
			
			inAttackScope = TRUE;
			if (distanceInUnit > bestDistanceInUnit) {
				bestDistanceInUnit = distanceInUnit;
				finalPos = pos;
			}
		}
		
		if (!inAttackScope) {
			float distance = [disResolver getDistanceTo:[pos posValue]];
		
			if (distance < bestDistance) {
				bestDistance = distance;
				finalPos = pos;
			}
		}
	}
	
	NSLog(@"Get Target Pos: %f, %f", [finalPos posValue].x, [finalPos posValue].y);
	
	return [finalPos posValue];
}


-(FDCreature *) findTarget
{
	BattleField *field = [[layers getFieldLayer] getField];	
	CGPoint currentPos = [field getObjectPos:creature];
	
	FDCreature *terminateCreature = nil;
	NSMutableArray *terminateCandidates = nil;
	if ([creature getCreatureType] == CreatureType_Enemy)
	{
		terminateCandidates = [field getFriendList];
		// terminateCreature = [[field getFriendList] objectAtIndex:0];
	}
	else if ([creature getCreatureType] == CreatureType_Npc)
	{
		terminateCandidates = [field getEnemyList];
		// terminateCreature = [[field getEnemyList] objectAtIndex:0];
	}
	
	int candidateIndex = 0;
	while (candidateIndex < [terminateCandidates count]-1 && ![creature isAbleToAttack:[terminateCandidates objectAtIndex:candidateIndex]]) {
		candidateIndex ++;
	}
	terminateCreature = [terminateCandidates objectAtIndex:candidateIndex];
	
	[disResolver resolveDistanceFrom:currentPos terminateAt:[field getObjectPos:terminateCreature]];
	
	float minDistance = 999;
	FDCreature *finalTarget = terminateCreature;
	
	NSMutableArray *candidateList = [[NSMutableArray alloc] init];
	if ([creature getCreatureType] == CreatureType_Enemy) {
		[candidateList addObjectsFromArray:[field getFriendList]];
		[candidateList addObjectsFromArray:[field getNpcList]];
	}
	else if ([creature getCreatureType] == CreatureType_Npc) {
		[candidateList addObjectsFromArray:[field getEnemyList]];
	}
	
	for (FDCreature *c in candidateList) {
		
		float distance = [disResolver getDistanceTo:[field getObjectPos:c]];
		if (distance < minDistance && [creature isAbleToAttack:c]) {
			minDistance = distance;
			finalTarget = c;
		}
	}
	[candidateList release];
	
	NSLog(@"Find target: %d", [finalTarget getIdentifier]);
	
	return finalTarget;
}

-(BOOL) needAndCanRecover
{
	BOOL needRecover = FALSE;
	if (creature.data.hpCurrent < creature.data.hpMax) {
		needRecover = TRUE;
	}
	
	BOOL canRecover = FALSE;
	for (int index = 0; index < [creature.data.itemList count]; index++) {
		int itemId = [creature getItemId:index];
		if (itemId == 101 || itemId == 102 || itemId == 103 || itemId == 104) {
			canRecover = TRUE;
			break;
		}
	}
	
	return needRecover && canRecover;
}

-(void) selfRecover
{
	int itemIndex = -1;
	for (int index = 0; index < [creature.data.itemList count]; index++) {
		int itemId = [creature getItemId:index];
		if (itemId == 101 || itemId == 102 || itemId == 103 || itemId == 104) {
			itemIndex = index;
			break;
		}
	}
	
	if (itemIndex < 0) {
		return;
	}
	
	int itemId = [creature getItemId:itemIndex];
	UsableItemDefinition * itemDef = (UsableItemDefinition *)[[DataDepot depot] getItemDefinition:itemId];
	[itemDef usedBy:creature];
	
	[creature.data removeItem:itemIndex];
}

@end
