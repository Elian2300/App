const express = require("express")
const cors = require("cors")
const dotenv = require("dotenv")

const conectarDB = require("./config/db")
const authRoutes = require("./routes/authRoutes")
const studentRoutes = require("./routes/studentRoutes")
const teacherRoutes = require("./routes/teacherRoutes")
const userRoutes = require("./routes/userRoutes")
const subjectRoutes = require("./routes/subjectRoutes")
const groupRoutes = require("./routes/groupRoutes")
const scheduleRoutes = require("./routes/scheduleRoutes")
const enrollmentRoutes = require("./routes/enrollmentRoutes")
const attendanceRoutes = require("./routes/attendanceRoutes")
dotenv.config()


conectarDB()

const app = express()

app.use(cors())
app.use(express.json())

// Middleware de Logs Global para auditoría
app.use((req, res, next) => {
    console.log(`\n[BACKEND] Solicitud recibida: ${req.method} ${req.url}`);
    if (Object.keys(req.body).length > 0) {
        console.log(`[BACKEND] Payload:`, JSON.stringify(req.body));
    }
    const oldSend = res.send;
    res.send = function (data) {
        console.log(`[BACKEND] Enviando Respuesta: ${res.statusCode}`);
        return oldSend.apply(res, arguments);
    }
    next();
});

app.use("/api", authRoutes)
app.use("/api", userRoutes)
app.use("/api", studentRoutes)
app.use("/api", teacherRoutes)
app.use("/api", subjectRoutes)
app.use("/api", groupRoutes)
app.use("/api", scheduleRoutes)
app.use("/api", enrollmentRoutes)
app.use("/api", attendanceRoutes)

const PORT = process.env.PORT || 3000

app.listen(PORT,()=>{
    console.log("Servidor corriendo en puerto "+PORT)
})