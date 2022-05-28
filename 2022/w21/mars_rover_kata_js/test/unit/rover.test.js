'use strict'

const chai = require('chai')
const expect = chai.expect

const { N, W, E, S } = require('../../src/direction')
const { Position } = require('../../src/position')
const { L, R, M } = require('../../src/command')
const { Rover } = require('../../src/rover')

describe('Rover', () => {
  it('should be at 0 0 N initially', () => {
    const expectedPosition = Position.create(0, 0, N)
    const sut = Rover.create()

    const actualPosition = sut.currentPosition()

    expect(actualPosition).to.deep.equal(expectedPosition)
  })

  it('should change direction on direction commands', () => {
    const testCases = [
      { given: [L], then: Position.create(0, 0, W) },
      { given: [R], then: Position.create(0, 0, E) }
    ]

    for (const testCase of testCases) {
      const expectedPosition = testCase.then
      const sut = Rover.create()

      sut.executeCommands(testCase.given)
      const actualPosition = sut.currentPosition()

      expect(actualPosition).to.deep.equal(expectedPosition)
    }
  })

  it('should change direction on a chain of direction commands', () => {
    const testCases = [
      { given: [L], then: Position.create(0, 0, W) },
      { given: [R], then: Position.create(0, 0, E) },
      { given: [R, R], then: Position.create(0, 0, S) },
      { given: [R, R, R], then: Position.create(0, 0, W) },
      { given: [L, L], then: Position.create(0, 0, S) },
      { given: [L, L, L], then: Position.create(0, 0, E) }
    ]

    for (const testCase of testCases) {
      const expectedPosition = testCase.then
      const sut = Rover.create()

      sut.executeCommands(testCase.given)
      const actualPosition = sut.currentPosition()

      expect(actualPosition).to.deep.equal(expectedPosition)
    }
  })

  it('should wrap around at the end of x axis', () => {
    const initialPosition = Position.create(9, 0, E)
    const expectedPosition = Position.create(0, 0, E)
    const sut = Rover.create(initialPosition)

    sut.executeCommands(M)
    const actualPosition = sut.currentPosition()

    expect(actualPosition).to.deep.equal(expectedPosition)
  })

  it('should wrap around at the beginning of x axis', () => {
    const initialPosition = Position.create(0, 0, W)
    const expectedPosition = Position.create(9, 0, W)
    const sut = Rover.create(initialPosition)

    sut.executeCommands(M)
    const actualPosition = sut.currentPosition()

    expect(actualPosition).to.deep.equal(expectedPosition)
  })

  it('should wrap around at the end of y axis', () => {
    const initialPosition = Position.create(0, 9, N)
    const expectedPosition = Position.create(0, 0, N)
    const sut = Rover.create(initialPosition)

    sut.executeCommands(M)
    const actualPosition = sut.currentPosition()

    expect(actualPosition).to.deep.equal(expectedPosition)
  })

  it('should wrap around at the beginning of y axis', () => {
    const initialPosition = Position.create(0, 0, S)
    const expectedPosition = Position.create(0, 9, S)
    const sut = Rover.create(initialPosition)

    sut.executeCommands(M)
    const actualPosition = sut.currentPosition()

    expect(actualPosition).to.deep.equal(expectedPosition)
  })

  it('should change position on a chain of commands', () => {
    const testCases = [
      { given: [R, M, M, L, M], then: Position.create(2, 1, N) },
      { given: [L, M, L, M, L, M, L, M], then: Position.create(0, 0, N) },
      { given: [L, M, L, M, L, M, L, M, L, M], then: Position.create(9, 0, W) },
      { given: [R, M, L, M, L, M, L, M, L, M], then: Position.create(1, 0, E) }
    ]

    for (const testCase of testCases) {
      const expectedPosition = testCase.then
      const sut = Rover.create()

      sut.executeCommands(testCase.given)
      const actualPosition = sut.currentPosition()

      expect(actualPosition).to.deep.equal(expectedPosition)
    }
  })

  it('should error on receiving unknown command', () => {
    const unknownCommand = 'UNKNOWN_COMMAND'
    const sut = Rover.create()

    expect(() => sut.executeCommands([unknownCommand])).to.throw(
      `Unknown command: ${unknownCommand}`
    )
  })
})
