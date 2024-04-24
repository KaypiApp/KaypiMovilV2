const mongoose = require('mongoose');

const dbConnection = async() => {

    try {
        console.log('Conecting DB...');
        await mongoose.connect('mongodb+srv://KaypiAdmin:KaypiAdmin1234@cluster0.plmtfgc.mongodb.net/kaypi?retryWrites=true&w=majority&appName=Cluster0',{
            useNewUrlParser: true
        });
        console.log('Conectado......:D');
    }
    catch (error) {
        throw new Error(error);
    }

}

module.exports = { dbConnection }