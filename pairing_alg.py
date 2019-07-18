#pairing algorithm for fbu app
#draft in python, test for efficiency

#currently: a matching simulation

import json
import random

MATCHES = [] #list of sets of matches

class User:
    def __init__(self, name):
        self.name = name
        self.likes = set()
        self.tags = set()

    def add_like(self, like): #where like is another User
        self.likes.add(like)
        if self in like.likes:
            MATCHES.append({self.name, like.name})
            self.likes.remove(like)
            like.likes.remove(self)

    def add_tag(self, tag): #add a tag, a string, to describe the User
        self.tags.add(tag)

#####################
#testing basic matching alg

def basic_matching():

    users = dict()

    with open('first-names.json') as file:
        data = json.load(file)
        for person in data:
            users[str(person)] = User(str(person))

        for person in users:
            likes = set()
            for i in range(50):
                likes.add(random.choice(data))
            for lk in likes:
                if lk == str(person):
                    continue
                else:
                    users[person].add_like(users[lk])

    return MATCHES

####################
#testing accuracy of match alg

def top_matches():
    users = dict()
    our_user = User("me")

    #load all users
    with open('first-names.json') as file1:
        data_names = json.load(file1)
        for person in data_names:
            users[str(person)] = User(str(person))

    #add tags for users
    with open('occupations.json') as file2:
        jobs = json.load(file2)
        data_jobs = jobs["occupations"]
        for person in users:
            for i in range(10):
                users[person].add_tag(random.choice(data_jobs))

    #set own user preferences
    for i in range(100):
        our_user.add_tag(random.choice(data_jobs))

    #produce top 10 potential matches with highest accuracy
    top = []
    for person in users:
        p = check_accuracy(our_user, users[person])
        #print(p)
        if len(top) == 0:
            top = [(users[person], p)]
        else:
            if len(top) < 10:
                top.append((users[person], p))
                #print('just appended')
            else:
                if p > min(top, key=lambda x:x[1])[1]:
                    top.remove(min(top, key=lambda x:x[1]))
                    top.append((users[person], p))
                    #print("removed and appended")

    return top


#accuracy percentage for user2 with respect to user1
def check_accuracy(user1, user2):
    percent = 0.0
    base_size = len(user2.tags)

    for tg in user2.tags:
        if tg in user1.tags:
            percent += 1.0/base_size

    return percent


if __name__ == '__main__':
    top = top_matches()
    for match in top:
        print(match[0].name, match[1])
