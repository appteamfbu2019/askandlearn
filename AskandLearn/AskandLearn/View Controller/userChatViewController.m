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
                      type:(NSString *)type {
    self = [super init];
    if(self){
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
@property (strong, nonatomic) PFUser *receiver;
@property (strong, nonatomic) NSString *receiverUsername;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) int textViewOriginY;

@end

@implementation userChatViewController{
    NSMutableArray *currentMessages;
    ChatCellSettings *chatCellSettings;
}
@synthesize chatCell;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.sendButton.layer.cornerRadius = 10;
    
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
    
    [[self chatTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatSend"];
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatReceive"];
    
    self.handler = [[ContentView alloc] initWithTextView:self.chatTextView ChatTextViewHeightConstraint:self.chatTextViewHeightConstraint contentView:self.contentView ContentViewHeightConstraint:self.contentViewHeightConstraint andContentViewBottomConstraint:self.contentViewBottomConstraint];
    
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:3];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.chatTable addGestureRecognizer:gestureRecognizer];
    [self Refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) dismissKeyboard{
    [self.chatTextView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.contentView.frame;
        self.textViewOriginY = f.origin.y;
        f.origin.y = f.origin.y -keyboardSize.height;
        self.contentView.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.contentView.frame;
        f.origin.y = self.textViewOriginY;
        self.contentView.frame = f;
    }];
}

- (IBAction)sendMessage:(id)sender{
    if([self.chatTextView.text length]!=0)
    {
        iMessage *sendMessage;
        
        PFUser *currentUser = [PFUser currentUser];
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        
        sendMessage = [[iMessage alloc] initIMessageWithName:currentUser.username  message:self.chatTextView.text time:newDateString type:@"self"];
        
        [self updateTableView:sendMessage];
        
        PFObject *chatMessage = [PFObject objectWithClassName:@"Messages"];
        chatMessage[@"text"] = sendMessage.userMessage;
        chatMessage[@"sender"] = PFUser.currentUser;
        chatMessage[@"receiver"] = self.person2;
        
        [Messages sendMessage:chatMessage[@"sender"] withUser:chatMessage[@"receiver"] withText:chatMessage[@"text"] withTime:newDateString];
        
        
        self.chatTextView.text = @"";
    }
}

- (IBAction)receiveMessage:(id)sender{
    if([self.chatTextView.text length]!=0){
        iMessage *receiveMessage;
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        
        receiveMessage = [[iMessage alloc] initIMessageWithName:self.person2[@"username"] message:self.chatTextView.text time:newDateString type:@"other"];
        
        [self updateTableView:receiveMessage];
        
        PFObject *chatMessage = [PFObject objectWithClassName:@"Messages"];
        chatMessage[@"text"] = receiveMessage.userMessage;
        chatMessage[@"receiver"] = PFUser.currentUser;
        chatMessage[@"sender"] = self.person2;
        
        [Messages sendMessage:chatMessage[@"sender"] withUser:chatMessage[@"receiver"] withText:chatMessage[@"text"] withTime:newDateString];
        
        self.chatTextView.text = @"";
    }
}

-(void) updateTableView:(iMessage *)msg{
    [self.chatTextView setText:@""];
    [self.handler textViewDidChange:self.chatTextView];
    
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:currentMessages.count inSection:0];
    
    [currentMessages insertObject:msg atIndex:currentMessages.count];
    
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTable endUpdates];

    if([self.chatTable numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    if ([message.userName isEqualToString:PFUser.currentUser.username]){
        message.messageType = @"self";
    }
    else{
        message.messageType = nil;
    }

    if ([message.userName isEqualToString:PFUser.currentUser.username]){
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeSender;
    }
    else{
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];

        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeReceiver;
    }
    
    return chatCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    CGSize size;
    CGSize Namesize;
    CGSize Timesize;
    CGSize Messagesize;
    
    NSArray *fontArray = [[NSArray alloc] init];
    
    if([message.messageType isEqualToString:@"self"])
    {
        fontArray = chatCellSettings.getSenderBubbleFontWithSize;
    }
    else
    {
        fontArray = chatCellSettings.getReceiverBubbleFontWithSize;
    }
    
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

-(void)Refresh{
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query includeKey:@"sender"];
    [query includeKey:@"receiver"];
    [query includeKey:@"messageText"];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            for (Messages *msg in posts){
                PFUser *currentUser = [PFUser currentUser];
                if ([[msg[@"sender"] objectId] isEqualToString:PFUser.currentUser.objectId] && [[msg[@"receiver"] objectId] isEqualToString:self.person2.objectId]){
                    
                    iMessage *iMsg = [[iMessage alloc] initIMessageWithName:currentUser.username  message:msg[@"messageText"] time:msg[@"timeNow"] type:@"self"];
                    [self->currentMessages addObject:iMsg];
                    [self.chatTable reloadData];
                    
                    
                }else if ([[msg[@"receiver"] objectId] isEqualToString:PFUser.currentUser.objectId] && [[msg[@"sender"] objectId] isEqualToString:self.person2.objectId]){
                    
                    iMessage *iMsg = [[iMessage alloc] initIMessageWithName:self.person2.username  message:msg[@"messageText"] time:msg[@"timeNow"] type:nil];
                    [self->currentMessages addObject:iMsg];
                    [self.chatTable reloadData];
                }
                else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }
        }
    }];
}


@end
