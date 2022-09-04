# Steps

1. Create one of `chws.txt` or `supervisors.txt`. The contents of either file should be the usernames that need to be included in mRDT.
2. Ensure you have NodeJS 6+ installed.
3. Run `npm ci` to set up the script dependencies.
4. Run `COUCH_URL=<instance-url> node index.js` to execute the script