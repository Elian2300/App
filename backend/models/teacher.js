const mongoose = require("mongoose")

const teacherSchema = new mongoose.Schema({

  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  numeroEmpleado: String,

  nombre: String,

  apellido: String,

  especialidad: String,

  isActive: {
    type: Boolean,
    default: true
  }

}, { timestamps: true })

module.exports = mongoose.model("Teacher", teacherSchema)