DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate
(
    id          INTEGER             NOT NULL PRIMARY KEY,
    name        VARCHAR(64)         NOT NULL,
    description VARCHAR(4096)       NOT NULL,
    thumbnail   VARCHAR(128)        NOT NULL,
    address     VARCHAR(128)        NOT NULL,
    latitude_longitude   POINT    NOT NULL,
    rent        INTEGER             NOT NULL,
    door_height INTEGER             NOT NULL,
    door_width  INTEGER             NOT NULL,
    features    VARCHAR(64)         NOT NULL,
    popularity  INTEGER             NOT NULL,
    features_bit BIGINT(64) unsigned not null default '0',
    door_height_range   INTEGER     NOT NULL,
    door_width_range    INTEGER     NOT NULL,
    rent_range  INTEGER             NOT NULL
);

CREATE TABLE isuumo.chair
(
    id          INTEGER         NOT NULL PRIMARY KEY,
    name        VARCHAR(64)     NOT NULL,
    description VARCHAR(4096)   NOT NULL,
    thumbnail   VARCHAR(128)    NOT NULL,
    price       INTEGER         NOT NULL,
    height      INTEGER         NOT NULL,
    width       INTEGER         NOT NULL,
    depth       INTEGER         NOT NULL,
    color       VARCHAR(64)     NOT NULL,
    features    VARCHAR(64)     NOT NULL,
    kind        VARCHAR(64)     NOT NULL,
    popularity  INTEGER         NOT NULL,
    stock       INTEGER         NOT NULL,
    features_bit BIGINT(64) unsigned not null default '0',
    price_range INTEGER         NOT NULL,
    height_range    INTEGER     NOT NULL,
    width_range INTEGER         NOT NULL,
    depth_range INTEGER         NOT NULL
);

-- index for SELECT * FROM estate ORDER BY rent ASC, id ASC LIMIT 20
CREATE INDEX idx_estate_rent_id ON isuumo.estate (rent asc, id asc);

-- index for SELECT * FROM chair WHERE stock > 0 ORDER BY price ASC, id ASC LIMIT 20
CREATE INDEX idx_stock ON isuumo.chair (stock);
CREATE INDEX idx_price ON isuumo.chair (price);

-- index for estate nazotte
CREATE SPATIAL INDEX sp_index_ll ON isuumo.estate (latitude_longitude);
