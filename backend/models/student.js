const mongoose = require("mongoose")

const studentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },
  matricula: String,
  nombre: String,
  apellido: String,
  carrera: String,
  cuatrimestre: Number,
  isActive: {
    type: Boolean,
    default: true
  }
}, { timestamps: true })

module.exports = mongoose.model("Student", studentSchema, "students")