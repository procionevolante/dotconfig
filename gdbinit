# command history
set history save on
set history size 10000
set history filename ~/.gdb_history

define peconnect
    # copied from s32ds -> run/debug settings -> Debugger -> commands:
    set mem inaccessible-by-default off
    set tcp auto-retry on
    set tcp connect-timeout 240
    set remotetimeout 60
    # - - -

    target remote localhost:7244
end

# colored prompt
set prompt \033[1m(gdb) \033[0m

# large listing
set listsize 21

# styling
set style enabled on
set style sources on

# print prompt like LLDB's
# this needs to mess a bit with `style enabled` to work
define ll
    set style enabled off
    # black fg color for "invisible text"
    echo \033[30m
    # l . needed to set "current line" so that `l -` works as we want
    with listsize 1 -- l .
    echo \033[0m
    with listsize 10 -- with style enabled on -- l -
    echo \033[32m
    set style enabled on
    # line number is still printed with previous colors
    with listsize 1 -- l .
    with listsize 10 -- l
end
# alternative which assumes that listing lines don't wrap and listsize == 21
#define ll
#   with listsize 21 -- list .
#   !printf "\e[11F\e[7m>>\e[11E\e[0m"
# gdb's printf and echo filter out cursor-moving escape sequences...
# this otherwise would be much faster than invoking a shell
#   printf "\e[11F\e[7m>>\e[11E\e[0m"
#end

# invoke LLDB's prompt like when lldb invokes it
define hook-stop
    ll
end
define hookpost-frame
    ll
end
define hookpost-up
    ll
end
define hookpost-down
    ll
end

