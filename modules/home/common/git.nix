# Git + GitHub, identical on every host. Identity comes from `user` in flake.nix.
{ user, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = user.git.name;
        email = user.git.email;
      };
      init.defaultBranch = "main";
      fetch = {
        prune = true;
        pruneTags = true;
      };
      pull.ff = "only";
    };
  };

  # GitHub CLI (run `gh auth login` once per machine; it can also act as a
  # git credential helper for https remotes).
  programs.gh.enable = true;
}
