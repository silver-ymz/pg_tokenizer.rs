pub mod character_filter;
pub mod datatype;
pub mod model;
pub mod pre_tokenizer;
pub mod text_analyzer;
pub mod token_filter;
pub mod tokenizer;
pub mod utils;

::pgrx::pg_module_magic!();

#[cfg(not(all(target_endian = "little", target_pointer_width = "64")))]
compile_error!("Target is not supported.");

#[cfg(not(any(feature = "pg14", feature = "pg15", feature = "pg16", feature = "pg17")))]
compiler_error!("PostgreSQL version must be selected.");

#[cfg(test)]
pub mod pg_test {
    pub fn setup(_options: Vec<&str>) {
        // perform one-off initialization when the pg_test framework starts
    }

    pub fn postgresql_conf_options() -> Vec<&'static str> {
        // return any postgresql.conf settings that are required for your tests
        vec![r#"search_path = '"$user", public, bm25_catalog, tokenizer_catalog'"#]
    }
}
