# Ubuntu sandbox

An Ubuntu sandbox for experimentation and proof of concepts.

## Alternative docker runtimes
If you want to `gVisor` as the docker runtime after starting the VM, use:
```bash
docker run -it --runtime=runsc --rm alpine
```

## Using Tor
### Disclaimer
**The below configuration is NOT a complete solution to anonymizing your traffic. Use at your own risk.**

### Configuration
If you'd like to anonymize your traffic from inside the sandbox there is a Tor socks proxy that should already be running. See the following examples:
```bash
proxy="socks5h://127.0.0.1:9150"
echo "ALL_PROXY=${proxy}" | sudo tee --append /etc/environment
export "ALL_PROXY=${proxy}"
echo "http_proxy=${proxy}" | sudo tee --append /etc/environment
export "http_proxy=${proxy}"
echo "HTTP_PROXY=${proxy}" | sudo tee --append /etc/environment
export "HTTP_PROXY=${proxy}"
echo "https_proxy=${proxy}" | sudo tee --append /etc/environment
export "https_proxy=${proxy}"
echo "HTTPS_PROXY=${proxy}" | sudo tee --append /etc/environment
export "HTTPS_PROXY=${proxy}"
echo -e "Acquire::http::proxy \"${proxy}\";\nAcquire::ftp::proxy \"${proxy}\";\nAcquire::https::proxy \"${proxy}\";" | sudo tee --append /etc/apt/apt.conf.d/90proxies

source torsocks on
echo ". torsocks on" >> ~/.bashrc
```
