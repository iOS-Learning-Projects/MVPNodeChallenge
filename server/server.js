const express = require('express')
const bodyParser = require('body-parser')
const _ = require('lodash')

const Task = require('./model')

const app = express()

app.use(bodyParser.json())

app.get('/', (request, response) => {
  Task.find((error, doc) => {
    if (doc) {
      response.send(doc)
    } else {
      response.status(500).send(error)
    }
  })
})

app.get('/:id', (request, response) => {
  Task.findOne({_id: request.params.id}, (error, doc) => {
    if (doc) {
      response.send(doc)
    } else {
      response.status(400).send(error)
    }
  })
})

app.patch('/:id', (request, response) => {
  const task = getTaskParamsFromBody(request.body)

  Task.findOneAndUpdate({_id: request.params.id}, task, {new: true}, (error, doc) => {
    if (doc) {
      response.send(doc)
    } else {
      response.status(400).send(error)
    }
  })
})

app.delete('/:id', (request, response) => {
  Task.findOneAndRemove({_id: request.params.id}, (error, doc) => {
    if (doc) {
      response.send(doc)
    } else {
      response.status(400).send(error)
    }
  })
})

app.post('/', (request, response) => {
  const task = new Task(getTaskParamsFromBody(request.body))

  task.save((error, doc) => {
    if (doc) {
      response.send(doc)
    } else {
      response.status(400).send(error)
    }
  })
})

app.listen(3000, () => {
  console.info(`Server is up on port 3000`)
})

function getTaskParamsFromBody(body) {
  return _.pick(body, ['title', 'description', 'dateLimit'])
}
