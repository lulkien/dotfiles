# Dracula Color Palette
set -g red          ff5555
set -g orange       ffb86c
set -g yellow       f1fa8c
set -g green        50fa7b
set -g cyan         8be9fd
set -g blue         6272a4
set -g purple       bd93f9
set -g pink         ff79c6
set -g white        f8f8f2
set -g gray         44475a

set -l foreground   $white
set -l selection    $gray
set -l comment      $blue

# Syntax Highlighting Colors
set -g fish_color_normal        $foreground
set -g fish_color_command       $cyan
set -g fish_color_keyword       $pink
set -g fish_color_quote         $yellow
set -g fish_color_redirection   $foreground
set -g fish_color_end           $orange
set -g fish_color_error         $red
set -g fish_color_param         $purple
set -g fish_color_comment       $comment
set -g fish_color_operator      $green
set -g fish_color_escape        $pink

set -g fish_color_autosuggestion $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection

# Completion Pager Colors
set -g fish_pager_color_progress    $comment
set -g fish_pager_color_prefix      $cyan
set -g fish_pager_color_completion  $foreground
set -g fish_pager_color_description $comment
