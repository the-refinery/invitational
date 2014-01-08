# Invitational

Invitational is a gem to provide a separation of concerns between
user identity/authentication and functional authorization.

## Configuration

*More content coming soon*

```
gem 'invitational', git: 'git@github.com:d-i/invitational.git'
```

Given that the class name of your Devise (or other authentication environment) is "User"

```
rails generate invitational User role1 role2 role3 ...
```

Will configure invitational in your application.  You will then need to:

```
rake db:migrate
```

To run the migration added by the generator

You will also need to run bundle install again, as the generator will add the cancan gem to your gemfile


## Getting Started

*More content coming soon*

```
rake invitational:create_uberadmin
```
Will create an uberadmin invitation, and present the claim hash.  You can then claim this hash to setup the
initial uberadmin user.

## Usage

*More content coming soon*
