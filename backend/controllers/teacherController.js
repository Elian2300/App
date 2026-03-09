const Teacher = require("../models/teacher")

exports.getTeachers = async (req,res)=>{

  try{

    const teachers = await Teacher.find({ isActive:true })

    res.json(teachers)

  }catch(error){

    res.status(500).json({
      mensaje:"error obteniendo maestros"
    })

  }

}

exports.getTeacherById = async (req,res)=>{

  try{

    const teacher = await Teacher.findById(req.params.id)

    if(!teacher){
      return res.status(404).json({
        mensaje:"maestro no encontrado"
      })
    }

    res.json(teacher)

  }catch(error){

    res.status(500).json({
      mensaje:"error obteniendo maestro"
    })

  }

}