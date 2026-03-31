const express = require("express")
const router = express.Router()

const subjectController = require("../controllers/subjectController")

router.get("/subjects", subjectController.getSubjects)
router.get("/subjects/:id", subjectController.getSubjectById)
router.post("/subjects", subjectController.createSubject)
router.put("/subjects/:id", subjectController.updateSubject)
router.delete("/subjects/:id", subjectController.deleteSubject)

module.exports = router
