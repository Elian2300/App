const Attendance = require("../models/attendance")

exports.getAttendances = async (req,res) => {
  try {
    const attendances = await Attendance.find()
      .populate("groupId")
      .populate("studentId")
      .populate("enrollmentId")
      .populate("markedBy", "email")
    res.json(attendances)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo asistencias", error })
  }
}

exports.getAttendanceById = async (req,res) => {
  try {
    const attendance = await Attendance.findById(req.params.id)
      .populate("groupId")
      .populate("studentId")
      .populate("enrollmentId")
      .populate("markedBy", "email")
    if (!attendance) return res.status(404).json({ mensaje: "Asistencia no encontrada" })
    res.json(attendance)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo asistencia", error })
  }
}

exports.createAttendance = async (req,res) => {
  try {
    const newAttendance = new Attendance(req.body)
    await newAttendance.save()
    res.status(201).json(newAttendance)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando asistencia", error })
  }
}

exports.updateAttendance = async (req,res) => {
  try {
    const updatedAttendance = await Attendance.findByIdAndUpdate(req.params.id, req.body, { new: true })
    if (!updatedAttendance) return res.status(404).json({ mensaje: "Asistencia no encontrada" })
    res.json(updatedAttendance)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando asistencia", error })
  }
}

exports.deleteAttendance = async (req,res) => {
  try {
    const deletedAttendance = await Attendance.findByIdAndDelete(req.params.id)
    if (!deletedAttendance) return res.status(404).json({ mensaje: "Asistencia no encontrada" })
    res.json({ mensaje: "Asistencia eliminada permanentemente", attendance: deletedAttendance })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando asistencia", error })
  }
}
