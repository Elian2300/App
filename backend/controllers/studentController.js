const Student = require("../models/student")

exports.getStudents = async (req,res)=>{

  try{

    const students = await Student.find()

    res.json(students)

  }catch(error){

    res.status(500).json({
      mensaje:"error obteniendo estudiantes"
    })

  }

}