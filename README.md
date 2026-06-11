<!--section="app-reporting_transformation_model"-->
# App Reporting dbt Package

This dbt package unifies and aggregates data from Fivetran's Apple App Store and Google Play connectors into analytics-ready tables.

## Resources

- Number of materialized models¹: 96
- Connector documentation
  - [Apple App Store](https://fivetran.com/docs/connectors/applications/apple-app-store#appleappstore)
  - [Google Play](https://fivetran.com/docs/connectors/applications/google-play#googleplay)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_app_reporting)
  - [dbt Docs](https://fivetran.github.io/dbt_app_reporting/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_app_reporting/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_app_reporting/blob/main/CHANGELOG.md)
- dbt Core™ supported versions
  - `>=1.3.0, <3.0.0`

## What does this dbt package do?
This package enables you to standardize schemas from various app platform connectors and create reporting models for all activity aggregated to the device, country, OS version, app version, and traffic source levels. It creates enriched models with metrics focused on app performance, user engagement, and platform-specific analytics.

Currently supports the following Fivetran app platform connectors:
- [Apple App Store](https://fivetran.com/docs/connectors/applications/apple-app-store#appleappstore)
- [Google Play](https://fivetran.com/docs/connectors/applications/google-play#googleplay)

> The individual Google Play and Apple App Store tables have additional platform-specific metrics better suited for deep-dive analyses.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_app_reporting
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [app_reporting__app_version_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__app_version_report) | Tracks daily app performance metrics by app version to monitor version adoption, identify version-specific issues, and understand how different app versions perform. <br></br>**Example Analytics Questions:**<ul><li>Which app versions have the highest user adoption and retention rates?</li><li>Are there specific app versions experiencing higher crash rates or performance issues?</li><li>How do key metrics (sessions, revenue, engagement) compare across different app versions?</li></ul>|
| [app_reporting__country_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__country_report) | Analyzes daily app performance by country to understand geographic distribution of users, revenue by region, and identify market-specific opportunities and challenges. <br></br>**Example Analytics Questions:**<ul><li>Which countries generate the most app revenue and have the highest user engagement?</li><li>How do key performance metrics vary across different geographic markets?</li><li>What countries show the strongest growth in daily active users or revenue?</li></ul>|
| [app_reporting__device_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__device_report) | Monitors daily app metrics by device type to optimize device-specific experiences, identify device compatibility issues, and understand device preferences among users. <br></br>**Example Analytics Questions:**<ul><li>Which device types have the highest user volumes and best performance metrics?</li><li>Are there device-specific crashes or performance issues affecting user experience?</li><li>How do engagement and revenue metrics differ between iOS and Android devices?</li></ul>|
| [app_reporting__os_version_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__os_version_report) | Tracks daily performance metrics by operating system version to ensure compatibility, prioritize OS version support, and identify version-specific issues. <br></br>**Example Analytics Questions:**<ul><li>Which OS versions have the most active users and highest engagement rates?</li><li>Are newer OS versions showing better or worse performance metrics?</li><li>What percentage of users are on outdated OS versions that may need deprecation?</li></ul>|
| [app_reporting__overview_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__overview_report) | Provides a high-level daily summary of app performance across all dimensions to monitor overall app health, track key metrics, and identify trends at the app level. <br></br>**Example Analytics Questions:**<ul><li>What are the overall daily active users, sessions, and revenue trends for each app?</li><li>How do total app metrics compare week-over-week or month-over-month?</li><li>Which apps in the portfolio are performing best across key engagement and revenue metrics?</li></ul>|
| [app_reporting__traffic_source_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__traffic_source_report) | Analyzes daily app metrics by traffic source to measure acquisition channel effectiveness, optimize marketing spend, and understand which sources drive the most valuable users. <br></br>**Example Analytics Questions:**<ul><li>Which traffic sources generate the most app installs and highest lifetime value users?</li><li>How do organic versus paid acquisition channels compare in terms of user quality and retention?</li><li>What is the cost per acquisition and return on ad spend by traffic source?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

### Materialized Models
Each Quickstart transformation job run materializes the following model counts for each selected connector. The total model count represents all staging, intermediate, and final models, materialized as `view`, `table`, or `incremental`:

| **Connector** | **Model Count** |
| ------------- | --------------- |
| App Reporting | 18 |
| [Apple App Store](https://github.com/fivetran/dbt_apple_store) | 38 |
| [Google Play](https://github.com/fivetran/dbt_google_play) | 40 |

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran App Reporting connection syncing data into your destination.
- A BigQuery, Snowflake, Redshift, Postgres, or Databricks destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_app_reporting/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/app_reporting
    version: [">=1.3.0", "<1.4.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do NOT include the individual app platform packages in this file. The app reporting package itself has dependencies on these packages and will install them as well.

### Define database and schema variables
#### Option A: Single connection(s)
By default, this package also looks for your connection data in specific schemas (`itunes_connect` and `google_play` for Apple App Store and Google Play, respectively). If your data is stored in a different schema, add the relevant `<connection>_schema` variables to your `dbt_project.yml` file (see below).

```yml
vars:
  apple_store_schema: itunes_connect
  apple_store_database: your_database_name

  google_play_schema: google_play
  google_play_database: your_database_name 
```
#### Option B: Union multiple connections
If you have multiple app platform connections of the same type in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the below variables in your root `dbt_project.yml` file:
```yml
# dbt_project.yml

vars:
  apple_store_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Required
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name

  google_play_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Required
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name
```

> Previous versions of this package employed two separate, mutually exclusive variables for unioning for each platform: (eg. `apple_store_union_schemas` and `apple_store_union_databases`). While these variables are still supported, the new approach shared above are the recommended variables to configure.

#### Optional: Incorporate unioned sources into DAG

If you use [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore) and are unioning multiple App Platform connections of the same type, you can define your sources in a property `.yml` file. Set the variable `has_defined_sources: true` in your `dbt_project.yml`. Otherwise, your connections won't appear in your DAG. See the `union_connections` macro [documentation](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#optional-union-connections-defined-sources-configuration) for full configuration details.

### Disable and Enable Source Tables
Your app platform connections might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in your respective app platforms or have actively excluded some tables from your syncs.

If you use subscriptions and have the follow tables enabled for:
- Apple App Store
    - `sales_subscription_event_summary`
    - `sales_subscription_summary`
- Google Play
    - `financial_stats_subscriptions_country`
    - `earnings`

Add the following variables to your dbt_project.yml file

```yml
vars:
  apple_store__using_subscriptions: true # by default this is assumed to be false
  google_play__using_subscriptions: true # by default this is assumed to be false
  google_play__using_earnings: true # by default this is assumed to be false
```

>  Subscriptions and financial data are NOT included in `app_reporting` data models. This data is leveraged in the individual Google Play and Apple App Store packages, which are installed within the App Reporting package.

### Seed `country_codes` mapping tables (once)

In order to map longform territory names to their ISO country codes, we have adapted the CSV from [lukes/ISO-3166-Countries-with-Regional-Codes](https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes) to align Google and [Apple's](https://developer.apple.com/help/app-store-connect/reference/app-store-localizations/) country name formats for the App Reporting package.

You will need to `dbt seed` the `google_play__country_codes` [file](https://github.com/fivetran/dbt_google_play/blob/main/seeds/google_play__country_codes.csv) and `apple_store_country_codes` [file](https://github.com/fivetran/dbt_apple_store/blob/main/seeds/apple_store_country_codes.csv) just once.

### (Recommended) Change the Build Schema
By default this package will build all models in your `<target_schema>` with the respective package suffixes (see below). This behavior can be tailored to your preference by making use of custom schemas. If you would like to override the current naming conventions, please add the following configuration to your `dbt_project.yml` file and rename `+schema` configs:

```yml
models:  
  app_reporting:
    +schema: app_reporting # default schema suffix

  apple_store:
    +schema: apple_store # default schema suffix
    staging:
      +schema: apple_store_source # default schema suffix

  google_play:
    +schema: google_play # default schema suffix
    staging:
      +schema: google_play_source # default schema suffix
```

> Provide a blank `+schema: ` to write to the `target_schema` without any suffix.

### (Optional) Additional configurations
<details open><summary>Expand/collapse configurations</summary>

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See the Apple Store [`dbt_project.yml`](https://github.com/fivetran/dbt_apple_store/blob/main/dbt_project.yml)  and Google Play [`dbt_project.yml`](https://github.com/fivetran/dbt_google_play/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    apple_store_<default_source_table_name>_identifier: your_table_name 
    google_play_<default_source_table_name>_identifier: your_table_name 
```

#### Source casing for case-sensitive destinations
By default, the package applies case-insensitive comparisons when resolving `source_relation` values. If your destination is case-sensitive and you want downstream transformations to respect the exact casing of your source database and schema names, set the following variable:

```yml
vars:
    fivetran_using_source_casing: true
```


</details>
<br>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement#setupguide).

</details>
<br>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> **If you have any of these dependent packages in your own `packages.yml` we highly recommend you remove them to ensure there are no package version conflicts.**
```yml
packages: 
    - package: fivetran/google_play
      version: [">=1.3.0", "<1.4.0"]
    
    - package: fivetran/apple_store
      version: [">=1.3.0", "<1.4.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
<!--section="app-reporting_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/app_reporting/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_app_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

### Opinionated Decisions
In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made in the [DECISIONLOG.md](https://github.com/fivetran/dbt_app_reporting/blob/main/DECISIONLOG.md), and will continue to update as the package evolves. We are always open to and encourage feedback on these choices, and the package in general.

<!--section-end-->

## Are there any resources available?
- If you encounter any questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_app_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
