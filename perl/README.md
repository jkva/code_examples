# README

This application is built using Dancer2, using Moops and DBIx::Class.

## Usage

To start the project, please make sure you have Perl installed, plus the dependencies listed below.
Then, run `./launch.sh` and navigate your browser to `http://localhost:9000`.

## Files

Files in this project:

* README.md - this file
* NOTES.md - design considerations
* launch.sh - quick application launch script
* orders.db.sql - the schema used for the SQLite DB
* orders.db - the SQLite db
* orders.csv - the originally supplied data file
* example\_report.html - an example of a generated report. _In-line css was added for illustration purposes. See NOTES.md_
* order_report/ - the application code
* perl_developer.txt - the original assignment

## Dependencies

Perl dependencies needed for this application are:

* Dancer2
* DBIx::Class
* Dancer2::Plugin::DBIC
* Locale::Currency::Format
* String::Trim
* Moops
* Text::CSV_XS
* Test::More
* Test::Exception
* IO::File