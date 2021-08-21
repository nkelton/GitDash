self.addEventListener("push", function(event) {
  const data = (event.data && event.data.json()) || 'Event with no data!';

  event.waitUntil(
    self.registration.showNotification(data['message'], {
      body: data['link'],
      tag:  "gitdash-push-message"
    })
  );
});

self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  clients.openWindow(new URL(event.notification.body));
});
