const ORIGIN = "https://praxis-static.pages.dev";
export default {
  async fetch(request) {
    const url = new URL(request.url);
    // Serve the app landing from /app/ on the static origin
    let path = url.pathname;
    if (path === "/" || path === "") path = "/app/";
    else if (!path.startsWith("/app")) path = "/app" + (path.startsWith("/") ? path : "/" + path);
    const target = new URL(path + url.search, ORIGIN);
    const headers = new Headers(request.headers);
    headers.set("Host", "praxis-static.pages.dev");
    return fetch(new Request(target, { method: request.method, headers, body: request.body, redirect: "manual" }));
  }
};
