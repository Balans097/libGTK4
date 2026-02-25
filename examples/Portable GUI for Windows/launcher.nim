# launcher.nim
# Launcher for Calculator on Windows - adds /libs/ to PATH and runs main app

# nim c -d:release --app:gui launcher.nim



when defined(windows):
  import os, osproc
  const mainProgramName = "calculator.exe"

  let exePath = getAppDir()
  let libsPath = exePath / "libs"
  putEnv("PATH", libsPath & ";" & getEnv("PATH"))

  # Launch without waiting; launcher exits immediately
  discard startProcess(
    exePath / mainProgramName,
    workingDir = exePath,
    # Pass launcher arguments to main program
    args = commandLineParams(),
    options = {poParentStreams})