const { expect } = require('chai');
const moment = require('moment');
const { contact_follow_up } = require('../form-inputs');
const TestHarness = require('medic-conf-test-harness');
const harness = new TestHarness();
const now = moment('2020-01-01');

describe('Contact follow up', () => {
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

  const scenariosKeys = Object.keys(contact_follow_up.actions);
  scenariosKeys.forEach((key) => {
    it(`${key}`, async () => {
      const scenario = contact_follow_up.actions[key];
      const result = await harness.fillForm('contact_follow_up', ...scenario.data);

      if (scenario.fail) {
        expect(result.errors).to.not.be.empty;
      } else {
        expect(result.errors).to.be.empty;
      }
      if (scenario.expectation) {
        const root = result.report.fields[scenario.expectation.property] || result.report.fields;
        expect(root).to.deep.include(scenario.expectation.value);
      }
    });
  });
});
