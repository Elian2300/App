const mongoose = require("mongoose")

const conectarDB = async () => {

    try {

        await mongoose.connect("mongodb+srv://swag_mongo_dev:pipipopo4@swagmong.vlhtcmj.mongodb.net/swag?retryWrites=true&w=majority&appName=SWAGMONG")

        console.log("MongoDB conectado")

    } catch (error) {

        console.error(error)
        process.exit(1)

    }

}

module.exports = conectarDB