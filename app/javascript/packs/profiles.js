function urlB64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding)
    .replace(/\-/g, '+')
    .replace(/_/g, '/');

  const rawData = atob(base64);
  const outputArray = new Uint8Array(rawData.length);

  for (var i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

window.addEventListener('load', () => {
  navigator.serviceWorker.register('/service-worker.js').then(registration => {
    console.log('ServiceWorker registered: ', registration);
    console.log('serviceWorker', navigator.serviceWorker)

    var serviceWorker;
    if (registration.installing) {
      serviceWorker = registration.installing;
      console.log('Service worker installing.');
    } else if (registration.waiting) {
      serviceWorker = registration.waiting;
      console.log('Service worker installed & waiting.');
    } else if (registration.active) {
      serviceWorker = registration.active;
      console.log('Service worker active.');
    }
  }).catch(registrationError => {
    console.log('Service worker registration failed: ', registrationError);
  });


  navigator.serviceWorker.ready.then(function(reg) {
    const applicationServerKey = urlB64ToUint8Array('BOlgPaGK1sdtwi9niXB-3dDjji4ziTVTTJXXhjGjtQRs3u7rmcvUeXzmJ2XoojHsVVvgk_TJyQAtzaj7_-Wi94M=')
    reg.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey
    })
    .then(pushSubscription => {
      console.log(
        "Received PushSubscription:",
        JSON.stringify(pushSubscription)
      );
      $.ajax({
        url : 'http://localhost:3000/subscription',
        headers: {
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        },
        data : JSON.stringify({ subscription: pushSubscription.toJSON() }),
        type : 'PATCH',
        contentType : 'application/json',
        processData: false,
        dataType: 'json'
      });

      return pushSubscription;
    });

    reg.pushManager.getSubscription().then(function(subscription) {
      console.log('subscription', subscription)
    })
  });
});
