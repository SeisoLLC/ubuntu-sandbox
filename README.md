# Ubuntu sandbox

An Ubuntu sandbox for experimentation and proof of concepts.

## Alternative docker runtimes
If you want to `gVisor` as the docker runtime after starting the VM, use:
```bash
docker run -it --runtime=runsc --rm alpine
```
