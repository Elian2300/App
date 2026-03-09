const express = require("express")
const router = express.Router()

const teacherController = require("../controllers/teacherController")

router.get("/teachers", teacherController.getTeachers)

router.get("/teachers/:id", teacherController.getTeacherById)

module.exports = router