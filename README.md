# bitserv

serves git's bits using sinatra.

## requirements

* ruby 1.9
* bundler

## running

    cp example.application.yml application.yml
    # adjust application.yml
    bundle install
    rackup
    open http://localhost:9292

## special pages

* **index**: is displayed when navigating to /
* **header**: is displayed at the top of the page
* **footer**: is displayed at the bottom of the page

## license

see LICENSE.
