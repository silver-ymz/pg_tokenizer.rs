/* <begin connected objects> */
/*
This file is auto generated by pgrx.

The ordering of items is not stable, it is driven by a dependency graph.
*/
/* </end connected objects> */

/* <begin connected objects> */
-- src/text_analyzer.rs:80

CREATE TABLE tokenizer_catalog.text_analyzer (
    name TEXT NOT NULL UNIQUE PRIMARY KEY,
    config TEXT NOT NULL
);
/* </end connected objects> */

/* <begin connected objects> */
-- src/tokenizer.rs:83

CREATE TABLE tokenizer_catalog.tokenizer (
    name TEXT NOT NULL UNIQUE PRIMARY KEY,
    config TEXT NOT NULL
);
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/mod.rs:54

CREATE TABLE tokenizer_catalog.model (
    name TEXT NOT NULL UNIQUE PRIMARY KEY,
    config TEXT NOT NULL
);
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/custom.rs:251

CREATE FUNCTION create_custom_model_tokenizer_and_trigger(
tokenizer_name TEXT, model_name TEXT, text_analyzer_name TEXT, table_name TEXT, source_column TEXT, target_column TEXT)
RETURNS VOID AS $body$
BEGIN
    EXECUTE format('SELECT tokenizer_catalog.create_custom_model(%L, $$
        table = %L
        column = %L
        text_analyzer = %L
        $$)', model_name, table_name, source_column, text_analyzer_name);
    EXECUTE format('SELECT tokenizer_catalog.create_tokenizer(%L, $$
        text_analyzer = %L
        model = %L
        $$)', tokenizer_name, text_analyzer_name, model_name);
    EXECUTE format('UPDATE %I SET %I = tokenizer_catalog.tokenize(%I, %L)', table_name, target_column, source_column, tokenizer_name);
    EXECUTE format('CREATE TRIGGER "model_%s_trigger_insert" BEFORE INSERT OR UPDATE OF %I ON %I FOR EACH ROW EXECUTE FUNCTION tokenizer_catalog.custom_model_tokenizer_set_target_column_trigger(%L, %I, %I)', model_name, source_column, table_name, tokenizer_name, source_column, target_column);
END;
$body$ LANGUAGE plpgsql;
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/custom.rs:223

CREATE FUNCTION custom_model_insert_trigger()
RETURNS TRIGGER AS $$
DECLARE
    tokenizer_name TEXT := TG_ARGV[0];
    target_column TEXT := TG_ARGV[1];
    text_analyzer TEXT := TG_ARGV[2];
BEGIN
    EXECUTE format('
    WITH 
    new_tokens AS (
        SELECT unnest(tokenizer_catalog.apply_text_analyzer_for_custom_model($1.%I, %L)) AS token
    ),
    to_insert AS (
        SELECT token FROM new_tokens
        WHERE NOT EXISTS (
            SELECT 1 FROM tokenizer_catalog."model_%s" WHERE token = new_tokens.token
        )
    )
    INSERT INTO tokenizer_catalog."model_%s" (token) SELECT token FROM to_insert ON CONFLICT (token) DO NOTHING', target_column, text_analyzer, tokenizer_name, tokenizer_name) USING NEW;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/synonym.rs:55

CREATE TABLE tokenizer_catalog.synonym (
    name TEXT NOT NULL UNIQUE PRIMARY KEY,
    config TEXT NOT NULL
);
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/stopwords.rs:43

CREATE TABLE tokenizer_catalog.stopwords (
    name TEXT NOT NULL UNIQUE PRIMARY KEY,
    config TEXT NOT NULL
);
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/stopwords.rs:158
-- pg_tokenizer::token_filter::stopwords::_pg_tokenizer_stopwords_init
CREATE  FUNCTION "_pg_tokenizer_stopwords_init"() RETURNS void
STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', '_pg_tokenizer_stopwords_init_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/stopwords.rs:165
-- requires:
--   stopwords_table
--   _pg_tokenizer_stopwords_init


    SELECT tokenizer_catalog._pg_tokenizer_stopwords_init();
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/mod.rs:139
-- pg_tokenizer::model::add_preload_model
CREATE  FUNCTION "add_preload_model"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL UNSAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'add_preload_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/text_analyzer.rs:169
-- pg_tokenizer::text_analyzer::apply_text_analyzer
CREATE  FUNCTION "apply_text_analyzer"(
	"text" TEXT, /* &str */
	"text_analyzer_name" TEXT /* &str */
) RETURNS TEXT[] /* alloc::vec::Vec<alloc::string::String> */
IMMUTABLE STRICT PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'apply_text_analyzer_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/custom.rs:201
-- pg_tokenizer::model::custom::apply_text_analyzer_for_custom_model
CREATE  FUNCTION "apply_text_analyzer_for_custom_model"(
	"text" TEXT, /* &str */
	"text_analyzer_name" TEXT /* &str */
) RETURNS TEXT[] /* alloc::vec::Vec<alloc::string::String> */
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'apply_text_analyzer_for_custom_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/custom.rs:94
-- pg_tokenizer::model::custom::create_custom_model
CREATE  FUNCTION "create_custom_model"(
	"name" TEXT, /* &str */
	"config" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'create_custom_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/huggingface.rs:31
-- pg_tokenizer::model::huggingface::create_huggingface_model
CREATE  FUNCTION "create_huggingface_model"(
	"name" TEXT, /* &str */
	"config" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'create_huggingface_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/lindera.rs:38
-- pg_tokenizer::model::lindera::create_lindera_model
CREATE  FUNCTION "create_lindera_model"(
	"name" TEXT, /* &str */
	"config" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'create_lindera_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/stopwords.rs:85
-- pg_tokenizer::token_filter::stopwords::create_stopwords
CREATE  FUNCTION "create_stopwords"(
	"name" TEXT, /* &str */
	"config" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'create_stopwords_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/synonym.rs:96
-- pg_tokenizer::token_filter::synonym::create_synonym
CREATE  FUNCTION "create_synonym"(
	"name" TEXT, /* &str */
	"config" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'create_synonym_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/text_analyzer.rs:122
-- pg_tokenizer::text_analyzer::create_text_analyzer
CREATE  FUNCTION "create_text_analyzer"(
	"name" TEXT, /* &str */
	"config" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'create_text_analyzer_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/tokenizer.rs:121
-- pg_tokenizer::tokenizer::create_tokenizer
CREATE  FUNCTION "create_tokenizer"(
	"name" TEXT, /* &str */
	"config" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'create_tokenizer_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/custom.rs:159
-- pg_tokenizer::model::custom::drop_custom_model
CREATE  FUNCTION "drop_custom_model"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'drop_custom_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/huggingface.rs:62
-- pg_tokenizer::model::huggingface::drop_huggingface_model
CREATE  FUNCTION "drop_huggingface_model"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'drop_huggingface_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/lindera.rs:64
-- pg_tokenizer::model::lindera::drop_lindera_model
CREATE  FUNCTION "drop_lindera_model"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'drop_lindera_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/stopwords.rs:114
-- pg_tokenizer::token_filter::stopwords::drop_stopwords
CREATE  FUNCTION "drop_stopwords"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'drop_stopwords_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/token_filter/synonym.rs:125
-- pg_tokenizer::token_filter::synonym::drop_synonym
CREATE  FUNCTION "drop_synonym"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'drop_synonym_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/text_analyzer.rs:150
-- pg_tokenizer::text_analyzer::drop_text_analyzer
CREATE  FUNCTION "drop_text_analyzer"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'drop_text_analyzer_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/tokenizer.rs:149
-- pg_tokenizer::tokenizer::drop_tokenizer
CREATE  FUNCTION "drop_tokenizer"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'drop_tokenizer_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/mod.rs:168
-- pg_tokenizer::model::list_preload_models
CREATE  FUNCTION "list_preload_models"() RETURNS TEXT[] /* alloc::vec::Vec<alloc::string::String> */
STRICT VOLATILE PARALLEL UNSAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'list_preload_models_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/mod.rs:153
-- pg_tokenizer::model::remove_preload_model
CREATE  FUNCTION "remove_preload_model"(
	"name" TEXT /* &str */
) RETURNS void
STRICT VOLATILE PARALLEL UNSAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'remove_preload_model_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/tokenizer.rs:168
-- pg_tokenizer::tokenizer::tokenize
CREATE  FUNCTION "tokenize"(
	"text" TEXT, /* &str */
	"tokenizer_name" TEXT /* &str */
) RETURNS INT[] /* alloc::vec::Vec<i32> */
STRICT STABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'tokenize_wrapper';
/* </end connected objects> */

/* <begin connected objects> */
-- src/model/custom.rs:274
-- pg_tokenizer::model::custom::custom_model_tokenizer_set_target_column_trigger
CREATE FUNCTION "custom_model_tokenizer_set_target_column_trigger"()
	RETURNS TRIGGER
	LANGUAGE c
	AS 'MODULE_PATHNAME', 'custom_model_tokenizer_set_target_column_trigger_wrapper';
/* </end connected objects> */

