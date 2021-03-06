# Decision Log

## Metrics included and excluded
Metrics included in this package had to:
1. **Have an equivalent metric for both the Apple App Store and Google Play according to documentation found for each of the connector data sources.**<br>
For example, we included a field called `downloads` that occurs as `total_downloads` in the Apple App Store and as `device_installs` in Google Play.<br>

2. **Make sense when aggregated at the level of the respective report.**<br>
For example, we did not include `active_devices_last_30_days` from the Apple App Store although there was an equivalent metric in Google Play called `active_devices_last_30_days` (renamed from `active_device_installs`). This is because in the Apple App Store, this metric is typically aggregated by a dimension and source type, therefore, we cannot guarantee that there will not be any duplication in counts of `active_devices_last_30_days` if only aggregated by the dimension. This is not the case in Google Play, rendering this metric inconsistent across platforms.

Additionally, we welcome any [discussion](https://github.com/fivetran/dbt_app_reporting/discussions/6) for fields to include/exclude!

## Excluding Subscription Report
Although the Apple App Store and Google Play packages both have subscription reports, we have decided to not extend this capability in the initial release of the App Reporting roll-up package. Currently, we cannot guarantee the proper aggregating and mapping of subscription events in Apple to active subscriptions, subscription cancellations, and subscription purchases in Google Play.

We are, however, very eager to include this report as a feature in the App Reporting package and welcome any [discussion](https://github.com/fivetran/dbt_app_reporting/discussions/7) that can help us create it!

## Metrics Naming
We made the design decision to keep each respective packages' naming convention as close to their original reporting as possible, making small tweaks where necessary. However, for this roll-up package, we chose the column names that best represented the data field across both packages.