//
//  Network.m
//  NetworkTest
//
//  Created by Mohammad Jeragh on 3/22/13.
//  Copyright (c) 2013 Mohammad Jeragh. All rights reserved.
//

#import "Network.h"

@interface Network()



@end 



@implementation Network


-(void)sendPacketSignInRequestTo:(NSString *)peerID{
    Packet *packet = [Packet packetWithType:PacketTypeSignInRequest];
    GKSendDataMode dataMode = GKSendDataReliable;
	NSData *data = [packet data];
	NSError *error;
    
//#ifdef DEBUG
//	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
//#endif
    
	if (![_session sendData:data toPeers:[NSArray arrayWithObject:peerID] withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to server: %@", error);
	}
    else
        [self.delegate appendStringToViewWith:[NSString stringWithFormat:@"Packet %@ sent to Peer %@ with data %@ length %d\n",packet,peerID,data,[data length]]];
}

-(void)sendPacketSignInResponseTo:(NSString *)peerID{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    Packet *packet = [PacketSignInResponse packetWithPlayerName:@"MAJ"];
    GKSendDataMode dataMode = GKSendDataReliable;
	NSData *data = [packet data];
	NSError *error;
    NSLog(@"Packet class: %@", NSStringFromClass([Packet class]));
	if (![self.session sendData:data toPeers:[NSArray arrayWithObject:peerID] withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to server: %@", error);
	}
    else
    [self.delegate appendStringToViewWith:[NSString stringWithFormat:@"Packet %@ sent to Peer %@ with data %@ length %d\n",packet,peerID,data,[data length]]];

}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
	NSLog(@"Network: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
    NSLog(@"%s",__PRETTY_FUNCTION__);
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil)
	{
		NSLog(@"Invalid packet: %@", data);
		return;
	}
    NSLog(@"Packet class: %@", NSStringFromClass([packet class]));
	switch (packet.packetType)
	{
		case PacketTypeSignInResponse:
			[self.delegate appendStringToViewWith:[NSString stringWithFormat:@"Packet %@ recieved from Peer %@ with data %@ length %d\n",packet,peerID,data,[data length]]];
            NSLog(@"Packet %@ recieved from Peer %@ with data %@ length %d\n",packet,peerID,data,[data length]);
				NSLog(@"%@",((PacketSignInResponse *)packet).playerName);
            
            
        break;
        case PacketTypeSignInRequest:
            NSLog(@"SignRequest");
            [self.delegate appendStringToViewWith:[NSString stringWithFormat:@"Packet %@ recieved from Peer %@ with data %@ length %d\n",packet,peerID,data,[data length]]];
            [self sendPacketSignInResponseTo:peerID];
            
        break;
        default:
            NSLog(@"Error");
    }
}

@end
