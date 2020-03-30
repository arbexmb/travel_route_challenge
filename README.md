# Travel Route Challenge

This repository contains an application design for the Travel Route Challenge.

## Introduction

The application was developed using Ruby as the programming language, and Rails as the main development framework. As requested, a console and a REST API interfaces were created, and their functionalities include searching for the cheapest travel route, given a .csv file, and creating a new route and append it to the file.

## Setup

There are two ways to setup the application.

*I have add a Dockerfile into the project to give it another way to set it up, if necessary.*

##### First option:

The first and simplest way to setup the application only requires that you have `ruby` installed in your local OS.

With that said, you can simply clone this repository, run `bundle install` to install the dependencies, and `rails s` to start the server on port 3000.

##### Second option:

Since I have set a Docker container in the application, it is possible to build and run the application with Docker.

After cloning this repository, run the following commands:

```
# docker build -t app_image .
# docker run --name app_image -d -p 3000:3000 app_image
```

The above commands will build the image, and run it on port 3000 detached from the active terminal process.

## Running the test suite

As requested, I have developed a few tests, to ensure the application runs smoothly. If you chose to setup the application without containerization, `rspec` is all you need to run the test suite.

However, if you mounted the application using docker, run the following:

```
# docker exec app_image rspec
```

Everything should pass!

## Running the console interface

As well as the test suite, there are two options to run the console interface. Without containerization:

```shell
ruby app/console.rb
```

And with containerization:

```
# docker exec -it app_image ruby app/console.rb
```

If departure and arrival airports exist in the collection on the .csv file, the cheapest route travel will be fetched as response, given the route entered by the user.

## Testing the API endpoints

As requested, the API has two endpoints:

#### 1. Create new travel route

- POST: http://127.0.0.1:3000/routes

It is possible to create a new travel route in this endpoint, by passing the arguments on the request body, like this:

```json
{
  "route": "GRU-ORL",
  "price": 40
}
```

The request above will create a new route and append it to the .csv file.

**OBS:** There are a lot of validations in order to create a route: a regex rule to validate the route string, a method to validate the price as a positive integer, and more.

#### 2. Get the cheapest travel route

- GET: http://127.0.0.1:3000/routes/cheapest/GRU-SCL

To fetch the cheapest travel route, you can pass the route you want as the parameter on the get request above. The response body will be an object with the cheapest route found, given the data on the .csv file.

## Observation

Please, note that the docker commands mentioned above must be run as root. And, also, port 3000 must be empty in order to properly run the application or the container.

## Conclusion

As requested, a way to fetch the cheapest route was developed. Probably, there is a more optimized way to do it, however this is what I could do in the little time I had to develop it. I hope it is enough to show my skills.

