const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const dotenv = require('dotenv')

// Cargar variables de entorno desde el archivo .env
dotenv.config()

environment.plugins.append('Environment', new webpack.EnvironmentPlugin(process.env))

module.exports = environment
