const mongoose = require("mongoose")

const studentSchema = new mongoose.Schema({

  nombre: String,
  correo: String,
  aulaAsignada: String

})

module.exports = mongoose.model("Student", studentSchema, "students")