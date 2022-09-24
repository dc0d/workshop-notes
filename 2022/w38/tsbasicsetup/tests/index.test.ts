import { stringifyPerson } from '../src/index';
import { Person } from '../src/protos/person';

describe('testing index file', () => {
  test('empty string should result in zero', () => {
    interface TestCase {
      given: Person;
      then: string;
    }
    const testCases: TestCase[] = [
      {
        given: {
          name: 'Nikola Tesla',
          id: 19,
          email: 'coil@nikolatesla.com',
        },
        then: '{"name":"Nikola Tesla","id":19,"email":"coil@nikolatesla.com"}',
      },
    ];

    for (const tc of testCases) {
      const actual = stringifyPerson(tc.given);

      expect(actual).toBe(tc.then);
    }
  });
});
