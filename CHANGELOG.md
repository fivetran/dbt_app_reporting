# dbt_app_reporting v0.1.1

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
