alias r := rebuild

hostname := `uname -n`
username := "zane"

rebuild:
  if hostname == "adelaide" {
    sudo nixos-rebuild --flake .
  } else {
    home-manager switch --flake .
  }
