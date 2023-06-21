# dbt_app_reporting v0.3.1
## Bug Fixes
[PR #16](https://github.com/fivetran/dbt_app_reporting/pull/16) includes the following bug fix.
- Included the `country_long` field in the unique combination of columns test for the `app_reporting__country_report`. It has been identified that Apple will sometimes provide records with different `country_long` names; however, they will be the same `country_short`. This is due to some countries having multiple `country_long` spelling variations. 

# dbt_app_reporting v0.3.0

## Bug Fixes:
[PR #14](https://github.com/fivetran/dbt_app_reporting/pull/14) includes the following changes:
- This version of the transform package points to breaking changes in the upstream [Google Play](https://github.com/fivetran/dbt_google_play_source/blob/main/CHANGELOG.md) and [Apple Store](https://github.com/fivetran/dbt_apple_store_source/blob/main/CHANGELOG.md) source packages in which the [country code](https://github.com/fivetran/dbt_apple_store_source/blob/main/seeds/apple_store_country_codes.csv) mapping tables were updated to align with Apple's [format and inclusion list](https://developer.apple.com/help/app-store-connect/reference/app-store-localizations/) of country names.
  - This is a 🚨**breaking change**🚨 as you will need to re-seed (`dbt seed --full-refresh`) the `google_play__country_codes` [file](https://github.com/fivetran/dbt_google_play_source/blob/main/seeds/google_play__country_codes.csv) and `apple_store_country_codes` [file](https://github.com/fivetran/dbt_apple_store_source/blob/main/seeds/apple_store_country_codes.csv) again.

## Under the Hood:
[PR #13](https://github.com/fivetran/dbt_app_reporting/pull/13) includes the following changes:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_app_reporting v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #12](https://github.com/fivetran/dbt_app_reporting/pull/12) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
# dbt_app_reporting v0.1.1-v0.1.2

## Updates
- `README` update to remove release badge as they are confusing in the current state of package/downstream tooling.

# dbt_app_reporting v0.1.0

## Initial Release
This is the initial release of this package. 

__What does this dbt package do?__
- Standardizes schemas from various app platform connectors and creates reporting models for all activity aggregated to the device, country, OS version, app version and traffic source
- Currently supports the following Fivetran app platform connectors:
    - [Apple App Store](https://github.com/fivetran/dbt_apple_store)
    - [Google Play](https://github.com/fivetran/dbt_google_play)
- Generates a comprehensive data dictionary of your source and modeled App Reporting data via the [dbt docs site](https://fivetran.github.io/dbt_app_reporting/)

__References__
- [lukes/ISO-3166-Countries-with-Regional-Codes](https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes) for the foundation of our `country_codes` mapping table

For more information refer to the [README](/README.md).
