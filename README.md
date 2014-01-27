# Invitational

Invitational is a libaray to provide a separation of concerns between
user identity/authentication and functional authorization.  It provides the ability
for an administrative user to invite another user to the system and define their
permissions without having to create a username and passowrd for the new user.

## Configuration

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


## Getting Started

*More content coming soon*

```
rake invitational:create_uberadmin
```
Will create an uberadmin invitation, and present the claim hash.  You can then claim this hash to setup the
initial uberadmin user.

## Usage

*More content coming soon*
