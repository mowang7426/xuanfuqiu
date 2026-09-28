# FloatBack

FloatBack is an iOS jailbreak tweak for iOS 15 through iOS 17. A single AssistiveTouch tap is intended to return the foreground application to its previous page.

## Current implementation

The project contains the cross-process notification bridge and the UIKit return controller. `FloatBackSpringBoard` handles the system event, while `FloatBackApps` handles the current application's UIKit navigation. The SpringBoard AssistiveTouch selector is isolated in `Tweak.xm` and must be confirmed on the target iOS build before enabling the final hook.

The return controller handles these UIKit cases:

- Dismiss the top presented view controller.
- Pop the visible navigation controller when it has a previous controller.
- Traverse tab and navigation containers before applying the return action.

## Build

### Local environment

Run the setup script on a macOS or Linux development machine. The script installs the roothide-compatible Theos toolchain into `~/theos` by default and prints the required `THEOS` export.

```bash
bash scripts/setup-theos.sh
export THEOS="$HOME/theos"
```

The local machine also needs an Objective-C toolchain, `make`, `perl`, `curl`, and `git`. The roothide Theos installer supplies the signing tool used by the package build; `ldid` is not installed through the standard Ubuntu package repository.

### Local packages

```bash
# Build the rootless package
make clean package THEOS_PACKAGE_SCHEME=rootless

# Build the roothide package
make clean package THEOS_PACKAGE_SCHEME=roothide
```

The generated packages are written to `packages/`.

### GitHub Actions

Every push to `master`, pull request, or manual workflow run executes `.github/workflows/build.yml`. The workflow installs the roothide Theos environment, builds both package schemes, and uploads `FloatBack-debs` as an Actions artifact.

## Device verification

Install one package on the test device, run `sbreload`, and inspect the device log for:

```text
[FloatBack] SpringBoard bridge loaded
```

The AssistiveTouch hook must be verified separately on each supported major iOS version because its private implementation can change between iOS releases. The app component currently receives the Darwin notification and applies UIKit back behavior; the notification emitter becomes active after the target AssistiveTouch single-tap selector is confirmed.
