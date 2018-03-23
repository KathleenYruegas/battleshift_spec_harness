# Battleshift Spec Harness

This project tests the expected results of API endpoints for [Battleshift](https://github.com/turingschool-examples/battleshift). The code base tested against is intended to show the struggles that come along with dealing with technical debt.

## Running

You will need to have your Battleshift project running prior to running this spec harness. By default it will look for your project to be run at `http://localhost:3000`.

To set the spec harness to run against a production code base set an ENV variable for `BATTLESHIFT_BASE_URL`. One way to accomplish this is to run `export BATTLESHIFT_BASE_URL="https://example.com/"`

The test suite is built using RSpec. Run `rspec` from within the root directory of this project and follow the errors. Good luck!

