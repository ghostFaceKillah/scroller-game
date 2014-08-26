/*
 Generic queue.
 Authored by somebody on the net, found at SE, seems to be ok
 please see:
 https://github.com/esromneb/ios-queue-object
 */

@interface NSMutableArray (QueueAdditions)

-(id) dequeue;
-(void) enqueue:(id)obj;
-(id) peek:(int)index;
-(id) peekHead;
-(id) peekTail;
-(BOOL) empty;

@end