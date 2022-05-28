'use strict'

const Width = 10
const Height = 10

const { Direction, N, W, E, S } = require('./direction')
const { Position } = require('./position')
const { L, R, M } = require('./command')

class DirectionHandler {
  static create(command, currentPosition) {
    return new DirectionHandler(command, currentPosition)
  }

  constructor(command, currentPosition) {
    this.command = command
    this.currentPosition = currentPosition
  }

  handle() {
    switch (this.command) {
      case L:
        return this.turnLeft()
      case R:
        return this.turnRight()
    }
  }

  turnLeft() {
    const d = Direction.create(this.currentPosition.direction)
    return Position.create(
      this.currentPosition.x,
      this.currentPosition.y,
      d.left()
    )
  }

  turnRight() {
    const d = Direction.create(this.currentPosition.direction)
    return Position.create(
      this.currentPosition.x,
      this.currentPosition.y,
      d.right()
    )
  }
}

class LocationHandler {
  static create(command, currentPosition) {
    return new LocationHandler(command, currentPosition)
  }

  constructor(command, currentPosition) {
    this.command = command
    this.currentPosition = currentPosition
  }

  handle() {
    switch (this.currentPosition.direction) {
      case E:
        return this.moveEast()
      case W:
        return this.moveWest()
      case N:
        return this.moveNorth()
      case S:
        return this.moveSouth()
    }
  }

  moveSouth() {
    let y = this.currentPosition.y - 1
    if (y < 0) {
      y = Height - 1
    }
    return Position.create(
      this.currentPosition.x,
      y,
      this.currentPosition.direction
    )
  }

  moveNorth() {
    let y = this.currentPosition.y + 1
    if (y >= Height) {
      y = 0
    }
    return Position.create(
      this.currentPosition.x,
      y,
      this.currentPosition.direction
    )
  }

  moveWest() {
    let x = this.currentPosition.x - 1
    if (x < 0) {
      x = Width - 1
    }
    return Position.create(
      x,
      this.currentPosition.y,
      this.currentPosition.direction
    )
  }

  moveEast() {
    let x = this.currentPosition.x + 1
    if (x >= Width) {
      x = 0
    }
    return Position.create(
      x,
      this.currentPosition.y,
      this.currentPosition.direction
    )
  }
}

const createCommandHandler = (command, currentPosition) => {
  switch (command) {
    case L:
      return DirectionHandler.create(command, currentPosition)
    case R:
      return DirectionHandler.create(command, currentPosition)
    case M:
      return LocationHandler.create(command, currentPosition)
    default:
      throw new Error(`Unknown command: ${command}`)
  }
}

class Rover {
  static create(initialPosition = Position.create(0, 0, N)) {
    return new Rover(initialPosition)
  }

  constructor(initialPosition) {
    this.position = initialPosition
  }

  currentPosition() {
    return this.position
  }

  executeCommands(commands) {
    for (const command of commands) {
      const handler = createCommandHandler(command, this.currentPosition())
      this.position = handler.handle()
    }
  }
}

module.exports = { Rover, Width, Height }
