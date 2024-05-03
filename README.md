# Sailfish

*As fast as the wind can take us.*

## Getting Started

Sailfish is built entirely in Rust via the [Leptos](https://leptos.dev/) framework. Rust is available on most modern operating systems, and installation instructions are available at [the official website](https://rust-lang.org/).

### Prerequisites
* Rust 1.78 (nightly)
* PostgreSQL 16.1.2
* Diesel CLI
* Bun 1.1.5

After installing the latest Rust nightly and cloning this repo, grab the following tools:
* `rustup toolchain install nightly`
* `rustup target add wasm32-unknown-unknown`
* `cargo install cargo-leptos`
* `cargo install trunk`
* `cargo install diesel_cli`

Note that `diesel_cli` might complain about missing `libpq` or something like that. All that means is that you don't have PostgreSQL installed and haven't linked to the client library. Please follow the instructions related to your operating system in order to get that rectified.

Once all the tools are installed, `cd Sailfish` and then run a quick `cargo build` and `bun install` in order to fetch all the dependencies. Then, create a `.env` file in the root of the project folder with `DATABASE_URL` and `SECRET_KEY` (see `sample.env` for reference). Afterwards, make sure to run `diesel migration run` to initialize the database with all the necessary tables, and then you're off to the races.

## TODO: finish the rest of the README

## Contributing

We will (eventually) have Contribution guidelines written up! If i