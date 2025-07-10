import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewTask, tasks, users } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";
import { error } from "console";

const taskRouter = Router();


taskRouter.post("/", auth, async (req: AuthRequest ,res) => {
    try{
        const body : any = { 
    
          ...req.body, 
          uid: req.user!
        
        };

        if (req.body.dueAt) {
          const parsedDate = new Date(req.body.dueAt);
          if (isNaN(parsedDate.getTime())) {
            res.status(400).json({error: "Invalid dueAt Format"}); 
          }
          body.dueAt = parsedDate;
        }
      
        const newTask: NewTask = body;

        const [task] = await db.insert(tasks).values(newTask).returning();

        res.status(201).json(task);
        
    }catch (e){

        res.status(500).json({error: e});
    }
});

taskRouter.get('/', auth, async (req: AuthRequest, res) => {
    try{
      
        const allTask = await db.select().from(tasks).where(eq(tasks.uid , req.user!));
        res.json(allTask);

    }catch(e) {
        res.status(500).json({error: e});
    }
});

taskRouter.delete("/", auth, async (req: AuthRequest, res) => {
  try {
    const { taskId }: { taskId: string } = req.body;
    await db.delete(tasks).where(eq(tasks.id, taskId));

    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

export default taskRouter;