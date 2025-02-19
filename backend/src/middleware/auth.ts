import { UUID } from "crypto";
import { Request, Response, NextFunction } from "express";
import  jwt  from "jsonwebtoken";
import { db } from "../db";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
    user?: UUID;
    token?: string;
}


export const auth = async (
    req: AuthRequest,
    res: Response,
    next: NextFunction
    ) => {
    try{
        const token = req.header("x-auth-header");

        if(!token){
            res.status(401).json({ErrorMsg: "Request Header not found"});
            return;
        }

        const verifyToken = jwt.verify(token, "passwordKey");

        if(!verifyToken){
            res.status(401).json({ErrorMsg: "Invalid Token"});
            return;
        }

        const verifiedToken = verifyToken as { id : UUID };

        const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));

        if(!user){
            res.status(401).json({ErrorMsg: "User not Found"});
            return;
        }

        req.user = verifiedToken.id;
        req.token = token;

        next();

    }catch(e){
        res.status(500).json({error : e});
    }
};