# Sailfish

*As fast as the wind can take us.*

## Getting Started

Sailfish is divided into two parts: the API (under `Sources`) and the Client (under `Client`). Depending on what you want to work on, the steps to compile are listed down below (which both assume you have *already* cloned the repository).

### Client

Make sure you have the latest NodeJS version installed and ready to go. Additionally, create a `.env` file at the `Client` root and populate it with your `PUBLIC_API_URL` value. Then, take the following steps:

1. Move into the project directory with `cd Sailfish/Client`
2. Install all dependencies with `yarn install`
3. Create a `.env` file at the `Client` root and populate it with your `PUBLIC_API_URL` value (`http://127.0.0.1:3333` should be fine for development)
4. Start the dev server with `yarn run dev`

### API

The Sailfish API requires **Swift 5.6** at a minimum, but please install the latest version for your platform if it's higher than that. Official builds are available on [The Swift Project's homepage](https://swift.org/) for Windows, Linux, and macOS. You might also prefer running via `docker-compose up`, which should get you a full development environment equivalent to what we run on the production and staging servers. 

Additionally, make sure you have the latest **PostgreSQL** and **Redis** versions installed. Check out `sample.env` to set up your environment variables in your own `.env` file. If you want to test out image uploading functionality (we use DigitalOcean Spaces at present), also fill out the `DIGITALOCEAN_SPACES_*` variables, although the server should work fine without those (you just won't be able to upload images).

After all that's done, take the following steps:

1. Move into the project directory with `cd Sailfish`
2. Install dependencies with `swift package resolve` (if you're using the official Swift extension for VSCode, this should happen automatically)
3. Start the server with `vapor run`

If using Docker, follow these instead:

1. Move into the project directory with `cd Sailfish`
2. Run `docker compose up`

## Contributing

We will (eventually!) have Contribution guidelines written up! If instead you want to talk about Offprint with a growing community of authors and readers, check out [our Discord server](https://discord.gg/9cnSwfn)!
