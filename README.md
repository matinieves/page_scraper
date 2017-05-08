# Page Scrapper

This a simple application that scrapes a page and save content of h1, h2, h3 and links elements.

* Ruby version - 2.3.3

# App setup

* bundle install
* rake db:create
* rake db:migrate

* `rails s` to run the application

# Usage example

* curl --data "url=http://www.google.com" http://localhost:3000/pages -- Redirections not supported

* curl  http://localhost:3000/pages
