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

##accepts_invitation_for
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

You can then add this entity to the list of invitable classes on the `invited_to` call in your identity class.

#Usage
##Creating Invitations
To create an invitation to a given model:

```
entity = Entity.find(1)

entity.invite "foo@bar.com", :admin
```

The method will return the Invitation.  In the event that the email has already been invited to that entity, 
an `Invitational::AlreadyInvitedError` will be raised.  If the passed role is not valid for the given entity (based on its 
`accepts_invitation_as` call), an `Invitational::InvalidRoleError` will be raised.

###Immediately Claimed Invitations

In some situations it is preferable to have an invitation created that is immediately claimed by an existing user.
For example, if the current user is creating an invitable entity, they would likely want to have immediate administrative
authority to that entity.  In such situations, you can pass a user object (an instance of your identity class) to
the invite method instead of an email.  The invitation that is created will be immedately claimed by that user:

```
entity = Entity.create(...)

entity.invite current_user, :admin
```

##Claiming Invitations

Invitations can be claimed by passing their hash and the claiming user to the `claim` class method on Invitation:

```
Invitation.claim claim_hash, current_user
```

The method will return the claimed Invitation. In the event that the hash does match an existing invitation, 
an `Invitational::InvitationNotFoundError` will be raised.  If the hash is found, but the invitation has already 
been claimed, an `Invitational::AlreadyClaimedError` will be raised.

##Checking for Invitations

The `invited_to?` instance method that Invitational adds to your identity class provides an easy interface to 
check if a user has an accepted invitation to a specific entity.  Your query can be general (invited in any role) or 
specifically for a supplied role:

```
current_user.invited_to? entity
```

Will return true if the current user has accepted an invitation in any role to the entity.

```
current_user.invited_to? entity, :admin
```

Will only return true if the current user has accepted an invitation as an Admin to the entity.

##UberAdmin

Invitational provides a special, system-wide, invitation and role called `:uberadmin`.  A user that has
claimed an UberAdmin invitation will always indicate they have been invited to a given role for a given entity.  
In other words, every call to `invited_to?` for an UberAdmin will return true.  

To create an UberAdmin invitation:

```
License.invite_uberadmin "foo@bar.com"
```

As with creating standard invitations, you can pass a user instead of an email to have the invitation
claimed immediately by that user:

```
License.invite_uberadmin current_user
```

The process to claim an UberAdmin invitation is the same as any other invitation.

To make getting started with a brand new Invitational based environment easier, a rake task is provided to 
create a new UberAdmin invitation.

```
rake invitational:create_uberadmin
```

This will output the claim hash for a new UberAdmin invitation.

##CanCan

Invitational adds a new condition key to CanCan's abilities, `:role`. This allows you to define the role(s)
that a user must be invited into for a specific entity in order to perform the specified action.  For example, 
to indicate that a user invited to a parent entity in an admin role can manage the parent entity, but a user 
invited to a staff role can only read the parent entity, in your `ability.rb` file:

```
can :manage, Parent, roles: [:admin]
can :read, Parent, roles: [:staff]
```

###Invitation to a parent
To idenfitify abilities based upon invitations to a parent entity, add a hash as an element to the roles array, 
supplying the parent attribute name as a key, and an allowed roles array as the value:

```
can :manage, Child, roles[ {parent: [:admin, :staff]}]
```

The parent invitation can be used recursively too, to specify grand-parent (or above) relationships:

```
can :manage, Child, roles[ {parent: {grand_parent: [:admin, :staff]}}]
```

To specify child and parent invitations, you can combine them on one line:

```
can :manage, Child, roles[:child_admin, {parent: [:admin, :staff]}]
```

However, it is recommended to specify them on separate lines:

```
can :manage, Child, roles[:child_admin]
can :manage, Child, roles[ {parent: [:admin, :staff]}]
```
