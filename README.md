#Overview

The purpose of Invitational is to eliminate the tight coupling between user identity/authentication and application authorization.  It is a common pattern in multi-user systems that in order to grant access to someone else, an existing administrator must create a user account, providing a username and password, and then grant permissions to that account.  The administrator then needs to communicate the username and password to the individual, often via email.  The complexity of this process is compounded in multi-account based systems where a single user might wind up with mutiple user accounts with various usernames and passwords.

Inspired by 37Signals' single sign-on process for Basecamp, Invitational provides an intermediate layer between an identity model (i.e. User) and some entity to which authorization is given.  This intermediate layer, an Invitation, represents a granted role for a given entity.  These roles can then be leveraged by the application's functional authorization system.

Invitational supplies a custom DSL on top of the CanCan gem to provide an easy implementation of role-based functional authorization.  This DSL supports the hierarchical model common in many systems.  Permissions can be esablished for a child based upon an invitation to its parent (or grandparent, etc).

An invitation is initially created in an un-claimed state.  The invitation is associated with an email address, but can be claimed by any user who has the unique claim hash.  The Invitational library allows for this delegation of authority, though it is fully possible for a host application to implement a requirement that the user claiming an invitation must match the email for which the invitation was created.  Once claimed, an invitation may not be claimed again by any other user.


#Getting Started
Invitational works with Rails 4.0 and up.  You can add it to your Gemfile with:

```
gem 'invitational', git: 'git@github.com:d-i/invitational.git'
```

Run the bundle command to install it.

After you install the gem, you need to run the generator:

```
rails generate invitational:install MODEL
```

Replace MODEL with the class name of your identity class.  Since this is very frequently `User`, the
generator defaults to that class name, thus you can omit it if that is how your application is built:

```
rails generate invitational:install
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
The generator will setup your identity model (`User`) to include the `Invitational::InvitedTo` module.  As part of the Invitational 
functionality it provides, the `invited_to` method is added to your user class along with the foundational has_many relationship to 
Invitation.  This method accepts a list of the entity classes (as symbols) 
to which a user can be invited:

```
invited_to :customer, :vendor, :supplier
```

This will setup has_many :through relationships for each entity:

```
user.companies
user.vendors
user.suppliers
```

##acccepts_invitation_for
To configure an entity as able to accept invitations, use the `make_invitable` generator:

```
rails generate invitational:make_invitable MODEL, ROLE1, ROLE2...
```

Here, replace MODEL with the name of the entity class you are making invitable.  Replace, ROLE1, ROLE2 with the 
list of roles which are valid to this model, for example User, Admin.  The generator will include the `Invitational::AcceptsInvitationAs`
module, and will pre-populate the call to the `accepts_invitation_as` method with the list of roles supplied:

```
accepts_invitation_as :user, :admin
```

As with your identity class, a foundational has_many relationship is established with Invitation.  The `accepts_invitation_as`
method also sets up has_many :through relationships to user for each role identified:

```
entity.users
entity.admins
```

#Usage
##Creating Invitations



##Claiming Invitations

##Checking for Invitations

##CanCan

##UberAdmin
