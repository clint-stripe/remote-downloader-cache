start the [bazel-remote server](https://github.com/buchgr/bazel-remote) with `./run-bazel-remote.sh`

with bazel 5.0.0, `--noremote_accept_cached` will encounter an error:

```
USE_BAZEL_VERSION=5.0.0 bazelisk build hello \
    --remote_cache=grpc://127.0.0.1:9092 \
    --experimental_remote_downloader=grpc://127.0.0.1:9092 \
    --disk_cache=tmp/disk_cache \
    --repository_cache=tmp/repo_cache \
    --noremote_accept_cached
```

```
Error in download_and_extract: com.google.devtools.build.lib.bazel.repository.downloader.UnrecoverableHttpException: 
Checksum was e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
but wanted bc81f1ba47ef5cc68ad32225c3d0e70b8c6f6077663835438da8d5733f917598
```

`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` is the checksum of the empty file.

`USE_BAZEL_VERSION=4.2.2` with the same flags works as expected: results in the AC are ignored, but the CAS is still usable for the remote downloader