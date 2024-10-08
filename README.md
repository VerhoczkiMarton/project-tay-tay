<br/>
<p align="center">
  <img src="https://emojigraph.org/media/apple/thread_1f9f5.png" width="150">
  <h3 align="center">Helping people reach their full potential through fashion.</h3>
  <p align="center">
    <br/>
    <br/>
    <a href="https://taytay.me">Visit App</a>
    .
    <a href="https://github.com/VerhoczkiMarton/project-tay-tay/issues">Report Bug</a>
    .
    <a href="https://github.com/VerhoczkiMarton/project-tay-tay/issues">Request Feature</a>
  </p>
</p>

![Contributors](https://img.shields.io/github/contributors/VerhoczkiMarton/project-tay-tay?color=dark-green) ![Stargazers](https://img.shields.io/github/stars/VerhoczkiMarton/project-tay-tay?style=social) ![Issues](https://img.shields.io/github/issues/VerhoczkiMarton/project-tay-tay) ![License](https://img.shields.io/github/license/VerhoczkiMarton/project-tay-tay) 

## About The Project

Currently this is a fancy Hello World app at most. We've been focusing on developing our infrastructure and CI/CD skills, but stay tuned, exciting stuff is coming soon.

## Built With

- Javascript with React on the frontend
- Java with Spring Boot on the backend
- Terraform and AWS for IAC
- Github Actions for CI/CD

## Getting Started

The application is hosted on AWS and is accessible via taytay.me
For local development we use docker compose.

### Installation

1. Clone the repo

```sh
git clone https://github.com/VerhoczkiMarton/project-tay-tay.git
```

2. Run locally with docker compose

```sh
docker compose up
```

### Environment variables

#### Frontend
- `VITE_API_URL` - URL of the server for API communication

#### Backend

- `POSTGRES_HOST` - (Production only) Host of Postgres Database
- `POSTGRES_PORT` - (Production only) Port of Postgres Database
- `POSTGRES_DATABASE` - (Production only) Name of Postgres Database
- `POSTGRES_USER` - (Production only) Username of Postgres Database User
- `POSTGRES_PASSWORD` - (Production only) Password of Postgres Database User
- `CLIENT_WEB_URL` - URL of the client for CORS exceptions

## Roadmap

See the [open issues](https://github.com/VerhoczkiMarton/project-tay-tay/issues) for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.
* If you have suggestions for adding or removing projects, feel free to [open an issue](https://github.com/VerhoczkiMarton/project-tay-tay/issues/new) to discuss it, or directly create a pull request after you edit the *README.md* file with necessary changes.
* Please make sure you check your spelling and grammar.
* Create individual PR for each suggestion.
* Please also read through the [Code Of Conduct](https://github.com/VerhoczkiMarton/project-tay-tay/blob/main/CODE_OF_CONDUCT.md) before posting your first idea as well.

### Creating A Pull Request

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See [LICENSE](https://github.com/VerhoczkiMarton/project-tay-tay/blob/main/LICENSE.md) for more information.

## Authors

* **Márton Verhóczki** - *Creator* - [Márton Verhóczki](https://github.com/VerhoczkiMarton) - *CEO, CTO, Project Owner, Engineering manager, Developer, Manual tester*

## Acknowledgements

* [ShaanCoding](https://github.com/ShaanCoding/)
