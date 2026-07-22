# Plugin Development Guide

Plugins are independent Bash scripts that hook into the PAG framework to extend its functionality.

## Hooking into PAG
Plugins can register themselves into existing extension points.

```bash
#!/usr/bin/env bash

# Register your plugin hook
plugin_register "pre_build" "my_custom_hook"

my_custom_hook() {
    log_info "Running my custom hook before build!"
}
```

## Best Practices
1. Avoid touching internal variables. Only use public APIs provided by the framework.
2. Namespace your functions to prevent collisions (e.g., `myplugin_do_something`).
3. Follow the standard style guides (ShellCheck and shfmt).
