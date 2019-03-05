workflow "Build Image" {
  on = "push"
  resolves = [
    "Push Image",
    "GitHub Action for Docker",
  ]
}

action "GitHub Action for Docker" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t chinodesuuuu/coder:latest ."
}
