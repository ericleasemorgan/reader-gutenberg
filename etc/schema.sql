-- a simple Project Gutenberg database

create table titles (
	gid      INTEGER PRIMARY KEY,
	title    TEXT,
	author   TEXT,
	language TEXT,
	rights   TEXT
);

create table subjects (
	gid     INTEGER,
	subject TEXT
)
