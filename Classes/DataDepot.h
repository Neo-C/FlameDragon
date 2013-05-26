//
//  DataDepot.h
//  FlameDragon
//
//  Created by sui toney on 11-11-23.
//  Copyright 2011 ms. All rights reserved.
//

#import "cocos2d.h"
#import "ItemDefinition.h"
#import "MagicDefinition.h"
#import "CreatureDefinition.h"
#import "AnimationDefinition.h"
#import "LevelUpDefinition.h"
#import "ShopDefinition.h"
#import "OccupationDefinition.h"
#import "SecretSequenceDefinition.h"
#import "LevelUpMagicDefinition.h"
#import "TransfersDefinition.h"

@interface DataDepot : NSObject {

	NSMutableDictionary *itemDictionary;
	NSMutableDictionary *magicDictionary;
	NSMutableDictionary *creatureDictionary;
	NSMutableDictionary *animationDictionary;
	NSMutableDictionary *levelUpDictionary;
	NSMutableDictionary *shopDictionary;
	NSMutableDictionary *occupationDictionary;
	NSMutableDictionary *secretSequenceDictionary;
	NSMutableDictionary *levelUpMagicDictionary;
	NSMutableDictionary *transferDictionary;
	NSMutableArray *mandatoryPickedFriend;
}

+(DataDepot *) depot;

-(void) loadAllDictionaries;
-(void) loadItemDictionary;
-(void) loadMagicDictionary;
-(void) loadCreatureDictionary;
-(void) loadAnimationDictionary;
-(void) loadLevelUpDictionary;
-(void) loadShopDictionary;
-(void) loadOccupationDictionary;
-(void) loadSecretSequenceDictionary;
-(void) loadLevelUpMagicDictionary;
-(void) loadTransferDictionary;
-(void) loadMandatoryPickedFriend;

-(ItemDefinition *) getItemDefinition:(int)itemId;
-(MagicDefinition *) getMagicDefinition:(int)magicId;
-(CreatureDefinition *) getCreatureDefinition:(int)creatureDefId;
-(AnimationDefinition *) getAnimationDefinition:(AnimationType)type Id:(int)aniId;
-(AnimationDefinition *) getMagicAnimationDefinition:(int)magicId isBadGuy:(BOOL)isBad;
-(LevelUpDefinition *) getLevelUpDefinition:(int)creatureDefId;
-(ShopDefinition *) getShopDefinition:(int)chapterId Type:(DataDepotShopType)shopType;
-(OccupationDefinition *) getOccupationDefinition:(int)occupationId;
-(SecretSequenceDefinition *) getSecretSequenceDefinition:(int)chapterId;
-(MagicDefinition *) getLevelUpMagicDefinition:(int)creatureDefId atLeveL:(int)level;
-(TransfersDefinition *) getTransfersDefinition:(int)creatureDefId;
-(TransferDefinition *) getTransferDefinition:(int)transferId;
-(NSMutableArray *) getMandatoryPickedFriend:(int)chapterId;

@end
