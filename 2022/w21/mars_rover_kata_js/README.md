playing around with:

- the concept of a grid is left out; just fixed width and height of 10 - unlike what I did before.
- leaving the command handling part inside the rover.
- ~~then again pushing it down into command handlers; created by a factory - should the factory be tested separately (or is this a set of sociable tests - the factory and the command handlers will be "covered" by tests for the rover; and they are under the rover omega-mess)? maybe only later when a specific test is made to the factory?~~ (statically typed vs dynamically typed? dead-end collaborator? black-box?)
- if there are obstacles, the grid needs to be reintroduced.
