# Ubuntu sandbox

An Ubuntu sandbox for experimentation and proof of concepts.

## Getting Started

This project uses the vagrant-parallels provider by default. Install it via:

```bash
vagrant plugin install vagrant-parallels
```

To see how to run an alternative provider, use the help function:

```bash
./start.sh --help
```

### Alternative docker runtimes

If you want to `gVisor` as the docker runtime after starting the VM, use the following.  **Note** This is only supported on Intel-based systems.

```bash
docker run -it --runtime=runsc --rm alpine
```

## Using Tor

### Disclaimer

**The below configuration is NOT a complete solution to anonymizing your traffic. Use at your own risk.**

### Configuration

If you'd like to anonymize your traffic from inside the sandbox there is a Tor socks proxy that should already be running. See the following examples:

```bash
source torsocks on
echo ". torsocks on" >> ~/.bashrc
```
