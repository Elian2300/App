const User = require("../models/user")
const bcrypt = require("bcrypt")

exports.login = async (req, res) => {

  try {

    const { email, password } = req.body

    const user = await User.findOne({ email: email })

    if (!user) {
      return res.status(401).json({
        mensaje: "usuario no encontrado"
      })
    }

    const passwordValido = await bcrypt.compare(password, user.passwordHash)

    if (!passwordValido) {
      return res.status(401).json({
        mensaje: "contraseña incorrecta"
      })
    }

    res.json({
      email: user.email,
      role: user.role
    })

  } catch (error) {

    console.error(error)

    res.status(500).json({
      mensaje: "error en el servidor"
    })

  }

}