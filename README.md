# Currency Service

A service that, provided a date range, fetches day-by-day UF value and USD value expressed on CLP, using data from Banco Central de Chile

Developed by [Alexis Ibarra](https://github.com/alexisibarra) for [Platanus](https://platan.us/)

## Requeriments

This project assumes the following tools are installed:

- [Ruby](https://www.ruby-lang.org/)
- [Bundler](https://bundler.io/)

# Installation

1. Clone the base from the repo:

    $ git clone git@bitbucket.org:alexisibarra/currency_service.git

2. Install all the dependencies

    $ bundle install

At this point you will have everything ready to execute the project

# Execution

Modify the client with the dates you are interested in and run:

    $ ruby client.rb
