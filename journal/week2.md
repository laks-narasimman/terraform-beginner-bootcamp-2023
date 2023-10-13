## Terraform Beginner Bootcamp 2023 - Week 2

## Terraform mock server

download the server using [git link](https://github.com/ExamProCo/terratowns_mock_server)
Once the server is downaloded, we see a folder called 'terratowns_mock_server'

**Need to make sure that the `.git` folder is removed uder this directory as it is not supposed to be committed**

##Working with Ruby
  
### Bundler

Bundler is a package manager for runy. It is the primary way to install ruby packages (known as gems) for ruby.

### Install Gems

You need to create a Gemfile and define your gems in that file.

```
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```
Then you need to run the bundle install command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

__Executing ruby scripts in the context of bundler__


We have to use bundle exec to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

Its great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

https://sinatrarb.com/ 

## Terratowns Mock Server
Running the web server
We can run the web server by executing the following commands:
```
bundle install
bundle exec ruby server.rb

```
All of the code for our server is stored in the server.rb file.

## working with Golang for setting up Terrtown schema


We need to provide permission to builder_provider file and execute

## CRUD

Terraform Provider resources utilize CRUD.

CRUD stands for Create, Read Update, and Delete

https://en.wikipedia.org/wiki/Create,_read,_update_and_delete 

## Terrahome AWS

```
module "home_payday" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.payday_public_path
  content_version = var.content_version
}
```

The public directory expects the following:

- index.html
- error.html
- assets

All top level files in assets will be copied, but not any subdirectories.
