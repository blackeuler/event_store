# What is a DDD Projection ? 


So we are storing our state as a sereis of events. 

How do we get anything useful. Like say for instance the list of uncompleted todos? 


Well we will need to get our list of events. And then Compress all of them down into the state that you need.


how do we translate a list of 

"todo_created", "todo_edited", "todo_deleted", "todo_completed" into a list of uncompleted todos

Well just looking at it we can do the count of completed todos by just counting how many todo_completed events we have.


We can get a count of how many todos we have in total by counting the "todo_created" events. 


