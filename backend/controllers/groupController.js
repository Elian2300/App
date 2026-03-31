const Group = require("../models/group")

exports.getGroups = async (req,res) => {
  try {
    const groups = await Group.find({ isActive: true }).populate("subjectId").populate("teacherId")
    res.json(groups)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo grupos", error })
  }
}

exports.getGroupById = async (req,res) => {
  try {
    const group = await Group.findById(req.params.id).populate("subjectId").populate("teacherId")
    if (!group) return res.status(404).json({ mensaje: "Grupo no encontrado" })
    res.json(group)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo grupo", error })
  }
}

exports.createGroup = async (req,res) => {
  try {
    const newGroup = new Group(req.body)
    await newGroup.save()
    res.status(201).json(newGroup)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando grupo", error })
  }
}

exports.updateGroup = async (req,res) => {
  try {
    const updatedGroup = await Group.findByIdAndUpdate(req.params.id, req.body, { new: true })
    if (!updatedGroup) return res.status(404).json({ mensaje: "Grupo no encontrado" })
    res.json(updatedGroup)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando grupo", error })
  }
}

exports.deleteGroup = async (req,res) => {
  try {
    const deletedGroup = await Group.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true })
    if (!deletedGroup) return res.status(404).json({ mensaje: "Grupo no encontrado" })
    res.json({ mensaje: "Grupo eliminado (soft delete)", group: deletedGroup })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando grupo", error })
  }
}
