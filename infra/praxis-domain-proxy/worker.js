const ORIGIN = "https://praxis-static.pages.dev";

export default {
  async fetch(request) {
    const url = new URL(request.url);
    let path = url.pathname;
    // Cloud landing at / (SaaS hostname stand-in until app.praxis DNS exists)
    if (path === "/" || path === "") path = "/app/";
    const target = new URL(path + url.search, ORIGIN);
    const headers = new Headers(request.headers);
    headers.set("Host", "praxis-static.pages.dev");
    return fetch(
      new Request(target, {
        method: request.method,
        headers,
        body: request.body,
        redirect: "manual",
      })
    );
  },
};
