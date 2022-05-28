'use strict'

const chai = require('chai')
const expect = chai.expect
const { Direction, N, E, S, W } = require('../../src/direction')

describe('Direction', () => {
  it('should be N initially', () => {
    const sut = Direction.create()

    const actualDirection = sut.direction()

    expect(actualDirection).to.deep.equal(N)
  })

  it('should prevent mutation', () => {
    const sut = Direction.create()

    expect(() => {
      sut.value = 'some arbitrary value'
    }).to.throw(
      "Cannot assign to read only property 'value' of object '[object Object]'"
    )
  })

  it('should provide the left direction', () => {
    const testCases = [
      { given: N, then: W },
      { given: E, then: N },
      { given: S, then: E },
      { given: W, then: S }
    ]

    for (const testCase of testCases) {
      const sut = Direction.create(testCase.given)
      const expectedDirection = testCase.then

      const actualDirection = sut.left()

      expect(actualDirection).to.deep.equal(expectedDirection)
    }
  })

  it('should provide the right direction', () => {
    const testCases = [
      { given: N, then: E },
      { given: E, then: S },
      { given: S, then: W },
      { given: W, then: N }
    ]

    for (const testCase of testCases) {
      const sut = Direction.create(testCase.given)
      const expectedDirection = testCase.then

      const actualDirection = sut.right()

      expect(actualDirection).to.deep.equal(expectedDirection)
    }
  })

  it('should provide the toString representation', () => {
    const testCases = [
      { given: N, then: 'N' },
      { given: E, then: 'E' },
      { given: S, then: 'S' },
      { given: W, then: 'W' }
    ]

    for (const testCase of testCases) {
      const sut = Direction.create(testCase.given)
      const expectedDirection = testCase.then

      const actualDirection = sut.toString()

      expect(actualDirection).to.deep.equal(expectedDirection)
    }
  })
})
