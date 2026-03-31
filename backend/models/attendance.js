const mongoose = require("mongoose")

const attendanceSchema = new mongoose.Schema({
  date: Date,
  enrollmentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Enrollment"
  },
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Group"
  },
  markedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },
  status: String, // e.g. "present", "absent", "late"
  studentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Student"
  }
}, { timestamps: true })

module.exports = mongoose.model("Attendance", attendanceSchema, "attendances")
