<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_github/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="Fivetran-Release"
        href="https://fivetran.com/docs/getting-started/core-concepts#releasephases">
        <img src="https://img.shields.io/badge/Fivetran Release Phase-_Beta-orange.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_core-version_>=1.0.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# App Reporting dbt Package ([Docs](https://fivetran.github.io/dbt_github/))
# 📣 What does this dbt package do?
- Standardizes schemas from various app platform connectors and creates reporting models for all activity aggregated to the device, country, OS version, app version, traffic source and subscription levels. 
- Currently supports the following Fivetran app platform connectors:
    - [Apple App Store](https://github.com/fivetran/dbt_apple_store)
    - [Google Play](https://github.com/fivetran/dbt_google_play)
- Generates a comprehensive data dictionary of your source and modeled GitHub data via the [dbt docs site](https://fivetran.github.io/dbt_github/)

Refer to the table below for a detailed view of final models materialized by default within this package. Additionally, check out our [Docs site](https://fivetran.github.io/dbt_app_reporting/#!/overview) for more details about these models. 

| **model**                  | **description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [app_reporting__app_version_report](https://dbt-github.netlify.app/#!/model/model.github.app_reporting__app_version_report)             | Each record represents daily metrics by app_name and app version.                                             |
| [app_reporting__country_report](https://dbt-github.netlify.app/#!/model/model.github.app_reporting__country_report)     | Each record represents daily metrics by app_name and country |
| [app_reporting__device_report](https://dbt-github.netlify.app/#!/model/model.github.app_reporting__device_report)     | Each record represents daily metrics by app_name and device.                             |
| [app_reporting__os_version_report](https://dbt-github.netlify.app/#!/model/model.github.app_reporting__os_version_report)    | Each record represents daily metrics by app_name and OS version.                            |
| [app_reporting__overview_report](https://dbt-github.netlify.app/#!/model/model.github.app_reporting__overview_report)   | Each record represents daily metrics by app_name.                            |
| [app_reporting__subscription_report](https://dbt-github.netlify.app/#!/model/model.github.app_reporting__subscription_report)   | Each record represents daily metrics by app_name and subscription_name                            |
| [app_reporting__traffic_source_report](https://dbt-github.netlify.app/#!/model/model.github.app_reporting__traffic_source_report) | Each record represents daily metrics by app_name and traffic source.                         |

# 🤔 Who is the target user of this dbt package?
- You use more than one of Fivetran' app platform connectors, including:
    - [Apple App Store](https://fivetran.com/docs/applications/apple-app-store)
    - [Google Play](https://fivetran.com/docs/applications/google-play)
- You use dbt
- You want a modeling layer that cleans, tests, and prepares your app platform data for analysis as well as leverage the analysis ready models outlined above.

# 🎯 How do I use the dbt package?
To effectively install this package and leverage the pre-made models, you will follow the below steps:
## Step 1: Pre-Requisites
You will need to ensure you have the following before leveraging the dbt package.
- **Connector**: Have all relevant Fivetran app platform connectors syncing data into your warehouse. 
- **Database support**: This package has been tested on **BigQuery**, **Snowflake**, **Redshift**, **Postgres** and **Databricks**. Ensure you are using one of these supported databases.
- **dbt Version**: This dbt package requires you have a functional dbt project that utilizes a dbt version within the respective range `>=1.0.0, <2.0.0`.

## Step 2: Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/app_reporting
    version: [">=0.1.0", "<0.2.0"]
```
## Step 3: Configure Your Variables
### Database and Schema Variables
By default, this package looks for your app platform data in your target database. If this is not where your advertising data is stored, add the relevant `_database` variables to your `dbt_project.yml` file (see below).

By default, this package also looks for specific schemas from each of your connectors. The schemas from each connector are highlighted in the code snippet below. If your data is stored in a different schema, add the relevant `_schema` variables to your `dbt_project.yml` file:

```yml
vars:
  apple_store_schema: itunes_connect
  apple_store_database: your_database_name
  
  google_play_schema: google_play
  google_play_database: your_database_name 
```

### Connector Selection
The package assumes that all connector models are enabled, so it will look to pull data from all of the connectors listed above. If you don't want to use certain connectors, disable those connectors' models in this package by setting the relevant variables to `false`.

```yml
vars:
  app_reporting__google_play_enabled: false
  app_reporting__apple_store_enabled: false
```

Next, you must disable the models in the unwanted connector's related package, which has its own configuration. Disable the relevant models under the models section of your `dbt_project.yml` file by setting the `enabled` value to `false`.

Only include the models you want to disable. Default values are generally `true` but that is not always the case.

```yml
models:
  # disable both Apple App Store models if not using Apple App Store
  apple_store:
    enabled: false
  apple_store_source:
    enabled: false

  # disable both Google Play models if not using Google Play
  google_play:
    enabled: false
  google_play_source:
    enabled: false
```
### Configuring Components
Your app platform connectors might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in your respective app platforms or have actively excluded some tables from your syncs.

If you use subscriptions and have the follow tables enabled for:
- Apple App Store
    - `sales_subscription_event_summary`
    - `sales_subscription_summary`
- Google Play
    - `<insert google tables>`

Add the following variables to your dbt_project.yml file

```yml
vars:
  apple_store__using_subscriptions: true # by default this is assumed to be false
```
## (Recommended) Step 4: Additional Configurations
### Change the Build Schema
By default this package will build all models in your <target_schema>. This behavior can be tailored to your preference by making use of custom schemas. We highly recommend use of custom schemas for this package, as multiple sources are involved. To do so, add the following configuration to your `dbt_project.yml` file:

```yml
models:  
  apple_store:
    +schema: apple_store
  apple_store_source:
    +schema: apple_store_source
  
  google_play:
    +schema: google_play
  google_play_source:
    +schema: google_play_source
  
```

## Step 5: Finish Setup
Your dbt project is now setup to successfully run the dbt package models! You can now execute `dbt run` and `dbt test` to have the models materialize in your warehouse and execute the data integrity tests applied within the package.

## (Optional) Step 6: Orchestrate your package models with Fivetran
Fivetran offers the ability for you to orchestrate your dbt project through the [Fivetran Transformations for dbt Core](https://fivetran.com/docs/transformations/dbt) product. Refer to the linked docs for more information on how to setup your project for orchestration through Fivetran. 

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> **If you have any of these dependent packages in your own `packages.yml` I highly recommend you remove them to ensure there are no package version conflicts.**
```yml
packages:
    - package: fivetran/apple_store
      version: [">=0.1.0", "<0.2.0"]

    - package: fivetran/google_play
      version: [">=0.1.0", "<0.2.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.3.0", "<0.4.0"]

    - package: dbt-labs/dbt_utils
      version: [">=0.8.0", "<0.9.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_app_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you encounter any questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_app_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or send us an email at solutions@fivetran.com.
