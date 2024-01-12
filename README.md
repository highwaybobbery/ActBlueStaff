# ActBlue Staff Engineer Coding Challenge

Thank you for taking the time to consider this submission! I found the problem to be interesting, and offered some cool design challenges.
I enjoyed building an "Old School" Rails app, choosing a very simple stack over a more modern 2 tier approach with apis and a separate UI.
 ~ Alex Berry

## Project Resources
[requirements](docs/%5BStaff%5D%20Voting%20Machine%20-%20Take-Home%20Technical%20Exercise%20_.docx)

[results mockup](docs/Results.png)

[vote mockup](docs/Vote.png)

## Installation
1) Install ruby >~ 3.3.0
1) Install postgres `brew install postgres`
1) Install gems `bundle install`
1) Setup db `bundle exec rails db:create db:migrate`
1) Start the server `bundle exec rails s`

The App does not use any additional processes or services, so you should be good to go with just that.

## Tech Overview
This is a rails 7 app, built using Ruby 3.3.0, backed by a Postgres databse.
In the interest of simplicity this is a monolithic app with standard rails MVC.

The UI is bare bones, with only a teaspoon of javascript for the auto logout and logout timer.

The application uses the Rails cache backed by ActiveSupport::Cache::MemoryStore. In production I would probably opt for
Redis, using it to keep individual counts for each candidate in real time.

The cache is not enabled in development by default, in which case the cache will be bypassed.

To enable the cache (and thus the update of vote totals only after every 10 votes), execute this command from your terminal within the application root:
```
rails dev:cache
```

The update of the vote counts is executed in an ActiveJob queue, to keep voters from being delayed at vote submission.

### UI And Application Flow
Just for ease of navigation, I deviated a bit from the design. I gave access to the voting software and the results dashboard
within the same UI, but you do not need to log in to see the results.

The application is making heavy use of redirects and flash messages, which works well for an old school Rails MVC.
To build an application like this in production, I would probably opt for a 2 tier architecture, with the front end separately deployed.
Graphql would be a good fit for client - server communication.

Since I didn't implement any password security, I chose to omit it completely for this exercise,
as it would be bad practice to handle even fake passwords entered in testing as plain text.

I also just combined sign-in and sign-up into a single flow, the backend looks for an existing user by email
and either uses it, or saves a new user. Zip code handling is a little funny, as it will overwrite the zip if you 
sign in a second time, but this isn't really meant for repeated visists, so that's probably not a big deal.

### Testing and Development Process
After I built the main features in "Rails Startup" mode, I went back and dispersed a lot of the critical logic away from
the controllers, and wrote some test coverage for it.

The application would definitely benefit from some controller and integration tests, but that felt a bit out of scope for the
exercise.

### Schema decisions
The Schema seemed very straight forward. The only choice I felt was a little unusual was to use a separate table for the 
votes, even though it is a 1 to many relationship between candidates and users. I did this to keep the vote data a bit more
isolated from the voter data. In a sensitive application like this one, I felt this would allow for better data access
control. An example of this is that the vote tallying code does not join to a table that knows any identity information for
the voters.

I did not worry about indexes and constraints at the beginning of the build, but noted as I went along what constraints would
be needed. I then added those constraints and indexes to the database where possible, as well as to the Rails models.

This gave me an opportunity to ensure that even without application code, the database was resilient to bad data.

## Ideas for extra credit problems

### Account for "near misses" on candidate name entry.
We could separate the name into multiple fields, and then propose possible matches if 2 of them match (getting around middle name issues)
Alternatively Postgres has some features to calculate the similarity score between different strings, which could be interesting to explore:
[Similarity in Postgres and Rails using Trigrams](https://pganalyze.com/blog/similarity-in-postgres-and-ruby-on-rails-using-trigrams)

### Have the dashboard update “live” as new values are counted - i.e. without triggering a periodic refresh of the page.
Converting the votes index page to make an API call to fetch the votes would be a quick way to reduce overhead. This could simply be done on a timer.
ActionCable could be a nice fit to allow the server to push updated data to the clients as it is available, rather than having them polling for it.
Given the small number of candidates, I believe keeping numbers always up to date in a Key/Value store like Redis could make this extremely performant.
