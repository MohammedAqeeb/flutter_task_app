import { pgTable, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
    id : uuid("id").primaryKey().defaultRandom(), 
    name: text("name").notNull(),
    email: text("email").notNull().unique(),
    password: text("password").notNull(),
    createdAt: timestamp("create_At").defaultNow(),
    updatedAt: timestamp("updated_At").defaultNow(),
})


export type User = typeof users.$inferSelect;

export type NewUser = typeof users.$inferInsert;