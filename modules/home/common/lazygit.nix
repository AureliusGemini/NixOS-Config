# lazygit with shortcuts for this repo's workflow.
# The keys are guesses; if one collides with a built-in, change it.
{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings.customCommands = [
      {
        key = "X";
        context = "global";
        command = "nh os switch --ask";
        output = "terminal"; # older lazygit: use `subprocess = true;` instead
        description = "Rebuild this machine (nh)";
      }
      {
        key = "U";
        context = "global";
        command = "git pull --rebase --autostash";
        output = "log";
        loadingText = "Pulling";
        description = "Pull (rebase + autostash)";
      }
    ];
  };
}
