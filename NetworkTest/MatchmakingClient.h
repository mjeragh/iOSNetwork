//
//  MatchmakingClient.h
//  Snap
//
//  Created by Mohammad Jeragh on 12/28/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MatchmakingClient;

@protocol MatchmakingClientDelegate <NSObject>

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID;
- (void)matchmakingClientNoNetwork:(MatchmakingClient *)client;
- (void)matchmakingClient:(MatchmakingClient *)client didConnectFromServer:(NSString *)peerID;
@end



@interface MatchmakingClient : NSObject<GKSessionDelegate>
@property(nonatomic, strong, readonly) NSArray *availableServers;
@property(nonatomic, strong, readonly) GKSession *session;
@property (nonatomic, weak) id <MatchmakingClientDelegate> delegate;

-(void) startSearchingForServersWithSessionID:(NSString *)sessionID;
-(NSUInteger)availableServerCount;
-(NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index;
-(NSString *)displayNameForPeerID:(NSString *)peerID;
- (void)connectToServerWithPeerID:(NSString *)peerID;
- (void)disconnectFromServer;
@end
