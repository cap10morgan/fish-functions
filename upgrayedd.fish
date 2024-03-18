function home-manager-generations
  set -l num $argv[1] 
  home-manager generations | head -$num | cut -d" " -f 7 | tac
end

function upgrayedd
  # Requires nix, home-manager, coreutils, nvd

  echo "Updating home-manager flake"
  set -l current_gen (home-manager-generations 1)
  # echo "Current home-manager generation: $current_gen"
  nix flake update ~/.config/home-manager --commit-lock-file
  home-manager switch

  set -l two_most_recent_gens (home-manager-generations 2)
  # echo "Two most recent home-manager generations: $two_most_recent_gens"
  if test $current_gen != $two_most_recent_gens[1]
    echo -e '\nPackage updates:'
    echo $two_most_recent_gens | xargs nvd diff
  end

  # Don't actually think we need to update this regularly and it asks for
  # my password a lot, which is annoying...
  # echo "Updating nix-darwin flake"
  # nix flake update ~/.config/nix-darwin --commit-lock-file
  # darwin-rebuild switch --flake .config/nix-darwin
end
