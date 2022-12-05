CREATE SEQUENCE user_id_sequence START 1;

CREATE TABLE user_info
(
    id        INTEGER NOT NULL PRIMARY KEY DEFAULT nextval('user_id_sequence'),
    device_id VARCHAR(255) UNIQUE
);

-- Can be unused --
CREATE SEQUENCE organisation_id_sequence START 1;

CREATE TABLE organisation
(
    id   INTEGER      NOT NULL PRIMARY KEY DEFAULT nextval('organisation_id_sequence'),
    name VARCHAR(255) NOT NULL,
    url  VARCHAR(512)
);

CREATE SEQUENCE card_id_sequence START 1;

CREATE TABLE card
(
    id              INTEGER       NOT NULL PRIMARY KEY DEFAULT nextval('card_id_sequence'),
    name            VARCHAR(255)  NOT NULL,
    -- Can be long...
    code            VARCHAR(1024) NOT NULL,
    hidden          BOOLEAN       NOT NULL DEFAULT FALSE,
    owner_id        INTEGER       NOT NULL REFERENCES user_info,
    organisation_id INTEGER REFERENCES organisation
);

-- Can be unused --
CREATE SEQUENCE filial_id_sequence START 1;

CREATE TABLE filial
(
    id              INTEGER          NOT NULL PRIMARY KEY DEFAULT nextval('filial_id_sequence'),
    organisation_id INTEGER          NOT NULL REFERENCES organisation,
    latitude        DOUBLE PRECISION NOT NULL,
    longitude       DOUBLE PRECISION NOT NULL
);
