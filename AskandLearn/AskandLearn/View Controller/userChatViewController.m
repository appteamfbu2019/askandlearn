//
//  userChatViewController.m
//  AskandLearn
//
//  Created by estherb on 8/5/19.
//  Copyright © 2019 estherb. All rights reserved.

#import "userChatViewController.h"
#import "ContentView.h"
#import "ChatTableViewCell.h"
#import "MatchViewController.h"
#import "ChatCellSettings.h"
#import "Parse.h"
#import "Messages.h"
#import "Match.h"

@interface iMessage: NSObject
-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMessage;
@property (strong, nonatomic) NSString *userTime;
@property (strong, nonatomic) NSString *messageType;
@end

@implementation iMessage
-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        self.userName = name;
        self.userMessage = message;
        self.userTime = time;
        self.messageType = type;
    }
    
    return self;
}
@end

@interface userChatViewController ()

@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (strong,nonatomic) ChatTableViewCell *chatCell;
@property (strong,nonatomic) ContentView *handler;
@end

@implementation userChatViewController
{
    NSMutableArray *currentMessages;
    ChatCellSettings *chatCellSettings;
}
@synthesize chatCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentMessages = [[NSMutableArray alloc] init];
    chatCellSettings = [ChatCellSettings getInstance];
    
    self.chatTable.dataSource = self;
    self.chatTable.delegate = self;
    
    [chatCellSettings setSenderBubbleColorHex:@"007AFF"];
    [chatCellSettings setReceiverBubbleColorHex:@"DFDEE5"];
    [chatCellSettings setSenderBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleNameTextColorHex:@"000000"];
    [chatCellSettings setSenderBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleMessageTextColorHex:@"000000"];
    [chatCellSettings setSenderBubbleTimeTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleTimeTextColorHex:@"000000"];
    
    [chatCellSettings setSenderBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setSenderBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setReceiverBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setSenderBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    
    [chatCellSettings senderBubbleTailRequired:YES];
    [chatCellSettings receiverBubbleTailRequired:YES];
    
    self.navigationItem.title = @"AskandLearn Messages";
    
    [[self chatTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatSend"];
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatReceive"];
  
    self.handler = [[ContentView alloc] initWithTextView:self.chatTextView ChatTextViewHeightConstraint:self.chatTextViewHeightConstraint contentView:self.contentView ContentViewHeightConstraint:self.contentViewHeightConstraint andContentViewBottomConstraint:self.contentViewBottomConstraint];
    
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:3];
    
    //Tap gesture on table view so that when someone taps on it, the keyboard is hidden
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.chatTable addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissKeyboard
{
    [self.chatTextView resignFirstResponder];
}

- (IBAction)sendMessage:(id)sender
{
    if([self.chatTextView.text length]!=0)
    {
        iMessage *sendMessage;
        
        PFUser *currentUser = [PFUser currentUser];
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        
        sendMessage = [[iMessage alloc] initIMessageWithName:currentUser.username  message:self.chatTextView.text time:newDateString type:@"self"];
        
        [self updateTableView:sendMessage];
        
        PFObject *chatMessage = [PFObject objectWithClassName:@"Message2_Testing"];
        chatMessage[@"text"] = sendMessage.userMessage;
        chatMessage[@"sender"] = PFUser.currentUser;
        if ([[self.matchObj[@"person1"] objectId] isEqualToString:PFUser.currentUser.objectId]){
            chatMessage[@"receiver"] = self.matchObj[@"person2"];
        }
        else {
            chatMessage[@"receiver"] = self.matchObj[@"person1"];
        }
        [Messages sendMessage:chatMessage[@"sender"] withUser:chatMessage[@"receiver"] withText:chatMessage[@"text"]];
//        [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
//            if (succeeded) {
//                NSLog(@"The message was saved!");
//            } else {
//                NSLog(@"Problem saving message: %@", error.localizedDescription);
//            }
//        }];
        self.chatTextView.text = @"";
    }
}

- (IBAction)receiveMessage:(id)sender
{
    if([self.chatTextView.text length]!=0)
    {
        iMessage *receiveMessage;
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        
        receiveMessage = [[iMessage alloc] initIMessageWithName:@"Mango" message:self.chatTextView.text time:newDateString type:@"other"];
        
        [self updateTableView:receiveMessage];
    }
}

-(void) updateTableView:(iMessage *)msg
{
    [self.chatTextView setText:@""];
    [self.handler textViewDidChange:self.chatTextView];
    
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:currentMessages.count inSection:0];
    
    [currentMessages insertObject:msg atIndex:currentMessages.count];
    
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTable endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.chatTable numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}



#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    if([message.messageType isEqualToString:@"self"])
    {
        
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeSender;
    }
    else
    {
       
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeReceiver;
    }
    
    return chatCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    CGSize size;
    
    CGSize Namesize;
    CGSize Timesize;
    CGSize Messagesize;
    
    NSArray *fontArray = [[NSArray alloc] init];
    
    //Get the chal cell font settings. This is to correctly find out the height of each of the cell according to the text written in those cells which change according to their fonts and sizes.
    //If you want to keep the same font sizes for both sender and receiver cells then remove this code and manually enter the font name with size in Namesize, Messagesize and Timesize.
    if([message.messageType isEqualToString:@"self"])
    {
        fontArray = chatCellSettings.getSenderBubbleFontWithSize;
    }
    else
    {
        fontArray = chatCellSettings.getReceiverBubbleFontWithSize;
    }
    
    //Find the required cell height
    Namesize = [@"Name" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[0]}
                                     context:nil].size;
    
    
    
    Messagesize = [message.userMessage boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:fontArray[1]}
                                                    context:nil].size;
    
    
    Timesize = [@"Time" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[2]}
                                     context:nil].size;
    
    
    size.height = Messagesize.height + Namesize.height + Timesize.height + 48.0f;
    
    return size.height;
}



@end
