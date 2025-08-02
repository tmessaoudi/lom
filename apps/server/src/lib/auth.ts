import { betterAuth } from "better-auth";
import { db as database } from "../db";
import { createAuthMiddleware } from "better-auth/api";

export const auth = betterAuth({
  database,
  user: {
    fields: {
      emailVerified: "email_verified",
      createdAt: "created_at",
      updatedAt: "updated_at"
    }
  },
  session:{
    fields: {
      userId:"user_id", 
      createdAt: "created_at",
      updatedAt: "updated_at",
      expiresAt: "expires_at",
      ipAddress: "ip_address",
      userAgent: "user_agent"
    }
  },
  verification: {
    fields: {
      createdAt : "created_at",
      expiresAt : "expires_at",
      updatedAt : "updated_at"
    }
  },
  account: {
    fields: {
      accountId: "account_id",
      accessToken: "access_token",
      accessTokenExpiresAt: "access_token_expires_at",
      idToken:"id_token",
      providerId:"provider_id", 
      refreshToken:"refresh_token", 
      refreshTokenExpiresAt:"refresh_token_expires_at", 
      userId:"user_id", 
      createdAt: "created_at",
      updatedAt: "updated_at"
    }
  },
  hooks: {
    before: createAuthMiddleware(async (ctx) => {
      // Execute before processing the request
      console.log("Request path:", ctx.path);
    }),
    after: createAuthMiddleware(async (ctx) => {
      // Execute after processing the request
      console.log("Response:", ctx.context.returned);
    })
  },
  trustedOrigins: [
    process.env.CORS_ORIGIN || "",
  ],
  emailAndPassword: {
    enabled: true,
  },
  secret: process.env.BETTER_AUTH_SECRET,
  baseURL: process.env.BETTER_AUTH_URL,
});