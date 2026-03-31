const express = require("express")
const router = express.Router()

const teacherController = require("../controllers/teacherController")

router.get("/teachers", teacherController.getTeachers)
router.get("/teachers/:id", teacherController.getTeacherById)
router.post("/teachers", teacherController.createTeacher)
router.put("/teachers/:id", teacherController.updateTeacher)
router.delete("/teachers/:id", teacherController.deleteTeacher)

module.exports = router