use pgrx::{datum::DatumWithOid, pg_sys::panic::ErrorReportable, FromDatum, IntoDatum};

pub fn spi_get_one<T>(query: &str, args: &[DatumWithOid]) -> Option<T>
where
    T: FromDatum + IntoDatum,
{
    pgrx::Spi::connect(|client| {
        let tuptable = client.select(query, Some(1), args).unwrap_or_report();

        match tuptable.first().get_one::<T>() {
            Ok(Some(bytes)) => Some(bytes),
            Ok(None) => panic!("Get null value when excuting spi query: {}", query),
            Err(e) if matches!(e, pgrx::spi::SpiError::InvalidPosition) => {
                return None;
            }
            Err(e) => panic!(
                "Failed to excuting spi query, error: {}, query: {}",
                e, query
            ),
        }
    })
}
