'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "4159ff5c5ca233485810cd62c9be97ef",
"assets/AssetManifest.bin.json": "7e73bd093551c9529203527c30e35909",
"assets/FontManifest.json": "0f6f3414adb1df0393b68386230f3911",
"assets/fonts/BerkshireSwash-Regular.ttf": "ce313427e6a2252bb111eb6474bc1e03",
"assets/fonts/FascinateInline-Regular.ttf": "a6b220895febf94ce94662c0c139bb51",
"assets/fonts/MaterialIcons-Regular.otf": "0349b2a00a755e520877415acef4759e",
"assets/fonts/Roboto-Regular.ttf": "678ba85b47044ac65031832c80bdfe4a",
"assets/fonts/rubik_medium.ttf": "11f22f212ab3e9b8e241cbd69d3c43e7",
"assets/fonts/rubik_regular.ttf": "cd619a4f068dc66cc6e58fe0a91a8a34",
"assets/images/Allocate_Icon.png": "f1de475249850b140b322d14d58648c8",
"assets/images/AttendenceIcon.png": "03b0d9a294a0774597932bc741ee4a8d",
"assets/images/BookingIcon.png": "248c23b2716c0be9b1a6e84a766c897c",
"assets/images/CanteenIcon.png": "5019716721fe4ecf404e156049e48faa",
"assets/images/EmployeeIcon.png": "406eafc47098dc72dd5c17ec0fae3b91",
"assets/images/ExpenseIcon.png": "668bd4285cd31f89f9acdfe4eb4fb8a6",
"assets/images/LoginImage.jpg": "f5265f01033bf03327abaae83714fce5",
"assets/images/logo.png": "8664ea6726b396df4cc2d4d59ce84d07",
"assets/images/logo1.png": "f041c3dce33a715a7c7eca252632f889",
"assets/images/MembershipIcon.png": "bd9f680186d3b1849ca356fd3990a57e",
"assets/images/PackageIcon.png": "2a1703688e515da524cd146dc495fb98",
"assets/images/Permission_Icon.png": "21e466206b32d41c55c4249f1ee8ab85",
"assets/images/pngegg.png": "5b12bf03198571dde8ba1844ac4f6bf8",
"assets/images/refresh%2520icon.png": "4b50d7932e4115c654692e03393b0961",
"assets/images/ReportIcon.png": "d1124c6f26bfadcec1a403e1b47420ff",
"assets/images/SalaryIcon.png": "7f730712cd4100f540515ea62ce07d18",
"assets/images/SaleIcon.png": "30b40c7e20b6018841929c064a135311",
"assets/images/ShiftIcon.png": "457d38a108ca1164cd53fa5c32ae2d46",
"assets/images/snooker_table.png": "44a351ea58ac028f3fece1eb7285466e",
"assets/images/TableIcon.png": "0e402a6e79050204ea08a7d2620fc73b",
"assets/images/table_logo.png": "14154726f9fc32d9c3dd09dec244811a",
"assets/NOTICES": "03db8e2557c3e0f0c61909ab2d458c80",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/syncfusion_flutter_pdfviewer/assets/fonts/RobotoMono-Regular.ttf": "5b04fdfec4c8c36e8ca574e40b7148bb",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/highlight.png": "2aecc31aaa39ad43c978f209962a985c",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/squiggly.png": "68960bf4e16479abb83841e54e1ae6f4",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/strikethrough.png": "72e2d23b4cdd8a9e5e9cadadf0f05a3f",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/underline.png": "59886133294dd6587b0beeac054b2ca3",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/highlight.png": "2fbda47037f7c99871891ca5e57e030b",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/squiggly.png": "9894ce549037670d25d2c786036b810b",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/strikethrough.png": "26f6729eee851adb4b598e3470e73983",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/underline.png": "a98ff6a28215341f764f96d627a5d0f5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.ico": "76655c51f137163876febe47398dc039",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "80baec2e00b02d4b6bb8cc743ca1541c",
"icons/Icon-192.png": "8603fe2e57de38dfe8ce9af0d99f4743",
"icons/Icon-512.png": "2148397dde3fcf5bb4d9956e7040523d",
"icons/Icon-maskable-192.png": "8603fe2e57de38dfe8ce9af0d99f4743",
"icons/Icon-maskable-512.png": "2148397dde3fcf5bb4d9956e7040523d",
"index.html": "b44678260df29b6a5d6de42f64a763f8",
"/": "b44678260df29b6a5d6de42f64a763f8",
"main.dart.js": "ffcb4b5332ebce7b587f293955980967",
"manifest.json": "5bce2264f0d6abbbc9d548275301932d",
"version.json": "37bce735216d5587358a0ad4e9893c59"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
