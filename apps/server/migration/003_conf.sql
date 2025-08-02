-- RUN first schema.sql

BEGIN;

INSERT INTO building_type (name, cost, shape)
VALUES
    ('Logging Camp', '{"wood":1}', '[[0, 0], [20, 0], [20, 20], [0, 20]]'),
    ('Timber hut', '{"wood":10}', '[[0, 0], [60, 0], [60, 40], [0, 40]]'),
    ('Quarry', '{"lumber":10}', '[[0, 0], [10, 0], [10, 10], [0, 10]]'),
    ('Brickyard', '{"lumber":10, "stone": 1}', '[[0, 0], [10, 0], [10, 10], [0, 10]]'),
    ('Farm', '{"wood":1}', '[[0, 0], [100, 0], [100, 100], [0, 100]]'),
    ('Bakery', '{"wood":10, "brick": 5}', '[[0, 0], [50, 0], [50, 50], [0, 50]]'),
    ('Fishery', '{"wood":10}', '[[0, 0], [10, 0], [10, 10], [0, 10]]'),
    ('Barn', '{"wood":10}', '[[0, 0], [10, 0], [10, 10], [0, 10]]'),
    ('Brewery', '{"wood":10}', '[[0, 0], [10, 0], [10, 10], [0, 10]]'),
    ('Mine', '{"lumber":10}', '[[0, 0], [10, 0], [10, 10], [0, 10]]'),
    ('Forge', '{"lumber":10, "brick": 5, "stone": 10}', '[[0, 0], [10, 0], [10, 10], [0, 10]]'),
    ('Carpentry', '{"lumber":10}', '[[0, 0], [10, 0], [10, 10], [0, 10]]');

INSERT INTO resource_type (name, need_category, tags)
VALUES
    ('wood', NULL, '{"raw","cheap","construction"}'),
    ('lumber', NULL, '{"construction"}'),
    ('clay', NULL, '{"construction","raw"}'),
    ('brick', NULL, '{"construction"}'),
    ('stone', NULL, '{"construction","raw"}'),
    ('marble', NULL, '{"construction","luxury"}'),
    ('grain', 'cereal', '{"food","cereal","raw","cheap"}'),
    ('bread', 'cereal', '{"food","cereal"}'),
    ('fish', 'meat', '{"food","cheap","meat","raw"}'),
    ('cattle', 'meat', '{"utility","food","fabric","raw","animal"}'),
    ('sheep', 'meat', '{"utility","food","fabric","raw","animal"}'),
    ('meat', 'meat', '{"food","meat"}'),
    ('milk', 'condiment', '{"food","condiment"}'),
    ('cheese', 'condiment', '{"food","condiment","luxury"}'),
    ('fruits', 'vegetable', '{"food","raw","vegetable"}'),
    ('vegetable', 'vegetable', '{"food","cheap","raw","vegetable"}'),
    ('oil', 'condiment', '{"food","condiment","luxury","merchandise"}'),
    ('salt', 'condiment', '{"food","raw","condiment","merchandise"}'),
    ('spices', 'condiment', '{"food","raw","luxury","condiment","merchandise"}'),
    ('wine', 'beverage', '{"food","beverage","luxury"}'),
    ('beer', 'beverage', '{"food","beverage"}'),
    ('iron', NULL, '{"metal","construction"}'),
    ('gold', NULL, '{"metal","raw","luxury"}'),
    ('wool', NULL, '{"fabric","cheap"}'),
    ('linen', NULL, '{"fabric","raw"}'),
    ('leather', NULL, '{"fabric"}'),
    ('silk', NULL, '{"fabric","raw","luxury"}'),
    ('cheap clothes', 'clothes', '{"fabric", "cheap"}'),
    ('common clothes', 'clothes', '{"fabric","merchandise"}'),
    ('luxury clothes', 'clothes', '{"fabric","luxury","merchandise"}'),
    ('tool', NULL, '{"construction", "utility"}'),
    ('cart', NULL, '{"construction", "utility"}'),
    ('horse', NULL, '{"weapon", "utility", "animal", "raw" }'),
    ('sword', NULL, '{"weapon"}'),
    ('lance', NULL, '{"weapon","cheap"}'),
    ('shield', NULL, '{"weapon"}'),
    ('bow', NULL, '{"weapon"}'),
    ('arrow', NULL, '{"weapon"}');


INSERT INTO production_method (name, building_type_id)
VALUES
    ('Wood cutting', 1),
    ('Farming', 5),
    ('Baking Bread', 6);

INSERT INTO production_method_item (production_method_id, resource, amount)
VALUES
    (1, 'wood', 10),
    (2, 'grain', 25),
    (3, 'grain', -20),
    (3, 'bread', 30);


INSERT INTO social_class (name, promote_to, demote_to)
VALUES
    ('peasant', 'artisan', NULL ),
    ('artisan', 'clerc', 'bourgeois'),
    ('clerc', 'bourgeois', 'artisan'),
    ('bourgeois', NULL, 'clerc'),
    ('noble', NULL, NULL);

INSERT INTO social_class_need (class, resource, amount, factor)
VALUES
    ('peasant', 'grain', 1, 1),
    ('artisan', 'grain', 1, .5),
    ('clerc', 'grain', 1, 1),
    ('bourgeois', 'grain', 1, 1),
    ('noble', 'grain', 1, 1);

COMMIT;

