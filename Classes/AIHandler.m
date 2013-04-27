//
//  AIHandler.m
//  FlameDragon
//
//  Created by sui toney on 11-12-13.
//  Copyright 2011 ms. All rights reserved.
//

#import "AIHandler.h"
#import "AIAggressiveDelegate.h"
#import "AIMagicalDelegate.h"
#import "AIEscapeDelegate.h"
#import "AIStandByDelegate.h"
#import "AIGuardDelegate.h"
#import "FDEnemy.h"
#import "FDFriend.h"
#import "FDNpc.h"


@implementation AIHandler

-(id) initEnemyHandlerWithLayers:(ActionLayers *)l
{
	self = [super init];
	
	creatureClass = [FDEnemy class];
	lastOperatedCreatureId = 0;
	
	layers = l;
	
	[layers setEnemyAiHandler:self];
	
	return self;
}

-(id) initNpcHandlerWithLayers:(ActionLayers *)l
{
	self = [super init];
	
	creatureClass = [FDNpc class];
	layers = l;
	
	[layers setNpcAiHandler:self];
	
	return self;
}

-(void) isNotified
{
	NSLog(@"Enemy AI Handler is notified.");
	
	// find a creature and take action on it
	FDCreature *selectedCreature = nil;
	
	NSMutableArray *array = (creatureClass == [FDEnemy class]) ? [[[layers getFieldLayer] getField] getEnemyList]: [[[layers getFieldLayer] getField] getNpcList];
	for (FDCreature *creature in array) {
		
		if (creature.hasActioned || creature.data.statusFrozen > 0 || creature.pendingAction) {
			continue;
		}
		
		if (selectedCreature == nil || [creature getIdentifier] < [selectedCreature getIdentifier]) {
			selectedCreature = creature;
		}
	}
	
	if (selectedCreature == nil) {
		for (FDCreature *creature in array) {
			
			if (creature.hasActioned || ![creature isNotFrozen] || !creature.pendingAction) {
				continue;
			}
			
			if (selectedCreature == nil || [creature getIdentifier] < [selectedCreature getIdentifier]) {
				selectedCreature = creature;
			}
		}		
	}
	
	if (selectedCreature == nil) {
		
		NSLog(@"Didn't find creature to operate.");
		return;
	}
	
	NSLog(@"Select creature to operate.");
	[self runAiDelegate:selectedCreature];
}

-(void) runAiDelegate:(FDCreature *)creature
{
	AIDelegate *delegate = nil;
	
	switch (creature.data.aiType) {
		case AIType_Aggressive:
			if ([[creature getDefinition] isMagicalCreature]) {
				delegate = [[AIMagicalDelegate alloc] initWithCreature:creature Layers:layers];
			} else {
				delegate = [[AIAggressiveDelegate alloc] initWithCreature:creature Layers:layers];
			}

			break;
		case AIType_Escape:
			delegate = [[AIEscapeDelegate alloc] initWithCreature:creature Layers:layers];
			[delegate setParameter:creature.data.aiParam];
			break;
		case AIType_StandBy:
			delegate = [[AIStandByDelegate alloc] initWithCreature:creature Layers:layers];
			break;
		case AIType_Guard:
			delegate = [[AIGuardDelegate alloc] initWithCreature:creature Layers:layers];
			break;
		default:
			break;
	}
	
	if (delegate != nil)
	{
		lastOperatedCreatureId = [creature getIdentifier];
		[delegate takeAction];
		//[delegate release];
	}
}

@end
