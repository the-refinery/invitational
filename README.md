[![Gem Version](https://badge.fury.io/rb/invitational.png)](http://badge.fury.io/rb/invitational)
[![Build Status](https://travis-ci.org/the-refinery/invitational.svg?branch=master)](https://travis-ci.org/the-refinery/invitational)

# Overview

The purpose of Invitational is to eliminate the tight coupling between user identity/authentication and application functional authorization.  It is a common pattern in multi-user systems that in order to grant access to someone else, an existing administrator must create a user account, providing a username and password, and then grant permissions to that account.  The administrator then needs to communicate the username and password to the individual, often via email.  The complexity of this process is compounded in multi-account based systems where a single user might wind up with mutiple user accounts with various usernames and passwords.

Inspired by 37Signals' single sign-on process for Basecamp, Invitational provides an intermediate layer between an identity model (i.e. User) and either the system as a whole or some specific entity to which authorization is given.  This intermediate layer, an Invitation, represents a granted role for the sytem or a given entity.  These roles can then be leveraged by the application's functional authorization system.

Invitational supplies a custom DSL on top of the CanCan gem to provide an easy implementation of role-based functional authorization.  This DSL supports the hierarchical model common in many systems.  Permissions can be esablished for a child based upon an invitation to its parent (or grandparent, etc).

An invitation is initially created in an un-claimed state.  The invitation is associated with an email address, but can be claimed by any user who has the unique claim hash.  The Invitational library allows for this delegation of authority, though it is fully possible for a host application to implement a requirement that the user claiming an invitation must match the email for which the invitation was created.  Once claimed, an invitation may not be claimed again by any other user.


# Getting Started
Invitational works with Rails 4.0 and up.  You can add it to your Gemfile with:

```
gem 'invitational'
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

# Types of Invitations
Invitational has three types of invitations:

## Entity
An `Entity` invitation, as the name imples, is for a specific entity within the system.  For example, in a contract management system, a user might be invited to a 
contract in the sytem with the role of 'Recipient' .  They might then be able to read and to mark that specific contract as signed, but not access any other contracts in the system.

## System
A `System` invitation is not related to a specific entity, but to the system overall. For example, in the contract management system mentioned above, another user might be 
invited to the sytem with the role of 'contract_manager'.  They might then be able to manage *all* contracts within the system, but not have authority to invite other users.

## UberAdmin
An `UberAdmin` invitation is also, like a `System` invitation, not related to a specific entity but to the system overall.  Unlike a `System` invitation, an `UberAdmin` invitation
effectively grants the associated user access to all parts of the system, as every inquiry for the existance of an invitation (either System or Entity) will indicate true.

# Implementation

## invited_to
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

## accepts_invitation_for
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

## accepts_system_roles_as
System roles are defined in the `Invitation` class. Simply add the list of system roles to the class method that has been defined for you by the 
generator:

```
accepts_system_roles_as :contract_manager, :bookkeeper
```

The `accepts_system_roles_as` method also sets up scopes on `Invitation` for each identified role:

```
License.contract_managers
License.bookkeepers
```

Similarly, the identity model is given scopes for each role:

```
User.uberadmins # returns users who are uberadmins
User.contract_managers # returns users with the contract_manager system role
User.bookkeepers # returns users with the bookkeepers system role
```

# Usage
## Creating Invitations
To create an entity invitation to a given model:

```
entity = Entity.find(1)

entity.invite "foo@bar.com", :admin
```

To create an invitation to a system role:

```
Invitation.invite_system_user "foo@bar.com", :contract_manager
```

The method will return the Invitation.  In the event that the email has already been invited to that entity or to the system role, 
an `Invitational::AlreadyInvitedError` will be raised.  If the passed role is not valid for the given entity (based on its 
`accepts_invitation_as` call) or not a valid system role, an `Invitational::InvalidRoleError` will be raised.


### Immediately Claimed Invitations

In some situations it is preferable to have an invitation created that is immediately claimed by an existing user.
For example, if the current user is creating an invitable entity, they would likely want to have immediate administrative
authority to that entity.  In such situations, you can pass a user object (an instance of your identity class) to
the invite method instead of an email.  The invitation that is created will be immedately claimed by that user:

```
entity = Entity.create(...)

entity.invite current_user, :admin
```

and

```
Invitation.invite_system_user current_user, :contract_manager
```


## Claiming Invitations

Invitations can be claimed by passing their hash and the claiming user to the `claim` class method on Invitation:

```
Invitation.claim claim_hash, current_user
```

The method will return the claimed Invitation. In the event that the hash does match an existing invitation, 
an `Invitational::InvitationNotFoundError` will be raised.  If the hash is found, but the invitation has already 
been claimed, an `Invitational::AlreadyClaimedError` will be raised.

## Checking for Invitations

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

For system roles, the `invited_to_system?` instance method on your identity class can be used:

```
current_user.invited_to_system? :contract_manager
```

## UberAdmin

Invitational provides a special, system-wide, invitation and role called `:uberadmin`.  A user that has
claimed an UberAdmin invitation will always indicate they have been invited to a given role for a given entity.  
In other words, every call to `invited_to?` or `invited_to_system?` for an UberAdmin will return true.  

To create an UberAdmin invitation:

```
Invitation.invite_uberadmin "foo@bar.com"
```

As with creating standard invitations, you can pass a user instead of an email to have the invitation
claimed immediately by that user:

```
Invitation.invite_uberadmin current_user
```

The process to claim an UberAdmin invitation is the same as any other invitation.

To make getting started with a brand new Invitational based environment easier, a rake task is provided to 
create a new UberAdmin invitation.

```
rake invitational:create_uberadmin
```

This will output the claim hash for a new UberAdmin invitation.

You can test to see if the a user is an uberadmin through:

```
current_user.uberadmin?
```

## CanCanCan

Invitational adds a new condition key to CanCanCan's abilities, `:role`. This allows you to define the role(s)
that a user must be invited into for a specific entity in order to perform the specified action.  For example, 
to indicate that a user invited to a parent entity in an admin role can manage the parent entity, but a user 
invited to a staff role can only read the parent entity, in your `ability.rb` file:

```
can :manage, Parent, roles: [:admin]
can :read, Parent, roles: [:staff]
cannot :edit, Parent, roles: [:consultant]
```

### System Roles
To specify system roles for a given ability, utilize the `system_roles` method inside a `roles:` array:

```
can :manage, contract, roles: [system_roles(:contract_manager, :sales_manager)]
```


### Invitation to a parent (or other attribute)
To idenfitify abilities based upon invitations to a parent entity or other attribute, Invitational provides an
```attribute_roles``` method.  The first argument is symbol indicating the attribute name of the parent entity, 
the second is an array of roles in which the user must be invited to the parent entity:

```
can :manage, Child, roles[attribute_roles(:parent, [:admin, :staff])]
```

To reference invitations on a "grand parent" (or higher) entity, ```attribute_roles``` optionally accepts
an array as the first parameter, indicating the "path" to the target entity.

To indicate that an invitation to the grandparent found here:

```
entity = Entity.first

entity.parent.grandparent
```

Pass the following as the first attribute:

```
can :manage, Child, roles[attribute_roles([:parent, :grandparent],  [:admin])]
```

To specify child and parent invitations, you can combine them on one line:

```
can :manage, Child, roles[:child_admin, attribute_roles(:parent, [:admin, :staff])]
```

However, it is recommended to specify them on separate lines:

```
can :manage, Child, roles[:child_admin]
can :manage, Child, roles[attribute_roles(:parent, [:admin, :staff])]
```
