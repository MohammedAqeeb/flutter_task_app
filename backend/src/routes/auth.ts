import {Router, Request, Response} from 'express';
import { db } from '../db';
import { NewUser, users } from '../db/schema';
import { eq } from 'drizzle-orm';
import bcryptjs from "bcryptjs";
import jwt  from 'jsonwebtoken';
import { auth, AuthRequest } from '../middleware/auth';
import { error } from 'console';


const authRouter = Router();


interface SignUpBody{
    name:string;
    email:string;
    password:string;
}

interface LoginBody{
    email:string;
    password:string;
}


authRouter.post("/signup", 
    async(req: Request<{},{}, SignUpBody>, res: Response) => {   
    try{
        // Getting the request body from the users
        const {name, email, password} = req.body;
        
        // check email existing in the dataBase
        const checkUserExist = await db.select().from(users).where(eq(users.email,email));

        // check if the email id already existing in the dataBase
        if(checkUserExist.length){
            res.status(400).json({msg: 'User with email id Already Exists'});
            return;
        }
        const hashedPassword = await bcryptjs.hash(password,8);


        const newUser: NewUser ={
            name,
            email,
            password: hashedPassword,
        }

        const [user] = await db.insert(users).values(newUser).returning();

        res.status(201).json(user);

    }catch(e){
        res.status(500).json({error: e});
    }
});

authRouter.post("/login", 
    async(req: Request<{},{}, LoginBody>, res: Response) => {   
    try{
        // Getting the request body from the users
        const {email, password} = req.body;
        
        // email exists in the dataBase
        const [checkUserExist] = await db.select().from(users).where(eq(users.email,email));

        // check if the email id already existing in the dataBase
        if(!checkUserExist){
            res.status(400).json({msg: `User with email id Does'/t Exists`});
            return;
        }

        // Checking for valid password of existing user
        const validPassword = await bcryptjs.compare(password, checkUserExist.password);
        if(!validPassword){
            res.status(400).json({msg:"Incorrect Password"});
            return;
        }

        const token = jwt.sign({id: checkUserExist.id},"passwordKey")

        res.json({ token, ...checkUserExist });

    }catch(e){
        res.status(500).json({error: e});
    }
});




authRouter.post('/isTokenValid', async(req,res) => {
    try{
        // Get the header body
        const getToken = req.header('x-auth-header');

        // check if header is not empty
        if(!getToken) {
            res.json(false);
            return;
        }

        // verify the token from the header body
        const verifyToken = jwt.verify(getToken,'passwordKey');

        // check if token is valid 
        if(!verifyToken){
            res.json(false);
            return;
        }

        const verifiedToken = verifyToken as {id : string };

        // get the user data 

        const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));

        if(!user){
            res.json(false);
            return;
        }
        res.json(true);

    }catch(e){
        res.status(500).json(false)
    }




});

authRouter.get('/', auth, async (req: AuthRequest,res) => 
{
    try{
        if(!req.user){
            res.status(401).json({msg: "User not found"});
            return;
        }

        const [user] = await db.select().from(users).where(eq(users.id, req.user));

        res.json({ ...user, token: req.token});


    }catch(e){
        res.status(500).json({error: e});
    }
});

export default authRouter;