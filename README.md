# Ubuntu sandbox

This is my personal Ubuntu sandbox vagrant machine

## Alternative docker runtimes
If you want to `gVisor` as the docker runtime after starting the VM, use:
```bash
docker run -it --runtime=runsc --rm alpine
```
