# Map Demo App
An iOS showcase application for GeoJSON map data and clustering

<center>

|Demo|
|---|
|![iPhoneScreenshot](ReadmeAssets/iphoneScreenshot.gif)|

</center>

### Requirements

Swift `5.0`, iOS deployment target: `12.2`.

Cocoapods `1.6.1`.

### Setup
Installed pods are included in the repository. Project runs out of the box.
In case of manual pods installation, run:

```
pod repo update
pod install
```

## Covering notes

### Implemented features

- Tabbar controller UI
- GeoJSON deserialization
- Fetch and display electric recharging stations as pins on map
- Fetch and display parkings as tracks on map
- Cache GeoJSON on disk
- Clustering
- Filtering by object type with switches on map
- List of objects displayed on map
- Detailed map view for object selection in list

### Omitted features

Faced an API issue while working with geodata endpoint on [apidata.mos.ru](https://apidata.mos.ru). The API fails to return legit objects set for valid boundary box.
In case of absent or incorrect `bbox` parameter, it will return all existing objects. In case of valid boundary box, which probably include a small subset of all objects, the API returns `413` error, which means objects count `10000` exceeding. Examples with `bbox` param provided by document also fail with `413`. Corresponding [postman](https://apidata.mos.ru/Content/Docs/) examples, provided by docs, also fail.  
This condition makes it impossible to implement such things as paging, request throttling, request by displayed area, optimize requests by indexing area.

- Request throttling
- Request pagination by `bbox`
- Loading data only for map's displayed area by `bbox`
- Caching object models to Realm - GeoJSON saved to disk instead
- Optimize object requests by indexing areas




