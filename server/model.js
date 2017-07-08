const mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/taskGuard')

const taskSchema = new mongoose.Schema({
  title: {
    minlength: 3,
    maxlength: 20,
    required: true,
    type: String,
  },
  description: String,
  dateLimit: {
    type: Date,
    required: true,
  },
})

const Task = mongoose.model("Password", taskSchema)

module.exports = Task
