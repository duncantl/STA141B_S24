CREATE TABLE Foo (
 g INTEGER,
 age  INTEGER
);

INSERT INTO Foo VALUES
(1, 20),
(1, 30),
(1, 10),
(2, 55),
(2, 27),
(3, 20),
(3, 55),
(3, 30),
(3, 45);

-- Within each group, get the record with the minimum value of age
select * FROM Foo
GROUP BY g
HAVING age = MIN(age);


select * FROM Foo
GROUP BY g
HAVING (MAX(age) - MIN(age)) > 20;

