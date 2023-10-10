--Create user for dbt model execution
--    Fill in <user_id> with account user before running script
--    Fill in <password> with password for indicated user
USE ROLE USERADMIN;
CREATE ROLE DBT_EXECUTION_ROLE
    COMMENT = 'Role for dbt model execution';
GRANT ROLE DBT_EXECUTION_ROLE TO USER <user_id>;

--Create dbt warehouse to run dbt models
USE ROLE SYSADMIN;
    --Cluser count > 1 recommended for Enterprise and High Availability
    --Scaling policy can be changed to STANDARD if desired
CREATE WAREHOUSE DBT_EXECUTION_WAREHOUSE
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    MAX_CLUSTER_COUNT = 2 
    SCALING_POLICY = ECONOMY  
    COMMENT = 'Warehouse for dbt model execution';

--Add privileges
USE ROLE SYSADMIN;
GRANT CREATE DATABASE ON ACCOUNT
    TO ROLE DBT_EXECUTION_ROLE;
GRANT USAGE ON WAREHOUSE DBT_EXECUTION_WAREHOUSE
    TO ROLE DBT_EXECUTION_ROLE;

--Create DBT_USER
USE ROLE USERADMIN;
CREATE USER DBT_USER
    COMMENT = 'User for running dbt model commands'
    PASSWORD = '<password>'
    DEFAULT_WAREHOUSE = 'DBT_EXECUTION_WAREHOUSE'
    DEFAULT_ROLE = 'DBT_EXECUTION_ROLE';
GRANT ROLE DBT_EXECUTION_ROLE TO USER DBT_USER;

CREATE USER DBT_USER_DEV
    COMMENT = 'User for developing dbt models'
    PASSWORD = '<password>'
    DEFAULT_WAREHOUSE = 'DBT_EXECUTION_WAREHOUSE'
    DEFAULT_ROLE = 'DBT_EXECUTION_ROLE';
GRANT ROLE DBT_EXECUTION_ROLE TO USER DBT_USER_DEV;

--Create DBT_MODEL_DB database
USE ROLE DBT_EXECUTION_ROLE;
CREATE DATABASE DBT_MODEL_DB;

--Create dbt schemas for development and production
USE DATABASE DBT_MODEL_DB;
CREATE SCHEMA DBT_DEV_SCHEMA
    COMMENT = 'Schema for dbt development';
CREATE SCHEMA DBT_PROD_SCHEMA
    COMMENT = 'Schema for dbt production';