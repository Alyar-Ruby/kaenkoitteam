--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_balances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_balances (
    id integer NOT NULL,
    account_id integer,
    balance numeric DEFAULT 0.0,
    kaenko_currency_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_primary boolean DEFAULT false
);


--
-- Name: account_balances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_balances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_balances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_balances_id_seq OWNED BY account_balances.id;


--
-- Name: account_currencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_currencies (
    id integer NOT NULL,
    account_id integer,
    kaenko_currency_id integer,
    is_primary boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: account_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_currencies_id_seq OWNED BY account_currencies.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    account_number character varying(255),
    roleable_id integer,
    roleable_type character varying(255),
    approved boolean,
    premium boolean DEFAULT false,
    verified boolean DEFAULT false,
    search_by character varying(255),
    platform_limit numeric,
    kaenko_currency_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean DEFAULT true,
    time_zone character varying(255),
    account_document character varying(255),
    account_id_document character varying(255),
    account_status_document character varying(255),
    last_sign_in integer
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: api_clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_clients (
    id integer NOT NULL,
    email character varying(255),
    client_id character varying(255),
    client_secret character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: api_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_clients_id_seq OWNED BY api_clients.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_keys (
    id integer NOT NULL,
    access_token character varying(255) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    api_client_id integer NOT NULL,
    active boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_keys_id_seq OWNED BY api_keys.id;


--
-- Name: banks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE banks (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    kaenko_currency_id integer,
    status boolean DEFAULT false,
    "primary" boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_id integer,
    processing_time character varying(255),
    country character varying(255),
    account_number character varying(255)
);


--
-- Name: banks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE banks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: banks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE banks_id_seq OWNED BY banks.id;


--
-- Name: business_websites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE business_websites (
    id integer NOT NULL,
    business_id integer,
    title character varying(255),
    website_url character varying(255),
    is_primary boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: business_websites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE business_websites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_websites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE business_websites_id_seq OWNED BY business_websites.id;


--
-- Name: businesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE businesses (
    id integer NOT NULL,
    country_of_incorporation character varying(255),
    organization_name character varying(255),
    organization_url character varying(255),
    legal_form character varying(255),
    registration_number character varying(255),
    date_of_incorporation date,
    country character varying(255),
    state character varying(255),
    address text,
    postal_code character varying(255),
    city character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    commission numeric,
    phone character varying(255),
    category_id integer,
    sub_category_id integer,
    address_document character varying(255),
    address_verified boolean DEFAULT false,
    business_document character varying(255),
    business_verified boolean DEFAULT false,
    email character varying(255),
    region character varying(255),
    image character varying(255),
    description text
);


--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE businesses_id_seq OWNED BY businesses.id;


--
-- Name: capabilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE capabilities (
    id integer NOT NULL,
    title character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE capabilities_id_seq OWNED BY capabilities.id;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    card_type character varying(255),
    expiry_date date,
    status boolean DEFAULT false,
    "primary" boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    card_number character varying(255),
    cvv integer
);


--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cards_id_seq OWNED BY cards.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    parent_id integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: circle_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE circle_users (
    id integer NOT NULL,
    circle_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: circle_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE circle_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: circle_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE circle_users_id_seq OWNED BY circle_users.id;


--
-- Name: circles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE circles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_id integer
);


--
-- Name: circles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE circles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: circles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE circles_id_seq OWNED BY circles.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer,
    post_id integer,
    title text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_id integer
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: connections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE connections (
    id integer NOT NULL,
    from_user_id integer,
    to_user_id integer,
    status character varying(255) DEFAULT 'Pending'::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    from_account_id integer,
    to_account_id integer
);


--
-- Name: connections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE connections_id_seq OWNED BY connections.id;


--
-- Name: conversation_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE conversation_messages (
    id integer NOT NULL,
    conversation_id integer,
    message text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_id integer
);


--
-- Name: conversation_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conversation_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversation_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conversation_messages_id_seq OWNED BY conversation_messages.id;


--
-- Name: conversation_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE conversation_users (
    id integer NOT NULL,
    conversation_id integer,
    conversation_message_id integer,
    user_id integer,
    archive boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_read boolean DEFAULT false,
    is_deleted boolean DEFAULT false,
    account_id integer
);


--
-- Name: conversation_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conversation_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversation_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conversation_users_id_seq OWNED BY conversation_users.id;


--
-- Name: conversations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE conversations (
    id integer NOT NULL,
    title character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    accounts character varying(255)
);


--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;


--
-- Name: deposits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deposits (
    id integer NOT NULL,
    user_id integer,
    account_id integer,
    kaenko_currency_id integer,
    amount numeric,
    transaction_id integer,
    roleable_id integer,
    roleable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: deposits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deposits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deposits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deposits_id_seq OWNED BY deposits.id;


--
-- Name: disputes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE disputes (
    id integer NOT NULL,
    must_reply_before date,
    user_id integer,
    from_account_id integer,
    to_account_id integer,
    transaction_id integer,
    kaenko_currency_id integer,
    reason character varying(255),
    amount numeric DEFAULT 0.0,
    is_resolved boolean DEFAULT false,
    document character varying(255),
    message text,
    is_shipment_pay boolean DEFAULT false,
    is_partial_refund boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: disputes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE disputes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: disputes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE disputes_id_seq OWNED BY disputes.id;


--
-- Name: earnings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE earnings (
    id integer NOT NULL,
    account_id integer,
    user_id integer,
    kaenko_currency_id integer,
    amount numeric,
    transaction_type character varying(255),
    fee_earned_percent numeric,
    fee_earned_value numeric,
    batch_id character varying(255),
    note character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: earnings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE earnings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: earnings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE earnings_id_seq OWNED BY earnings.id;


--
-- Name: facebook_friends; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facebook_friends (
    id integer NOT NULL,
    user_id integer,
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: facebook_friends_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facebook_friends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_friends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facebook_friends_id_seq OWNED BY facebook_friends.id;


--
-- Name: faqs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE faqs (
    id integer NOT NULL,
    question character varying(255),
    answer text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faqs_id_seq OWNED BY faqs.id;


--
-- Name: fees_exchanges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fees_exchanges (
    id integer NOT NULL,
    from_currency_id integer,
    to_currency_id integer,
    fee_percent numeric,
    fee_value numeric,
    our_fee numeric,
    fx_fee numeric,
    provider character varying(255),
    limit_pd numeric,
    exchange_group character varying(255),
    account_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fees_exchanges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fees_exchanges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fees_exchanges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fees_exchanges_id_seq OWNED BY fees_exchanges.id;


--
-- Name: fees_from_tos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fees_from_tos (
    id integer NOT NULL,
    from_account character varying(255),
    to_account character varying(255),
    mode character varying(255),
    fee_percent numeric,
    fee_value numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fees_from_tos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fees_from_tos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fees_from_tos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fees_from_tos_id_seq OWNED BY fees_from_tos.id;


--
-- Name: fees_redemptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fees_redemptions (
    id integer NOT NULL,
    account character varying(255),
    payment_option character varying(255),
    account_type character varying(255),
    brute_fee_percent numeric,
    brute_fee_value numeric,
    total_fee_percent numeric,
    total_fee_value numeric,
    our_margin numeric,
    limits numeric,
    provider character varying(255),
    timings character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fees_redemptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fees_redemptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fees_redemptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fees_redemptions_id_seq OWNED BY fees_redemptions.id;


--
-- Name: fees_uploads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fees_uploads (
    id integer NOT NULL,
    account character varying(255),
    payment_option character varying(255),
    account_type character varying(255),
    brute_fee_percent numeric,
    brute_fee_value numeric,
    total_fee_percent numeric,
    total_fee_value numeric,
    our_margin numeric,
    limits numeric,
    provider character varying(255),
    refund boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fees_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fees_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fees_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fees_uploads_id_seq OWNED BY fees_uploads.id;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invites (
    id integer NOT NULL,
    email character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invites_id_seq OWNED BY invites.id;


--
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoice_items (
    id integer NOT NULL,
    invoice_id integer,
    item_name character varying(255),
    quantity integer,
    unit_price numeric DEFAULT 0,
    tax_type character varying(255),
    amount numeric DEFAULT 0,
    kaenko_currency_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoice_items_id_seq OWNED BY invoice_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoices (
    id integer NOT NULL,
    user_id integer,
    number character varying(255),
    invoice_date date,
    due_date date,
    receipent character varying(255),
    terms_conditions text,
    subtotal numeric DEFAULT 0,
    shipping numeric DEFAULT 0,
    discount numeric DEFAULT 0,
    total numeric DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    kaenko_currency_id integer,
    status character varying(255)
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoices_id_seq OWNED BY invoices.id;


--
-- Name: kaenko_currencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE kaenko_currencies (
    id integer NOT NULL,
    title character varying(255),
    unit character varying(255),
    symbol character varying(5)
);


--
-- Name: kaenko_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE kaenko_currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kaenko_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE kaenko_currencies_id_seq OWNED BY kaenko_currencies.id;


--
-- Name: kaenko_notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE kaenko_notifications (
    id integer NOT NULL,
    from_user_id integer,
    to_user_id integer,
    message text,
    url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    checked boolean DEFAULT false,
    roleable_type character varying(255),
    roleable_id integer,
    from_account_id integer,
    to_account_id integer
);


--
-- Name: kaenko_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE kaenko_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kaenko_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE kaenko_notifications_id_seq OWNED BY kaenko_notifications.id;


--
-- Name: kaenko_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE kaenko_settings (
    id integer NOT NULL,
    business_commission numeric,
    date_time timestamp without time zone,
    timezone character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: kaenko_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE kaenko_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kaenko_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE kaenko_settings_id_seq OWNED BY kaenko_settings.id;


--
-- Name: message_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE message_images (
    id integer NOT NULL,
    conversation_message_id integer,
    attachment character varying(255),
    attachment_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: message_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE message_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: message_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE message_images_id_seq OWNED BY message_images.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    kaenko_currency_id integer,
    "order" character varying(255),
    amount numeric,
    fee_percent numeric,
    fee_value numeric,
    batch_id character varying(255),
    status character varying(255),
    note text,
    account_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: payout_currencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payout_currencies (
    id integer NOT NULL,
    fees_redemption_id integer,
    kaenko_currency_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: payout_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payout_currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payout_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payout_currencies_id_seq OWNED BY payout_currencies.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    from_user_id integer,
    to_user_id integer,
    title text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    from_account_id integer,
    to_account_id integer,
    is_private boolean DEFAULT false
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: premium_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE premium_requests (
    id integer NOT NULL,
    account_id integer,
    user_id integer,
    request text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying(10) DEFAULT 'pending'::character varying,
    comments character varying(255)
);


--
-- Name: premium_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE premium_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: premium_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE premium_requests_id_seq OWNED BY premium_requests.id;


--
-- Name: referrals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE referrals (
    id integer NOT NULL,
    account_type character varying(255),
    levels integer,
    commission integer,
    commission_level hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE referrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE referrals_id_seq OWNED BY referrals.id;


--
-- Name: request_payments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE request_payments (
    id integer NOT NULL,
    user_id integer,
    request_to character varying(255),
    amount numeric,
    kaenko_currency_id integer,
    title character varying(255),
    memo text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying(255) DEFAULT 'Pending'::character varying
);


--
-- Name: request_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE request_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE request_payments_id_seq OWNED BY request_payments.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    title character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles_users (
    user_id integer,
    role_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: settlement_currencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settlement_currencies (
    id integer NOT NULL,
    fees_upload_id integer,
    kaenko_currency_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: settlement_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settlement_currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settlement_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settlement_currencies_id_seq OWNED BY settlement_currencies.id;


--
-- Name: simple_captcha_data; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE simple_captcha_data (
    id integer NOT NULL,
    key character varying(40),
    value character varying(6),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: simple_captcha_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE simple_captcha_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: simple_captcha_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE simple_captcha_data_id_seq OWNED BY simple_captcha_data.id;


--
-- Name: timelines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timelines (
    id integer NOT NULL,
    user_id integer,
    task character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: timelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE timelines_id_seq OWNED BY timelines.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    from_account_id integer,
    to_account_id integer,
    transaction_from character varying(255),
    transaction_to character varying(255),
    transaction_type character varying(255),
    kaenko_currency_id integer,
    fee_payer character varying(255),
    amount numeric,
    fee_percent numeric,
    fee_value numeric,
    batch_id character varying(255),
    status character varying(255),
    note text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    transaction_id character varying(255),
    transaction_from_id integer,
    transaction_to_id integer,
    roleable_id integer,
    roleable_type character varying(255),
    parent_id integer
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: user_capabilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_capabilities (
    id integer NOT NULL,
    user_id integer,
    capability_id integer,
    daily_limit numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_capabilities_id_seq OWNED BY user_capabilities.id;


--
-- Name: user_referrals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_referrals (
    id integer NOT NULL,
    user_id integer,
    email character varying(255),
    status character varying(255) DEFAULT 'Invited'::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    current_earnings numeric DEFAULT 0.0
);


--
-- Name: user_referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_referrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_referrals_id_seq OWNED BY user_referrals.id;


--
-- Name: user_security_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_security_questions (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: user_security_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_security_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_security_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_security_questions_id_seq OWNED BY user_security_questions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    language character varying(255),
    first_name character varying(255),
    middle_name character varying(255),
    last_name character varying(255),
    gender character varying(255),
    date_of_birth date,
    nationality character varying(255),
    country character varying(255),
    state character varying(255),
    address text,
    city character varying(255),
    postal_code character varying(255),
    phone character varying(255),
    username character varying(255),
    representative_position character varying(255) DEFAULT ''::character varying,
    account_admin boolean DEFAULT true,
    account_id integer,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean DEFAULT true,
    image character varying(255),
    online_status boolean DEFAULT false,
    address_verified boolean DEFAULT false,
    secret_question_answer text,
    job_title character varying(255),
    user_security_question_id integer,
    pin character varying(255),
    suspend boolean DEFAULT false,
    security_pin character varying(6),
    address_document character varying(255),
    subuser boolean DEFAULT false,
    pay_out_over numeric DEFAULT 0.0,
    about_me text,
    website_url character varying(255)
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
-- Name: withdraws; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE withdraws (
    id integer NOT NULL,
    user_id integer,
    account_id integer,
    kaenko_currency_id integer,
    amount numeric,
    transaction_id integer,
    roleable_id integer,
    roleable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: withdraws_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE withdraws_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: withdraws_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE withdraws_id_seq OWNED BY withdraws.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_balances ALTER COLUMN id SET DEFAULT nextval('account_balances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_currencies ALTER COLUMN id SET DEFAULT nextval('account_currencies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_clients ALTER COLUMN id SET DEFAULT nextval('api_clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_keys ALTER COLUMN id SET DEFAULT nextval('api_keys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY banks ALTER COLUMN id SET DEFAULT nextval('banks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_websites ALTER COLUMN id SET DEFAULT nextval('business_websites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses ALTER COLUMN id SET DEFAULT nextval('businesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY capabilities ALTER COLUMN id SET DEFAULT nextval('capabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards ALTER COLUMN id SET DEFAULT nextval('cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY circle_users ALTER COLUMN id SET DEFAULT nextval('circle_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY circles ALTER COLUMN id SET DEFAULT nextval('circles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY connections ALTER COLUMN id SET DEFAULT nextval('connections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY conversation_messages ALTER COLUMN id SET DEFAULT nextval('conversation_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY conversation_users ALTER COLUMN id SET DEFAULT nextval('conversation_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deposits ALTER COLUMN id SET DEFAULT nextval('deposits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY disputes ALTER COLUMN id SET DEFAULT nextval('disputes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY earnings ALTER COLUMN id SET DEFAULT nextval('earnings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY facebook_friends ALTER COLUMN id SET DEFAULT nextval('facebook_friends_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY faqs ALTER COLUMN id SET DEFAULT nextval('faqs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fees_exchanges ALTER COLUMN id SET DEFAULT nextval('fees_exchanges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fees_from_tos ALTER COLUMN id SET DEFAULT nextval('fees_from_tos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fees_redemptions ALTER COLUMN id SET DEFAULT nextval('fees_redemptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fees_uploads ALTER COLUMN id SET DEFAULT nextval('fees_uploads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_items ALTER COLUMN id SET DEFAULT nextval('invoice_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices ALTER COLUMN id SET DEFAULT nextval('invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY kaenko_currencies ALTER COLUMN id SET DEFAULT nextval('kaenko_currencies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY kaenko_notifications ALTER COLUMN id SET DEFAULT nextval('kaenko_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY kaenko_settings ALTER COLUMN id SET DEFAULT nextval('kaenko_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY message_images ALTER COLUMN id SET DEFAULT nextval('message_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payout_currencies ALTER COLUMN id SET DEFAULT nextval('payout_currencies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY premium_requests ALTER COLUMN id SET DEFAULT nextval('premium_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY referrals ALTER COLUMN id SET DEFAULT nextval('referrals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_payments ALTER COLUMN id SET DEFAULT nextval('request_payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settlement_currencies ALTER COLUMN id SET DEFAULT nextval('settlement_currencies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY simple_captcha_data ALTER COLUMN id SET DEFAULT nextval('simple_captcha_data_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY timelines ALTER COLUMN id SET DEFAULT nextval('timelines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_capabilities ALTER COLUMN id SET DEFAULT nextval('user_capabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_referrals ALTER COLUMN id SET DEFAULT nextval('user_referrals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_security_questions ALTER COLUMN id SET DEFAULT nextval('user_security_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY withdraws ALTER COLUMN id SET DEFAULT nextval('withdraws_id_seq'::regclass);


--
-- Name: account_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_balances
    ADD CONSTRAINT account_balances_pkey PRIMARY KEY (id);


--
-- Name: account_currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_currencies
    ADD CONSTRAINT account_currencies_pkey PRIMARY KEY (id);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: api_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_clients
    ADD CONSTRAINT api_clients_pkey PRIMARY KEY (id);


--
-- Name: api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: banks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY banks
    ADD CONSTRAINT banks_pkey PRIMARY KEY (id);


--
-- Name: business_websites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY business_websites
    ADD CONSTRAINT business_websites_pkey PRIMARY KEY (id);


--
-- Name: businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY capabilities
    ADD CONSTRAINT capabilities_pkey PRIMARY KEY (id);


--
-- Name: cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: circle_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY circle_users
    ADD CONSTRAINT circle_users_pkey PRIMARY KEY (id);


--
-- Name: circles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY circles
    ADD CONSTRAINT circles_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY connections
    ADD CONSTRAINT connections_pkey PRIMARY KEY (id);


--
-- Name: conversation_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY conversation_messages
    ADD CONSTRAINT conversation_messages_pkey PRIMARY KEY (id);


--
-- Name: conversation_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY conversation_users
    ADD CONSTRAINT conversation_users_pkey PRIMARY KEY (id);


--
-- Name: conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: deposits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deposits
    ADD CONSTRAINT deposits_pkey PRIMARY KEY (id);


--
-- Name: disputes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY disputes
    ADD CONSTRAINT disputes_pkey PRIMARY KEY (id);


--
-- Name: earnings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY earnings
    ADD CONSTRAINT earnings_pkey PRIMARY KEY (id);


--
-- Name: facebook_friends_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facebook_friends
    ADD CONSTRAINT facebook_friends_pkey PRIMARY KEY (id);


--
-- Name: faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: fees_exchanges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fees_exchanges
    ADD CONSTRAINT fees_exchanges_pkey PRIMARY KEY (id);


--
-- Name: fees_from_tos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fees_from_tos
    ADD CONSTRAINT fees_from_tos_pkey PRIMARY KEY (id);


--
-- Name: fees_redemptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fees_redemptions
    ADD CONSTRAINT fees_redemptions_pkey PRIMARY KEY (id);


--
-- Name: fees_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fees_uploads
    ADD CONSTRAINT fees_uploads_pkey PRIMARY KEY (id);


--
-- Name: invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: kaenko_currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY kaenko_currencies
    ADD CONSTRAINT kaenko_currencies_pkey PRIMARY KEY (id);


--
-- Name: kaenko_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY kaenko_notifications
    ADD CONSTRAINT kaenko_notifications_pkey PRIMARY KEY (id);


--
-- Name: kaenko_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY kaenko_settings
    ADD CONSTRAINT kaenko_settings_pkey PRIMARY KEY (id);


--
-- Name: message_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY message_images
    ADD CONSTRAINT message_images_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payout_currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payout_currencies
    ADD CONSTRAINT payout_currencies_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: premium_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY premium_requests
    ADD CONSTRAINT premium_requests_pkey PRIMARY KEY (id);


--
-- Name: referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- Name: request_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY request_payments
    ADD CONSTRAINT request_payments_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: settlement_currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settlement_currencies
    ADD CONSTRAINT settlement_currencies_pkey PRIMARY KEY (id);


--
-- Name: simple_captcha_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY simple_captcha_data
    ADD CONSTRAINT simple_captcha_data_pkey PRIMARY KEY (id);


--
-- Name: timelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timelines
    ADD CONSTRAINT timelines_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: user_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_capabilities
    ADD CONSTRAINT user_capabilities_pkey PRIMARY KEY (id);


--
-- Name: user_referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_referrals
    ADD CONSTRAINT user_referrals_pkey PRIMARY KEY (id);


--
-- Name: user_security_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_security_questions
    ADD CONSTRAINT user_security_questions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: withdraws_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY withdraws
    ADD CONSTRAINT withdraws_pkey PRIMARY KEY (id);


--
-- Name: idx_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX idx_key ON simple_captcha_data USING btree (key);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_api_keys_on_access_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_api_keys_on_access_token ON api_keys USING btree (access_token);


--
-- Name: index_api_keys_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_api_keys_on_user_id ON api_keys USING btree (api_client_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140205112810');

INSERT INTO schema_migrations (version) VALUES ('20140205112811');

INSERT INTO schema_migrations (version) VALUES ('20140205112812');

INSERT INTO schema_migrations (version) VALUES ('20140205120553');

INSERT INTO schema_migrations (version) VALUES ('20140206105021');

INSERT INTO schema_migrations (version) VALUES ('20140210061657');

INSERT INTO schema_migrations (version) VALUES ('20140212150336');

INSERT INTO schema_migrations (version) VALUES ('20140218063436');

INSERT INTO schema_migrations (version) VALUES ('20140219065243');

INSERT INTO schema_migrations (version) VALUES ('20140220120509');

INSERT INTO schema_migrations (version) VALUES ('20140221065440');

INSERT INTO schema_migrations (version) VALUES ('20140224050452');

INSERT INTO schema_migrations (version) VALUES ('20140224053057');

INSERT INTO schema_migrations (version) VALUES ('20140224071603');

INSERT INTO schema_migrations (version) VALUES ('20140224074500');

INSERT INTO schema_migrations (version) VALUES ('20140224074509');

INSERT INTO schema_migrations (version) VALUES ('20140224074534');

INSERT INTO schema_migrations (version) VALUES ('20140224074547');

INSERT INTO schema_migrations (version) VALUES ('20140224124440');

INSERT INTO schema_migrations (version) VALUES ('20140225060730');

INSERT INTO schema_migrations (version) VALUES ('20140225061016');

INSERT INTO schema_migrations (version) VALUES ('20140225101938');

INSERT INTO schema_migrations (version) VALUES ('20140225115411');

INSERT INTO schema_migrations (version) VALUES ('20140225151253');

INSERT INTO schema_migrations (version) VALUES ('20140227073253');

INSERT INTO schema_migrations (version) VALUES ('20140324103228');

INSERT INTO schema_migrations (version) VALUES ('20140325052306');

INSERT INTO schema_migrations (version) VALUES ('20140325052328');

INSERT INTO schema_migrations (version) VALUES ('20140328060105');

INSERT INTO schema_migrations (version) VALUES ('20140331091610');

INSERT INTO schema_migrations (version) VALUES ('20140402104322');

INSERT INTO schema_migrations (version) VALUES ('20140402105309');

INSERT INTO schema_migrations (version) VALUES ('20140404104610');

INSERT INTO schema_migrations (version) VALUES ('20140502063337');

INSERT INTO schema_migrations (version) VALUES ('20140507101045');

INSERT INTO schema_migrations (version) VALUES ('20140507112751');

INSERT INTO schema_migrations (version) VALUES ('20140507113950');

INSERT INTO schema_migrations (version) VALUES ('20140508123501');

INSERT INTO schema_migrations (version) VALUES ('20140509045019');

INSERT INTO schema_migrations (version) VALUES ('20140520072507');

INSERT INTO schema_migrations (version) VALUES ('20140521064914');

INSERT INTO schema_migrations (version) VALUES ('20140521124030');

INSERT INTO schema_migrations (version) VALUES ('20140521133051');

INSERT INTO schema_migrations (version) VALUES ('20140522060235');

INSERT INTO schema_migrations (version) VALUES ('20140522060804');

INSERT INTO schema_migrations (version) VALUES ('20140522064548');

INSERT INTO schema_migrations (version) VALUES ('20140522070733');

INSERT INTO schema_migrations (version) VALUES ('20140522072942');

INSERT INTO schema_migrations (version) VALUES ('20140522085329');

INSERT INTO schema_migrations (version) VALUES ('20140523060915');

INSERT INTO schema_migrations (version) VALUES ('20140523062113');

INSERT INTO schema_migrations (version) VALUES ('20140527074841');

INSERT INTO schema_migrations (version) VALUES ('20140527175502');

INSERT INTO schema_migrations (version) VALUES ('20140528100252');

INSERT INTO schema_migrations (version) VALUES ('20140528100322');

INSERT INTO schema_migrations (version) VALUES ('20140528123715');

INSERT INTO schema_migrations (version) VALUES ('20140531035706');

INSERT INTO schema_migrations (version) VALUES ('20140531114737');

INSERT INTO schema_migrations (version) VALUES ('20140531120644');

INSERT INTO schema_migrations (version) VALUES ('20140601041440');

INSERT INTO schema_migrations (version) VALUES ('20140601064841');

INSERT INTO schema_migrations (version) VALUES ('20140601084913');

INSERT INTO schema_migrations (version) VALUES ('20140601094442');

INSERT INTO schema_migrations (version) VALUES ('20140602062617');

INSERT INTO schema_migrations (version) VALUES ('20140602062641');

INSERT INTO schema_migrations (version) VALUES ('20140602062650');

INSERT INTO schema_migrations (version) VALUES ('20140603135601');

INSERT INTO schema_migrations (version) VALUES ('20140604132116');

INSERT INTO schema_migrations (version) VALUES ('20140605101242');

INSERT INTO schema_migrations (version) VALUES ('20140612063838');

INSERT INTO schema_migrations (version) VALUES ('20140617062811');

INSERT INTO schema_migrations (version) VALUES ('20140617075632');

INSERT INTO schema_migrations (version) VALUES ('20140618091829');

INSERT INTO schema_migrations (version) VALUES ('20140620120431');

INSERT INTO schema_migrations (version) VALUES ('20140623072649');

INSERT INTO schema_migrations (version) VALUES ('20140626133957');

INSERT INTO schema_migrations (version) VALUES ('20140629111128');

INSERT INTO schema_migrations (version) VALUES ('20140630040921');

INSERT INTO schema_migrations (version) VALUES ('20140701130811');

INSERT INTO schema_migrations (version) VALUES ('20140709060239');

INSERT INTO schema_migrations (version) VALUES ('20140709115004');

INSERT INTO schema_migrations (version) VALUES ('20140711085813');

INSERT INTO schema_migrations (version) VALUES ('20140714071055');

INSERT INTO schema_migrations (version) VALUES ('20140716080826');

INSERT INTO schema_migrations (version) VALUES ('20140716114730');

INSERT INTO schema_migrations (version) VALUES ('20140718122135');

INSERT INTO schema_migrations (version) VALUES ('20140723094439');

INSERT INTO schema_migrations (version) VALUES ('20140725045300');

INSERT INTO schema_migrations (version) VALUES ('20140725045407');

INSERT INTO schema_migrations (version) VALUES ('20140725075609');

INSERT INTO schema_migrations (version) VALUES ('20140901064625');

INSERT INTO schema_migrations (version) VALUES ('20140902104114');

INSERT INTO schema_migrations (version) VALUES ('20140918093610');

INSERT INTO schema_migrations (version) VALUES ('20140918113645');

INSERT INTO schema_migrations (version) VALUES ('20140919062150');

INSERT INTO schema_migrations (version) VALUES ('20140919070602');

INSERT INTO schema_migrations (version) VALUES ('20140922070932');

INSERT INTO schema_migrations (version) VALUES ('20140922073109');

INSERT INTO schema_migrations (version) VALUES ('20140922101242');

INSERT INTO schema_migrations (version) VALUES ('20140924080251');

INSERT INTO schema_migrations (version) VALUES ('20140925073051');

INSERT INTO schema_migrations (version) VALUES ('20140926105058');
