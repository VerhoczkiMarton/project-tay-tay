--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE logto_tenant_logto;
ALTER ROLE logto_tenant_logto WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE logto_tenant_logto_admin;
ALTER ROLE logto_tenant_logto_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:2BvMfkcVOsWQYXPlshsEUg==$ZWJ0sPMCORNm0Pmsy4AKOg8A14MAcIbdjQVJbqlLIVY=:8jxi/1rymnzGGZA9sISY/i7OPB/bXvSpRZ9YT17wS7U=';
CREATE ROLE logto_tenant_logto_default;
ALTER ROLE logto_tenant_logto_default WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:XYl+OJ5ActP5EFtW51HsHA==$DKvzFtqo2Alwy/Mb2WvqdkPHyV+JPfllEqyoHN6N0f0=:774ctmf8l/xWt0cBfLnvZiIKCp22ZnfRPG6dOiE3kVk=';
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'postgres') THEN
        CREATE ROLE postgres;
    END IF;
END $$;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:nSgaEI6EzeKhV75stIiBzg==$IozPxbeePyszD5N2On+iv5KR7bBqS44WKPuoAplMtto=:ijL6Zj4xmMphR2lQE6gN7XniwADXDRFcwIxp5R/rOgk=';


--
-- Role memberships
--

GRANT logto_tenant_logto TO logto_tenant_logto_admin GRANTED BY postgres;
GRANT logto_tenant_logto TO logto_tenant_logto_default GRANTED BY postgres;




--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13
-- Dumped by pg_dump version 14.13

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
-- PostgreSQL database dump complete
--

--
-- Database "logto" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13
-- Dumped by pg_dump version 14.13

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
-- Name: logto; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE logto WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE logto OWNER TO postgres;

\connect logto

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
-- Name: agree_to_terms_policy; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.agree_to_terms_policy AS ENUM (
    'Automatic',
    'ManualRegistrationOnly',
    'Manual'
);


ALTER TYPE public.agree_to_terms_policy OWNER TO postgres;

--
-- Name: application_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.application_type AS ENUM (
    'Native',
    'SPA',
    'Traditional',
    'MachineToMachine',
    'Protected'
);


ALTER TYPE public.application_type OWNER TO postgres;

--
-- Name: organization_invitation_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.organization_invitation_status AS ENUM (
    'Pending',
    'Accepted',
    'Expired',
    'Revoked'
);


ALTER TYPE public.organization_invitation_status OWNER TO postgres;

--
-- Name: role_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role_type AS ENUM (
    'User',
    'MachineToMachine'
);


ALTER TYPE public.role_type OWNER TO postgres;

--
-- Name: sentinel_action_result; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sentinel_action_result AS ENUM (
    'Success',
    'Failed'
);


ALTER TYPE public.sentinel_action_result OWNER TO postgres;

--
-- Name: sentinel_decision; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sentinel_decision AS ENUM (
    'Undecided',
    'Allowed',
    'Blocked',
    'Challenge'
);


ALTER TYPE public.sentinel_decision OWNER TO postgres;

--
-- Name: sign_in_mode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sign_in_mode AS ENUM (
    'SignIn',
    'Register',
    'SignInAndRegister'
);


ALTER TYPE public.sign_in_mode OWNER TO postgres;

--
-- Name: users_password_encryption_method; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_password_encryption_method AS ENUM (
    'Argon2i',
    'Argon2id',
    'Argon2d',
    'SHA1',
    'SHA256',
    'MD5',
    'Bcrypt'
);


ALTER TYPE public.users_password_encryption_method OWNER TO postgres;

--
-- Name: check_application_type(character varying, public.application_type[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_application_type(application_id character varying, VARIADIC target_type public.application_type[]) RETURNS boolean
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$ begin return (select type from applications where id = application_id) = any(target_type); end; $$;


ALTER FUNCTION public.check_application_type(application_id character varying, VARIADIC target_type public.application_type[]) OWNER TO postgres;

--
-- Name: check_organization_role_type(character varying, public.role_type); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_organization_role_type(role_id character varying, target_type public.role_type) RETURNS boolean
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$ begin return (select type from organization_roles where id = role_id) = target_type; end; $$;


ALTER FUNCTION public.check_organization_role_type(role_id character varying, target_type public.role_type) OWNER TO postgres;

--
-- Name: check_role_type(character varying, public.role_type); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_role_type(role_id character varying, target_type public.role_type) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ begin return (select type from public.roles where id = role_id) = target_type; end; $$;


ALTER FUNCTION public.check_role_type(role_id character varying, target_type public.role_type) OWNER TO postgres;

--
-- Name: set_tenant_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_tenant_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ begin if new.tenant_id is not null then return new; end if; select tenants.id into new.tenant_id from tenants where tenants.db_user = current_user; return new; end; $$;


ALTER FUNCTION public.set_tenant_id() OWNER TO postgres;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ begin new.updated_at = now(); return new; end; $$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: application_secrets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_secrets (
    tenant_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    name character varying(256) NOT NULL,
    value character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    CONSTRAINT application_type CHECK (public.check_application_type(application_id, VARIADIC ARRAY['MachineToMachine'::public.application_type, 'Traditional'::public.application_type, 'Protected'::public.application_type]))
);


ALTER TABLE public.application_secrets OWNER TO postgres;

--
-- Name: application_sign_in_experiences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_sign_in_experiences (
    tenant_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    color jsonb DEFAULT '{}'::jsonb NOT NULL,
    branding jsonb DEFAULT '{}'::jsonb NOT NULL,
    terms_of_use_url character varying(2048),
    privacy_policy_url character varying(2048),
    display_name character varying(256)
);


ALTER TABLE public.application_sign_in_experiences OWNER TO postgres;

--
-- Name: application_user_consent_organization_resource_scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_user_consent_organization_resource_scopes (
    tenant_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    scope_id character varying(21) NOT NULL
);


ALTER TABLE public.application_user_consent_organization_resource_scopes OWNER TO postgres;

--
-- Name: application_user_consent_organization_scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_user_consent_organization_scopes (
    tenant_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    organization_scope_id character varying(21) NOT NULL
);


ALTER TABLE public.application_user_consent_organization_scopes OWNER TO postgres;

--
-- Name: application_user_consent_organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_user_consent_organizations (
    tenant_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    user_id character varying(21) NOT NULL
);


ALTER TABLE public.application_user_consent_organizations OWNER TO postgres;

--
-- Name: application_user_consent_resource_scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_user_consent_resource_scopes (
    tenant_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    scope_id character varying(21) NOT NULL
);


ALTER TABLE public.application_user_consent_resource_scopes OWNER TO postgres;

--
-- Name: application_user_consent_user_scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_user_consent_user_scopes (
    tenant_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    user_scope character varying(64) NOT NULL
);


ALTER TABLE public.application_user_consent_user_scopes OWNER TO postgres;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    name character varying(256) NOT NULL,
    secret character varying(64) NOT NULL,
    description text,
    type public.application_type NOT NULL,
    oidc_client_metadata jsonb NOT NULL,
    custom_client_metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    protected_app_metadata jsonb,
    custom_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_third_party boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.applications OWNER TO postgres;

--
-- Name: applications_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications_roles (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    role_id character varying(21) NOT NULL,
    CONSTRAINT applications_roles__role_type CHECK (public.check_role_type(role_id, 'MachineToMachine'::public.role_type))
);


ALTER TABLE public.applications_roles OWNER TO postgres;

--
-- Name: connectors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.connectors (
    tenant_id character varying(21) NOT NULL,
    id character varying(128) NOT NULL,
    sync_profile boolean DEFAULT false NOT NULL,
    connector_id character varying(128) NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.connectors OWNER TO postgres;

--
-- Name: custom_phrases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.custom_phrases (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    language_tag character varying(16) NOT NULL,
    translation jsonb NOT NULL
);


ALTER TABLE public.custom_phrases OWNER TO postgres;

--
-- Name: daily_active_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daily_active_users (
    id character varying(21) NOT NULL,
    tenant_id character varying(21) NOT NULL,
    user_id character varying(21) NOT NULL,
    date timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.daily_active_users OWNER TO postgres;

--
-- Name: daily_token_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daily_token_usage (
    id character varying(21) NOT NULL,
    tenant_id character varying(21) NOT NULL,
    usage bigint DEFAULT 0 NOT NULL,
    date timestamp with time zone NOT NULL
);


ALTER TABLE public.daily_token_usage OWNER TO postgres;

--
-- Name: domains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domains (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    domain character varying(256) NOT NULL,
    status character varying(32) DEFAULT 'PendingVerification'::character varying NOT NULL,
    error_message character varying(1024),
    dns_records jsonb DEFAULT '[]'::jsonb NOT NULL,
    cloudflare_data jsonb,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.domains OWNER TO postgres;

--
-- Name: hooks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hooks (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    name character varying(256) DEFAULT ''::character varying NOT NULL,
    event character varying(128),
    events jsonb DEFAULT '[]'::jsonb NOT NULL,
    config jsonb NOT NULL,
    signing_key character varying(64) DEFAULT ''::character varying NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.hooks OWNER TO postgres;

--
-- Name: idp_initiated_saml_sso_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idp_initiated_saml_sso_sessions (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    connector_id character varying(128) NOT NULL,
    assertion_content jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL
);


ALTER TABLE public.idp_initiated_saml_sso_sessions OWNER TO postgres;

--
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    key character varying(128) NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- Name: logto_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logto_configs (
    tenant_id character varying(21) NOT NULL,
    key character varying(256) NOT NULL,
    value jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.logto_configs OWNER TO postgres;

--
-- Name: oidc_model_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oidc_model_instances (
    tenant_id character varying(21) NOT NULL,
    model_name character varying(64) NOT NULL,
    id character varying(128) NOT NULL,
    payload jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    consumed_at timestamp with time zone
);


ALTER TABLE public.oidc_model_instances OWNER TO postgres;

--
-- Name: organization_application_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_application_relations (
    tenant_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    CONSTRAINT application_type CHECK (public.check_application_type(application_id, VARIADIC ARRAY['MachineToMachine'::public.application_type]))
);


ALTER TABLE public.organization_application_relations OWNER TO postgres;

--
-- Name: organization_invitation_role_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_invitation_role_relations (
    tenant_id character varying(21) NOT NULL,
    organization_invitation_id character varying(21) NOT NULL,
    organization_role_id character varying(21) NOT NULL
);


ALTER TABLE public.organization_invitation_role_relations OWNER TO postgres;

--
-- Name: organization_invitations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_invitations (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    inviter_id character varying(21),
    invitee character varying(256) NOT NULL,
    accepted_user_id character varying(21),
    organization_id character varying(21) NOT NULL,
    status public.organization_invitation_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL
);


ALTER TABLE public.organization_invitations OWNER TO postgres;

--
-- Name: organization_jit_email_domains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_jit_email_domains (
    tenant_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    email_domain character varying(128) NOT NULL
);


ALTER TABLE public.organization_jit_email_domains OWNER TO postgres;

--
-- Name: organization_jit_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_jit_roles (
    tenant_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    organization_role_id character varying(21) NOT NULL
);


ALTER TABLE public.organization_jit_roles OWNER TO postgres;

--
-- Name: organization_jit_sso_connectors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_jit_sso_connectors (
    tenant_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    sso_connector_id character varying(128) NOT NULL
);


ALTER TABLE public.organization_jit_sso_connectors OWNER TO postgres;

--
-- Name: organization_role_application_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_role_application_relations (
    tenant_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    organization_role_id character varying(21) NOT NULL,
    application_id character varying(21) NOT NULL,
    CONSTRAINT organization_role_application_relations__role_type CHECK (public.check_organization_role_type(organization_role_id, 'MachineToMachine'::public.role_type))
);


ALTER TABLE public.organization_role_application_relations OWNER TO postgres;

--
-- Name: organization_role_resource_scope_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_role_resource_scope_relations (
    tenant_id character varying(21) NOT NULL,
    organization_role_id character varying(21) NOT NULL,
    scope_id character varying(21) NOT NULL
);


ALTER TABLE public.organization_role_resource_scope_relations OWNER TO postgres;

--
-- Name: organization_role_scope_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_role_scope_relations (
    tenant_id character varying(21) NOT NULL,
    organization_role_id character varying(21) NOT NULL,
    organization_scope_id character varying(21) NOT NULL
);


ALTER TABLE public.organization_role_scope_relations OWNER TO postgres;

--
-- Name: organization_role_user_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_role_user_relations (
    tenant_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    organization_role_id character varying(21) NOT NULL,
    user_id character varying(21) NOT NULL,
    CONSTRAINT organization_role_user_relations__role_type CHECK (public.check_organization_role_type(organization_role_id, 'User'::public.role_type))
);


ALTER TABLE public.organization_role_user_relations OWNER TO postgres;

--
-- Name: organization_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_roles (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(256),
    type public.role_type DEFAULT 'User'::public.role_type NOT NULL
);


ALTER TABLE public.organization_roles OWNER TO postgres;

--
-- Name: organization_scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_scopes (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(256)
);


ALTER TABLE public.organization_scopes OWNER TO postgres;

--
-- Name: organization_user_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_user_relations (
    tenant_id character varying(21) NOT NULL,
    organization_id character varying(21) NOT NULL,
    user_id character varying(21) NOT NULL
);


ALTER TABLE public.organization_user_relations OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(256),
    custom_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_mfa_required boolean DEFAULT false NOT NULL,
    branding jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: passcodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passcodes (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    interaction_jti character varying(128),
    phone character varying(32),
    email character varying(128),
    type character varying(32) NOT NULL,
    code character varying(6) NOT NULL,
    consumed boolean DEFAULT false NOT NULL,
    try_count smallint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.passcodes OWNER TO postgres;

--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    tenant_id character varying(21) NOT NULL,
    user_id character varying(21) NOT NULL,
    name character varying(256) NOT NULL,
    value character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resources (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    name text NOT NULL,
    indicator text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    access_token_ttl bigint DEFAULT 3600 NOT NULL
);


ALTER TABLE public.resources OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(128) NOT NULL,
    type public.role_type DEFAULT 'User'::public.role_type NOT NULL,
    is_default boolean DEFAULT false NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles_scopes (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    role_id character varying(21) NOT NULL,
    scope_id character varying(21) NOT NULL
);


ALTER TABLE public.roles_scopes OWNER TO postgres;

--
-- Name: scopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scopes (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    resource_id character varying(21) NOT NULL,
    name character varying(256) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.scopes OWNER TO postgres;

--
-- Name: sentinel_activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sentinel_activities (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    target_type character varying(32) NOT NULL,
    target_hash character varying(64) NOT NULL,
    action character varying(64) NOT NULL,
    action_result public.sentinel_action_result NOT NULL,
    payload jsonb NOT NULL,
    decision public.sentinel_decision NOT NULL,
    decision_expires_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sentinel_activities OWNER TO postgres;

--
-- Name: service_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_logs (
    id character varying(21) NOT NULL,
    tenant_id character varying(21) NOT NULL,
    type character varying(64) NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.service_logs OWNER TO postgres;

--
-- Name: sign_in_experiences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sign_in_experiences (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    color jsonb NOT NULL,
    branding jsonb NOT NULL,
    language_info jsonb NOT NULL,
    terms_of_use_url character varying(2048),
    privacy_policy_url character varying(2048),
    agree_to_terms_policy public.agree_to_terms_policy DEFAULT 'Automatic'::public.agree_to_terms_policy NOT NULL,
    sign_in jsonb NOT NULL,
    sign_up jsonb NOT NULL,
    social_sign_in jsonb DEFAULT '{}'::jsonb NOT NULL,
    social_sign_in_connector_targets jsonb DEFAULT '[]'::jsonb NOT NULL,
    sign_in_mode public.sign_in_mode DEFAULT 'SignInAndRegister'::public.sign_in_mode NOT NULL,
    custom_css text,
    custom_content jsonb DEFAULT '{}'::jsonb NOT NULL,
    custom_ui_assets jsonb,
    password_policy jsonb DEFAULT '{}'::jsonb NOT NULL,
    mfa jsonb DEFAULT '{}'::jsonb NOT NULL,
    single_sign_on_enabled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.sign_in_experiences OWNER TO postgres;

--
-- Name: sso_connector_idp_initiated_auth_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sso_connector_idp_initiated_auth_configs (
    tenant_id character varying(21) NOT NULL,
    connector_id character varying(128) NOT NULL,
    default_application_id character varying(21) NOT NULL,
    redirect_uri text,
    auth_parameters jsonb DEFAULT '{}'::jsonb NOT NULL,
    auto_send_authorization_request boolean DEFAULT false NOT NULL,
    client_idp_initiated_auth_callback_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT application_type CHECK (public.check_application_type(default_application_id, VARIADIC ARRAY['Traditional'::public.application_type, 'SPA'::public.application_type]))
);


ALTER TABLE public.sso_connector_idp_initiated_auth_configs OWNER TO postgres;

--
-- Name: sso_connectors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sso_connectors (
    tenant_id character varying(21) NOT NULL,
    id character varying(128) NOT NULL,
    provider_name character varying(128) NOT NULL,
    connector_name character varying(128) NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    domains jsonb DEFAULT '[]'::jsonb NOT NULL,
    branding jsonb DEFAULT '{}'::jsonb NOT NULL,
    sync_profile boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sso_connectors OWNER TO postgres;

--
-- Name: subject_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_tokens (
    tenant_id character varying(21) NOT NULL,
    id character varying(25) NOT NULL,
    context jsonb DEFAULT '{}'::jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    consumed_at timestamp with time zone,
    user_id character varying(21) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    creator_id character varying(32) NOT NULL
);


ALTER TABLE public.subject_tokens OWNER TO postgres;

--
-- Name: systems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.systems (
    key character varying(256) NOT NULL,
    value jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.systems OWNER TO postgres;

--
-- Name: tenants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenants (
    id character varying(21) NOT NULL,
    db_user character varying(128),
    db_user_password character varying(128),
    name character varying(128) DEFAULT 'My Project'::character varying NOT NULL,
    tag character varying(64) DEFAULT 'development'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_suspended boolean DEFAULT false NOT NULL
);


ALTER TABLE public.tenants OWNER TO postgres;

--
-- Name: user_sso_identities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_sso_identities (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    user_id character varying(12) NOT NULL,
    issuer character varying(256) NOT NULL,
    identity_id character varying(128) NOT NULL,
    detail jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    sso_connector_id character varying(128) NOT NULL
);


ALTER TABLE public.user_sso_identities OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    tenant_id character varying(21) NOT NULL,
    id character varying(12) NOT NULL,
    username character varying(128),
    primary_email character varying(128),
    primary_phone character varying(128),
    password_encrypted character varying(128),
    password_encryption_method public.users_password_encryption_method,
    name character varying(128),
    avatar character varying(2048),
    profile jsonb DEFAULT '{}'::jsonb NOT NULL,
    application_id character varying(21),
    identities jsonb DEFAULT '{}'::jsonb NOT NULL,
    custom_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    logto_config jsonb DEFAULT '{}'::jsonb NOT NULL,
    mfa_verifications jsonb DEFAULT '[]'::jsonb NOT NULL,
    is_suspended boolean DEFAULT false NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_roles (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    user_id character varying(21) NOT NULL,
    role_id character varying(21) NOT NULL,
    CONSTRAINT users_roles__role_type CHECK (public.check_role_type(role_id, 'User'::public.role_type))
);


ALTER TABLE public.users_roles OWNER TO postgres;

--
-- Name: verification_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verification_records (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    user_id character varying(21),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.verification_records OWNER TO postgres;

--
-- Name: verification_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verification_statuses (
    tenant_id character varying(21) NOT NULL,
    id character varying(21) NOT NULL,
    user_id character varying(21) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    verified_identifier character varying(255)
);


ALTER TABLE public.verification_statuses OWNER TO postgres;

--
-- Data for Name: application_secrets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_secrets (tenant_id, application_id, name, value, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: application_sign_in_experiences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_sign_in_experiences (tenant_id, application_id, color, branding, terms_of_use_url, privacy_policy_url, display_name) FROM stdin;
\.


--
-- Data for Name: application_user_consent_organization_resource_scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_user_consent_organization_resource_scopes (tenant_id, application_id, scope_id) FROM stdin;
\.


--
-- Data for Name: application_user_consent_organization_scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_user_consent_organization_scopes (tenant_id, application_id, organization_scope_id) FROM stdin;
\.


--
-- Data for Name: application_user_consent_organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_user_consent_organizations (tenant_id, application_id, organization_id, user_id) FROM stdin;
\.


--
-- Data for Name: application_user_consent_resource_scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_user_consent_resource_scopes (tenant_id, application_id, scope_id) FROM stdin;
\.


--
-- Data for Name: application_user_consent_user_scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_user_consent_user_scopes (tenant_id, application_id, user_scope) FROM stdin;
\.


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applications (tenant_id, id, name, secret, description, type, oidc_client_metadata, custom_client_metadata, protected_app_metadata, custom_data, is_third_party, created_at) FROM stdin;
admin	0yvfkne9182vtg0fkrqmr	Cloud Service	EJg8Hce9VSA3NBci1rBJqSeSnQGxkoh8	Machine to machine application for tenant default	MachineToMachine	{"redirectUris": [], "postLogoutRedirectUris": []}	{"tenantId": "default"}	\N	{}	f	2024-11-09 21:35:11.787031+00
admin	admin-console	Admin Console	0prRkALMgNuQESMPkCYbigsGGeq8MBRD	Logto Admin Console.	SPA	{"redirectUris": [], "postLogoutRedirectUris": []}	{}	\N	{}	f	2024-11-09 21:35:11.787031+00
admin	m-default	Management API access for default	84m8pX0Au6Z3J0jGWUmjVDQL7K9acJ4p	Machine-to-machine app for accessing Management API of tenant 'default'.	MachineToMachine	{"redirectUris": [], "postLogoutRedirectUris": []}	{}	\N	{}	f	2024-11-09 21:35:11.787031+00
admin	m-admin	Management API access for admin	oyaYJ2m3Z58Ug9uq4SLl6pxQx5BmdlHm	Machine-to-machine app for accessing Management API of tenant 'admin'.	MachineToMachine	{"redirectUris": [], "postLogoutRedirectUris": []}	{}	\N	{}	f	2024-11-09 21:35:11.787031+00
default	1kumj8ov6qlzc4t5imnv0	TayTay Web Client	#internal:9hjIp9ODzAwSbOO4mC9baTxq6kryHnrA	\N	SPA	{"redirectUris": ["http://localhost:5173/callback"], "postLogoutRedirectUris": ["http://localhost:5173/"]}	{}	\N	{}	f	2024-11-09 21:36:17.460242+00
\.


--
-- Data for Name: applications_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applications_roles (tenant_id, id, application_id, role_id) FROM stdin;
admin	p4bfn5nx4q27yhq9whp5p	0yvfkne9182vtg0fkrqmr	b8n5i2s7ptrpbeb54kqv5
admin	arke6t0smyr9d0l9xr5i8	m-default	m-default
admin	1by7u1wd8mq49s735hvw3	m-admin	m-admin
\.


--
-- Data for Name: connectors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.connectors (tenant_id, id, sync_profile, connector_id, config, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: custom_phrases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.custom_phrases (tenant_id, id, language_tag, translation) FROM stdin;
\.


--
-- Data for Name: daily_active_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_active_users (id, tenant_id, user_id, date) FROM stdin;
ddi8h3umr5u8g4s5w1mxk	admin	2wz8vvrtgw3i	2024-11-09 21:35:48.366982+00
xz1ijv8j0gitcry4q7ir8	admin	2wz8vvrtgw3i	2024-11-09 21:35:48.589258+00
otsp5k4xpba90cuji5cem	admin	2wz8vvrtgw3i	2024-11-09 21:35:48.818798+00
2asi6rq142l12tuxxkhvt	admin	2wz8vvrtgw3i	2024-11-09 21:36:03.808261+00
k00iywdu5ji2o8zkc92fv	default	6rlc4e8ssvu4	2024-11-09 21:37:18.803925+00
laujdfgoqumobe3tcdkl4	default	6rlc4e8ssvu4	2024-11-09 21:37:18.985061+00
\.


--
-- Data for Name: daily_token_usage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_token_usage (id, tenant_id, usage, date) FROM stdin;
9pe5jwghhv2wbceddz1fx	admin	8	2024-11-09 00:00:00+00
n5emo2wx8xrwvobngi2vk	default	4	2024-11-09 00:00:00+00
\.


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domains (tenant_id, id, domain, status, error_message, dns_records, cloudflare_data, updated_at, created_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hooks (tenant_id, id, name, event, events, config, signing_key, enabled, created_at) FROM stdin;
\.


--
-- Data for Name: idp_initiated_saml_sso_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.idp_initiated_saml_sso_sessions (tenant_id, id, connector_id, assertion_content, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (tenant_id, id, key, payload, created_at) FROM stdin;
admin	09xym3s54nor37ilzesvu	Interaction.Create	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Create", "params": {"scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all", "state": "V9SmYrxxaCzv0sUo8-xxCl-kbWSSIogGXSDIgEmdMqHffnEms7FTPfrk3go29RFlds27sEHIWSvehxuSV5Fb7Q", "prompt": "login consent", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "client_id": "admin-console", "redirect_uri": "http://localhost:3002/console/callback", "response_type": "code", "code_challenge": "_Ky-q9NQ_OQFMLg0u3IZjZ_uU7_4YocinwQncw_qIZc", "code_challenge_method": "S256"}, "prompt": {"name": "login", "details": {}, "reasons": ["login_prompt", "no_session"]}, "result": "Success", "sessionId": "3-Db-ZNeqG2lfNtBkkMEQ", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "admin-console", "interactionId": "Iy0SqfNIdDsuUAtByPNpq"}	2024-11-09 21:35:31.299932+00
admin	o3kihkxqi7hi54yofsl0q	Interaction.Register.Update	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Update", "event": "Register", "result": "Success", "profile": {"username": "admin"}, "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0"}	2024-11-09 21:35:35.539951+00
admin	ynd1u4kaafdmyadb9kuh7	Interaction.Register.Submit	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Submit", "error": {"code": "user.missing_profile", "data": {"missingProfile": ["password"]}, "message": "You need to provide additional info before signing-in."}, "result": "Error", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "interaction": {"event": "Register", "profile": {"username": "admin"}}}	2024-11-09 21:35:35.569017+00
admin	b6xvli1i51bzt15ko0f8t	Interaction.Register.Profile.Update	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Profile.Update", "method": "PATCH", "result": "Success", "profile": {"password": "******"}, "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "interactionStorage": {"event": "Register", "profile": {"username": "admin"}}}	2024-11-09 21:35:45.202051+00
admin	qs505a7t3a6xrlah2ckfz	Interaction.Register.Submit	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Submit", "result": "Success", "userId": "2wz8vvrtgw3i", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "interaction": {"event": "Register", "profile": {"password": "******", "username": "admin"}}}	2024-11-09 21:35:47.262765+00
admin	6dhll47v927aomswooqr3	Interaction.End	{"ip": "::ffff:172.18.0.1", "key": "Interaction.End", "params": {"scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all", "state": "V9SmYrxxaCzv0sUo8-xxCl-kbWSSIogGXSDIgEmdMqHffnEms7FTPfrk3go29RFlds27sEHIWSvehxuSV5Fb7Q", "prompt": "login consent", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "client_id": "admin-console", "redirect_uri": "http://localhost:3002/console/callback", "response_type": "code", "code_challenge": "_Ky-q9NQ_OQFMLg0u3IZjZ_uU7_4YocinwQncw_qIZc", "code_challenge_method": "S256"}, "result": "Success", "sessionId": "tCyfCLIBOIbz38lgurGc8", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "admin-console", "interactionId": "Iy0SqfNIdDsuUAtByPNpq"}	2024-11-09 21:35:47.397745+00
admin	xuz0jtqdlrh3ayfqg183z	Interaction.Create	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Create", "params": {"scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all", "state": "V9SmYrxxaCzv0sUo8-xxCl-kbWSSIogGXSDIgEmdMqHffnEms7FTPfrk3go29RFlds27sEHIWSvehxuSV5Fb7Q", "prompt": "login consent", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "client_id": "admin-console", "redirect_uri": "http://localhost:3002/console/callback", "response_type": "code", "code_challenge": "_Ky-q9NQ_OQFMLg0u3IZjZ_uU7_4YocinwQncw_qIZc", "code_challenge_method": "S256"}, "prompt": {"name": "consent", "details": {"missingOIDCScope": ["openid", "offline_access", "profile", "email", "identities", "custom_data", "urn:logto:scope:organizations", "urn:logto:scope:organization_roles"], "missingResourceScopes": {"https://admin.logto.app/me": ["all"], "https://default.logto.app/api": ["all"]}}, "reasons": ["consent_prompt", "op_scopes_missing", "rs_scopes_missing"]}, "result": "Success", "userId": "2wz8vvrtgw3i", "sessionId": "tCyfCLIBOIbz38lgurGc8", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "admin-console", "interactionId": "hHiZsFM39AmUhazOpPe89"}	2024-11-09 21:35:47.398351+00
admin	62d4w4j5v3qjf2qznivuz	Interaction.End	{"ip": "::ffff:172.18.0.1", "key": "Interaction.End", "params": {"scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all", "state": "V9SmYrxxaCzv0sUo8-xxCl-kbWSSIogGXSDIgEmdMqHffnEms7FTPfrk3go29RFlds27sEHIWSvehxuSV5Fb7Q", "prompt": "login consent", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "client_id": "admin-console", "redirect_uri": "http://localhost:3002/console/callback", "response_type": "code", "code_challenge": "_Ky-q9NQ_OQFMLg0u3IZjZ_uU7_4YocinwQncw_qIZc", "code_challenge_method": "S256"}, "result": "Success", "sessionId": "Qe48YN3_QiOMnUvTw9yzw", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "admin-console", "interactionId": "hHiZsFM39AmUhazOpPe89"}	2024-11-09 21:35:47.562665+00
admin	qfxdr0xewi807jzk5tuty	ExchangeTokenBy.AuthorizationCode	{"ip": "::ffff:172.18.0.1", "key": "ExchangeTokenBy.AuthorizationCode", "scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles", "params": {"code": "-7u6GKCDESo1ykn3sxFgGn2CV302OzQFdIbd35NFRH7", "client_id": "admin-console", "grant_type": "authorization_code", "redirect_uri": "http://localhost:3002/console/callback", "code_verifier": "JTA5CnjkFSXIWWKxoXXaAihNju6l8qVoebSADp2MiacB_0hpN9QLLjybxRt5E_VyKGGZdWC1Y7zvmxzXqYektQ"}, "result": "Success", "userId": "2wz8vvrtgw3i", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "tokenTypes": ["AccessToken", "RefreshToken", "IdToken"], "applicationId": "admin-console"}	2024-11-09 21:35:48.431293+00
admin	u9afdon282q12gpf481d0	ExchangeTokenBy.RefreshToken	{"ip": "::ffff:172.18.0.1", "key": "ExchangeTokenBy.RefreshToken", "scope": "all", "params": {"resource": "https://admin.logto.app/me", "client_id": "admin-console", "grant_type": "refresh_token", "refresh_token": "wFasVL3aioZQ84RkICQMtbKJOB1GUuPTTCM8OrXWT5K"}, "result": "Success", "userId": "2wz8vvrtgw3i", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "tokenTypes": ["AccessToken", "RefreshToken", "IdToken"], "applicationId": "admin-console"}	2024-11-09 21:35:48.60271+00
admin	5umxv3lutk23ai97niwqj	ExchangeTokenBy.RefreshToken	{"ip": "::ffff:172.18.0.1", "key": "ExchangeTokenBy.RefreshToken", "scope": "", "params": {"client_id": "admin-console", "grant_type": "refresh_token", "refresh_token": "kJuOejgh-Z9L3MdV23gXjF-PTMdBZKorZtUuZ0pKsli", "organization_id": "t-default"}, "result": "Success", "userId": "2wz8vvrtgw3i", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "tokenTypes": ["AccessToken", "RefreshToken", "IdToken"], "applicationId": "admin-console"}	2024-11-09 21:35:48.829061+00
admin	86okztj9iux9d55o8li4n	ExchangeTokenBy.RefreshToken	{"ip": "::ffff:172.18.0.1", "key": "ExchangeTokenBy.RefreshToken", "scope": "all", "params": {"resource": "https://default.logto.app/api", "client_id": "admin-console", "grant_type": "refresh_token", "refresh_token": "S8RhPA34rDY8cfSO91-dS-fLrcVhxdFdFpw96da1_jb"}, "result": "Success", "userId": "2wz8vvrtgw3i", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "tokenTypes": ["AccessToken", "RefreshToken", "IdToken"], "applicationId": "admin-console"}	2024-11-09 21:36:03.856248+00
default	59wftnf484rjm2qao8z1s	Interaction.Create	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Create", "params": {"scope": "openid offline_access profile", "state": "rpUR5KlVbMmk4ilDumvEeNSVHVkQGNTqi-Rz0o0hDlAyvTUaWCOhJ061RfrHSNsGPk5cHlQy3CgfGYTshm5fLQ", "prompt": "consent", "resource": "http://localhost:8080/", "client_id": "1kumj8ov6qlzc4t5imnv0", "redirect_uri": "http://localhost:5173/callback", "response_type": "code", "code_challenge": "Uk_quSdetH2O3CzV0lCAqw8uBcpabB_ryMVwDShQwTU", "code_challenge_method": "S256"}, "prompt": {"name": "login", "details": {}, "reasons": ["no_session"]}, "result": "Success", "sessionId": "ke0Khho6SbeovkC3EJmTF", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "1kumj8ov6qlzc4t5imnv0", "interactionId": "fNTPJye-3ookzFLBU8WLd"}	2024-11-09 21:37:03.616329+00
default	tra6dbm9kd8l2ld8k1zzx	Interaction.Register.Update	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Update", "event": "Register", "result": "Success", "profile": {"username": "admin"}, "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0"}	2024-11-09 21:37:08.624467+00
default	ly6egmexsq450santwpj9	Interaction.Register.Submit	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Submit", "error": {"code": "user.missing_profile", "data": {"missingProfile": ["password"]}, "message": "You need to provide additional info before signing-in."}, "result": "Error", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "interaction": {"event": "Register", "profile": {"username": "admin"}}}	2024-11-09 21:37:08.657691+00
default	pxrxqmuv6q65wgw4irdzb	Interaction.Register.Profile.Update	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Profile.Update", "method": "PATCH", "result": "Success", "profile": {"password": "******"}, "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "interactionStorage": {"event": "Register", "profile": {"username": "admin"}}}	2024-11-09 21:37:16.12553+00
default	c6jzme3j2fowtc38sq3ke	Interaction.Register.Submit	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Register.Submit", "result": "Success", "userId": "6rlc4e8ssvu4", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "interaction": {"event": "Register", "profile": {"password": "******", "username": "admin"}}}	2024-11-09 21:37:17.860584+00
default	bjf7hlxrsjwu329lsfwrb	Interaction.Create	{"ip": "::ffff:172.18.0.1", "key": "Interaction.Create", "params": {"scope": "openid offline_access profile", "state": "rpUR5KlVbMmk4ilDumvEeNSVHVkQGNTqi-Rz0o0hDlAyvTUaWCOhJ061RfrHSNsGPk5cHlQy3CgfGYTshm5fLQ", "prompt": "consent", "resource": "http://localhost:8080/", "client_id": "1kumj8ov6qlzc4t5imnv0", "redirect_uri": "http://localhost:5173/callback", "response_type": "code", "code_challenge": "Uk_quSdetH2O3CzV0lCAqw8uBcpabB_ryMVwDShQwTU", "code_challenge_method": "S256"}, "prompt": {"name": "consent", "details": {"missingOIDCScope": ["openid", "offline_access", "profile"]}, "reasons": ["consent_prompt", "op_scopes_missing"]}, "result": "Success", "userId": "6rlc4e8ssvu4", "sessionId": "qJk2Lz7aDam-qf0geueae", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "1kumj8ov6qlzc4t5imnv0", "interactionId": "d6724bNT8cM89KVI3LJpk"}	2024-11-09 21:37:17.982432+00
default	lisk4sfz311x20poykwu3	Interaction.End	{"ip": "::ffff:172.18.0.1", "key": "Interaction.End", "params": {"scope": "openid offline_access profile", "state": "rpUR5KlVbMmk4ilDumvEeNSVHVkQGNTqi-Rz0o0hDlAyvTUaWCOhJ061RfrHSNsGPk5cHlQy3CgfGYTshm5fLQ", "prompt": "consent", "resource": "http://localhost:8080/", "client_id": "1kumj8ov6qlzc4t5imnv0", "redirect_uri": "http://localhost:5173/callback", "response_type": "code", "code_challenge": "Uk_quSdetH2O3CzV0lCAqw8uBcpabB_ryMVwDShQwTU", "code_challenge_method": "S256"}, "result": "Success", "sessionId": "qJk2Lz7aDam-qf0geueae", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "1kumj8ov6qlzc4t5imnv0", "interactionId": "fNTPJye-3ookzFLBU8WLd"}	2024-11-09 21:37:17.982153+00
default	z6dj6afa1zabmj0npuqhl	Interaction.End	{"ip": "::ffff:172.18.0.1", "key": "Interaction.End", "params": {"scope": "openid offline_access profile", "state": "rpUR5KlVbMmk4ilDumvEeNSVHVkQGNTqi-Rz0o0hDlAyvTUaWCOhJ061RfrHSNsGPk5cHlQy3CgfGYTshm5fLQ", "prompt": "consent", "resource": "http://localhost:8080/", "client_id": "1kumj8ov6qlzc4t5imnv0", "redirect_uri": "http://localhost:5173/callback", "response_type": "code", "code_challenge": "Uk_quSdetH2O3CzV0lCAqw8uBcpabB_ryMVwDShQwTU", "code_challenge_method": "S256"}, "result": "Success", "sessionId": "zuhHY06M-akAkD_Bxbx_I", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "applicationId": "1kumj8ov6qlzc4t5imnv0", "interactionId": "d6724bNT8cM89KVI3LJpk"}	2024-11-09 21:37:18.095612+00
default	zbdie2tvg1yfp2s3527kq	ExchangeTokenBy.AuthorizationCode	{"ip": "::ffff:172.18.0.1", "key": "ExchangeTokenBy.AuthorizationCode", "scope": "openid offline_access profile", "params": {"code": "PpsNwfN97Gbl5V0bXdBDjqDfSkkWCsExmLwfLnny7FY", "client_id": "1kumj8ov6qlzc4t5imnv0", "grant_type": "authorization_code", "redirect_uri": "http://localhost:5173/callback", "code_verifier": "_FM-JA51eof7FvTls6Dv783hwIP_liojlr__SgPJ6mABfJZADcaDK6sCRcE89344x9cZGnxZtl6Aob9sjVFCkg"}, "result": "Success", "userId": "6rlc4e8ssvu4", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "tokenTypes": ["AccessToken", "RefreshToken", "IdToken"], "applicationId": "1kumj8ov6qlzc4t5imnv0"}	2024-11-09 21:37:18.815297+00
default	95tstamihqkj0we1435ep	ExchangeTokenBy.RefreshToken	{"ip": "::ffff:172.18.0.1", "key": "ExchangeTokenBy.RefreshToken", "scope": "", "params": {"resource": "http://localhost:8080/", "client_id": "1kumj8ov6qlzc4t5imnv0", "grant_type": "refresh_token", "refresh_token": "xrkI1z2GSihxVx7SexdE_gEj5soc5NRcYGZaYxx0NbR"}, "result": "Success", "userId": "6rlc4e8ssvu4", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:132.0) Gecko/20100101 Firefox/132.0", "tokenTypes": ["AccessToken", "RefreshToken", "IdToken"], "applicationId": "1kumj8ov6qlzc4t5imnv0"}	2024-11-09 21:37:18.98825+00
\.


--
-- Data for Name: logto_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logto_configs (tenant_id, key, value) FROM stdin;
default	oidc.privateKeys	[{"id": "b0i56cwxv2m6pf1opa4v9", "value": "-----BEGIN PRIVATE KEY-----\\nMIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDBVoTYKE0snJo+5t4Zd\\nLGfp6rS9rRXOnQCHc3GKoJM1gtvhsBHL6RKusjshN6McSnyhZANiAAQU4oKpNxTF\\nXrMzoPNoG7Eko1KpGsYwwWrjPYxUjc0o4hUSyWiwKezMaCB4dhOu0QYhItGHl1EP\\nBRzYyIaPahYdau6SKU74ZKgxNjdtEU5sufvNxIVSqBSrQLkgvzbc9wE=\\n-----END PRIVATE KEY-----\\n", "createdAt": 1731188113}]
default	oidc.cookieKeys	[{"id": "ozcqa0xtvnppa0xqwf06v", "value": "E2vmzuSfWMvlWNYoGBFhSRi621c48NJx", "createdAt": 1731188113}]
admin	oidc.privateKeys	[{"id": "clsoxb5hgnmkd4tkiorcf", "value": "-----BEGIN PRIVATE KEY-----\\nMIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDCAR1l1FpNPnI5ILjQq\\nmKxXIzfylCa2wvuh61HS/Dp00dr0RiNjfuPcR+/KhSwUF++hZANiAAQdpUYt7ZR1\\nZetgB9irRss6klUtACPUk5t/1iIiIuElsc9Ow5FepbYt68I3pGvfDfxnwiy49wZd\\nPHqVrDFJL5+EmsCnHKd3dhtOAQ6IxWavcdfrHMKenhCoQywJ61/Cu8g=\\n-----END PRIVATE KEY-----\\n", "createdAt": 1731188113}]
admin	oidc.cookieKeys	[{"id": "kpilupoz3gli9sig2izno", "value": "7kTQECQlKb3pFbCfcoa7c67dxfJiObxY", "createdAt": 1731188113}]
default	adminConsole	{"organizationCreated": false, "signInExperienceCustomized": false}
admin	adminConsole	{"organizationCreated": false, "signInExperienceCustomized": false}
default	cloudConnection	{"appId": "0yvfkne9182vtg0fkrqmr", "resource": "https://cloud.logto.io/api", "appSecret": "EJg8Hce9VSA3NBci1rBJqSeSnQGxkoh8"}
\.


--
-- Data for Name: oidc_model_instances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oidc_model_instances (tenant_id, model_name, id, payload, expires_at, consumed_at) FROM stdin;
admin	Grant	mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW	{"exp": 1732397747, "iat": 1731188147, "jti": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "kind": "Grant", "openid": {"scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles"}, "clientId": "admin-console", "accountId": "2wz8vvrtgw3i", "resources": {"https://admin.logto.app/me": "all", "https://default.logto.app/api": "all"}}	2024-11-23 21:35:47.442+00	\N
admin	Session	Qe48YN3_QiOMnUvTw9yzw	{"exp": 1732397747, "iat": 1731188147, "jti": "Qe48YN3_QiOMnUvTw9yzw", "uid": "bkn82U7TTysAl9r9UWYOL", "kind": "Session", "loginTs": 1731188147, "accountId": "2wz8vvrtgw3i", "authorizations": {"admin-console": {"sid": "T0zsQzUHDuHbyspeEFeZy", "grantId": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "persistsLogout": true}}}	2024-11-23 21:35:47.556+00	\N
admin	AuthorizationCode	-7u6GKCDESo1ykn3sxFgGn2CV302OzQFdIbd35NFRH7	{"exp": 1731188207, "iat": 1731188147, "jti": "-7u6GKCDESo1ykn3sxFgGn2CV302OzQFdIbd35NFRH7", "kind": "AuthorizationCode", "scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all ", "claims": {"id_token": {"auth_time": {"essential": true}}}, "grantId": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "authTime": 1731188147, "clientId": "admin-console", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "accountId": "2wz8vvrtgw3i", "sessionUid": "bkn82U7TTysAl9r9UWYOL", "redirectUri": "http://localhost:3002/console/callback", "codeChallenge": "_Ky-q9NQ_OQFMLg0u3IZjZ_uU7_4YocinwQncw_qIZc", "codeChallengeMethod": "S256"}	2024-11-09 21:36:47.533+00	2024-11-09 21:35:48.339+00
admin	AccessToken	bgirs9A9jknABSR8_vqVh2vSAHANGFQ0zeHjsC_RPUH	{"exp": 1731191748, "gty": "authorization_code", "iat": 1731188148, "jti": "bgirs9A9jknABSR8_vqVh2vSAHANGFQ0zeHjsC_RPUH", "kind": "AccessToken", "scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles", "claims": {"id_token": {"auth_time": {"essential": true}}}, "grantId": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "clientId": "admin-console", "accountId": "2wz8vvrtgw3i", "sessionUid": "bkn82U7TTysAl9r9UWYOL"}	2024-11-09 22:35:48.36+00	\N
admin	RefreshToken	wFasVL3aioZQ84RkICQMtbKJOB1GUuPTTCM8OrXWT5K	{"exp": 1732397748, "gty": "authorization_code", "iat": 1731188148, "jti": "wFasVL3aioZQ84RkICQMtbKJOB1GUuPTTCM8OrXWT5K", "iiat": 1731188148, "kind": "RefreshToken", "scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all ", "claims": {"id_token": {"auth_time": {"essential": true}}}, "grantId": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "authTime": 1731188147, "clientId": "admin-console", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "accountId": "2wz8vvrtgw3i", "rotations": 0, "sessionUid": "bkn82U7TTysAl9r9UWYOL"}	2024-11-23 21:35:48.365+00	2024-11-09 21:35:48.548+00
admin	RefreshToken	kJuOejgh-Z9L3MdV23gXjF-PTMdBZKorZtUuZ0pKsli	{"exp": 1732397748, "gty": "authorization_code refresh_token", "iat": 1731188148, "jti": "kJuOejgh-Z9L3MdV23gXjF-PTMdBZKorZtUuZ0pKsli", "iiat": 1731188148, "kind": "RefreshToken", "scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all ", "claims": {"id_token": {"auth_time": {"essential": true}}}, "grantId": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "authTime": 1731188147, "clientId": "admin-console", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "accountId": "2wz8vvrtgw3i", "rotations": 1, "sessionUid": "bkn82U7TTysAl9r9UWYOL"}	2024-11-23 21:35:48.552+00	2024-11-09 21:35:48.789+00
admin	RefreshToken	S8RhPA34rDY8cfSO91-dS-fLrcVhxdFdFpw96da1_jb	{"exp": 1732397748, "gty": "authorization_code refresh_token", "iat": 1731188148, "jti": "S8RhPA34rDY8cfSO91-dS-fLrcVhxdFdFpw96da1_jb", "iiat": 1731188148, "kind": "RefreshToken", "scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all ", "claims": {"id_token": {"auth_time": {"essential": true}}}, "grantId": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "authTime": 1731188147, "clientId": "admin-console", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "accountId": "2wz8vvrtgw3i", "rotations": 2, "sessionUid": "bkn82U7TTysAl9r9UWYOL"}	2024-11-23 21:35:48.794+00	2024-11-09 21:36:03.719+00
admin	RefreshToken	6rjd8UOBdhkqc_3ZVAbjWTLTq2b61GIjBQMojgAdaEX	{"exp": 1732397748, "gty": "authorization_code refresh_token", "iat": 1731188163, "jti": "6rjd8UOBdhkqc_3ZVAbjWTLTq2b61GIjBQMojgAdaEX", "iiat": 1731188148, "kind": "RefreshToken", "scope": "openid offline_access profile email identities custom_data urn:logto:scope:organizations urn:logto:scope:organization_roles all ", "claims": {"id_token": {"auth_time": {"essential": true}}}, "grantId": "mbvfZ3Qku1QrMQphGVv0LmuCRXX-kkEbkdiF0fnxogW", "authTime": 1731188147, "clientId": "admin-console", "resource": ["https://default.logto.app/api", "https://admin.logto.app/me", "urn:logto:resource:organizations"], "accountId": "2wz8vvrtgw3i", "rotations": 3, "sessionUid": "bkn82U7TTysAl9r9UWYOL"}	2024-11-23 21:35:48.724+00	\N
default	Grant	N7biKdlOMHu-e90guYdJwDCGcTgFsTRIH8UogCpWBoP	{"exp": 1732397838, "iat": 1731188238, "jti": "N7biKdlOMHu-e90guYdJwDCGcTgFsTRIH8UogCpWBoP", "kind": "Grant", "openid": {"scope": "openid offline_access profile"}, "clientId": "1kumj8ov6qlzc4t5imnv0", "accountId": "6rlc4e8ssvu4"}	2024-11-23 21:37:18.037+00	\N
default	Session	zuhHY06M-akAkD_Bxbx_I	{"exp": 1732397838, "iat": 1731188237, "jti": "zuhHY06M-akAkD_Bxbx_I", "uid": "WkQ2j2JrDuZT1NUYG0Pwn", "kind": "Session", "loginTs": 1731188238, "accountId": "6rlc4e8ssvu4", "authorizations": {"1kumj8ov6qlzc4t5imnv0": {"sid": "WzVzpWapcVOsC3z3TqBqb", "grantId": "N7biKdlOMHu-e90guYdJwDCGcTgFsTRIH8UogCpWBoP", "persistsLogout": true}}}	2024-11-23 21:37:18.092+00	\N
default	AuthorizationCode	PpsNwfN97Gbl5V0bXdBDjqDfSkkWCsExmLwfLnny7FY	{"exp": 1731188298, "iat": 1731188238, "jti": "PpsNwfN97Gbl5V0bXdBDjqDfSkkWCsExmLwfLnny7FY", "kind": "AuthorizationCode", "scope": "openid offline_access profile ", "grantId": "N7biKdlOMHu-e90guYdJwDCGcTgFsTRIH8UogCpWBoP", "authTime": 1731188238, "clientId": "1kumj8ov6qlzc4t5imnv0", "resource": "http://localhost:8080/", "accountId": "6rlc4e8ssvu4", "sessionUid": "WkQ2j2JrDuZT1NUYG0Pwn", "redirectUri": "http://localhost:5173/callback", "codeChallenge": "Uk_quSdetH2O3CzV0lCAqw8uBcpabB_ryMVwDShQwTU", "codeChallengeMethod": "S256"}	2024-11-09 21:38:18.086+00	2024-11-09 21:37:18.792+00
default	AccessToken	Bjae_1-vxyppNo2XM1i0r4B-mahGP014pO8OaGwmYpS	{"exp": 1731191838, "gty": "authorization_code", "iat": 1731188238, "jti": "Bjae_1-vxyppNo2XM1i0r4B-mahGP014pO8OaGwmYpS", "kind": "AccessToken", "scope": "openid offline_access profile", "grantId": "N7biKdlOMHu-e90guYdJwDCGcTgFsTRIH8UogCpWBoP", "clientId": "1kumj8ov6qlzc4t5imnv0", "accountId": "6rlc4e8ssvu4", "sessionUid": "WkQ2j2JrDuZT1NUYG0Pwn"}	2024-11-09 22:37:18.799+00	\N
default	RefreshToken	xrkI1z2GSihxVx7SexdE_gEj5soc5NRcYGZaYxx0NbR	{"exp": 1732397838, "gty": "authorization_code", "iat": 1731188238, "jti": "xrkI1z2GSihxVx7SexdE_gEj5soc5NRcYGZaYxx0NbR", "iiat": 1731188238, "kind": "RefreshToken", "scope": "openid offline_access profile ", "grantId": "N7biKdlOMHu-e90guYdJwDCGcTgFsTRIH8UogCpWBoP", "authTime": 1731188238, "clientId": "1kumj8ov6qlzc4t5imnv0", "resource": "http://localhost:8080/", "accountId": "6rlc4e8ssvu4", "rotations": 0, "sessionUid": "WkQ2j2JrDuZT1NUYG0Pwn"}	2024-11-23 21:37:18.803+00	2024-11-09 21:37:18.944+00
default	RefreshToken	-dxX7IB0wZD2V3vlxhIHjag1wIksvlCLGXc_OwySYI1	{"exp": 1732397838, "gty": "authorization_code refresh_token", "iat": 1731188238, "jti": "-dxX7IB0wZD2V3vlxhIHjag1wIksvlCLGXc_OwySYI1", "iiat": 1731188238, "kind": "RefreshToken", "scope": "openid offline_access profile ", "grantId": "N7biKdlOMHu-e90guYdJwDCGcTgFsTRIH8UogCpWBoP", "authTime": 1731188238, "clientId": "1kumj8ov6qlzc4t5imnv0", "resource": "http://localhost:8080/", "accountId": "6rlc4e8ssvu4", "rotations": 1, "sessionUid": "WkQ2j2JrDuZT1NUYG0Pwn"}	2024-11-23 21:37:18.949+00	\N
\.


--
-- Data for Name: organization_application_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_application_relations (tenant_id, organization_id, application_id) FROM stdin;
\.


--
-- Data for Name: organization_invitation_role_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_invitation_role_relations (tenant_id, organization_invitation_id, organization_role_id) FROM stdin;
\.


--
-- Data for Name: organization_invitations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_invitations (tenant_id, id, inviter_id, invitee, accepted_user_id, organization_id, status, created_at, updated_at, expires_at) FROM stdin;
\.


--
-- Data for Name: organization_jit_email_domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_jit_email_domains (tenant_id, organization_id, email_domain) FROM stdin;
\.


--
-- Data for Name: organization_jit_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_jit_roles (tenant_id, organization_id, organization_role_id) FROM stdin;
\.


--
-- Data for Name: organization_jit_sso_connectors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_jit_sso_connectors (tenant_id, organization_id, sso_connector_id) FROM stdin;
\.


--
-- Data for Name: organization_role_application_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_role_application_relations (tenant_id, organization_id, organization_role_id, application_id) FROM stdin;
\.


--
-- Data for Name: organization_role_resource_scope_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_role_resource_scope_relations (tenant_id, organization_role_id, scope_id) FROM stdin;
\.


--
-- Data for Name: organization_role_scope_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_role_scope_relations (tenant_id, organization_role_id, organization_scope_id) FROM stdin;
admin	admin	read-data
admin	admin	write-data
admin	admin	delete-data
admin	admin	read-member
admin	admin	invite-member
admin	admin	remove-member
admin	admin	update-member-role
admin	admin	manage-tenant
admin	collaborator	read-data
admin	collaborator	write-data
admin	collaborator	delete-data
admin	collaborator	read-member
\.


--
-- Data for Name: organization_role_user_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_role_user_relations (tenant_id, organization_id, organization_role_id, user_id) FROM stdin;
admin	t-default	admin	2wz8vvrtgw3i
\.


--
-- Data for Name: organization_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_roles (tenant_id, id, name, description, type) FROM stdin;
admin	admin	admin	Admin of the tenant, who has all permissions.	User
admin	collaborator	collaborator	Collaborator of the tenant, who has permissions to operate the tenant data, but not the tenant settings.	User
\.


--
-- Data for Name: organization_scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_scopes (tenant_id, id, name, description) FROM stdin;
admin	read-data	read:data	Read the tenant data.
admin	write-data	write:data	Write the tenant data, including creating and updating the tenant.
admin	delete-data	delete:data	Delete data of the tenant.
admin	read-member	read:member	Read members of the tenant.
admin	invite-member	invite:member	Invite members to the tenant.
admin	remove-member	remove:member	Remove members from the tenant.
admin	update-member-role	update:member:role	Update the role of a member in the tenant.
admin	manage-tenant	manage:tenant	Manage the tenant settings, including name, billing, etc.
\.


--
-- Data for Name: organization_user_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_user_relations (tenant_id, organization_id, user_id) FROM stdin;
admin	t-default	2wz8vvrtgw3i
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (tenant_id, id, name, description, custom_data, is_mfa_required, branding, created_at) FROM stdin;
admin	t-default	Tenant default	\N	{}	f	{}	2024-11-09 21:35:11.787031+00
admin	t-admin	Tenant admin	\N	{}	f	{}	2024-11-09 21:35:11.787031+00
\.


--
-- Data for Name: passcodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passcodes (tenant_id, id, interaction_jti, phone, email, type, code, consumed, try_count, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (tenant_id, user_id, name, value, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resources (tenant_id, id, name, indicator, is_default, access_token_ttl) FROM stdin;
default	management-api	Logto Management API	https://default.logto.app/api	f	3600
admin	uu614v2we47yqooikzot8	Logto Management API for tenant default	https://default.logto.app/api	f	3600
admin	m769osddizk0f4k4saxas	Logto Management API for tenant admin	https://admin.logto.app/api	f	3600
admin	ja74rfnrjhme5akjs29df	Logto Me API	https://admin.logto.app/me	f	3600
admin	az1x5hqg3ppnfhmzh6rzj	Logto Cloud API	https://cloud.logto.io/api	f	3600
default	t1cwl8x05fjwq8ww0cmke	TayTay Server	http://localhost:8080/	f	3600
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (tenant_id, id, name, description, type, is_default) FROM stdin;
default	admin-role	#internal:admin	Internal admin role for Logto tenant default.	MachineToMachine	f
default	6sg5gs0iwcc40xl30lzqn	Logto Management API access	This default role grants access to the Logto management API.	MachineToMachine	f
admin	m-default	machine:mapi:default	Machine-to-machine role for accessing Management API of tenant 'default'.	MachineToMachine	f
admin	m-admin	machine:mapi:admin	Machine-to-machine role for accessing Management API of tenant 'admin'.	MachineToMachine	f
admin	ctfwrok015bax4tcu2x9j	user	Default role for admin tenant.	User	f
admin	b8n5i2s7ptrpbeb54kqv5	tenantApplication	The role for M2M applications that represent a user tenant and send requests to Logto Cloud.	MachineToMachine	f
admin	gibqucop9jhga83mm7ae8	default:admin	Legacy user role for accessing default Management API. Used in OSS only.	User	f
\.


--
-- Data for Name: roles_scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles_scopes (tenant_id, id, role_id, scope_id) FROM stdin;
default	05660qp22rh8d1acski8l	admin-role	management-api-all
default	rmcz21nk4zk1kd35qnlqw	6sg5gs0iwcc40xl30lzqn	management-api-all
admin	ivzm1swycqoyyaaxcaizk	m-default	76bnlpmym0bvavz7xnggk
admin	husb7mu22u1b2ec2u4785	m-admin	5yo6wwgoqc3kwhzi6n877
admin	q93xx29fdmh2h34ezvd3x	ctfwrok015bax4tcu2x9j	87s90muw6mwjwmxzd272a
admin	fc6dd6bmn9y1idyio676b	ctfwrok015bax4tcu2x9j	qco94jial8dc4l18gm2fa
admin	gmpitze1fgsw6nsup5lm9	ctfwrok015bax4tcu2x9j	vpval11tnamc5bhkvrg54
admin	kxd113nuw1uu7tygb1nib	b8n5i2s7ptrpbeb54kqv5	51sesvf8rti7b94v2oip9
admin	tfvbnd3cnaiypzaqabf4a	b8n5i2s7ptrpbeb54kqv5	yv5jfr5sase4t7yzikzyz
admin	9j2ax4z40seegk3drqs21	b8n5i2s7ptrpbeb54kqv5	zafw5gamtl9vm1tbzbfwr
admin	f1n46uvi2u4yubwcwari3	b8n5i2s7ptrpbeb54kqv5	3jlnml2cg0rn5zyxmiwhy
admin	3g6yueg6xja8nkuj6yonz	gibqucop9jhga83mm7ae8	76bnlpmym0bvavz7xnggk
\.


--
-- Data for Name: scopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scopes (tenant_id, id, resource_id, name, description, created_at) FROM stdin;
default	management-api-all	management-api	all	Default scope for Management API, allows all permissions.	2024-11-09 21:35:11.787031+00
admin	76bnlpmym0bvavz7xnggk	uu614v2we47yqooikzot8	all	Default scope for Management API, allows all permissions.	2024-11-09 21:35:11.787031+00
admin	5yo6wwgoqc3kwhzi6n877	m769osddizk0f4k4saxas	all	Default scope for Management API, allows all permissions.	2024-11-09 21:35:11.787031+00
admin	87s90muw6mwjwmxzd272a	ja74rfnrjhme5akjs29df	all	Default scope for Me API, allows all permissions.	2024-11-09 21:35:11.787031+00
admin	qco94jial8dc4l18gm2fa	az1x5hqg3ppnfhmzh6rzj	create:tenant	Allow creating new tenants.	2024-11-09 21:35:11.787031+00
admin	vpval11tnamc5bhkvrg54	az1x5hqg3ppnfhmzh6rzj	manage:tenant:self	Allow managing tenant itself, including update and delete.	2024-11-09 21:35:11.787031+00
admin	51sesvf8rti7b94v2oip9	az1x5hqg3ppnfhmzh6rzj	send:email	Allow sending emails. This scope is only available to M2M application.	2024-11-09 21:35:11.787031+00
admin	yv5jfr5sase4t7yzikzyz	az1x5hqg3ppnfhmzh6rzj	send:sms	Allow sending SMS. This scope is only available to M2M application.	2024-11-09 21:35:11.787031+00
admin	zafw5gamtl9vm1tbzbfwr	az1x5hqg3ppnfhmzh6rzj	fetch:custom:jwt	Allow accessing external resource to execute JWT payload customizer script and fetch the parsed token payload.	2024-11-09 21:35:11.787031+00
admin	3jlnml2cg0rn5zyxmiwhy	az1x5hqg3ppnfhmzh6rzj	report:subscription:updates	Allow reporting changes on Stripe subscription to Logto Cloud.	2024-11-09 21:35:11.787031+00
admin	lrcgyfpu733w1r6m6um2r	az1x5hqg3ppnfhmzh6rzj	create:affiliate	Allow creating new affiliates and logs.	2024-11-09 21:35:11.787031+00
admin	f06b65nndtbjdxyhocmvp	az1x5hqg3ppnfhmzh6rzj	manage:affiliate	Allow managing affiliates, including create, update, and delete.	2024-11-09 21:35:11.787031+00
\.


--
-- Data for Name: sentinel_activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sentinel_activities (tenant_id, id, target_type, target_hash, action, action_result, payload, decision, decision_expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: service_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_logs (id, tenant_id, type, payload, created_at) FROM stdin;
\.


--
-- Data for Name: sign_in_experiences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sign_in_experiences (tenant_id, id, color, branding, language_info, terms_of_use_url, privacy_policy_url, agree_to_terms_policy, sign_in, sign_up, social_sign_in, social_sign_in_connector_targets, sign_in_mode, custom_css, custom_content, custom_ui_assets, password_policy, mfa, single_sign_on_enabled) FROM stdin;
default	default	{"primaryColor": "#6139F6", "darkPrimaryColor": "#8768F8", "isDarkModeEnabled": false}	{"logoUrl": "https://logto.io/logo.svg", "darkLogoUrl": "https://logto.io/logo-dark.svg"}	{"autoDetect": true, "fallbackLanguage": "en"}	\N	\N	Automatic	{"methods": [{"password": true, "identifier": "username", "verificationCode": false, "isPasswordPrimary": true}]}	{"verify": false, "password": true, "identifiers": ["username"]}	{}	[]	SignInAndRegister	\N	{}	\N	{}	{"policy": "UserControlled", "factors": []}	f
admin	default	{"primaryColor": "#6139F6", "darkPrimaryColor": "#8768F8", "isDarkModeEnabled": true}	{"logoUrl": "https://logto.io/logo.svg", "darkLogoUrl": "https://logto.io/logo-dark.svg"}	{"autoDetect": true, "fallbackLanguage": "en"}	\N	\N	Automatic	{"methods": [{"password": true, "identifier": "username", "verificationCode": false, "isPasswordPrimary": true}]}	{"verify": false, "password": true, "identifiers": ["username"]}	{}	[]	SignIn	\N	{}	\N	{}	{"policy": "UserControlled", "factors": []}	f
\.


--
-- Data for Name: sso_connector_idp_initiated_auth_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sso_connector_idp_initiated_auth_configs (tenant_id, connector_id, default_application_id, redirect_uri, auth_parameters, auto_send_authorization_request, client_idp_initiated_auth_callback_uri, created_at) FROM stdin;
\.


--
-- Data for Name: sso_connectors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sso_connectors (tenant_id, id, provider_name, connector_name, config, domains, branding, sync_profile, created_at) FROM stdin;
\.


--
-- Data for Name: subject_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subject_tokens (tenant_id, id, context, expires_at, consumed_at, user_id, created_at, creator_id) FROM stdin;
\.


--
-- Data for Name: systems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.systems (key, value) FROM stdin;
alterationState	{"timestamp": 1728887713, "updatedAt": "2024-11-09T21:35:13.282Z"}
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenants (id, db_user, db_user_password, name, tag, created_at, is_suspended) FROM stdin;
default	logto_tenant_logto_default	yk8q7y1ulistun9kiios3a8m7a1za7mg	My Project	development	2024-11-09 21:35:11.787031+00	f
admin	logto_tenant_logto_admin	txnksou3zk8jzehmuj3dk3u2g1ld3qet	My Project	development	2024-11-09 21:35:11.787031+00	f
\.


--
-- Data for Name: user_sso_identities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_sso_identities (tenant_id, id, user_id, issuer, identity_id, detail, created_at, sso_connector_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (tenant_id, id, username, primary_email, primary_phone, password_encrypted, password_encryption_method, name, avatar, profile, application_id, identities, custom_data, logto_config, mfa_verifications, is_suspended, last_sign_in_at, created_at, updated_at) FROM stdin;
admin	2wz8vvrtgw3i	admin	\N	\N	$argon2i$v=19$m=4096,t=256,p=1$VwlfigUgswg26W1AFBBJvg$/yj6FwWldkcOf+BhwhpMqpCO2NoqM6CEYc5gWocZR3Y	Argon2i	\N	\N	{}	admin-console	{}	{}	{}	[]	f	2024-11-09 21:35:47.143+00	2024-11-09 21:35:47.178517+00	2024-11-09 21:35:47.437796+00
default	6rlc4e8ssvu4	admin	\N	\N	$argon2i$v=19$m=4096,t=256,p=1$SDKZWq2a01wQIMD/jV9nVQ$ruq2cals7DxVsljPD/HnVwbLmowHo+o+ejwIm/gDWEE	Argon2i	\N	\N	{}	1kumj8ov6qlzc4t5imnv0	{}	{}	{}	[]	f	2024-11-09 21:37:17.809+00	2024-11-09 21:37:17.816497+00	2024-11-09 21:37:18.033858+00
\.


--
-- Data for Name: users_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_roles (tenant_id, id, user_id, role_id) FROM stdin;
admin	jduzxm6ebvggr3iz2bj4a	2wz8vvrtgw3i	ctfwrok015bax4tcu2x9j
admin	7u8iuxkgzvn2jkuckg54y	2wz8vvrtgw3i	gibqucop9jhga83mm7ae8
\.


--
-- Data for Name: verification_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verification_records (tenant_id, id, user_id, created_at, expires_at, data) FROM stdin;
\.


--
-- Data for Name: verification_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verification_statuses (tenant_id, id, user_id, created_at, verified_identifier) FROM stdin;
\.


--
-- Name: application_secrets application_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_secrets
    ADD CONSTRAINT application_secrets_pkey PRIMARY KEY (tenant_id, application_id, name);


--
-- Name: application_sign_in_experiences application_sign_in_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_sign_in_experiences
    ADD CONSTRAINT application_sign_in_experiences_pkey PRIMARY KEY (tenant_id, application_id);


--
-- Name: application_user_consent_organization_resource_scopes application_user_consent_organization_resource_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_resource_scopes
    ADD CONSTRAINT application_user_consent_organization_resource_scopes_pkey PRIMARY KEY (application_id, scope_id);


--
-- Name: application_user_consent_organization_scopes application_user_consent_organization_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_scopes
    ADD CONSTRAINT application_user_consent_organization_scopes_pkey PRIMARY KEY (application_id, organization_scope_id);


--
-- Name: application_user_consent_organizations application_user_consent_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organizations
    ADD CONSTRAINT application_user_consent_organizations_pkey PRIMARY KEY (tenant_id, application_id, organization_id, user_id);


--
-- Name: application_user_consent_resource_scopes application_user_consent_resource_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_resource_scopes
    ADD CONSTRAINT application_user_consent_resource_scopes_pkey PRIMARY KEY (application_id, scope_id);


--
-- Name: application_user_consent_user_scopes application_user_consent_user_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_user_scopes
    ADD CONSTRAINT application_user_consent_user_scopes_pkey PRIMARY KEY (application_id, user_scope);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: applications_roles applications_roles__application_id_role_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications_roles
    ADD CONSTRAINT applications_roles__application_id_role_id UNIQUE (tenant_id, application_id, role_id);


--
-- Name: applications_roles applications_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications_roles
    ADD CONSTRAINT applications_roles_pkey PRIMARY KEY (id);


--
-- Name: connectors connectors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.connectors
    ADD CONSTRAINT connectors_pkey PRIMARY KEY (id);


--
-- Name: custom_phrases custom_phrases__language_tag; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_phrases
    ADD CONSTRAINT custom_phrases__language_tag UNIQUE (tenant_id, language_tag);


--
-- Name: custom_phrases custom_phrases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_phrases
    ADD CONSTRAINT custom_phrases_pkey PRIMARY KEY (id);


--
-- Name: daily_active_users daily_active_users__user_id_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_active_users
    ADD CONSTRAINT daily_active_users__user_id_date UNIQUE (user_id, date);


--
-- Name: daily_active_users daily_active_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_active_users
    ADD CONSTRAINT daily_active_users_pkey PRIMARY KEY (id);


--
-- Name: daily_token_usage daily_token_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_token_usage
    ADD CONSTRAINT daily_token_usage_pkey PRIMARY KEY (id);


--
-- Name: domains domains__domain; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains__domain UNIQUE (tenant_id, domain);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: idp_initiated_saml_sso_sessions idp_initiated_saml_sso_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idp_initiated_saml_sso_sessions
    ADD CONSTRAINT idp_initiated_saml_sso_sessions_pkey PRIMARY KEY (tenant_id, id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: logto_configs logto_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logto_configs
    ADD CONSTRAINT logto_configs_pkey PRIMARY KEY (tenant_id, key);


--
-- Name: oidc_model_instances oidc_model_instances__model_name_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oidc_model_instances
    ADD CONSTRAINT oidc_model_instances__model_name_id UNIQUE (tenant_id, model_name, id);


--
-- Name: oidc_model_instances oidc_model_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oidc_model_instances
    ADD CONSTRAINT oidc_model_instances_pkey PRIMARY KEY (id);


--
-- Name: organization_application_relations organization_application_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_application_relations
    ADD CONSTRAINT organization_application_relations_pkey PRIMARY KEY (tenant_id, organization_id, application_id);


--
-- Name: organization_invitation_role_relations organization_invitation_role_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitation_role_relations
    ADD CONSTRAINT organization_invitation_role_relations_pkey PRIMARY KEY (tenant_id, organization_invitation_id, organization_role_id);


--
-- Name: organization_invitations organization_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitations
    ADD CONSTRAINT organization_invitations_pkey PRIMARY KEY (id);


--
-- Name: organization_jit_email_domains organization_jit_email_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_email_domains
    ADD CONSTRAINT organization_jit_email_domains_pkey PRIMARY KEY (tenant_id, organization_id, email_domain);


--
-- Name: organization_jit_roles organization_jit_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_roles
    ADD CONSTRAINT organization_jit_roles_pkey PRIMARY KEY (tenant_id, organization_id, organization_role_id);


--
-- Name: organization_jit_sso_connectors organization_jit_sso_connectors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_sso_connectors
    ADD CONSTRAINT organization_jit_sso_connectors_pkey PRIMARY KEY (tenant_id, organization_id, sso_connector_id);


--
-- Name: organization_role_application_relations organization_role_application_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_application_relations
    ADD CONSTRAINT organization_role_application_relations_pkey PRIMARY KEY (tenant_id, organization_id, organization_role_id, application_id);


--
-- Name: organization_role_resource_scope_relations organization_role_resource_scope_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_resource_scope_relations
    ADD CONSTRAINT organization_role_resource_scope_relations_pkey PRIMARY KEY (tenant_id, organization_role_id, scope_id);


--
-- Name: organization_role_scope_relations organization_role_scope_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_scope_relations
    ADD CONSTRAINT organization_role_scope_relations_pkey PRIMARY KEY (tenant_id, organization_role_id, organization_scope_id);


--
-- Name: organization_role_user_relations organization_role_user_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_user_relations
    ADD CONSTRAINT organization_role_user_relations_pkey PRIMARY KEY (tenant_id, organization_id, organization_role_id, user_id);


--
-- Name: organization_roles organization_roles__name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_roles
    ADD CONSTRAINT organization_roles__name UNIQUE (tenant_id, name);


--
-- Name: organization_roles organization_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_roles
    ADD CONSTRAINT organization_roles_pkey PRIMARY KEY (id);


--
-- Name: organization_scopes organization_scopes__name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_scopes
    ADD CONSTRAINT organization_scopes__name UNIQUE (tenant_id, name);


--
-- Name: organization_scopes organization_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_scopes
    ADD CONSTRAINT organization_scopes_pkey PRIMARY KEY (id);


--
-- Name: organization_user_relations organization_user_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_user_relations
    ADD CONSTRAINT organization_user_relations_pkey PRIMARY KEY (tenant_id, organization_id, user_id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: passcodes passcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passcodes
    ADD CONSTRAINT passcodes_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (tenant_id, user_id, name);


--
-- Name: resources resources__indicator; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources__indicator UNIQUE (tenant_id, indicator);


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: roles roles__name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles__name UNIQUE (tenant_id, name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles_scopes roles_scopes__role_id_scope_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_scopes
    ADD CONSTRAINT roles_scopes__role_id_scope_id UNIQUE (tenant_id, role_id, scope_id);


--
-- Name: roles_scopes roles_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_scopes
    ADD CONSTRAINT roles_scopes_pkey PRIMARY KEY (id);


--
-- Name: scopes scopes__resource_id_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scopes
    ADD CONSTRAINT scopes__resource_id_name UNIQUE (tenant_id, resource_id, name);


--
-- Name: scopes scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scopes
    ADD CONSTRAINT scopes_pkey PRIMARY KEY (id);


--
-- Name: sentinel_activities sentinel_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sentinel_activities
    ADD CONSTRAINT sentinel_activities_pkey PRIMARY KEY (id);


--
-- Name: service_logs service_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_logs
    ADD CONSTRAINT service_logs_pkey PRIMARY KEY (id);


--
-- Name: sign_in_experiences sign_in_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sign_in_experiences
    ADD CONSTRAINT sign_in_experiences_pkey PRIMARY KEY (tenant_id, id);


--
-- Name: sso_connector_idp_initiated_auth_configs sso_connector_idp_initiated_auth_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sso_connector_idp_initiated_auth_configs
    ADD CONSTRAINT sso_connector_idp_initiated_auth_configs_pkey PRIMARY KEY (tenant_id, connector_id);


--
-- Name: sso_connectors sso_connectors__connector_name__unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sso_connectors
    ADD CONSTRAINT sso_connectors__connector_name__unique UNIQUE (tenant_id, connector_name);


--
-- Name: sso_connectors sso_connectors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sso_connectors
    ADD CONSTRAINT sso_connectors_pkey PRIMARY KEY (id);


--
-- Name: subject_tokens subject_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_tokens
    ADD CONSTRAINT subject_tokens_pkey PRIMARY KEY (id);


--
-- Name: systems systems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.systems
    ADD CONSTRAINT systems_pkey PRIMARY KEY (key);


--
-- Name: tenants tenants__db_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants__db_user UNIQUE (db_user);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: user_sso_identities user_sso_identities__issuer__identity_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sso_identities
    ADD CONSTRAINT user_sso_identities__issuer__identity_id UNIQUE (tenant_id, issuer, identity_id);


--
-- Name: user_sso_identities user_sso_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sso_identities
    ADD CONSTRAINT user_sso_identities_pkey PRIMARY KEY (id);


--
-- Name: users users__primary_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users__primary_email UNIQUE (tenant_id, primary_email);


--
-- Name: users users__primary_phone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users__primary_phone UNIQUE (tenant_id, primary_phone);


--
-- Name: users users__username; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users__username UNIQUE (tenant_id, username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_roles users_roles__user_id_role_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles__user_id_role_id UNIQUE (tenant_id, user_id, role_id);


--
-- Name: users_roles users_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_pkey PRIMARY KEY (id);


--
-- Name: verification_records verification_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_records
    ADD CONSTRAINT verification_records_pkey PRIMARY KEY (id);


--
-- Name: verification_statuses verification_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_statuses
    ADD CONSTRAINT verification_statuses_pkey PRIMARY KEY (id);


--
-- Name: applications__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications__id ON public.applications USING btree (tenant_id, id);


--
-- Name: applications__is_third_party; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications__is_third_party ON public.applications USING btree (tenant_id, is_third_party);


--
-- Name: applications__protected_app_metadata_custom_domain; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX applications__protected_app_metadata_custom_domain ON public.applications USING btree (((((protected_app_metadata -> 'customDomains'::text) -> 0) ->> 'domain'::text)));


--
-- Name: applications__protected_app_metadata_host; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX applications__protected_app_metadata_host ON public.applications USING btree (((protected_app_metadata ->> 'host'::text)));


--
-- Name: applications_roles__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_roles__id ON public.applications_roles USING btree (tenant_id, id);


--
-- Name: connectors__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX connectors__id ON public.connectors USING btree (tenant_id, id);


--
-- Name: custom_phrases__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX custom_phrases__id ON public.custom_phrases USING btree (tenant_id, id);


--
-- Name: daily_active_users__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX daily_active_users__id ON public.daily_active_users USING btree (tenant_id, id);


--
-- Name: daily_token_usage__date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX daily_token_usage__date ON public.daily_token_usage USING btree (tenant_id, date);


--
-- Name: domains__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX domains__id ON public.domains USING btree (tenant_id, id);


--
-- Name: hooks__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hooks__id ON public.hooks USING btree (tenant_id, id);


--
-- Name: logs__application_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logs__application_id ON public.logs USING btree (tenant_id, ((payload ->> 'applicationId'::text)));


--
-- Name: logs__hook_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logs__hook_id ON public.logs USING btree (tenant_id, ((payload ->> 'hookId'::text)));


--
-- Name: logs__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logs__id ON public.logs USING btree (tenant_id, id);


--
-- Name: logs__key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logs__key ON public.logs USING btree (tenant_id, key);


--
-- Name: logs__user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logs__user_id ON public.logs USING btree (tenant_id, ((payload ->> 'userId'::text)));


--
-- Name: oidc_model_instances__model_name_payload_grant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oidc_model_instances__model_name_payload_grant_id ON public.oidc_model_instances USING btree (tenant_id, model_name, ((payload ->> 'grantId'::text)));


--
-- Name: oidc_model_instances__model_name_payload_uid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oidc_model_instances__model_name_payload_uid ON public.oidc_model_instances USING btree (tenant_id, model_name, ((payload ->> 'uid'::text)));


--
-- Name: oidc_model_instances__model_name_payload_user_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oidc_model_instances__model_name_payload_user_code ON public.oidc_model_instances USING btree (tenant_id, model_name, ((payload ->> 'userCode'::text)));


--
-- Name: organization_invitations__invitee_organization_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX organization_invitations__invitee_organization_id ON public.organization_invitations USING btree (tenant_id, invitee, organization_id) WHERE (status = 'Pending'::public.organization_invitation_status);


--
-- Name: organization_roles__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_roles__id ON public.organization_roles USING btree (tenant_id, id);


--
-- Name: organization_scopes__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_scopes__id ON public.organization_scopes USING btree (tenant_id, id);


--
-- Name: organizations__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organizations__id ON public.organizations USING btree (tenant_id, id);


--
-- Name: passcodes__email_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX passcodes__email_type ON public.passcodes USING btree (tenant_id, email, type);


--
-- Name: passcodes__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX passcodes__id ON public.passcodes USING btree (tenant_id, id);


--
-- Name: passcodes__interaction_jti_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX passcodes__interaction_jti_type ON public.passcodes USING btree (tenant_id, interaction_jti, type);


--
-- Name: passcodes__phone_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX passcodes__phone_type ON public.passcodes USING btree (tenant_id, phone, type);


--
-- Name: personal_access_token__value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_token__value ON public.personal_access_tokens USING btree (tenant_id, value);


--
-- Name: resources__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX resources__id ON public.resources USING btree (tenant_id, id);


--
-- Name: resources__is_default_true; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX resources__is_default_true ON public.resources USING btree (tenant_id) WHERE (is_default = true);


--
-- Name: roles__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roles__id ON public.roles USING btree (tenant_id, id);


--
-- Name: roles_scopes__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX roles_scopes__id ON public.roles_scopes USING btree (tenant_id, id);


--
-- Name: scopes__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scopes__id ON public.scopes USING btree (tenant_id, id);


--
-- Name: sentinel_activities__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sentinel_activities__id ON public.sentinel_activities USING btree (tenant_id, id);


--
-- Name: sentinel_activities__target_type_target_hash_action_action_resu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sentinel_activities__target_type_target_hash_action_action_resu ON public.sentinel_activities USING btree (tenant_id, target_type, target_hash, action, action_result, decision);


--
-- Name: service_logs__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX service_logs__id ON public.service_logs USING btree (id);


--
-- Name: service_logs__tenant_id__type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX service_logs__tenant_id__type ON public.service_logs USING btree (tenant_id, type);


--
-- Name: sso_connectors__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sso_connectors__id ON public.sso_connectors USING btree (tenant_id, id);


--
-- Name: sso_connectors__id__provider_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sso_connectors__id__provider_name ON public.sso_connectors USING btree (tenant_id, id, provider_name);


--
-- Name: subject_token__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_token__id ON public.subject_tokens USING btree (tenant_id, id);


--
-- Name: users__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users__id ON public.users USING btree (tenant_id, id);


--
-- Name: users__name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users__name ON public.users USING btree (tenant_id, name);


--
-- Name: users_roles__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_roles__id ON public.users_roles USING btree (tenant_id, id);


--
-- Name: verification_records__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX verification_records__id ON public.verification_records USING btree (tenant_id, id);


--
-- Name: verification_statuses__id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX verification_statuses__id ON public.verification_statuses USING btree (tenant_id, id);


--
-- Name: verification_statuses__user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX verification_statuses__user_id ON public.verification_statuses USING btree (tenant_id, user_id);


--
-- Name: application_secrets set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.application_secrets FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: application_sign_in_experiences set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.application_sign_in_experiences FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: application_user_consent_organization_resource_scopes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.application_user_consent_organization_resource_scopes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: application_user_consent_organization_scopes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.application_user_consent_organization_scopes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: application_user_consent_organizations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.application_user_consent_organizations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: application_user_consent_resource_scopes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.application_user_consent_resource_scopes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: application_user_consent_user_scopes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.application_user_consent_user_scopes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: applications set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.applications FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: applications_roles set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.applications_roles FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: connectors set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.connectors FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: custom_phrases set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.custom_phrases FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: daily_active_users set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.daily_active_users FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: daily_token_usage set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.daily_token_usage FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: domains set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.domains FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: hooks set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.hooks FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: idp_initiated_saml_sso_sessions set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.idp_initiated_saml_sso_sessions FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: logs set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.logs FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: logto_configs set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.logto_configs FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: oidc_model_instances set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.oidc_model_instances FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_application_relations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_application_relations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_invitation_role_relations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_invitation_role_relations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_invitations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_invitations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_jit_email_domains set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_jit_email_domains FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_jit_roles set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_jit_roles FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_jit_sso_connectors set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_jit_sso_connectors FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_role_application_relations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_role_application_relations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_role_resource_scope_relations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_role_resource_scope_relations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_role_scope_relations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_role_scope_relations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_role_user_relations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_role_user_relations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_roles set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_roles FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_scopes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_scopes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organization_user_relations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organization_user_relations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: organizations set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.organizations FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: passcodes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.passcodes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: personal_access_tokens set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.personal_access_tokens FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: resources set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.resources FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: roles set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.roles FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: roles_scopes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.roles_scopes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: scopes set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.scopes FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: sentinel_activities set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.sentinel_activities FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: sign_in_experiences set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.sign_in_experiences FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: sso_connector_idp_initiated_auth_configs set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.sso_connector_idp_initiated_auth_configs FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: sso_connectors set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.sso_connectors FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: subject_tokens set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.subject_tokens FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: user_sso_identities set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.user_sso_identities FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: users set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: users_roles set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.users_roles FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: verification_records set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.verification_records FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: verification_statuses set_tenant_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_tenant_id BEFORE INSERT ON public.verification_statuses FOR EACH ROW EXECUTE FUNCTION public.set_tenant_id();


--
-- Name: users set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: application_secrets application_secrets_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_secrets
    ADD CONSTRAINT application_secrets_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_secrets application_secrets_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_secrets
    ADD CONSTRAINT application_secrets_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_sign_in_experiences application_sign_in_experiences_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_sign_in_experiences
    ADD CONSTRAINT application_sign_in_experiences_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_sign_in_experiences application_sign_in_experiences_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_sign_in_experiences
    ADD CONSTRAINT application_sign_in_experiences_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organizations application_user_consent_orga_tenant_id_organization_id_us_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organizations
    ADD CONSTRAINT application_user_consent_orga_tenant_id_organization_id_us_fkey FOREIGN KEY (tenant_id, organization_id, user_id) REFERENCES public.organization_user_relations(tenant_id, organization_id, user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organization_scopes application_user_consent_organizatio_organization_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_scopes
    ADD CONSTRAINT application_user_consent_organizatio_organization_scope_id_fkey FOREIGN KEY (organization_scope_id) REFERENCES public.organization_scopes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organization_resource_scopes application_user_consent_organization_resou_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_resource_scopes
    ADD CONSTRAINT application_user_consent_organization_resou_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organization_resource_scopes application_user_consent_organization_resource_s_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_resource_scopes
    ADD CONSTRAINT application_user_consent_organization_resource_s_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organization_resource_scopes application_user_consent_organization_resource_sc_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_resource_scopes
    ADD CONSTRAINT application_user_consent_organization_resource_sc_scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scopes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organization_scopes application_user_consent_organization_scope_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_scopes
    ADD CONSTRAINT application_user_consent_organization_scope_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organization_scopes application_user_consent_organization_scopes_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organization_scopes
    ADD CONSTRAINT application_user_consent_organization_scopes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organizations application_user_consent_organizations_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organizations
    ADD CONSTRAINT application_user_consent_organizations_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_organizations application_user_consent_organizations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_organizations
    ADD CONSTRAINT application_user_consent_organizations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_resource_scopes application_user_consent_resource_scopes_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_resource_scopes
    ADD CONSTRAINT application_user_consent_resource_scopes_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_resource_scopes application_user_consent_resource_scopes_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_resource_scopes
    ADD CONSTRAINT application_user_consent_resource_scopes_scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scopes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_resource_scopes application_user_consent_resource_scopes_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_resource_scopes
    ADD CONSTRAINT application_user_consent_resource_scopes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_user_scopes application_user_consent_user_scopes_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_user_scopes
    ADD CONSTRAINT application_user_consent_user_scopes_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_user_consent_user_scopes application_user_consent_user_scopes_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_user_consent_user_scopes
    ADD CONSTRAINT application_user_consent_user_scopes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: applications_roles applications_roles_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications_roles
    ADD CONSTRAINT applications_roles_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: applications_roles applications_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications_roles
    ADD CONSTRAINT applications_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: applications_roles applications_roles_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications_roles
    ADD CONSTRAINT applications_roles_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: applications applications_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: connectors connectors_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.connectors
    ADD CONSTRAINT connectors_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: custom_phrases custom_phrases_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_phrases
    ADD CONSTRAINT custom_phrases_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: daily_active_users daily_active_users_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_active_users
    ADD CONSTRAINT daily_active_users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: daily_token_usage daily_token_usage_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_token_usage
    ADD CONSTRAINT daily_token_usage_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: domains domains_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hooks hooks_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hooks
    ADD CONSTRAINT hooks_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: idp_initiated_saml_sso_sessions idp_initiated_saml_sso_sessions_connector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idp_initiated_saml_sso_sessions
    ADD CONSTRAINT idp_initiated_saml_sso_sessions_connector_id_fkey FOREIGN KEY (connector_id) REFERENCES public.sso_connectors(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: idp_initiated_saml_sso_sessions idp_initiated_saml_sso_sessions_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idp_initiated_saml_sso_sessions
    ADD CONSTRAINT idp_initiated_saml_sso_sessions_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: logs logs_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: logto_configs logto_configs_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logto_configs
    ADD CONSTRAINT logto_configs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: oidc_model_instances oidc_model_instances_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oidc_model_instances
    ADD CONSTRAINT oidc_model_instances_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_application_relations organization_application_relations_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_application_relations
    ADD CONSTRAINT organization_application_relations_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_application_relations organization_application_relations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_application_relations
    ADD CONSTRAINT organization_application_relations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_application_relations organization_application_relations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_application_relations
    ADD CONSTRAINT organization_application_relations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_invitation_role_relations organization_invitation_role_re_organization_invitation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitation_role_relations
    ADD CONSTRAINT organization_invitation_role_re_organization_invitation_id_fkey FOREIGN KEY (organization_invitation_id) REFERENCES public.organization_invitations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_invitation_role_relations organization_invitation_role_relation_organization_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitation_role_relations
    ADD CONSTRAINT organization_invitation_role_relation_organization_role_id_fkey FOREIGN KEY (organization_role_id) REFERENCES public.organization_roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_invitation_role_relations organization_invitation_role_relations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitation_role_relations
    ADD CONSTRAINT organization_invitation_role_relations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_invitations organization_invitations_accepted_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitations
    ADD CONSTRAINT organization_invitations_accepted_user_id_fkey FOREIGN KEY (accepted_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_invitations organization_invitations_inviter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitations
    ADD CONSTRAINT organization_invitations_inviter_id_fkey FOREIGN KEY (inviter_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_invitations organization_invitations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitations
    ADD CONSTRAINT organization_invitations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_invitations organization_invitations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_invitations
    ADD CONSTRAINT organization_invitations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_email_domains organization_jit_email_domains_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_email_domains
    ADD CONSTRAINT organization_jit_email_domains_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_email_domains organization_jit_email_domains_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_email_domains
    ADD CONSTRAINT organization_jit_email_domains_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_roles organization_jit_roles_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_roles
    ADD CONSTRAINT organization_jit_roles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_roles organization_jit_roles_organization_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_roles
    ADD CONSTRAINT organization_jit_roles_organization_role_id_fkey FOREIGN KEY (organization_role_id) REFERENCES public.organization_roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_roles organization_jit_roles_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_roles
    ADD CONSTRAINT organization_jit_roles_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_sso_connectors organization_jit_sso_connectors_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_sso_connectors
    ADD CONSTRAINT organization_jit_sso_connectors_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_sso_connectors organization_jit_sso_connectors_sso_connector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_sso_connectors
    ADD CONSTRAINT organization_jit_sso_connectors_sso_connector_id_fkey FOREIGN KEY (sso_connector_id) REFERENCES public.sso_connectors(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_jit_sso_connectors organization_jit_sso_connectors_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_jit_sso_connectors
    ADD CONSTRAINT organization_jit_sso_connectors_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_application_relations organization_role_application_relatio_organization_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_application_relations
    ADD CONSTRAINT organization_role_application_relatio_organization_role_id_fkey FOREIGN KEY (organization_role_id) REFERENCES public.organization_roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_application_relations organization_role_application_relations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_application_relations
    ADD CONSTRAINT organization_role_application_relations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_application_relations organization_role_application_tenant_id_organization_id_ap_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_application_relations
    ADD CONSTRAINT organization_role_application_tenant_id_organization_id_ap_fkey FOREIGN KEY (tenant_id, organization_id, application_id) REFERENCES public.organization_application_relations(tenant_id, organization_id, application_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_resource_scope_relations organization_role_resource_scope_rela_organization_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_resource_scope_relations
    ADD CONSTRAINT organization_role_resource_scope_rela_organization_role_id_fkey FOREIGN KEY (organization_role_id) REFERENCES public.organization_roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_resource_scope_relations organization_role_resource_scope_relations_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_resource_scope_relations
    ADD CONSTRAINT organization_role_resource_scope_relations_scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scopes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_resource_scope_relations organization_role_resource_scope_relations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_resource_scope_relations
    ADD CONSTRAINT organization_role_resource_scope_relations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_scope_relations organization_role_scope_relations_organization_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_scope_relations
    ADD CONSTRAINT organization_role_scope_relations_organization_role_id_fkey FOREIGN KEY (organization_role_id) REFERENCES public.organization_roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_scope_relations organization_role_scope_relations_organization_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_scope_relations
    ADD CONSTRAINT organization_role_scope_relations_organization_scope_id_fkey FOREIGN KEY (organization_scope_id) REFERENCES public.organization_scopes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_scope_relations organization_role_scope_relations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_scope_relations
    ADD CONSTRAINT organization_role_scope_relations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_user_relations organization_role_user_relati_tenant_id_organization_id_us_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_user_relations
    ADD CONSTRAINT organization_role_user_relati_tenant_id_organization_id_us_fkey FOREIGN KEY (tenant_id, organization_id, user_id) REFERENCES public.organization_user_relations(tenant_id, organization_id, user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_user_relations organization_role_user_relations_organization_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_user_relations
    ADD CONSTRAINT organization_role_user_relations_organization_role_id_fkey FOREIGN KEY (organization_role_id) REFERENCES public.organization_roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_role_user_relations organization_role_user_relations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_role_user_relations
    ADD CONSTRAINT organization_role_user_relations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_roles organization_roles_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_roles
    ADD CONSTRAINT organization_roles_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_scopes organization_scopes_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_scopes
    ADD CONSTRAINT organization_scopes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_user_relations organization_user_relations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_user_relations
    ADD CONSTRAINT organization_user_relations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_user_relations organization_user_relations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_user_relations
    ADD CONSTRAINT organization_user_relations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organization_user_relations organization_user_relations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_user_relations
    ADD CONSTRAINT organization_user_relations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organizations organizations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: passcodes passcodes_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passcodes
    ADD CONSTRAINT passcodes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personal_access_tokens personal_access_tokens_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personal_access_tokens personal_access_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resources resources_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: roles_scopes roles_scopes_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_scopes
    ADD CONSTRAINT roles_scopes_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: roles_scopes roles_scopes_scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_scopes
    ADD CONSTRAINT roles_scopes_scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scopes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: roles_scopes roles_scopes_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_scopes
    ADD CONSTRAINT roles_scopes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: roles roles_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: scopes scopes_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scopes
    ADD CONSTRAINT scopes_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: scopes scopes_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scopes
    ADD CONSTRAINT scopes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sentinel_activities sentinel_activities_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sentinel_activities
    ADD CONSTRAINT sentinel_activities_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sign_in_experiences sign_in_experiences_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sign_in_experiences
    ADD CONSTRAINT sign_in_experiences_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sso_connector_idp_initiated_auth_configs sso_connector_idp_initiated_auth_co_default_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sso_connector_idp_initiated_auth_configs
    ADD CONSTRAINT sso_connector_idp_initiated_auth_co_default_application_id_fkey FOREIGN KEY (default_application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sso_connector_idp_initiated_auth_configs sso_connector_idp_initiated_auth_configs_connector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sso_connector_idp_initiated_auth_configs
    ADD CONSTRAINT sso_connector_idp_initiated_auth_configs_connector_id_fkey FOREIGN KEY (connector_id) REFERENCES public.sso_connectors(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sso_connector_idp_initiated_auth_configs sso_connector_idp_initiated_auth_configs_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sso_connector_idp_initiated_auth_configs
    ADD CONSTRAINT sso_connector_idp_initiated_auth_configs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sso_connectors sso_connectors_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sso_connectors
    ADD CONSTRAINT sso_connectors_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subject_tokens subject_tokens_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_tokens
    ADD CONSTRAINT subject_tokens_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subject_tokens subject_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_tokens
    ADD CONSTRAINT subject_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_sso_identities user_sso_identities_sso_connector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sso_identities
    ADD CONSTRAINT user_sso_identities_sso_connector_id_fkey FOREIGN KEY (sso_connector_id) REFERENCES public.sso_connectors(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_sso_identities user_sso_identities_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sso_identities
    ADD CONSTRAINT user_sso_identities_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_sso_identities user_sso_identities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sso_identities
    ADD CONSTRAINT user_sso_identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_roles users_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_roles users_roles_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_roles users_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users users_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: verification_records verification_records_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_records
    ADD CONSTRAINT verification_records_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: verification_records verification_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_records
    ADD CONSTRAINT verification_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: verification_statuses verification_statuses_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_statuses
    ADD CONSTRAINT verification_statuses_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: verification_statuses verification_statuses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_statuses
    ADD CONSTRAINT verification_statuses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_secrets; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.application_secrets ENABLE ROW LEVEL SECURITY;

--
-- Name: application_secrets application_secrets_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_secrets_modification ON public.application_secrets USING (true);


--
-- Name: application_secrets application_secrets_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_secrets_tenant_id ON public.application_secrets AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: application_sign_in_experiences; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.application_sign_in_experiences ENABLE ROW LEVEL SECURITY;

--
-- Name: application_sign_in_experiences application_sign_in_experiences_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_sign_in_experiences_modification ON public.application_sign_in_experiences USING (true);


--
-- Name: application_sign_in_experiences application_sign_in_experiences_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_sign_in_experiences_tenant_id ON public.application_sign_in_experiences AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: application_user_consent_organization_resource_scopes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.application_user_consent_organization_resource_scopes ENABLE ROW LEVEL SECURITY;

--
-- Name: application_user_consent_organization_resource_scopes application_user_consent_organization_resource_scopes_modificat; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_organization_resource_scopes_modificat ON public.application_user_consent_organization_resource_scopes USING (true);


--
-- Name: application_user_consent_organization_resource_scopes application_user_consent_organization_resource_scopes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_organization_resource_scopes_tenant_id ON public.application_user_consent_organization_resource_scopes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: application_user_consent_organization_scopes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.application_user_consent_organization_scopes ENABLE ROW LEVEL SECURITY;

--
-- Name: application_user_consent_organization_scopes application_user_consent_organization_scopes_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_organization_scopes_modification ON public.application_user_consent_organization_scopes USING (true);


--
-- Name: application_user_consent_organization_scopes application_user_consent_organization_scopes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_organization_scopes_tenant_id ON public.application_user_consent_organization_scopes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: application_user_consent_organizations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.application_user_consent_organizations ENABLE ROW LEVEL SECURITY;

--
-- Name: application_user_consent_organizations application_user_consent_organizations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_organizations_modification ON public.application_user_consent_organizations USING (true);


--
-- Name: application_user_consent_organizations application_user_consent_organizations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_organizations_tenant_id ON public.application_user_consent_organizations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: application_user_consent_resource_scopes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.application_user_consent_resource_scopes ENABLE ROW LEVEL SECURITY;

--
-- Name: application_user_consent_resource_scopes application_user_consent_resource_scopes_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_resource_scopes_modification ON public.application_user_consent_resource_scopes USING (true);


--
-- Name: application_user_consent_resource_scopes application_user_consent_resource_scopes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_resource_scopes_tenant_id ON public.application_user_consent_resource_scopes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: application_user_consent_user_scopes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.application_user_consent_user_scopes ENABLE ROW LEVEL SECURITY;

--
-- Name: application_user_consent_user_scopes application_user_consent_user_scopes_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_user_scopes_modification ON public.application_user_consent_user_scopes USING (true);


--
-- Name: application_user_consent_user_scopes application_user_consent_user_scopes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY application_user_consent_user_scopes_tenant_id ON public.application_user_consent_user_scopes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: applications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

--
-- Name: applications applications_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY applications_modification ON public.applications USING (true);


--
-- Name: applications_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.applications_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: applications_roles applications_roles_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY applications_roles_modification ON public.applications_roles USING (true);


--
-- Name: applications_roles applications_roles_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY applications_roles_tenant_id ON public.applications_roles AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: applications applications_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY applications_tenant_id ON public.applications AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: connectors; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.connectors ENABLE ROW LEVEL SECURITY;

--
-- Name: connectors connectors_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY connectors_modification ON public.connectors USING (true);


--
-- Name: connectors connectors_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY connectors_tenant_id ON public.connectors AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: custom_phrases; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.custom_phrases ENABLE ROW LEVEL SECURITY;

--
-- Name: custom_phrases custom_phrases_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY custom_phrases_modification ON public.custom_phrases USING (true);


--
-- Name: custom_phrases custom_phrases_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY custom_phrases_tenant_id ON public.custom_phrases AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: daily_active_users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.daily_active_users ENABLE ROW LEVEL SECURITY;

--
-- Name: daily_active_users daily_active_users_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY daily_active_users_modification ON public.daily_active_users USING (true);


--
-- Name: daily_active_users daily_active_users_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY daily_active_users_tenant_id ON public.daily_active_users AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: daily_token_usage; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.daily_token_usage ENABLE ROW LEVEL SECURITY;

--
-- Name: daily_token_usage daily_token_usage_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY daily_token_usage_modification ON public.daily_token_usage USING (true);


--
-- Name: daily_token_usage daily_token_usage_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY daily_token_usage_tenant_id ON public.daily_token_usage AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: domains; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.domains ENABLE ROW LEVEL SECURITY;

--
-- Name: domains domains_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY domains_modification ON public.domains USING (true);


--
-- Name: domains domains_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY domains_tenant_id ON public.domains AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: hooks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.hooks ENABLE ROW LEVEL SECURITY;

--
-- Name: hooks hooks_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hooks_modification ON public.hooks USING (true);


--
-- Name: hooks hooks_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hooks_tenant_id ON public.hooks AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: idp_initiated_saml_sso_sessions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.idp_initiated_saml_sso_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: idp_initiated_saml_sso_sessions idp_initiated_saml_sso_sessions_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY idp_initiated_saml_sso_sessions_modification ON public.idp_initiated_saml_sso_sessions USING (true);


--
-- Name: idp_initiated_saml_sso_sessions idp_initiated_saml_sso_sessions_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY idp_initiated_saml_sso_sessions_tenant_id ON public.idp_initiated_saml_sso_sessions AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.logs ENABLE ROW LEVEL SECURITY;

--
-- Name: logs logs_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY logs_modification ON public.logs USING (true);


--
-- Name: logs logs_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY logs_tenant_id ON public.logs AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: logto_configs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.logto_configs ENABLE ROW LEVEL SECURITY;

--
-- Name: logto_configs logto_configs_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY logto_configs_modification ON public.logto_configs USING (true);


--
-- Name: logto_configs logto_configs_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY logto_configs_tenant_id ON public.logto_configs AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: oidc_model_instances; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.oidc_model_instances ENABLE ROW LEVEL SECURITY;

--
-- Name: oidc_model_instances oidc_model_instances_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY oidc_model_instances_modification ON public.oidc_model_instances USING (true);


--
-- Name: oidc_model_instances oidc_model_instances_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY oidc_model_instances_tenant_id ON public.oidc_model_instances AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_application_relations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_application_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_application_relations organization_application_relations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_application_relations_modification ON public.organization_application_relations USING (true);


--
-- Name: organization_application_relations organization_application_relations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_application_relations_tenant_id ON public.organization_application_relations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_invitation_role_relations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_invitation_role_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_invitation_role_relations organization_invitation_role_relations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_invitation_role_relations_modification ON public.organization_invitation_role_relations USING (true);


--
-- Name: organization_invitation_role_relations organization_invitation_role_relations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_invitation_role_relations_tenant_id ON public.organization_invitation_role_relations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_invitations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_invitations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_invitations organization_invitations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_invitations_modification ON public.organization_invitations USING (true);


--
-- Name: organization_invitations organization_invitations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_invitations_tenant_id ON public.organization_invitations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_jit_email_domains; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_jit_email_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_jit_email_domains organization_jit_email_domains_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_jit_email_domains_modification ON public.organization_jit_email_domains USING (true);


--
-- Name: organization_jit_email_domains organization_jit_email_domains_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_jit_email_domains_tenant_id ON public.organization_jit_email_domains AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_jit_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_jit_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_jit_roles organization_jit_roles_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_jit_roles_modification ON public.organization_jit_roles USING (true);


--
-- Name: organization_jit_roles organization_jit_roles_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_jit_roles_tenant_id ON public.organization_jit_roles AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_jit_sso_connectors; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_jit_sso_connectors ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_jit_sso_connectors organization_jit_sso_connectors_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_jit_sso_connectors_modification ON public.organization_jit_sso_connectors USING (true);


--
-- Name: organization_jit_sso_connectors organization_jit_sso_connectors_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_jit_sso_connectors_tenant_id ON public.organization_jit_sso_connectors AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_role_application_relations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_role_application_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_role_application_relations organization_role_application_relations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_application_relations_modification ON public.organization_role_application_relations USING (true);


--
-- Name: organization_role_application_relations organization_role_application_relations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_application_relations_tenant_id ON public.organization_role_application_relations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_role_resource_scope_relations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_role_resource_scope_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_role_resource_scope_relations organization_role_resource_scope_relations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_resource_scope_relations_modification ON public.organization_role_resource_scope_relations USING (true);


--
-- Name: organization_role_resource_scope_relations organization_role_resource_scope_relations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_resource_scope_relations_tenant_id ON public.organization_role_resource_scope_relations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_role_scope_relations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_role_scope_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_role_scope_relations organization_role_scope_relations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_scope_relations_modification ON public.organization_role_scope_relations USING (true);


--
-- Name: organization_role_scope_relations organization_role_scope_relations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_scope_relations_tenant_id ON public.organization_role_scope_relations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_role_user_relations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_role_user_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_role_user_relations organization_role_user_relations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_user_relations_modification ON public.organization_role_user_relations USING (true);


--
-- Name: organization_role_user_relations organization_role_user_relations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_role_user_relations_tenant_id ON public.organization_role_user_relations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_roles organization_roles_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_roles_modification ON public.organization_roles USING (true);


--
-- Name: organization_roles organization_roles_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_roles_tenant_id ON public.organization_roles AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_scopes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_scopes ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_scopes organization_scopes_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_scopes_modification ON public.organization_scopes USING (true);


--
-- Name: organization_scopes organization_scopes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_scopes_tenant_id ON public.organization_scopes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organization_user_relations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organization_user_relations ENABLE ROW LEVEL SECURITY;

--
-- Name: organization_user_relations organization_user_relations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_user_relations_modification ON public.organization_user_relations USING (true);


--
-- Name: organization_user_relations organization_user_relations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organization_user_relations_tenant_id ON public.organization_user_relations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: organizations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

--
-- Name: organizations organizations_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organizations_modification ON public.organizations USING (true);


--
-- Name: organizations organizations_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organizations_tenant_id ON public.organizations AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: passcodes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.passcodes ENABLE ROW LEVEL SECURITY;

--
-- Name: passcodes passcodes_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY passcodes_modification ON public.passcodes USING (true);


--
-- Name: passcodes passcodes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY passcodes_tenant_id ON public.passcodes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: personal_access_tokens; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.personal_access_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: personal_access_tokens personal_access_tokens_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY personal_access_tokens_modification ON public.personal_access_tokens USING (true);


--
-- Name: personal_access_tokens personal_access_tokens_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY personal_access_tokens_tenant_id ON public.personal_access_tokens AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: resources; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.resources ENABLE ROW LEVEL SECURITY;

--
-- Name: resources resources_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY resources_modification ON public.resources USING (true);


--
-- Name: resources resources_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY resources_tenant_id ON public.resources AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;

--
-- Name: roles roles_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY roles_modification ON public.roles USING (true);


--
-- Name: roles_scopes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.roles_scopes ENABLE ROW LEVEL SECURITY;

--
-- Name: roles_scopes roles_scopes_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY roles_scopes_modification ON public.roles_scopes USING (true);


--
-- Name: roles_scopes roles_scopes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY roles_scopes_tenant_id ON public.roles_scopes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: roles roles_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY roles_tenant_id ON public.roles AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: scopes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.scopes ENABLE ROW LEVEL SECURITY;

--
-- Name: scopes scopes_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY scopes_modification ON public.scopes USING (true);


--
-- Name: scopes scopes_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY scopes_tenant_id ON public.scopes AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: sentinel_activities; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sentinel_activities ENABLE ROW LEVEL SECURITY;

--
-- Name: sentinel_activities sentinel_activities_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sentinel_activities_modification ON public.sentinel_activities USING (true);


--
-- Name: sentinel_activities sentinel_activities_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sentinel_activities_tenant_id ON public.sentinel_activities AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: sign_in_experiences; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sign_in_experiences ENABLE ROW LEVEL SECURITY;

--
-- Name: sign_in_experiences sign_in_experiences_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sign_in_experiences_modification ON public.sign_in_experiences USING (true);


--
-- Name: sign_in_experiences sign_in_experiences_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sign_in_experiences_tenant_id ON public.sign_in_experiences AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: sso_connector_idp_initiated_auth_configs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sso_connector_idp_initiated_auth_configs ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_connector_idp_initiated_auth_configs sso_connector_idp_initiated_auth_configs_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sso_connector_idp_initiated_auth_configs_modification ON public.sso_connector_idp_initiated_auth_configs USING (true);


--
-- Name: sso_connector_idp_initiated_auth_configs sso_connector_idp_initiated_auth_configs_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sso_connector_idp_initiated_auth_configs_tenant_id ON public.sso_connector_idp_initiated_auth_configs AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: sso_connectors; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sso_connectors ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_connectors sso_connectors_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sso_connectors_modification ON public.sso_connectors USING (true);


--
-- Name: sso_connectors sso_connectors_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY sso_connectors_tenant_id ON public.sso_connectors AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: subject_tokens; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.subject_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: subject_tokens subject_tokens_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY subject_tokens_modification ON public.subject_tokens USING (true);


--
-- Name: subject_tokens subject_tokens_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY subject_tokens_tenant_id ON public.subject_tokens AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: tenants; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tenants ENABLE ROW LEVEL SECURITY;

--
-- Name: tenants tenants_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenants_tenant_id ON public.tenants USING (((db_user)::text = CURRENT_USER));


--
-- Name: user_sso_identities; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_sso_identities ENABLE ROW LEVEL SECURITY;

--
-- Name: user_sso_identities user_sso_identities_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_sso_identities_modification ON public.user_sso_identities USING (true);


--
-- Name: user_sso_identities user_sso_identities_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_sso_identities_tenant_id ON public.user_sso_identities AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users users_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_modification ON public.users USING (true);


--
-- Name: users_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: users_roles users_roles_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_roles_modification ON public.users_roles USING (true);


--
-- Name: users_roles users_roles_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_roles_tenant_id ON public.users_roles AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: users users_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_tenant_id ON public.users AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: verification_records; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.verification_records ENABLE ROW LEVEL SECURITY;

--
-- Name: verification_records verification_records_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY verification_records_modification ON public.verification_records USING (true);


--
-- Name: verification_records verification_records_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY verification_records_tenant_id ON public.verification_records AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: verification_statuses; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.verification_statuses ENABLE ROW LEVEL SECURITY;

--
-- Name: verification_statuses verification_statuses_modification; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY verification_statuses_modification ON public.verification_statuses USING (true);


--
-- Name: verification_statuses verification_statuses_tenant_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY verification_statuses_tenant_id ON public.verification_statuses AS RESTRICTIVE USING (((tenant_id)::text = (( SELECT tenants.id
   FROM public.tenants
  WHERE ((tenants.db_user)::text = CURRENT_USER)))::text));


--
-- Name: TABLE application_secrets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.application_secrets TO logto_tenant_logto;


--
-- Name: TABLE application_sign_in_experiences; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.application_sign_in_experiences TO logto_tenant_logto;


--
-- Name: TABLE application_user_consent_organization_resource_scopes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.application_user_consent_organization_resource_scopes TO logto_tenant_logto;


--
-- Name: TABLE application_user_consent_organization_scopes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.application_user_consent_organization_scopes TO logto_tenant_logto;


--
-- Name: TABLE application_user_consent_organizations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.application_user_consent_organizations TO logto_tenant_logto;


--
-- Name: TABLE application_user_consent_resource_scopes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.application_user_consent_resource_scopes TO logto_tenant_logto;


--
-- Name: TABLE application_user_consent_user_scopes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.application_user_consent_user_scopes TO logto_tenant_logto;


--
-- Name: TABLE applications; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.applications TO logto_tenant_logto;


--
-- Name: TABLE applications_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.applications_roles TO logto_tenant_logto;


--
-- Name: TABLE connectors; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.connectors TO logto_tenant_logto;


--
-- Name: TABLE custom_phrases; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.custom_phrases TO logto_tenant_logto;


--
-- Name: TABLE daily_active_users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.daily_active_users TO logto_tenant_logto;


--
-- Name: TABLE daily_token_usage; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.daily_token_usage TO logto_tenant_logto;


--
-- Name: TABLE domains; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.domains TO logto_tenant_logto;


--
-- Name: TABLE hooks; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hooks TO logto_tenant_logto;


--
-- Name: TABLE idp_initiated_saml_sso_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.idp_initiated_saml_sso_sessions TO logto_tenant_logto;


--
-- Name: TABLE logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.logs TO logto_tenant_logto;


--
-- Name: TABLE logto_configs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.logto_configs TO logto_tenant_logto;


--
-- Name: TABLE oidc_model_instances; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.oidc_model_instances TO logto_tenant_logto;


--
-- Name: TABLE organization_application_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_application_relations TO logto_tenant_logto;


--
-- Name: TABLE organization_invitation_role_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_invitation_role_relations TO logto_tenant_logto;


--
-- Name: TABLE organization_invitations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_invitations TO logto_tenant_logto;


--
-- Name: TABLE organization_jit_email_domains; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_jit_email_domains TO logto_tenant_logto;


--
-- Name: TABLE organization_jit_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_jit_roles TO logto_tenant_logto;


--
-- Name: TABLE organization_jit_sso_connectors; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_jit_sso_connectors TO logto_tenant_logto;


--
-- Name: TABLE organization_role_application_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_role_application_relations TO logto_tenant_logto;


--
-- Name: TABLE organization_role_resource_scope_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_role_resource_scope_relations TO logto_tenant_logto;


--
-- Name: TABLE organization_role_scope_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_role_scope_relations TO logto_tenant_logto;


--
-- Name: TABLE organization_role_user_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_role_user_relations TO logto_tenant_logto;


--
-- Name: TABLE organization_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_roles TO logto_tenant_logto;


--
-- Name: TABLE organization_scopes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_scopes TO logto_tenant_logto;


--
-- Name: TABLE organization_user_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organization_user_relations TO logto_tenant_logto;


--
-- Name: TABLE organizations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organizations TO logto_tenant_logto;


--
-- Name: TABLE passcodes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.passcodes TO logto_tenant_logto;


--
-- Name: TABLE personal_access_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.personal_access_tokens TO logto_tenant_logto;


--
-- Name: TABLE resources; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.resources TO logto_tenant_logto;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.roles TO logto_tenant_logto;


--
-- Name: TABLE roles_scopes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.roles_scopes TO logto_tenant_logto;


--
-- Name: TABLE scopes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.scopes TO logto_tenant_logto;


--
-- Name: TABLE sentinel_activities; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sentinel_activities TO logto_tenant_logto;


--
-- Name: TABLE sign_in_experiences; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sign_in_experiences TO logto_tenant_logto;


--
-- Name: TABLE sso_connector_idp_initiated_auth_configs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sso_connector_idp_initiated_auth_configs TO logto_tenant_logto;


--
-- Name: TABLE sso_connectors; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sso_connectors TO logto_tenant_logto;


--
-- Name: TABLE subject_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.subject_tokens TO logto_tenant_logto;


--
-- Name: COLUMN tenants.id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(id) ON TABLE public.tenants TO logto_tenant_logto;


--
-- Name: COLUMN tenants.db_user; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(db_user) ON TABLE public.tenants TO logto_tenant_logto;


--
-- Name: COLUMN tenants.is_suspended; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_suspended) ON TABLE public.tenants TO logto_tenant_logto;


--
-- Name: TABLE user_sso_identities; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.user_sso_identities TO logto_tenant_logto;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO logto_tenant_logto;


--
-- Name: TABLE users_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users_roles TO logto_tenant_logto;


--
-- Name: TABLE verification_records; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.verification_records TO logto_tenant_logto;


--
-- Name: TABLE verification_statuses; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.verification_statuses TO logto_tenant_logto;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13
-- Dumped by pg_dump version 14.13

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
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

