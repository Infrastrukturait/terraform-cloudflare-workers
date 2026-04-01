export default {
    async fetch(request, env) {
        return new Response(
            JSON.stringify({
                message: "Hello from Cloudflare Worker",
                app: env.APP_NAME,
                environment: env.ENVIRONMENT
            }),
            {
                headers: {
                    "content-type": "application/json"
                }
            }
        );
    }
};
