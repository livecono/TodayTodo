const CACHE_NAME = 'today-todo-shell-v4.3.1';
const SHELL_ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './images/app-logo.svg',
  './images/cloudy.jpg',
  './images/hot.jpg',
  './images/rainy.jpg',
  './images/snowy.jpg',
  './images/sunny.jpg',
  './images/thunder.jpg',
  './sounds/cafe.wav',
  './sounds/rain.wav',
  './sounds/white-noise.wav',
  './vendor/three.min.js'
];

self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(SHELL_ASSETS)));
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
    ))
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;
  const requestUrl = new URL(event.request.url);
  if (requestUrl.origin !== self.location.origin) return;
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request).then(response => {
        const copy = response.clone();
        caches.open(CACHE_NAME).then(cache => cache.put('./index.html', copy));
        return response;
      }).catch(() => caches.match('./index.html'))
    );
    return;
  }
  event.respondWith(
    caches.match(event.request).then(cached => cached || fetch(event.request).then(response => {
      const copy = response.clone();
      caches.open(CACHE_NAME).then(cache => cache.put(event.request, copy));
      return response;
    }))
  );
});