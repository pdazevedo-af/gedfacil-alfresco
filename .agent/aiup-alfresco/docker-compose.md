---
description: "Generate a Docker Compose file with full ACS stack."
allowed-tools: "Read, Write, Grep, Glob"
argument-hint: "[ACS version, e.g. 26.1]"
---

# /docker-compose — Docker Compose Generator

Generate a complete `compose.yaml` for an Alfresco Content Services stack.

## Input
- ACS version from "$ARGUMENTS" or default to 7.3
- Read `REQUIREMENTS.md` for any deployment-specific requirements
- Resolve the `Root path` values from Section 2 (Project Architecture)

## Output File
`compose.yaml` at project root.

## Required Services

### Core
- `alfresco` — ACS repository (with extension JAR mounted or built into image)
- `postgres` — PostgreSQL database
- `activemq` — Apache ActiveMQ message broker

### Transform
- `transform-core-aio` — All-in-one Transform Service

- `solr6` — for Solr-based search

### Optional
- `share` — Share UI (if content model forms are needed)
- `proxy` — Nginx or similar reverse proxy
- `content-app` — Alfresco Content App (ACA)
- `{extension-name}` — Out-of-Process Spring Boot app (if `/events` command was used)

## Conventions
- Use Docker Compose v2 format (no `version:` key)
- Every service must have a `healthcheck`
- Use `condition: service_healthy` in `depends_on`
- Use named volumes for persistent data
- `compose.yaml` always lives at the repository root, even in Mixed mode
- If a Platform JAR project is present, mount or copy its built artifact from the Platform JAR `Root path`
- If a Share JAR project is present, add a `share` service and use the Share project's `Root path` as the authoritative source for Share-tier resources
- If a Share JAR project is present, mount or copy `src/main/resources/alfresco/web-extension/` and `src/main/resources/alfresco/site-webscripts/` from the Share project into the Share container
- If an Aikau customization generates `src/main/resources/META-INF/resources/`, ensure those client-side resources are also copied into the Share image or otherwise made available to Share's webapp classpath/static resources
- If an Out-of-Process Spring Boot app is present, add it as a service that depends on `activemq` and `alfresco` with `condition: service_healthy`
- If an Out-of-Process Spring Boot app is present, its `build:` context must point to the Event Handler `Root path` from `REQUIREMENTS.md` (`.` for Event Handler only mode, `{name}-events/` for Mixed mode)
- Never assume the Platform JAR, Share JAR, and Event Handler share the same build context or the same deployable artifact
- Never mount Share resources into the `alfresco` service, and never mount repository module resources into the `share` service

## Canonical Image Tags (ACS 7.3 Community)

```
alfresco/alfresco-content-repository-community:7.3.0
alfresco/alfresco-share:7.3.0
alfresco/alfresco-search-services:2.0.x
postgres:14.4
docker.io/alfresco/alfresco-activemq:5.17.x
alfresco/alfresco-transform-core-aio:3.1.x
nginx:stable-alpine
```

## Share Healthcheck — critical note

`/share/page/home` exists in Share 7.3 and is usually a good healthcheck target.

Use this healthcheck instead — it accepts any 2xx or 3xx response from the Share root:

```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/share/ | grep -qE '^[23]'"]
  interval: 30s
  timeout: 10s
  retries: 5
  start_period: 30s
```

## Share Addon Deployment Notes

When `REQUIREMENTS.md` declares a **Share JAR** project:

- Include the `share` service even if the repository-side project is optional for that scenario
- Use the Share project's `Root path` from Section 2 as the source for:
  - `alfresco/web-extension/`
  - `alfresco/site-webscripts/`
  - `META-INF/resources/` when Aikau custom widgets are generated
- Prefer one of these deployment approaches:
  - bind-mount the Share resource directories for local development
  - build a custom Share image that copies the Share project resources into the container
- Keep deployment boundaries explicit:
  - repository artifacts go to `alfresco`
  - Share-tier artifacts go to `share`
  - event-handler artifacts run as their own Spring Boot service

Minimum validation expectation for Share-enabled stacks:

- Share root healthcheck returns `2xx` or `3xx`
- generated Share pages/components do not prevent Share startup
- the generated Share resources come from the Share project root, not from the repository project

## Encryption Keystore (ACS 7.3)

ACS 7.3 ships with a JCEKS keystore inside the image at
`/usr/local/tomcat/shared/classes/alfresco/extension/keystore/keystore`.

Only `JAVA_TOOL_OPTIONS` is required:

```yaml
alfresco:
  environment:
    JAVA_TOOL_OPTIONS: >-
      -Dencryption.keystore.type=JCEKS
      -Dencryption.cipherAlgorithm=AES/CBC/PKCS5Padding
      -Dencryption.keyAlgorithm=AES
      -Dencryption.keystore.location=/usr/local/tomcat/shared/classes/alfresco/extension/keystore/keystore
      -Dmetadata-keystore.password=mp6yc0UD9e
      -Dmetadata-keystore.aliases=metadata
      -Dmetadata-keystore.metadata.password=oKIWzVdEdA
      -Dmetadata-keystore.metadata.algorithm=AES
```

> **Common pitfall**: using `oKIWzOIvdD` (wrong) instead of `oKIWzVdEdA` (correct) for
> `-Dmetadata-keystore.metadata.password` causes `02240004 Failed to retrieve keys from keystore:
> Given final block not properly padded`. Always use `oKIWzVdEdA`.
> Omitting `JAVA_TOOL_OPTIONS` entirely fails with `02240000 Unable to get secret key: no key information is provided`.

## Validation
After generation, invoke `docker-compose-healthcheck-injector` skill.
