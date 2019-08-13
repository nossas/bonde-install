--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE admin;
ALTER ROLE admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE anonymous;
ALTER ROLE anonymous WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE common_user;
ALTER ROLE common_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE microservices;
ALTER ROLE microservices WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE monkey_user;
ALTER ROLE monkey_user WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md58b65ca062964325f427416d6bc223a48';
CREATE ROLE postgraphql;
ALTER ROLE postgraphql WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md575fbebcd4f9a74d02e83eacbb32dc9fb';


--
-- Role memberships
--

GRANT admin TO postgraphql GRANTED BY monkey_user;
GRANT anonymous TO postgraphql GRANTED BY monkey_user;
GRANT common_user TO admin GRANTED BY monkey_user;




--
-- Database creation
--

CREATE DATABASE bonde WITH TEMPLATE = template0 OWNER = monkey_user;
CREATE DATABASE monkey_db WITH TEMPLATE = template0 OWNER = monkey_user;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect bonde

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.14
-- Dumped by pg_dump version 9.6.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: monkey_user
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO monkey_user;

--
-- Name: hdb_views; Type: SCHEMA; Schema: -; Owner: monkey_user
--

CREATE SCHEMA hdb_views;


ALTER SCHEMA hdb_views OWNER TO monkey_user;

--
-- Name: microservices; Type: SCHEMA; Schema: -; Owner: monkey_user
--

CREATE SCHEMA microservices;


ALTER SCHEMA microservices OWNER TO monkey_user;

--
-- Name: pgjwt; Type: SCHEMA; Schema: -; Owner: monkey_user
--

CREATE SCHEMA pgjwt;


ALTER SCHEMA pgjwt OWNER TO monkey_user;

--
-- Name: postgraphile_watch; Type: SCHEMA; Schema: -; Owner: monkey_user
--

CREATE SCHEMA postgraphile_watch;


ALTER SCHEMA postgraphile_watch OWNER TO monkey_user;

--
-- Name: postgraphql; Type: SCHEMA; Schema: -; Owner: monkey_user
--

CREATE SCHEMA postgraphql;


ALTER SCHEMA postgraphql OWNER TO monkey_user;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: jwt_token; Type: TYPE; Schema: microservices; Owner: monkey_user
--

CREATE TYPE microservices.jwt_token AS (
	role text,
	user_id integer
);


ALTER TYPE microservices.jwt_token OWNER TO monkey_user;

--
-- Name: facebook_activist_search_result_type; Type: TYPE; Schema: postgraphql; Owner: monkey_user
--

CREATE TYPE postgraphql.facebook_activist_search_result_type AS (
	fb_context_recipient_id text,
	fb_context_sender_id text,
	data jsonb,
	messages tsvector,
	quick_replies text[],
	created_at timestamp without time zone,
	updated_at timestamp without time zone,
	id integer
);


ALTER TYPE postgraphql.facebook_activist_search_result_type OWNER TO monkey_user;

--
-- Name: facebook_bot_campaigns_type; Type: TYPE; Schema: postgraphql; Owner: monkey_user
--

CREATE TYPE postgraphql.facebook_bot_campaigns_type AS (
	facebook_bot_configuration_id integer,
	name text,
	segment_filters jsonb,
	total_impacted_activists integer
);


ALTER TYPE postgraphql.facebook_bot_campaigns_type OWNER TO monkey_user;

--
-- Name: get_facebook_bot_campaign_activists_by_campaign_type; Type: TYPE; Schema: postgraphql; Owner: monkey_user
--

CREATE TYPE postgraphql.get_facebook_bot_campaign_activists_by_campaign_type AS (
	id integer,
	facebook_bot_campaign_id integer,
	facebook_bot_activist_id integer,
	received boolean,
	log jsonb,
	created_at timestamp without time zone,
	updated_at timestamp without time zone,
	fb_context_recipient_id text,
	fb_context_sender_id text,
	data jsonb,
	messages tsvector,
	quick_replies text[],
	interaction_dates timestamp without time zone[]
);


ALTER TYPE postgraphql.get_facebook_bot_campaign_activists_by_campaign_type OWNER TO monkey_user;

--
-- Name: jwt_token; Type: TYPE; Schema: postgraphql; Owner: monkey_user
--

CREATE TYPE postgraphql.jwt_token AS (
	role text,
	user_id integer
);


ALTER TYPE postgraphql.jwt_token OWNER TO monkey_user;

--
-- Name: twilio_calls_arguments; Type: TYPE; Schema: postgraphql; Owner: monkey_user
--

CREATE TYPE postgraphql.twilio_calls_arguments AS (
	activist_id integer,
	widget_id integer,
	"from" text,
	"to" text,
	twilio_call_sid text
);


ALTER TYPE postgraphql.twilio_calls_arguments OWNER TO monkey_user;

--
-- Name: watch_twilio_call_transition_record_set; Type: TYPE; Schema: postgraphql; Owner: monkey_user
--

CREATE TYPE postgraphql.watch_twilio_call_transition_record_set AS (
	widget_id integer,
	activist_id integer,
	twilio_call_id integer,
	twilio_call_account_sid text,
	twilio_call_call_sid text,
	twilio_call_from text,
	twilio_call_to text,
	twilio_call_transition_id integer,
	twilio_call_transition_sequence_number integer,
	twilio_call_transition_status text,
	twilio_call_transition_call_duration text,
	twilio_call_transition_created_at timestamp without time zone,
	twilio_call_transition_updated_at timestamp without time zone
);


ALTER TYPE postgraphql.watch_twilio_call_transition_record_set OWNER TO monkey_user;

--
-- Name: change_password_fields; Type: TYPE; Schema: public; Owner: monkey_user
--

CREATE TYPE public.change_password_fields AS (
	user_first_name text,
	user_last_name text,
	token postgraphql.jwt_token
);


ALTER TYPE public.change_password_fields OWNER TO monkey_user;

--
-- Name: email; Type: DOMAIN; Schema: public; Owner: monkey_user
--

CREATE DOMAIN public.email AS public.citext
	CONSTRAINT email_check CHECK ((VALUE OPERATOR(public.~) '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::public.citext));


ALTER DOMAIN public.email OWNER TO monkey_user;

--
-- Name: status_mobilization; Type: TYPE; Schema: public; Owner: monkey_user
--

CREATE TYPE public.status_mobilization AS ENUM (
    'active',
    'archived'
);


ALTER TYPE public.status_mobilization OWNER TO monkey_user;

--
-- Name: hdb_schema_update_event_notifier(); Type: FUNCTION; Schema: hdb_catalog; Owner: monkey_user
--

CREATE FUNCTION hdb_catalog.hdb_schema_update_event_notifier() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    instance_id uuid;
    occurred_at timestamptz;
    curr_rec record;
  BEGIN
    instance_id = NEW.instance_id;
    occurred_at = NEW.occurred_at;
    PERFORM pg_notify('hasura_schema_update', json_build_object(
      'instance_id', instance_id,
      'occurred_at', occurred_at
      )::text);
    RETURN curr_rec;
  END;
$$;


ALTER FUNCTION hdb_catalog.hdb_schema_update_event_notifier() OWNER TO monkey_user;

--
-- Name: hdb_table_oid_check(); Type: FUNCTION; Schema: hdb_catalog; Owner: monkey_user
--

CREATE FUNCTION hdb_catalog.hdb_table_oid_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (EXISTS (SELECT 1 FROM information_schema.tables st WHERE st.table_schema = NEW.table_schema AND st.table_name = NEW.table_name)) THEN
      return NEW;
    ELSE
      RAISE foreign_key_violation using message = 'table_schema, table_name not in information_schema.tables';
      return NULL;
    END IF;
  END;
$$;


ALTER FUNCTION hdb_catalog.hdb_table_oid_check() OWNER TO monkey_user;

--
-- Name: inject_table_defaults(text, text, text, text); Type: FUNCTION; Schema: hdb_catalog; Owner: monkey_user
--

CREATE FUNCTION hdb_catalog.inject_table_defaults(view_schema text, view_name text, tab_schema text, tab_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
        r RECORD;
    BEGIN
      FOR r IN SELECT column_name, column_default FROM information_schema.columns WHERE table_schema = tab_schema AND table_name = tab_name AND column_default IS NOT NULL LOOP
          EXECUTE format('ALTER VIEW %I.%I ALTER COLUMN %I SET DEFAULT %s;', view_schema, view_name, r.column_name, r.column_default);
      END LOOP;
    END;
$$;


ALTER FUNCTION hdb_catalog.inject_table_defaults(view_schema text, view_name text, tab_schema text, tab_name text) OWNER TO monkey_user;

--
-- Name: insert_event_log(text, text, text, text, json); Type: FUNCTION; Schema: hdb_catalog; Owner: monkey_user
--

CREATE FUNCTION hdb_catalog.insert_event_log(schema_name text, table_name text, trigger_name text, op text, row_data json) RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    id text;
    payload json;
    session_variables json;
    server_version_num int;
  BEGIN
    id := gen_random_uuid();
    server_version_num := current_setting('server_version_num');
    IF server_version_num >= 90600 THEN
      session_variables := current_setting('hasura.user', 't');
    ELSE
      BEGIN
        session_variables := current_setting('hasura.user');
      EXCEPTION WHEN OTHERS THEN
                  session_variables := NULL;
      END;
    END IF;
    payload := json_build_object(
      'op', op,
      'data', row_data,
      'session_variables', session_variables
    );
    INSERT INTO hdb_catalog.event_log
                (id, schema_name, table_name, trigger_name, payload)
    VALUES
    (id, schema_name, table_name, trigger_name, payload);
    RETURN id;
  END;
$$;


ALTER FUNCTION hdb_catalog.insert_event_log(schema_name text, table_name text, trigger_name text, op text, row_data json) OWNER TO monkey_user;

--
-- Name: create_community_dns(json); Type: FUNCTION; Schema: microservices; Owner: monkey_user
--

CREATE FUNCTION microservices.create_community_dns(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
          _community public.communities;
          _dns_hosted_zone public.dns_hosted_zones;
          _dns public.dns_hosted_zones;
        begin
          -- to execute function in api-v1
          -- if current_role <> 'microservices' then
          --     raise 'permission_denied';
          -- end if;

          select * from public.communities c where c.id = ($1->>'community_id')::integer
          into _community;

          if _community is null then
              raise 'community_not_found';
          end if;

          select *
              from public.dns_hosted_zones
          where community_id = _community.id and domain_name = $1->>'domain_name'
          into _dns;

          if _dns is null then
              insert into public.dns_hosted_zones(community_id, domain_name, comment, created_at, updated_at, ns_ok)
              values (
                  _community.id, $1->>'domain_name', $1->>'comment', now(), now(), false
              )
              returning * into _dns_hosted_zone;
          else
              select *
                  from public.dns_hosted_zones
              where community_id = _community.id and domain_name = $1->>'domain_name'
              into _dns_hosted_zone;
          end if;

          -- after create dns_hosted_zone perform route53
          perform pg_notify('dns_channel',pgjwt.sign(json_build_object(
              'action', 'create_hosted_zone',
              'id', _dns_hosted_zone.id,
              'domain', _dns_hosted_zone.domain_name,
              'created_at', _dns_hosted_zone.created_at,
              'sent_to_queuing', now(),
              'jit', now()::timestamp
          ), public.configuration('jwt_secret'), 'HS512'));

          return json_build_object(
              'id', _dns_hosted_zone.id,
              'community_id', _dns_hosted_zone.community_id,
              'domain_name', _dns_hosted_zone.domain_name,
              'comment', _dns_hosted_zone.comment,
              'ns_ok', _dns_hosted_zone.ns_ok
          );
        end;
      $_$;


ALTER FUNCTION microservices.create_community_dns(data json) OWNER TO monkey_user;

--
-- Name: locale_names(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.locale_names() RETURNS text[]
    LANGUAGE sql IMMUTABLE
    AS $$
    select '{pt-BR, es, en}'::text[];
$$;


ALTER FUNCTION public.locale_names() OWNER TO monkey_user;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: users; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    provider character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    first_name character varying,
    last_name character varying,
    email character varying,
    tokens text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar character varying,
    admin boolean,
    locale text DEFAULT 'pt-BR'::text NOT NULL,
    CONSTRAINT localechk CHECK ((locale = ANY (public.locale_names())))
);


ALTER TABLE public.users OWNER TO monkey_user;

--
-- Name: current_user(); Type: FUNCTION; Schema: microservices; Owner: monkey_user
--

CREATE FUNCTION microservices."current_user"() RETURNS public.users
    LANGUAGE sql STABLE
    AS $$
        select
          *
        from
          public.users
        where
          id = current_setting('jwt.claims.user_id')::integer
      $$;


ALTER FUNCTION microservices."current_user"() OWNER TO monkey_user;

--
-- Name: FUNCTION "current_user"(); Type: COMMENT; Schema: microservices; Owner: monkey_user
--

COMMENT ON FUNCTION microservices."current_user"() IS 'Gets the user who was indentified by our JWT.';


--
-- Name: current_user_id(); Type: FUNCTION; Schema: microservices; Owner: monkey_user
--

CREATE FUNCTION microservices.current_user_id() RETURNS integer
    LANGUAGE sql
    AS $$
          select id from microservices.current_user();
      $$;


ALTER FUNCTION microservices.current_user_id() OWNER TO monkey_user;

--
-- Name: algorithm_sign(text, text, text); Type: FUNCTION; Schema: pgjwt; Owner: monkey_user
--

CREATE FUNCTION pgjwt.algorithm_sign(signables text, secret text, algorithm text) RETURNS text
    LANGUAGE sql
    AS $$
      WITH
        alg AS (
          SELECT CASE
            WHEN algorithm = 'HS256' THEN 'sha256'
            WHEN algorithm = 'HS384' THEN 'sha384'
            WHEN algorithm = 'HS512' THEN 'sha512'
            ELSE '' END AS id)  -- hmac throws error
      SELECT pgjwt.url_encode(hmac(signables, secret, alg.id)) FROM alg;
      $$;


ALTER FUNCTION pgjwt.algorithm_sign(signables text, secret text, algorithm text) OWNER TO monkey_user;

--
-- Name: sign(json, text, text); Type: FUNCTION; Schema: pgjwt; Owner: monkey_user
--

CREATE FUNCTION pgjwt.sign(payload json, secret text, algorithm text DEFAULT 'HS256'::text) RETURNS text
    LANGUAGE sql
    AS $$
      WITH
        header AS (
          SELECT pgjwt.url_encode(convert_to('{"alg":"' || algorithm || '","typ":"JWT"}', 'utf8')) AS data
          ),
        payload AS (
          SELECT pgjwt.url_encode(convert_to(payload::text, 'utf8')) AS data
          ),
        signables AS (
          SELECT header.data || '.' || payload.data AS data FROM header, payload
          )
      SELECT
          signables.data || '.' ||
          pgjwt.algorithm_sign(signables.data, secret, algorithm) FROM signables;
      $$;


ALTER FUNCTION pgjwt.sign(payload json, secret text, algorithm text) OWNER TO monkey_user;

--
-- Name: url_decode(text); Type: FUNCTION; Schema: pgjwt; Owner: monkey_user
--

CREATE FUNCTION pgjwt.url_decode(data text) RETURNS bytea
    LANGUAGE sql
    AS $$
      WITH t AS (SELECT translate(data, '-_', '+/') AS trans),
           rem AS (SELECT length(t.trans) % 4 AS remainder FROM t) -- compute padding size
          SELECT decode(
              t.trans ||
              CASE WHEN rem.remainder > 0
                 THEN repeat('=', (4 - rem.remainder))
                 ELSE '' END,
          'base64') FROM t, rem;
      $$;


ALTER FUNCTION pgjwt.url_decode(data text) OWNER TO monkey_user;

--
-- Name: url_encode(bytea); Type: FUNCTION; Schema: pgjwt; Owner: monkey_user
--

CREATE FUNCTION pgjwt.url_encode(data bytea) RETURNS text
    LANGUAGE sql
    AS $$
      SELECT translate(encode(data, 'base64'), E'+/=\n', '-_');
$$;


ALTER FUNCTION pgjwt.url_encode(data bytea) OWNER TO monkey_user;

--
-- Name: verify(text, text, text); Type: FUNCTION; Schema: pgjwt; Owner: monkey_user
--

CREATE FUNCTION pgjwt.verify(token text, secret text, algorithm text DEFAULT 'HS256'::text) RETURNS TABLE(header json, payload json, valid boolean)
    LANGUAGE sql
    AS $$
        SELECT
          convert_from(pgjwt.url_decode(r[1]), 'utf8')::json AS header,
          convert_from(pgjwt.url_decode(r[2]), 'utf8')::json AS payload,
          r[3] = pgjwt.algorithm_sign(r[1] || '.' || r[2], secret, algorithm) AS valid
        FROM regexp_split_to_array(token, '\.') r;
      $$;


ALTER FUNCTION pgjwt.verify(token text, secret text, algorithm text) OWNER TO monkey_user;

--
-- Name: notify_watchers_ddl(); Type: FUNCTION; Schema: postgraphile_watch; Owner: monkey_user
--

CREATE FUNCTION postgraphile_watch.notify_watchers_ddl() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'ddl',
      'payload',
      (select json_agg(json_build_object('schema', schema_name, 'command', command_tag)) from pg_event_trigger_ddl_commands() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphile_watch.notify_watchers_ddl() OWNER TO monkey_user;

--
-- Name: notify_watchers_drop(); Type: FUNCTION; Schema: postgraphile_watch; Owner: monkey_user
--

CREATE FUNCTION postgraphile_watch.notify_watchers_drop() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'drop',
      'payload',
      (select json_agg(distinct x.schema_name) from pg_event_trigger_dropped_objects() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphile_watch.notify_watchers_drop() OWNER TO monkey_user;

--
-- Name: twilio_calls; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.twilio_calls (
    id integer NOT NULL,
    activist_id integer,
    widget_id integer,
    twilio_account_sid text,
    twilio_call_sid text,
    "from" text NOT NULL,
    "to" text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    community_id integer
);


ALTER TABLE public.twilio_calls OWNER TO monkey_user;

--
-- Name: twilio_calls; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.twilio_calls AS
 SELECT twilio_calls.id,
    twilio_calls.activist_id,
    twilio_calls.widget_id,
    twilio_calls.twilio_account_sid,
    twilio_calls.twilio_call_sid,
    twilio_calls."from",
    twilio_calls."to",
    twilio_calls.data,
    twilio_calls.created_at,
    twilio_calls.updated_at,
    twilio_calls.community_id
   FROM public.twilio_calls;


ALTER TABLE postgraphql.twilio_calls OWNER TO monkey_user;

--
-- Name: add_twilio_call(postgraphql.twilio_calls); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.add_twilio_call(call postgraphql.twilio_calls) RETURNS postgraphql.twilio_calls
    LANGUAGE plpgsql
    AS $$
        DECLARE twilio_calls postgraphql.twilio_calls;
        BEGIN
          INSERT INTO postgraphql.twilio_calls (
            activist_id,
            community_id,
            widget_id,
            "from",
            "to",
            created_at,
            updated_at
          ) VALUES (
            coalesce(CALL.activist_id, NULL),
            CALL.community_id,
            CALL.widget_id,
            CALL.from,
            CALL.to,
            now(),
            now()
          ) returning * INTO twilio_calls;
          RETURN twilio_calls;
        END;
      $$;


ALTER FUNCTION postgraphql.add_twilio_call(call postgraphql.twilio_calls) OWNER TO monkey_user;

--
-- Name: twilio_configurations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.twilio_configurations (
    id integer NOT NULL,
    community_id integer NOT NULL,
    twilio_account_sid text NOT NULL,
    twilio_auth_token text NOT NULL,
    twilio_number text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.twilio_configurations OWNER TO monkey_user;

--
-- Name: twilio_configurations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.twilio_configurations AS
 SELECT twilio_configurations.id,
    twilio_configurations.community_id,
    twilio_configurations.twilio_account_sid,
    twilio_configurations.twilio_auth_token,
    twilio_configurations.twilio_number,
    twilio_configurations.created_at,
    twilio_configurations.updated_at
   FROM public.twilio_configurations;


ALTER TABLE postgraphql.twilio_configurations OWNER TO monkey_user;

--
-- Name: add_twilio_configuration(postgraphql.twilio_configurations); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.add_twilio_configuration(config postgraphql.twilio_configurations) RETURNS postgraphql.twilio_configurations
    LANGUAGE plpgsql
    AS $$
  DECLARE twilio_configuration postgraphql.twilio_configurations;
  BEGIN
    INSERT INTO postgraphql.twilio_configurations (
      community_id,
      twilio_account_sid,
      twilio_auth_token,
      twilio_number,
      created_at,
      updated_at
    ) VALUES (
      CONFIG.community_id,
      CONFIG.twilio_account_sid,
      CONFIG.twilio_auth_token,
      CONFIG.twilio_number,
      now(),
      now()
    ) RETURNING * INTO twilio_configuration;
    RETURN twilio_configuration;
  END;
$$;


ALTER FUNCTION postgraphql.add_twilio_configuration(config postgraphql.twilio_configurations) OWNER TO monkey_user;

--
-- Name: authenticate(text, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.authenticate(email text, password text) RETURNS postgraphql.jwt_token
    LANGUAGE plpgsql STRICT SECURITY DEFINER
    AS $_$
  declare
    users public.users;
  begin
    select u.* into users
    from public.users as u
    where u.email = $1;

    if users.encrypted_password = crypt(password, users.encrypted_password) and users.admin = true then
      return ('admin', users.id)::postgraphql.jwt_token;
    elsif users.encrypted_password = crypt(password, users.encrypted_password) then
      return ('common_user', users.id)::postgraphql.jwt_token;
    else
      return null;
    end if;
  end;
$_$;


ALTER FUNCTION postgraphql.authenticate(email text, password text) OWNER TO monkey_user;

--
-- Name: FUNCTION authenticate(email text, password text); Type: COMMENT; Schema: postgraphql; Owner: monkey_user
--

COMMENT ON FUNCTION postgraphql.authenticate(email text, password text) IS 'Creates a JWT token that will securely identify a user and give them certain permissions.';


--
-- Name: change_password(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.change_password(data json) RETURNS postgraphql.jwt_token
    LANGUAGE plpgsql
    AS $_$
    declare
        _user public.users;
    begin
        if nullif(($1->> 'password')::text, '') is null then
            raise 'missing_password';
        end if;

        if length(($1->>'password'::text)) < 6 then
            raise 'password_lt_six_chars';
        end if;

        if ($1->>'password'::text) <> ($1->>'password_confirmation'::text) then
            raise 'password_confirmation_not_match';
        end if;

        -- when user is anonymous should be have reset_password_token
        if current_role = 'anonymous' then
            if nullif(($1->>'reset_password_token')::text, '') is not null then
                select * from public.users 
                    where reset_password_token is not null
                        and ($1->>'reset_password_token')::text = reset_password_token
                    into _user;

                if _user.id is null then
                    raise 'invalid_reset_password_token';
                end if;
            else
                raise 'missing_reset_password_token';
            end if;
        else
        -- when user already logged (jwt) should not require reset_password_token
            select * from users where id = postgraphql.current_user_id()
                into _user;
        end if;
        
        update users
            set encrypted_password = public.crypt(($1->>'password')::text, public.gen_salt('bf', 9))
        where id = _user.id;
        
        return (
            (case when _user.admin is true then 'admin' else 'common_user' end), 
            _user.id
        )::postgraphql.jwt_token;        
    end;
$_$;


ALTER FUNCTION postgraphql.change_password(data json) OWNER TO monkey_user;

--
-- Name: invitations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.invitations (
    id integer NOT NULL,
    community_id integer,
    user_id integer,
    email character varying,
    code character varying,
    expires timestamp without time zone,
    role integer,
    expired boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.invitations OWNER TO monkey_user;

--
-- Name: check_invitation(text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.check_invitation(invitation_code text) RETURNS SETOF public.invitations
    LANGUAGE sql IMMUTABLE
    AS $$
  select * from public.invitations where code=invitation_code
$$;


ALTER FUNCTION postgraphql.check_invitation(invitation_code text) OWNER TO monkey_user;

--
-- Name: create_activist(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_activist(activist json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
            _activist public.activists;
            _community_id integer;
            _mobilization public.mobilizations;
            _community_activist public.community_activists;
        begin
            _community_id := ($1->>'community_id')::integer;

            if _community_id is null then
                raise 'missing community_id inside activist';
            end if;            

            if not postgraphql.current_user_has_community_participation(_community_id) then
                raise 'operation not permitted';
            end if;

            select * from public.mobilizations
                where community_id = _community_id
                    and id = ($1->>'mobilization_id')::integer
                into _mobilization;
            
            select * from public.activists a
                where a.email = lower(($1->>'email')::email)
                limit 1 into _activist;
                
            if _activist.id is null then 
                insert into public.activists (first_name, last_name, name, email, phone, document_number, document_type, city, created_at, updated_at)
                    values ($1->>'first_name'::text, $1->>'last_name'::text, $1->>'name'::text, lower($1->>'email'), $1->>'phone'::text, $1->>'document_number'::text,
                        $1->>'document_type'::text, $1->>'city'::text, now(), now())
                    returning * into _activist;
            end if;
            
            select *
                from public.community_activists 
                where community_id = _community_id 
                    and activist_id = _activist.id
                into _community_activist;
            
            if _community_activist.id is null then
                insert into public.community_activists (community_id, activist_id, created_at, updated_at, profile_data)
                    values (_community_id, _activist.id, now(), now(), ($1)::jsonb)
                    returning * into _community_activist;
            end if;
            
            if _mobilization.id is not null and not exists(select true 
                from public.mobilization_activists 
                where mobilization_id = _mobilization.id
                    and activist_id = _activist.id
            ) then
                insert into public.mobilization_activists (mobilization_id, activist_id, created_at, updated_at)
                    values (_mobilization.id, _activist.id, now(), now());
            end if;            

            return row_to_json(_community_activist);
        end;
    $_$;


ALTER FUNCTION postgraphql.create_activist(activist json) OWNER TO monkey_user;

--
-- Name: create_activist_tag(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_activist_tag(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
            _activist public.activists;
            _tagging public.taggings;
            _tag public.tags;
            _activist_tag public.activist_tags;
            _community_id integer;
            --_mobilization public.mobilizations;            
        begin
            -- check for community_id
            _community_id := ($1->>'community_id')::integer;
            if _community_id is null then
                raise 'missing community_id inside activist';
            end if;            

            -- check if current_user has participation on this community or he is admin
            if not postgraphql.current_user_has_community_participation(_community_id) and current_role <> 'admin' then
                raise 'operation not permitted';
            end if;
            
            -- get mobilization
            -- select * from public.mobilizations
            --     where community_id = _community_id
            --         and id = ($1->>'mobilization_id')::integer
            --     into _mobilization;
            
            -- get activist
            select * from public.activists a
                where a.id = ($1->>'activist_id')::integer
                limit 1 into _activist;
                
            -- check if activists in community
            if not exists(select true from community_activists 
                where community_id = _community_id
                    and activist_id = _activist.id) then
                raise 'activist not found on community';
            end if;
            
            -- insert new activist_tag
            select * from public.activist_tags 
                where activist_id = _activist.id 
                    and community_id = _community_id
                into _activist_tag;

            if _activist_tag is null then
                insert into public.activist_tags (activist_id, community_id, created_at, updated_at)
                    values (_activist.id, _community_id, now(), now())
                    returning * into _activist_tag;
            end if;
                
            -- search for some tag that have the same name
            select * from public.tags
                where name = 'input_'||public.slugfy(($1->>'name')::text)
                limit 1
                into _tag;

            -- insert tag if not found
            if _tag is null then
                insert into public.tags (name, label) 
                    values ('input_'||public.slugfy(($1->>'name')::text), ($1->>'name')::text)
                    returning * into _tag;
            end if;
            
            -- create taggings linking activist_tag to tag
            select * from public.taggings
                where tag_id = _tag.id
                    and taggable_id = _activist_tag.id
                    and taggable_type = 'ActivistTag'
                into _tagging;
            if _tagging is null then
                insert into public.taggings(tag_id, taggable_id, taggable_type) 
                    values (_tag.id, _activist_tag.id, 'ActivistTag')
                    returning * into _tagging;
            end if;
            
            return json_build_object(
                'activist_tag_id', _activist_tag.id,
                'tag_id', _tag.id,
                'activist_id', _activist.id,
                'tag_name', _tag.name,
                'tag_label', _tag.label
            );
        end;
    $_$;


ALTER FUNCTION postgraphql.create_activist_tag(data json) OWNER TO monkey_user;

--
-- Name: create_bot(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_bot(bot_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
        declare
            bot_json public.facebook_bot_configurations;
        begin
            insert into public.facebook_bot_configurations
                (community_id, messenger_app_secret, messenger_validation_token, messenger_page_access_token, data, created_at, updated_at)
                values (
                    (bot_data ->> 'community_id')::integer,
                    (bot_data ->> 'messenger_app_secret'),
                    (bot_data ->> 'messenger_validation_token'),
                    (bot_data ->> 'messenger_page_access_token'),
                    coalesce((bot_data ->> 'data')::jsonb, '{}'),
                    now(),
                    now())
                returning * into bot_json;

                return row_to_json(bot_json);
        end;
    $$;


ALTER FUNCTION postgraphql.create_bot(bot_data json) OWNER TO monkey_user;

--
-- Name: create_bot_interaction(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_bot_interaction(bot_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
        declare
            bot_json public.activist_facebook_bot_interactions;
        begin
            insert into public.activist_facebook_bot_interactions
                (facebook_bot_configuration_id, fb_context_recipient_id, fb_context_sender_id, interaction, created_at, updated_at)
                values (
                    (bot_data ->> 'facebook_bot_configuration_id')::integer,
                    (bot_data ->> 'fb_context_recipient_id'),
                    (bot_data ->> 'fb_context_sender_id'),
                    coalesce((bot_data ->> 'interaction')::jsonb, '{}'),
                    now(),
                    now())
                returning * into bot_json;

                return row_to_json(bot_json);
        end;
    $$;


ALTER FUNCTION postgraphql.create_bot_interaction(bot_data json) OWNER TO monkey_user;

--
-- Name: create_community(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_community(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
          declare
              _community public.communities;
          begin
              if current_role = 'anonymous' then
                  raise 'permission_denied';
              end if;

              if nullif(btrim($1->> 'name'::text), '') is null then
                  raise 'missing_community_name';
              end if;

              if nullif(btrim($1->> 'city'::text), '') is null then
                  raise 'missing_community_city';
              end if;

              insert into public.communities(name, city, created_at, updated_at)
                  values(
                      ($1->>'name')::text,
                      ($1->>'city')::text,
                      now(),
                      now()
                  ) returning * into _community;

              -- create user x community after create community
              insert into public.community_users(user_id, community_id, role, created_at, updated_at)
                  values(
                      postgraphql.current_user_id(),
                      _community.id,
                      1,
                      now(),
                      now()
                  );

              return row_to_json(_community);
          end;
      $_$;


ALTER FUNCTION postgraphql.create_community(data json) OWNER TO monkey_user;

--
-- Name: create_dns_record(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_dns_record(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
          _dns_hosted_zone public.dns_hosted_zones;
          _dns_record public.dns_records;
        begin
          -- to execute function in api-v1
          -- if current_role <> 'microservices' then
          --     raise 'permission_denied';
          -- end if;

          select * from public.dns_hosted_zones d where d.id = ($1->>'dns_hosted_zone_id')::integer
          into _dns_hosted_zone;

          if _dns_hosted_zone is null then
              raise 'dns_hosted_zone_not_found';
          end if;

          select *
              from public.dns_records
          where name = $1->>'name' and record_type = $1->>'record_type'
          into _dns_record;

          if _dns_record is null then
              insert into public.dns_records(dns_hosted_zone_id, name, record_type, value, ttl, created_at, updated_at, comment)
              values (
                  _dns_hosted_zone.id, $1->>'name', $1->>'record_type', $1->>'value', $1->>'ttl', now(), now(),  $1->>'comment'
              )
              returning * into _dns_record;

              -- after create dns_record perform route53
              perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
                  'action', 'create_dns_record',
                  'id', _dns_record.id,
                  'created_at', _dns_record.created_at,
                  'sent_to_queuing', now(),
                  'jit', now()::timestamp
              ), public.configuration('jwt_secret'), 'HS512'));

              return json_build_object(
                  'id', _dns_record.id,
                  'dns_hosted_zone_id', _dns_record.dns_hosted_zone_id,
                  'name', _dns_record.name,
                  'comment', _dns_record.comment
              );
          else
              raise 'dns_record_already_registered';
          end if;
        end;
      $_$;


ALTER FUNCTION postgraphql.create_dns_record(data json) OWNER TO monkey_user;

--
-- Name: facebook_bot_campaigns; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.facebook_bot_campaigns (
    id integer NOT NULL,
    facebook_bot_configuration_id integer NOT NULL,
    name text NOT NULL,
    segment_filters jsonb NOT NULL,
    total_impacted_activists integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_campaigns OWNER TO monkey_user;

--
-- Name: create_facebook_bot_campaign(postgraphql.facebook_bot_campaigns_type); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_facebook_bot_campaign(campaign postgraphql.facebook_bot_campaigns_type) RETURNS public.facebook_bot_campaigns
    LANGUAGE plpgsql
    AS $$
    DECLARE
        _facebook_bot_campaign public.facebook_bot_campaigns;
        _campaign_id integer;
    BEGIN
        INSERT INTO public.facebook_bot_campaigns (
            facebook_bot_configuration_id,
            name,
            segment_filters,
            total_impacted_activists,
            created_at,
            updated_at
        ) VALUES (
            campaign.facebook_bot_configuration_id,
            campaign.name,
            campaign.segment_filters,
            campaign.total_impacted_activists,
            now(),
            now()
        ) RETURNING * INTO _facebook_bot_campaign;

        INSERT INTO public.facebook_bot_campaign_activists (
            facebook_bot_campaign_id,
            facebook_bot_activist_id,
            received,
            created_at,
            updated_at
        )
            SELECT
                (to_json(_facebook_bot_campaign) ->> 'id')::integer as facebook_bot_activist_id,
                id as facebook_bot_activist_id,
                FALSE,
                NOW(),
                NOW()
            FROM postgraphql.get_facebook_bot_activists_strategy(campaign.segment_filters);
      RETURN _facebook_bot_campaign;
    END;
$$;


ALTER FUNCTION postgraphql.create_facebook_bot_campaign(campaign postgraphql.facebook_bot_campaigns_type) OWNER TO monkey_user;

--
-- Name: create_tags(text, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_tags(name text, label text) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
    _tag public.tags;
    _user_tag public.user_tags;
begin
    if current_role = 'anonymous' then
        raise 'permission_denied';
    end if;

    if name is null then
        raise 'name_is_empty';
    end if;

    if label is null then
        raise 'label_is_empty';
    end if;

    insert into public.tags(name, label)
    values(concat('user_', name), label)
    returning * into _tag;

    -- insert a new tag in current_user
    insert into public.user_tags(user_id, tag_id, created_at, updated_at)
    values(postgraphql.current_user_id(), _tag.id, now(), now())
    returning * into _user_tag;

    return json_build_object(
        'msg', 'tag created successful',
        'tag_id', _tag.id,
        'user_tag', _user_tag.id
    );
end;
$$;


ALTER FUNCTION postgraphql.create_tags(name text, label text) OWNER TO monkey_user;

--
-- Name: create_user_tags(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.create_user_tags(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
declare
    _tags json;
    _tag text;
begin
    if current_role = 'anonymous' then
        raise 'permission_denied';
    end if;

    for _tag in (select * from json_array_elements_text(($1->>'tags')::json))
    loop
        insert into public.user_tags(user_id, tag_id, created_at, updated_at)
        (
            select postgraphql.current_user_id(),
            (select id from public.tags where name = _tag),
            now(),
            now()
        ) returning * into _tags;
    end loop;

    return (select json_agg(t.name) from (
        select * from tags t
        left join user_tags ut on ut.tag_id = t.id
        where ut.user_id = (postgraphql.current_user_id())
    ) t);
end;
$_$;


ALTER FUNCTION postgraphql.create_user_tags(data json) OWNER TO monkey_user;

--
-- Name: users; Type: TABLE; Schema: postgraphql; Owner: monkey_user
--

CREATE TABLE postgraphql.users (
    id integer,
    provider character varying,
    uid character varying,
    encrypted_password character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    first_name character varying,
    last_name character varying,
    email character varying,
    tokens text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar character varying,
    admin boolean,
    locale text,
    tags json
);

ALTER TABLE ONLY postgraphql.users REPLICA IDENTITY NOTHING;


ALTER TABLE postgraphql.users OWNER TO monkey_user;

--
-- Name: current_user(); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql."current_user"() RETURNS postgraphql.users
    LANGUAGE sql STABLE
    AS $$
  select *
  from postgraphql.users
  where id = current_setting('jwt.claims.user_id')::integer
$$;


ALTER FUNCTION postgraphql."current_user"() OWNER TO monkey_user;

--
-- Name: current_user_has_community_participation(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.current_user_has_community_participation(com_id integer) RETURNS boolean
    LANGUAGE sql
    AS $$
        select (exists(
            select true from public.community_users cu
                where cu.user_id = postgraphql.current_user_id()
                and cu.community_id = com_id
        ) or current_role = 'admin');
    $$;


ALTER FUNCTION postgraphql.current_user_has_community_participation(com_id integer) OWNER TO monkey_user;

--
-- Name: current_user_has_community_participation(integer, integer[]); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.current_user_has_community_participation(com_id integer, role_ids integer[]) RETURNS boolean
    LANGUAGE sql
    AS $$
        select exists(
            select true from public.community_users cu
                where cu.user_id = postgraphql.current_user_id()
                and cu.community_id = com_id
                and cu.role = ANY(role_ids)
        );
    $$;


ALTER FUNCTION postgraphql.current_user_has_community_participation(com_id integer, role_ids integer[]) OWNER TO monkey_user;

--
-- Name: current_user_id(); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.current_user_id() RETURNS integer
    LANGUAGE sql
    AS $$
        select id from postgraphql.current_user();
    $$;


ALTER FUNCTION postgraphql.current_user_id() OWNER TO monkey_user;

--
-- Name: template_mobilizations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.template_mobilizations (
    id integer NOT NULL,
    name character varying,
    user_id integer,
    color_scheme character varying,
    facebook_share_title character varying,
    facebook_share_description text,
    header_font character varying,
    body_font character varying,
    facebook_share_image character varying,
    slug character varying,
    custom_domain character varying,
    twitter_share_text character varying(140),
    community_id integer,
    uses_number integer,
    global boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    goal text
);


ALTER TABLE public.template_mobilizations OWNER TO monkey_user;

--
-- Name: custom_templates(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.custom_templates(ctx_community_id integer) RETURNS SETOF public.template_mobilizations
    LANGUAGE sql STABLE
    AS $$
        select *
          from public.template_mobilizations
          where community_id = ctx_community_id
          and global = false
          and postgraphql.current_user_has_community_participation(ctx_community_id);
      $$;


ALTER FUNCTION postgraphql.custom_templates(ctx_community_id integer) OWNER TO monkey_user;

--
-- Name: destroy_bot(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.destroy_bot(bot_id integer) RETURNS void
    LANGUAGE sql
    AS $$
        update public.facebook_bot_configurations
            set data = jsonb_set(data, '{deleted}', 'true')
        where id = bot_id
    $$;


ALTER FUNCTION postgraphql.destroy_bot(bot_id integer) OWNER TO monkey_user;

--
-- Name: activist_tags; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.activist_tags (
    id integer NOT NULL,
    activist_id integer,
    community_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mobilization_id integer
);


ALTER TABLE public.activist_tags OWNER TO monkey_user;

--
-- Name: taggings; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying(128),
    created_at timestamp without time zone
);


ALTER TABLE public.taggings OWNER TO monkey_user;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0,
    label text
);


ALTER TABLE public.tags OWNER TO monkey_user;

--
-- Name: community_tags; Type: VIEW; Schema: public; Owner: monkey_user
--

CREATE VIEW public.community_tags AS
 SELECT at.community_id,
    tag.name AS tag_complete_name,
    (regexp_split_to_array((tag.name)::text, '_'::text))[1] AS tag_from,
    (regexp_split_to_array((tag.name)::text, '_'::text))[2] AS tag_name,
    count(DISTINCT at.activist_id) AS total_activists,
    tag.label AS tag_label
   FROM ((public.activist_tags at
     JOIN public.taggings tgs ON ((((tgs.taggable_type)::text = 'ActivistTag'::text) AND (tgs.taggable_id = at.id))))
     JOIN public.tags tag ON ((tag.id = tgs.tag_id)))
  GROUP BY at.community_id, tag.name, tag.label;


ALTER TABLE public.community_tags OWNER TO monkey_user;

--
-- Name: community_tags; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.community_tags AS
 SELECT community_tags.community_id,
    community_tags.tag_complete_name,
    community_tags.tag_from,
    community_tags.tag_name,
    community_tags.total_activists,
    community_tags.tag_label
   FROM public.community_tags
  WHERE postgraphql.current_user_has_community_participation(community_tags.community_id);


ALTER TABLE postgraphql.community_tags OWNER TO monkey_user;

--
-- Name: filter_community_tags(text, integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.filter_community_tags(search text, ctx_community_id integer) RETURNS SETOF postgraphql.community_tags
    LANGUAGE sql STABLE
    AS $$
  select * from postgraphql.community_tags
    where community_id = ctx_community_id
    and tag_complete_name ilike ('%' || search || '%')
$$;


ALTER FUNCTION postgraphql.filter_community_tags(search text, ctx_community_id integer) OWNER TO monkey_user;

--
-- Name: FUNCTION filter_community_tags(search text, ctx_community_id integer); Type: COMMENT; Schema: postgraphql; Owner: monkey_user
--

COMMENT ON FUNCTION postgraphql.filter_community_tags(search text, ctx_community_id integer) IS 'filter community_tags view by tag_complete_name and communityd_id';


--
-- Name: get_facebook_activists_by_campaign_ids(integer[]); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaign_ids(campaign_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        DISTINCT _fba.fb_context_recipient_id,
        _fba.fb_context_sender_id,
        _fba.data,
        _fba.messages,
        _fba.quick_replies,
        _fba.created_at,
        _fba.updated_at,
        _fba.id
    FROM public.facebook_bot_campaign_activists as _fbca
    LEFT JOIN public.facebook_bot_activists as _fba
        ON _fba.id = _fbca.facebook_bot_activist_id
    WHERE _fbca.facebook_bot_campaign_id = ANY(campaign_ids)
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaign_ids(campaign_ids integer[]) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_campaigns_both_inclusion_exclusion(jsonb, integer[], integer[]); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaigns_both_inclusion_exclusion(segment_filters jsonb, campaign_exclusion_ids integer[], campaign_inclusion_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_campaigns_exclusion(
        segment_filters,
        campaign_exclusion_ids
    )
    UNION
    SELECT *
    FROM postgraphql.get_facebook_activists_by_campaign_ids(
        campaign_inclusion_ids
    );
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaigns_both_inclusion_exclusion(segment_filters jsonb, campaign_exclusion_ids integer[], campaign_inclusion_ids integer[]) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_campaigns_exclusion(jsonb, integer[]); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaigns_exclusion(segment_filters jsonb, campaign_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fas.fb_context_recipient_id,
        fas.fb_context_sender_id,
        fas.data,
        fas.messages,
        fas.quick_replies,
        fas.created_at,
        fas.updated_at,
        fas.id
    FROM postgraphql.get_facebook_bot_activists_strategy(segment_filters) as fas
    LEFT JOIN (
        SELECT fba.*
        FROM public.facebook_bot_campaign_activists as fbca
        LEFT JOIN public.facebook_bot_activists as fba
            ON fba.id = fbca.facebook_bot_activist_id
        WHERE fbca.facebook_bot_campaign_id = ANY(campaign_ids)
    ) as fbca
        ON fbca.fb_context_recipient_id = fas.fb_context_recipient_id
    WHERE fbca.id IS NULL
    ORDER BY fas.updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaigns_exclusion(segment_filters jsonb, campaign_ids integer[]) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_campaigns_inclusion(jsonb, integer[]); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaigns_inclusion(segment_filters jsonb, campaign_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fas.fb_context_recipient_id,
        fas.fb_context_sender_id,
        fas.data,
        fas.messages,
        fas.quick_replies,
        fas.created_at,
        fas.updated_at,
        fas.id
    FROM postgraphql.get_facebook_bot_activists_strategy(segment_filters) as fas
    UNION
    SELECT *
    FROM postgraphql.get_facebook_activists_by_campaign_ids(campaign_ids);
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaigns_inclusion(segment_filters jsonb, campaign_ids integer[]) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_date_interval(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_date_interval(date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT DISTINCT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM (
        SELECT *, UNNEST(interaction_dates) as interaction_date
        FROM public.facebook_bot_activists
    ) as a
    WHERE interaction_date::date BETWEEN date_interval_start AND date_interval_end
    ORDER BY updated_at;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_date_interval(date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_message(text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message(message text) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM public.facebook_bot_activists
    WHERE messages @@ plainto_tsquery('portuguese', message)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message(message text) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_message_date_interval(text, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message_date_interval(message text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_date_interval(
        date_interval_start,
        date_interval_end
    )
    WHERE messages @@ plainto_tsquery('portuguese', message)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message_date_interval(message text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_message_quick_reply(text, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply(message text, quick_reply text) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM public.facebook_bot_activists
    WHERE
        messages @@ plainto_tsquery('portuguese', message) AND
        quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply(message text, quick_reply text) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_message_quick_reply_date_interval(text, text, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply_date_interval(message text, quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_date_interval(
        date_interval_start,
        date_interval_end
    )
    WHERE
        messages @@ plainto_tsquery('portuguese', message) AND
        quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply_date_interval(message text, quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_quick_reply(text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_quick_reply(quick_reply text) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM public.facebook_bot_activists
    WHERE quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_quick_reply(quick_reply text) OWNER TO monkey_user;

--
-- Name: get_facebook_activists_by_quick_reply_date_interval(text, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_quick_reply_date_interval(quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_date_interval(
        date_interval_start,
        date_interval_end
    )
    WHERE quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_quick_reply_date_interval(quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO monkey_user;

--
-- Name: get_facebook_bot_activists_strategy(jsonb); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_bot_activists_strategy(search jsonb) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    DECLARE
        _message                text      := search ->> 'message';
        _quick_reply            text      := search ->> 'quickReply';
        _date_interval_start    timestamp := search ->> 'dateIntervalStart';
        _date_interval_end      timestamp := search ->> 'dateIntervalEnd';
        _campaign_exclusion_ids int[]     := search ->> 'campaignExclusionIds';
        _campaign_inclusion_ids int[]     := search ->> 'campaignInclusionIds';

        _m      boolean := _message                IS NOT NULL;
        _qr     boolean := _quick_reply            IS NOT NULL;
        _start  boolean := _date_interval_start    IS NOT NULL;
        _end    boolean := _date_interval_end      IS NOT NULL;
        _ce     boolean := _campaign_exclusion_ids IS NOT NULL;
        _ci     boolean := _campaign_inclusion_ids IS NOT NULL;

        _is_only_campaign_exclusion boolean :=      _ce  AND (NOT _ci);
        _is_only_campaign_inclusion boolean := (NOT _ce) AND      _ci;
        _is_both_campaign_strategy  boolean :=      _ce  AND      _ci;
        _is_only_message            boolean :=      _m  AND (NOT _qr) AND (NOT _start) AND (NOT _end);
        _is_only_q_reply            boolean := (NOT _m) AND      _qr  AND (NOT _start) AND (NOT _end);
        _is_only_date_interval      boolean := (NOT _m) AND (NOT _qr) AND      _start  AND      _end;
        _is_q_reply_date_interval   boolean := (NOT _m) AND      _qr  AND       _start AND      _end;
        _is_message_date_interval   boolean :=      _m  AND (NOT _qr) AND      _start  AND      _end;
        _is_message_q_reply         boolean :=      _m  AND      _qr  AND (NOT _start) AND (NOT _end);
        _is_all                     boolean :=      _m  AND      _qr  AND      _start  AND      _end;
    BEGIN
        IF _is_only_campaign_exclusion THEN RETURN QUERY (
            SELECT *
            FROM postgraphql.get_facebook_activists_by_campaigns_exclusion(
                search - 'campaignExclusionIds',
                _campaign_exclusion_ids
            )
        );
        ELSIF _is_only_campaign_inclusion THEN RETURN QUERY (
            SELECT *
            FROM postgraphql.get_facebook_activists_by_campaigns_inclusion(
                search - 'campaignInclusionIds',
                _campaign_inclusion_ids
            )
        );
        ELSIF _is_both_campaign_strategy THEN RETURN QUERY (
            SELECT *
            FROM postgraphql.get_facebook_activists_by_campaigns_both_inclusion_exclusion(
                search - 'campaignInclusionIds' - 'campaignExclusionIds',
                _campaign_exclusion_ids,
                _campaign_inclusion_ids
            )
        );
        ELSE
            IF _is_only_message THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message(_message)
            );
            ELSIF _is_only_q_reply THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_quick_reply(_quick_reply)
            );
            ELSIF _is_only_date_interval THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_date_interval(
                    _date_interval_start,
                    _date_interval_end
                )
            );
            ELSIF _is_q_reply_date_interval THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_quick_reply_date_interval(
                    _quick_reply,
                    _date_interval_start,
                    _date_interval_end
                )
            );
            ELSIF _is_message_date_interval THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message_date_interval(
                    _message,
                    _date_interval_start,
                    _date_interval_end
                )
            );
            ELSIF _is_message_q_reply THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message_quick_reply(
                    _message,
                    _quick_reply
                )
            );
            ELSIF _is_all THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message_quick_reply_date_interval(
                    _message,
                    _quick_reply,
                    _date_interval_start,
                    _date_interval_end
                )
            );
            END IF;
        END IF;
    END;
$$;


ALTER FUNCTION postgraphql.get_facebook_bot_activists_strategy(search jsonb) OWNER TO monkey_user;

--
-- Name: get_facebook_bot_campaign_activists_by_campaign_id(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_bot_campaign_activists_by_campaign_id(campaign_id integer) RETURNS SETOF postgraphql.get_facebook_bot_campaign_activists_by_campaign_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fbca.*,
        fba.fb_context_recipient_id,
        fba.fb_context_sender_id,
        fba.data,
        fba.messages,
        fba.quick_replies,
        fba.interaction_dates
    FROM public.facebook_bot_campaign_activists as fbca
    LEFT JOIN public.facebook_bot_activists as fba
        ON fba.id = fbca.facebook_bot_activist_id
    WHERE fbca.facebook_bot_campaign_id = campaign_id;
$$;


ALTER FUNCTION postgraphql.get_facebook_bot_campaign_activists_by_campaign_id(campaign_id integer) OWNER TO monkey_user;

--
-- Name: get_facebook_bot_campaigns_by_community_id(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_facebook_bot_campaigns_by_community_id(ctx_community_id integer) RETURNS SETOF public.facebook_bot_campaigns
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT campaigns.*
    FROM public.facebook_bot_campaigns as campaigns
    LEFT JOIN public.facebook_bot_configurations as configs
        ON campaigns.facebook_bot_configuration_id = configs.id
    WHERE configs.community_id = ctx_community_id;
$$;


ALTER FUNCTION postgraphql.get_facebook_bot_campaigns_by_community_id(ctx_community_id integer) OWNER TO monkey_user;

--
-- Name: get_widget_donation_stats(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) RETURNS json
    LANGUAGE sql STABLE
    AS $_$
        select
            json_build_object(
            'pledged', sum(d.amount / 100) + coalesce(nullif(w.settings::json->>'external_resource', ''), '0')::bigint,
            'widget_id', w.id,
            'goal', w.goal,
            'progress', ((sum(d.amount / 100) + coalesce(nullif(w.settings::json->>'external_resource', ''), '0')::bigint) / w.goal) * 100,
            'total_donations', (count(distinct d.id)),
            'total_donators', (count(distinct d.activist_id))
            )
        from widgets w
            join donations d on d.widget_id = w.id
            where w.id = $1 and
                d.transaction_status = 'paid'
            group by w.id;
        $_$;


ALTER FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) OWNER TO monkey_user;

--
-- Name: FUNCTION get_widget_donation_stats(widget_id integer); Type: COMMENT; Schema: postgraphql; Owner: monkey_user
--

COMMENT ON FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) IS 'Returns a json with pledged, progress and goal from widget';


--
-- Name: global_templates(); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.global_templates() RETURNS SETOF public.template_mobilizations
    LANGUAGE sql STABLE
    AS $$
          select *
          from public.template_mobilizations
          where
            global = true
        $$;


ALTER FUNCTION postgraphql.global_templates() OWNER TO monkey_user;

--
-- Name: mobilizations(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.mobilizations(days integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    _result json;
BEGIN
    if current_role = 'anonymous' then
        raise 'permission_denied';
    end if;

    select json_agg(row_to_json(t.*)) from (select
        c.name as community_name,
        m.name,
        m.goal,
        m.facebook_share_image,
        m.created_at::timestamp as created_at,
        m.updated_at::timestamp as updated_at,
        count(m.id) as score
        -- m.*
    from
        activist_actions aa
        left join mobilizations m on aa.mobilization_id = m.id
        left join communities c on m.community_id = c.id
    where
        -- aa.action_created_date >= now()::date - interval '90days'
        aa.action_created_date >= now()::date - (days || 'days')::interval
    group by
        m.id,
        c.name
    order by
        score desc
    ) t
    into _result;

    return _result;
END
$$;


ALTER FUNCTION postgraphql.mobilizations(days integer) OWNER TO monkey_user;

--
-- Name: communities; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.communities (
    id integer NOT NULL,
    name character varying,
    city character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mailchimp_api_key text,
    mailchimp_list_id text,
    mailchimp_group_id text,
    image character varying,
    description text,
    recipient_id integer,
    fb_link character varying,
    twitter_link character varying,
    facebook_app_id character varying,
    subscription_retry_interval integer DEFAULT 7,
    subscription_dead_days_interval integer DEFAULT 90,
    email_template_from character varying,
    mailchimp_sync_request_at timestamp without time zone
);


ALTER TABLE public.communities OWNER TO monkey_user;

--
-- Name: communities; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.communities AS
 SELECT com.id,
    com.name,
    com.city,
    com.description,
    com.created_at,
    com.updated_at,
    com.image,
    com.fb_link,
    com.twitter_link
   FROM public.communities com;


ALTER TABLE postgraphql.communities OWNER TO monkey_user;

--
-- Name: mobilizations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.mobilizations (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    color_scheme character varying,
    google_analytics_code character varying,
    goal text,
    facebook_share_title character varying,
    facebook_share_description text,
    header_font character varying,
    body_font character varying,
    facebook_share_image character varying,
    slug character varying NOT NULL,
    custom_domain character varying,
    twitter_share_text character varying(140),
    community_id integer,
    favicon character varying,
    deleted_at timestamp without time zone,
    status public.status_mobilization DEFAULT 'active'::public.status_mobilization,
    traefik_host_rule character varying,
    traefik_backend_address character varying
);


ALTER TABLE public.mobilizations OWNER TO monkey_user;

--
-- Name: mobilizations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.mobilizations AS
 SELECT m.id,
    m.name,
    m.created_at,
    m.updated_at,
    m.user_id,
    m.color_scheme,
    m.google_analytics_code,
    m.goal,
    m.facebook_share_title,
    m.facebook_share_description,
    m.header_font,
    m.body_font,
    m.facebook_share_image,
    m.slug,
    m.custom_domain,
    m.twitter_share_text,
    m.community_id,
    m.favicon,
    m.deleted_at,
    m.status
   FROM public.mobilizations m
  WHERE (m.deleted_at IS NULL);


ALTER TABLE postgraphql.mobilizations OWNER TO monkey_user;

--
-- Name: mobilizations_community(postgraphql.mobilizations); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.mobilizations_community(m postgraphql.mobilizations) RETURNS postgraphql.communities
    LANGUAGE sql STABLE
    AS $$
    select c.*
    from postgraphql.communities c
    where c.id = m.community_id
$$;


ALTER FUNCTION postgraphql.mobilizations_community(m postgraphql.mobilizations) OWNER TO monkey_user;

--
-- Name: register(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.register(data json) RETURNS postgraphql.jwt_token
    LANGUAGE plpgsql
    AS $_$
    declare
        _user public.users;
        _invitation public.invitations;
    begin
        if current_role <> 'anonymous' then
            raise 'user_already_logged';
        end if;
        -- check if first_name, email and password are present
        if nullif(btrim($1->> 'first_name'::text), '') is null then
            raise 'missing_first_name';
        end if;
    
        if nullif(btrim($1->> 'email'::text), '') is null then
            raise 'missing_email';
        end if;
    
        if nullif(($1->> 'password')::text, '') is null then
            raise 'missing_password';
        end if;
        
        if length(($1->>'password'::text)) < 6 then
            raise 'password_lt_six_chars';
        end if;
        
        insert into public.users(uid, provider, email, encrypted_password, first_name, last_name)
            values (
                ($1->>'email')::email, 
                'email', 
                ($1->>'email')::email, 
                crypt($1->>'password'::text, gen_salt('bf', 9)),
                ($1->>'first_name')::text,
                ($1->>'last_name')::text
            ) returning * into _user;
        
        -- related created user with community by invitation_code
        if nullif(($1->> 'invitation_code')::text, '') is not null then
          select * from public.invitations where code = ($1->>'invitation_code'::text) into _invitation;
          insert into public.community_users(user_id, community_id, role, created_at, updated_at) values (
            _user.id,
            _invitation.community_id,
            _invitation.role,
            now(),
            now()
          );
        end if;

        perform public.notify('welcome_user', json_build_object(
          'user_id', _user.id
        ));

        return ('common_user', _user.id)::postgraphql.jwt_token;
    end;
$_$;


ALTER FUNCTION postgraphql.register(data json) OWNER TO monkey_user;

--
-- Name: reset_password_change_password(text, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.reset_password_change_password(new_password text, token text) RETURNS public.change_password_fields
    LANGUAGE plpgsql
    AS $$
          declare
              _password_fields change_password_fields%ROWTYPE;
              _jwt json;
              _user public.users;
          begin
              select postgraphql.reset_password_token_verify(token) into _jwt;

              select * from public.users where id = (_jwt->>'id')::int into _user;

              if nullif(new_password, '') is null then
                  raise 'missing_password';
              end if;

              if length(new_password) < 6 then
                  raise 'password_lt_six_chars';
              end if;

              update public.users
                  set encrypted_password = public.crypt(new_password, public.gen_salt('bf', 9)), reset_password_token = null
              where id = _user.id;

              _password_fields.user_first_name = _user.first_name;
              _password_fields.user_last_name = _user.last_name;
              _password_fields.token = (
                  (case when _user.admin is true then 'admin' else 'common_user' end),
                  _user.id
              )::postgraphql.jwt_token;

              return _password_fields;
          end;
      $$;


ALTER FUNCTION postgraphql.reset_password_change_password(new_password text, token text) OWNER TO monkey_user;

--
-- Name: reset_password_token_request(text, text, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.reset_password_token_request(email text, callback_url text, locale text DEFAULT 'pt-BR'::text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
          declare
            _user public.users;
            _notification_template_id integer;
            _locale text;
            _notification public.notifications;
          begin
            _locale := coalesce(locale, 'pt-BR');

            -- find user by email
            select * from public.users u where u.email = $1
                into _user;

            if _user.id is null then
                raise 'user_not_found';
            end if;

            -- generate new reset token
            update public.users
                set reset_password_token = pgjwt.sign(json_build_object(
                  'id', _user.id,
                  'expirated_at', now() + interval '48 hours'
              ), public.configuration('jwt_secret'), 'HS512')
                where id = _user.id
            returning * into _user;

            -- TODO think other utilities this snippet
            -- get notification template id for user locale
            select nt.id from public.notification_templates nt where label = 'reset_password_instructions'
                and nt.locale = _locale limit 1
                into _notification_template_id;

            -- fallback on default locale when locale from user not found
            if _notification_template_id is null then
                select nt.id from public.notification_templates nt where label = 'reset_password_instructions'
                    and nt.locale = 'pt-BR'
                    into _notification_template_id;

                if _notification_template_id is null then
                    raise 'invalid_notification_template';
                end if;
            end if;

            -- notify user about reset password instructions
            insert into public.notifications(user_id, notification_template_id, template_vars, created_at, updated_at)
                values (_user.id, _notification_template_id, json_build_object(
                    'user', json_build_object(
                        'id', _user.id,
                        'uid', _user.uid,
                        'email', _user.email,
                        'first_name', _user.first_name,
                        'last_name', _user.last_name,
                        'reset_password_token', _user.reset_password_token,
                        'callback_url', callback_url)
                ), now(), now()) returning * into _notification;

            -- notify to notification_channels
            perform pg_notify('notifications_channel',pgjwt.sign(json_build_object(
                'action', 'deliver_notification',
                'id', _notification.id,
                'created_at', now(),
                'sent_to_queuing', now(),
                'jit', now()::timestamp
            ), public.configuration('jwt_secret'), 'HS512'));
          end;
      $_$;


ALTER FUNCTION postgraphql.reset_password_token_request(email text, callback_url text, locale text) OWNER TO monkey_user;

--
-- Name: reset_password_token_verify(text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.reset_password_token_verify(token text) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $$
                declare
                    _jwt json;
                    _user public.users;
                begin

                    if (select valid from pgjwt.verify(token, public.configuration('jwt_secret'), 'HS512')) is false then
                        raise 'invalid_token';
                    end if;

                    select payload
                        from pgjwt.verify(token, public.configuration('jwt_secret'), 'HS512')
                    into _jwt;

                    if to_date(_jwt->>'expirated_at', 'YYYY MM DD') <= now()::date then
                        raise 'invalid_token';
                    end if;

                    select * from public.users u where u.id = (_jwt->>'id')::int and u.reset_password_token = token into _user;
                    if _user is null then
                        raise 'invalid_token';
                    end if;

                    return _jwt;
                end;
            $$;


ALTER FUNCTION postgraphql.reset_password_token_verify(token text) OWNER TO monkey_user;

--
-- Name: activists; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.activists (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying,
    document_number character varying,
    document_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    city character varying,
    first_name text,
    last_name text
);


ALTER TABLE public.activists OWNER TO monkey_user;

--
-- Name: community_activists; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.community_activists (
    id integer NOT NULL,
    community_id integer NOT NULL,
    activist_id integer NOT NULL,
    search_index tsvector,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_data jsonb
);


ALTER TABLE public.community_activists OWNER TO monkey_user;

--
-- Name: community_users; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.community_users (
    id integer NOT NULL,
    user_id integer,
    community_id integer,
    role integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.community_users OWNER TO monkey_user;

--
-- Name: activists; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.activists AS
 WITH current_communities_access AS (
         SELECT DISTINCT cu.community_id
           FROM public.community_users cu
          WHERE ((cu.user_id = postgraphql.current_user_id()) OR ("current_user"() = 'admin'::name))
        )
 SELECT ca.community_id,
    ca.activist_id AS id,
    ((ca.profile_data ->> 'name'::text))::character varying AS name,
    a.email,
    ((ca.profile_data ->> 'phone'::text))::character varying AS phone,
    ((ca.profile_data ->> 'document_number'::text))::character varying AS document_number,
    ca.created_at,
    (ca.profile_data)::json AS data,
    '{}'::json AS mobilizations,
    '{}'::jsonb AS tags
   FROM (public.community_activists ca
     JOIN public.activists a ON ((a.id = ca.activist_id)))
  WHERE (ca.community_id IN ( SELECT current_communities_access.community_id
           FROM current_communities_access));


ALTER TABLE postgraphql.activists OWNER TO monkey_user;

--
-- Name: search_activists_on_community(text, integer, integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.search_activists_on_community(query text, ctx_community_id integer, days_ago integer) RETURNS SETOF postgraphql.activists
    LANGUAGE sql STABLE
    AS $$
        with search_index as (
              select
                  atg.community_id,
                  atg.activist_id,
                  json_agg(json_build_object(
                    'tag_name', tag.name,
                    'activist_name', a.name,
                    'activist_email', a.email
                  )) package_search_vector
                  from public.activist_tags atg
                      join public.taggings tgs on tgs.taggable_type = 'ActivistTag'
                          and tgs.taggable_id = atg.id
                      join public.tags tag on tag.id = tgs.tag_id
                      join public.activists a on a.id = atg.activist_id
                      where atg.community_id = ctx_community_id
                        and (
                            case when days_ago is null or days_ago = 0 then true
                            else atg.created_at >= (current_timestamp - (days_ago||' days')::interval) end
                            )                      
                    group by atg.activist_id, atg.community_id, a.id
              ) select
                    act.*
                    from search_index si
                        join lateral (
                            select exists (
                                select
                                    true
                                from json_array_elements(si.package_search_vector)  as vec
                                    where (setweight(
                                              to_tsvector('portuguese', replace((regexp_split_to_array((vec->>'tag_name')::text, '_'::text))[2], '-', ' ')), 'A'
                                          )||setweight(
                                              to_tsvector('portuguese', (vec->>'tag_name')::text), 'B'
                                          )||setweight(
                                              to_tsvector('portuguese', vec->>'activist_name'), 'B'
                                          )||setweight(
                                              to_tsvector('portuguese', vec->>'activist_email'), 'C'
                                          ))::tsvector @@ plainto_tsquery('portuguese', query)
                            ) as found
                        ) as si_r on found
                        join lateral (
                             SELECT pa.*
                             FROM postgraphql.activists pa
                              WHERE pa.community_id = si.community_id
                                and pa.id = si.activist_id
                        ) as act on true
        $$;


ALTER FUNCTION postgraphql.search_activists_on_community(query text, ctx_community_id integer, days_ago integer) OWNER TO monkey_user;

--
-- Name: total_avg_donations_by_community(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_avg_donations_by_community(com_id integer) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.community_id = com_id
                and d.transaction_status = 'paid'
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_community(com_id integer) OWNER TO monkey_user;

--
-- Name: total_avg_donations_by_community_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_avg_donations_by_community_interval(com_id integer, timeinterval interval) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.community_id = com_id
                and d.transaction_status = 'paid'
                and d.payment_date > CURRENT_TIMESTAMP - timeinterval
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_community_interval(com_id integer, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_avg_donations_by_mobilization(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_avg_donations_by_mobilization(mob_id integer) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.mobilization_id = mob_id
                and d.transaction_status = 'paid'
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_mobilization(mob_id integer) OWNER TO monkey_user;

--
-- Name: total_avg_donations_by_mobilization_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_avg_donations_by_mobilization_interval(mob_id integer, timeinterval interval) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.mobilization_id = mob_id
                and d.transaction_status = 'paid'
                and d.payment_date > CURRENT_TIMESTAMP - timeinterval
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_mobilization_interval(mob_id integer, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_count_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_donations_from_community(com_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_community(com_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_count_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_count_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_donations_from_mobilization(mob_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_mobilization(mob_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_count_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_donations_from_mobilization_interval(mod_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.mobilization_id = mod_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_mobilization_interval(mod_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_count_subscription_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_community(com_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_community(com_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_count_subscription_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_count_subscription_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_mobilization(mob_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_mobilization(mob_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_count_subscription_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_count_uniq_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_community(com_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_community(com_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_count_uniq_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_count_uniq_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_mobilization(mob_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_mobilization(mob_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_count_uniq_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_sum_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_donations_from_community(com_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_community(com_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_sum_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_sum_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_donations_from_mobilization(mob_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_mobilization(mob_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_sum_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_sum_subscription_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_community(com_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_community(com_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_sum_subscription_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_sum_subscription_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization(mob_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization(mob_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_sum_subscription_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_sum_transfer_operations_from_community(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) RETURNS numeric
    LANGUAGE sql
    AS $_$
         WITH current_communities_access AS (
             SELECT DISTINCT(cu.community_id)
               FROM community_users cu
              WHERE ((cu.user_id = postgraphql.current_user_id()) OR ("current_user"() = 'admin'::name))
            ) select sum(bos.operation_amount) 
            from public.balance_operation_summaries bos
            where bos.operation_type = 'transfer' 
            and bos.community_id = $1 and (bos.community_id IN (
            SELECT current_communities_access.community_id FROM current_communities_access));
    $_$;


ALTER FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) OWNER TO monkey_user;

--
-- Name: FUNCTION total_sum_transfer_operations_from_community(community_id integer); Type: COMMENT; Schema: postgraphql; Owner: monkey_user
--

COMMENT ON FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) IS 'Get total sum of all transfers to community';


--
-- Name: total_sum_uniq_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_community(com_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_community(com_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_sum_uniq_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_sum_uniq_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization(mob_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization(mob_id integer, status text) OWNER TO monkey_user;

--
-- Name: total_sum_uniq_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount) 
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_uniq_activists_by_kind_and_community(text, integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_community(kind_name text, com_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id
                and participate_kind = kind_name
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_community(kind_name text, com_id integer) OWNER TO monkey_user;

--
-- Name: total_uniq_activists_by_kind_and_community_interval(text, integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_community_interval(kind_name text, com_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id
                and participate_kind = kind_name
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_community_interval(kind_name text, com_id integer, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_uniq_activists_by_kind_and_mobilization(text, integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization(kind_name text, mob_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id
                and participate_kind = kind_name
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization(kind_name text, mob_id integer) OWNER TO monkey_user;

--
-- Name: total_uniq_activists_by_kind_and_mobilization_interval(text, integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization_interval(kind_name text, mob_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id
                and participate_kind = kind_name
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization_interval(kind_name text, mob_id integer, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_unique_activists_by_community(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_unique_activists_by_community(com_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_community(com_id integer) OWNER TO monkey_user;

--
-- Name: total_unique_activists_by_community_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_unique_activists_by_community_interval(com_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_community_interval(com_id integer, timeinterval interval) OWNER TO monkey_user;

--
-- Name: total_unique_activists_by_mobilization(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_unique_activists_by_mobilization(mob_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_mobilization(mob_id integer) OWNER TO monkey_user;

--
-- Name: total_unique_activists_by_mobilization_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.total_unique_activists_by_mobilization_interval(mob_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_mobilization_interval(mob_id integer, timeinterval interval) OWNER TO monkey_user;

--
-- Name: trending_mobilizations(integer); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.trending_mobilizations(days integer) RETURNS SETOF postgraphql.mobilizations
    LANGUAGE sql STABLE
    AS $$
select m.*
from postgraphql.mobilizations m
left join lateral (
    select count(1)
    from public.activist_actions aa
        where aa.mobilization_id  = m.id
            and aa.action_created_date >= now()::date - (days || ' days')::interval
) as score on true
order by score desc;
$$;


ALTER FUNCTION postgraphql.trending_mobilizations(days integer) OWNER TO monkey_user;

--
-- Name: update_bot(json); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.update_bot(bot_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
        declare
            bot_json public.facebook_bot_configurations;
        begin
            update public.facebook_bot_configurations
                set community_id = coalesce((bot_data ->> 'community_id')::integer, community_id)::integer, 
                    messenger_app_secret = coalesce((bot_data ->> 'messenger_app_secret'), messenger_app_secret), 
                    messenger_validation_token = coalesce((bot_data ->> 'messenger_validation_token'), messenger_validation_token),
                    messenger_page_access_token = coalesce((bot_data ->> 'messenger_page_access_token'), messenger_validation_token), 
                    data = coalesce((bot_data ->> 'data')::jsonb, data), 
                    updated_at = now()
                where id = (bot_data ->> 'id')::integer
                returning * into bot_json;

                return row_to_json(bot_json);
        end;
    $$;


ALTER FUNCTION postgraphql.update_bot(bot_data json) OWNER TO monkey_user;

--
-- Name: facebook_bot_campaign_activists; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.facebook_bot_campaign_activists (
    id integer NOT NULL,
    facebook_bot_campaign_id integer NOT NULL,
    facebook_bot_activist_id integer NOT NULL,
    received boolean DEFAULT false NOT NULL,
    log jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_campaign_activists OWNER TO monkey_user;

--
-- Name: update_facebook_bot_campaign_activists(integer, boolean, jsonb); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.update_facebook_bot_campaign_activists(facebook_bot_campaign_activist_id integer, ctx_received boolean, ctx_log jsonb) RETURNS public.facebook_bot_campaign_activists
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_facebook_bot_campaign_activist public.facebook_bot_campaign_activists;
    BEGIN
        UPDATE public.facebook_bot_campaign_activists SET
            received = ctx_received,
            "log" = ctx_log,
            updated_at = NOW()
        WHERE id = facebook_bot_campaign_activist_id
        RETURNING * INTO v_facebook_bot_campaign_activist;
        RETURN v_facebook_bot_campaign_activist;
    END;
$$;


ALTER FUNCTION postgraphql.update_facebook_bot_campaign_activists(facebook_bot_campaign_activist_id integer, ctx_received boolean, ctx_log jsonb) OWNER TO monkey_user;

--
-- Name: update_twilio_configuration(postgraphql.twilio_configurations); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.update_twilio_configuration(config postgraphql.twilio_configurations) RETURNS postgraphql.twilio_configurations
    LANGUAGE plpgsql
    AS $$
  DECLARE twilio_configuration postgraphql.twilio_configurations;
  BEGIN
    UPDATE postgraphql.twilio_configurations
    SET
      twilio_account_sid = COALESCE(
        CONFIG.twilio_account_sid,
        twilio_configuration.twilio_account_sid
      ),
      twilio_auth_token = COALESCE(
        CONFIG.twilio_auth_token,
        twilio_configuration.twilio_auth_token
      ),
      twilio_number = COALESCE(
        CONFIG.twilio_number,
        twilio_configuration.twilio_number
      ),
      updated_at = now()
    WHERE community_id = CONFIG.community_id
    RETURNING * INTO twilio_configuration;
    RETURN twilio_configuration;
  END;
$$;


ALTER FUNCTION postgraphql.update_twilio_configuration(config postgraphql.twilio_configurations) OWNER TO monkey_user;

--
-- Name: user_mobilizations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.user_mobilizations AS
 SELECT m.id,
    m.name,
    m.created_at,
    m.updated_at,
    m.user_id,
    m.color_scheme,
    m.google_analytics_code,
    m.goal,
    m.facebook_share_title,
    m.facebook_share_description,
    m.header_font,
    m.body_font,
    m.facebook_share_image,
    m.slug,
    m.custom_domain,
    m.twitter_share_text,
    m.community_id,
    m.favicon,
    m.deleted_at,
    m.status
   FROM (postgraphql.mobilizations m
     JOIN public.community_users cou ON ((cou.community_id = m.community_id)))
  WHERE (cou.user_id = postgraphql.current_user_id());


ALTER TABLE postgraphql.user_mobilizations OWNER TO monkey_user;

--
-- Name: user_mobilizations_community(postgraphql.user_mobilizations); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.user_mobilizations_community(m postgraphql.user_mobilizations) RETURNS postgraphql.communities
    LANGUAGE sql STABLE
    AS $$
    select c.*
    from postgraphql.communities c
    where c.id = m.community_id
$$;


ALTER FUNCTION postgraphql.user_mobilizations_community(m postgraphql.user_mobilizations) OWNER TO monkey_user;

--
-- Name: user_mobilizations_score(postgraphql.user_mobilizations); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.user_mobilizations_score(m postgraphql.user_mobilizations) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
    select count(1)::INT
    from public.activist_actions aa
        where aa.mobilization_id  = m.id
$$;


ALTER FUNCTION postgraphql.user_mobilizations_score(m postgraphql.user_mobilizations) OWNER TO monkey_user;

--
-- Name: watch_twilio_call_transitions(postgraphql.twilio_calls_arguments); Type: FUNCTION; Schema: postgraphql; Owner: monkey_user
--

CREATE FUNCTION postgraphql.watch_twilio_call_transitions(call postgraphql.twilio_calls_arguments) RETURNS postgraphql.watch_twilio_call_transition_record_set
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT tc.widget_id AS widget_id,
         tc.activist_id AS activist_id,
         tc.id AS twilio_call_id,
         tc.twilio_account_sid AS twilio_call_account_sid,
         tc.twilio_call_sid AS twilio_call_call_sid,
         tc."from" AS twilio_call_from,
         tc."to" AS twilio_call_to,
         tct.id AS twilio_call_transition_id,
         tct.sequence_number AS twilio_call_transition_sequence_number,
         tct.status AS twilio_call_transition_status,
         tct.call_duration AS twilio_call_transition_call_duration,
         tct.created_at AS twilio_call_transition_created_at,
         tct.updated_at AS twilio_call_transition_updated_at
  FROM public.twilio_calls AS tc
  RIGHT JOIN public.twilio_call_transitions AS tct ON tc.twilio_call_sid = tct.twilio_call_sid
  WHERE tc.widget_id = CALL.widget_id
    AND tc."from" = CALL."from"
  ORDER BY tc.id DESC,
           tct.sequence_number DESC LIMIT 1;
$$;


ALTER FUNCTION postgraphql.watch_twilio_call_transitions(call postgraphql.twilio_calls_arguments) OWNER TO monkey_user;

--
-- Name: configuration(text); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.configuration(name text) RETURNS text
    LANGUAGE sql
    AS $_$
            select value from public.configurations where name = $1;
        $_$;


ALTER FUNCTION public.configuration(name text) OWNER TO monkey_user;

--
-- Name: facebook_activist_message_full_text_index(text); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.facebook_activist_message_full_text_index(v_message text) RETURNS tsvector
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN setweight(to_tsvector('portuguese', v_message), 'A');
    END;
$$;


ALTER FUNCTION public.facebook_activist_message_full_text_index(v_message text) OWNER TO monkey_user;

--
-- Name: generate_activists_from_generic_resource_with_widget(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.generate_activists_from_generic_resource_with_widget() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        declare
            v_mobilization public.mobilizations;
            v_profile_data json;
        begin
            IF TG_TABLE_NAME in ('subscriptions', 'form_entries', 'donations', 'activist_pressures')
                AND NEW.activist_id is not null AND NEW.widget_id is not null THEN

                select distinct(m.*) from mobilizations m
                    join blocks b on b.mobilization_id = m.id
                    join widgets w on w.block_id = b.id
                    where w.id = NEW.widget_id
                    into v_mobilization;
                
                select row_to_json(activists.*) from activists where id = NEW.activist_id
                    into v_profile_data;

                IF v_mobilization.id IS NOT NULL THEN
                    if not exists(select true
                        from community_activists
                        where community_id = v_mobilization.community_id and activist_id = NEW.activist_id) then
                        insert into community_activists (community_id, activist_id, created_at, updated_at, profile_data)
                            values (v_mobilization.community_id, NEW.activist_id, now(), now(), v_profile_data::jsonb);
                    end if;

                    if not exists(select true
                        from mobilization_activists
                        where mobilization_id = v_mobilization.id and activist_id = NEW.activist_id) then
                        insert into mobilization_activists (mobilization_id, activist_id, created_at, updated_at)
                            values (v_mobilization.id, NEW.activist_id, now(), now());
                    end if;
                END IF;

            END IF;
            return NEW;
        end;
    $$;


ALTER FUNCTION public.generate_activists_from_generic_resource_with_widget() OWNER TO monkey_user;

--
-- Name: FUNCTION generate_activists_from_generic_resource_with_widget(); Type: COMMENT; Schema: public; Owner: monkey_user
--

COMMENT ON FUNCTION public.generate_activists_from_generic_resource_with_widget() IS 'insert a row on mobilization_activists and community_activists linking from NEW.activist_id / widget_id';


--
-- Name: generate_notification_tags(json); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.generate_notification_tags(relations json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
            _subscription public.subscriptions;
            _donation public.donations;
            _last_subscription_payment public.donations;
            _activist public.activists;
            _community public.communities;
            _mobilization public.mobilizations;
            _user public.users;
            _result json;
        begin
            -- get subscription when json->>'subscription_id' is present
            select * from public.subscriptions where id = ($1->>'subscription_id')::integer
                into _subscription;

            -- get donation when json->>'donation_id' is present
            select * from public.donations where id = ($1->>'donation_id')::integer
                into _donation;

            -- get last subscription donation when json ->> 'subscription_id' is present
            select * from public.donations where local_subscription_id = _subscription.id
                order by created_at desc limit 1 into _last_subscription_payment;

            -- get activist when json ->> 'activist_id' is present or subscription/donation is found
            select * from public.activists where id = coalesce(coalesce(($1->>'activist_id')::integer, _subscription.activist_id), _donation.activist_id)
                into _activist;

            -- get community when json->>'community_id' is present or subscription/donation is found
            select * from public.communities where id = coalesce(coalesce(($1->>'community_id')::integer, _subscription.community_id), _donation.cached_community_id)
                into _community;
                
            -- get user when json->>'user_id' is present
            select * from public.users where id = ($1->>'user_id')::integer 
                into _user;

            -- get mobilization from subscription/donation widget when block is defined
            select * from mobilizations m
                join blocks b on b.mobilization_id = m.id
                join widgets w on w.block_id = b.id
                where w.id = coalesce(_subscription.widget_id, _donation.widget_id)
                into _mobilization;


            -- build and return template tags json after collect all data
            _result := json_build_object(
                'subscription_id', _subscription.id,
                'payment_method', coalesce(_subscription.payment_method, _donation.payment_method),
                'donation_id', _donation.id,
                'widget_id', _donation.widget_id,
                'mobilization_id', _mobilization.id,
                'mobilization_name', _mobilization.name,
                'boleto_expiration_date', (_donation.gateway_data ->> 'boleto_expiration_date'),
                'boleto_barcode', (_donation.gateway_data ->> 'boleto_barcode'),
                'boleto_url', (_donation.gateway_data ->> 'boleto_url'),
                'manage_url', (
                    case when _subscription.id is not null then
                        'https://app.bonde.org/subscriptions/'||_subscription.id||'/edit?token='||_subscription.token
                    else null end
                ),
                'amount', (coalesce(_subscription.amount, _donation.amount) / 100),
                'user', json_build_object(
                    'first_name', _user.first_name,
                    'last_name', _user.last_name
                ),
                'customer', json_build_object(
                    'name', _activist.name,
                    'first_name', _activist.first_name,
                    'last_name', _activist.last_name
                ),
                'community', json_build_object(
                    'id', _community.id,
                    'name', _community.name,
                    'image', _community.image
                ),
                'last_donation', json_build_object(
                    'payment_method', _last_subscription_payment.payment_method,
                    'widget_id', _last_subscription_payment.widget_id,
                    'mobilization_id', _mobilization.id,
                    'mobilization_name', _mobilization.name,
                    'boleto_expiration_date', (_last_subscription_payment.gateway_data ->> 'boleto_expiration_date'),
                    'boleto_barcode', (_last_subscription_payment.gateway_data ->> 'boleto_barcode'),
                    'boleto_url', (_last_subscription_payment.gateway_data ->> 'boleto_url')
                )
            );
            
            return _result;
        end;
    $_$;


ALTER FUNCTION public.generate_notification_tags(relations json) OWNER TO monkey_user;

--
-- Name: nossas_recipient_id(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.nossas_recipient_id() RETURNS text
    LANGUAGE sql
    AS $$
         select 'RECIPIENT_ID_HERE'::text;
$$;


ALTER FUNCTION public.nossas_recipient_id() OWNER TO monkey_user;

--
-- Name: notify(text, json); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.notify(template_name text, relations json) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
    declare
        _community public.communities;
        _user public.users;
        _activist public.activists;
        _notification public.notifications;
        _notification_template public.notification_templates;
        _template_vars json;
    begin
        -- get community from relations
        select * from public.communities where id = ($2->>'community_id')::integer
            into _community;

        -- get user from relations
        select * from public.users where id = ($2->>'user_id')::integer
            into _user;

        -- get activist when set on relations
        select * from public.activists where id = ($2->>'activist_id')::integer
            into _activist;

        -- try get notification template from community
        select * from public.notification_templates nt
            where nt.community_id = ($2->>'community_id')::integer
                and nt.label = $1
            into _notification_template;

        -- if not found on community try get without community
        if _notification_template is null then
            select * from public.notification_templates nt
                where nt.label = $1
                into _notification_template;

            if _notification_template is null then
                raise 'invalid_notification_template';
            end if;
        end if;

        _template_vars := public.generate_notification_tags(relations);

        -- insert notification to database
        insert into notifications(activist_id, notification_template_id, template_vars, created_at, updated_at, user_id, email)
            values (_activist.id, _notification_template.id, _template_vars::jsonb, now(), now(), _user.id, $2->>'email')
        returning * into _notification;

        -- notify to notification_channels
        perform pg_notify('notifications_channel',pgjwt.sign(json_build_object(
            'action', 'deliver_notification',
            'id', _notification.id,
            'created_at', now(),
            'sent_to_queuing', now(),
            'jit', now()::timestamp
        ), public.configuration('jwt_secret'), 'HS512'));

        return json_build_object('id', _notification.id);
    end;
$_$;


ALTER FUNCTION public.notify(template_name text, relations json) OWNER TO monkey_user;

--
-- Name: notify_create_twilio_configuration_trigger(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.notify_create_twilio_configuration_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'INSERT') THEN
            perform pg_notify('twilio_configuration_created', row_to_json(NEW)::text);
          END IF;

          IF (TG_OP = 'UPDATE') THEN
            perform pg_notify('twilio_configuration_updated', row_to_json(NEW)::text);
          END IF;

          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.notify_create_twilio_configuration_trigger() OWNER TO monkey_user;

--
-- Name: notify_form_entries_trigger(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.notify_form_entries_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN

          perform pg_notify('form_entries_channel',
            pgjwt.sign(
              row_to_json(NEW),
              public.configuration('jwt_secret'),
              'HS512'
            )
          );

          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.notify_form_entries_trigger() OWNER TO monkey_user;

--
-- Name: notify_twilio_call_trigger(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.notify_twilio_call_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    BEGIN perform pg_notify('twilio_call_created', row_to_json(NEW)::text);
    RETURN NEW;
  END;
$$;


ALTER FUNCTION public.notify_twilio_call_trigger() OWNER TO monkey_user;

--
-- Name: donations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.donations (
    id integer NOT NULL,
    widget_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    token character varying,
    payment_method character varying,
    amount integer,
    email character varying,
    card_hash character varying,
    customer public.hstore,
    skip boolean DEFAULT false,
    transaction_id character varying,
    transaction_status character varying DEFAULT 'pending'::character varying,
    subscription boolean,
    credit_card character varying,
    activist_id integer,
    subscription_id character varying,
    period integer,
    plan_id integer,
    parent_id integer,
    payables jsonb,
    gateway_data jsonb,
    payable_transfer_id integer,
    converted_from integer,
    synchronized boolean,
    local_subscription_id integer,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    checkout_data jsonb,
    cached_community_id integer
);


ALTER TABLE public.donations OWNER TO monkey_user;

--
-- Name: payable_fee(public.donations); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.payable_fee(d public.donations) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
    select (
    case
    when d.payables is not null and jsonb_array_length(d.payables) < 2 then
        (
            case 
            when extract(year from d.created_at) <= 2016 then        
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.15)  - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            else
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.13) - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            end
        )
    when d.payables is null then
        (
            case 
            when extract(year from d.created_at) <= 2016 then
                (d.amount / 100.0) * 0.15
            else
                (d.amount / 100.0) * 0.13
            end        
        )    
    else
        (
            select 
                ((p ->> 'amount')::integer / 100.0) - ((p ->> 'fee')::integer / 100.0)
            from jsonb_array_elements(d.payables) p
                where (p ->> 'fee')::integer <> 0
                    limit 1
        )
    end)::decimal - (case d.payment_method 
                     when 'boleto' then 0
                     else coalesce(((d.gateway_data ->> 'cost')::integer / 100.0), 0) end)
$$;


ALTER FUNCTION public.payable_fee(d public.donations) OWNER TO monkey_user;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    widget_id integer,
    activist_id integer,
    community_id integer,
    card_data jsonb,
    status character varying,
    period integer DEFAULT 30,
    amount integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    payment_method text NOT NULL,
    token uuid DEFAULT public.uuid_generate_v4(),
    gateway_subscription_id integer,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    gateway_customer_id integer,
    customer_data jsonb,
    schedule_next_charge_at timestamp without time zone
);


ALTER TABLE public.subscriptions OWNER TO monkey_user;

--
-- Name: receiving_unpaid_notifications(public.subscriptions); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.receiving_unpaid_notifications(public.subscriptions) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $_$
    declare
        _last_paid_donation public.donations;
    begin
        select * from donations
            where local_subscription_id = $1.id
                and transaction_status = 'paid'
                order by created_at desc
                limit 1
        into _last_paid_donation;
        
        if _last_paid_donation.id is not null then
            return coalesce((
                select count(1) <= 2 
                    from notifications n
                    join notification_templates nt on nt.id = n.notification_template_id
                    where nt.label = 'unpaid_subscription'
                        and (n.template_vars->>'subscription_id')::integer = $1.id
                        and n.created_at >= _last_paid_donation.created_at
            ), true);
        else
            return (
                select count(1) <= 2 
                    from notifications n
                    join notification_templates nt on nt.id = n.notification_template_id
                    where nt.label = 'unpaid_subscription'
                        and (n.template_vars->>'subscription_id')::integer = $1.id
            );
        end if;
    end;
$_$;


ALTER FUNCTION public.receiving_unpaid_notifications(public.subscriptions) OWNER TO monkey_user;

--
-- Name: refresh_custom_domain_frontend(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.refresh_custom_domain_frontend() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        if new.traefik_host_rule is not null then
            perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
                'action', 'refresh_frontend',
                'id', new.id,
                'created_at', now(),
                'sent_to_queuing', now(),
                'jit', now()::timestamp
            ), public.configuration('jwt_secret'), 'HS512'));
        end if;
        
        return new;
    end;
$$;


ALTER FUNCTION public.refresh_custom_domain_frontend() OWNER TO monkey_user;

--
-- Name: slugfy(text); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.slugfy(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
        select regexp_replace(replace(unaccent(lower($1)), ' ', '-'), '[^a-z0-9-_]+', '', 'g');
    $_$;


ALTER FUNCTION public.slugfy(text) OWNER TO monkey_user;

--
-- Name: update_facebook_bot_activists_full_text_index(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.update_facebook_bot_activists_full_text_index() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_facebook_bot_activists public.facebook_bot_activists;
        v_payload jsonb;
        v_quick_reply text;
        v_messages tsvector;
        v_quick_replies text[];
    BEGIN
        SELECT *
        FROM public.facebook_bot_activists
        WHERE fb_context_recipient_id = NEW.fb_context_recipient_id
        INTO v_facebook_bot_activists;

        IF NEW.interaction ->> 'is_bot' IS NULL THEN
            v_payload := NEW.interaction -> 'payload';
            v_quick_reply := v_payload -> 'message' -> 'quick_reply' ->> 'payload';
            v_messages := CASE WHEN v_quick_reply IS NULL THEN
                public.facebook_activist_message_full_text_index(
                    v_payload -> 'message' ->> 'text'
                )
            END;

            IF v_quick_reply IS NOT NULL THEN
                v_quick_replies := ARRAY[v_quick_reply]::text[];
            END IF;

            IF v_facebook_bot_activists IS NULL THEN
                INSERT INTO public.facebook_bot_activists (
                    fb_context_recipient_id,
                    fb_context_sender_id,
                    data,
                    messages,
                    quick_replies,
                    interaction_dates,
                    created_at,
                    updated_at
                ) VALUES (
                    NEW.fb_context_recipient_id,
                    NEW.fb_context_sender_id,
                    NEW.interaction -> 'profile',
                    v_messages,
                    COALESCE(v_quick_replies, ARRAY[]::text[]),
                    ARRAY[NEW.created_at]::timestamp without time zone[],
                    NEW.created_at,
                    NEW.updated_at
                );
            ELSE
                UPDATE public.facebook_bot_activists
                SET
                    interaction_dates = ARRAY_APPEND(interaction_dates, NEW.created_at),
                    messages = CASE WHEN v_quick_reply IS NULL THEN messages || v_messages
                    ELSE messages
                    END,
                    quick_replies = CASE WHEN v_quick_replies IS NOT NULL THEN
                        (SELECT ARRAY_AGG(DISTINCT qr)
                        FROM UNNEST(ARRAY_CAT(quick_replies, v_quick_replies)) as qr)
                    ELSE
                        quick_replies
                    END
                WHERE fb_context_recipient_id = NEW.fb_context_recipient_id;
            END IF;
        END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.update_facebook_bot_activists_full_text_index() OWNER TO monkey_user;

--
-- Name: verify_custom_domain(); Type: FUNCTION; Schema: public; Owner: monkey_user
--

CREATE FUNCTION public.verify_custom_domain() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      CASE TG_OP
      WHEN 'INSERT' THEN
        IF NEW.custom_domain is not null then
          perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
              'action', 'verify_custom_domain',
              'id', NEW.id,
              'custom_domain', NEW.custom_domain,
              'pg_action', 'insert_custom_domain',
              'sent_to_queuing', now(),
              'jit', now()::timestamp
          ), public.configuration('jwt_secret'), 'HS512'));
        END IF;
        RETURN NEW;

      WHEN 'UPDATE' THEN
        IF NEW.custom_domain is not null then
          perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
              'action', 'verify_custom_domain',
              'id', NEW.id,
              'custom_domain', NEW.custom_domain,
              'pg_action', 'update_custom_domain',
              'sent_to_queuing', now(),
              'jit', now()::timestamp
          ), public.configuration('jwt_secret'), 'HS512'));
        END IF;
        RETURN NEW;

     WHEN 'DELETE' THEN
      perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
          'action', 'verify_custom_domain',
          'id', OLD.id,
          'custom_domain', OLD.custom_domain,
          'pg_action', 'delete_custom_domain',
          'sent_to_queuing', now(),
          'jit', now()::timestamp
      ), public.configuration('jwt_secret'), 'HS512'));
      RETURN OLD;

     ELSE
        raise  'custom_domain_not_processed';
      END CASE;
        END;
      $$;


ALTER FUNCTION public.verify_custom_domain() OWNER TO monkey_user;

--
-- Name: event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.event_invocation_logs (
    id text DEFAULT public.gen_random_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.event_invocation_logs OWNER TO monkey_user;

--
-- Name: event_log; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.event_log (
    id text DEFAULT public.gen_random_uuid() NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    trigger_name text NOT NULL,
    payload jsonb NOT NULL,
    delivered boolean DEFAULT false NOT NULL,
    error boolean DEFAULT false NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    locked boolean DEFAULT false NOT NULL,
    next_retry_at timestamp without time zone
);


ALTER TABLE hdb_catalog.event_log OWNER TO monkey_user;

--
-- Name: event_triggers; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.event_triggers (
    name text NOT NULL,
    type text NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    configuration json,
    comment text
);


ALTER TABLE hdb_catalog.event_triggers OWNER TO monkey_user;

--
-- Name: hdb_allowlist; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_allowlist (
    collection_name text
);


ALTER TABLE hdb_catalog.hdb_allowlist OWNER TO monkey_user;

--
-- Name: hdb_check_constraint; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_check_constraint AS
 SELECT (n.nspname)::text AS table_schema,
    (ct.relname)::text AS table_name,
    (r.conname)::text AS constraint_name,
    pg_get_constraintdef(r.oid, true) AS "check"
   FROM ((pg_constraint r
     JOIN pg_class ct ON ((r.conrelid = ct.oid)))
     JOIN pg_namespace n ON ((ct.relnamespace = n.oid)))
  WHERE (r.contype = 'c'::"char");


ALTER TABLE hdb_catalog.hdb_check_constraint OWNER TO monkey_user;

--
-- Name: hdb_foreign_key_constraint; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_foreign_key_constraint AS
 SELECT (q.table_schema)::text AS table_schema,
    (q.table_name)::text AS table_name,
    (q.constraint_name)::text AS constraint_name,
    (min(q.constraint_oid))::integer AS constraint_oid,
    min((q.ref_table_table_schema)::text) AS ref_table_table_schema,
    min((q.ref_table)::text) AS ref_table,
    json_object_agg(ac.attname, afc.attname) AS column_mapping,
    min((q.confupdtype)::text) AS on_update,
    min((q.confdeltype)::text) AS on_delete
   FROM ((( SELECT ctn.nspname AS table_schema,
            ct.relname AS table_name,
            r.conrelid AS table_id,
            r.conname AS constraint_name,
            r.oid AS constraint_oid,
            cftn.nspname AS ref_table_table_schema,
            cft.relname AS ref_table,
            r.confrelid AS ref_table_id,
            r.confupdtype,
            r.confdeltype,
            unnest(r.conkey) AS column_id,
            unnest(r.confkey) AS ref_column_id
           FROM ((((pg_constraint r
             JOIN pg_class ct ON ((r.conrelid = ct.oid)))
             JOIN pg_namespace ctn ON ((ct.relnamespace = ctn.oid)))
             JOIN pg_class cft ON ((r.confrelid = cft.oid)))
             JOIN pg_namespace cftn ON ((cft.relnamespace = cftn.oid)))
          WHERE (r.contype = 'f'::"char")) q
     JOIN pg_attribute ac ON (((q.column_id = ac.attnum) AND (q.table_id = ac.attrelid))))
     JOIN pg_attribute afc ON (((q.ref_column_id = afc.attnum) AND (q.ref_table_id = afc.attrelid))))
  GROUP BY q.table_schema, q.table_name, q.constraint_name;


ALTER TABLE hdb_catalog.hdb_foreign_key_constraint OWNER TO monkey_user;

--
-- Name: hdb_function; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_function (
    function_schema text NOT NULL,
    function_name text NOT NULL,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_function OWNER TO monkey_user;

--
-- Name: hdb_function_agg; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_function_agg AS
 SELECT (p.proname)::text AS function_name,
    (pn.nspname)::text AS function_schema,
        CASE
            WHEN (p.provariadic = (0)::oid) THEN false
            ELSE true
        END AS has_variadic,
        CASE
            WHEN ((p.provolatile)::text = ('i'::character(1))::text) THEN 'IMMUTABLE'::text
            WHEN ((p.provolatile)::text = ('s'::character(1))::text) THEN 'STABLE'::text
            WHEN ((p.provolatile)::text = ('v'::character(1))::text) THEN 'VOLATILE'::text
            ELSE NULL::text
        END AS function_type,
    pg_get_functiondef(p.oid) AS function_definition,
    (rtn.nspname)::text AS return_type_schema,
    (rt.typname)::text AS return_type_name,
        CASE
            WHEN ((rt.typtype)::text = ('b'::character(1))::text) THEN 'BASE'::text
            WHEN ((rt.typtype)::text = ('c'::character(1))::text) THEN 'COMPOSITE'::text
            WHEN ((rt.typtype)::text = ('d'::character(1))::text) THEN 'DOMAIN'::text
            WHEN ((rt.typtype)::text = ('e'::character(1))::text) THEN 'ENUM'::text
            WHEN ((rt.typtype)::text = ('r'::character(1))::text) THEN 'RANGE'::text
            WHEN ((rt.typtype)::text = ('p'::character(1))::text) THEN 'PSUEDO'::text
            ELSE NULL::text
        END AS return_type_type,
    p.proretset AS returns_set,
    ( SELECT COALESCE(json_agg(q.type_name), '[]'::json) AS "coalesce"
           FROM ( SELECT pt.typname AS type_name,
                    pat.ordinality
                   FROM (unnest(COALESCE(p.proallargtypes, (p.proargtypes)::oid[])) WITH ORDINALITY pat(oid, ordinality)
                     LEFT JOIN pg_type pt ON ((pt.oid = pat.oid)))
                  ORDER BY pat.ordinality) q) AS input_arg_types,
    to_json(COALESCE(p.proargnames, ARRAY[]::text[])) AS input_arg_names
   FROM (((pg_proc p
     JOIN pg_namespace pn ON ((pn.oid = p.pronamespace)))
     JOIN pg_type rt ON ((rt.oid = p.prorettype)))
     JOIN pg_namespace rtn ON ((rtn.oid = rt.typnamespace)))
  WHERE (((pn.nspname)::text !~~ 'pg_%'::text) AND ((pn.nspname)::text <> ALL (ARRAY['information_schema'::text, 'hdb_catalog'::text, 'hdb_views'::text])) AND (NOT (EXISTS ( SELECT 1
           FROM pg_aggregate
          WHERE ((pg_aggregate.aggfnoid)::oid = p.oid)))));


ALTER TABLE hdb_catalog.hdb_function_agg OWNER TO monkey_user;

--
-- Name: hdb_function_info_agg; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_function_info_agg AS
 SELECT hdb_function_agg.function_name,
    hdb_function_agg.function_schema,
    row_to_json(( SELECT e.*::record AS e
           FROM ( SELECT hdb_function_agg.has_variadic,
                    hdb_function_agg.function_type,
                    hdb_function_agg.return_type_schema,
                    hdb_function_agg.return_type_name,
                    hdb_function_agg.return_type_type,
                    hdb_function_agg.returns_set,
                    hdb_function_agg.input_arg_types,
                    hdb_function_agg.input_arg_names,
                    (EXISTS ( SELECT 1
                           FROM information_schema.tables
                          WHERE (((tables.table_schema)::text = hdb_function_agg.return_type_schema) AND ((tables.table_name)::text = hdb_function_agg.return_type_name)))) AS returns_table) e)) AS function_info
   FROM hdb_catalog.hdb_function_agg;


ALTER TABLE hdb_catalog.hdb_function_info_agg OWNER TO monkey_user;

--
-- Name: hdb_permission; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_permission (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    role_name text NOT NULL,
    perm_type text NOT NULL,
    perm_def jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false,
    CONSTRAINT hdb_permission_perm_type_check CHECK ((perm_type = ANY (ARRAY['insert'::text, 'select'::text, 'update'::text, 'delete'::text])))
);


ALTER TABLE hdb_catalog.hdb_permission OWNER TO monkey_user;

--
-- Name: hdb_permission_agg; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_permission_agg AS
 SELECT hdb_permission.table_schema,
    hdb_permission.table_name,
    hdb_permission.role_name,
    json_object_agg(hdb_permission.perm_type, hdb_permission.perm_def) AS permissions
   FROM hdb_catalog.hdb_permission
  GROUP BY hdb_permission.table_schema, hdb_permission.table_name, hdb_permission.role_name;


ALTER TABLE hdb_catalog.hdb_permission_agg OWNER TO monkey_user;

--
-- Name: hdb_primary_key; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_primary_key AS
 SELECT tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    json_agg(constraint_column_usage.column_name) AS columns
   FROM (information_schema.table_constraints tc
     JOIN ( SELECT x.tblschema AS table_schema,
            x.tblname AS table_name,
            x.colname AS column_name,
            x.cstrname AS constraint_name
           FROM ( SELECT DISTINCT nr.nspname,
                    r.relname,
                    a.attname,
                    c.conname
                   FROM pg_namespace nr,
                    pg_class r,
                    pg_attribute a,
                    pg_depend d,
                    pg_namespace nc,
                    pg_constraint c
                  WHERE ((nr.oid = r.relnamespace) AND (r.oid = a.attrelid) AND (d.refclassid = ('pg_class'::regclass)::oid) AND (d.refobjid = r.oid) AND (d.refobjsubid = a.attnum) AND (d.classid = ('pg_constraint'::regclass)::oid) AND (d.objid = c.oid) AND (c.connamespace = nc.oid) AND (c.contype = 'c'::"char") AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND (NOT a.attisdropped))
                UNION ALL
                 SELECT nr.nspname,
                    r.relname,
                    a.attname,
                    c.conname
                   FROM pg_namespace nr,
                    pg_class r,
                    pg_attribute a,
                    pg_namespace nc,
                    pg_constraint c
                  WHERE ((nr.oid = r.relnamespace) AND (r.oid = a.attrelid) AND (nc.oid = c.connamespace) AND (r.oid =
                        CASE c.contype
                            WHEN 'f'::"char" THEN c.confrelid
                            ELSE c.conrelid
                        END) AND (a.attnum = ANY (
                        CASE c.contype
                            WHEN 'f'::"char" THEN c.confkey
                            ELSE c.conkey
                        END)) AND (NOT a.attisdropped) AND (c.contype = ANY (ARRAY['p'::"char", 'u'::"char", 'f'::"char"])) AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])))) x(tblschema, tblname, colname, cstrname)) constraint_column_usage ON ((((tc.constraint_name)::text = (constraint_column_usage.constraint_name)::text) AND ((tc.table_schema)::text = (constraint_column_usage.table_schema)::text) AND ((tc.table_name)::text = (constraint_column_usage.table_name)::text))))
  WHERE ((tc.constraint_type)::text = 'PRIMARY KEY'::text)
  GROUP BY tc.table_schema, tc.table_name, tc.constraint_name;


ALTER TABLE hdb_catalog.hdb_primary_key OWNER TO monkey_user;

--
-- Name: hdb_query_collection; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_query_collection (
    collection_name text NOT NULL,
    collection_defn jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_query_collection OWNER TO monkey_user;

--
-- Name: hdb_query_template; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_query_template (
    template_name text NOT NULL,
    template_defn jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_query_template OWNER TO monkey_user;

--
-- Name: hdb_relationship; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_relationship (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    rel_name text NOT NULL,
    rel_type text,
    rel_def jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false,
    CONSTRAINT hdb_relationship_rel_type_check CHECK ((rel_type = ANY (ARRAY['object'::text, 'array'::text])))
);


ALTER TABLE hdb_catalog.hdb_relationship OWNER TO monkey_user;

--
-- Name: hdb_schema_update_event; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_schema_update_event (
    id bigint NOT NULL,
    instance_id uuid NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE hdb_catalog.hdb_schema_update_event OWNER TO monkey_user;

--
-- Name: hdb_schema_update_event_id_seq; Type: SEQUENCE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE SEQUENCE hdb_catalog.hdb_schema_update_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hdb_catalog.hdb_schema_update_event_id_seq OWNER TO monkey_user;

--
-- Name: hdb_schema_update_event_id_seq; Type: SEQUENCE OWNED BY; Schema: hdb_catalog; Owner: monkey_user
--

ALTER SEQUENCE hdb_catalog.hdb_schema_update_event_id_seq OWNED BY hdb_catalog.hdb_schema_update_event.id;


--
-- Name: hdb_table; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_table (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_catalog.hdb_table OWNER TO monkey_user;

--
-- Name: hdb_table_info_agg; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_table_info_agg AS
 SELECT tables.table_name,
    tables.table_schema,
    COALESCE(columns.columns, '[]'::json) AS columns,
    COALESCE(pk.columns, '[]'::json) AS primary_key_columns,
    COALESCE(constraints.constraints, '[]'::json) AS constraints,
    COALESCE(views.view_info, 'null'::json) AS view_info
   FROM ((((information_schema.tables tables
     LEFT JOIN ( SELECT c.table_name,
            c.table_schema,
            json_agg(json_build_object('name', c.column_name, 'type', c.udt_name, 'is_nullable', (c.is_nullable)::boolean)) AS columns
           FROM information_schema.columns c
          GROUP BY c.table_schema, c.table_name) columns ON ((((tables.table_schema)::text = (columns.table_schema)::text) AND ((tables.table_name)::text = (columns.table_name)::text))))
     LEFT JOIN ( SELECT hdb_primary_key.table_schema,
            hdb_primary_key.table_name,
            hdb_primary_key.constraint_name,
            hdb_primary_key.columns
           FROM hdb_catalog.hdb_primary_key) pk ON ((((tables.table_schema)::text = (pk.table_schema)::text) AND ((tables.table_name)::text = (pk.table_name)::text))))
     LEFT JOIN ( SELECT c.table_schema,
            c.table_name,
            json_agg(c.constraint_name) AS constraints
           FROM information_schema.table_constraints c
          WHERE (((c.constraint_type)::text = 'UNIQUE'::text) OR ((c.constraint_type)::text = 'PRIMARY KEY'::text))
          GROUP BY c.table_schema, c.table_name) constraints ON ((((tables.table_schema)::text = (constraints.table_schema)::text) AND ((tables.table_name)::text = (constraints.table_name)::text))))
     LEFT JOIN ( SELECT v.table_schema,
            v.table_name,
            json_build_object('is_updatable', ((v.is_updatable)::boolean OR (v.is_trigger_updatable)::boolean), 'is_deletable', ((v.is_updatable)::boolean OR (v.is_trigger_deletable)::boolean), 'is_insertable', ((v.is_insertable_into)::boolean OR (v.is_trigger_insertable_into)::boolean)) AS view_info
           FROM information_schema.views v) views ON ((((tables.table_schema)::text = (views.table_schema)::text) AND ((tables.table_name)::text = (views.table_name)::text))));


ALTER TABLE hdb_catalog.hdb_table_info_agg OWNER TO monkey_user;

--
-- Name: hdb_unique_constraint; Type: VIEW; Schema: hdb_catalog; Owner: monkey_user
--

CREATE VIEW hdb_catalog.hdb_unique_constraint AS
 SELECT tc.table_name,
    tc.constraint_schema AS table_schema,
    tc.constraint_name,
    json_agg(kcu.column_name) AS columns
   FROM (information_schema.table_constraints tc
     JOIN information_schema.key_column_usage kcu USING (constraint_schema, constraint_name))
  WHERE ((tc.constraint_type)::text = 'UNIQUE'::text)
  GROUP BY tc.table_name, tc.constraint_schema, tc.constraint_name;


ALTER TABLE hdb_catalog.hdb_unique_constraint OWNER TO monkey_user;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO monkey_user;

--
-- Name: remote_schemas; Type: TABLE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TABLE hdb_catalog.remote_schemas (
    id bigint NOT NULL,
    name text,
    definition json,
    comment text
);


ALTER TABLE hdb_catalog.remote_schemas OWNER TO monkey_user;

--
-- Name: remote_schemas_id_seq; Type: SEQUENCE; Schema: hdb_catalog; Owner: monkey_user
--

CREATE SEQUENCE hdb_catalog.remote_schemas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hdb_catalog.remote_schemas_id_seq OWNER TO monkey_user;

--
-- Name: remote_schemas_id_seq; Type: SEQUENCE OWNED BY; Schema: hdb_catalog; Owner: monkey_user
--

ALTER SEQUENCE hdb_catalog.remote_schemas_id_seq OWNED BY hdb_catalog.remote_schemas.id;


--
-- Name: certificates; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.certificates (
    id integer NOT NULL,
    community_id integer,
    mobilization_id integer,
    dns_hosted_zone_id integer,
    domain character varying,
    file_content text,
    expire_on timestamp without time zone,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.certificates OWNER TO monkey_user;

--
-- Name: certificates; Type: VIEW; Schema: microservices; Owner: monkey_user
--

CREATE VIEW microservices.certificates AS
 SELECT certificates.id,
    certificates.community_id,
    certificates.mobilization_id,
    certificates.dns_hosted_zone_id AS dns_hosted_zones_id,
    certificates.domain,
    certificates.file_content,
    certificates.expire_on,
    certificates.is_active,
    certificates.created_at,
    certificates.updated_at
   FROM public.certificates
  WHERE ((certificates.is_active IS TRUE) AND (microservices.current_user_id() IS NOT NULL));


ALTER TABLE microservices.certificates OWNER TO monkey_user;

--
-- Name: communities; Type: VIEW; Schema: microservices; Owner: monkey_user
--

CREATE VIEW microservices.communities AS
 SELECT DISTINCT c.id,
    c.name,
    c.city,
    c.created_at,
    c.updated_at,
    c.mailchimp_api_key,
    c.mailchimp_list_id,
    c.mailchimp_group_id,
    c.image,
    c.description,
    c.recipient_id,
    c.fb_link,
    c.twitter_link,
    c.facebook_app_id,
    c.subscription_retry_interval,
    c.subscription_dead_days_interval,
    c.email_template_from,
    c.mailchimp_sync_request_at
   FROM (public.communities c
     RIGHT JOIN public.mobilizations m ON ((c.id = m.community_id)))
  WHERE ((m.custom_domain IS NOT NULL) AND (microservices.current_user_id() IS NOT NULL));


ALTER TABLE microservices.communities OWNER TO monkey_user;

--
-- Name: dns_hosted_zones; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.dns_hosted_zones (
    id integer NOT NULL,
    community_id integer,
    domain_name character varying,
    comment text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    response jsonb,
    ns_ok boolean
);


ALTER TABLE public.dns_hosted_zones OWNER TO monkey_user;

--
-- Name: dns_hosted_zones; Type: VIEW; Schema: microservices; Owner: monkey_user
--

CREATE VIEW microservices.dns_hosted_zones AS
 SELECT dns_hosted_zones.id,
    dns_hosted_zones.community_id,
    dns_hosted_zones.domain_name,
    dns_hosted_zones.comment,
    dns_hosted_zones.created_at,
    dns_hosted_zones.updated_at,
    dns_hosted_zones.response,
    dns_hosted_zones.ns_ok
   FROM public.dns_hosted_zones
  WHERE ((dns_hosted_zones.ns_ok IS TRUE) AND (microservices.current_user_id() IS NOT NULL));


ALTER TABLE microservices.dns_hosted_zones OWNER TO monkey_user;

--
-- Name: mobilizations; Type: VIEW; Schema: microservices; Owner: monkey_user
--

CREATE VIEW microservices.mobilizations AS
 SELECT mobilizations.id,
    mobilizations.name,
    mobilizations.created_at,
    mobilizations.updated_at,
    mobilizations.user_id,
    mobilizations.color_scheme,
    mobilizations.google_analytics_code,
    mobilizations.goal,
    mobilizations.facebook_share_title,
    mobilizations.facebook_share_description,
    mobilizations.header_font,
    mobilizations.body_font,
    mobilizations.facebook_share_image,
    mobilizations.slug,
    mobilizations.custom_domain,
    mobilizations.twitter_share_text,
    mobilizations.community_id,
    mobilizations.favicon,
    mobilizations.deleted_at,
    mobilizations.status
   FROM public.mobilizations
  WHERE ((mobilizations.custom_domain IS NOT NULL) AND (microservices.current_user_id() IS NOT NULL));


ALTER TABLE microservices.mobilizations OWNER TO monkey_user;

--
-- Name: notification_templates; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.notification_templates (
    id integer NOT NULL,
    label text NOT NULL,
    community_id integer,
    subject_template text NOT NULL,
    body_template text NOT NULL,
    template_vars jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale text DEFAULT 'pt-BR'::text NOT NULL,
    CONSTRAINT localechk CHECK ((locale = ANY (public.locale_names())))
);


ALTER TABLE public.notification_templates OWNER TO monkey_user;

--
-- Name: notification_templates; Type: VIEW; Schema: microservices; Owner: monkey_user
--

CREATE VIEW microservices.notification_templates AS
 SELECT notification_templates.id,
    notification_templates.label,
    notification_templates.community_id,
    notification_templates.subject_template,
    notification_templates.body_template,
    notification_templates.template_vars,
    notification_templates.created_at,
    notification_templates.updated_at,
    notification_templates.locale
   FROM public.notification_templates
  ORDER BY notification_templates.created_at DESC;


ALTER TABLE microservices.notification_templates OWNER TO monkey_user;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    activist_id integer,
    notification_template_id integer NOT NULL,
    template_vars jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    email character varying,
    community_id integer,
    deliver_at timestamp without time zone,
    delivered_at timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO monkey_user;

--
-- Name: notifications; Type: VIEW; Schema: microservices; Owner: monkey_user
--

CREATE VIEW microservices.notifications AS
 SELECT notifications.id,
    notifications.activist_id,
    notifications.notification_template_id,
    notifications.template_vars,
    notifications.created_at,
    notifications.updated_at,
    notifications.user_id,
    notifications.email,
    notifications.community_id,
    notifications.deliver_at,
    notifications.delivered_at
   FROM public.notifications
  ORDER BY notifications.created_at DESC;


ALTER TABLE microservices.notifications OWNER TO monkey_user;

--
-- Name: activist_facebook_bot_interactions; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.activist_facebook_bot_interactions (
    id integer NOT NULL,
    activist_id integer,
    facebook_bot_configuration_id integer NOT NULL,
    fb_context_recipient_id text NOT NULL,
    fb_context_sender_id text NOT NULL,
    interaction jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.activist_facebook_bot_interactions OWNER TO monkey_user;

--
-- Name: facebook_bot_configurations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.facebook_bot_configurations (
    id integer NOT NULL,
    community_id integer,
    messenger_app_secret text NOT NULL,
    messenger_validation_token text NOT NULL,
    messenger_page_access_token text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_configurations OWNER TO monkey_user;

--
-- Name: activist_facebook_bot_interactions; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.activist_facebook_bot_interactions AS
 SELECT i.id,
    i.activist_id,
    i.facebook_bot_configuration_id,
    i.fb_context_recipient_id,
    i.fb_context_sender_id,
    i.interaction,
    i.created_at,
    i.updated_at,
    c.community_id,
    c.data AS facebook_bot_configuration
   FROM (public.activist_facebook_bot_interactions i
     JOIN public.facebook_bot_configurations c ON ((i.facebook_bot_configuration_id = c.id)))
  WHERE postgraphql.current_user_has_community_participation(c.community_id);


ALTER TABLE postgraphql.activist_facebook_bot_interactions OWNER TO monkey_user;

--
-- Name: mobilization_activists; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.mobilization_activists (
    id integer NOT NULL,
    mobilization_id integer NOT NULL,
    activist_id integer NOT NULL,
    search_index tsvector,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.mobilization_activists OWNER TO monkey_user;

--
-- Name: activist_mobilizations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.activist_mobilizations AS
 SELECT ma.activist_id,
    m.id,
    m.name,
    m.created_at,
    m.updated_at,
    m.user_id,
    m.color_scheme,
    m.google_analytics_code,
    m.goal,
    m.facebook_share_title,
    m.facebook_share_description,
    m.header_font,
    m.body_font,
    m.facebook_share_image,
    m.slug,
    m.custom_domain,
    m.twitter_share_text,
    m.community_id,
    m.favicon
   FROM (public.mobilization_activists ma
     JOIN public.mobilizations m ON ((m.id = ma.mobilization_id)))
  WHERE postgraphql.current_user_has_community_participation(m.community_id);


ALTER TABLE postgraphql.activist_mobilizations OWNER TO monkey_user;

--
-- Name: VIEW activist_mobilizations; Type: COMMENT; Schema: postgraphql; Owner: monkey_user
--

COMMENT ON VIEW postgraphql.activist_mobilizations IS 'show the mobilizations that activists participate';


--
-- Name: activist_tags; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.activist_tags AS
 SELECT at.community_id,
    at.activist_id,
    tag.name AS tag_complete_name,
    (regexp_split_to_array((tag.name)::text, '_'::text))[1] AS tag_from,
    replace((regexp_split_to_array((tag.name)::text, '_'::text))[2], '-'::text, ' '::text) AS tag_name,
    tag.label AS tag_label
   FROM ((public.activist_tags at
     JOIN public.taggings tgs ON ((((tgs.taggable_type)::text = 'ActivistTag'::text) AND (tgs.taggable_id = at.id))))
     JOIN public.tags tag ON ((tag.id = tgs.tag_id)))
  WHERE postgraphql.current_user_has_community_participation(at.community_id);


ALTER TABLE postgraphql.activist_tags OWNER TO monkey_user;

--
-- Name: balance_operations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.balance_operations (
    id integer NOT NULL,
    recipient_id integer NOT NULL,
    gateway_data jsonb NOT NULL,
    gateway_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.balance_operations OWNER TO monkey_user;

--
-- Name: recipients; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.recipients (
    id integer NOT NULL,
    pagarme_recipient_id character varying NOT NULL,
    recipient jsonb NOT NULL,
    community_id integer NOT NULL,
    transfer_day integer,
    transfer_enabled boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.recipients OWNER TO monkey_user;

--
-- Name: balance_operation_summaries; Type: VIEW; Schema: public; Owner: monkey_user
--

CREATE VIEW public.balance_operation_summaries AS
 SELECT bo.id,
    bo.recipient_id,
    r.community_id,
    (bo.gateway_data ->> 'type'::text) AS operation_type,
    (bo.gateway_data ->> 'object'::text) AS operation_object,
    (bo.gateway_data ->> 'status'::text) AS operation_status,
    (((bo.gateway_data ->> 'amount'::text))::numeric / 100.0) AS operation_amount,
    (((bo.gateway_data ->> 'balance_amount'::text))::numeric / 100.0) AS balance_amount_at_moment,
    (((bo.gateway_data ->> 'fee'::text))::numeric / 100.0) AS operation_fee,
    ((bo.gateway_data ->> 'date_created'::text))::timestamp without time zone AS operation_created_at,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'id'::text) AS movement_object_id,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'type'::text) AS movement_object_type,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'status'::text) AS movement_object_status,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'object'::text) AS movement_object_object,
    ((((bo.gateway_data -> 'movement_object'::text) ->> 'amount'::text))::numeric / 100.0) AS movement_object_amount,
    ((((bo.gateway_data -> 'movement_object'::text) ->> 'fee'::text))::numeric / 100.0) AS movement_object_fee,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'transaction_id'::text) AS movement_object_transaction_id,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'payment_method'::text) AS movement_object_payment_method,
    (bo.gateway_data -> 'movement_object'::text) AS movement_object
   FROM (public.balance_operations bo
     JOIN public.recipients r ON ((r.id = bo.recipient_id)))
  ORDER BY ((bo.gateway_data ->> 'date_created'::text))::timestamp without time zone DESC;


ALTER TABLE public.balance_operation_summaries OWNER TO monkey_user;

--
-- Name: balance_operations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.balance_operations AS
 SELECT bos.id,
    bos.recipient_id,
    bos.community_id,
    bos.operation_type,
    bos.operation_object,
    bos.operation_status,
    bos.operation_amount,
    bos.balance_amount_at_moment,
    bos.operation_fee,
    bos.operation_created_at,
    bos.movement_object_id,
    bos.movement_object_type,
    bos.movement_object_status,
    bos.movement_object_object,
    bos.movement_object_amount,
    bos.movement_object_fee,
    bos.movement_object_transaction_id,
    bos.movement_object_payment_method,
    bos.movement_object
   FROM public.balance_operation_summaries bos
  WHERE postgraphql.current_user_has_community_participation(bos.community_id);


ALTER TABLE postgraphql.balance_operations OWNER TO monkey_user;

--
-- Name: facebook_activist_interactions; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.facebook_activist_interactions AS
 SELECT activist_facebook_bot_interactions.id,
    activist_facebook_bot_interactions.activist_id,
    activist_facebook_bot_interactions.facebook_bot_configuration_id,
    activist_facebook_bot_interactions.fb_context_recipient_id,
    activist_facebook_bot_interactions.fb_context_sender_id,
    activist_facebook_bot_interactions.interaction,
    activist_facebook_bot_interactions.created_at,
    activist_facebook_bot_interactions.updated_at
   FROM public.activist_facebook_bot_interactions
  WHERE ((activist_facebook_bot_interactions.interaction -> 'is_bot'::text) IS NULL);


ALTER TABLE postgraphql.facebook_activist_interactions OWNER TO monkey_user;

--
-- Name: bot_recipients; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.bot_recipients AS
 SELECT i.facebook_bot_configuration_id,
    i.fb_context_recipient_id,
    i.fb_context_sender_id,
    i.interaction,
    c.community_id,
    c.data AS facebook_bot_configuration,
    i.created_at
   FROM ((postgraphql.facebook_activist_interactions i
     LEFT JOIN postgraphql.facebook_activist_interactions aux ON (((i.facebook_bot_configuration_id = aux.facebook_bot_configuration_id) AND (i.fb_context_recipient_id = aux.fb_context_recipient_id) AND (i.fb_context_sender_id = aux.fb_context_sender_id) AND (i.id < aux.id))))
     LEFT JOIN public.facebook_bot_configurations c ON ((i.facebook_bot_configuration_id = c.id)))
  WHERE ((aux.id IS NULL) AND postgraphql.current_user_has_community_participation(c.community_id));


ALTER TABLE postgraphql.bot_recipients OWNER TO monkey_user;

--
-- Name: community_user_roles; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.community_user_roles AS
 SELECT cu.id,
    cu.user_id,
    cu.community_id,
    cu.role,
    cu.created_at,
    cu.updated_at
   FROM public.community_users cu
  WHERE (cu.user_id = postgraphql.current_user_id());


ALTER TABLE postgraphql.community_user_roles OWNER TO monkey_user;

--
-- Name: blocks; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.blocks (
    id integer NOT NULL,
    mobilization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bg_class character varying,
    "position" integer,
    hidden boolean,
    bg_image text,
    name character varying,
    menu_hidden boolean,
    deleted_at timestamp without time zone
);


ALTER TABLE public.blocks OWNER TO monkey_user;

--
-- Name: payable_transfers; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.payable_transfers (
    id integer NOT NULL,
    transfer_id integer,
    transfer_data jsonb,
    transfer_status text,
    community_id integer NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.payable_transfers OWNER TO monkey_user;

--
-- Name: widgets; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.widgets (
    id integer NOT NULL,
    block_id integer,
    settings public.hstore,
    kind character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sm_size integer,
    md_size integer,
    lg_size integer,
    mailchimp_segment_id character varying,
    action_community boolean DEFAULT false,
    exported_at timestamp without time zone,
    mailchimp_unique_segment_id character varying,
    mailchimp_recurring_active_segment_id character varying,
    mailchimp_recurring_inactive_segment_id character varying,
    goal numeric(8,2),
    deleted_at timestamp without time zone
);


ALTER TABLE public.widgets OWNER TO monkey_user;

--
-- Name: payable_details; Type: VIEW; Schema: public; Owner: monkey_user
--

CREATE VIEW public.payable_details AS
 SELECT o.id AS community_id,
    d.widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.id AS donation_id,
    d.subscription_id,
    d.transaction_id,
    (dd.value ->> 'id'::text) AS payable_id,
    (((d.amount)::numeric / 100.0))::double precision AS donation_value,
    (((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS payable_value,
    (payable_summary.payable_fee)::double precision AS payable_pagarme_fee,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN nossas_tx.amount
            ELSE ((((d.amount)::numeric / 100.0) * 0.13))::double precision
        END AS nossas_fee,
    nossas_tx.percent AS percent_tx,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) - (payable_summary.payable_fee)::double precision)
            ELSE ((((d.amount)::numeric / 100.0))::double precision - ((((d.amount)::numeric / 100.0) * 0.13))::double precision)
        END AS value_without_fee,
    ((dd.value ->> 'date_created'::text))::timestamp without time zone AS payment_date,
    ((dd.value ->> 'payment_date'::text))::timestamp without time zone AS payable_date,
    d.transaction_status AS pagarme_status,
    (dd.value ->> 'status'::text) AS payable_status,
    d.payment_method,
    customer.name,
    customer.email,
    pt.id AS payable_transfer_id,
    pt.transfer_data,
    d.gateway_data,
    d.subscription AS is_subscription,
    (dd.value ->> 'recipient_id'::text) AS recipient_id,
    d.local_subscription_id
   FROM (((((((((public.communities o
     JOIN public.donations d ON (((d.cached_community_id = o.id) AND ((d.transaction_status)::text = 'paid'::text))))
     LEFT JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.payable_transfers pt ON ((pt.id = d.payable_transfer_id)))
     LEFT JOIN LATERAL ( SELECT COALESCE((d2.customer OPERATOR(public.->) 'name'::text), (d.customer OPERATOR(public.->) 'name'::text)) AS name,
            COALESCE((d2.customer OPERATOR(public.->) 'email'::text), (d.customer OPERATOR(public.->) 'email'::text)) AS email
           FROM public.donations d2
          WHERE
                CASE
                    WHEN (d.parent_id IS NULL) THEN (d2.id = d.id)
                    ELSE (d2.id = d.parent_id)
                END) customer ON (true))
     LEFT JOIN LATERAL ( SELECT data.value
           FROM jsonb_array_elements(d.payables) data(value)) dd ON (true))
     LEFT JOIN LATERAL ( SELECT (((jsonb_array_elements.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS amount,
            ((((jsonb_array_elements.value ->> 'amount'::text))::double precision / (d.amount)::double precision) * (100.0)::double precision) AS percent
           FROM jsonb_array_elements(d.payables) jsonb_array_elements(value)
          WHERE ((jsonb_array_elements.value ->> 'recipient_id'::text) = public.nossas_recipient_id())) nossas_tx ON (true))
     LEFT JOIN LATERAL ( SELECT td.amount,
            td.payable_fee,
            td.transaction_cost,
            (td.amount - td.payable_fee) AS value_without_fee
           FROM ( SELECT ((((dd.value ->> 'amount'::text))::integer)::numeric / 100.0) AS amount,
                    ((((dd.value ->> 'fee'::text))::integer)::numeric / 100.0) AS payable_fee,
                    ((((d.gateway_data ->> 'cost'::text))::integer)::numeric / 100.0) AS transaction_cost) td) payable_summary ON (true))
  WHERE ((((dd.value ->> 'type'::text) = 'credit'::text) AND ((dd.value ->> 'object'::text) = 'payable'::text) AND ((dd.value ->> 'recipient_id'::text) IN ( SELECT (r.pagarme_recipient_id)::text AS pagarme_recipient_id
           FROM public.recipients r
          WHERE (r.community_id = o.id)))) OR (jsonb_array_length(d.payables) = 1));


ALTER TABLE public.payable_details OWNER TO monkey_user;

--
-- Name: donations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.donations AS
 SELECT d.id AS donation_id,
    COALESCE(c.id, d.cached_community_id) AS community_id,
    w.id AS widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.activist_id,
    d.email AS donation_email,
    (d.amount / 100) AS donation_amount,
    d.local_subscription_id AS subscription_id,
    d.transaction_status,
    COALESCE(((d.gateway_data ->> 'date_created'::text))::timestamp without time zone, d.created_at) AS payment_date,
    pd.payable_date,
    pd.payable_value AS payable_amount,
    pd.payable_status,
    s.status AS subscription_status
   FROM ((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.communities c ON (((c.id = m.community_id) OR (c.id = d.cached_community_id))))
     LEFT JOIN public.subscriptions s ON ((s.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
  WHERE ((d.transaction_id IS NOT NULL) AND (c.id IN ( SELECT community_user_roles.community_id
           FROM postgraphql.community_user_roles)));


ALTER TABLE postgraphql.donations OWNER TO monkey_user;

--
-- Name: facebook_bot_configurations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.facebook_bot_configurations AS
 SELECT facebook_bot_configurations.id,
    facebook_bot_configurations.community_id,
    facebook_bot_configurations.messenger_app_secret,
    facebook_bot_configurations.messenger_validation_token,
    facebook_bot_configurations.messenger_page_access_token,
    facebook_bot_configurations.data,
    facebook_bot_configurations.created_at,
    facebook_bot_configurations.updated_at
   FROM public.facebook_bot_configurations
  WHERE ((facebook_bot_configurations.data ->> 'deleted'::text) IS NULL);


ALTER TABLE postgraphql.facebook_bot_configurations OWNER TO monkey_user;

--
-- Name: facebook_bot_interactions; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.facebook_bot_interactions AS
 SELECT activist_facebook_bot_interactions.id,
    activist_facebook_bot_interactions.activist_id,
    activist_facebook_bot_interactions.facebook_bot_configuration_id,
    activist_facebook_bot_interactions.fb_context_recipient_id,
    activist_facebook_bot_interactions.fb_context_sender_id,
    activist_facebook_bot_interactions.interaction,
    activist_facebook_bot_interactions.created_at,
    activist_facebook_bot_interactions.updated_at
   FROM public.activist_facebook_bot_interactions
  WHERE ((activist_facebook_bot_interactions.interaction -> 'is_bot'::text) = 'true'::jsonb);


ALTER TABLE postgraphql.facebook_bot_interactions OWNER TO monkey_user;

--
-- Name: activist_participations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.activist_participations (
    community_id integer,
    mobilization_id integer,
    widget_id integer,
    activist_id integer,
    email character varying,
    participate_at timestamp without time zone,
    participate_kind text,
    participate_id integer
);

ALTER TABLE ONLY public.activist_participations REPLICA IDENTITY NOTHING;


ALTER TABLE public.activist_participations OWNER TO monkey_user;

--
-- Name: participations; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.participations AS
 SELECT ap.community_id,
    ap.mobilization_id,
    ap.widget_id,
    ap.activist_id,
    ap.email,
    ap.participate_at,
    ap.participate_kind,
    ap.participate_id
   FROM public.activist_participations ap
  WHERE (ap.community_id IN ( SELECT community_user_roles.community_id
           FROM postgraphql.community_user_roles));


ALTER TABLE postgraphql.participations OWNER TO monkey_user;

--
-- Name: tags; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.tags AS
 SELECT t.id,
    t.name,
    t.taggings_count,
    t.label,
    (regexp_split_to_array((t.name)::text, '_'::text))[1] AS tag_type
   FROM public.tags t;


ALTER TABLE postgraphql.tags OWNER TO monkey_user;

--
-- Name: user_communities; Type: VIEW; Schema: postgraphql; Owner: monkey_user
--

CREATE VIEW postgraphql.user_communities AS
 SELECT com.id,
    com.name,
    com.city,
    com.description,
    com.created_at,
    com.updated_at,
    com.mailchimp_api_key,
    com.mailchimp_list_id,
    com.mailchimp_group_id,
    com.image,
    com.recipient_id,
    com.facebook_app_id,
    com.fb_link,
    com.twitter_link,
    com.subscription_retry_interval,
    com.subscription_dead_days_interval,
    com.email_template_from,
    com.mailchimp_sync_request_at
   FROM (public.communities com
     JOIN public.community_users cou ON ((cou.community_id = com.id)))
  WHERE (cou.user_id = postgraphql.current_user_id());


ALTER TABLE postgraphql.user_communities OWNER TO monkey_user;

--
-- Name: activist_pressures; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.activist_pressures (
    id integer NOT NULL,
    activist_id integer,
    widget_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    cached_community_id integer
);


ALTER TABLE public.activist_pressures OWNER TO monkey_user;

--
-- Name: form_entries; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.form_entries (
    id integer NOT NULL,
    widget_id integer,
    fields text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    synchronized boolean,
    activist_id integer,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    cached_community_id integer
);


ALTER TABLE public.form_entries OWNER TO monkey_user;

--
-- Name: activist_actions; Type: VIEW; Schema: public; Owner: monkey_user
--

CREATE VIEW public.activist_actions AS
 SELECT t.action,
    t.widget_id,
    t.mobilization_id,
    t.community_id,
    t.activist_id,
    t.action_created_date,
    t.activist_created_at,
    t.activist_email
   FROM ( SELECT 'form_entries'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            fe.activist_id,
            fe.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.form_entries fe
             JOIN public.activists a ON ((a.id = fe.activist_id)))
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'activist_pressures'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            ap.activist_id,
            ap.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.activist_pressures ap
             JOIN public.activists a ON ((a.id = ap.activist_id)))
             JOIN public.widgets w ON ((w.id = ap.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'donation'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            d.activist_id,
            d.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.donations d
             JOIN public.activists a ON ((a.id = d.activist_id)))
             JOIN public.widgets w ON ((w.id = d.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))) t;


ALTER TABLE public.activist_actions OWNER TO monkey_user;

--
-- Name: activist_facebook_bot_interactions_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.activist_facebook_bot_interactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_facebook_bot_interactions_id_seq OWNER TO monkey_user;

--
-- Name: activist_facebook_bot_interactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.activist_facebook_bot_interactions_id_seq OWNED BY public.activist_facebook_bot_interactions.id;


--
-- Name: activist_matches; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.activist_matches (
    id integer NOT NULL,
    activist_id integer,
    match_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text
);


ALTER TABLE public.activist_matches OWNER TO monkey_user;

--
-- Name: activist_matches_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.activist_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_matches_id_seq OWNER TO monkey_user;

--
-- Name: activist_matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.activist_matches_id_seq OWNED BY public.activist_matches.id;


--
-- Name: activist_pressures_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.activist_pressures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_pressures_id_seq OWNER TO monkey_user;

--
-- Name: activist_pressures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.activist_pressures_id_seq OWNED BY public.activist_pressures.id;


--
-- Name: activist_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.activist_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_tags_id_seq OWNER TO monkey_user;

--
-- Name: activist_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.activist_tags_id_seq OWNED BY public.activist_tags.id;


--
-- Name: activists_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activists_id_seq OWNER TO monkey_user;

--
-- Name: activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.activists_id_seq OWNED BY public.activists.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    zipcode character varying,
    street character varying,
    street_number character varying,
    complementary character varying,
    neighborhood character varying,
    city character varying,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    activist_id integer
);


ALTER TABLE public.addresses OWNER TO monkey_user;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO monkey_user;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: agg_activists; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.agg_activists (
    community_id integer,
    activist_id integer,
    email character varying,
    name character varying,
    phone text,
    total_form_entries bigint,
    total_donations bigint,
    total_pressures bigint,
    total_actions bigint,
    last_donation_status character varying,
    last_donation_amount integer,
    last_donation_is_subscription boolean,
    address_street text,
    street_number text,
    neighborhood text,
    complementary text,
    city text,
    state text
);

ALTER TABLE ONLY public.agg_activists REPLICA IDENTITY NOTHING;


ALTER TABLE public.agg_activists OWNER TO monkey_user;

--
-- Name: balance_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.balance_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.balance_operations_id_seq OWNER TO monkey_user;

--
-- Name: balance_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.balance_operations_id_seq OWNED BY public.balance_operations.id;


--
-- Name: blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blocks_id_seq OWNER TO monkey_user;

--
-- Name: blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.blocks_id_seq OWNED BY public.blocks.id;


--
-- Name: certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.certificates_id_seq OWNER TO monkey_user;

--
-- Name: certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.certificates_id_seq OWNED BY public.certificates.id;


--
-- Name: communities_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.communities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communities_id_seq OWNER TO monkey_user;

--
-- Name: communities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.communities_id_seq OWNED BY public.communities.id;


--
-- Name: community_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.community_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.community_activists_id_seq OWNER TO monkey_user;

--
-- Name: community_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.community_activists_id_seq OWNED BY public.community_activists.id;


--
-- Name: community_users_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.community_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.community_users_id_seq OWNER TO monkey_user;

--
-- Name: community_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.community_users_id_seq OWNED BY public.community_users.id;


--
-- Name: configurations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.configurations (
    id integer NOT NULL,
    name character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.configurations OWNER TO monkey_user;

--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.configurations_id_seq OWNER TO monkey_user;

--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: credit_cards; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.credit_cards (
    id integer NOT NULL,
    activist_id integer,
    last_digits character varying,
    card_brand character varying,
    card_id character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    expiration_date character varying
);


ALTER TABLE public.credit_cards OWNER TO monkey_user;

--
-- Name: credit_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.credit_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.credit_cards_id_seq OWNER TO monkey_user;

--
-- Name: credit_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.credit_cards_id_seq OWNED BY public.credit_cards.id;


--
-- Name: dns_hosted_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.dns_hosted_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dns_hosted_zones_id_seq OWNER TO monkey_user;

--
-- Name: dns_hosted_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.dns_hosted_zones_id_seq OWNED BY public.dns_hosted_zones.id;


--
-- Name: dns_records; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.dns_records (
    id integer NOT NULL,
    dns_hosted_zone_id integer,
    name character varying,
    record_type character varying,
    value text,
    ttl integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment character varying
);


ALTER TABLE public.dns_records OWNER TO monkey_user;

--
-- Name: dns_records_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.dns_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dns_records_id_seq OWNER TO monkey_user;

--
-- Name: dns_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.dns_records_id_seq OWNED BY public.dns_records.id;


--
-- Name: donation_reports; Type: VIEW; Schema: public; Owner: monkey_user
--

CREATE VIEW public.donation_reports AS
 SELECT m.id AS mobilization_id,
    w.id AS widget_id,
    c.id AS community_id,
    d.id,
    d.transaction_id,
    d.transaction_status AS status,
    to_char(d.created_at, 'dd/mm/YYYY'::text) AS data,
    COALESCE((d.customer OPERATOR(public.->) 'name'::text), (a.name)::text) AS nome,
    d.email,
    COALESCE(customer_phone.number, activist_phone.number) AS telefone,
    d.payment_method AS "cartao/boleto",
        CASE
            WHEN (d.subscription OR (d.local_subscription_id IS NOT NULL)) THEN 'Sim'::text
            ELSE 'Não'::text
        END AS recorrente,
    (((d.amount)::numeric / 100.0))::double precision AS valor,
    pd.value_without_fee AS "valor garantido",
    to_char(((d.gateway_data ->> 'boleto_expiration_date'::text))::timestamp without time zone, 'dd/mm/YYYY'::text) AS "data vencimento boleto",
    recurrency_donation.count AS "recorrencia da doacao",
    recurrency_activist.count AS "recorrencia do ativista",
    (gs.status)::text AS subscription_status,
    pd.payable_date AS "data de recebimento"
   FROM (((((((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     JOIN public.blocks b ON ((b.id = w.block_id)))
     JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     JOIN public.communities c ON ((c.id = m.community_id)))
     LEFT JOIN public.subscriptions gs ON ((gs.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
     LEFT JOIN public.activists a ON ((a.id = d.activist_id)))
     LEFT JOIN LATERAL ( SELECT (((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) customer_phone ON (true))
     LEFT JOIN LATERAL ( SELECT (((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) activist_phone ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.local_subscription_id IS NOT NULL) AND (d2.local_subscription_id = d.local_subscription_id))) recurrency_donation ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.activist_id = d.activist_id) AND (d2.cached_community_id = d.cached_community_id) AND (d.activist_id IS NOT NULL))) recurrency_activist ON (true))
  WHERE (d.transaction_id IS NOT NULL);


ALTER TABLE public.donation_reports OWNER TO monkey_user;

--
-- Name: donation_transitions; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.donation_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    sort_key integer NOT NULL,
    donation_id integer NOT NULL,
    most_recent boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.donation_transitions OWNER TO monkey_user;

--
-- Name: donation_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.donation_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donation_transitions_id_seq OWNER TO monkey_user;

--
-- Name: donation_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.donation_transitions_id_seq OWNED BY public.donation_transitions.id;


--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donations_id_seq OWNER TO monkey_user;

--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.donations_id_seq OWNED BY public.donations.id;


--
-- Name: facebook_bot_activists; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.facebook_bot_activists (
    id integer NOT NULL,
    fb_context_recipient_id text NOT NULL,
    fb_context_sender_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    messages tsvector,
    quick_replies text[] DEFAULT '{}'::text[],
    interaction_dates timestamp without time zone[] DEFAULT '{}'::timestamp without time zone[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_activists OWNER TO monkey_user;

--
-- Name: facebook_bot_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.facebook_bot_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_activists_id_seq OWNER TO monkey_user;

--
-- Name: facebook_bot_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.facebook_bot_activists_id_seq OWNED BY public.facebook_bot_activists.id;


--
-- Name: facebook_bot_campaign_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.facebook_bot_campaign_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_campaign_activists_id_seq OWNER TO monkey_user;

--
-- Name: facebook_bot_campaign_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.facebook_bot_campaign_activists_id_seq OWNED BY public.facebook_bot_campaign_activists.id;


--
-- Name: facebook_bot_campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.facebook_bot_campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_campaigns_id_seq OWNER TO monkey_user;

--
-- Name: facebook_bot_campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.facebook_bot_campaigns_id_seq OWNED BY public.facebook_bot_campaigns.id;


--
-- Name: facebook_bot_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.facebook_bot_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_configurations_id_seq OWNER TO monkey_user;

--
-- Name: facebook_bot_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.facebook_bot_configurations_id_seq OWNED BY public.facebook_bot_configurations.id;


--
-- Name: first_email_ids_activists; Type: VIEW; Schema: public; Owner: monkey_user
--

CREATE VIEW public.first_email_ids_activists AS
 SELECT min(activists.id) AS min_id,
    lower((activists.email)::text) AS email,
    array_agg(activists.id) AS ids
   FROM public.activists
  GROUP BY activists.email;


ALTER TABLE public.first_email_ids_activists OWNER TO monkey_user;

--
-- Name: form_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.form_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.form_entries_id_seq OWNER TO monkey_user;

--
-- Name: form_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.form_entries_id_seq OWNED BY public.form_entries.id;


--
-- Name: gateway_subscriptions; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.gateway_subscriptions (
    id integer NOT NULL,
    subscription_id integer,
    gateway_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.gateway_subscriptions OWNER TO monkey_user;

--
-- Name: gateway_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.gateway_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_subscriptions_id_seq OWNER TO monkey_user;

--
-- Name: gateway_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.gateway_subscriptions_id_seq OWNED BY public.gateway_subscriptions.id;


--
-- Name: gateway_transactions; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.gateway_transactions (
    id integer NOT NULL,
    transaction_id text,
    gateway_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.gateway_transactions OWNER TO monkey_user;

--
-- Name: gateway_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.gateway_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_transactions_id_seq OWNER TO monkey_user;

--
-- Name: gateway_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.gateway_transactions_id_seq OWNED BY public.gateway_transactions.id;


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invitations_id_seq OWNER TO monkey_user;

--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.invitations_id_seq OWNED BY public.invitations.id;


--
-- Name: matches; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.matches (
    id integer NOT NULL,
    widget_id integer,
    first_choice character varying,
    second_choice character varying,
    goal_image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.matches OWNER TO monkey_user;

--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.matches_id_seq OWNER TO monkey_user;

--
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;


--
-- Name: mobilization_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.mobilization_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mobilization_activists_id_seq OWNER TO monkey_user;

--
-- Name: mobilization_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.mobilization_activists_id_seq OWNED BY public.mobilization_activists.id;


--
-- Name: mobilizations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.mobilizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mobilizations_id_seq OWNER TO monkey_user;

--
-- Name: mobilizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.mobilizations_id_seq OWNED BY public.mobilizations.id;


--
-- Name: notification_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.notification_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_templates_id_seq OWNER TO monkey_user;

--
-- Name: notification_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.notification_templates_id_seq OWNED BY public.notification_templates.id;


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO monkey_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: payable_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.payable_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payable_transfers_id_seq OWNER TO monkey_user;

--
-- Name: payable_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.payable_transfers_id_seq OWNED BY public.payable_transfers.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    transaction_status character varying,
    transaction_id character varying,
    plan_id integer,
    donation_id integer,
    subscription_id character varying,
    activist_id integer,
    address_id integer,
    credit_card_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.payments OWNER TO monkey_user;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO monkey_user;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.plans (
    id integer NOT NULL,
    plan_id character varying,
    name character varying,
    amount integer,
    days integer,
    payment_methods text[] DEFAULT '{credit_card,boleto}'::text[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.plans OWNER TO monkey_user;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plans_id_seq OWNER TO monkey_user;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipients_id_seq OWNER TO monkey_user;

--
-- Name: recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.recipients_id_seq OWNED BY public.recipients.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO monkey_user;

--
-- Name: subscription_transitions; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.subscription_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata json DEFAULT '{}'::json,
    sort_key integer NOT NULL,
    subscription_id integer NOT NULL,
    most_recent boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.subscription_transitions OWNER TO monkey_user;

--
-- Name: subscription_reports; Type: VIEW; Schema: public; Owner: monkey_user
--

CREATE VIEW public.subscription_reports AS
 SELECT s.community_id,
    a.name AS "Nome do doador",
    a.email AS "Email do doador",
    (((s.amount)::numeric / 100.0))::numeric(13,2) AS "Valor de doação",
    s.status AS "Status de assinatura",
    s.payment_method AS "Forma de doação (boleto/cartão)",
    s.id AS "ID da assinatura",
    s.created_at AS "Data de início da assinatura",
        CASE
            WHEN ((s.status)::text = 'canceled'::text) THEN ct.created_at
            ELSE NULL::timestamp without time zone
        END AS "Data do cancelamento da assinatura",
        CASE
            WHEN ((s.status)::text = 'unpaid'::text) THEN
            CASE
                WHEN public.receiving_unpaid_notifications(s.*) THEN 'Sim'::text
                ELSE 'Não'::text
            END
            ELSE NULL::text
        END AS "recebendo notificações?",
    ((('https://app.bonde.org/subscriptions/'::text || s.id) || '/edit?token='::text) || s.token) AS "Link de alteração da assinatura"
   FROM (((public.subscriptions s
     JOIN public.activists a ON ((a.id = s.activist_id)))
     LEFT JOIN LATERAL ( SELECT st.id,
            st.to_state,
            st.metadata,
            st.sort_key,
            st.subscription_id,
            st.most_recent,
            st.created_at,
            st.updated_at
           FROM public.subscription_transitions st
          WHERE ((st.subscription_id = s.id) AND ((st.to_state)::text = 'canceled'::text))
          ORDER BY st.created_at DESC
         LIMIT 1) ct ON (true))
     LEFT JOIN LATERAL ( SELECT n.id,
            n.activist_id,
            n.notification_template_id,
            n.template_vars,
            n.created_at,
            n.updated_at,
            n.community_id,
            n.user_id,
            n.email,
            n.deliver_at,
            n.delivered_at
           FROM (public.notifications n
             JOIN public.notification_templates nt ON ((nt.id = n.notification_template_id)))
          WHERE ((nt.label = 'unpaid_subscription'::text) AND (((n.template_vars ->> 'subscription_id'::text))::integer = s.id))
          ORDER BY n.created_at DESC
         LIMIT 1) last_unpaid_notification ON (true));


ALTER TABLE public.subscription_reports OWNER TO monkey_user;

--
-- Name: subscription_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.subscription_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_transitions_id_seq OWNER TO monkey_user;

--
-- Name: subscription_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.subscription_transitions_id_seq OWNED BY public.subscription_transitions.id;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_id_seq OWNER TO monkey_user;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taggings_id_seq OWNER TO monkey_user;

--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO monkey_user;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: template_blocks; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.template_blocks (
    id integer NOT NULL,
    template_mobilization_id integer,
    bg_class character varying,
    "position" integer,
    hidden boolean,
    bg_image text,
    name character varying,
    menu_hidden boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.template_blocks OWNER TO monkey_user;

--
-- Name: template_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.template_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_blocks_id_seq OWNER TO monkey_user;

--
-- Name: template_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.template_blocks_id_seq OWNED BY public.template_blocks.id;


--
-- Name: template_mobilizations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.template_mobilizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_mobilizations_id_seq OWNER TO monkey_user;

--
-- Name: template_mobilizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.template_mobilizations_id_seq OWNED BY public.template_mobilizations.id;


--
-- Name: template_widgets; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.template_widgets (
    id integer NOT NULL,
    template_block_id integer,
    settings public.hstore,
    kind character varying,
    sm_size integer,
    md_size integer,
    lg_size integer,
    mailchimp_segment_id character varying,
    action_community boolean,
    exported_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.template_widgets OWNER TO monkey_user;

--
-- Name: template_widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.template_widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_widgets_id_seq OWNER TO monkey_user;

--
-- Name: template_widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.template_widgets_id_seq OWNED BY public.template_widgets.id;


--
-- Name: twilio_call_transitions; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.twilio_call_transitions (
    id integer NOT NULL,
    twilio_account_sid text NOT NULL,
    twilio_call_sid text NOT NULL,
    twilio_parent_call_sid text,
    sequence_number integer NOT NULL,
    status text NOT NULL,
    called text NOT NULL,
    caller text NOT NULL,
    call_duration text,
    data text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.twilio_call_transitions OWNER TO monkey_user;

--
-- Name: twilio_call_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.twilio_call_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.twilio_call_transitions_id_seq OWNER TO monkey_user;

--
-- Name: twilio_call_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.twilio_call_transitions_id_seq OWNED BY public.twilio_call_transitions.id;


--
-- Name: twilio_calls_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.twilio_calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.twilio_calls_id_seq OWNER TO monkey_user;

--
-- Name: twilio_calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.twilio_calls_id_seq OWNED BY public.twilio_calls.id;


--
-- Name: twilio_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.twilio_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.twilio_configurations_id_seq OWNER TO monkey_user;

--
-- Name: twilio_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.twilio_configurations_id_seq OWNED BY public.twilio_configurations.id;


--
-- Name: user_tags; Type: TABLE; Schema: public; Owner: monkey_user
--

CREATE TABLE public.user_tags (
    id integer NOT NULL,
    user_id integer,
    tag_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.user_tags OWNER TO monkey_user;

--
-- Name: user_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.user_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_tags_id_seq OWNER TO monkey_user;

--
-- Name: user_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.user_tags_id_seq OWNED BY public.user_tags.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO monkey_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: monkey_user
--

CREATE SEQUENCE public.widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.widgets_id_seq OWNER TO monkey_user;

--
-- Name: widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: monkey_user
--

ALTER SEQUENCE public.widgets_id_seq OWNED BY public.widgets.id;


--
-- Name: hdb_schema_update_event id; Type: DEFAULT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_update_event ALTER COLUMN id SET DEFAULT nextval('hdb_catalog.hdb_schema_update_event_id_seq'::regclass);


--
-- Name: remote_schemas id; Type: DEFAULT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.remote_schemas ALTER COLUMN id SET DEFAULT nextval('hdb_catalog.remote_schemas_id_seq'::regclass);


--
-- Name: activist_facebook_bot_interactions id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions ALTER COLUMN id SET DEFAULT nextval('public.activist_facebook_bot_interactions_id_seq'::regclass);


--
-- Name: activist_matches id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_matches ALTER COLUMN id SET DEFAULT nextval('public.activist_matches_id_seq'::regclass);


--
-- Name: activist_pressures id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_pressures ALTER COLUMN id SET DEFAULT nextval('public.activist_pressures_id_seq'::regclass);


--
-- Name: activist_tags id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_tags ALTER COLUMN id SET DEFAULT nextval('public.activist_tags_id_seq'::regclass);


--
-- Name: activists id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activists ALTER COLUMN id SET DEFAULT nextval('public.activists_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: balance_operations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.balance_operations ALTER COLUMN id SET DEFAULT nextval('public.balance_operations_id_seq'::regclass);


--
-- Name: blocks id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.blocks ALTER COLUMN id SET DEFAULT nextval('public.blocks_id_seq'::regclass);


--
-- Name: certificates id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.certificates ALTER COLUMN id SET DEFAULT nextval('public.certificates_id_seq'::regclass);


--
-- Name: communities id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.communities ALTER COLUMN id SET DEFAULT nextval('public.communities_id_seq'::regclass);


--
-- Name: community_activists id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.community_activists ALTER COLUMN id SET DEFAULT nextval('public.community_activists_id_seq'::regclass);


--
-- Name: community_users id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.community_users ALTER COLUMN id SET DEFAULT nextval('public.community_users_id_seq'::regclass);


--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: credit_cards id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.credit_cards ALTER COLUMN id SET DEFAULT nextval('public.credit_cards_id_seq'::regclass);


--
-- Name: dns_hosted_zones id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.dns_hosted_zones ALTER COLUMN id SET DEFAULT nextval('public.dns_hosted_zones_id_seq'::regclass);


--
-- Name: dns_records id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.dns_records ALTER COLUMN id SET DEFAULT nextval('public.dns_records_id_seq'::regclass);


--
-- Name: donation_transitions id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donation_transitions ALTER COLUMN id SET DEFAULT nextval('public.donation_transitions_id_seq'::regclass);


--
-- Name: donations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donations ALTER COLUMN id SET DEFAULT nextval('public.donations_id_seq'::regclass);


--
-- Name: facebook_bot_activists id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_activists ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_activists_id_seq'::regclass);


--
-- Name: facebook_bot_campaign_activists id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_campaign_activists_id_seq'::regclass);


--
-- Name: facebook_bot_campaigns id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_campaigns ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_campaigns_id_seq'::regclass);


--
-- Name: facebook_bot_configurations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_configurations ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_configurations_id_seq'::regclass);


--
-- Name: form_entries id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.form_entries ALTER COLUMN id SET DEFAULT nextval('public.form_entries_id_seq'::regclass);


--
-- Name: gateway_subscriptions id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.gateway_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.gateway_subscriptions_id_seq'::regclass);


--
-- Name: gateway_transactions id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.gateway_transactions ALTER COLUMN id SET DEFAULT nextval('public.gateway_transactions_id_seq'::regclass);


--
-- Name: invitations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.invitations ALTER COLUMN id SET DEFAULT nextval('public.invitations_id_seq'::regclass);


--
-- Name: matches id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);


--
-- Name: mobilization_activists id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.mobilization_activists ALTER COLUMN id SET DEFAULT nextval('public.mobilization_activists_id_seq'::regclass);


--
-- Name: mobilizations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.mobilizations ALTER COLUMN id SET DEFAULT nextval('public.mobilizations_id_seq'::regclass);


--
-- Name: notification_templates id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notification_templates ALTER COLUMN id SET DEFAULT nextval('public.notification_templates_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: payable_transfers id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.payable_transfers ALTER COLUMN id SET DEFAULT nextval('public.payable_transfers_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: recipients id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.recipients ALTER COLUMN id SET DEFAULT nextval('public.recipients_id_seq'::regclass);


--
-- Name: subscription_transitions id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscription_transitions ALTER COLUMN id SET DEFAULT nextval('public.subscription_transitions_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: template_blocks id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.template_blocks ALTER COLUMN id SET DEFAULT nextval('public.template_blocks_id_seq'::regclass);


--
-- Name: template_mobilizations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.template_mobilizations ALTER COLUMN id SET DEFAULT nextval('public.template_mobilizations_id_seq'::regclass);


--
-- Name: template_widgets id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.template_widgets ALTER COLUMN id SET DEFAULT nextval('public.template_widgets_id_seq'::regclass);


--
-- Name: twilio_call_transitions id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.twilio_call_transitions ALTER COLUMN id SET DEFAULT nextval('public.twilio_call_transitions_id_seq'::regclass);


--
-- Name: twilio_calls id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.twilio_calls ALTER COLUMN id SET DEFAULT nextval('public.twilio_calls_id_seq'::regclass);


--
-- Name: twilio_configurations id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.twilio_configurations ALTER COLUMN id SET DEFAULT nextval('public.twilio_configurations_id_seq'::regclass);


--
-- Name: user_tags id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.user_tags ALTER COLUMN id SET DEFAULT nextval('public.user_tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: widgets id; Type: DEFAULT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.widgets ALTER COLUMN id SET DEFAULT nextval('public.widgets_id_seq'::regclass);


--
-- Data for Name: event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: event_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.event_log (id, schema_name, table_name, trigger_name, payload, delivered, error, tries, created_at, locked, next_retry_at) FROM stdin;
\.


--
-- Data for Name: event_triggers; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.event_triggers (name, type, schema_name, table_name, configuration, comment) FROM stdin;
\.


--
-- Data for Name: hdb_allowlist; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_allowlist (collection_name) FROM stdin;
\.


--
-- Data for Name: hdb_function; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_function (function_schema, function_name, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_permission; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_permission (table_schema, table_name, role_name, perm_type, perm_def, comment, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_query_collection; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_query_collection (collection_name, collection_defn, comment, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_query_template; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_query_template (template_name, template_defn, comment, is_system_defined) FROM stdin;
\.


--
-- Data for Name: hdb_relationship; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) FROM stdin;
hdb_catalog	hdb_table	detail	object	{"manual_configuration": {"remote_table": {"name": "tables", "schema": "information_schema"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	primary_key	object	{"manual_configuration": {"remote_table": {"name": "hdb_primary_key", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	columns	array	{"manual_configuration": {"remote_table": {"name": "columns", "schema": "information_schema"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	foreign_key_constraints	array	{"manual_configuration": {"remote_table": {"name": "hdb_foreign_key_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	relationships	array	{"manual_configuration": {"remote_table": {"name": "hdb_relationship", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	permissions	array	{"manual_configuration": {"remote_table": {"name": "hdb_permission_agg", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	check_constraints	array	{"manual_configuration": {"remote_table": {"name": "hdb_check_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	hdb_table	unique_constraints	array	{"manual_configuration": {"remote_table": {"name": "hdb_unique_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}	\N	t
hdb_catalog	event_log	trigger	object	{"manual_configuration": {"remote_table": {"name": "event_triggers", "schema": "hdb_catalog"}, "column_mapping": {"trigger_name": "name"}}}	\N	t
hdb_catalog	event_triggers	events	array	{"manual_configuration": {"remote_table": {"name": "event_log", "schema": "hdb_catalog"}, "column_mapping": {"name": "trigger_name"}}}	\N	t
hdb_catalog	event_invocation_logs	event	object	{"foreign_key_constraint_on": "event_id"}	\N	t
hdb_catalog	event_log	logs	array	{"foreign_key_constraint_on": {"table": {"name": "event_invocation_logs", "schema": "hdb_catalog"}, "column": "event_id"}}	\N	t
hdb_catalog	hdb_function_agg	return_table_info	object	{"manual_configuration": {"remote_table": {"name": "hdb_table", "schema": "hdb_catalog"}, "column_mapping": {"return_type_name": "table_name", "return_type_schema": "table_schema"}}}	\N	t
\.


--
-- Data for Name: hdb_schema_update_event; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_schema_update_event (id, instance_id, occurred_at) FROM stdin;
\.


--
-- Name: hdb_schema_update_event_id_seq; Type: SEQUENCE SET; Schema: hdb_catalog; Owner: monkey_user
--

SELECT pg_catalog.setval('hdb_catalog.hdb_schema_update_event_id_seq', 1, false);


--
-- Data for Name: hdb_table; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_table (table_schema, table_name, is_system_defined) FROM stdin;
hdb_catalog	hdb_table	t
information_schema	tables	t
information_schema	schemata	t
information_schema	views	t
hdb_catalog	hdb_primary_key	t
information_schema	columns	t
hdb_catalog	hdb_foreign_key_constraint	t
hdb_catalog	hdb_relationship	t
hdb_catalog	hdb_permission_agg	t
hdb_catalog	hdb_check_constraint	t
hdb_catalog	hdb_unique_constraint	t
hdb_catalog	hdb_query_template	t
hdb_catalog	event_triggers	t
hdb_catalog	event_log	t
hdb_catalog	event_invocation_logs	t
hdb_catalog	hdb_function_agg	t
hdb_catalog	hdb_function	t
hdb_catalog	remote_schemas	t
hdb_catalog	hdb_version	t
hdb_catalog	hdb_query_collection	t
hdb_catalog	hdb_allowlist	t
\.


--
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
436575ee-2f81-4483-9913-7e4a0962e372	17	2019-08-13 13:50:26.971831+00	{}	{}
\.


--
-- Data for Name: remote_schemas; Type: TABLE DATA; Schema: hdb_catalog; Owner: monkey_user
--

COPY hdb_catalog.remote_schemas (id, name, definition, comment) FROM stdin;
\.


--
-- Name: remote_schemas_id_seq; Type: SEQUENCE SET; Schema: hdb_catalog; Owner: monkey_user
--

SELECT pg_catalog.setval('hdb_catalog.remote_schemas_id_seq', 1, false);


--
-- Data for Name: activist_facebook_bot_interactions; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.activist_facebook_bot_interactions (id, activist_id, facebook_bot_configuration_id, fb_context_recipient_id, fb_context_sender_id, interaction, created_at, updated_at) FROM stdin;
\.


--
-- Name: activist_facebook_bot_interactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.activist_facebook_bot_interactions_id_seq', 1, false);


--
-- Data for Name: activist_matches; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.activist_matches (id, activist_id, match_id, created_at, updated_at, synchronized, mailchimp_syncronization_at, mailchimp_syncronization_error_reason) FROM stdin;
\.


--
-- Name: activist_matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.activist_matches_id_seq', 1, false);


--
-- Data for Name: activist_pressures; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.activist_pressures (id, activist_id, widget_id, created_at, updated_at, synchronized, mailchimp_syncronization_at, mailchimp_syncronization_error_reason, cached_community_id) FROM stdin;
\.


--
-- Name: activist_pressures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.activist_pressures_id_seq', 1, false);


--
-- Data for Name: activist_tags; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.activist_tags (id, activist_id, community_id, created_at, updated_at, mobilization_id) FROM stdin;
\.


--
-- Name: activist_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.activist_tags_id_seq', 1, false);


--
-- Data for Name: activists; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.activists (id, name, email, phone, document_number, document_type, created_at, updated_at, city, first_name, last_name) FROM stdin;
\.


--
-- Name: activists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.activists_id_seq', 1, false);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.addresses (id, zipcode, street, street_number, complementary, neighborhood, city, state, created_at, updated_at, activist_id) FROM stdin;
\.


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- Data for Name: balance_operations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.balance_operations (id, recipient_id, gateway_data, gateway_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: balance_operations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.balance_operations_id_seq', 1, false);


--
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.blocks (id, mobilization_id, created_at, updated_at, bg_class, "position", hidden, bg_image, name, menu_hidden, deleted_at) FROM stdin;
\.


--
-- Name: blocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.blocks_id_seq', 1, false);


--
-- Data for Name: certificates; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.certificates (id, community_id, mobilization_id, dns_hosted_zone_id, domain, file_content, expire_on, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Name: certificates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.certificates_id_seq', 1, false);


--
-- Data for Name: communities; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.communities (id, name, city, created_at, updated_at, mailchimp_api_key, mailchimp_list_id, mailchimp_group_id, image, description, recipient_id, fb_link, twitter_link, facebook_app_id, subscription_retry_interval, subscription_dead_days_interval, email_template_from, mailchimp_sync_request_at) FROM stdin;
1	Bonde	Rio de Janeiro	2019-08-13 13:50:23.06928	2019-08-13 13:50:23.06928	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	90	\N	\N
2	Nossas	Rio de Janeiro	2019-08-13 13:50:23.079917	2019-08-13 13:50:23.079917	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	90	\N	\N
\.


--
-- Name: communities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.communities_id_seq', 2, true);


--
-- Data for Name: community_activists; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.community_activists (id, community_id, activist_id, search_index, created_at, updated_at, profile_data) FROM stdin;
\.


--
-- Name: community_activists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.community_activists_id_seq', 1, false);


--
-- Data for Name: community_users; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.community_users (id, user_id, community_id, role, created_at, updated_at) FROM stdin;
1	1	1	1	2019-08-13 13:50:23.126155	2019-08-13 13:50:23.126155
2	2	1	1	2019-08-13 13:50:23.141447	2019-08-13 13:50:23.141447
3	1	2	1	2019-08-13 13:50:23.15364	2019-08-13 13:50:23.15364
4	2	2	1	2019-08-13 13:50:23.176637	2019-08-13 13:50:23.176637
\.


--
-- Name: community_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.community_users_id_seq', 4, true);


--
-- Data for Name: configurations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.configurations (id, name, value, created_at, updated_at) FROM stdin;
\.


--
-- Name: configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.configurations_id_seq', 1, false);


--
-- Data for Name: credit_cards; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.credit_cards (id, activist_id, last_digits, card_brand, card_id, created_at, updated_at, expiration_date) FROM stdin;
\.


--
-- Name: credit_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.credit_cards_id_seq', 1, false);


--
-- Data for Name: dns_hosted_zones; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.dns_hosted_zones (id, community_id, domain_name, comment, created_at, updated_at, response, ns_ok) FROM stdin;
\.


--
-- Name: dns_hosted_zones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.dns_hosted_zones_id_seq', 1, false);


--
-- Data for Name: dns_records; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.dns_records (id, dns_hosted_zone_id, name, record_type, value, ttl, created_at, updated_at, comment) FROM stdin;
\.


--
-- Name: dns_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.dns_records_id_seq', 1, false);


--
-- Data for Name: donation_transitions; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.donation_transitions (id, to_state, metadata, sort_key, donation_id, most_recent, created_at, updated_at) FROM stdin;
\.


--
-- Name: donation_transitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.donation_transitions_id_seq', 1, false);


--
-- Data for Name: donations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.donations (id, widget_id, created_at, updated_at, token, payment_method, amount, email, card_hash, customer, skip, transaction_id, transaction_status, subscription, credit_card, activist_id, subscription_id, period, plan_id, parent_id, payables, gateway_data, payable_transfer_id, converted_from, synchronized, local_subscription_id, mailchimp_syncronization_at, mailchimp_syncronization_error_reason, checkout_data, cached_community_id) FROM stdin;
\.


--
-- Name: donations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.donations_id_seq', 1, false);


--
-- Data for Name: facebook_bot_activists; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.facebook_bot_activists (id, fb_context_recipient_id, fb_context_sender_id, data, messages, quick_replies, interaction_dates, created_at, updated_at) FROM stdin;
\.


--
-- Name: facebook_bot_activists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.facebook_bot_activists_id_seq', 1, false);


--
-- Data for Name: facebook_bot_campaign_activists; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.facebook_bot_campaign_activists (id, facebook_bot_campaign_id, facebook_bot_activist_id, received, log, created_at, updated_at) FROM stdin;
\.


--
-- Name: facebook_bot_campaign_activists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.facebook_bot_campaign_activists_id_seq', 1, false);


--
-- Data for Name: facebook_bot_campaigns; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.facebook_bot_campaigns (id, facebook_bot_configuration_id, name, segment_filters, total_impacted_activists, created_at, updated_at) FROM stdin;
\.


--
-- Name: facebook_bot_campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.facebook_bot_campaigns_id_seq', 1, false);


--
-- Data for Name: facebook_bot_configurations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.facebook_bot_configurations (id, community_id, messenger_app_secret, messenger_validation_token, messenger_page_access_token, data, created_at, updated_at) FROM stdin;
\.


--
-- Name: facebook_bot_configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.facebook_bot_configurations_id_seq', 1, false);


--
-- Data for Name: form_entries; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.form_entries (id, widget_id, fields, created_at, updated_at, synchronized, activist_id, mailchimp_syncronization_at, mailchimp_syncronization_error_reason, cached_community_id) FROM stdin;
\.


--
-- Name: form_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.form_entries_id_seq', 1, false);


--
-- Data for Name: gateway_subscriptions; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.gateway_subscriptions (id, subscription_id, gateway_data, created_at, updated_at) FROM stdin;
\.


--
-- Name: gateway_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.gateway_subscriptions_id_seq', 1, false);


--
-- Data for Name: gateway_transactions; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.gateway_transactions (id, transaction_id, gateway_data, created_at, updated_at) FROM stdin;
\.


--
-- Name: gateway_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.gateway_transactions_id_seq', 1, false);


--
-- Data for Name: invitations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.invitations (id, community_id, user_id, email, code, expires, role, expired, created_at, updated_at) FROM stdin;
\.


--
-- Name: invitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.invitations_id_seq', 1, false);


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.matches (id, widget_id, first_choice, second_choice, goal_image, created_at, updated_at) FROM stdin;
\.


--
-- Name: matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.matches_id_seq', 1, false);


--
-- Data for Name: mobilization_activists; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.mobilization_activists (id, mobilization_id, activist_id, search_index, created_at, updated_at) FROM stdin;
\.


--
-- Name: mobilization_activists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.mobilization_activists_id_seq', 1, false);


--
-- Data for Name: mobilizations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.mobilizations (id, name, created_at, updated_at, user_id, color_scheme, google_analytics_code, goal, facebook_share_title, facebook_share_description, header_font, body_font, facebook_share_image, slug, custom_domain, twitter_share_text, community_id, favicon, deleted_at, status, traefik_host_rule, traefik_backend_address) FROM stdin;
1	Vamos limpar o tietê!	2019-08-13 13:50:23.297878	2019-08-13 13:50:23.297878	2	bonde-scheme	\N	Um rio limpo para todos	\N	\N	ubuntu	open-sans	\N	1-vamos-limpar-o-tiete	\N	Acabei de colaborar com Vamos limpar o tietê!. Participe você também: 	1	\N	\N	active	\N	\N
2	Save the Whales!	2019-08-13 13:50:23.318652	2019-08-13 13:50:23.318652	2	bonde-scheme	\N	More whales, more happyness	\N	\N	ubuntu	open-sans	\N	2-save-the-whales	\N	Acabei de colaborar com Save the Whales!. Participe você também: 	1	\N	\N	active	\N	\N
\.


--
-- Name: mobilizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.mobilizations_id_seq', 2, true);


--
-- Data for Name: notification_templates; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.notification_templates (id, label, community_id, subject_template, body_template, template_vars, created_at, updated_at, locale) FROM stdin;
1	bonde_password_retrieve	\N	Sobre seu acesso no bonde	Olá, {{user.name}}.  <br> Foi solicitadoa a geração de uma nova senha para sua conta no bonde, e a nova senha é {{new_password}}.	\N	2019-08-13 13:50:14.06794	2019-08-13 13:50:14.06794	pt-BR
2	paid_subscription	\N	{{community.name}} recebeu sua doação!	\n<tr>\n  <td style="padding-bottom: 16px;">\n    <table\n      width="100%"\n      style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      "\n    >\n      <tr>\n        <td style="padding: 32px 48px;" align="center">\n          <table>\n            <tr>\n              <td align="center" style="padding-bottom: 16px; color: #424242; font-size: 18px;">\n                Oi, <span style="color: #EE0099; font-weight: 800;">{{customer.first_name}}</span>!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 32px; color: #424242; font-size: 13px;">\n                Olha a notícia boa: sua contribuição a(o) <b>{{community.name}}</b> foi recebida.\n                Obrigada por acreditar nesse trabalho, seu apoio faz toda a diferença! :)\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 16px;">\n                <img src="https://s3.amazonaws.com/hub-central-dev/uploads/1524537871_bonde-donation-icon.png">\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 24px; color: #EE0099; font-size: 13px; font-weight: 800;">\n                Comprovante de Contribuição\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 24px; font-size: 9px; font-weight: 700;">\n                <table style="max-width: 335px; border-top: 1px solid #AAAAAA;">\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">Nome do apoiador</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{customer.name}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">CPF/CNPJ do apoiador</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{last_donation.customer_document}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">Data da confirmação</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{created}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">Valor da contribuição</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{amount}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">ID do apoio</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{"#" | append: last_donation.donation_id}}</td>\n                  </tr>\n                  {% if last_donation.payment_method == 'credit_card' %}\n                    <tr>\n                      <td align="left" style="padding-top: 16px; color: #424242">Cartão de crédito final</td>\n                      <td align="right" style="padding-top: 16px; color: #AAAAAA;"> {{"****.****.****." | append: last_donation.card_last_digits}} </td>\n                    </tr>\n                  {% endif %}\n                </table>\n              </td>\n            </tr>\n            {% if last_donation.payment_method == 'credit_card' %}\n            <tr align="center">\n              <td align="center" style="padding-bottom: 56px; color: #4A4A4A; font-size: 11px; font-weight: 600;">\n                Em sua fatura, aparecerá a descrição "PG *NOSSAS CIDADES"\n              </td>\n            </tr>\n            {% endif %}\n            <tr>\n              <td align="center" style="padding-bottom: 0; color: #4A4A4A; font-size: 11px;">\n                Dúvidas? Só mandar um e-mail pra: <a href="mailto:suporte@bonde.org">suporte@bonde.org</a>\n              </td>\n            </tr>\n          </table>\n        </td>\n      </tr>\n    </table>\n  </td>\n</tr>	\N	2019-08-13 13:50:26.387986	2019-08-13 13:50:26.387986	pt-BR
3	unpaid_subscription	\N	{{community.name}} não recebeu sua doação :/	\n<tr>\n  <td style="padding-bottom: 16px;">\n    <table\n      width="100%"\n      style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      "\n    >\n      <tr>\n        <td style="padding: 32px 48px;" align="center">\n          <table>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 18px;">\n                Olá, <span style="color: #EE0099; font-weight: 800;">{{customer.first_name}}</span>!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 13px;">\n                Algo deu errado na sua doação a(o) <b>{{community.name}}</b> -\n                e seu apoio faz muita diferença, então bora resolver juntos? Se você trocou\n                de cartão ou quer alterar a data de cobrança, é só clicar no botão a\n                seguir para editar essas informações:\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 64px;">\n                <a\n                  href="{{manage_url}}"\n                  style="\n                    display: inline-block;\n                    background-color: #EE0099;\n                    color: #FFFFFF;\n                    font-size: 11px;\n                    font-weight: 700;\n                    text-transform: uppercase;\n                    border-radius: 100px;\n                    text-decoration: none;\n                    padding: 16px 32px;\n                    text-align: center;\n                  "\n                >\n                  Editar minha doação\n                </a>\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 0; color: #4A4A4A; font-size: 11px;">\n                Dúvidas? Só mandar um e-mail pra: <a href="mailto:suporte@bonde.org">suporte@bonde.org</a>\n              </td>\n            </tr>\n          </table>\n        </td>\n      </tr>\n    </table>\n  </td>\n</tr>	\N	2019-08-13 13:50:26.39994	2019-08-13 13:50:26.39994	pt-BR
4	canceled_subscription	\N	Olá {{customer.first_name}}, sua doação foi cancelada :(	\n<tr>\n  <td style="padding-bottom: 16px;">\n    <table\n      width="100%"\n      style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      "\n    >\n      <tr>\n        <td style="padding: 32px 48px;" align="center">\n          <table>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 18px;">\n                Olá, <span style="color: #EE0099; font-weight: 800;">{{customer.first_name}}</span>!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 48px; color: #424242; font-size: 13px;">\n                Seu apoio recorrente a(o) <b>{{community.name}}</b> foi cancelado...\n                Agradecemos muito sua ajuda até então, pode acreditar que fez muita diferença!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 24px; color: #424242; font-size: 13px;">\n                E se quiser voltar a apoiar <b>{{community.name}}</b>, é só entrar no site e criar uma nova doação :)\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 0; color: #4A4A4A; font-size: 11px;">\n                Dúvidas? Só mandar um e-mail pra: <a href="mailto:suporte@bonde.org">suporte@bonde.org</a>\n              </td>\n            </tr>\n          </table>\n        </td>\n      </tr>\n    </table>\n  </td>\n</tr>	\N	2019-08-13 13:50:26.407499	2019-08-13 13:50:26.407499	pt-BR
5	slip_subscription	\N	{{customer.first_name}}, um boleto que ode fazer a diferença para {{community.name}}	\n<tr>\n  <td style="padding-bottom: 16px;">\n    <table\n      width="100%"\n      style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      "\n    >\n      <tr>\n        <td style="padding: 32px 48px;" align="center">\n          <table>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 18px;">\n                Olá, <span style="color: #EE0099; font-weight: 800;">{{customer.first_name}}</span>!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 13px;">\n                Como vai?\n                <br>\n                Emitimos o boleto pra você poder seguir\n                apoiando <b>{{community.name}}</b>.\n                Para acessar o boleto, é só clicar no botão:\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 32px;">\n                <a\n                  href="{{last_donation.boleto_url}}"\n                  style="\n                    display: inline-block;\n                    background-color: #EE0099;\n                    color: #FFFFFF;\n                    font-size: 11px;\n                    font-weight: 700;\n                    text-transform: uppercase;\n                    border-radius: 100px;\n                    text-decoration: none;\n                    padding: 16px 32px;\n                    text-align: center;\n                  "\n                >\n                  Acessar boleto\n                </a>\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 64px; color: #4A4A4A; font-size: 13px;">\n                E pra apoiar é fácil: você pode pagar pelo Internet Banking ou agência\n                de qualquer banco até a data de vencimento. Depois de vencido, só\n                será aceito pelo banco emissor. Se o botão não funcionar, é só\n                clicar neste link:\n                <br>\n                       <a href="{{last_donation.boleto_url}}">{{last_donation.boleto_url}}</a>\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 0; color: #4A4A4A; font-size: 11px;">\n                Dúvidas? Só mandar um e-mail pra: <a href="mailto:suporte@bonde.org">suporte@bonde.org</a>\n              </td>\n            </tr>\n          </table>\n        </td>\n      </tr>\n    </table>\n  </td>\n</tr>	\N	2019-08-13 13:50:26.416496	2019-08-13 13:50:26.416496	pt-BR
6	invalid_canceled_gateway_subscription	\N	Sua doação a {{community.name}} continua ativa!	\n<tr>\n    <td style="height:134px;position:relative;">\n        <div style="background-image:url({{community.image}});background-size:100%;left:50%;margin-left:-56px;width:112px;height:112px;background-color:#d8d8d8;border:5px solid #ffffff;border-radius:50%; margin: 0 auto;"></div>\n    </td>\n</tr>\n<tr>\n    <td>\n        <table style="width:420px;margin:80px auto;text-align:center;color:#222;font-size:17px;">\n            <tr>\n                <td>\nOlá {{customer.first_name}}, tudo bem? <br/><br/>\nOntem você recebeu um e-mail do Pagar.me informando o cancelamento da sua doação a {{community.name}}. Estamos fazendo uma atualização no nosso sistema de pagamento e esse e-mail não deveria ter sido enviado.\n<br/><br/>\nSua doação continua válida e você continuará sendo debitado na data correta. Não será necessária nenhuma ação sua para continuar contribuindo. Desculpe-nos o transtorno. Qualquer dúvida, estamos à disposição\n<br/>\n                </td>\n            </tr>\n{% if community.fb_link %}\n            <tr>\n                <td style="padding-bottom:30px;">\n                    <p>\n                        Siga de perto o trabalho da {{community.name}}:\n                    </p>\n                    <div>\n                        <a href="{{community.fb_link}}"><img src="https://s3.amazonaws.com/hub-central-dev/uploads/1490248328_icon-fb.png" width="36" height="36" hspace="5" /></a>\n                        <a href="{{community.twitter_link}}"><img src="https://s3.amazonaws.com/hub-central-dev/uploads/1490248320_icon-ig.png" width="36" height="36" hspace="5" /></a>\n                    </div>\n                </td>\n            </tr>\n{% endif %}\n        </table>\n    </td>\n</tr>	\N	2019-08-13 13:50:26.440813	2019-08-13 13:50:26.440813	pt-BR
7	waiting_payment_donation	\N	{{customer.first_name}}, um boleto que pode fazer a diferença para {{community.name}}!	\n<tr>\n  <td style="padding-bottom: 16px;">\n    <table\n      width="100%"\n      style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      "\n    >\n      <tr>\n        <td style="padding: 32px 48px;" align="center">\n          <table>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 18px;">\n                Olá, <span style="color: #EE0099; font-weight: 800;">{{customer.first_name}}</span>!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 13px;">\n                Como vai?\n                <br>\n                Emitimos o boleto pra você poder seguir\n                apoiando a <b>{{community.name}}</b>.\n                Para acessar o boleto, é só clicar no botão:\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 32px;">\n                <a\n                  href="{{boleto_url}}"\n                  style="\n                    display: inline-block;\n                    background-color: #EE0099;\n                    color: #FFFFFF;\n                    font-size: 11px;\n                    font-weight: 700;\n                    text-transform: uppercase;\n                    border-radius: 100px;\n                    text-decoration: none;\n                    padding: 16px 32px;\n                    text-align: center;\n                  "\n                >\n                  Acessar boleto\n                </a>\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 64px; color: #4A4A4A; font-size: 13px;">\n                E pra apoiar é fácil: você pode pagar pelo  Internet Banking ou agência\n                de qualquer banco até a data de vencimento. Depois de vencido, só\n                será aceito pelo banco emissor. Se o botão não funcionar, é só\n                clicar neste link:\n                <br>\n                      <a href="{{boleto_url}}">{{boleto_url}}</a>\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 0; color: #4A4A4A; font-size: 11px;">\n                Dúvidas? Só mandar um e-mail pra: <a href="mailto:suporte@bonde.org">suporte@bonde.org</a>\n              </td>\n            </tr>\n          </table>\n        </td>\n      </tr>\n    </table>\n  </td>\n</tr>	\N	2019-08-13 13:50:26.45089	2019-08-13 13:50:26.468951	pt-BR
10	reset_password_instructions	\N	Instruções para alteração de senha	\n<link href="https://fonts.googleapis.com/css?family=Nunito:400,800" rel="stylesheet">  \n<tr>\n  <td> \n    <table style="width:532px;margin:80px auto;text-align:center;color:#222;font-size:13px;font-family:Nunito;"> \n      <tr> \n        <td>\n          <b style="font-size:18px;">Olá!</b> \n          <br/><br/>\n          Você está recebendo este e-mail pois houve uma solicitação de alteração da senha do seu usuário do <b>BONDE</b>.\n          <br/><br/>\n          <b>Para alterar sua senha, clique aqui:</b>\n          <br/><br/>\n          <a href="{{user.callback_url}}{{user.reset_password_token}}" style="display:block;width:192px;padding:18px 0;border-radius:100px;margin:0 auto;background-color:#ee0099;font-size:11px;color:#fff;font-weight:800;text-transform:uppercase;text-decoration:none;">Alterar senha</a>\n          <br/><br/>\n          Caso você não tenha feito essa solicitação, ignore este e-mail.\n          <br/>\n          Este link irá expirar em 24h.\n          <br/><br /><br />\n          <span style="font-size:11px;">Dúvidas? Só mandar um e-mail pra: <a href="#" style="color:#ee0099;">suporte@bonde.org</a></span>\n        </td>\n      </tr>\n    </table> \n  </td> \n</tr>\n	\N	2019-08-13 13:50:26.511351	2019-08-13 13:50:26.511351	pt-BR
8	paid_donation	\N	{{community.name}} recebeu sua doação!	\n<tr>\n  <td style="padding-bottom: 16px;">\n    <table\n      width="100%"\n      style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      "\n    >\n      <tr>\n        <td style="padding: 32px 48px;" align="center">\n          <table>\n            <tr>\n              <td align="center" style="padding-bottom: 16px; color: #424242; font-size: 18px;">\n                Oi, <span style="color: #EE0099; font-weight: 800;">{{customer.first_name}}</span>!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 32px; color: #424242; font-size: 13px;">\n                Olha a notícia boa: sua contribuição a(o) <b>{{community.name}}</b> foi recebida.\n                Obrigada por acreditar nesse trabalho, seu apoio faz toda a diferença! :)\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 16px;">\n                <img src="https://s3.amazonaws.com/hub-central-dev/uploads/1524537871_bonde-donation-icon.png">\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 24px; color: #EE0099; font-size: 13px; font-weight: 800;">\n                Comprovante de Contribuição\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 24px; font-size: 9px; font-weight: 700;">\n                <table style="max-width: 335px; border-top: 1px solid #AAAAAA;">\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">Nome do apoiador</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{customer.name}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">CPF/CNPJ do apoiador</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{customer_document}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">Data da confirmação</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{created}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">Valor da contribuição</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{amount}}</td>\n                  </tr>\n                  <tr>\n                    <td align="left" style="padding-top: 16px; color: #424242">ID do apoio</td>\n                    <td align="right" style="padding-top: 16px; color: #AAAAAA;">{{"#" | append: donation_id}}</td>\n                  </tr>\n                  {% if payment_method == 'credit_card' %}\n                    <tr>\n                      <td align="left" style="padding-top: 16px; color: #424242">Cartão de crédito final</td>\n                      <td align="right" style="padding-top: 16px; color: #AAAAAA;"> {{"****.****.****." | append: card_last_digits}} </td>\n                    </tr>\n                  {% endif %}\n                </table>\n              </td>\n            </tr>\n            {% if payment_method == 'credit_card' %}\n            <tr align="center">\n              <td align="center" style="padding-bottom: 56px; color: #4A4A4A; font-size: 11px; font-weight: 600;">\n                Em sua fatura, aparecerá a descrição "PG *NOSSAS CIDADES"\n              </td>\n            </tr>\n            {% endif %}\n            <tr>\n              <td align="center" style="padding-bottom: 0; color: #4A4A4A; font-size: 11px;">\n                Dúvidas? Só mandar um e-mail pra: <a href="mailto:suporte@bonde.org">suporte@bonde.org</a>\n              </td>\n            </tr>\n          </table>\n        </td>\n      </tr>\n    </table>\n  </td>\n</tr>\n	\N	2019-08-13 13:50:26.460055	2019-08-13 13:50:26.487818	pt-BR
9	refused_donation	\N	{{community.name}} nào recebeu sua doação :/	\n<tr>\n  <td style="padding-bottom: 16px;">\n    <table\n      width="100%"\n      style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      "\n    >\n      <tr>\n        <td style="padding: 32px 48px;" align="center">\n          <table>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 18px;">\n                Olá, <span style="color: #EE0099; font-weight: 800;">{{customer.first_name}}</span>!\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 40px; color: #424242; font-size: 13px;">\n                Algo deu errado na sua doação a(o) <b>{{community.name}}</b>  -\n                e seu apoio faz muita diferença, então bora resolver juntos?\n                Basta tentar novamente em nosso site e verificar se todas as informações inseridas estão corretas :)\n              </td>\n            </tr>\n            <tr>\n              <td align="center" style="padding-bottom: 0; color: #4A4A4A; font-size: 11px;">\n                Dúvidas? Só mandar um e-mail pra: <a href="mailto:suporte@bonde.org">suporte@bonde.org</a>\n              </td>\n            </tr>\n          </table>\n        </td>\n      </tr>\n    </table>\n  </td>\n</tr>	\N	2019-08-13 13:50:26.500112	2019-08-13 13:50:26.500112	pt-BR
11	welcome_user	\N	Você acaba de embarcar no BONDE!	\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml">\n <head>\n  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\n  <title>BONDE</title>\n  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>\n  <link href="https://fonts.googleapis.com/css?family=Nunito:300,400,600,700,800" rel="stylesheet">\n  <style type="text/css">\n    a, a:link, a:visited, a:hover, a:active { color: #EE0099; }\n  </style>\n</head>\n<body style="margin: 0; padding: 16px; background-color: #EEEEEE; text-align: center;">\n  <table\n    align="center"\n    cellpadding="0"\n    cellspacing="0"\n    style="font-family: 'Nunito', sans-serif; max-width: 600px;"\n  >\n    <!-- HEADER -->\n    <tr>\n      <td align="center" style="padding: 16px;">\n        <img src="https://s3.amazonaws.com/hub-central-dev/uploads/1524537731_bonde-logo.png" style="vertical-align: middle;">\n        {%- if community.image  %}\n          <div style="width: 1px; height: 26px; background-color: #AAAAAA; margin: 0 20px; display: inline-block; vertical-align: middle;"></div>\n          <img src="{{community.image}}" width="20%" style="vertical-align: middle;">\n        {% endif %}\n      </td>\n    </tr>\n    <!-- HEADER -->\n\n    <!-- MAIN -->\n    \n<tr width="100%" style="\n        border-collapse: collapse;\n        border-radius: 5px;\n        border-style: hidden;\n        background-color: #FFFFFF;\n      ">\n    <td>\n        <table style="width:420px;margin:80px auto;text-align:center;color:#222;font-size:17px;">\n            <tr>\n                <td>\nOlá {{user.first_name}}\n<br/><br/>\nVocê está recebendo este email porque acaba de embarcar no BONDE!\n<br/><br/>\nSe tiver dúvidas nessa chegada, pode dar uma olhada em nosso tutorial no <a href="https://trilho.bonde.org">trilho.bonde.org</a> ou nas respostas de nossas perguntas frequentes em <a href="https://faq.bonde.org">faq.bonde.org</a> :)\n<br/><br/>\nUm abraço,\n<br/>\nEquipe do BONDE.\n<br/><br/>\n\n                </td>\n            </tr>\n        </table>\n    </td>\n</tr>\n    <!-- MAIN -->\n\n    <!-- FOOTER -->\n    <tr>\n        <td>\n            <table width="100%">\n                <tr>\n                    <td align="left" style="color: #4A4A4A; font-size: 12px; padding-left: 16px;">\n                        Feito pra causar. Feito com <b>BONDE</b>.\n                    </td>\n                    <td align="right" style="padding-right: 16px;">\n                        <img src="https://s3.amazonaws.com/hub-central-dev/uploads/1524537742_bonde-logo-icon.png">\n                    </td>\n                </tr>\n            </table>\n        </td>\n    </tr>\n    <tr>\n        <td align="center" style="color: #9B9B9B; font-weight: 300; font-size: 9px; padding: 16px 40px;">\n            {%  if community.name  %}\n                O BONDE é a plataforma que {{ community.name }} usa para criar e gerenciar as páginas de\n                mobilizações, por isso você recebe essas notificações vindas da gente ;)\n            {% else %}\n                O BONDE é a plataforma usada para criar e gerenciar as páginas de\n                mobilizações, por isso você recebe essas notificações vindas da gente ;)\n            {% endif %}\n        </td>\n    </tr>\n    <!-- FOOTER -->\n  </table>\n</body>\n</html>\n	\N	2019-08-13 13:50:26.52347	2019-08-13 13:50:26.52347	pt-BR
\.


--
-- Name: notification_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.notification_templates_id_seq', 11, true);


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.notifications (id, activist_id, notification_template_id, template_vars, created_at, updated_at, user_id, email, community_id, deliver_at, delivered_at) FROM stdin;
\.


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Data for Name: payable_transfers; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.payable_transfers (id, transfer_id, transfer_data, transfer_status, community_id, amount, created_at, updated_at) FROM stdin;
\.


--
-- Name: payable_transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.payable_transfers_id_seq', 1, false);


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.payments (id, transaction_status, transaction_id, plan_id, donation_id, subscription_id, activist_id, address_id, credit_card_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.plans (id, plan_id, name, amount, days, payment_methods, created_at, updated_at) FROM stdin;
\.


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.plans_id_seq', 1, false);


--
-- Data for Name: recipients; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.recipients (id, pagarme_recipient_id, recipient, community_id, transfer_day, transfer_enabled, created_at, updated_at) FROM stdin;
\.


--
-- Name: recipients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.recipients_id_seq', 1, false);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.schema_migrations (version) FROM stdin;
20150703175403
20150706222436
20150713202918
20150713205021
20150714134550
20150714192829
20150715182956
20150715185609
20150715185726
20150716140537
20150719172525
20150725143735
20150727031806
20150810212431
20150810212515
20150810212523
20150810215000
20150813210737
20150816004447
20150821173623
20150821173644
20150825160508
20150825160730
20150825160818
20150901035437
20150915141520
20151008121750
20151009182634
20151013165520
20151022141822
20151203190156
20151204202424
20151209193105
20160316001445
20160424074859
20160424093502
20160425053712
20160425061713
20160425102822
20160503125823
20160504184606
20160525213731
20160531195554
20160531214444
20160531214934
20160603225456
20160610182122
20160615192131
20160616034612
20160616043646
20160616195620
20160617125043
20160617135212
20160617171432
20160617192325
20160620120438
20160620130706
20160707013254
20160722185641
20160804203515
20160807232901
20160815195858
20160827125929
20160903182905
20160906000248
20160906011913
20160914103640
20160916113930
20161026223410
20161027001658
20161027003705
20161028152450
20161108141551
20161124155229
20161130194337
20161202142857
20161202162044
20161202163004
20161206144017
20161208191530
20161212181326
20161214144920
20161219215157
20161222175147
20161222205608
20170106125642
20170109235232
20170109235259
20170111175149
20170113233941
20170124134540
20170124153246
20170124160528
20170124190454
20170124221303
20170124221331
20170126205559
20170130123433
20170130123434
20170130123435
20170130123436
20170130123437
20170130123438
20170201113840
20170201160823
20170206175947
20170208151800
20170216155631
20170216210054
20170221131735
20170223000046
20170306221448
20170306223410
20170308111659
20170308123319
20170310131321
20170312170123
20170315104509
20170315195507
20170318210716
20170322181401
20170324132253
20170329184946
20170330210041
20170411133904
20170412192642
20170419190937
20170424121801
20170502183828
20170510151218
20170513184137
20170516183056
20170517193151
20170518183206
20170519172727
20170524200920
20170525191310
20170525204607
20170526183445
20170526195733
20170529204907
20170530183457
20170530235836
20170613185734
20170615040907
20170619151626
20170623201256
20170626161343
20170626184554
20170627172735
20170627180517
20170627184154
20170628102306
20170628112427
20170628112748
20170628115056
20170628121733
20170628191644
20170628194055
20170703190631
20170704211310
20170706212944
20170707144246
20170707161019
20170707165023
20170707165950
20170707175454
20170712174035
20170714013216
20170718172757
20170719173347
20170719175728
20170720191804
20170720205244
20170721164625
20170725195744
20170726204022
20170726204054
20170726204954
20170726205318
20170726205536
20170726212359
20170802063458
20170802070642
20170802071256
20170803201057
20170808114505
20170809125901
20170809133334
20170809134706
20170810125626
20170814184009
20170815175734
20170816181522
20170816182606
20170817173520
20170822101528
20170822103719
20170823154511
20170823172240
20170824185608
20170824201333
20170828180940
20170828183331
20170830151610
20170901130606
20170901155147
20170906143724
20170913121622
20170913182113
20170913212556
20170921132611
20170926170509
20170926170702
20170926210850
20170927162408
20170928195709
20170929162447
20170929163823
20171006161423
20171009181239
20171016162353
20171017192735
20171019144249
20171024112046
20171024113026
20171024114122
20171024195201
20171024205742
20171026115058
20171030165448
20171106183342
20171109153428
20171109154132
20171114132823
20171114202010
20171114210433
20171123182736
20171124163731
20171124201657
20171124202043
20171127181756
20171127193947
20171128165734
20171128184923
20171128211245
20171219163205
20180112132143
20180119181911
20180122204907
20180123171258
20180124225240
20180124225505
20180131162239
20180201210558
20180207185850
20180208153927
20180208205254
20180220193616
20180220194121
20180221180839
20180221182135
20180221184513
20180226184323
20180227181313
20180227230144
20180301141940
20180303014249
20180312214323
20180313135751
20180314184230
20180315004947
20180327163255
20180327163553
20180405184423
20180405192442
20180410202742
20180411122937
20180411200752
20180411214831
20180411215643
20180411215924
20180411220608
20180417194356
20180417201649
20180418144638
20180418181720
20180425194905
20180425205001
20180426140620
20180508180021
20180508202031
20180508203852
20180511181600
20180517163943
20180517222700
20180518104847
20180518105544
20180518151439
20180518162126
20180521004211
20180522175648
20180529112157
20180529113755
20180529114541
20180606193300
20180606210107
20180607172013
20180611190509
20180611193042
20180611201937
20180611204413
20180611204747
20180611205332
20180611205937
20180620145202
20180621142306
20180622125022
20180622182053
20180625145413
20180625150342
20180625205013
20180628214954
20180711234242
20180717142009
20180717143044
20180718194357
20180718195130
20180719192426
20180719193340
20180724190157
20180803154045
20180809141519
20181113143400
20190211180401
\.


--
-- Data for Name: subscription_transitions; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.subscription_transitions (id, to_state, metadata, sort_key, subscription_id, most_recent, created_at, updated_at) FROM stdin;
\.


--
-- Name: subscription_transitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.subscription_transitions_id_seq', 1, false);


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.subscriptions (id, widget_id, activist_id, community_id, card_data, status, period, amount, created_at, updated_at, payment_method, token, gateway_subscription_id, synchronized, mailchimp_syncronization_at, mailchimp_syncronization_error_reason, gateway_customer_id, customer_data, schedule_next_charge_at) FROM stdin;
\.


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 1, false);


--
-- Data for Name: taggings; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.taggings (id, tag_id, taggable_id, taggable_type, tagger_id, tagger_type, context, created_at) FROM stdin;
\.


--
-- Name: taggings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.taggings_id_seq', 1, false);


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.tags (id, name, taggings_count, label) FROM stdin;
1	user_meio-ambiente	0	Meio Ambiente
2	user_direitos-humanos	0	Direitos Humanos
3	user_segurança-publica	0	Segurança pública
4	user_mobilidade	0	Mobilidade
5	user_direito-das-mulheres	0	Direito das Mulheres
6	user_feminismo	0	Feminismo
7	user_participacao-social	0	Participação Social
8	user_educacao	0	Educação
9	user_transparencia	0	Transparência
10	user_direito-lgbtqi+	0	Direito LGBTQI+
11	user_direito-a-moradia	0	Direito à Moradia
12	user_combate-a-corrupção	0	Combate à Corrupção
13	user_combate-ao-racismo	0	Combate ao Racismo
14	user_saude-publica	0	Saúde Pública
\.


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.tags_id_seq', 14, true);


--
-- Data for Name: template_blocks; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.template_blocks (id, template_mobilization_id, bg_class, "position", hidden, bg_image, name, menu_hidden, created_at, updated_at) FROM stdin;
\.


--
-- Name: template_blocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.template_blocks_id_seq', 1, false);


--
-- Data for Name: template_mobilizations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.template_mobilizations (id, name, user_id, color_scheme, facebook_share_title, facebook_share_description, header_font, body_font, facebook_share_image, slug, custom_domain, twitter_share_text, community_id, uses_number, global, created_at, updated_at, goal) FROM stdin;
\.


--
-- Name: template_mobilizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.template_mobilizations_id_seq', 1, false);


--
-- Data for Name: template_widgets; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.template_widgets (id, template_block_id, settings, kind, sm_size, md_size, lg_size, mailchimp_segment_id, action_community, exported_at, created_at, updated_at) FROM stdin;
\.


--
-- Name: template_widgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.template_widgets_id_seq', 1, false);


--
-- Data for Name: twilio_call_transitions; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.twilio_call_transitions (id, twilio_account_sid, twilio_call_sid, twilio_parent_call_sid, sequence_number, status, called, caller, call_duration, data, created_at, updated_at) FROM stdin;
\.


--
-- Name: twilio_call_transitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.twilio_call_transitions_id_seq', 1, false);


--
-- Data for Name: twilio_calls; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.twilio_calls (id, activist_id, widget_id, twilio_account_sid, twilio_call_sid, "from", "to", data, created_at, updated_at, community_id) FROM stdin;
\.


--
-- Name: twilio_calls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.twilio_calls_id_seq', 1, false);


--
-- Data for Name: twilio_configurations; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.twilio_configurations (id, community_id, twilio_account_sid, twilio_auth_token, twilio_number, created_at, updated_at) FROM stdin;
\.


--
-- Name: twilio_configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.twilio_configurations_id_seq', 1, false);


--
-- Data for Name: user_tags; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.user_tags (id, user_id, tag_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: user_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.user_tags_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.users (id, provider, uid, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, first_name, last_name, email, tokens, created_at, updated_at, avatar, admin, locale) FROM stdin;
1	email	foo@bar.com	$2a$11$LEj93TU6wUEOTTeneaByAeYCy1H/RaVXGjFY0f.ukVLMhQk0PcH4a	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	Foo	Bar	foo@bar.com	\N	2019-08-13 13:50:22.875549	2019-08-13 13:50:22.875549	\N	f	pt-BR
2	email	admin_foo@bar.com	$2a$11$/6VvJ85sQNFJFy1CaZIgDuT8pARWbmII2cVr9lb6XeC.gGTMwNUN.	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	admin Foo	Bar	admin_foo@bar.com	\N	2019-08-13 13:50:22.997004	2019-08-13 13:50:22.997004	\N	t	pt-BR
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Data for Name: widgets; Type: TABLE DATA; Schema: public; Owner: monkey_user
--

COPY public.widgets (id, block_id, settings, kind, created_at, updated_at, sm_size, md_size, lg_size, mailchimp_segment_id, action_community, exported_at, mailchimp_unique_segment_id, mailchimp_recurring_active_segment_id, mailchimp_recurring_inactive_segment_id, goal, deleted_at) FROM stdin;
\.


--
-- Name: widgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: monkey_user
--

SELECT pg_catalog.setval('public.widgets_id_seq', 1, false);


--
-- Name: event_invocation_logs event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.event_invocation_logs
    ADD CONSTRAINT event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: event_log event_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.event_log
    ADD CONSTRAINT event_log_pkey PRIMARY KEY (id);


--
-- Name: event_triggers event_triggers_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.event_triggers
    ADD CONSTRAINT event_triggers_pkey PRIMARY KEY (name);


--
-- Name: hdb_allowlist hdb_allowlist_collection_name_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_allowlist
    ADD CONSTRAINT hdb_allowlist_collection_name_key UNIQUE (collection_name);


--
-- Name: hdb_function hdb_function_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_function
    ADD CONSTRAINT hdb_function_pkey PRIMARY KEY (function_schema, function_name);


--
-- Name: hdb_permission hdb_permission_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_permission
    ADD CONSTRAINT hdb_permission_pkey PRIMARY KEY (table_schema, table_name, role_name, perm_type);


--
-- Name: hdb_query_collection hdb_query_collection_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_query_collection
    ADD CONSTRAINT hdb_query_collection_pkey PRIMARY KEY (collection_name);


--
-- Name: hdb_query_template hdb_query_template_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_query_template
    ADD CONSTRAINT hdb_query_template_pkey PRIMARY KEY (template_name);


--
-- Name: hdb_relationship hdb_relationship_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_relationship
    ADD CONSTRAINT hdb_relationship_pkey PRIMARY KEY (table_schema, table_name, rel_name);


--
-- Name: hdb_schema_update_event hdb_schema_update_event_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_update_event
    ADD CONSTRAINT hdb_schema_update_event_pkey PRIMARY KEY (id);


--
-- Name: hdb_table hdb_table_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_table
    ADD CONSTRAINT hdb_table_pkey PRIMARY KEY (table_schema, table_name);


--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- Name: remote_schemas remote_schemas_name_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.remote_schemas
    ADD CONSTRAINT remote_schemas_name_key UNIQUE (name);


--
-- Name: remote_schemas remote_schemas_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.remote_schemas
    ADD CONSTRAINT remote_schemas_pkey PRIMARY KEY (id);


--
-- Name: activist_facebook_bot_interactions activist_facebook_bot_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT activist_facebook_bot_interactions_pkey PRIMARY KEY (id);


--
-- Name: activist_matches activist_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT activist_matches_pkey PRIMARY KEY (id);


--
-- Name: activist_pressures activist_pressures_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT activist_pressures_pkey PRIMARY KEY (id);


--
-- Name: activist_tags activist_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT activist_tags_pkey PRIMARY KEY (id);


--
-- Name: activists activists_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activists
    ADD CONSTRAINT activists_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: balance_operations balance_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.balance_operations
    ADD CONSTRAINT balance_operations_pkey PRIMARY KEY (id);


--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: communities communities_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- Name: community_activists community_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT community_activists_pkey PRIMARY KEY (id);


--
-- Name: community_users community_users_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.community_users
    ADD CONSTRAINT community_users_pkey PRIMARY KEY (id);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: credit_cards credit_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.credit_cards
    ADD CONSTRAINT credit_cards_pkey PRIMARY KEY (id);


--
-- Name: dns_hosted_zones dns_hosted_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT dns_hosted_zones_pkey PRIMARY KEY (id);


--
-- Name: dns_records dns_records_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT dns_records_pkey PRIMARY KEY (id);


--
-- Name: donation_transitions donation_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donation_transitions
    ADD CONSTRAINT donation_transitions_pkey PRIMARY KEY (id);


--
-- Name: donations donations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: facebook_bot_activists facebook_bot_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_activists
    ADD CONSTRAINT facebook_bot_activists_pkey PRIMARY KEY (id);


--
-- Name: facebook_bot_campaign_activists facebook_bot_campaign_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT facebook_bot_campaign_activists_pkey PRIMARY KEY (id);


--
-- Name: facebook_bot_campaigns facebook_bot_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_campaigns
    ADD CONSTRAINT facebook_bot_campaigns_pkey PRIMARY KEY (id);


--
-- Name: facebook_bot_configurations facebook_bot_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_configurations
    ADD CONSTRAINT facebook_bot_configurations_pkey PRIMARY KEY (id);


--
-- Name: form_entries form_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT form_entries_pkey PRIMARY KEY (id);


--
-- Name: gateway_subscriptions gateway_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.gateway_subscriptions
    ADD CONSTRAINT gateway_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: gateway_transactions gateway_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.gateway_transactions
    ADD CONSTRAINT gateway_transactions_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: mobilization_activists mobilization_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT mobilization_activists_pkey PRIMARY KEY (id);


--
-- Name: mobilizations mobilizations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_pkey PRIMARY KEY (id);


--
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: payable_transfers payable_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.payable_transfers
    ADD CONSTRAINT payable_transfers_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: recipients recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.recipients
    ADD CONSTRAINT recipients_pkey PRIMARY KEY (id);


--
-- Name: subscription_transitions subscription_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscription_transitions
    ADD CONSTRAINT subscription_transitions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: template_blocks template_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.template_blocks
    ADD CONSTRAINT template_blocks_pkey PRIMARY KEY (id);


--
-- Name: template_mobilizations template_mobilizations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.template_mobilizations
    ADD CONSTRAINT template_mobilizations_pkey PRIMARY KEY (id);


--
-- Name: template_widgets template_widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.template_widgets
    ADD CONSTRAINT template_widgets_pkey PRIMARY KEY (id);


--
-- Name: twilio_call_transitions twilio_call_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.twilio_call_transitions
    ADD CONSTRAINT twilio_call_transitions_pkey PRIMARY KEY (id);


--
-- Name: twilio_calls twilio_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.twilio_calls
    ADD CONSTRAINT twilio_calls_pkey PRIMARY KEY (id);


--
-- Name: twilio_configurations twilio_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.twilio_configurations
    ADD CONSTRAINT twilio_configurations_pkey PRIMARY KEY (id);


--
-- Name: user_tags user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: widgets widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);


--
-- Name: event_invocation_logs_event_id_idx; Type: INDEX; Schema: hdb_catalog; Owner: monkey_user
--

CREATE INDEX event_invocation_logs_event_id_idx ON hdb_catalog.event_invocation_logs USING btree (event_id);


--
-- Name: event_log_trigger_name_idx; Type: INDEX; Schema: hdb_catalog; Owner: monkey_user
--

CREATE INDEX event_log_trigger_name_idx ON hdb_catalog.event_log USING btree (trigger_name);


--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: monkey_user
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: ids_blocks_mob_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX ids_blocks_mob_id ON public.blocks USING btree (mobilization_id);


--
-- Name: ids_widgets_block_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX ids_widgets_block_id ON public.widgets USING btree (block_id);


--
-- Name: ids_widgets_kind; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX ids_widgets_kind ON public.widgets USING btree (kind);


--
-- Name: idx_activists_on_bot_interations; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX idx_activists_on_bot_interations ON public.activist_facebook_bot_interactions USING btree (activist_id);


--
-- Name: idx_bot_config_on_bot_interactions; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX idx_bot_config_on_bot_interactions ON public.activist_facebook_bot_interactions USING btree (facebook_bot_configuration_id);


--
-- Name: idx_facebook_bot_campaign_activists_on_facebook_bot_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX idx_facebook_bot_campaign_activists_on_facebook_bot_activist_id ON public.facebook_bot_campaign_activists USING btree (facebook_bot_activist_id);


--
-- Name: idx_facebook_bot_campaign_activists_on_facebook_bot_campaign_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX idx_facebook_bot_campaign_activists_on_facebook_bot_campaign_id ON public.facebook_bot_campaign_activists USING btree (facebook_bot_campaign_id);


--
-- Name: idx_mobilizations_custom_domain; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX idx_mobilizations_custom_domain ON public.mobilizations USING btree (custom_domain);


--
-- Name: idx_mobilizations_slug; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX idx_mobilizations_slug ON public.mobilizations USING btree (slug);


--
-- Name: index_activist_matches_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_activist_matches_on_activist_id ON public.activist_matches USING btree (activist_id);


--
-- Name: index_activist_matches_on_match_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_activist_matches_on_match_id ON public.activist_matches USING btree (match_id);


--
-- Name: index_activist_pressures_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_activist_pressures_on_activist_id ON public.activist_pressures USING btree (activist_id);


--
-- Name: index_activist_pressures_on_widget_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_activist_pressures_on_widget_id ON public.activist_pressures USING btree (widget_id);


--
-- Name: index_activist_tags_on_activist_id_and_community_id_and_mob_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_activist_tags_on_activist_id_and_community_id_and_mob_id ON public.activist_tags USING btree (activist_id, community_id, mobilization_id);


--
-- Name: index_activists_on_created_at; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_activists_on_created_at ON public.activists USING btree (created_at DESC);


--
-- Name: index_activists_on_email; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_activists_on_email ON public.activists USING btree (email);


--
-- Name: index_addresses_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_addresses_on_activist_id ON public.addresses USING btree (activist_id);


--
-- Name: index_balance_operations_on_recipient_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_balance_operations_on_recipient_id ON public.balance_operations USING btree (recipient_id);


--
-- Name: index_community_activists_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_community_activists_on_activist_id ON public.community_activists USING btree (activist_id);


--
-- Name: index_community_activists_on_community_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_community_activists_on_community_id ON public.community_activists USING btree (community_id);


--
-- Name: index_community_activists_on_community_id_and_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_community_activists_on_community_id_and_activist_id ON public.community_activists USING btree (community_id, activist_id);


--
-- Name: index_configurations_on_name; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_configurations_on_name ON public.configurations USING btree (name);


--
-- Name: index_credit_cards_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_credit_cards_on_activist_id ON public.credit_cards USING btree (activist_id);


--
-- Name: index_dns_hosted_zones_on_domain_name; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_dns_hosted_zones_on_domain_name ON public.dns_hosted_zones USING btree (domain_name);


--
-- Name: index_dns_records_on_name_and_record_type; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_dns_records_on_name_and_record_type ON public.dns_records USING btree (name, record_type);


--
-- Name: index_donation_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_donation_transitions_parent_most_recent ON public.donation_transitions USING btree (donation_id, most_recent) WHERE most_recent;


--
-- Name: index_donation_transitions_parent_sort; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_donation_transitions_parent_sort ON public.donation_transitions USING btree (donation_id, sort_key);


--
-- Name: index_donations_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_donations_on_activist_id ON public.donations USING btree (activist_id);


--
-- Name: index_donations_on_customer; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_donations_on_customer ON public.donations USING gin (customer);


--
-- Name: index_donations_on_payable_transfer_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_donations_on_payable_transfer_id ON public.donations USING btree (payable_transfer_id);


--
-- Name: index_donations_on_transaction_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_donations_on_transaction_id ON public.donations USING btree (transaction_id);


--
-- Name: index_donations_on_widget_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_donations_on_widget_id ON public.donations USING btree (widget_id);


--
-- Name: index_facebook_bot_activists_on_interaction_dates; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_facebook_bot_activists_on_interaction_dates ON public.facebook_bot_activists USING btree (interaction_dates);


--
-- Name: index_facebook_bot_activists_on_messages; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_facebook_bot_activists_on_messages ON public.facebook_bot_activists USING gin (messages);


--
-- Name: index_facebook_bot_activists_on_quick_replies; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_facebook_bot_activists_on_quick_replies ON public.facebook_bot_activists USING btree (quick_replies);


--
-- Name: index_facebook_bot_activists_on_recipient_id_and_sender_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_facebook_bot_activists_on_recipient_id_and_sender_id ON public.facebook_bot_activists USING btree (fb_context_recipient_id, fb_context_sender_id);


--
-- Name: index_facebook_bot_campaigns_on_facebook_bot_configuration_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_facebook_bot_campaigns_on_facebook_bot_configuration_id ON public.facebook_bot_campaigns USING btree (facebook_bot_configuration_id);


--
-- Name: index_form_entries_on_widget_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_form_entries_on_widget_id ON public.form_entries USING btree (widget_id);


--
-- Name: index_gateway_subscriptions_on_subscription_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_gateway_subscriptions_on_subscription_id ON public.gateway_subscriptions USING btree (subscription_id);


--
-- Name: index_invitations_on_community_id_and_code; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_invitations_on_community_id_and_code ON public.invitations USING btree (community_id, code);


--
-- Name: index_matches_on_widget_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_matches_on_widget_id ON public.matches USING btree (widget_id);


--
-- Name: index_mobilization_activists_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_mobilization_activists_on_activist_id ON public.mobilization_activists USING btree (activist_id);


--
-- Name: index_mobilization_activists_on_mobilization_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_mobilization_activists_on_mobilization_id ON public.mobilization_activists USING btree (mobilization_id);


--
-- Name: index_mobilization_activists_on_mobilization_id_and_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_mobilization_activists_on_mobilization_id_and_activist_id ON public.mobilization_activists USING btree (mobilization_id, activist_id);


--
-- Name: index_mobilizations_on_community_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_mobilizations_on_community_id ON public.mobilizations USING btree (community_id);


--
-- Name: index_mobilizations_on_custom_domain; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_mobilizations_on_custom_domain ON public.mobilizations USING btree (custom_domain);


--
-- Name: index_mobilizations_on_slug; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_mobilizations_on_slug ON public.mobilizations USING btree (slug);


--
-- Name: index_notifications_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_notifications_on_activist_id ON public.notifications USING btree (activist_id);


--
-- Name: index_notifications_on_community_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_notifications_on_community_id ON public.notifications USING btree (community_id);


--
-- Name: index_notifications_on_notification_template_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_notifications_on_notification_template_id ON public.notifications USING btree (notification_template_id);


--
-- Name: index_payments_on_donation_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_payments_on_donation_id ON public.payments USING btree (donation_id);


--
-- Name: index_subscription_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_subscription_transitions_parent_most_recent ON public.subscription_transitions USING btree (subscription_id, most_recent) WHERE most_recent;


--
-- Name: index_subscription_transitions_parent_sort; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_subscription_transitions_parent_sort ON public.subscription_transitions USING btree (subscription_id, sort_key);


--
-- Name: index_subscriptions_on_activist_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_subscriptions_on_activist_id ON public.subscriptions USING btree (activist_id);


--
-- Name: index_subscriptions_on_community_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_subscriptions_on_community_id ON public.subscriptions USING btree (community_id);


--
-- Name: index_subscriptions_on_widget_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_subscriptions_on_widget_id ON public.subscriptions USING btree (widget_id);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type ON public.taggings USING btree (taggable_id, taggable_type);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);


--
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);


--
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_twilio_calls_on_widget_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_twilio_calls_on_widget_id ON public.twilio_calls USING btree (widget_id);


--
-- Name: index_twilio_configurations_on_community_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_twilio_configurations_on_community_id ON public.twilio_configurations USING btree (community_id);


--
-- Name: index_user_tags_on_user_id; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_user_tags_on_user_id ON public.user_tags USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_uid_and_provider; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX index_users_on_uid_and_provider ON public.users USING btree (uid, provider);


--
-- Name: notification_templates_label_uniq_idx; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX notification_templates_label_uniq_idx ON public.notification_templates USING btree (community_id, label, locale);


--
-- Name: ordasc_widgets; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX ordasc_widgets ON public.widgets USING btree (id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: uniq_email_acts; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX uniq_email_acts ON public.activists USING btree (lower(((email)::public.email)::text));


--
-- Name: uniq_m_page_access_token_idx; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX uniq_m_page_access_token_idx ON public.facebook_bot_configurations USING btree (messenger_page_access_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: monkey_user
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: users _RETURN; Type: RULE; Schema: postgraphql; Owner: monkey_user
--

CREATE RULE "_RETURN" AS
    ON SELECT TO postgraphql.users DO INSTEAD  SELECT u.id,
    u.provider,
    u.uid,
    u.encrypted_password,
    u.reset_password_token,
    u.reset_password_sent_at,
    u.remember_created_at,
    u.sign_in_count,
    u.current_sign_in_at,
    u.last_sign_in_at,
    u.current_sign_in_ip,
    u.last_sign_in_ip,
    u.confirmation_token,
    u.confirmed_at,
    u.confirmation_sent_at,
    u.unconfirmed_email,
    u.first_name,
    u.last_name,
    u.email,
    u.tokens,
    u.created_at,
    u.updated_at,
    u.avatar,
    u.admin,
    u.locale,
    COALESCE(json_agg(t.name), '[]'::json) AS tags
   FROM ((public.users u
     LEFT JOIN public.user_tags ut ON ((ut.user_id = u.id)))
     LEFT JOIN public.tags t ON ((t.id = ut.tag_id)))
  WHERE (u.id = (current_setting('jwt.claims.user_id'::text))::integer)
  GROUP BY u.id;


--
-- Name: agg_activists _RETURN; Type: RULE; Schema: public; Owner: monkey_user
--

CREATE RULE "_RETURN" AS
    ON SELECT TO public.agg_activists DO INSTEAD  SELECT com.id AS community_id,
    a.id AS activist_id,
    a.email,
    a.name,
    (((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS phone,
    agg_fe.count AS total_form_entries,
    agg_do.count AS total_donations,
    agg_ap.count AS total_pressures,
    ((agg_fe.count + agg_do.count) + agg_ap.count) AS total_actions,
    last_donation.transaction_status AS last_donation_status,
    (last_donation.amount / 100) AS last_donation_amount,
    last_donation.subscription AS last_donation_is_subscription,
    (last_customer.address OPERATOR(public.->) 'street'::text) AS address_street,
    (last_customer.address OPERATOR(public.->) 'street_number'::text) AS street_number,
    (last_customer.address OPERATOR(public.->) 'neighborhood'::text) AS neighborhood,
    (last_customer.address OPERATOR(public.->) 'complementary'::text) AS complementary,
    (last_customer.address OPERATOR(public.->) 'city'::text) AS city,
    (last_customer.address OPERATOR(public.->) 'state'::text) AS state
   FROM (((((((public.communities com
     JOIN public.community_activists cac ON ((cac.community_id = com.id)))
     JOIN public.activists a ON ((a.id = cac.activist_id)))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM (((public.form_entries fe
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((b.mobilization_id = m.id)))
          WHERE ((fe.activist_id = a.id) AND (m.community_id = com.id))) agg_fe ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM (((public.donations d
             JOIN public.widgets w ON ((w.id = d.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((b.mobilization_id = m.id)))
          WHERE (((d.transaction_status)::text = 'paid'::text) AND (d.activist_id = a.id) AND (m.community_id = com.id))) agg_do ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM (((public.activist_pressures ap
             JOIN public.widgets w ON ((w.id = ap.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((b.mobilization_id = m.id)))
          WHERE ((ap.activist_id = a.id) AND (m.community_id = com.id))) agg_ap ON (true))
     LEFT JOIN LATERAL ( SELECT (btrim((d2.customer OPERATOR(public.->) 'address'::text), '{}'::text))::public.hstore AS address
           FROM public.donations d2
          WHERE ((d2.activist_id = a.id) AND (d2.transaction_id IS NOT NULL) AND (d2.transaction_status IS NOT NULL) AND (d2.customer IS NOT NULL))
          ORDER BY d2.id DESC
         LIMIT 1) last_customer ON (true))
     LEFT JOIN LATERAL ( SELECT d2.id,
            d2.widget_id,
            d2.created_at,
            d2.updated_at,
            d2.token,
            d2.payment_method,
            d2.amount,
            d2.email,
            d2.card_hash,
            d2.customer,
            d2.skip,
            d2.transaction_id,
            d2.transaction_status,
            d2.subscription,
            d2.credit_card,
            d2.activist_id,
            d2.subscription_id,
            d2.period,
            d2.plan_id,
            d2.parent_id,
            d2.payables,
            d2.gateway_data,
            d2.payable_transfer_id,
            d2.converted_from
           FROM public.donations d2
          WHERE ((d2.activist_id = a.id) AND (d2.transaction_id IS NOT NULL) AND (d2.transaction_status IS NOT NULL))
          ORDER BY d2.id DESC
         LIMIT 1) last_donation ON (true))
  WHERE (a.id IS NOT NULL)
  GROUP BY com.id, a.email, a.id, last_donation.transaction_status, last_donation.amount, last_donation.subscription, last_customer.address, agg_fe.count, agg_do.count, agg_ap.count;


--
-- Name: activist_participations _RETURN; Type: RULE; Schema: public; Owner: monkey_user
--

CREATE RULE "_RETURN" AS
    ON SELECT TO public.activist_participations DO INSTEAD  SELECT c.id AS community_id,
    m.id AS mobilization_id,
    w.id AS widget_id,
    a.id AS activist_id,
    a.email,
    COALESCE(fe.created_at, d.created_at, ap.created_at, s.created_at) AS participate_at,
        CASE
            WHEN (fe.id IS NOT NULL) THEN 'form_entry'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NOT NULL)) THEN 'subscription'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NULL)) THEN 'donation'::text
            WHEN (ap.id IS NOT NULL) THEN 'activist_pressure'::text
            WHEN (s.id IS NOT NULL) THEN 'subscription'::text
            ELSE NULL::text
        END AS participate_kind,
    COALESCE(fe.id, d.id, ap.id, s.id) AS participate_id
   FROM ((((((((public.communities c
     JOIN public.mobilizations m ON ((m.community_id = c.id)))
     LEFT JOIN public.blocks b ON ((b.mobilization_id = m.id)))
     LEFT JOIN public.widgets w ON ((w.block_id = b.id)))
     LEFT JOIN public.form_entries fe ON ((fe.widget_id = w.id)))
     LEFT JOIN public.donations d ON (((d.widget_id = w.id) AND (NOT d.subscription))))
     LEFT JOIN public.subscriptions s ON ((s.widget_id = w.id)))
     LEFT JOIN public.activist_pressures ap ON ((ap.widget_id = w.id)))
     JOIN public.activists a ON ((a.id = COALESCE(fe.activist_id, d.activist_id, s.activist_id, ap.activist_id))))
  GROUP BY c.id, m.id, w.id, a.id, fe.id, s.id, ap.id, d.id, fe.created_at, s.created_at, ap.created_at, d.created_at;


--
-- Name: hdb_schema_update_event hdb_schema_update_event_notifier; Type: TRIGGER; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TRIGGER hdb_schema_update_event_notifier AFTER INSERT ON hdb_catalog.hdb_schema_update_event FOR EACH ROW EXECUTE PROCEDURE hdb_catalog.hdb_schema_update_event_notifier();


--
-- Name: hdb_table hdb_table_oid_check; Type: TRIGGER; Schema: hdb_catalog; Owner: monkey_user
--

CREATE TRIGGER hdb_table_oid_check BEFORE INSERT OR UPDATE ON hdb_catalog.hdb_table FOR EACH ROW EXECUTE PROCEDURE hdb_catalog.hdb_table_oid_check();


--
-- Name: form_entries generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.form_entries FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- Name: activist_pressures generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.activist_pressures FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- Name: donations generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.donations FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- Name: subscriptions generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.subscriptions FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- Name: mobilizations refresh_custom_domain_frontend; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER refresh_custom_domain_frontend AFTER INSERT OR UPDATE OF traefik_host_rule ON public.mobilizations FOR EACH ROW WHEN ((new.traefik_host_rule IS NOT NULL)) EXECUTE PROCEDURE public.refresh_custom_domain_frontend();


--
-- Name: activist_facebook_bot_interactions update_facebook_bot_activist_data; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER update_facebook_bot_activist_data AFTER INSERT OR UPDATE ON public.activist_facebook_bot_interactions FOR EACH ROW EXECUTE PROCEDURE public.update_facebook_bot_activists_full_text_index();


--
-- Name: form_entries watched_create_form_entries_trigger; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER watched_create_form_entries_trigger AFTER INSERT OR UPDATE ON public.form_entries FOR EACH ROW WHEN ((new.widget_id = ANY (ARRAY[16850, 17628, 17633]))) EXECUTE PROCEDURE public.notify_form_entries_trigger();


--
-- Name: twilio_configurations watched_create_twilio_configuration_trigger; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER watched_create_twilio_configuration_trigger AFTER INSERT OR UPDATE ON public.twilio_configurations FOR EACH ROW EXECUTE PROCEDURE public.notify_create_twilio_configuration_trigger();


--
-- Name: mobilizations watched_custom_domain; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER watched_custom_domain AFTER INSERT OR DELETE OR UPDATE ON public.mobilizations FOR EACH ROW EXECUTE PROCEDURE public.verify_custom_domain();


--
-- Name: twilio_calls watched_twilio_call_trigger; Type: TRIGGER; Schema: public; Owner: monkey_user
--

CREATE TRIGGER watched_twilio_call_trigger AFTER INSERT ON public.twilio_calls FOR EACH ROW EXECUTE PROCEDURE public.notify_twilio_call_trigger();


--
-- Name: event_invocation_logs event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.event_invocation_logs
    ADD CONSTRAINT event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.event_log(id);


--
-- Name: event_triggers event_triggers_schema_name_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.event_triggers
    ADD CONSTRAINT event_triggers_schema_name_fkey FOREIGN KEY (schema_name, table_name) REFERENCES hdb_catalog.hdb_table(table_schema, table_name) ON UPDATE CASCADE;


--
-- Name: hdb_allowlist hdb_allowlist_collection_name_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_allowlist
    ADD CONSTRAINT hdb_allowlist_collection_name_fkey FOREIGN KEY (collection_name) REFERENCES hdb_catalog.hdb_query_collection(collection_name);


--
-- Name: hdb_permission hdb_permission_table_schema_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_permission
    ADD CONSTRAINT hdb_permission_table_schema_fkey FOREIGN KEY (table_schema, table_name) REFERENCES hdb_catalog.hdb_table(table_schema, table_name) ON UPDATE CASCADE;


--
-- Name: hdb_relationship hdb_relationship_table_schema_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: monkey_user
--

ALTER TABLE ONLY hdb_catalog.hdb_relationship
    ADD CONSTRAINT hdb_relationship_table_schema_fkey FOREIGN KEY (table_schema, table_name) REFERENCES hdb_catalog.hdb_table(table_schema, table_name) ON UPDATE CASCADE;


--
-- Name: notification_templates fk_rails_015164fe8d; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT fk_rails_015164fe8d FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: mobilizations fk_rails_0786dde5c3; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT fk_rails_0786dde5c3 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: subscriptions fk_rails_0ded3585f1; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_0ded3585f1 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: facebook_bot_campaign_activists fk_rails_0ff272a657; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT fk_rails_0ff272a657 FOREIGN KEY (facebook_bot_activist_id) REFERENCES public.facebook_bot_activists(id);


--
-- Name: activist_matches fk_rails_26ca62b2d0; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT fk_rails_26ca62b2d0 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: notifications fk_rails_2fb35253bd; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_2fb35253bd FOREIGN KEY (notification_template_id) REFERENCES public.notification_templates(id);


--
-- Name: recipients fk_rails_35bdfe7f89; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.recipients
    ADD CONSTRAINT fk_rails_35bdfe7f89 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: subscriptions fk_rails_3bd353c401; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_3bd353c401 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: activist_pressures fk_rails_3ff765ac30; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_3ff765ac30 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- Name: activist_tags fk_rails_4d2ba73b48; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT fk_rails_4d2ba73b48 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: notifications fk_rails_4ea5195391; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_4ea5195391 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: matches fk_rails_5238d1bbc9; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT fk_rails_5238d1bbc9 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- Name: subscriptions fk_rails_5c907257ba; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_5c907257ba FOREIGN KEY (gateway_subscription_id) REFERENCES public.gateway_subscriptions(id);


--
-- Name: subscriptions fk_rails_61f00b3de3; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_61f00b3de3 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- Name: addresses fk_rails_64d1e99667; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fk_rails_64d1e99667 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: activist_pressures fk_rails_67eb37c69b; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_67eb37c69b FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);


--
-- Name: facebook_bot_campaign_activists fk_rails_6ed0c7457d; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT fk_rails_6ed0c7457d FOREIGN KEY (facebook_bot_campaign_id) REFERENCES public.facebook_bot_campaigns(id);


--
-- Name: donations fk_rails_7217bc1bdf; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_7217bc1bdf FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);


--
-- Name: activist_matches fk_rails_7701a28e7f; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT fk_rails_7701a28e7f FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- Name: activist_pressures fk_rails_7e28014775; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_7e28014775 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: mobilization_activists fk_rails_821106ac31; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT fk_rails_821106ac31 FOREIGN KEY (mobilization_id) REFERENCES public.mobilizations(id);


--
-- Name: activist_facebook_bot_interactions fk_rails_8229429c26; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT fk_rails_8229429c26 FOREIGN KEY (facebook_bot_configuration_id) REFERENCES public.facebook_bot_configurations(id);


--
-- Name: twilio_calls fk_rails_8329ec7002; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.twilio_calls
    ADD CONSTRAINT fk_rails_8329ec7002 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- Name: notifications fk_rails_893eb4f32e; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_893eb4f32e FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: form_entries fk_rails_920c5d67ae; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_920c5d67ae FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);


--
-- Name: donations fk_rails_9279978f7a; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_9279978f7a FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- Name: donations fk_rails_98e396f4c1; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_98e396f4c1 FOREIGN KEY (local_subscription_id) REFERENCES public.subscriptions(id);


--
-- Name: mobilization_activists fk_rails_9c54902f75; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT fk_rails_9c54902f75 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: community_activists fk_rails_a007365593; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT fk_rails_a007365593 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: communities fk_rails_a268b06370; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_a268b06370 FOREIGN KEY (recipient_id) REFERENCES public.recipients(id);


--
-- Name: donations fk_rails_aaa30ab12e; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_aaa30ab12e FOREIGN KEY (payable_transfer_id) REFERENCES public.payable_transfers(id);


--
-- Name: notifications fk_rails_b080fb4855; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_b080fb4855 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: activist_facebook_bot_interactions fk_rails_b2d73f1a99; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT fk_rails_b2d73f1a99 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: facebook_bot_campaigns fk_rails_b518e26154; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.facebook_bot_campaigns
    ADD CONSTRAINT fk_rails_b518e26154 FOREIGN KEY (facebook_bot_configuration_id) REFERENCES public.facebook_bot_configurations(id);


--
-- Name: donations fk_rails_c1941efec9; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_c1941efec9 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: dns_hosted_zones fk_rails_c6b1f8b17a; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT fk_rails_c6b1f8b17a FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: invitations fk_rails_c70c9be1c0; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_c70c9be1c0 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: form_entries fk_rails_cbe3790222; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_cbe3790222 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- Name: dns_records fk_rails_ce2c3e0b71; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT fk_rails_ce2c3e0b71 FOREIGN KEY (dns_hosted_zone_id) REFERENCES public.dns_hosted_zones(id);


--
-- Name: balance_operations fk_rails_cee230e2a2; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.balance_operations
    ADD CONSTRAINT fk_rails_cee230e2a2 FOREIGN KEY (recipient_id) REFERENCES public.recipients(id);


--
-- Name: form_entries fk_rails_db28a0ad48; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_db28a0ad48 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- Name: activist_tags fk_rails_e8fa6ecb6c; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT fk_rails_e8fa6ecb6c FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: user_tags fk_rails_ea0382482a; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT fk_rails_ea0382482a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: community_activists fk_rails_fa4f63f07b; Type: FK CONSTRAINT; Schema: public; Owner: monkey_user
--

ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT fk_rails_fa4f63f07b FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- Name: postgraphile_watch_ddl; Type: EVENT TRIGGER; Schema: -; Owner: monkey_user
--

CREATE EVENT TRIGGER postgraphile_watch_ddl ON ddl_command_end
         WHEN TAG IN ('ALTER DOMAIN', 'ALTER FOREIGN TABLE', 'ALTER FUNCTION', 'ALTER SCHEMA', 'ALTER TABLE', 'ALTER TYPE', 'ALTER VIEW', 'COMMENT', 'CREATE DOMAIN', 'CREATE FOREIGN TABLE', 'CREATE FUNCTION', 'CREATE SCHEMA', 'CREATE TABLE', 'CREATE TABLE AS', 'CREATE VIEW', 'DROP DOMAIN', 'DROP FOREIGN TABLE', 'DROP FUNCTION', 'DROP SCHEMA', 'DROP TABLE', 'DROP VIEW', 'GRANT', 'REVOKE', 'SELECT INTO')
   EXECUTE PROCEDURE postgraphile_watch.notify_watchers_ddl();


ALTER EVENT TRIGGER postgraphile_watch_ddl OWNER TO monkey_user;

--
-- Name: postgraphile_watch_drop; Type: EVENT TRIGGER; Schema: -; Owner: monkey_user
--

CREATE EVENT TRIGGER postgraphile_watch_drop ON sql_drop
   EXECUTE PROCEDURE postgraphile_watch.notify_watchers_drop();


ALTER EVENT TRIGGER postgraphile_watch_drop OWNER TO monkey_user;

--
-- Name: SCHEMA microservices; Type: ACL; Schema: -; Owner: monkey_user
--

GRANT USAGE ON SCHEMA microservices TO microservices;


--
-- Name: SCHEMA pgjwt; Type: ACL; Schema: -; Owner: monkey_user
--

GRANT USAGE ON SCHEMA pgjwt TO microservices;
GRANT USAGE ON SCHEMA pgjwt TO postgraphql;
GRANT USAGE ON SCHEMA pgjwt TO anonymous;


--
-- Name: SCHEMA postgraphql; Type: ACL; Schema: -; Owner: monkey_user
--

GRANT USAGE ON SCHEMA postgraphql TO anonymous;
GRANT USAGE ON SCHEMA postgraphql TO common_user;
GRANT USAGE ON SCHEMA postgraphql TO admin;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: monkey_user
--

GRANT USAGE ON SCHEMA public TO admin;
GRANT USAGE ON SCHEMA public TO postgraphql;
GRANT USAGE ON SCHEMA public TO common_user;
GRANT USAGE ON SCHEMA public TO anonymous;
GRANT USAGE ON SCHEMA public TO microservices;


--
-- Name: FUNCTION create_community_dns(data json); Type: ACL; Schema: microservices; Owner: monkey_user
--

GRANT ALL ON FUNCTION microservices.create_community_dns(data json) TO microservices;
GRANT ALL ON FUNCTION microservices.create_community_dns(data json) TO postgraphql;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.users TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO admin;
GRANT SELECT ON TABLE public.users TO microservices;
GRANT SELECT,INSERT,UPDATE ON TABLE public.users TO anonymous;


--
-- Name: TABLE twilio_calls; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_calls TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_calls TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_calls TO anonymous;


--
-- Name: TABLE twilio_calls; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_calls TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_calls TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_calls TO anonymous;


--
-- Name: TABLE twilio_configurations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_configurations TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_configurations TO common_user;


--
-- Name: FUNCTION change_password(data json); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.change_password(data json) TO common_user;
GRANT ALL ON FUNCTION postgraphql.change_password(data json) TO admin;
GRANT ALL ON FUNCTION postgraphql.change_password(data json) TO anonymous;


--
-- Name: TABLE invitations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.invitations TO anonymous;
GRANT SELECT ON TABLE public.invitations TO common_user;
GRANT SELECT ON TABLE public.invitations TO admin;
GRANT SELECT ON TABLE public.invitations TO postgraphql;


--
-- Name: FUNCTION create_community(data json); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.create_community(data json) TO common_user;
GRANT ALL ON FUNCTION postgraphql.create_community(data json) TO admin;
GRANT ALL ON FUNCTION postgraphql.create_community(data json) TO anonymous;


--
-- Name: FUNCTION create_dns_record(data json); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.create_dns_record(data json) TO postgraphql;


--
-- Name: TABLE facebook_bot_campaigns; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaigns TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaigns TO common_user;


--
-- Name: FUNCTION create_tags(name text, label text); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.create_tags(name text, label text) TO common_user;
GRANT ALL ON FUNCTION postgraphql.create_tags(name text, label text) TO admin;
GRANT ALL ON FUNCTION postgraphql.create_tags(name text, label text) TO postgraphql;


--
-- Name: FUNCTION create_user_tags(data json); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.create_user_tags(data json) TO common_user;
GRANT ALL ON FUNCTION postgraphql.create_user_tags(data json) TO admin;
GRANT ALL ON FUNCTION postgraphql.create_user_tags(data json) TO postgraphql;


--
-- Name: TABLE users; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.users TO common_user;


--
-- Name: TABLE template_mobilizations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.template_mobilizations TO common_user;


--
-- Name: TABLE activist_tags; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.activist_tags TO common_user;
GRANT SELECT,INSERT ON TABLE public.activist_tags TO admin;


--
-- Name: TABLE taggings; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.taggings TO common_user;
GRANT SELECT,INSERT ON TABLE public.taggings TO admin;


--
-- Name: TABLE tags; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.tags TO common_user;
GRANT SELECT,INSERT,UPDATE ON TABLE public.tags TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.tags TO postgraphql;


--
-- Name: TABLE community_tags; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.community_tags TO common_user;
GRANT SELECT ON TABLE public.community_tags TO admin;


--
-- Name: TABLE community_tags; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.community_tags TO common_user;
GRANT SELECT ON TABLE postgraphql.community_tags TO admin;


--
-- Name: FUNCTION get_widget_donation_stats(widget_id integer); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) TO anonymous;


--
-- Name: FUNCTION mobilizations(days integer); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.mobilizations(days integer) TO common_user;
GRANT ALL ON FUNCTION postgraphql.mobilizations(days integer) TO admin;
GRANT ALL ON FUNCTION postgraphql.mobilizations(days integer) TO postgraphql;


--
-- Name: TABLE communities; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.communities TO common_user;
GRANT SELECT,INSERT ON TABLE public.communities TO admin;
GRANT SELECT ON TABLE public.communities TO microservices;


--
-- Name: TABLE communities; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.communities TO common_user;
GRANT SELECT ON TABLE postgraphql.communities TO admin;
GRANT SELECT ON TABLE postgraphql.communities TO postgraphql;


--
-- Name: TABLE mobilizations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.mobilizations TO common_user;
GRANT SELECT ON TABLE public.mobilizations TO admin;
GRANT SELECT ON TABLE public.mobilizations TO postgraphql;


--
-- Name: TABLE mobilizations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.mobilizations TO common_user;
GRANT SELECT ON TABLE postgraphql.mobilizations TO admin;
GRANT SELECT ON TABLE postgraphql.mobilizations TO postgraphql;


--
-- Name: FUNCTION reset_password_change_password(new_password text, token text); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.reset_password_change_password(new_password text, token text) TO anonymous;


--
-- Name: FUNCTION reset_password_token_verify(token text); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.reset_password_token_verify(token text) TO anonymous;


--
-- Name: TABLE activists; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.activists TO admin;
GRANT SELECT,INSERT ON TABLE public.activists TO common_user;


--
-- Name: TABLE community_activists; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.community_activists TO common_user;
GRANT SELECT,INSERT ON TABLE public.community_activists TO admin;


--
-- Name: TABLE community_users; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.community_users TO common_user;
GRANT SELECT,INSERT ON TABLE public.community_users TO admin;
GRANT SELECT,INSERT ON TABLE public.community_users TO anonymous;
GRANT SELECT,INSERT ON TABLE public.community_users TO postgraphql;


--
-- Name: TABLE activists; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.activists TO common_user;
GRANT SELECT ON TABLE postgraphql.activists TO admin;


--
-- Name: FUNCTION total_sum_transfer_operations_from_community(community_id integer); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) TO common_user;
GRANT ALL ON FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) TO admin;


--
-- Name: TABLE facebook_bot_campaign_activists; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaign_activists TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaign_activists TO common_user;


--
-- Name: TABLE user_mobilizations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.user_mobilizations TO common_user;
GRANT SELECT ON TABLE postgraphql.user_mobilizations TO admin;


--
-- Name: FUNCTION user_mobilizations_community(m postgraphql.user_mobilizations); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.user_mobilizations_community(m postgraphql.user_mobilizations) TO common_user;
GRANT ALL ON FUNCTION postgraphql.user_mobilizations_community(m postgraphql.user_mobilizations) TO admin;


--
-- Name: FUNCTION user_mobilizations_score(m postgraphql.user_mobilizations); Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT ALL ON FUNCTION postgraphql.user_mobilizations_score(m postgraphql.user_mobilizations) TO common_user;
GRANT ALL ON FUNCTION postgraphql.user_mobilizations_score(m postgraphql.user_mobilizations) TO admin;


--
-- Name: FUNCTION configuration(name text); Type: ACL; Schema: public; Owner: monkey_user
--

GRANT ALL ON FUNCTION public.configuration(name text) TO microservices;
GRANT ALL ON FUNCTION public.configuration(name text) TO postgraphql;
GRANT ALL ON FUNCTION public.configuration(name text) TO anonymous;


--
-- Name: TABLE donations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.donations TO common_user;
GRANT SELECT ON TABLE public.donations TO admin;
GRANT SELECT ON TABLE public.donations TO anonymous;


--
-- Name: TABLE subscriptions; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.subscriptions TO common_user;
GRANT SELECT ON TABLE public.subscriptions TO admin;


--
-- Name: FUNCTION verify_custom_domain(); Type: ACL; Schema: public; Owner: monkey_user
--

GRANT ALL ON FUNCTION public.verify_custom_domain() TO postgraphql;
GRANT ALL ON FUNCTION public.verify_custom_domain() TO admin;
GRANT ALL ON FUNCTION public.verify_custom_domain() TO microservices;


--
-- Name: TABLE certificates; Type: ACL; Schema: microservices; Owner: monkey_user
--

GRANT SELECT ON TABLE microservices.certificates TO microservices;


--
-- Name: TABLE communities; Type: ACL; Schema: microservices; Owner: monkey_user
--

GRANT SELECT ON TABLE microservices.communities TO microservices;


--
-- Name: TABLE dns_hosted_zones; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.dns_hosted_zones TO microservices;


--
-- Name: TABLE dns_hosted_zones; Type: ACL; Schema: microservices; Owner: monkey_user
--

GRANT SELECT ON TABLE microservices.dns_hosted_zones TO microservices;


--
-- Name: TABLE mobilizations; Type: ACL; Schema: microservices; Owner: monkey_user
--

GRANT SELECT ON TABLE microservices.mobilizations TO microservices;


--
-- Name: TABLE notification_templates; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.notification_templates TO anonymous;
GRANT SELECT ON TABLE public.notification_templates TO common_user;
GRANT SELECT ON TABLE public.notification_templates TO admin;
GRANT SELECT ON TABLE public.notification_templates TO microservices;


--
-- Name: TABLE notification_templates; Type: ACL; Schema: microservices; Owner: monkey_user
--

GRANT SELECT ON TABLE microservices.notification_templates TO microservices;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.notifications TO anonymous;
GRANT SELECT,INSERT ON TABLE public.notifications TO common_user;
GRANT SELECT,INSERT ON TABLE public.notifications TO admin;
GRANT SELECT ON TABLE public.notifications TO microservices;


--
-- Name: TABLE notifications; Type: ACL; Schema: microservices; Owner: monkey_user
--

GRANT SELECT ON TABLE microservices.notifications TO microservices;


--
-- Name: TABLE activist_facebook_bot_interactions; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.activist_facebook_bot_interactions TO admin;


--
-- Name: TABLE facebook_bot_configurations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_configurations TO admin;


--
-- Name: TABLE mobilization_activists; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.mobilization_activists TO common_user;
GRANT SELECT ON TABLE public.mobilization_activists TO admin;


--
-- Name: TABLE activist_mobilizations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.activist_mobilizations TO common_user;
GRANT SELECT ON TABLE postgraphql.activist_mobilizations TO admin;


--
-- Name: TABLE activist_tags; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.activist_tags TO admin;
GRANT SELECT ON TABLE postgraphql.activist_tags TO common_user;


--
-- Name: TABLE balance_operations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.balance_operations TO common_user;
GRANT SELECT ON TABLE public.balance_operations TO admin;


--
-- Name: TABLE balance_operation_summaries; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.balance_operation_summaries TO common_user;
GRANT SELECT ON TABLE public.balance_operation_summaries TO admin;


--
-- Name: TABLE balance_operations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.balance_operations TO common_user;
GRANT SELECT ON TABLE postgraphql.balance_operations TO admin;


--
-- Name: TABLE facebook_activist_interactions; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.facebook_activist_interactions TO admin;
GRANT SELECT ON TABLE postgraphql.facebook_activist_interactions TO common_user;
GRANT SELECT ON TABLE postgraphql.facebook_activist_interactions TO anonymous;


--
-- Name: TABLE bot_recipients; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.bot_recipients TO admin;


--
-- Name: TABLE community_user_roles; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.community_user_roles TO common_user;
GRANT SELECT ON TABLE postgraphql.community_user_roles TO admin;


--
-- Name: TABLE blocks; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.blocks TO common_user;
GRANT SELECT ON TABLE public.blocks TO admin;


--
-- Name: TABLE widgets; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.widgets TO common_user;
GRANT SELECT ON TABLE public.widgets TO admin;
GRANT SELECT ON TABLE public.widgets TO anonymous;


--
-- Name: TABLE donations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.donations TO common_user;
GRANT SELECT ON TABLE postgraphql.donations TO admin;


--
-- Name: TABLE facebook_bot_configurations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.facebook_bot_configurations TO admin;


--
-- Name: TABLE facebook_bot_interactions; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.facebook_bot_interactions TO admin;
GRANT SELECT ON TABLE postgraphql.facebook_bot_interactions TO common_user;
GRANT SELECT ON TABLE postgraphql.facebook_bot_interactions TO anonymous;


--
-- Name: TABLE activist_participations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.activist_participations TO common_user;
GRANT SELECT ON TABLE public.activist_participations TO admin;


--
-- Name: TABLE participations; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.participations TO common_user;
GRANT SELECT ON TABLE postgraphql.participations TO admin;


--
-- Name: TABLE tags; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.tags TO postgraphql;
GRANT SELECT ON TABLE postgraphql.tags TO common_user;
GRANT SELECT ON TABLE postgraphql.tags TO admin;


--
-- Name: TABLE user_communities; Type: ACL; Schema: postgraphql; Owner: monkey_user
--

GRANT SELECT ON TABLE postgraphql.user_communities TO common_user;
GRANT SELECT ON TABLE postgraphql.user_communities TO admin;


--
-- Name: TABLE activist_pressures; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.activist_pressures TO common_user;
GRANT SELECT ON TABLE public.activist_pressures TO admin;


--
-- Name: TABLE form_entries; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.form_entries TO common_user;
GRANT SELECT ON TABLE public.form_entries TO admin;


--
-- Name: TABLE activist_actions; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.activist_actions TO common_user;
GRANT SELECT ON TABLE public.activist_actions TO admin;
GRANT SELECT ON TABLE public.activist_actions TO postgraphql;


--
-- Name: SEQUENCE activist_facebook_bot_interactions_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.activist_facebook_bot_interactions_id_seq TO admin;


--
-- Name: SEQUENCE activist_tags_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.activist_tags_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.activist_tags_id_seq TO admin;


--
-- Name: SEQUENCE activists_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.activists_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.activists_id_seq TO postgraphql;
GRANT USAGE ON SEQUENCE public.activists_id_seq TO admin;


--
-- Name: SEQUENCE communities_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.communities_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.communities_id_seq TO admin;


--
-- Name: SEQUENCE community_activists_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.community_activists_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.community_activists_id_seq TO admin;


--
-- Name: SEQUENCE community_users_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.community_users_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.community_users_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.community_users_id_seq TO anonymous;
GRANT USAGE ON SEQUENCE public.community_users_id_seq TO postgraphql;


--
-- Name: TABLE configurations; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT ON TABLE public.configurations TO microservices;
GRANT SELECT ON TABLE public.configurations TO postgraphql;
GRANT SELECT ON TABLE public.configurations TO anonymous;


--
-- Name: SEQUENCE dns_hosted_zones_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.dns_hosted_zones_id_seq TO microservices;


--
-- Name: TABLE dns_records; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT ON TABLE public.dns_records TO admin;
GRANT SELECT,INSERT ON TABLE public.dns_records TO microservices;
GRANT SELECT,INSERT ON TABLE public.dns_records TO postgraphql;


--
-- Name: SEQUENCE dns_records_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.dns_records_id_seq TO postgraphql;
GRANT USAGE ON SEQUENCE public.dns_records_id_seq TO microservices;
GRANT USAGE ON SEQUENCE public.dns_records_id_seq TO admin;


--
-- Name: TABLE facebook_bot_activists; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_activists TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_activists TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_activists TO anonymous;


--
-- Name: SEQUENCE facebook_bot_activists_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.facebook_bot_activists_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.facebook_bot_activists_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.facebook_bot_activists_id_seq TO anonymous;


--
-- Name: SEQUENCE facebook_bot_campaign_activists_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.facebook_bot_campaign_activists_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.facebook_bot_campaign_activists_id_seq TO common_user;


--
-- Name: SEQUENCE facebook_bot_campaigns_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.facebook_bot_campaigns_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.facebook_bot_campaigns_id_seq TO common_user;


--
-- Name: SEQUENCE facebook_bot_configurations_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.facebook_bot_configurations_id_seq TO admin;


--
-- Name: SEQUENCE notifications_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.notifications_id_seq TO anonymous;
GRANT USAGE ON SEQUENCE public.notifications_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.notifications_id_seq TO admin;


--
-- Name: SEQUENCE taggings_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.taggings_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.taggings_id_seq TO admin;


--
-- Name: SEQUENCE tags_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.tags_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.tags_id_seq TO admin;


--
-- Name: TABLE twilio_call_transitions; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_call_transitions TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_call_transitions TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_call_transitions TO anonymous;


--
-- Name: SEQUENCE twilio_calls_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.twilio_calls_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.twilio_calls_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.twilio_calls_id_seq TO anonymous;


--
-- Name: SEQUENCE twilio_configurations_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.twilio_configurations_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.twilio_configurations_id_seq TO common_user;


--
-- Name: TABLE user_tags; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.user_tags TO common_user;
GRANT SELECT,INSERT,UPDATE ON TABLE public.user_tags TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.user_tags TO postgraphql;


--
-- Name: SEQUENCE user_tags_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.user_tags_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.user_tags_id_seq TO admin;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: monkey_user
--

GRANT USAGE ON SEQUENCE public.users_id_seq TO anonymous;
GRANT USAGE ON SEQUENCE public.users_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.users_id_seq TO admin;


--
-- PostgreSQL database dump complete
--

\connect monkey_db

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.14
-- Dumped by pg_dump version 9.6.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.14
-- Dumped by pg_dump version 9.6.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: monkey_user
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.14
-- Dumped by pg_dump version 9.6.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: monkey_user
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

