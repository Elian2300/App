const mongoose = require("mongoose")

const subjectSchema = new mongoose.Schema({
  carrera: String,
  codigo: String,
  creditos: Number,
  cuatrimestre: Number,
  isActive: {
    type: Boolean,
    default: true
  },
  nombre: String
}, { timestamps: true })

module.exports = mongoose.model("Subject", subjectSchema, "subjects")
