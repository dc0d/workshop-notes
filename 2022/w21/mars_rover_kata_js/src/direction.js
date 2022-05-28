'use strict'

const N = 'N'
const E = 'E'
const S = 'S'
const W = 'W'

const lefts = new Map([
  [N, W],
  [E, N],
  [S, E],
  [W, S]
])

const rights = new Map([
  [N, E],
  [E, S],
  [S, W],
  [W, N]
])

class Direction {
  static create(initialDirection = N) {
    return new Direction(initialDirection)
  }

  constructor(initialDirection) {
    Object.defineProperty(this, 'value', {
      value: initialDirection,
      writable: false,
      enumerable: true,
      configurable: true
    })
  }

  direction() {
    return this.value
  }

  left() {
    return lefts.get(this.value)
  }

  right() {
    return rights.get(this.value)
  }

  toString() {
    return this.value
  }
}

module.exports = { Direction, N, E, S, W }
