# Before Getting Started

1. Consider this test not only as an assessment of your skills as a developer but as a way for us to get to know you as a potential teammate. With that in mind, please feel free to reach out to us while you are working on the challenge when you have thoughts or questions that will help you complete the challenge to the best of your ability. You will NOT be penalized for doing this, we want this to be interactive!
2. Submissions must be here on GitHub. We cannot accept code in zip files or attachments.
3. We will go over your challenge during the technical interview so it may be helpful to make notes or comments about some of your design decisions.
4. Please remember to focus on the core requirements of the challenge and if you have any questions at any point, please reach out via email and we’ll get back to you ASAP.
We are looking forward to seeing what you come up with!

# Inital Enviroment Setup

### Installing Docker on a Mac:

1. **System Requirements**: Verify your Mac runs macOS 10.15 or later.
2. **Download Docker Desktop**: Visit [Docker Hub](https://hub.docker.com/), sign in or create an account, and download Docker Desktop for Mac (Intel or Apple Silicon).
3. **Install Docker Desktop**:
   - Open the `.dmg` file and drag Docker to the Applications folder.
   - Launch Docker from Applications; grant any permissions if asked.
4. **Verify Installation**:
   - Open a terminal and run `docker --version` and `docker-compose --version` to confirm both are installed.
5. **Test Docker**:
   - Execute `docker run hello-world` in the terminal to run a test container.

### Installing Docker on a PC (Windows):

1. **System Requirements**: Ensure Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later), or Windows 11.
2. **Enable WSL 2**:
   - Open PowerShell as Administrator and run: `wsl --install` to install the Windows Subsystem for Linux Version 2 (WSL 2).
   - Restart your PC.
3. **Download Docker Desktop**: Visit [Docker Hub](https://hub.docker.com/), sign in or create an account, and download Docker Desktop for Windows.
4. **Install Docker Desktop**:
   - Run the installer and follow the on-screen instructions.
   - If prompted, enable the Hyper-V Windows Features.
5. **Verify Installation**:
   - Open a command prompt or PowerShell and type `docker --version` and `docker-compose --version`.
6. **Test Docker**:
   - Execute `docker run hello-world` to test that Docker runs correctly.

# Part I: Building the Rails API

## Intial API Application Setup

Please ensure that you have Docker and Docker Compose installed on your computer by following the above instructions. Once that is complete, run the following:

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

#### To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

#### To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

#### Run the web server

    docker-compose up

#### Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

#### Getting the top 100

    curl localhost:3000

#### Checking your short URL redirect

    curl -I localhost:3000/abc

## Core Requirements for Part I:
* Given a URL, we should get back a shortcode for that URL of the shortest possible length relative to the number of links currently in the system.
* Invalid URLs should not be able to be entered into the system.
* If you go to http://yourhostname.com/shortcode, you should be redirected to the full URL.
* There should be an API response with the top 100 most frequently accessed shortcodes.
* The title of the web page for each of the shortened URLs should be fetched and stored in the database using a background job.
* Be sure to update this readme with information about the algorithm you used to shorten the URL.


# Part II: Building the Client Application
Upon approval from LTV, please move forward with the second part of the code challenge.

Setting Up the Front-End (React used as an example). Please note that you may create a separate Github repository for this application in your personal Github account and share the repository with us via email once it is complete.

1. **Create the Front-End Application**:
   - For React: `npx create-react-app my-app`

2. **Local Development Configuration**:
   - Set the `proxy` in the front-end project’s package configuration to route API requests to the Docker-hosted Rails server.
   - For React in `package.json`:
     ```json
     "proxy": "http://localhost:3000",
     ```

## Core Requirements for Part II:
* There must be a view for the Top 100 most frequently accessed URLs.
* There must be a form for inputting URLs into the system.
* Inputting a valid URL should result in displaying the new shortened URL to the user.
* Inputting an invalid URL should result in displaying errors to the user.


# General Advice for Connecting Both Apps

1. **Cross-Origin Resource Sharing (CORS)**:
   - Configure CORS in the Rails application to allow requests from the front-end domain, even locally. This is crucial for local development environments where ports differ.
   - Example CORS setup in Rails:
     ```ruby
     # Gemfile
     gem 'rack-cors'

     # config/initializers/cors.rb
     Rails.application.config.middleware.insert_before 0, Rack::Cors do
       allow do
         origins 'localhost:3001' # Adjust the port for the React app
         resource '*',
                  headers: :any,
                  methods: [:get, :post, :put, :delete, :options]
       end
     end
     ```

3. **Testing Connectivity**:
   - Test the connection by making a simple API call from the front-end app to the Rails API to fetch or send data.

4. **Documentation and Resources**:

    ##### Docker

    1. **Docker Documentation**:
       - [Docker Overview](https://docs.docker.com/get-started/overview/)
       - [Docker Compose](https://docs.docker.com/compose/)

    ##### Rails

    2. **Rails API**:
       - [Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html)
       - [Building a Rails API](https://guides.rubyonrails.org/api_app.html)

    3. **CORS in Rails**:
       - [rack-cors gem on GitHub](https://github.com/cyu/rack-cors)

    ##### React

    4. **React Documentation**:
       - [Create React App](https://create-react-app.dev/)
       - [React Proxy Configuration](https://create-react-app.dev/docs/proxying-api-requests-in-development/)

   ##### General Development and Troubleshooting

    5. **CORS (Cross-Origin Resource Sharing)**:
       - [Mozilla CORS Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)

    6. **Networking in Docker**:
       - [Docker Network Overview](https://docs.docker.com/network/)

# Debugging Tips

##### Check Docker Container Status
Use `docker ps` to ensure that all required containers are up and running. If a container is not running, use `docker logs [container_name]` to inspect any error messages that may have caused the container to crash or fail to start.

##### Verify Port Exposure and Mapping

Ensure that the ports your Rails API needs are correctly exposed and mapped in your Docker setup. This is defined in your docker-compose.yml file under the ports section. Use `docker port [container_name]` to see the actual port mappings.

##### Network Connectivity

Test network connectivity between your Docker containers and your local machine. You can use `docker exec -it [container_name] ping [target_IP_or_hostname]` to check if your container can reach your front-end application or external services.

##### Check Environment Variables

Incorrect environment variables can often cause applications to behave unexpectedly. Double-check that all required environment variables are properly set. You can use `docker exec -it [container_name] env` to list environment variables within a container.

##### Review CORS Configuration

Cross-Origin Resource Sharing (CORS) issues can prevent your front-end application from communicating with your Rails API. Ensure CORS is configured correctly in your Rails application to allow requests from the appropriate front-end URL.

##### Browser Console and Network Tools

Utilize browser developer tools to inspect console logs and network requests. This can provide insights into errors occurring on the front-end, such as failed network requests, CORS issues, or JavaScript errors.

##### Rails Logs

Check Rails logs for any error messages or stack traces. This can be done by looking at the output in your terminal where you run the Docker container or by accessing the log files directly within the container using docker exec -it [container_name] tail -f log/development.log.

##### Front-End Framework Debugging

For React, use the React Developer Tools extension to inspect components and their states.

##### Rebuild Docker Containers

If you make changes to the Docker setup (like Dockerfile or docker-compose files), ensure you rebuild your containers with docker-compose build and restart them. Sometimes, persistent issues are resolved by simply rebuilding the environment.

##### Simplify and Isolate

When faced with a complex error, simplify the scenario or isolate components to narrow down the source of the problem. For instance, test API endpoints independently with tools like Postman or curl to ensure they work as expected before connecting them with the front-end.
