#Overview

The purpose of Invitational is to eliminate the tight coupling between user identity/authentication and application authorization.  It is a common pattern in muti-user systems that in order to grant access to someone else, an existing administrator must create a user account, providing a username and password, and then grant permissions to that account.  The administrator then needs to communicate the username and password to the individual, often via email.  The complexity of this process is compounded in mult-account based systems where a single user might wind up with mutiple user accounts with various usernames and passwords.

Inspired by 37Signals and their single sign on process for Basecamp, Invitational provides an intermediate layer between an identity model (i.e. User) and some entity to which authorization is given.  This intermediate layer, an Invitation, represents a granted role for a given entity.  These roles can then be leveraged by the application's functional authorization system.

Out of the box, Invitational integrates with the CanCan gem through a custom DSL to provide an easy method of implementation of functional authorization.  The generator adds a reference to CanCan to the application's Gemfile, and sets up an initial Ability file.

An invitation is initially created in an un-claimed state.  The invitation is associated with an email address, but can be claimed by any user who has the unique claim hash.  The Invitational library allows for this delegation of authority, though it is fully possible for a host application to implement a requirement that the user claiming an invitation must match the email for which the invitation was created.  Once claimed, an invitation may not be claimed again by any other user.


#Configuration
Include the gem into your application

```
gem 'invitational', git: 'git@github.com:d-i/invitational.git'
```

Then execute the generator configure invitational into your application:

```
rails generate invitational identity_class_name
```

The generator defaults to an identity class name of "User", so if "User" is the identiy
model in your application, you can leave off the arguement:

```
rails generate invitational
```

The generator will add a database migration you will need to run:

```
rake db:migrate
```

You will also need to run bundle install again, as the generator will add the cancan gem to your gemfile

```
bundle install
```

#Implementation

##invited_to

##acccepts_invitation_for

#Usage
##Creating Invitations



##Claiming Invitations

##Checking for Invitations

##CanCan

##UberAdmin
