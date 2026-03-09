const express = require("express")
const cors = require("cors")
const dotenv = require("dotenv")

const conectarDB = require("./config/db")
const authRoutes = require("./routes/authRoutes")
const studentRoutes = require("./routes/studentRoutes")
const teacherRoutes = require("./routes/teacherRoutes")
dotenv.config()




conectarDB()

const app = express()

app.use(cors())
app.use(express.json())


app.use("/api",authRoutes)
app.use("/api",teacherRoutes)
app.use("/api", studentRoutes)

const PORT = process.env.PORT || 3000

app.listen(PORT,()=>{
    console.log("Servidor corriendo en puerto "+PORT)
})