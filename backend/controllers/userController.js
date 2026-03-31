const User = require("../models/user")
const bcrypt = require("bcrypt")

exports.getUsers = async (req,res) => {
  try {
    const users = await User.find({ isActive: true }).select("-passwordHash")
    res.json(users)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo usuarios", error })
  }
}

exports.getUserById = async (req,res) => {
  try {
    const user = await User.findById(req.params.id).select("-passwordHash")
    if (!user) return res.status(404).json({ mensaje: "Usuario no encontrado" })
    res.json(user)
  } catch(error) {
    res.status(500).json({ mensaje: "Error obteniendo usuario", error })
  }
}

exports.createUser = async (req,res) => {
  try {
    const { email, password, role } = req.body
    const salt = await bcrypt.genSalt(10)
    const passwordHash = await bcrypt.hash(password, salt)

    const newUser = new User({
      email,
      passwordHash,
      role
    })
    await newUser.save()
    
    // Convert to object and remove passwordHash before sending
    const userObj = newUser.toObject()
    delete userObj.passwordHash
    res.status(201).json(userObj)
  } catch(error) {
    res.status(500).json({ mensaje: "Error creando usuario", error })
  }
}

exports.updateUser = async (req,res) => {
  try {
    const { email, password, role, isActive } = req.body
    const updateData = { email, role, isActive }

    if (password) {
      const salt = await bcrypt.genSalt(10)
      updateData.passwordHash = await bcrypt.hash(password, salt)
    }

    const updatedUser = await User.findByIdAndUpdate(req.params.id, updateData, { new: true }).select("-passwordHash")
    if (!updatedUser) return res.status(404).json({ mensaje: "Usuario no encontrado" })
    res.json(updatedUser)
  } catch(error) {
    res.status(500).json({ mensaje: "Error actualizando usuario", error })
  }
}

exports.deleteUser = async (req,res) => {
  try {
    const deletedUser = await User.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true }).select("-passwordHash")
    if (!deletedUser) return res.status(404).json({ mensaje: "Usuario no encontrado" })
    res.json({ mensaje: "Usuario eliminado (soft delete)", user: deletedUser })
  } catch(error) {
    res.status(500).json({ mensaje: "Error eliminando usuario", error })
  }
}
