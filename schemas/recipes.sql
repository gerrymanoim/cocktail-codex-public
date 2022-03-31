CREATE TABLE recipes (
    name TEXT NOT NULL,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    notes TEXT,
    FOREIGN KEY(post_id) REFERENCES posts(rowid)
)
;
