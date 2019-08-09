# AskandLearn

Esther Brown, Claire Cheng, Alexs Gonzalez

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
"AskAndLearn" is an app focused on connecting 'mentors' with certain skillsets and experiences to 'learners' with certain topics and areas and areas of interests. Mentors and learners will be required to connect a LinkedIn profile for increased reliability and trustworthiness.

The "connections" will be formed in a similar way to the workings of the app Tinder, as both the mentors and the learners will have to 'match' with each other before communication can be established. This will help to minimize the proliferation of bots or spam/unwanted messages and will create more meaningful connections in which both learners and mentors can benefit in different ways.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Education
- **Mobile:** Real-time, Convenient and fun swipe interface
- **Story:** Users can get advice on areas of interest. At the same time, users can learn from others/experts in their field.
- **Market:** Anyone who wants to learn a new skill or wants to share his or her skill.
- **Habit:** Like the case of many easy-to-use, low-commitment apps which implement a swiping interface, swiping becomes easily addictive. Since there is no extra cost to learn from other users, this quality promote frequent and honest usage.
- **Scope:** The backend does not seem too complicated to implement, although we would need to implement a lot of tabs and features such as instant messaging that may be more difficult to tackle. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
- [x] User can sign up to create a new account (using username, password)
- [x] User can Login/Logout
- [x] During sign up,user can connect through Facebook, and we will extract basic information through there 
- [ ] Profiles of people with basic information (age, areas of expertise, educational levels) that user can tap through 
- [x] Tab to access the user's 'matches'
- [x] Segue to access the user's messages from the 'matches' tab
- [x] Tab to access the user's 'messages'
- [x] Implement Basic messaging function using Parse Chat
- [ ] Filters that the user can instantiate to make it easier to find people they want to learn from (categories)
  (profession, company, age, field of study, area of interests)
  
**Optional Nice-to-have Stories**

- [x] Swiping animation instead of just button taps
- [ ] The option to unmatch, report, block users
- [ ] "Verified" status for users with good ratings
- [ ] Rating system and points system
- [x] Pop-up notification when a match has been formed

### 2. Screen Archetypes

* Login
   * Username and password
   * Connect Facebook account
* Swipe Stream
   * Profiles of people to swipe through
   * Calculate "Match Score" to determine likelihood of shared interests
* Detail
    * User can click on a profile to view more info
* Messaging/Matches
    * User can view matches
    * User can message matches
* Profile
    * User can customize their profile to display
* Settings
    * User can Log Out
    * User can add Tags to show their areas of interest
    * User can choose to be a Learner, Teacher, or both

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Swipe Stream
* Matches/Messaging
* Profile

**Flow Navigation** (Screen to Screen)

* Login/Signup -> Swipe Stream
* Matches -> Messages
* Profile -> Settings -> Add Tags
* Profile -> Edit Profile
  
## Wireframes
<img src="https://github.com/appteamfbu2019/askandlearn/blob/master/wireframes.png" width=600>

## Schema Objects / Parse Classes
**User**
* email (NSString)
* Username (NSString)
* Password (NSString)

**Action**
* receivedLike (PFUser)
* receivedDislike (PFUser)
* sender (PFUser)
* sentLike (PFUser)
* sentDislike (PFUser)

**Switch**
* user (PFUser)
* isLearner (BOOL)
* isTeacher (BOOL)

**Tags**
* user (PFUser)
* tags (NSDictionary) (Dictionary with name of tag and unique identifier of tag)
* status (NSString) (adding or removing tag)

**Profile**
* name (NSString)
* major (NSString)
* profession (NSString)
* user (NSString)
* profilepic (UIImage)
* backgroundpic (UIImage)

**Message**
* sender (PFUser)
* receiver (PFUser)
* messageText (NSString)
* timeNow (NSString)

**Matches** 
* person1 (PFUser)
* person2 (PFUser)

### Networking
- Using Facebook API for login


