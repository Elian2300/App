const mongoose = require("mongoose")

const enrollmentSchema = new mongoose.Schema({
  enrolledAt: Date,
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Group"
  },
  status: String, // e.g. "active", "dropped"
  studentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Student"
  }
}, { timestamps: true })

module.exports = mongoose.model("Enrollment", enrollmentSchema, "enrollments")
