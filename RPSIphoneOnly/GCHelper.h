//
//  GCHelper.h
//  RPSIphoneOnly
//
//  Created by student student on 11/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@protocol GCTurnBasedMatchHelperDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)recieveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice 
          forMatch:(GKTurnBasedMatch *)match;
@end


// Modify @interface line to support protocols as follows
@interface GCHelper : NSObject 
<GKTurnBasedMatchmakerViewControllerDelegate, 
GKTurnBasedEventHandlerDelegate> {
    
    // New instance variable
    UIViewController *presentingViewController;
    
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    GKTurnBasedMatch *currentMatch;
    
    id <GCTurnBasedMatchHelperDelegate> delegate;
}


@property (nonatomic, retain) 
id <GCTurnBasedMatchHelperDelegate> delegate;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, retain) GKTurnBasedMatch *currentMatch;


+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

// New method
- (void)findMatchWithMinPlayers:(int)minPlayers 
                     maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController *)viewController;

@end