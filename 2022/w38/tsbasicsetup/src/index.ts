import { Person } from './protos/person';

export function stringifyPerson(person: Person): string {
  return JSON.stringify(person);
}

const samplePerson: Person = {
  name: 'Tesla',
  id: 19,
  email: 'tesla@teslacoils.com',
};

console.log(samplePerson);
