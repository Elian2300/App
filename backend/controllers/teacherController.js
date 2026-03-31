const Teacher = require("../models/teacher")

exports.getTeachers = async (req,res) => {
  try {
    const teachers = await Teacher.find({ isActive: true })
    res.json(teachers)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo maestros", error })
  }
}

exports.getTeacherById = async (req,res) => {
  try {
    const teacher = await Teacher.findById(req.params.id)
    if (!teacher) return res.status(404).json({ mensaje: "Maestro no encontrado" })
    res.json(teacher)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo maestro", error })
  }
}

exports.createTeacher = async (req,res) => {
  try {
    const newTeacher = new Teacher(req.body)
    await newTeacher.save()
    res.status(201).json(newTeacher)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando maestro", error })
  }
}

exports.updateTeacher = async (req,res) => {
  try {
    const updatedTeacher = await Teacher.findByIdAndUpdate(req.params.id, req.body, { new: true })
    if (!updatedTeacher) return res.status(404).json({ mensaje: "Maestro no encontrado" })
    res.json(updatedTeacher)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando maestro", error })
  }
}

exports.deleteTeacher = async (req,res) => {
  try {
    const deletedTeacher = await Teacher.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true })
    if (!deletedTeacher) return res.status(404).json({ mensaje: "Maestro no encontrado" })
    res.json({ mensaje: "Maestro eliminado (soft delete)", teacher: deletedTeacher })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando maestro", error })
  }
}