# What is an DDD Aggregate 

In the process of building this projectt I started thinking about what were my layer of seperation. So I am recording my notes here on what an aggregate is. 


[YouTube Link to Talk](https://www.youtube.com/watch?v=7h3DqZmvF9A) 

## Why do we need Aggregates? 

It is difficult to guarantee the consistency of changes 

## Responsibility of Aggregates

- Guarantee internal consistency
- Guarantee invariants 
- Manage concurrency 


### Eric Evans Definition of Aggregate

- A cluster of associated objects that we treat as a unit for the purpose of data changes.

## Invariants are driven by the domain 


## Static vs Temporal Model 

Static Model, a specific point in time. 

Temporal Model, a model that changes over time. I understand all of the temporal points that built up to that transaction.

## From static to process  model 

- Finite State Machines have no output

- Finite State Transducers have output


Essentially to get started with an aggregate you need to understand the invariants of the domain.

## Aggregate Design

The Aggregate is the Todo List.

What are the invariants of the domain?

What can you do with TODOs? 
What are you not allowed to do with TODOs? 

I should be able to see a list of TODOs.
I should be able to add a TODO to my list.

Listing my TODOs will require a projection.



I should be able to mark a TODO as complete with an identfier.
I should be able to delete a TODO using an identifier.
I should be able to edit the title of a TODO using an identfier.








