import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { logger } from "hono/logger";
import { auth } from './lib/auth';
import { db } from './db';

const app = new Hono()
app.use(logger());
app.use("/*", cors({
  origin: process.env.CORS_ORIGIN || "",
  allowMethods: ["GET", "POST", "OPTIONS"],
  allowHeaders: ["Content-Type", "Authorization"],
  credentials: true,
}));


const users = db.query('SELECT * FROM user').all()
console.log(users)

app.on(["POST", "GET"], "/api/auth/**", (c) => auth.handler(c.req.raw));

export default app
