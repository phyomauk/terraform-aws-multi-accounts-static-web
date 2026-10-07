function handler(event) {
  var request = event.request;
  var host = request.headers.host.value;

  // strip "www." if present
  if (host.startsWith("www.")) {
    var targetHost = host.slice(4);

    return {
      statusCode: 301,
      statusDescription: "Moved Permanently",
      headers: {
        location: {
          value: "https://" + targetHost + request.uri
        }
      }
    };
  }

  return request;
}