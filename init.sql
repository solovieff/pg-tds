--  creating new db user
CREATE ROLE db_admin LOGIN PASSWORD 'db_admin';
--  creating new  db
CREATE DATABASE db_name owner db_admin ENCODING 'UTF8';

\c db_name

CREATE EXTENSION tds_fdw;
-- env vars can not be passed here directly
-- TODO: sh script to init with env vars
CREATE SERVER mssql_svr
    FOREIGN DATA WRAPPER tds_fdw
    OPTIONS (servername '192.168.0.32', port '1433', database 'db_to_use', tds_version '7.1');

GRANT USAGE ON FOREIGN SERVER mssql_svr TO db_admin;

CREATE USER MAPPING FOR db_admin
    SERVER mssql_svr
    OPTIONS (username 'sql_srv_username', password 'sql_srv_password');

CREATE USER MAPPING FOR postgres
    SERVER mssql_svr
    OPTIONS (username 'sql_srv_username', password 'sql_srv_password');

IMPORT FOREIGN SCHEMA sql_srv_schema_name
    FROM SERVER mssql_svr
    INTO public
    OPTIONS (import_default 'true');
