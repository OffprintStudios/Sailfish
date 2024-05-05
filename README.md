# Sailfish

*As fast as the wind can take us.*

## Getting Started

Sailfish is built entirely in Rust via the [Leptos](https://leptos.dev/) framework. Rust is available on most modern operating systems, and installation instructions are available at [the official website](https://rust-lang.org/).

### Prerequisites
* Rust 1.78 (nightly)
* PostgreSQL 16.1.2
* SurrealDB 1.4.2
* Bun 1.1.5

After installing the latest Rust nightly and cloning this repo, grab the following tools:
* `rustup toolchain install nightly`
* `rustup target add wasm32-unknown-unknown`
* `cargo install cargo-leptos`
* `cargo install trunk`

To install SurrealDB, head over to their website ([surrealdb.com](https://surrealdb.com/)) to get started. We also recommend installing Surrealist to visually manage your local database instance. Afterwards, run the following command to start your local SurrealDB development server in the project's `/temp` directory:

```bash
surreal start --log trace --user root --pass root file:./temp/sailfish
```

*NOTE*: Please do not modify `.gitignore` to include your local database in our repository! That database is your own personal local instance, not anyone else's.

## TODO: finish the rest of the README

## Contributing

We will (eventually) have Contribution guidelines written up! If i