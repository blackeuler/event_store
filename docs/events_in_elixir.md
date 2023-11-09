# Events in Elixir 

What does an Event need to have? 
 - type: string 
 - data: map
 - timestamps: utc_datetime 
 
 
 So if we just have events alone, and a event store we can just add events to our event store that 1, didnt happen  and two we have no way of maintaining our invariants. like you should not be able to delete/modify a nonexisting, todo. 
 
 We also need id's to track the todos.

