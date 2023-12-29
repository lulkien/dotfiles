# Load themes
if set -q QF_STYLE; and test -f "$QF_RUNTIME_PATH/styles/$QF_STYLE.fish"
    source $QF_RUNTIME_PATH/styles/$QF_STYLE.fish
else
    source $QF_RUNTIME_PATH/styles/$QF_STYLE_DEFAULT.fish
end

# Set color palette
set -g QF_CL_RESET      (set_color normal)

set -q red; or set -g red ff0000
set -g QF_CL_RED_N      $QF_CL_RESET(set_color $red)
set -g QF_CL_RED_B      (set_color -o $red)

set -q orange; or set -g orange ffa500
set -g QF_CL_ORANGE_N   $QF_CL_RESET(set_color $orange)
set -g QF_CL_ORANGE_B   (set_color -o $orange)

set -q yellow; or set -g yellow ffff00
set -g QF_CL_YELLOW_N   $QF_CL_RESET(set_color $yellow)
set -g QF_CL_YELLOW_B   (set_color -o $yellow)

set -q green; or set -g green 00ff00
set -g QF_CL_GREEN_N    $QF_CL_RESET(set_color $green)
set -g QF_CL_GREEN_B    (set_color -o $green)

set -q cyan; or set -g cyan 00ffff
set -g QF_CL_CYAN_N     $QF_CL_RESET(set_color $cyan)
set -g QF_CL_CYAN_B     (set_color -o $cyan)

set -q blue; or set -g blue 0000ff
set -g QF_CL_BLUE_N     $QF_CL_RESET(set_color $blue)
set -g QF_CL_BLUE_B     (set_color -o $blue)

set -q purple; or set -g purple 800080
set -g QF_CL_PURPLE_N   $QF_CL_RESET(set_color $purple)
set -g QF_CL_PURPLE_B   (set_color -o $purple)

set -q pink; or set -g pink ffc0cb
set -g QF_CL_PINK_N  $QF_CL_RESET(set_color $pink)
set -g QF_CL_PINK_B  (set_color -o $pink)

set -q white; or set -g white ffffff
set -g QF_CL_WHITE_N    $QF_CL_RESET(set_color $white)
set -g QF_CL_WHITE_B    (set_color -o $white)

set -q gray; or set -q gray 808080
set -g QF_CL_GRAY_N     $QF_CL_RESET(set_color $gray)
set -g QF_CL_GRAY_B     (set_color -o $gray)
