'use strict'

const chai = require('chai')
const expect = chai.expect

const { N, W } = require('../../src/direction')
const { Position, Location } = require('../../src/position')

describe('Location', () => {
  it('should provide the toString representation', () => {
    const testCases = [
      { given: Location.create(0, 0), then: '0:0' },
      { given: Location.create(3, 3), then: '3:3' }
    ]

    for (const testCase of testCases) {
      const expectedText = testCase.then

      const actualText = testCase.given.toString()

      expect(actualText).to.deep.equal(expectedText)
    }
  })

  it('should prevent mutation', () => {
    const sut = Location.create(0, 0)

    expect(() => {
      sut.x = 'some arbitrary value'
    }).to.throw(
      "Cannot assign to read only property 'x' of object '[object Object]'"
    )

    expect(() => {
      sut.y = 'some arbitrary value'
    }).to.throw(
      "Cannot assign to read only property 'y' of object '[object Object]'"
    )
  })
})

describe('Position', () => {
  it('should provide the toString representation', () => {
    const testCases = [
      { given: Position.create(0, 0, N), then: '0:0:N' },
      { given: Position.create(3, 3, W), then: '3:3:W' }
    ]

    for (const testCase of testCases) {
      const expectedText = testCase.then

      const actualText = testCase.given.toString()

      expect(actualText).to.deep.equal(expectedText)
    }
  })

  it('should prevent mutation', () => {
    const sut = Position.create(0, 0)

    expect(() => {
      sut.x = 'some arbitrary value'
    }).to.throw(
      "Cannot assign to read only property 'x' of object '[object Object]'"
    )

    expect(() => {
      sut.y = 'some arbitrary value'
    }).to.throw(
      "Cannot assign to read only property 'y' of object '[object Object]'"
    )

    expect(() => {
      sut.direction = 'some arbitrary value'
    }).to.throw(
      "Cannot assign to read only property 'direction' of object '[object Object]'"
    )
  })
})
