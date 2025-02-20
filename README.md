<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_github/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# App Reporting dbt Package ([Docs](https://fivetran.github.io/dbt_app_reporting/))
## What does this dbt package do?
- Standardizes schemas from various app platform connectors and creates reporting models for all activity aggregated to the device, country, OS version, app version, traffic source and subscription levels.
- Currently supports the following Fivetran app platform connectors:
    - [Apple App Store](https://github.com/fivetran/dbt_apple_store)
    - [Google Play](https://github.com/fivetran/dbt_google_play)
- Generates a comprehensive data dictionary of your source and modeled App Reporting data via the [dbt docs site](https://fivetran.github.io/dbt_app_reporting/)

<!--section="app_reporting_transformation_model"-->
Refer to the table below for a detailed view of final tables materialized by default within this package. Additionally, check out our [Docs site](https://fivetran.github.io/dbt_app_reporting/#!/overview) for more details about these tables.

| **Table**                  | **Description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [app_reporting__app_version_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__app_version_report)             | Each record represents daily metrics by app_name and app version.                                             |
| [app_reporting__country_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__country_report)     | Each record represents daily metrics by app_name and country |
| [app_reporting__device_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__device_report)     | Each record represents daily metrics by app_name and device.                             |
| [app_reporting__os_version_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__os_version_report)    | Each record represents daily metrics by app_name and OS version.                            |
| [app_reporting__overview_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__overview_report)   | Each record represents daily metrics by app_name.                            |                          |
| [app_reporting__traffic_source_report](https://fivetran.github.io/dbt_app_reporting/#!/model/model.app_reporting.app_reporting__traffic_source_report) | Each record represents daily metrics by app_name and traffic source.                         |

> The individual Google Play and Apple App Store tables have additional platform-specific metrics better suited for deep-dive analyses.

### Materialized Models
Each Quickstart transformation job run materializes the following model counts for each selected connector. The total model count represents all staging, intermediate, and final models, materialized as `view`, `table`, or `incremental`:

| **Connector** | **Model Count** |
| ------------- | --------------- |
| App Reporting | 18 |
| [Apple App Store](https://github.com/fivetran/dbt_apple_store) | 38 |
| [Google Play](https://github.com/fivetran/dbt_google_play) | 40 |
<!--section-end-->

## How do I use the dbt package?
### Step 1: Pre-Requisites
- Have all relevant Fivetran app platform connections syncing data into your destination. This package currently supports:
    - [Apple App Store](https://fivetran.com/docs/applications/apple-app-store)
    - [Google Play](https://fivetran.com/docs/applications/google-play)
- This package has been tested on **BigQuery**, **Snowflake**, **Redshift**, **Postgres** and **Databricks**. Ensure you are using one of these supported databases.
- This dbt package requires you have a functional dbt project that utilizes a dbt version within the respective range `>=1.0.0, <2.0.0`.

### Step 2: Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/app_reporting
    version: [">=0.5.0", "<0.6.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do NOT include the individual app platform packages in this file. The app reporting package itself has dependencies on these packages and will install them as well.

### Step 3: Configure Database and Schema Variables
By default, this package looks for your app platform data in your target database. If this is not where your app platform data is stored, add the relevant `<connection>_database` variables to your `dbt_project.yml` file (see below).

By default, this package also looks for your connection data in specific schemas (`itunes_connect` and `google_play` for Apple App Store and Google Play, respectively). If your data is stored in a different schema, add the relevant `<connection>_schema` variables to your `dbt_project.yml` file (see below).

```yml
vars:
  apple_store_schema: itunes_connect
  apple_store_database: your_database_name
  
  google_play_schema: google_play
  google_play_database: your_database_name 
```

### Step 4: Disable and Enable Source Tables
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

### Step 5: Seed `country_codes` mapping tables (once)

In order to map longform territory names to their ISO country codes, we have adapted the CSV from [lukes/ISO-3166-Countries-with-Regional-Codes](https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes) to align Google and [Apple's](https://developer.apple.com/help/app-store-connect/reference/app-store-localizations/) country name formats for the App Reporting package.

You will need to `dbt seed` the `google_play__country_codes` [file](https://github.com/fivetran/dbt_google_play_source/blob/main/seeds/google_play__country_codes.csv) and `apple_store_country_codes` [file](https://github.com/fivetran/dbt_apple_store_source/blob/main/seeds/apple_store_country_codes.csv) just once.

### (Recommended) Step 6: Change the Build Schema
By default this package will build all models in your `<target_schema>` with the respective package suffixes (see below). This behavior can be tailored to your preference by making use of custom schemas. If you would like to override the current naming conventions, please add the following configuration to your `dbt_project.yml` file and rename `+schema` configs:

```yml
models:  
  app_reporting:
    +schema: app_reporting # default schema suffix

  apple_store:
    +schema: apple_store # default schema suffix
  apple_store_source:
    +schema: apple_store_source # default schema suffix
  
  google_play:
    +schema: google_play # default schema suffix
  google_play_source:
    +schema: google_play_source # default schema suffix
```

> Provide a blank `+schema: ` to write to the `target_schema` without any suffix.

### (Optional) Step 7: Additional configurations
<details open><summary>Expand/collapse configurations</summary>

#### Union multiple connections
If you have multiple app reporting connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `<package_name>_union_schemas` OR `<package_name>_union_databases` variables (cannot do both) in your root `dbt_project.yml` file. Below are the variables and examples for each connection:

```yml
vars:
    apple_store_union_schemas: ['apple_store_usa','apple_store_canada']
    apple_store_union_databases: ['apple_store_usa','apple_store_canada']

    google_play_union_schemas: ['google_play_usa','google_play_canada']
    google_play_union_databases: ['google_play_usa','google_play_canada']
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See the Apple Store [`dbt_project.yml`](https://github.com/fivetran/dbt_apple_store_source/blob/main/dbt_project.yml)  and Google Play [`dbt_project.yml`](https://github.com/fivetran/dbt_google_play_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    apple_store_<default_source_table_name>_identifier: your_table_name 
    google_play_<default_source_table_name>_identifier: your_table_name 
```
    
</details>
<br>

### (Optional) Step 8: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>
<br>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> **If you have any of these dependent packages in your own `packages.yml` I highly recommend you remove them to ensure there are no package version conflicts.**
```yml
packages: 
    - package: fivetran/apple_store 
      version: [">=0.5.0", "<0.6.0"] 

    - package: fivetran/apple_store_source
      version: [">=0.5.0", "<0.6.0"] 

    - package: fivetran/google_play 
      version: [">=0.4.0", "<0.5.0"] 
 
    - package: fivetran/google_play_source
      version: [">=0.4.0", "<0.5.0"] 

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_app_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Opinionated Decisions
In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made in the [DECISIONLOG.md](https://github.com/fivetran/dbt_app_reporting/blob/main/DECISIONLOG.md), and will continue to update as the package evolves. We are always open to and encourage feedback on these choices, and the package in general.

### Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you encounter any questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_app_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
