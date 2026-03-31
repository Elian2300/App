const express = require("express")
const router = express.Router()

const groupController = require("../controllers/groupController")

router.get("/groups", groupController.getGroups)
router.get("/groups/:id", groupController.getGroupById)
router.post("/groups", groupController.createGroup)
router.put("/groups/:id", groupController.updateGroup)
router.delete("/groups/:id", groupController.deleteGroup)

module.exports = router
