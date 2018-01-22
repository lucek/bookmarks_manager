
# Bookmark Manager

Bookmark manager with user authentication

## Setup

* Clone this repository
* Install gems

    ```
    $ bundle install
    ```

* Create database.yml from database.yml.example

    ```
    $ cp config/database.yml.example config/database.yml
    ```

* Create the database

    ```
    $ rails db:create
    ```

* Migrate the database

    ```
    $ rails db:migrate
    ```

* Run the application

    ```
    $ bundle exec rails s
    ```

* Running the test suite

   ```
   rspec spec
   ```
