# Coder in Docker

[[Try the Demo](https://labs.play-with-docker.com/?stack=https://gist.githubusercontent.com/sr229/fbb05dfb1e3cb8ec8dc0f9ad8976f40c/raw/d34635e38a8dcf9b29e0cc7c70819de4093077f5/docker-stack.yml)]

This is a distribution of Coder's [Visual Studio Code in browser](https://github.com/codercom/code-server) designed to work for CNCF-compliant orchestators.

## Running

We maintain two tags that has a specific container orchestrator usage.

- For OpenShift use the `chinodesuuu/coder:openshift` image.
- Kubernetes and anything else can use the `chinodesuuu/coder:vanilla`/`chinodesuuu/coder:latest` image.

> Keep in mind that Coder in Kubernetes does not play well with non-PVC mounts, `sudo` tends to fail to work with the volume mount on `hostMount` or NFS volumes, so make sure you set `nosuid` for the mount.

After the pull has been done, make sure you bound to port 9000 and mount a volume in `/home/coder/projects`.

## Enabling SSL or Auth

to enable auth, make sure you set the environment variable `CODER_ENABLE_AUTH` to true.

when `CODER_ENABLE_AUTH` is set to true, you must provide your password via `CODER_PASSWORD` else, it defaults to "coder".

To enable SSL, mount your certificates' dir to `/home/coder/certs` and set `CODER_ENABLE_SSL` to true.

Keep in mind for SSL, your files should be named as follows:

- `coder.crt` for the Certificate chain.
- `coder.key` for the Certificate key.

If you didn't name your files as such - it will be invalid and Coder will refuse to work.
