const mongoose = require("mongoose")

const scheduleSchema = new mongoose.Schema({
  classroom: String,
  dayOfWeek: Number, // e.g. 1 for Monday, 2 for Tuesday...
  endTime: String,
  groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Group"
  },
  startTime: String
}, { timestamps: true })

module.exports = mongoose.model("Schedule", scheduleSchema, "schedules")
