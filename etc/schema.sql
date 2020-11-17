-- a simple Project Gutenberg database

create table titles (
	gid       INTEGER PRIMARY KEY,
	title     TEXT,
	author    TEXT,
	language  TEXT,
	rights    TEXT
);

create table subjects (
	gid      INTEGER,
	subject  TEXT
);

create table classifications (
	gid             INTEGER,
	classification  TEXT
);

create table files (
	gid   INTEGER,
	file  TEXT,
	mime  TEXT
);

