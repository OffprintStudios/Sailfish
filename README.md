# Sailfish

*As fast as the wind can take us.*

## Getting Started

Sailfish is built entirely in Rust via the [Leptos](https://leptos.dev/) framework. Rust is available on most modern operating systems, and installation instructions are available at [the official website](https://rust-lang.org/).

### Prerequisites
* Rust 1.78 (nightly)
* PostgreSQL 16.1.2
* Bun 1.1.5

After installing the latest Rust nightly and cloning this repo, grab the following tools:
* `rustup target add wasm32-unknown-unknown`
* `cargo install cargo-leptos`
* `cargo install trunk`

Next, make sure you create a `.env` file at the root of the project containing the following variables:
* `DATABASE_URL=postgresql://<username>:<password>@localhost:5432/<database name>`
* `SECRET_KEY=<a randomly generated key>`

## TODO: finish the rest of the README

## Contributing

We will (eventually) have Contribution guidelines written up! If instead you want to talk about Offprint with a growing community of authors and readers, check out [our Discord server](https://discord.gg/9cnSwfn)!