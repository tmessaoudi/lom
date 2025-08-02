-- CHARACTERS/HOUSES --

CREATE TABLE house (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES user (id)
);

CREATE TABLE character (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  sex TEXT NOT NULL CHECK (UPPER(sex) IN ('M', 'F')),
  birthdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  house_id INTEGER,
  FOREIGN KEY (house_id) REFERENCES house (id)
);

CREATE TABLE character_relation (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  subject_id INTEGER,
  object_id INTEGER,
  type TEXT NOT NULL,
  FOREIGN KEY (subject_id) REFERENCES character (id),
  FOREIGN KEY (object_id) REFERENCES character (id)
);

-- SETTLEMENTS/BUILDINGS --

CREATE TABLE building_type (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  shape TEXT NOT NULL,
  cost TEXT NOT NULL
);

CREATE TABLE resource_type (
  name TEXT PRIMARY KEY,
  need_category TEXT,
  tags TEXT
);

CREATE TABLE production_method (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  building_type_id INTEGER,
  name TEXT UNIQUE NOT NULL,
  FOREIGN KEY (building_type_id) REFERENCES building_type (id)
);

CREATE TABLE production_method_item (
  production_method_id INTEGER,
  resource TEXT,
  amount INTEGER NOT NULL,
  PRIMARY KEY (production_method_id, resource),
  FOREIGN KEY (production_method_id) REFERENCES production_method (id),
  FOREIGN KEY (resource) REFERENCES resource_type (name)
);

CREATE TABLE settlement (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  controller_id INTEGER,
  name TEXT NOT NULL,
  shape TEXT NOT NULL, 
  FOREIGN KEY (controller_id) REFERENCES character (id)
);

CREATE TABLE stock (
  settlement_id INTEGER,
  resource TEXT,
  amount INTEGER CHECK (amount >= 0) DEFAULT 0,
  PRIMARY KEY (settlement_id, resource),
  FOREIGN KEY (settlement_id) REFERENCES settlement (id),
  FOREIGN KEY (resource) REFERENCES resource_type (name)
);

CREATE TABLE building (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  settlement_id INTEGER,
  building_type_id INTEGER,
  production_method_id INTEGER,
  shape TEXT NOT NULL,
  built_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (settlement_id) REFERENCES settlement (id),
  FOREIGN KEY (building_type_id) REFERENCES building_type (id),
  FOREIGN KEY (production_method_id) REFERENCES production_method (id)
);

CREATE TABLE title (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  owner_id INTEGER,
  settlement_id INTEGER,
  suzerain_title_id INTEGER,
  name TEXT UNIQUE NOT NULL,
  type TEXT NOT NULL,
  FOREIGN KEY (owner_id) REFERENCES character (id),
  FOREIGN KEY (settlement_id) REFERENCES settlement (id),
  FOREIGN KEY (suzerain_title_id) REFERENCES title (id)
);

CREATE TABLE claim (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  claimant_id INTEGER,
  title_id INTEGER,
  strength INTEGER,
  FOREIGN KEY (claimant_id) REFERENCES character (id),
  FOREIGN KEY (title_id) REFERENCES title (id)
);

CREATE TABLE social_class (
  name TEXT PRIMARY KEY,
  promote_to TEXT,
  demote_to TEXT,
  FOREIGN KEY (promote_to) REFERENCES social_class (name),
  FOREIGN KEY (demote_to) REFERENCES social_class (name)
);

CREATE TABLE social_class_need(
  class TEXT,
  resource TEXT,
  amount REAL NOT NULL,
  factor REAL NOT NULL,
  PRIMARY KEY (class, resource),
  FOREIGN KEY (class) REFERENCES social_class (name),
  FOREIGN KEY (resource) REFERENCES resource_type (name)
);

CREATE TABLE pop (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  settlement_id INTEGER,
  social_class TEXT,
  size INTEGER,
  wealth REAL,
  FOREIGN KEY (settlement_id) REFERENCES settlement (id),
  FOREIGN KEY (social_class) REFERENCES social_class (name)
); 

ALTER TABLE house ADD COLUMN ruler_id REFERENCES character (id);

ALTER TABLE character ADD COLUMN position_id REFERENCES building (id);

CREATE VIRTUAL TABLE settlement_shape USING geopoly(settlement_id);
CREATE VIRTUAL TABLE building_shape USING geopoly(building_id);



-- TRIGGERS --

CREATE TRIGGER insert_settlement_shape AFTER INSERT ON settlement
  BEGIN
    -- TODO VALIDATE --
    INSERT INTO settlement_shape(_shape, settlement_id) VALUES (new.shape, new.id);
  END;
-- TODO DELETE --

CREATE TRIGGER insert_building_shape AFTER INSERT ON building
  BEGIN
    -- TODO VALIDATE --
    INSERT INTO building_shape (_shape, building_id) VALUES (new.shape, new.id);
  END;
-- TODO DELETE --