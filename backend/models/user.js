const mongoose = require("mongoose")

const userSchema = new mongoose.Schema({

  email: {
    type: String,
    required: true
  },

  passwordHash: {
    type: String,
    required: true
  },

  role: {
    type: String,
    required: true
  },

  isActive: {
    type: Boolean,
    default: true
  }

}, { timestamps: true })

module.exports = mongoose.model("User", userSchema)