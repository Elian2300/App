const Schedule = require("../models/schedule")

exports.getSchedules = async (req,res) => {
  try {
    const schedules = await Schedule.find().populate("groupId")
    res.json(schedules)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo horarios", error })
  }
}

exports.getScheduleById = async (req,res) => {
  try {
    const schedule = await Schedule.findById(req.params.id).populate("groupId")
    if (!schedule) return res.status(404).json({ mensaje: "Horario no encontrado" })
    res.json(schedule)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo horario", error })
  }
}

exports.createSchedule = async (req,res) => {
  try {
    const newSchedule = new Schedule(req.body)
    await newSchedule.save()
    res.status(201).json(newSchedule)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando horario", error })
  }
}

exports.updateSchedule = async (req,res) => {
  try {
    const updatedSchedule = await Schedule.findByIdAndUpdate(req.params.id, req.body, { new: true })
    if (!updatedSchedule) return res.status(404).json({ mensaje: "Horario no encontrado" })
    res.json(updatedSchedule)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando horario", error })
  }
}

exports.deleteSchedule = async (req,res) => {
  try {
    const deletedSchedule = await Schedule.findByIdAndDelete(req.params.id)
    if (!deletedSchedule) return res.status(404).json({ mensaje: "Horario no encontrado" })
    res.json({ mensaje: "Horario eliminado de forma permanente", schedule: deletedSchedule })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando horario", error })
  }
}
