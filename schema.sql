--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-2.pgdg90+1)
-- Dumped by pg_dump version 10.4

-- Started on 2018-11-29 00:29:59 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 17 (class 2615 OID 20576)
-- Name: waze; Type: SCHEMA; Schema: -; Owner: jonathan
--

CREATE SCHEMA waze;


ALTER SCHEMA waze OWNER TO jonathan;

--
-- TOC entry 509 (class 1255 OID 30927)
-- Name: getLatAlerts(character varying); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getLatAlerts"(identificador character varying) RETURNS text
    LANGUAGE plpgsql PARALLEL SAFE
    AS $$
DECLARE
	sql text;
	result text;
BEGIN
    sql := 'SELECT location -> ''y'' FROM waze.alerts as a WHERE a.id = '''||identificador||'''';
	execute sql into result;
	return result;
END;
$$;


ALTER FUNCTION waze."getLatAlerts"(identificador character varying) OWNER TO jonathan;

--
-- TOC entry 459 (class 1255 OID 142457)
-- Name: getLineIrregularities(character varying); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getLineIrregularities"(identificador character varying) RETURNS text
    LANGUAGE plpgsql PARALLEL SAFE
    AS $_$

DECLARE
	resulte text default '';
	string jsonb;
	aux text;
	auy text;
	cont int default 0;
	tam int;
	getx text default null;
	gety text default null;
BEGIN
	EXECUTE 'SELECT jsonb_array_length(line) FROM waze.irregularities WHERE id = '''||identificador||'''' INTO tam;
	EXECUTE 'SELECT line FROM waze.irregularities WHERE id = '''||identificador||'''' INTO string;
	getx := 'SELECT $1->$2->''x''';
	EXECUTE getx using string, cont INTO aux;
	gety := 'SELECT $1->$2->''y''';
	EXECUTE gety using string, cont INTO auy;
	resulte := aux||' '||auy;
	FOR cont IN 1..tam-1 LOOP
		getx := 'SELECT $1->$2->''x''';
		EXECUTE getx using string, cont INTO aux;
		gety := 'SELECT $1->$2->''y''';
		EXECUTE gety using string, cont INTO auy;
		resulte := resulte||', '||aux||' '||auy;
	END LOOP;
	return resulte;
END;

$_$;


ALTER FUNCTION waze."getLineIrregularities"(identificador character varying) OWNER TO jonathan;

--
-- TOC entry 584 (class 1255 OID 39749)
-- Name: getLineJams(character varying); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getLineJams"(identificador character varying) RETURNS text
    LANGUAGE plpgsql PARALLEL SAFE
    AS $_$

DECLARE
	resulte text default '';
	string jsonb;
	aux text;
	auy text;
	cont int default 0;
	tam int;
	getx text default null;
	gety text default null;
BEGIN
	EXECUTE 'SELECT jsonb_array_length(line) FROM waze.jams WHERE id = '''||identificador||'''' INTO tam;
	EXECUTE 'SELECT line FROM waze.jams WHERE id = '''||identificador||'''' INTO string;
	getx := 'SELECT $1->$2->''x''';
	EXECUTE getx using string, cont INTO aux;
	gety := 'SELECT $1->$2->''y''';
	EXECUTE gety using string, cont INTO auy;
	resulte := aux||' '||auy;
	FOR cont IN 1..tam-1 LOOP
		getx := 'SELECT $1->$2->''x''';
		EXECUTE getx using string, cont INTO aux;
		gety := 'SELECT $1->$2->''y''';
		EXECUTE gety using string, cont INTO auy;
		resulte := resulte||', '||aux||' '||auy;
	END LOOP;
	return resulte;
END;

$_$;


ALTER FUNCTION waze."getLineJams"(identificador character varying) OWNER TO jonathan;

--
-- TOC entry 508 (class 1255 OID 30926)
-- Name: getLongAlerts(character varying); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getLongAlerts"(identificador character varying) RETURNS text
    LANGUAGE plpgsql PARALLEL SAFE
    AS $$DECLARE
	sql text;
	result text;
BEGIN
    sql := 'SELECT location -> ''x'' FROM waze.alerts as a WHERE a.id = '''||identificador||'''';
	execute sql into result;
	return result;
END;
$$;


ALTER FUNCTION waze."getLongAlerts"(identificador character varying) OWNER TO jonathan;

--
-- TOC entry 516 (class 1255 OID 39730)
-- Name: getRowsAlerts(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getRowsAlerts"() RETURNS bigint
    LANGUAGE sql PARALLEL SAFE
    AS $$
SELECT COUNT(id) FROM waze.alerts
$$;


ALTER FUNCTION waze."getRowsAlerts"() OWNER TO jonathan;

--
-- TOC entry 523 (class 1255 OID 39758)
-- Name: getRowsAlertsIsNull(); Type: FUNCTION; Schema: waze; Owner: baldo
--

CREATE FUNCTION waze."getRowsAlertsIsNull"() RETURNS bigint
    LANGUAGE sql PARALLEL SAFE
    AS $$

SELECT COUNT(id) FROM waze.alerts where geom is null

$$;


ALTER FUNCTION waze."getRowsAlertsIsNull"() OWNER TO baldo;

--
-- TOC entry 458 (class 1255 OID 142456)
-- Name: getRowsIrregularitiesIsNull(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getRowsIrregularitiesIsNull"() RETURNS bigint
    LANGUAGE sql COST 10 PARALLEL SAFE
    AS $$

SELECT COUNT(id) FROM waze.irregularities WHERE geom is null;

$$;


ALTER FUNCTION waze."getRowsIrregularitiesIsNull"() OWNER TO jonathan;

--
-- TOC entry 582 (class 1255 OID 50389)
-- Name: getRowsJams(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getRowsJams"() RETURNS bigint
    LANGUAGE sql COST 10 PARALLEL SAFE
    AS $$
SELECT COUNT(id) FROM waze.jams
$$;


ALTER FUNCTION waze."getRowsJams"() OWNER TO jonathan;

--
-- TOC entry 586 (class 1255 OID 102930)
-- Name: getRowsJamsIsNull(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."getRowsJamsIsNull"() RETURNS bigint
    LANGUAGE sql COST 10 PARALLEL SAFE
    AS $$

SELECT COUNT(id) FROM waze.jams WHERE geom is null;

$$;


ALTER FUNCTION waze."getRowsJamsIsNull"() OWNER TO jonathan;

--
-- TOC entry 518 (class 1255 OID 39734)
-- Name: insertGeom(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."insertGeom"() RETURNS void
    LANGUAGE plpgsql PARALLEL SAFE
    AS $$
DECLARE
   reg record;
   long text;
   lat text;
   geo_from_text text;
   contador bigint default 0;
   maximo bigint;
BEGIN
   EXECUTE 'SELECT waze."getRowsAlerts"()' INTO maximo;
   FOR contador in 0..maximo by 1000 LOOP
	   FOR reg IN SELECT id FROM waze.alerts LIMIT 1000 OFFSET contador loop
		   EXECUTE 'SELECT waze."getLongAlerts"('''||reg.id||''')' INTO long;
		   EXECUTE 'SELECT waze."getLatAlerts"('''||reg.id||''')' INTO lat;
		   geo_from_text := ST_GeomFromText('POINT('||long||' '||lat||')',4326);
		   EXECUTE 'UPDATE waze.alerts SET geom = '''||geo_from_text||''' WHERE ID = '''||reg.id||''';';
	   END LOOP;
   END LOOP;
end;
$$;


ALTER FUNCTION waze."insertGeom"() OWNER TO jonathan;

--
-- TOC entry 460 (class 1255 OID 142458)
-- Name: insertGeomIrregularitiesIsNull(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."insertGeomIrregularitiesIsNull"() RETURNS void
    LANGUAGE plpgsql PARALLEL SAFE
    AS $$

DECLARE
   reg record;
   resulte text;
   geo_from_text text;
   contador bigint default 0;
   maximo bigint;
BEGIN
   EXECUTE 'SELECT waze."getRowsIrregularitiesIsNull"()' INTO maximo;
   FOR contador in 0..maximo by 1000 LOOP
	   FOR reg IN SELECT id FROM waze.irregularities WHERE geom is null LIMIT 1000 OFFSET contador loop
		   EXECUTE 'SELECT waze."getLineIrregularities"('''||reg.id||''')' INTO resulte;
		   geo_from_text := ST_GeomFromText('LINESTRING('||resulte||')',4326);
		   EXECUTE 'UPDATE waze.irregularities SET geom = '''||geo_from_text||''' WHERE ID = '''||reg.id||''';';
	   END LOOP;
   END LOOP;
end;

$$;


ALTER FUNCTION waze."insertGeomIrregularitiesIsNull"() OWNER TO jonathan;

--
-- TOC entry 524 (class 1255 OID 39759)
-- Name: insertGeomIsNull(); Type: FUNCTION; Schema: waze; Owner: baldo
--

CREATE FUNCTION waze."insertGeomIsNull"() RETURNS void
    LANGUAGE plpgsql PARALLEL SAFE
    AS $$

DECLARE
   reg record;
   long text;
   lat text;
   geo_from_text text;
   contador bigint default 0;
   maximo bigint;
BEGIN
   EXECUTE 'SELECT waze."getRowsAlertsIsNull"()' INTO maximo;
   FOR contador in 0..maximo by 1000 LOOP
	   FOR reg IN SELECT id FROM waze.alerts where geom is null LIMIT 1000 OFFSET contador loop
		   EXECUTE 'SELECT waze."getLongAlerts"('''||reg.id||''')' INTO long;
		   EXECUTE 'SELECT waze."getLatAlerts"('''||reg.id||''')' INTO lat;
		   geo_from_text := ST_GeomFromText('POINT('||long||' '||lat||')',4326);
		   EXECUTE 'UPDATE waze.alerts SET geom = '''||geo_from_text||''' WHERE ID = '''||reg.id||''';';
	   END LOOP;
   END LOOP;
end;

$$;


ALTER FUNCTION waze."insertGeomIsNull"() OWNER TO baldo;

--
-- TOC entry 585 (class 1255 OID 50390)
-- Name: insertGeomJams(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."insertGeomJams"() RETURNS void
    LANGUAGE plpgsql PARALLEL SAFE
    AS $$

DECLARE
   reg record;
   resulte text;
   geo_from_text text;
   contador bigint default 0;
   maximo bigint;
BEGIN
   EXECUTE 'SELECT waze."getRowsJams"()' INTO maximo;
   FOR contador in 0..maximo by 1000 LOOP
	   FOR reg IN SELECT id FROM waze.jams LIMIT 1000 OFFSET contador loop
		   EXECUTE 'SELECT waze."getLineJams"('''||reg.id||''')' INTO resulte;
		   geo_from_text := ST_GeomFromText('LINESTRING('||resulte||')',4326);
		   EXECUTE 'UPDATE waze.jams SET geom = '''||geo_from_text||''' WHERE ID = '''||reg.id||''';';
	   END LOOP;
   END LOOP;
end;

$$;


ALTER FUNCTION waze."insertGeomJams"() OWNER TO jonathan;

--
-- TOC entry 587 (class 1255 OID 102931)
-- Name: insertGeomJamsIsNull(); Type: FUNCTION; Schema: waze; Owner: jonathan
--

CREATE FUNCTION waze."insertGeomJamsIsNull"() RETURNS void
    LANGUAGE plpgsql PARALLEL SAFE
    AS $$

DECLARE
   reg record;
   resulte text;
   geo_from_text text;
   contador bigint default 0;
   maximo bigint;
BEGIN
   EXECUTE 'SELECT waze."getRowsJamsIsNull"()' INTO maximo;
   FOR contador in 0..maximo by 1000 LOOP
	   FOR reg IN SELECT id FROM waze.jams WHERE geom is null LIMIT 1000 OFFSET contador loop
		   EXECUTE 'SELECT waze."getLineJams"('''||reg.id||''')' INTO resulte;
		   geo_from_text := ST_GeomFromText('LINESTRING('||resulte||')',4326);
		   EXECUTE 'UPDATE waze.jams SET geom = '''||geo_from_text||''' WHERE ID = '''||reg.id||''';';
	   END LOOP;
   END LOOP;
end;

$$;


ALTER FUNCTION waze."insertGeomJamsIsNull"() OWNER TO jonathan;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 221 (class 1259 OID 20621)
-- Name: alerts; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.alerts (
    id character varying(40) NOT NULL,
    uuid text NOT NULL,
    pub_millis bigint NOT NULL,
    pub_utc_date timestamp without time zone,
    road_type integer,
    location jsonb,
    street text,
    city text,
    country text,
    magvar integer,
    reliability integer,
    report_description text,
    report_rating integer,
    confidence integer,
    type text,
    subtype text,
    report_by_municipality_user boolean,
    thumbs_up integer,
    jam_uuid text,
    datafile_id bigint NOT NULL,
    geom public.geometry
);


ALTER TABLE waze.alerts OWNER TO jonathan;

--
-- TOC entry 219 (class 1259 OID 20613)
-- Name: alert_types; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.alert_types (
    id integer NOT NULL,
    type text NOT NULL,
    subtype text
);


ALTER TABLE waze.alert_types OWNER TO jonathan;

--
-- TOC entry 220 (class 1259 OID 20619)
-- Name: alert_types_id_seq; Type: SEQUENCE; Schema: waze; Owner: jonathan
--

CREATE SEQUENCE waze.alert_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE waze.alert_types_id_seq OWNER TO jonathan;

--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 220
-- Name: alert_types_id_seq; Type: SEQUENCE OWNED BY; Schema: waze; Owner: jonathan
--

ALTER SEQUENCE waze.alert_types_id_seq OWNED BY waze.alert_types.id;


--
-- TOC entry 222 (class 1259 OID 20627)
-- Name: coordinate_type; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.coordinate_type (
    id integer NOT NULL,
    type_name text NOT NULL
);


ALTER TABLE waze.coordinate_type OWNER TO jonathan;

--
-- TOC entry 223 (class 1259 OID 20633)
-- Name: coordinates; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.coordinates (
    id character varying(40) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    "order" integer NOT NULL,
    jam_id character varying(40),
    irregularity_id character varying(40),
    alert_id character varying(40),
    coordinate_type_id integer
);


ALTER TABLE waze.coordinates OWNER TO jonathan;

--
-- TOC entry 224 (class 1259 OID 20636)
-- Name: data_files; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.data_files (
    id integer NOT NULL,
    start_time_millis bigint NOT NULL,
    end_time_millis bigint NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    date_created timestamp without time zone,
    date_updated timestamp without time zone,
    file_name text NOT NULL,
    json_hash character varying(40) NOT NULL
);


ALTER TABLE waze.data_files OWNER TO jonathan;

--
-- TOC entry 225 (class 1259 OID 20642)
-- Name: data_files_id_seq; Type: SEQUENCE; Schema: waze; Owner: jonathan
--

CREATE SEQUENCE waze.data_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE waze.data_files_id_seq OWNER TO jonathan;

--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 225
-- Name: data_files_id_seq; Type: SEQUENCE OWNED BY; Schema: waze; Owner: jonathan
--

ALTER SEQUENCE waze.data_files_id_seq OWNED BY waze.data_files.id;


--
-- TOC entry 226 (class 1259 OID 20644)
-- Name: irregularities; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.irregularities (
    id character varying(40) NOT NULL,
    uuid text NOT NULL,
    detection_date_millis bigint NOT NULL,
    detection_date text,
    detection_utc_date timestamp without time zone,
    update_date_millis bigint NOT NULL,
    update_date text,
    update_utc_date timestamp without time zone,
    street text,
    city text,
    country text,
    is_highway boolean,
    speed real,
    regular_speed real,
    delay_seconds integer,
    seconds integer,
    length integer,
    trend integer,
    type text,
    severity real,
    jam_level integer,
    drivers_count integer,
    alerts_count integer,
    n_thumbs_up integer,
    n_comments integer,
    n_images integer,
    line jsonb,
    cause_type text,
    start_node text,
    end_node text,
    datafile_id bigint NOT NULL,
    geom public.geometry
);


ALTER TABLE waze.irregularities OWNER TO jonathan;

--
-- TOC entry 227 (class 1259 OID 20650)
-- Name: jams; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.jams (
    id character varying(40) NOT NULL,
    uuid text NOT NULL,
    pub_millis bigint NOT NULL,
    pub_utc_date timestamp without time zone,
    start_node text,
    end_node text,
    road_type integer,
    street text,
    city text,
    country text,
    delay integer,
    speed real,
    speed_kmh real,
    length integer,
    turn_type text,
    level integer,
    blocking_alert_id text,
    line jsonb,
    type text,
    turn_line jsonb,
    datafile_id bigint NOT NULL,
    geom public.geometry
);


ALTER TABLE waze.jams OWNER TO jonathan;

--
-- TOC entry 228 (class 1259 OID 20656)
-- Name: roads; Type: TABLE; Schema: waze; Owner: jonathan
--

CREATE TABLE waze.roads (
    id integer NOT NULL,
    value integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE waze.roads OWNER TO jonathan;

--
-- TOC entry 229 (class 1259 OID 20659)
-- Name: roads_id_seq; Type: SEQUENCE; Schema: waze; Owner: jonathan
--

CREATE SEQUENCE waze.roads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE waze.roads_id_seq OWNER TO jonathan;

--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 229
-- Name: roads_id_seq; Type: SEQUENCE OWNED BY; Schema: waze; Owner: jonathan
--

ALTER SEQUENCE waze.roads_id_seq OWNED BY waze.roads.id;


--
-- TOC entry 4566 (class 2604 OID 20665)
-- Name: alert_types id; Type: DEFAULT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.alert_types ALTER COLUMN id SET DEFAULT nextval('waze.alert_types_id_seq'::regclass);


--
-- TOC entry 4567 (class 2604 OID 20666)
-- Name: data_files id; Type: DEFAULT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.data_files ALTER COLUMN id SET DEFAULT nextval('waze.data_files_id_seq'::regclass);


--
-- TOC entry 4568 (class 2604 OID 20667)
-- Name: roads id; Type: DEFAULT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.roads ALTER COLUMN id SET DEFAULT nextval('waze.roads_id_seq'::regclass);


--
-- TOC entry 4570 (class 2606 OID 20958)
-- Name: alert_types alert_types_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.alert_types
    ADD CONSTRAINT alert_types_pkey PRIMARY KEY (id);


--
-- TOC entry 4572 (class 2606 OID 20960)
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- TOC entry 4574 (class 2606 OID 20963)
-- Name: coordinate_type coordinate_type_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.coordinate_type
    ADD CONSTRAINT coordinate_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4576 (class 2606 OID 20965)
-- Name: coordinates coordinates_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.coordinates
    ADD CONSTRAINT coordinates_pkey PRIMARY KEY (id);


--
-- TOC entry 4579 (class 2606 OID 20990)
-- Name: data_files data_files_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.data_files
    ADD CONSTRAINT data_files_pkey PRIMARY KEY (id);


--
-- TOC entry 4581 (class 2606 OID 20992)
-- Name: irregularities irregularities_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.irregularities
    ADD CONSTRAINT irregularities_pkey PRIMARY KEY (id);


--
-- TOC entry 4583 (class 2606 OID 20994)
-- Name: jams jams_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.jams
    ADD CONSTRAINT jams_pkey PRIMARY KEY (id);


--
-- TOC entry 4585 (class 2606 OID 20996)
-- Name: roads roads_pkey; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.roads
    ADD CONSTRAINT roads_pkey PRIMARY KEY (id);


--
-- TOC entry 4587 (class 2606 OID 20998)
-- Name: roads roads_unique_combo; Type: CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.roads
    ADD CONSTRAINT roads_unique_combo UNIQUE (value, name);


--
-- TOC entry 4577 (class 1259 OID 21000)
-- Name: IDX_UNIQUE_json_hash; Type: INDEX; Schema: waze; Owner: jonathan
--

CREATE UNIQUE INDEX "IDX_UNIQUE_json_hash" ON waze.data_files USING btree (json_hash);


--
-- TOC entry 4588 (class 2606 OID 21011)
-- Name: alerts alerts_datafile_id_fkey; Type: FK CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.alerts
    ADD CONSTRAINT alerts_datafile_id_fkey FOREIGN KEY (datafile_id) REFERENCES waze.data_files(id);


--
-- TOC entry 4589 (class 2606 OID 21016)
-- Name: coordinates coordinates_alert_id_fkey; Type: FK CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.coordinates
    ADD CONSTRAINT coordinates_alert_id_fkey FOREIGN KEY (alert_id) REFERENCES waze.alerts(id);


--
-- TOC entry 4590 (class 2606 OID 21021)
-- Name: coordinates coordinates_coordinate_type_id_fkey; Type: FK CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.coordinates
    ADD CONSTRAINT coordinates_coordinate_type_id_fkey FOREIGN KEY (coordinate_type_id) REFERENCES waze.coordinate_type(id);


--
-- TOC entry 4591 (class 2606 OID 21026)
-- Name: coordinates coordinates_irregularity_id_fkey; Type: FK CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.coordinates
    ADD CONSTRAINT coordinates_irregularity_id_fkey FOREIGN KEY (irregularity_id) REFERENCES waze.irregularities(id);


--
-- TOC entry 4592 (class 2606 OID 21031)
-- Name: coordinates coordinates_jam_id_fkey; Type: FK CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.coordinates
    ADD CONSTRAINT coordinates_jam_id_fkey FOREIGN KEY (jam_id) REFERENCES waze.jams(id);


--
-- TOC entry 4593 (class 2606 OID 21036)
-- Name: irregularities irregularities_datafile_id_fkey; Type: FK CONSTRAINT; Schema: waze; Owner: jonathan
--

ALTER TABLE ONLY waze.irregularities
    ADD CONSTRAINT irregularities_datafile_id_fkey FOREIGN KEY (datafile_id) REFERENCES waze.data_files(id);



-- Completed on 2018-11-29 00:30:00 UTC

--
-- PostgreSQL database dump complete
--

