# Test Cases
Same as [Project2](Project2_Activity_Assignment) but make use of the assignment_csp predicate. </br>

## Stressful tests
```prolog
?- assignment_opt(10, 5, 15, 1.0, 0, ASP, ASA, Cost).
Found a solution with cost 21
Found a solution with cost 17
Found a solution with cost 9
Found a solution with cost 7
Found a solution with cost 5
Found no solution with cost 1.0 .. 4.0
ASP = [1 - [a001, a002, a008] - 11,
 2 - [a004] - 9,
 3 - [a007, a009] - 11,
 4 - [a003, a006] - 11,
 5 - [a005, a010] - 12]
ASA = [a001 - 1, a002 - 1, a003 - 4, a004 - 2, a005 - 5,
 a006 - 4, a007 - 3, a008 - 1, a009 - 3, a010 - 5]
Cost = 5

?- assignment_opt(20, 5, 25, 1.0, 0, ASP, ASA, Cost).
Found a solution with cost 16
Found a solution with cost 8
Found a solution with cost 6
Found a solution with cost 4
Found a solution with cost 2
ASP = [1 - [a001, a019, a020] - 23,
 2 - [a004, a006, a016] - 22,
 3 - [a010, a011, a013, a014] - 22,
 4 - [a005, a007, a012, a015] - 23,
 5 - [a002, a003, a008, a009, a017, a018] - 23]
ASA = [a001 - 1, a002 - 5, a003 - 5, a004 - 2, a005 - 4,
 a006 - 2, a007 - 4, a008 - 5, a009 - 5, a010 - 3,
 a011 - 3, a012 - 4, a013 - 3, a014 - 3, a015 - 4,
 a016 - 2, a017 - 5, a018 - 5, ... - ..., ...]
Cost = 2
```
```prolog
?- assignment_opt(30, 4, 50, 1.0, 0, ASP, ASA, Cost).
Found a solution with cost 19
Found a solution with cost 15
Found a solution with cost 13
Found a solution with cost 11
Found a solution with cost 5
Found a solution with cost 3
Found a solution with cost 1
ASP = [1 - [a001, a005, a007, a011, a012, a019, a024] - 42,
 2 - [a002, a006, a008, a009, a015, a021, a023, a025,
 a027] - 42,
 3 - [a010, a013, a014, a020, a022, a026, a029, a030]
 - 42,
 4 - [a003, a004, a016, a017, a018, a028] - 43]
ASA = [a001 - 1, a002 - 2, a003 - 4, a004 - 4, a005 - 1,
 a006 - 2, a007 - 1, a008 - 2, a009 - 2, a010 - 3,
 a011 - 1, a012 - 1, a013 - 3, a014 - 3, a015 - 2,
 a016 - 4, a017 - 4, a018 - 4, ... - ..., ...]
Cost = 1

```