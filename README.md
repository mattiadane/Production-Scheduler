# Production-Scheduler
This is a University project in which we had to create a scheduler of orders.
In this case, a specific company gives a text file in which stores the orders to schedule.

Every file in the Ordini directory is composed in this way:
```id,production_time,deadline,priority```

## How we store and order the data
Every time we store a data in the Stack, we have this column for each order:
|Stack|
|--------|
|........|
|Priority|
|Deadline|
|Production time|
|ID Order|

At this point, we have all the four data near to each other, so we can easily manage them during the scheduling process.

### HPF Algorithm
The first algoritm we use is the ```High Priority First``` and in case two orders have the same priority, we check the deadline and put first which one has the lower deadline.

### EDF Algorithm
The second algoritm we use is the ```Earliest Deadline First``` and in case two orders have the same deadline, we check the priority and put first which one has the higher priority

## How to use
Open a terminal and run these 3 commands:
```bash
mkdir obj
mkdir bin
make
```
At this point, all objects and executable files are created.

## How to run
In order to run this project, run this command:
```bash
./bin/pianificatore Ordini/orders_file
```

## Collaborators
- [Alessandro De Carli](https://github.com/Aledpl5)
