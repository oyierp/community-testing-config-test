const { expect } = require('chai');
const moment = require('moment');
const { contacts } = require('../form-inputs');
const TestHarness = require('medic-conf-test-harness');
const harness = new TestHarness();
const now = moment('2020-01-01');

describe('Suspected case', () => {
  before(async () => {
    return await harness.start();
  });
  after(async () => {
    return await harness.stop();
  });
  beforeEach(async () => {
    await harness.clear();
    return await harness.setNow(now.valueOf());
  });
  afterEach(() => {
    expect(harness.consoleErrors).to.be.empty;
  });

  const scenariosKeys = Object.keys(contacts.actions);
  scenariosKeys.forEach((key) => {
    it(`${key}`, async () => {
      const scenario = contacts.actions[key];
      const result = await harness.fillContactForm('suspected_case', ...scenario.data);

      if (scenario.fail) {
        expect(result.errors).to.not.be.empty;
      } else {
        expect(result.errors).to.be.empty;

        it('profile card', async () => {
          const contactSummary = await harness.getContactSummary();

          expect(contactSummary.fields.length, 'Number of fields').to.be.equal(4);
        });
      }
    });
  });
});
