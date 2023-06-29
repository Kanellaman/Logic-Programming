# Test Cases

```prolog
?- assignment(3, 14, ASP, ASA).
ASP = [1 - [a15, a12, a09, a07, a05, a03] - 13,
 2 - [a14, a11, a08, a04, a01] - 14,
 3 - [a13, a10, a06, a02] - 12]
ASA = [a01 - 2, a02 - 3, a03 - 1, a04 - 2, a05 - 1, a06 - 3,
 a07 - 1, a08 - 2, a09 - 1, a10 - 3, a11 - 2, a12 - 1,
 a13 - 3, a14 - 2, a15 - 1] --> ;
ASP = [1 - [a15, a12, a10, a07, a05, a03] - 13,
 2 - [a14, a11, a08, a04, a01] - 14,
 3 - [a13, a09, a06, a02] - 12]
ASA = [a01 - 2, a02 - 3, a03 - 1, a04 - 2, a05 - 1, a06 - 3,
 a07 - 1, a08 - 2, a09 - 3, a10 - 1, a11 - 2, a12 - 1,
 a13 - 3, a14 - 2, a15 - 1] --> ;
..............(6 more solutions)
```

Keep in mind that the solutions may vary from a machine to another but the number of solutions must be the same

```prolog
?- assignment(2, 40, ASP, ASA).
no
?- assignment(3, 13, ASP, ASA).
no
```

## Stressful tests

```prolog
?- findall(sol, assignment(5, 8, _, _), Solutions),
 length(Solutions, N).
Solutions = [sol, sol, sol, sol, sol, sol, sol, ...]
N = 2544

?- findall(sol, assignment(5, 9, _, _), Solutions),
 length(Solutions, N).
Solutions = [sol, sol, sol, sol, sol, sol, sol, ...]
N = 63852
```
