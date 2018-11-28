# AWS re:Invent NPO Hackathon 2018

## How to Deploy API

* Node setup: Assuming you have Node Version, `nvm install v8.10.0` and npm install -g serverless
* AWS setup: Serverless will use your AWS creds. For now (it's a hackathon) use an account with Admin.
* From the `evaluate-image-api` directory run `serverless deploy -v`

### Running locally

You can run serverless locally during development before deploying to AWS:

```
sls invoke local -f donate -l
```
The `-f` identifies the function to run and `-l` will output any `console.log()`
calls to terminal.

## Helpful Links

DevPost with Challenges
https://awsnpohack2018.devpost.com/details/challenges

Goodwill Careers & Training / Job Coaching
http://www.goodwillbigbend.org/careers-and-training/job-coaching/

Serverless AWS Quick Start
https://serverless.com/framework/docs/providers/aws/guide/quick-start/
