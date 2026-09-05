// select the area of interest on the map, the code of the selection is:
var AOI = 
    /* color: #bbffef */
    /* displayProperties: [
      {
        "type": "rectangle"
      }
    ] */
    ee.Geometry.Polygon(
        [[[-6.620941182520183, 54.76089192999706],
          [-6.620941182520183, 54.476226465328416],
          [-6.217193623926433, 54.476226465328416],
          [-6.217193623926433, 54.76089192999706]]], null, false);

// define a function to mask the clouds
function maskS2cloudsSCL(image) {
  var scl = image.select('SCL');
  // select the pixels classes to: keep 4 = Vegetation, 5 = Bare Soils, 6 = Water, 11 = Snow/Ice
  var keepPixels = scl.eq(4)
  .or(scl.eq(5))
  .or(scl.eq(6))
  .or(scl.eq(11));
  return image.updateMask(keepPixels);
}

// Load Sentinel-2 Surface Reflectance data
var autumn_collection = ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
 .filterBounds(AOI)
.filterDate('2023-09-01', '2023-11-30') //meterological autumn
.filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 3))
.map(maskS2cloudsSCL);


// Check the number of available images 
print(autumn_collection.size()); //there are two images


// Select your bands, obtain the median image, scale by 10,000, and clip to the AOI
var processed_image = autumn_collection.select(['B4', 'B3', 'B2', 'B5', 'B8'])
  .median()
  .divide(10000)
  .clip(AOI);

// Display natural RGB colors
Map.centerObject(AOI, 10);
Map.addLayer(processed_image, {bands: ['B4', 'B3', 'B2'], min: 0, max: 0.3}, 'Lough Neagh Autumn RGB');

// Export to Google Drive
Export.image.toDrive({
  image: processed_image,
  description: 'Sentinel2_Export',
  scale: 10,
  region: AOI,
  fileFormat: 'GeoTIFF'
});
