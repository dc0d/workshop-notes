'use strict'

const chai = require('chai')
const expect = chai.expect

const { Command, None, L, R, M } = require('../../src/command')

describe('Command', () => {
  it('should be None initially', () => {
    const sut = Command.create()

    const actual = sut.command()

    expect(actual).to.equal(None)
  })

  it('should provide the toString representation', () => {
    const testCases = [
      { given: None, then: 'None' },
      { given: L, then: 'L' },
      { given: R, then: 'R' },
      { given: M, then: 'M' }
    ]

    for (const testCase of testCases) {
      const expectedText = testCase.then
      const sut = Command.create(testCase.given)

      const actualText = sut.toString()

      expect(actualText).to.deep.equal(expectedText)
    }
  })
})
