BEGIN;

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL, 
    CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

-- Running upgrade  -> a90c22f7a6ae

CREATE TABLE atps (
    id SERIAL NOT NULL, 
    title VARCHAR NOT NULL, 
    numbers VARCHAR NOT NULL, 
    about VARCHAR, 
    phone VARCHAR, 
    report VARCHAR, 
    PRIMARY KEY (id), 
    UNIQUE (numbers), 
    UNIQUE (title)
);

CREATE TABLE charts (
    id SERIAL NOT NULL, 
    label VARCHAR NOT NULL, 
    lats FLOAT[] NOT NULL, 
    lons FLOAT[] NOT NULL, 
    PRIMARY KEY (id)
);

CREATE TABLE tpus (
    id SERIAL NOT NULL, 
    name VARCHAR NOT NULL, 
    PRIMARY KEY (id), 
    UNIQUE (name)
);

CREATE TABLE users (
    id UUID NOT NULL, 
    name VARCHAR NOT NULL, 
    login VARCHAR, 
    hash_pass VARCHAR, 
    vkid VARCHAR, 
    rang INTEGER NOT NULL, 
    PRIMARY KEY (id)
);

CREATE TABLE routes (
    id SERIAL NOT NULL, 
    number VARCHAR NOT NULL, 
    label VARCHAR NOT NULL, 
    title VARCHAR NOT NULL, 
    info VARCHAR, 
    stage INTEGER, 
    care BOOLEAN, 
    atp_id INTEGER, 
    PRIMARY KEY (id), 
    FOREIGN KEY(atp_id) REFERENCES atps (id) ON DELETE CASCADE
);

CREATE TABLE stops (
    id SERIAL NOT NULL, 
    name VARCHAR NOT NULL, 
    about VARCHAR, 
    lat FLOAT NOT NULL, 
    lon FLOAT NOT NULL, 
    stage INTEGER NOT NULL, 
    tpu_id INTEGER, 
    PRIMARY KEY (id), 
    FOREIGN KEY(tpu_id) REFERENCES tpus (id) ON DELETE CASCADE
);

CREATE TABLE sections (
    route_id INTEGER NOT NULL, 
    "order" INTEGER NOT NULL, 
    stop_id INTEGER NOT NULL, 
    coef FLOAT NOT NULL, 
    stage INTEGER, 
    load INTEGER, 
    chart_id INTEGER, 
    PRIMARY KEY (route_id, "order"), 
    FOREIGN KEY(chart_id) REFERENCES charts (id) ON DELETE CASCADE, 
    FOREIGN KEY(route_id) REFERENCES routes (id) ON DELETE CASCADE, 
    FOREIGN KEY(stop_id) REFERENCES stops (id) ON DELETE CASCADE
);

CREATE TABLE timetables (
    id SERIAL NOT NULL, 
    day DATE, 
    start TIME WITHOUT TIME ZONE NOT NULL, 
    lap TIME WITHOUT TIME ZONE NOT NULL, 
    route_id INTEGER, 
    PRIMARY KEY (id), 
    FOREIGN KEY(route_id) REFERENCES routes (id) ON DELETE CASCADE
);

CREATE TABLE traffics (
    id SERIAL NOT NULL, 
    day DATE, 
    start TIME WITHOUT TIME ZONE NOT NULL, 
    "end" TIME WITHOUT TIME ZONE NOT NULL, 
    lap TIME WITHOUT TIME ZONE NOT NULL, 
    vehicles INTEGER, 
    route_id INTEGER, 
    PRIMARY KEY (id), 
    FOREIGN KEY(route_id) REFERENCES routes (id) ON DELETE CASCADE
);

CREATE SEQUENCE atps_seq;

CREATE SEQUENCE stops_seq;

CREATE SEQUENCE tpus_seq;

CREATE SEQUENCE routes_seq;

CREATE SEQUENCE charts_seq;

CREATE SEQUENCE timetables_seq;

CREATE SEQUENCE traffic_seq;

INSERT INTO users (id, name, vkid, rang) VALUES ('00000000-0000-0000-0000-000000000001',
        'Driver', '348066085', 99);

INSERT INTO alembic_version (version_num) VALUES ('a90c22f7a6ae') RETURNING alembic_version.version_num;

-- Running upgrade a90c22f7a6ae -> cbcce4ef8531

CREATE TABLE logs (
    id UUID NOT NULL, 
    created_ip VARCHAR(15) NOT NULL, 
    created_at TIMESTAMP WITHOUT TIME ZONE, 
    level INTEGER NOT NULL, 
    action VARCHAR NOT NULL, 
    information TEXT, 
    user_id UUID NOT NULL, 
    PRIMARY KEY (id), 
    FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE SET NULL
);

UPDATE alembic_version SET version_num='cbcce4ef8531' WHERE alembic_version.version_num = 'a90c22f7a6ae';

COMMIT;

