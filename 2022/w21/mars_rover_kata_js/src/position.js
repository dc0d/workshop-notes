'use strict'

class Location {
  static create(x, y) {
    return new Location(x, y)
  }

  constructor(x, y) {
    Object.defineProperty(this, 'x', {
      value: x,
      writable: false,
      enumerable: true,
      configurable: true
    })
    Object.defineProperty(this, 'y', {
      value: y,
      writable: false,
      enumerable: true,
      configurable: true
    })
  }

  toString() {
    return `${this.x}:${this.y}`
  }
}

class Position extends Location {
  static create(x, y, direction) {
    return new Position(x, y, direction)
  }

  constructor(x, y, direction) {
    super(x, y)
    Object.defineProperty(this, 'direction', {
      value: direction,
      writable: false,
      enumerable: true,
      configurable: true
    })
  }

  toString() {
    return `${this.x}:${this.y}:${this.direction}`
  }
}

module.exports = { Location, Position }
