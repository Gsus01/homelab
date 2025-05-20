# Home Server Configuration

## Project Overview

This project contains Docker Compose configurations for various self-hosted services. The goal is to provide an easy way to set up and manage a home server with a variety of applications.

## Services

The following services are included in this project:

*   **File Syncing:**
    *   Syncthing: Continuous file synchronization.
*   **Media Streaming:**
    *   Jellyfin: A free software media system.
*   **Network Management:**
    *   DuckDNS: A free dynamic DNS service.
    *   Pi-hole: A network-wide ad blocker.
    *   Samba: File sharing for Windows, macOS, and Linux.
    *   Traefik: A modern reverse proxy and load balancer.
    *   WireGuard: A fast and modern VPN.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

*   [Docker](https://docs.docker.com/get-docker/)
*   [Docker Compose](https://docs.docker.com/compose/install/)

## How to Use Docker Compose

Each service is configured in its own directory and has a `docker-compose.yml` file. To use a service:

1.  **Navigate to the service directory:**
    ```bash
    cd <service_directory>
    ```
    For example, to use Jellyfin:
    ```bash
    cd media/jellyfin
    ```

2.  **Configure the service (if necessary):**
    Some services may require you to create or modify configuration files (e.g., `.env` files from `.env.template`). Check the service-specific directory for any README files or template configuration files.

3.  **Start the service:**
    ```bash
    docker-compose up -d
    ```
    The `-d` flag runs the containers in detached mode (in the background).

4.  **View logs (optional):**
    ```bash
    docker-compose logs -f
    ```

5.  **Stop the service:**
    ```bash
    docker-compose down
    ```

**Note:** Some services may have dependencies on others (e.g., services that rely on Traefik for reverse proxying). It's generally a good idea to start core network services like Traefik first.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.
