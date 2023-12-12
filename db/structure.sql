--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.24
-- Dumped by pg_dump version 9.6.24

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: customers_spent_update_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.customers_spent_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF TG_OP IN ('DELETE', 'UPDATE') THEN
            UPDATE "customers"
              SET "spent" = (SELECT COALESCE(SUM("total"), 0) FROM "orders" WHERE "orders"."customer_id" = "customers"."id" AND "orders"."created_at" >= date_trunc('year', now()- interval '1 year'))
            WHERE ("customers"."id" = old."customer_id");
          END IF;
          IF TG_OP IN ('INSERT', 'UPDATE') THEN
            UPDATE "customers"
              SET "spent" = (SELECT COALESCE(SUM("total"), 0) FROM "orders" WHERE "orders"."customer_id" = "customers"."id" AND "orders"."created_at" >= date_trunc('year', now()- interval '1 year'))
            WHERE ("customers"."id" = new."customer_id");
          END IF;
          RETURN NULL;
        END
        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    spent integer DEFAULT 0 NOT NULL,
    CONSTRAINT customers_name_present_check CHECK (((name)::text ~ '[^\s　]'::text)),
    CONSTRAINT customers_spent_check CHECK ((spent >= 0))
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id character varying(255) NOT NULL,
    customer_id integer NOT NULL,
    total integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT orders_id_present_check CHECK (((id)::text ~ '[^\s　]'::text)),
    CONSTRAINT orders_total_check CHECK ((total >= 0))
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: index_orders_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_created_at ON public.orders USING btree (created_at);


--
-- Name: index_orders_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_customer_id ON public.orders USING btree (customer_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: orders customers_spent_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER customers_spent_update AFTER INSERT OR DELETE OR UPDATE OF customer_id, total ON public.orders FOR EACH ROW EXECUTE PROCEDURE public.customers_spent_update_trigger();


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('19750000000100');

INSERT INTO schema_migrations (version) VALUES ('19750000000101');

INSERT INTO schema_migrations (version) VALUES ('19750000000200');

INSERT INTO schema_migrations (version) VALUES ('19750000000201');

INSERT INTO schema_migrations (version) VALUES ('19750000000202');

INSERT INTO schema_migrations (version) VALUES ('19750000000203');