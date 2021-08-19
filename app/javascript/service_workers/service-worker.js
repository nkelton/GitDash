self.addEventListener("push", function(event) {
  console.log('pushing!');

  var title = (event.data && event.data.text()) || "Yay a message";

  event.waitUntil(
    self.registration.showNotification(title, {
      body: "We have received a push message",
      tag:  "push-simple-demo-notification-tag"
    })
  );
});
// testing...
self.addEventListener('install', function(event) {
  console.log('Service Worker installing.');
});

self.addEventListener('activate', function(event) {
  console.log('Service Worker activated.');
});
self.addEventListener('fetch', function(event) {
  console.log('Service Worker fetching.');
});