--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

-- Started on 2022-07-15 20:21:45

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
-- TOC entry 3360 (class 1262 OID 20724)
-- Name: DbCarDealer; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "DbCarDealer" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1254';


ALTER DATABASE "DbCarDealer" OWNER TO postgres;

\connect "DbCarDealer"

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
-- TOC entry 219 (class 1255 OID 20782)
-- Name: add_car(character varying, character varying, character varying, character varying, integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_car(IN make character varying, IN model character varying, IN fuel character varying, IN gear character varying, IN price integer, IN color character varying)
    LANGUAGE sql
    AS $$
insert into cars(make,model,fuel,gear,price,color) values (make,model,fuel,gear,price,color); 
$$;


ALTER PROCEDURE public.add_car(IN make character varying, IN model character varying, IN fuel character varying, IN gear character varying, IN price integer, IN color character varying) OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 20819)
-- Name: customers_cars(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.customers_cars() RETURNS TABLE(customer_name character varying, car_id integer, car_make character varying, car_model character varying, net_price numeric)
    LANGUAGE plpgsql
    AS $$
begin
return query
    select 
    cus.customername,
    cars.carid,
    cars.make,
    cars.model,
    netprice_calculator(cars.price,ordt.vat,ordt.vat2,ordt.discount)
    from customers cus
    inner join cars on cus.customerid=cars.carid
    inner join orderdetails ordt on cars.carid=ordt.orderid;
end;
$$;


ALTER FUNCTION public.customers_cars() OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 20816)
-- Name: netprice_calculator(numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.netprice_calculator(price numeric, vat numeric, vat2 numeric, discount numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
declare 
netprice decimal;
begin
    netprice:= price * vat * vat2 - (price*discount/100);
    return netprice;
end;
$$;


ALTER FUNCTION public.netprice_calculator(price numeric, vat numeric, vat2 numeric, discount numeric) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 20726)
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    carid integer NOT NULL,
    make character varying(10) NOT NULL,
    model character varying(10) NOT NULL,
    fuel character varying(10) NOT NULL,
    gear character varying(10) NOT NULL,
    price integer NOT NULL,
    color character varying(10) NOT NULL
);


ALTER TABLE public.cars OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 20725)
-- Name: cars_carid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cars_carid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cars_carid_seq OWNER TO postgres;

--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 209
-- Name: cars_carid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cars_carid_seq OWNED BY public.cars.carid;


--
-- TOC entry 212 (class 1259 OID 20733)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customerid integer NOT NULL,
    customername character varying(10) NOT NULL,
    customeradress character varying(10),
    customerphone character varying(10)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 20732)
-- Name: customers_customerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customerid_seq OWNER TO postgres;

--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 211
-- Name: customers_customerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customerid_seq OWNED BY public.customers.customerid;


--
-- TOC entry 214 (class 1259 OID 20740)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employeeid integer NOT NULL,
    employeename character varying(10) NOT NULL,
    employeeadress character varying(10),
    employeephone character varying(10)
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 20739)
-- Name: employees_employeeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employeeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_employeeid_seq OWNER TO postgres;

--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 213
-- Name: employees_employeeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employeeid_seq OWNED BY public.employees.employeeid;


--
-- TOC entry 218 (class 1259 OID 20754)
-- Name: orderdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderdetails (
    orderid integer NOT NULL,
    carid integer NOT NULL,
    vat2 numeric NOT NULL,
    vat numeric NOT NULL,
    discount numeric NOT NULL
);


ALTER TABLE public.orderdetails OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 20753)
-- Name: orderdetails_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orderdetails_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orderdetails_orderid_seq OWNER TO postgres;

--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 217
-- Name: orderdetails_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orderdetails_orderid_seq OWNED BY public.orderdetails.orderid;


--
-- TOC entry 216 (class 1259 OID 20747)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    customerid integer NOT NULL,
    employeeid integer NOT NULL,
    orderdate date NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 20746)
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_orderid_seq OWNER TO postgres;

--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 215
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- TOC entry 3187 (class 2604 OID 20729)
-- Name: cars carid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars ALTER COLUMN carid SET DEFAULT nextval('public.cars_carid_seq'::regclass);


--
-- TOC entry 3188 (class 2604 OID 20736)
-- Name: customers customerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customerid SET DEFAULT nextval('public.customers_customerid_seq'::regclass);


--
-- TOC entry 3189 (class 2604 OID 20743)
-- Name: employees employeeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employeeid SET DEFAULT nextval('public.employees_employeeid_seq'::regclass);


--
-- TOC entry 3191 (class 2604 OID 20757)
-- Name: orderdetails orderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails ALTER COLUMN orderid SET DEFAULT nextval('public.orderdetails_orderid_seq'::regclass);


--
-- TOC entry 3190 (class 2604 OID 20750)
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- TOC entry 3346 (class 0 OID 20726)
-- Dependencies: 210
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cars (carid, make, model, fuel, gear, price, color) VALUES (1, 'Toyota', 'Corolla', 'Gasoline', 'Automatic', 260000, 'White');
INSERT INTO public.cars (carid, make, model, fuel, gear, price, color) VALUES (2, 'Renault', 'Megane', 'Diesel', 'Manuel', 280000, 'Red');
INSERT INTO public.cars (carid, make, model, fuel, gear, price, color) VALUES (3, 'Ford', 'Focus', 'Gasoline', 'Automatic', 300000, 'Blue');


--
-- TOC entry 3348 (class 0 OID 20733)
-- Dependencies: 212
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers (customerid, customername, customeradress, customerphone) VALUES (1, 'Ahmet', NULL, NULL);
INSERT INTO public.customers (customerid, customername, customeradress, customerphone) VALUES (2, 'Mehmet', NULL, NULL);
INSERT INTO public.customers (customerid, customername, customeradress, customerphone) VALUES (3, 'Osman', NULL, NULL);


--
-- TOC entry 3350 (class 0 OID 20740)
-- Dependencies: 214
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employees (employeeid, employeename, employeeadress, employeephone) VALUES (1, 'Ayşe', NULL, NULL);
INSERT INTO public.employees (employeeid, employeename, employeeadress, employeephone) VALUES (2, 'Halil', NULL, NULL);
INSERT INTO public.employees (employeeid, employeename, employeeadress, employeephone) VALUES (3, 'Ali', NULL, NULL);


--
-- TOC entry 3354 (class 0 OID 20754)
-- Dependencies: 218
-- Data for Name: orderdetails; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orderdetails (orderid, carid, vat2, vat, discount) VALUES (1, 1, 1.18, 1.8, 0);
INSERT INTO public.orderdetails (orderid, carid, vat2, vat, discount) VALUES (2, 2, 1.18, 1.8, 3);
INSERT INTO public.orderdetails (orderid, carid, vat2, vat, discount) VALUES (3, 3, 1.18, 1.8, 5);


--
-- TOC entry 3352 (class 0 OID 20747)
-- Dependencies: 216
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orders (orderid, customerid, employeeid, orderdate) VALUES (1, 1, 3, '2022-07-13');
INSERT INTO public.orders (orderid, customerid, employeeid, orderdate) VALUES (2, 2, 1, '2022-07-14');
INSERT INTO public.orders (orderid, customerid, employeeid, orderdate) VALUES (3, 3, 2, '2022-07-15');


--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 209
-- Name: cars_carid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cars_carid_seq', 3, true);


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 211
-- Name: customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customerid_seq', 3, true);


--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 213
-- Name: employees_employeeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employeeid_seq', 3, true);


--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 217
-- Name: orderdetails_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orderdetails_orderid_seq', 1, false);


--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 215
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 3, true);


--
-- TOC entry 3193 (class 2606 OID 20731)
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (carid);


--
-- TOC entry 3195 (class 2606 OID 20738)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customerid);


--
-- TOC entry 3197 (class 2606 OID 20745)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employeeid);


--
-- TOC entry 3201 (class 2606 OID 20759)
-- Name: orderdetails orderdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_pkey PRIMARY KEY (orderid);


--
-- TOC entry 3199 (class 2606 OID 20752)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- TOC entry 3204 (class 2606 OID 20770)
-- Name: orderdetails fk_orderdetails_cars; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT fk_orderdetails_cars FOREIGN KEY (carid) REFERENCES public.cars(carid);


--
-- TOC entry 3205 (class 2606 OID 20775)
-- Name: orderdetails fk_orderdetails_orders; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT fk_orderdetails_orders FOREIGN KEY (orderid) REFERENCES public.orders(orderid);


--
-- TOC entry 3203 (class 2606 OID 20765)
-- Name: orders fk_orders_customers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customerid) REFERENCES public.customers(customerid);


--
-- TOC entry 3202 (class 2606 OID 20760)
-- Name: orders fk_orders_employees; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_employees FOREIGN KEY (employeeid) REFERENCES public.employees(employeeid);


-- Completed on 2022-07-15 20:21:46

--
-- PostgreSQL database dump complete
--

