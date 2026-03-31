const Subject = require("../models/subject")

exports.getSubjects = async (req,res) => {
  try {
    const subjects = await Subject.find({ isActive: true })
    res.json(subjects)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo materias", error })
  }
}

exports.getSubjectById = async (req,res) => {
  try {
    const subject = await Subject.findById(req.params.id)
    if (!subject) return res.status(404).json({ mensaje: "Materia no encontrada" })
    res.json(subject)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo materia", error })
  }
}

exports.createSubject = async (req,res) => {
  try {
    const newSubject = new Subject(req.body)
    await newSubject.save()
    res.status(201).json(newSubject)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando materia", error })
  }
}

exports.updateSubject = async (req,res) => {
  try {
    const updatedSubject = await Subject.findByIdAndUpdate(req.params.id, req.body, { new: true })
    if (!updatedSubject) return res.status(404).json({ mensaje: "Materia no encontrada" })
    res.json(updatedSubject)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando materia", error })
  }
}

exports.deleteSubject = async (req,res) => {
  try {
    const deletedSubject = await Subject.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true })
    if (!deletedSubject) return res.status(404).json({ mensaje: "Materia no encontrada" })
    res.json({ mensaje: "Materia eliminada (soft delete)", subject: deletedSubject })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando materia", error })
  }
}
