# Events101


## What is this? 

So recently I have been learning about event sourcing. I have been reading alot of material, watching tons of videos. I've come to the conclusion that the best way of learning is by doing. So I decided to build a simple event sourcing application.

## What is event sourcing?

Event Sourcing is essentially the idea that instead of storing your application state as one big blob, you store it as a series of events. 

An event is a record of something that has happened in your application.


These events are _immutable_ and are stored in an event store. The event store is essentially a database that stores events.

## Domain: Todo 

I think the trend is to build a todo app in any new framework. So we are building a todo app.

We will have the following events:

- TodoCreated
- TodoTitleUpdated 
- TodoCompleted

So yeah you can think of your day as a software engineer and you have things to do. You create a todo, you update the title and you complete it.

## Roadmap

- [ ] Event Store 
      - get all events 
      - get events by aggregate id
      - persist events
      




# How to run this?


To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.



# Definitions 

## Immutable 

Immutable means that once something is created, it cannot be changed.

