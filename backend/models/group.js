const mongoose = require("mongoose")

const groupSchema = new mongoose.Schema({
  capacity: Number,
  classroom: String,
  groupCode: String,
  isActive: {
    type: Boolean,
    default: true
  },
  period: String,
  subjectId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Subject"
  },
  teacherId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Teacher"
  }
}, { timestamps: true })

module.exports = mongoose.model("Group", groupSchema, "groups")
