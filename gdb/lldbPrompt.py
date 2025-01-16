#!/bin/python3

# IMHO one of the few things that lldb got right over gdb is its prompt.
# gdb TUI is not so great, and its default prompt is even worse because it
# doesn't highlight the current line.
# This script attempts to use gdb's python API to define a function that prints
# a prompt like lldb's

# To use it you can either call it directly or call it from hooks in gdb's conf

import gdb

class LldbPrompt(gdb.Command):
    '''Print a prompt of the current frame in the style of LLDB'''

    def __init__(self):
        super(LldbPrompt, self).__init__("lldb-prompt", gdb.COMMAND_STATUS)
        self.curLineMarker = '-> '

    def invoke(self, args, from_tty):
        self.dont_repeat() # no need to repeat the "prompt" command
        try:
            frame = gdb.selected_frame() # type = Frame
        except gdb.error:
            return # no frame selected, return

        curpos = frame.find_sal() # type = Symtab_and_line
        if curpos.symtab != None: # can gdb list around here?
            listing = gdb.execute(f"list {curpos.symtab.filename}:{curpos.line}", True, True)
            newListing = self.markLineInListing(curpos.line, listing)
            print(newListing, end='')

    def markLineInListing(self, lineNum, listing):
        lineNum = str(lineNum)
        lines = listing.split('\n')
        ret = ''
        for line in lines:
            if len(line) <= 0:
                continue
            if line[:len(lineNum)] == lineNum:
                ret += self.curLineMarker
            else:
                ret += " " * len(self.curLineMarker)
            ret += line + '\n'
        return ret

LldbPrompt()
