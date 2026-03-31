const Student = require("../models/student")

exports.getStudents = async (req,res) => {
  try {
    const students = await Student.find({ isActive: true })
    res.json(students)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo estudiantes", error })
  }
}

exports.getStudentById = async (req,res) => {
  try {
    const student = await Student.findById(req.params.id)
    if (!student) return res.status(404).json({ mensaje: "Estudiante no encontrado" })
    res.json(student)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo estudiante", error })
  }
}

exports.createStudent = async (req,res) => {
  try {
    const newStudent = new Student(req.body)
    await newStudent.save()
    res.status(201).json(newStudent)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando estudiante", error })
  }
}

exports.updateStudent = async (req,res) => {
  try {
    const updatedStudent = await Student.findByIdAndUpdate(req.params.id, req.body, { new: true })
    if (!updatedStudent) return res.status(404).json({ mensaje: "Estudiante no encontrado" })
    res.json(updatedStudent)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando estudiante", error })
  }
}

exports.deleteStudent = async (req,res) => {
  try {
    const deletedStudent = await Student.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true })
    if (!deletedStudent) return res.status(404).json({ mensaje: "Estudiante no encontrado" })
    res.json({ mensaje: "Estudiante eliminado (soft delete)", student: deletedStudent })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando estudiante", error })
  }
}