'use strict'

const None = 'None'
const L = 'L'
const R = 'R'
const M = 'M'

class Command {
  static create(cmd = None) {
    return new Command(cmd)
  }

  constructor(cmd) {
    Object.defineProperty(this, 'cmd', {
      value: cmd,
      writable: false,
      enumerable: true,
      configurable: true
    })
  }

  command() {
    return this.cmd
  }

  toString() {
    return this.cmd
  }
}

module.exports = { Command, None, L, R, M }
