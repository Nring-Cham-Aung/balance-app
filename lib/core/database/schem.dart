List<String> dbSchema = [
  '''
  CREATE TABLE IF NOT EXISTS category (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL,
    icon_code TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS balance (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT NOT NULL,
    amount INTEGER NOT NULL,
    date TEXT NOT NULL,
    type TEXT NOT NULL,
    category_id INTEGER
  )
  '''
];