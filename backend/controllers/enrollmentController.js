const Enrollment = require("../models/enrollment")

exports.getEnrollments = async (req,res) => {
  try {
    const enrollments = await Enrollment.find().populate("groupId").populate("studentId")
    res.json(enrollments)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo inscripciones", error })
  }
}

exports.getEnrollmentById = async (req,res) => {
  try {
    const enrollment = await Enrollment.findById(req.params.id).populate("groupId").populate("studentId")
    if (!enrollment) return res.status(404).json({ mensaje: "Inscripción no encontrada" })
    res.json(enrollment)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo inscripción", error })
  }
}

exports.createEnrollment = async (req,res) => {
  try {
    const newEnrollment = new Enrollment(req.body)
    await newEnrollment.save()
    res.status(201).json(newEnrollment)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando inscripción", error })
  }
}

exports.updateEnrollment = async (req,res) => {
  try {
    const updatedEnrollment = await Enrollment.findByIdAndUpdate(req.params.id, req.body, { new: true })
    if (!updatedEnrollment) return res.status(404).json({ mensaje: "Inscripción no encontrada" })
    res.json(updatedEnrollment)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando inscripción", error })
  }
}

exports.deleteEnrollment = async (req,res) => {
  try {
    const deletedEnrollment = await Enrollment.findByIdAndDelete(req.params.id)
    if (!deletedEnrollment) return res.status(404).json({ mensaje: "Inscripción no encontrada" })
    res.json({ mensaje: "Inscripción eliminada", enrollment: deletedEnrollment })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando inscripción", error })
  }
}
