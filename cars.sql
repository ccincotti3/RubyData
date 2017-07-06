CREATE TABLE cars (
  id INTEGER PRIMARY KEY,
  brand VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

INSERT INTO
  humans (id, fname, lname)
VALUES
  (1, "Carmen", "Cincotti"),
  (2, "Matt", "Smith"),
  (3, "Joey", "Chestnut"),
  (4, "Carless", "Human");

INSERT INTO
  cars (id, brand, owner_id)
VALUES
  (1, "Honda", 1),
  (2, "Hyundai", 2),
  (3, "Pontiac", 3),
  (4, "Subaru", 3),
  (5, "Delorean", NULL);
