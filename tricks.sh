
# trick 1: split $PATH into multiple lines
echo $PATH | tr : \\n

# trick 2: use absolute path for symlink 

# trick 3: bash initialization (ref: man bash) 
# --------------------------------------------------
# |                 |     login        | non-login |
# |------------------------------------------------|
# |     interactive | /etc/profile     | ~/.bashrc |
# |-----------------| ~/.bash_profile* |-----------|
# | non-interactive | ~/.bash_login    | BASH_ENV  |
# |                 | ~/.profile       |           |
# --------------------------------------------------

# trick 4: check how many shells deep 
#          SHLVL starts at 2 when using tmux
echo $SHLVL 
