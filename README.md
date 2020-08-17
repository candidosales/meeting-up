# Meeting UP

## Requirements

- Ruby 2.4.0
- Rails 4.2.8
- PostgreSQL

## Set up

1. Install dependencies

You have to use bundler 1.3.0v

```bash
gem install bundler -v 1.3.0

sudo gem install bcrypt -v '3.1.15'
sudo gem install eventmachine -v '1.0.9.1'
sudo gem install ffi -v '1.13.1'
sudo gem install sassc -v '2.4.0'

gem install delocalize -v '0.3.1'
bundle _1.3.0_ install
```

2. Install and set up database

```bash
rake db:create && rake db:migrate
```

3. Add users

```bash
rake db:seed
```

4. Reset the database

```bash
rake db:reset db:migrate
```

## Run

```bash
rails s
```

## Troubleshooting

### TypeError: ActiveSupport::Duration can't be coerced into Integer

https://weblog.rubyonrails.org/2017/2/11/this-week-in-rails-ruby-2-4-on-rails-4-2/

Solution: Upgrade Rails to 4.2.8

### Specified 'postgresql' for database adapter, but the gem is not loaded. Add `gem 'pg'` to your Gemfile (and ensure its version is at the minimum required by ActiveRecord).

Solution: Update the pg at Gemfile `gem 'pg', '~> 0.20.0'` and running:

```bash
bundle _1.3.0_ update pg
```

### NameError: uninitialized constant ActionController::Responder

Solution: Update the responders at Gemfile `gem 'responders', '~> 2.0.0'` and running:

```bash
bundle _1.3.0_ update responders
``` 


