#!/bin/bash
# 
# simple tmux assh session manager, feel free to modify it to your needs
#
# by bkzk 


# EDIT groups array and include here all groups you need 
# A list of group you can get with: 
#  assh -g
# A list of group members get with:
#  assh -g groupname,groupname2,..,groupnameN

groups=()

alias tmux='tmux -2'

# EDIT session name if you find a better name
session=aSSHtmux

# EDIT assh variable if assh is not found with system $PATH 
assh=$(which assh) 




while getopts "klh?g:" opt; do
    case "$opt" in
    h|\?)
        echo "Usage: $0  [option]"
        echo "   -g [group1,group2,..,groupN]  - creates saparetes window for group members"
        echo "   -k                            - kill tmux session "
        echo "   -l                            - list tmux session "
        exit 0; 
    ;;
    g) groups=(${OPTARG//,/ })     
    ;;
    k) tmux kill-session -t${session}  ; exit 0
    ;;
    l) tmux list-session ; exit 0
    ;;
    esac
done

if [[ $# -eq 0 ]]; then
   if [ ${#groups[@]} -eq 0 ]; then
      echo "Missing arguments and empty groups array ${#groups[*]}" ; exit ;
   fi
fi 
if [ ${#groups[@]} -eq 0 ]; then
   echo "Empty groups array ${#groups[*]}" ; exit ;
fi



# ---------------------------------------------------------------------------- # 

if [ ! -f ~/.dialogrc_tmux ]; then
   echo -en "use_shadow = OFF\nuse_colors = OFF\n" > ~/.dialogrc_tmux
fi

tmux has-session -t ${session} &>/dev/null

if [ $? != 0 ]; then

   tmux new-session -d -s${session} -n 'sh'
   tmux set-option -t${session} set-remain-on-exit on &> /dev/null
   tmux bind-key R respawn-window &>/dev/null
   tmux set-option default-command 'DIALOGRC=".dialogrc_tmux" dialog --clear --title "ASSH - Inputbox"  --inputbox "Enter your alias or IP address " 8 60 2>/tmp/input && clear && ~/.bin/assh $(< /tmp/input )' &>/dev/null

fi


for group in ${groups[*]}
do
  echo "Connecting with members of group: $group "
  for host in `assh -g ${group} -quiet` 
  do
    echo -ne " \r*tmux: new-window -> ${host}"
    tmux new-window -t${session} -n "${host}" "assh ${host} "
  done
  echo -e " \r *tmux: processing of $group group done"
done

echo "You can now attach your session: tmux attach -t ${session}"
exit 0

