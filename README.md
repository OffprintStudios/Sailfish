# Sailfish

*As fast as the wind can take us.*

## Getting Started

Sailfish is built entirely in Rust via the [Leptos](https://leptos.dev/) framework. Rust is available on most modern operating systems, and installation instructions are available at [the official website](https://rust-lang.org/).

### Prerequisites
* Rust 1.78 (nightly)
* PostgreSQL 16.1.2
* EdgeDB 5.0
* Bun 1.1.5

After installing the latest Rust nightly and cloning this repo, grab the following tools:
* `rustup toolchain install nightly`
* `rustup target add wasm32-unknown-unknown`
* `cargo install cargo-leptos`
* `cargo install trunk`

For EdgeDB, just follow the instructions at [their website](https://edgedb.com/) to install the database and CLI, then run `edgedb watch` to generate the schema. You can use the built-in web UI (via `edgedb ui`) to inspect everything.

## TODO: finish the rest of the README

## Contributing

We will (eventually) have Contribution guidelines written up! If i