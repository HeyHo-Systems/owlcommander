# Owl Commander: Your Convenient Twilio Monitoring Companion

Welcome to Owl Commander, an innvoative open-source solution for logging and monitoring your data, featuring a beautyful UI and tailored to enhance your Twilio experience.

### About Owl Commander

Created by HeyHo Systems, Owl Commander draws its inspiration from the legendary __Total Commander__, a tool that revolutionized file management on Windows with its efficient navigation capabilities. The choice of __Owl__ in the name pays homage to Twilio's culture, where the owl is a symbol of wisdom and insight—qualities that Twilio developers, or "Twilions," bring to their work..

Featuring a sleek, user-friendly interface, Owl Commander allows you to live stream Twilio logs, providing real-time insights into your Twilio applications. Whether you're tracking call logs, function logs, conferences, or Twilio Conversations, Owl Commander offers better visibility into your communications infrastructure.

### Key Features

- __Live Streaming of Twilio Logs:__ Stay on top of your game with real-time updates, including call logs, function logs, conferences, and Twilio Conversations.
- __Beautiful User Interface:__ Navigate through your Twilio logs with an intuitive and visually appealing UI designed for ease of use and efficiency.
- __Seamless Login/Logout:__ Experience hassle-free access with our streamlined authentication process.
- __Advanced Search Functionality:__ Quickly find what you're looking for with powerful search tools, making log management simpler than ever.
- __Flexibility:__ Use our hosted version for immediate access or deploy your own instance on Heroku with ease, offering you the flexibility to choose what best suits your needs.

## Hosted Version (Beta)

Owl Commander is available in a Beta hosted version for those interested in testing its features and functionality with Twilio services. To begin, visit [https://owlcommander.com/](https://owlcommander.com/) to sign up. Once registered, you can create a team and link your Twilio account, which will allow access to a range of features such as viewing calls, alerts, conversations, and more in a streamlined user interface.

This Beta version is intended for testing and feedback purposes. Users are encouraged to explore the platform and contribute feedback on any issues or improvements, aiding in the ongoing development and refinement of Owl Commander.

## Hosting Your Own Version on Heroku

Understanding the importance of keeping Twilio __data secure and confidential__, we've simplified the process for hosting your own instance of Owl Commander. The most straightforward method is deploying the application on Heroku. With just a few clicks using the button below, the application can be set up on Heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/HeyHo-Systems/owlcommander/tree/main)

For email functionality, including sending invitation and password reset emails, the application utilizes the SendGrid add-on. 
Additionally, a version of PostgreSQL is required to store application data. 

# Roadmap

- Include Twilio SMS
- REST API (connect other clients to Owl)
- Include further Twilio API endpoints
- Serverless function logs
- AI Data monitoring (alert when your twilio usage is very different from normal)
- Limit team members rights (currently every team member has the same rights)
- Your ideas here...

# Development Setup

Owl Commander is build on a __Ruby on Rails__ framework, making it accessible through any contemporary web browser. This design choice ensures cross-platform compatibility and ease of setup, whether opting for the hosted version or deploying a self-hosted instance on a platform like Heroku. Detailed setup instructions and configuration guidelines are provided to facilitate a smooth deployment and customization process.

### Install dependencies

The app expects you have the following setup:

- Ruby 3.x (specifically, whatever version is in `.ruby-version`
- A recent version of Postgres
- yarn installed globally  `npm install --global yarn`

Install dependencies with this command

```bash
bundle install && yarn install
```

Copy the database.yml.example file and configure it appropriately

```bash
cp config/database.yml.example config/database.yml
bin/rails db:create
```

Copy the `.env.example` file and set the encryption keys.

```bash
bin/rails db:encryption:init
cp .env.example .env
```

### Start application  

Run `yarn start` and visit <http://localhost:3000>.

### Before pushing changes

```bash
yarn upgrade && bundle update
bin/rake spec RAILS_ENV=test
bin/bundler-audit --update
bin/brakeman -q -w2
bin/rubocop --parallel -A
```

# Contribution Guidelines

Thank you for your interest in contributing to Owl Commander! We value the contributions of our community members and look forward to working together to improve and evolve this tool. To ensure a smooth collaboration process, we've outlined some guidelines for contributing to Owl Commander.

### Getting Started

1. __Fork the Repository__: Start by forking the [Owl Commander repository](https://github.com/HeyHo-Systems/owl_commander) on GitHub to your own account. This is your workspace for making changes.

2. __Clone Your Fork__: Clone your forked repository to your local machine to start working on the changes.

   ```bash
   git clone https://github.com/your-username/owl_commander.git
   cd owl_commander
   ```

### Submitting a Pull Request

1. __Push Your Changes__: Push your changes to your forked repository on GitHub.

   ```bash
   git push origin your-branch-name
   ```

2. __Create a Pull Request__: Go to the original Owl Commander repository you forked from, and click on "Pull Requests" > "New Pull Request". Select your fork and branch, then fill out the pull request form with a clear title and description of your changes.

3. __Review Process__: The Owl Commander maintainers will review your pull request. They may request changes or provide feedback. Engage in the discussion and make any necessary adjustments to your pull request based on the feedback.

4. __Merging__: Once your pull request is approved, a maintainer will merge it into the main codebase.

### Additional Guidelines

- __Issue Tracking__: If you're working on an issue from the issue tracker, mention the issue number in your pull request to link it to the discussion.
- __Stay Up to Date__: Keep your fork and branch up to date with the main repository to avoid merge conflicts.

By following these guidelines, you'll contribute to making Owl Commander better for everyone. We appreciate your contributions and are excited to see what you bring to the project!

# About HeyHo Systems

HeyHo Systems focuses on developing tools and solutions designed to support the developer community. Owl Commander is a product of our efforts towards innovation and our engagement with the open-source ecosystem, reflecting our role in promoting technological advancement and facilitating collaboration within the community.

For more information about us and our projects, visit our website at [heyhosystems.com](https://heyhosystems.com).

Connect with us on LinkedIn to stay updated on our latest developments and opportunities: [HeyHo Systems on LinkedIn](https://www.linkedin.com/company/heyho-systems/).

### Engage with Us

Your feedback and contributions are valuable to us. For feature requests, bug reports, or discussions, please reach out through our GitHub issues or contact us directly. Let's collaborate to make Owl Commander the definitive Twilio monitoring and administration tool for developers.

Join us in enhancing the Twilio development experience. Together, we can create a tool that not only meets the current demands but also anticipates the future needs of the developer community.
