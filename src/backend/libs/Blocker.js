const Blocker = () => {
  return async (ctx, next) => {
    const user = ctx.request.header.host;
    const start = Date.now();
    return next().then(() => {
      const ms = Date.now() - start;
      console.log(`${ctx.method} ${ctx.url} ${user} - ${ms}ms`);
    });
  }
}

module.exports = Blocker;