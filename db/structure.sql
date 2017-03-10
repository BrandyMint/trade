--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: add_current_user_to_transaction(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION add_current_user_to_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.username := current_user;
  RETURN NEW;
END
$$;


--
-- Name: constraint_accounts_currency_in_transactions(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION constraint_accounts_currency_in_transactions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.from_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (from #%) has wrong currency', NEW.from_account_id;
  END IF;

  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.to_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (to #%) has wrong currency', NEW.to_account_id;
  END IF;

  return NEW;
END

$$;


--
-- Name: constraint_transaction_ownership(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION constraint_transaction_ownership() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM id FROM OPENBILL_ACCOUNTS WHERE id = NEW.from_account_id and (owner_id = NEW.owner_id OR (owner_id is NULL and NEW.owner_id is NULL) );
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No such source account in this owner (to #%)', NEW.owner_id;
  END IF;

  PERFORM id FROM OPENBILL_ACCOUNTS WHERE id = NEW.to_account_id and (owner_id = NEW.owner_id OR (owner_id is NULL and NEW.owner_id is NULL) );
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No such destination account in this owner (to #%)', NEW.owner_id;
  END IF;


  return NEW;
END

$$;


--
-- Name: disable_delete_account(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION disable_delete_account() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'Cannot delete account';
END

$$;


--
-- Name: disable_update_account(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION disable_update_account() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  query text;
BEGIN
  IF current_query() like 'insert into OPENBILL_TRANSACTIONS%' THEN
    RETURN NEW;
  ELSE
    RAISE EXCEPTION 'Cannot directly update amount_cents and timestamps of account with query (#%)', current_query();
  END IF;
END

$$;


--
-- Name: notify_transaction(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION notify_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM pg_notify('openbill_transactions', CAST(NEW.id AS text));

  return NEW;
END

$$;


--
-- Name: openbill_transaction_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION openbill_transaction_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.to_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.from_account_id;

  return OLD;
END

$$;


--
-- Name: openbill_transaction_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION openbill_transaction_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.to_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.to_account_id;

  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + OLD.amount_cents, transactions_count = transactions_count - 1 WHERE id = OLD.from_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.from_account_id;

  return NEW;
END

$$;


--
-- Name: process_account_transaction(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION process_account_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- У всех счетов и транзакции должна быть одинаковая валюта

  IF NEW.operation_id IS NOT NULL THEN
    PERFORM * FROM OPENBIL_OPERATIONS WHERE ID = NEW.operation_id AND from_account_id = NEW.from_account_id AND to_account_id = NEW.to_account_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Operation (#%) has wrong accounts', NEW.operation_id;
    END IF;

  END IF;

  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.from_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (from #%) has wrong currency', NEW.from_account_id;
  END IF;

  PERFORM * FROM OPENBILL_ACCOUNTS where id = NEW.to_account_id and amount_currency = NEW.amount_currency;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (to #%) has wrong currency', NEW.to_account_id;
  END IF;

  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents - NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.from_account_id;
  UPDATE OPENBILL_ACCOUNTS SET amount_cents = amount_cents + NEW.amount_cents, transactions_count = transactions_count + 1 WHERE id = NEW.to_account_id;

  return NEW;
END

$$;


--
-- Name: process_reverse_transaction(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION process_reverse_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.reverse_transaction_id IS NOT NULL THEN
    PERFORM * FROM openbill_transactions
      WHERE amount_cents = NEW.amount_cents 
        AND amount_currency = NEW.amount_currency 
        AND from_account_id = NEW.to_account_id
        AND to_account_id = NEW.from_account_id
        AND id = NEW.reverse_transaction_id;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Not found reverse transaction with same accounts and amount (#%)', NEW.reverse_transaction_id;
    END IF;

  END IF;

  return NEW;
END

$$;


--
-- Name: restrict_transaction(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION restrict_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _from_category_id uuid;
  _to_category_id uuid;
BEGIN
  SELECT category_id FROM OPENBILL_ACCOUNTS where id = NEW.from_account_id INTO _from_category_id;
  SELECT category_id FROM OPENBILL_ACCOUNTS where id = NEW.to_account_id INTO _to_category_id;
  PERFORM * FROM OPENBILL_POLICIES WHERE 
    (
      NEW.reverse_transaction_id is null AND
      (from_category_id is null OR from_category_id = _from_category_id) AND
      (to_category_id is null OR to_category_id = _to_category_id) AND
      (from_account_id is null OR from_account_id = NEW.from_account_id) AND
      (to_account_id is null OR to_account_id = NEW.to_account_id)
    ) OR
    (
      NEW.reverse_transaction_id is not null AND
      (to_category_id is null OR to_category_id = _from_category_id) AND
      (from_category_id is null OR from_category_id = _to_category_id) AND
      (to_account_id is null OR to_account_id = NEW.from_account_id) AND
      (from_account_id is null OR from_account_id = NEW.to_account_id) AND
      allow_reverse
    );

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No policy for this transaction';
  END IF;

  RETURN NEW;
END

$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: banners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE banners (
    id integer NOT NULL,
    subject character varying NOT NULL,
    text text,
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE banners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE banners_id_seq OWNED BY banners.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    title character varying NOT NULL,
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    goods_count integer DEFAULT 0 NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE companies (
    id integer NOT NULL,
    user_id integer NOT NULL,
    form character varying DEFAULT 'company'::character varying NOT NULL,
    name character varying NOT NULL,
    ogrn character varying NOT NULL,
    inn character varying NOT NULL,
    kpp character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id uuid NOT NULL,
    workflow_state character varying,
    reject_message text,
    short_name character varying,
    management_post character varying,
    management_name character varying,
    address character varying,
    phone character varying,
    documents_count integer DEFAULT 0 NOT NULL,
    goods_count integer DEFAULT 0 NOT NULL,
    email character varying,
    locked_account_id uuid,
    awaiting_review_at timestamp without time zone,
    being_reviewed_at timestamp without time zone,
    accepted_at timestamp without time zone,
    rejected_at timestamp without time zone,
    moderator_id integer,
    orders_count integer DEFAULT 0 NOT NULL
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: company_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE company_documents (
    id integer NOT NULL,
    company_id integer NOT NULL,
    file character varying NOT NULL,
    state character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category character varying NOT NULL,
    file_size bigint NOT NULL,
    content_type character varying NOT NULL,
    original_filename character varying
);


--
-- Name: company_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE company_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE company_documents_id_seq OWNED BY company_documents.id;


--
-- Name: good_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE good_images (
    id integer NOT NULL,
    good_id integer NOT NULL,
    image character varying NOT NULL,
    file_size bigint NOT NULL,
    content_type character varying NOT NULL,
    width integer,
    height integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: good_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE good_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: good_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE good_images_id_seq OWNED BY good_images.id;


--
-- Name: goods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE goods (
    id integer NOT NULL,
    company_id integer NOT NULL,
    category_id integer NOT NULL,
    state_cd integer DEFAULT 0 NOT NULL,
    title character varying NOT NULL,
    details text,
    price numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image character varying,
    prepayment_required boolean DEFAULT true NOT NULL,
    workflow_state character varying DEFAULT 'draft'::character varying NOT NULL,
    is_company_verified boolean DEFAULT false NOT NULL
);


--
-- Name: goods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goods_id_seq OWNED BY goods.id;


--
-- Name: openbill_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE openbill_accounts (
    owner_id uuid,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    category_id uuid NOT NULL,
    key character varying(256) DEFAULT uuid_generate_v4() NOT NULL,
    amount_cents numeric DEFAULT 0 NOT NULL,
    amount_currency character(3) DEFAULT 'RUB'::bpchar NOT NULL,
    details text,
    transactions_count integer DEFAULT 0 NOT NULL,
    meta hstore DEFAULT ''::hstore NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: openbill_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE openbill_categories (
    owner_id uuid,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(256) NOT NULL,
    parent_id uuid
);


--
-- Name: openbill_lockings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE openbill_lockings (
    id integer NOT NULL,
    seller_id integer NOT NULL,
    buyer_id integer NOT NULL,
    good_id integer NOT NULL,
    locking_transaction_id uuid NOT NULL,
    reverse_transaction_id uuid,
    buy_transaction_id uuid,
    workflow_state character varying NOT NULL,
    amount_cents numeric NOT NULL,
    amount_currency character varying(3) DEFAULT 'RUB'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    order_id integer NOT NULL
);


--
-- Name: openbill_lockings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE openbill_lockings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: openbill_lockings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE openbill_lockings_id_seq OWNED BY openbill_lockings.id;


--
-- Name: openbill_operations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE openbill_operations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    from_account_id uuid NOT NULL,
    to_account_id uuid NOT NULL,
    owner_id uuid,
    key character varying(256) NOT NULL,
    details text NOT NULL,
    meta hstore DEFAULT ''::hstore NOT NULL
);


--
-- Name: openbill_policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE openbill_policies (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(256) NOT NULL,
    from_category_id uuid,
    to_category_id uuid,
    from_account_id uuid,
    to_account_id uuid,
    allow_reverse boolean DEFAULT true NOT NULL
);


--
-- Name: openbill_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE openbill_transactions (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    operation_id uuid,
    owner_id uuid,
    user_id integer NOT NULL,
    username character varying(255) NOT NULL,
    date date DEFAULT ('now'::text)::date NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    from_account_id uuid NOT NULL,
    to_account_id uuid NOT NULL,
    amount_cents numeric NOT NULL,
    amount_currency character(3) NOT NULL,
    key character varying(256) NOT NULL,
    details text NOT NULL,
    meta hstore DEFAULT ''::hstore NOT NULL,
    reverse_transaction_id uuid,
    CONSTRAINT different_accounts CHECK ((to_account_id <> from_account_id)),
    CONSTRAINT positive CHECK ((amount_cents > (0)::numeric))
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    company_id integer NOT NULL,
    good_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    workflow_state character varying DEFAULT 'actual'::character varying NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: outcome_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE outcome_orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    company_id integer NOT NULL,
    workflow_state character varying NOT NULL,
    manager_id integer,
    transaction_uuid uuid,
    requisite_id integer NOT NULL,
    reject_message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    amount_cents integer NOT NULL,
    amount_currency character varying DEFAULT 'RUB'::character varying NOT NULL
);


--
-- Name: outcome_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE outcome_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outcome_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE outcome_orders_id_seq OWNED BY outcome_orders.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pages (
    id integer NOT NULL,
    title character varying NOT NULL,
    row_order integer NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    text text NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: passport_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE passport_images (
    id integer NOT NULL,
    user_id integer,
    image character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: passport_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE passport_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passport_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE passport_images_id_seq OWNED BY passport_images.id;


--
-- Name: requisites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE requisites (
    id integer NOT NULL,
    bik character varying NOT NULL,
    inn character varying NOT NULL,
    kpp character varying,
    account_number character varying,
    poluchatel character varying NOT NULL,
    details text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ks_number character varying
);


--
-- Name: requisites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE requisites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: requisites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE requisites_id_seq OWNED BY requisites.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying NOT NULL,
    crypted_password character varying,
    salt character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    remember_me_token character varying,
    remember_me_token_expires_at timestamp without time zone,
    reset_password_token character varying,
    reset_password_token_expires_at timestamp without time zone,
    reset_password_email_sent_at timestamp without time zone,
    last_login_at timestamp without time zone,
    last_logout_at timestamp without time zone,
    last_activity_at timestamp without time zone,
    last_login_from_ip_address character varying,
    inn character varying,
    failed_logins_count integer DEFAULT 0,
    lock_expires_at timestamp without time zone,
    unlock_token character varying,
    role character varying DEFAULT 'user'::character varying NOT NULL,
    shown_banners integer[] DEFAULT '{}'::integer[] NOT NULL,
    companies_count integer DEFAULT 0 NOT NULL,
    orders_count integer DEFAULT 0 NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: banners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY banners ALTER COLUMN id SET DEFAULT nextval('banners_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: company_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_documents ALTER COLUMN id SET DEFAULT nextval('company_documents_id_seq'::regclass);


--
-- Name: good_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY good_images ALTER COLUMN id SET DEFAULT nextval('good_images_id_seq'::regclass);


--
-- Name: goods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goods ALTER COLUMN id SET DEFAULT nextval('goods_id_seq'::regclass);


--
-- Name: openbill_lockings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings ALTER COLUMN id SET DEFAULT nextval('openbill_lockings_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: outcome_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY outcome_orders ALTER COLUMN id SET DEFAULT nextval('outcome_orders_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: passport_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport_images ALTER COLUMN id SET DEFAULT nextval('passport_images_id_seq'::regclass);


--
-- Name: requisites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY requisites ALTER COLUMN id SET DEFAULT nextval('requisites_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_documents company_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_documents
    ADD CONSTRAINT company_documents_pkey PRIMARY KEY (id);


--
-- Name: good_images good_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY good_images
    ADD CONSTRAINT good_images_pkey PRIMARY KEY (id);


--
-- Name: goods goods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goods
    ADD CONSTRAINT goods_pkey PRIMARY KEY (id);


--
-- Name: openbill_accounts openbill_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_accounts
    ADD CONSTRAINT openbill_accounts_pkey PRIMARY KEY (id);


--
-- Name: openbill_categories openbill_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_categories
    ADD CONSTRAINT openbill_categories_pkey PRIMARY KEY (id);


--
-- Name: openbill_lockings openbill_lockings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT openbill_lockings_pkey PRIMARY KEY (id);


--
-- Name: openbill_operations openbill_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_operations
    ADD CONSTRAINT openbill_operations_pkey PRIMARY KEY (id);


--
-- Name: openbill_policies openbill_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_policies
    ADD CONSTRAINT openbill_policies_pkey PRIMARY KEY (id);


--
-- Name: openbill_transactions openbill_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_transactions
    ADD CONSTRAINT openbill_transactions_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: outcome_orders outcome_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outcome_orders
    ADD CONSTRAINT outcome_orders_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: passport_images passport_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport_images
    ADD CONSTRAINT passport_images_pkey PRIMARY KEY (id);


--
-- Name: requisites requisites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY requisites
    ADD CONSTRAINT requisites_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_created_at ON openbill_accounts USING btree (created_at);


--
-- Name: index_accounts_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_id ON openbill_accounts USING btree (id);


--
-- Name: index_accounts_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_key ON openbill_accounts USING btree (key);


--
-- Name: index_accounts_on_meta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_meta ON openbill_accounts USING gin (meta);


--
-- Name: index_categories_on_parent_id_and_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_parent_id_and_title ON categories USING btree (parent_id, title);


--
-- Name: index_companies_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_account_id ON companies USING btree (account_id);


--
-- Name: index_companies_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_user_id ON companies USING btree (user_id);


--
-- Name: index_companies_on_user_id_and_inn; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_user_id_and_inn ON companies USING btree (user_id, inn);


--
-- Name: index_company_documents_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_documents_on_company_id ON company_documents USING btree (company_id);


--
-- Name: index_company_documents_on_company_id_and_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_documents_on_company_id_and_category ON company_documents USING btree (company_id, category);


--
-- Name: index_good_images_on_good_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_images_on_good_id ON good_images USING btree (good_id);


--
-- Name: index_goods_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_goods_on_category_id ON goods USING btree (category_id);


--
-- Name: index_goods_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_goods_on_company_id ON goods USING btree (company_id);


--
-- Name: index_openbill_categories_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_openbill_categories_name ON openbill_categories USING btree (parent_id, name);


--
-- Name: index_openbill_lockings_on_buy_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_buy_transaction_id ON openbill_lockings USING btree (buy_transaction_id);


--
-- Name: index_openbill_lockings_on_buyer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_buyer_id ON openbill_lockings USING btree (buyer_id);


--
-- Name: index_openbill_lockings_on_good_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_good_id ON openbill_lockings USING btree (good_id);


--
-- Name: index_openbill_lockings_on_locking_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_locking_transaction_id ON openbill_lockings USING btree (locking_transaction_id);


--
-- Name: index_openbill_lockings_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_order_id ON openbill_lockings USING btree (order_id);


--
-- Name: index_openbill_lockings_on_reverse_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_reverse_transaction_id ON openbill_lockings USING btree (reverse_transaction_id);


--
-- Name: index_openbill_lockings_on_seller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_seller_id ON openbill_lockings USING btree (seller_id);


--
-- Name: index_openbill_lockings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_user_id ON openbill_lockings USING btree (user_id);


--
-- Name: index_openbill_lockings_on_workflow_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openbill_lockings_on_workflow_state ON openbill_lockings USING btree (workflow_state);


--
-- Name: index_openbill_policies_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_openbill_policies_name ON openbill_policies USING btree (name);


--
-- Name: index_orders_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_company_id ON orders USING btree (company_id);


--
-- Name: index_orders_on_good_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_good_id ON orders USING btree (good_id);


--
-- Name: index_orders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_user_id ON orders USING btree (user_id);


--
-- Name: index_outcome_orders_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outcome_orders_on_company_id ON outcome_orders USING btree (company_id);


--
-- Name: index_outcome_orders_on_manager_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outcome_orders_on_manager_id ON outcome_orders USING btree (manager_id);


--
-- Name: index_outcome_orders_on_requisite_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outcome_orders_on_requisite_id ON outcome_orders USING btree (requisite_id);


--
-- Name: index_outcome_orders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outcome_orders_on_user_id ON outcome_orders USING btree (user_id);


--
-- Name: index_pages_on_row_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_row_order ON pages USING btree (row_order);


--
-- Name: index_pages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pages_on_slug ON pages USING btree (slug);


--
-- Name: index_passport_images_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passport_images_on_user_id ON passport_images USING btree (user_id);


--
-- Name: index_transactions_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_created_at ON openbill_transactions USING btree (created_at);


--
-- Name: index_transactions_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_transactions_on_key ON openbill_transactions USING btree (key);


--
-- Name: index_transactions_on_meta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_meta ON openbill_transactions USING gin (meta);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_last_logout_at_and_last_activity_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_last_logout_at_and_last_activity_at ON users USING btree (last_logout_at, last_activity_at);


--
-- Name: index_users_on_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_phone ON users USING btree (phone);


--
-- Name: index_users_on_remember_me_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_remember_me_token ON users USING btree (remember_me_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: openbill_transactions add_current_user_to_transaction; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER add_current_user_to_transaction BEFORE INSERT OR UPDATE ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE add_current_user_to_transaction();


--
-- Name: openbill_transactions constraint_accounts_currency_in_transactions; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER constraint_accounts_currency_in_transactions BEFORE INSERT OR UPDATE ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE constraint_accounts_currency_in_transactions();


--
-- Name: openbill_transactions constraint_transaction_ownership; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER constraint_transaction_ownership AFTER INSERT ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE constraint_transaction_ownership();


--
-- Name: openbill_accounts disable_delete_account; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER disable_delete_account BEFORE DELETE ON openbill_accounts FOR EACH ROW EXECUTE PROCEDURE disable_delete_account();


--
-- Name: openbill_transactions notify_transaction; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER notify_transaction AFTER INSERT ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE notify_transaction();


--
-- Name: openbill_transactions openbill_transaction_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER openbill_transaction_delete BEFORE DELETE ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE openbill_transaction_delete();


--
-- Name: openbill_transactions openbill_transaction_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER openbill_transaction_update AFTER UPDATE ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE openbill_transaction_update();


--
-- Name: openbill_transactions process_account_transaction; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_account_transaction AFTER INSERT ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE process_account_transaction();


--
-- Name: openbill_transactions process_reverse_transaction; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_reverse_transaction AFTER INSERT ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE process_reverse_transaction();


--
-- Name: openbill_transactions restrict_transaction; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER restrict_transaction AFTER INSERT ON openbill_transactions FOR EACH ROW EXECUTE PROCEDURE restrict_transaction();


--
-- Name: outcome_orders fk_rails_1ea503f8a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outcome_orders
    ADD CONSTRAINT fk_rails_1ea503f8a5 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: companies fk_rails_2b5993e415; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT fk_rails_2b5993e415 FOREIGN KEY (moderator_id) REFERENCES users(id);


--
-- Name: outcome_orders fk_rails_417e41cf5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outcome_orders
    ADD CONSTRAINT fk_rails_417e41cf5d FOREIGN KEY (requisite_id) REFERENCES requisites(id);


--
-- Name: orders fk_rails_54a5a63275; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_54a5a63275 FOREIGN KEY (good_id) REFERENCES goods(id);


--
-- Name: goods fk_rails_5b7fc611ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goods
    ADD CONSTRAINT fk_rails_5b7fc611ab FOREIGN KEY (category_id) REFERENCES categories(id);


--
-- Name: openbill_lockings fk_rails_6e44e7f7b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_6e44e7f7b6 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: categories fk_rails_82f48f7407; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT fk_rails_82f48f7407 FOREIGN KEY (parent_id) REFERENCES categories(id);


--
-- Name: openbill_lockings fk_rails_8d77be131b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_8d77be131b FOREIGN KEY (buyer_id) REFERENCES companies(id);


--
-- Name: passport_images fk_rails_9af14a2a1f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport_images
    ADD CONSTRAINT fk_rails_9af14a2a1f FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: outcome_orders fk_rails_9f2f51af84; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outcome_orders
    ADD CONSTRAINT fk_rails_9f2f51af84 FOREIGN KEY (transaction_uuid) REFERENCES openbill_transactions(id);


--
-- Name: openbill_lockings fk_rails_a462639d6c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_a462639d6c FOREIGN KEY (reverse_transaction_id) REFERENCES openbill_transactions(id);


--
-- Name: good_images fk_rails_ab751a87ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY good_images
    ADD CONSTRAINT fk_rails_ab751a87ab FOREIGN KEY (good_id) REFERENCES goods(id);


--
-- Name: outcome_orders fk_rails_b699855bc6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outcome_orders
    ADD CONSTRAINT fk_rails_b699855bc6 FOREIGN KEY (manager_id) REFERENCES users(id);


--
-- Name: openbill_lockings fk_rails_c4dcc55947; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_c4dcc55947 FOREIGN KEY (good_id) REFERENCES goods(id);


--
-- Name: openbill_lockings fk_rails_d39cc48f56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_d39cc48f56 FOREIGN KEY (locking_transaction_id) REFERENCES openbill_transactions(id);


--
-- Name: orders fk_rails_dfd2d6dcf6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_dfd2d6dcf6 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: goods fk_rails_dfec162e7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goods
    ADD CONSTRAINT fk_rails_dfec162e7d FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: outcome_orders fk_rails_ec6d043d7f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outcome_orders
    ADD CONSTRAINT fk_rails_ec6d043d7f FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: openbill_lockings fk_rails_ef870498c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_ef870498c7 FOREIGN KEY (buy_transaction_id) REFERENCES openbill_transactions(id);


--
-- Name: openbill_lockings fk_rails_f5a7e6d9ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_f5a7e6d9ee FOREIGN KEY (seller_id) REFERENCES companies(id);


--
-- Name: orders fk_rails_f868b47f6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_f868b47f6a FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: openbill_lockings fk_rails_fcc4f4916d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_lockings
    ADD CONSTRAINT fk_rails_fcc4f4916d FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: openbill_accounts openbill_accounts_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_accounts
    ADD CONSTRAINT openbill_accounts_category_id_fkey FOREIGN KEY (category_id) REFERENCES openbill_categories(id) ON DELETE RESTRICT;


--
-- Name: openbill_categories openbill_categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_categories
    ADD CONSTRAINT openbill_categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES openbill_categories(id) ON DELETE RESTRICT;


--
-- Name: openbill_policies openbill_policies_from_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_policies
    ADD CONSTRAINT openbill_policies_from_account_id_fkey FOREIGN KEY (from_account_id) REFERENCES openbill_accounts(id);


--
-- Name: openbill_policies openbill_policies_from_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_policies
    ADD CONSTRAINT openbill_policies_from_category_id_fkey FOREIGN KEY (from_category_id) REFERENCES openbill_categories(id);


--
-- Name: openbill_policies openbill_policies_to_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_policies
    ADD CONSTRAINT openbill_policies_to_account_id_fkey FOREIGN KEY (to_account_id) REFERENCES openbill_accounts(id);


--
-- Name: openbill_policies openbill_policies_to_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_policies
    ADD CONSTRAINT openbill_policies_to_category_id_fkey FOREIGN KEY (to_category_id) REFERENCES openbill_categories(id);


--
-- Name: openbill_transactions openbill_transactions_from_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_transactions
    ADD CONSTRAINT openbill_transactions_from_account_id_fkey FOREIGN KEY (from_account_id) REFERENCES openbill_accounts(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: openbill_transactions openbill_transactions_operation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_transactions
    ADD CONSTRAINT openbill_transactions_operation_id_fkey FOREIGN KEY (operation_id) REFERENCES openbill_operations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: openbill_transactions openbill_transactions_to_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_transactions
    ADD CONSTRAINT openbill_transactions_to_account_id_fkey FOREIGN KEY (to_account_id) REFERENCES openbill_accounts(id);


--
-- Name: openbill_transactions openbill_transactions_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_transactions
    ADD CONSTRAINT openbill_transactions_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: openbill_transactions reverse_transaction_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openbill_transactions
    ADD CONSTRAINT reverse_transaction_foreign_key FOREIGN KEY (reverse_transaction_id) REFERENCES openbill_transactions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES
('20170129100431'),
('20170129100432'),
('20170129100433'),
('20170129100434'),
('20170129101103'),
('20170129101214'),
('20170129101258'),
('20170129101751'),
('20170129102443'),
('20170129115108'),
('20170130183319'),
('20170131075215'),
('20170131075429'),
('20170201193552'),
('20170201200811'),
('20170202121705'),
('20170202150320'),
('20170203083448'),
('20170203091043'),
('20170203104200'),
('20170203113654'),
('20170204195037'),
('20170205075246'),
('20170205080306'),
('20170205202741'),
('20170205211923'),
('20170210074954'),
('20170210080524'),
('20170210092432'),
('20170210100338'),
('20170227205740'),
('20170227214150'),
('20170228073344'),
('20170228074225'),
('20170228084101'),
('20170302154340'),
('20170303102324'),
('20170304222022'),
('20170305160253'),
('20170305212138'),
('20170305221705'),
('20170305223523'),
('20170306072423'),
('20170307124522'),
('20170308185608'),
('20170308185822'),
('20170309073541'),
('20170309202621'),
('20170309203237'),
('20170309203907'),
('20170310045129'),
('20170310045420'),
('20170310052150');


