'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "6bc7e395a13034ae3fa67e2637f3066d",
"assets/AssetManifest.bin.json": "aa3ede09cfcbfad111d472dcc0d6a84d",
"assets/AssetManifest.json": "47478f87a22226fe8acb9169ffc2bdb4",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "8d1738065b2e30875405d945b25060a6",
"assets/images/acorazado.png": "d0de054a09a7993f49108e248c46b48d",
"assets/images/acorazado_rotado.png": "f216096a758f967ff352db9f8eff8e86",
"assets/images/ajustes.png": "29e7cf2a4a61ec54b4c96ef8991d8131",
"assets/images/battleship.png": "916fdff8e3436a908905ea6b8122ff2e",
"assets/images/clasico.png": "20662b9511e07b217138ac966a8d1dc9",
"assets/images/desplegable.png": "78802a1f26293182a8f4a8d04949c5dc",
"assets/images/destructor.png": "502cac41610af62fa833d2b25113c148",
"assets/images/destructor_rotado.png": "e340ea56cee1feb4a4f9a038e15e7228",
"assets/images/dot.png": "f3710111f363cbb627c80b068d3e42ac",
"assets/images/flota.png": "2651a93eae3dec7520353d9f1e7d1986",
"assets/images/fondo.jpg": "a6111e349a12bab0e50efead90821fb4",
"assets/images/habilidad.png": "b891a788b5294cecc9eda6065d665e89",
"assets/images/jugar.png": "7e71781249c441b223a588683ce6d783",
"assets/images/logo.png": "3c2a10d1294c6683f9fc76e026ce019b",
"assets/images/mina.png": "c66718decbe69965da1d9330582a98c0",
"assets/images/misil.png": "46dddf222069936611e9cf5f34e1bcd5",
"assets/images/patrullero.png": "19b5dc7025520890457656befcae1753",
"assets/images/patrullero_rotado.png": "6518b4bb7323f76d269fcaa761cbd59c",
"assets/images/perfil.png": "1b4bef72113e1fce603b2d30f3e72007",
"assets/images/pirata.png": "068aab05f218dac427086f91dadfce5e",
"assets/images/portaaviones.png": "0d81de39b32ba2bae9fdd8a0056d3d2a",
"assets/images/portaaviones_rotado.png": "f2b552fa464734ea35abea3cea13d3ec",
"assets/images/portada.png": "72d7f63f3557fe09fa84741d15f3f277",
"assets/images/rafaga.png": "fd747124c242d4e6ab3a839586cab5e9",
"assets/images/redCross.png": "ec170726a393fcaec12c0a65b8741bb4",
"assets/images/social.png": "0638351f6b915bd903820a978a7e8355",
"assets/images/sonar.png": "14ac9f3946030f2a87c88fb65e4465e9",
"assets/images/submarino.png": "b68ff2599142be82eba24132fe3838df",
"assets/images/submarino_rotado.png": "674aac2f87d80525e32eb415e1271927",
"assets/images/titan.png": "0dc88ba4bb5a4c4bbcba646450d2b1a3",
"assets/images/torpedo.png": "9a3f6574ccf63eee015e07b7075c6e2b",
"assets/images/vikingo.png": "27f5931db95342d19f2c013707ec6ad1",
"assets/NOTICES": "a7050d5114db996a9c082b4b6c76a8a1",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c90a2940ea4e65390f0919919ba7c293",
"/": "c90a2940ea4e65390f0919919ba7c293",
"main.dart.js": "77f8adc7c222625011319c1e560b1571",
"manifest.json": "96ff3f37d98143debcbb1132925b22e0",
"version.json": "649a51b805f04482f00ceab84e13ecff"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
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
