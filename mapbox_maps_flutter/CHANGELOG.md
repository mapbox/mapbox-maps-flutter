### main

* Add `MapboxMap.httpService.setMaxRequestsPerHost` to cap the number of concurrent HTTP requests per host issued by the underlying HTTP service. Useful for reducing the chance of hitting per-token rate limits during offline tile region downloads.

### 3.0.0-beta.1