## AskandLearn

Group Project - README Template
===
Esther Brown

Claire Cheng

Alexs Gonzalez


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
- **Mobile:** Real-time, Convenient tap interface
- **Story:** Users can get advice on areas of interest. At the same time, users can learn from others/experts in their field.
- **Market:** Anyone who wants to learn a new skill or wants to share his or her skill.
- **Habit:** Like the case of many easy-to-use, low-commitment apps which implement a swiping interface, swiping becomes easily addictive. Mentors and learners who have good reviews will receive 'points' that can make them feel validated and influence others to respect their pages. The app will have a 'points system' where members will be classified into groups based on the classified ranges they fall into. High point receivers can be invited to private events as a sort of 'elite club.' These incentives promote frequent and honest usage.
- **Scope:** The backend does not seem too complicated to implement, although we would need to implement a lot of tabs and features such as instant messaging that may be more difficult to tackle. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
- [x] User can sign up to create a new account (using username, password)
- [x] User can Login/Logout
- [x] During sign up,user can connect through Facebook, and we will extract basic information through there 
- [x] Profiles of people with basic information (age, areas of expertise, educational levels) that user can tap through 
- [x] Tab to access the user's 'matches'
- [x] Segue to access the user's messages from the 'matches' tab
- [x] Tab to access the user's 'messages'
- [x] Implement Basic messaging function using Parse Chat
  
**Optional Nice-to-have Stories**

- [x] Swiping animation instead of just button taps
- [x] Match score so that the user can see how 'compatible' a profile is with them
- [ ] The option to unmatch, report, block users
- [ ] "Verified" status for users with good ratings
- [ ] Rating system and points system
- [x] Pop-up notification when a match has been formed
- [ ] Filters that the user can instantiate to make it easier to find people they want to learn from (categories)
  (profession, company, age, field of study, area of interests)

### 2. Screen Archetypes

* Login
   * Username and password
   * Connect LinkedIn account
* Swipe Stream
   * Profiles of people
   * Tab to access matches + Messaging( tab bar will be at top of page)
   * Filters that user can instantiate
* Detail
    * User can click on a profile to view more info
* Messaging/Matches
    * User can view matches
    * User can messages
* Profile
    * User can view their matches, ratings, points, status
* Settings
    * User can logout
    * User can adjust/filter for the people they want to "discover"

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Swipe Stream
* Matches/Messaging
* Profile

**Flow Navigation** (Screen to Screen)

* Login
   * Swipe Stream
* Swipe Stream
   * Detail View
  
## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/appteamfbu2019/askandlearn/blob/master/wireframes.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema Objects
**User**
* email
* Username
* Password
* Name
* ProfileImage
* Age
* JobTitle
* Bio
* Facebook

**Message**
* sender user
* receiving user
* message text
* message timestamp

**Matches**
* user

### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]


