# Trusted CBA Certificates

This repository contains the canonical list of trusted CBA CAs.

It is broken into two parts:
- `roots/` contains the list of CAs shipped with most browsers. It is derived
  from the Mozilla list.
- `internal/` contains the list of CAs which need to be trusted by software
  running on the internal CBA network.
  
This format has been chosen to provide a generic way to inject this information
into Docker containers.

# Updating
The root certificate bundle is derived from the Mozilla upstream bundle as
presented in their source tree via the `mk-ca-bundle` script
(modified from https://curl.haxx.se/cvssource/lib/mk-ca-bundle.pl).

This script finds the certificate locations automatically (see the `%urls` hash).
