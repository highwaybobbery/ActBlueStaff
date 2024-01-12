# ActBlue Staff Engineer Coding Challenge by Alex Berry

## Tech Overview
This is a rails 7 app, built using Ruby 3.3.0, backed by a Postgres databse.
In the interest of simplicity this is a monolithic app with standard rails MVC.

The application uses the Rails cache backed by ActiveSupport::Cache::MemoryStore.
It is not enabled in development by default, in which case the cache will be bypassed.

To enable the cache (and thus the update of vote totals only after every 10 votes), execute this command from your terminal within the application root:
```
rails dev:cache
```

The update of the counts is executed in a ActiveJob queue, to keep voters from being delayed at vote submission.

## Installation
1) Install ruby >~ 3.3.0
1) Install postgres `brew install postgres`
1) Install gems `bundle install`
1) Setup db `bundle exec rails db:create db:migrate`
1) Start the server `bundle exec rails s`
