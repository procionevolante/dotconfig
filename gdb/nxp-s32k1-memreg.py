#!/bin/python3

# Sets convenience variables useful when debugging FW on an NXP S32K1xx MCU
#
# Addresses are correct but the types are sourced from the standard NXP
# libraries, which you may or may not be using in your project
#
# Import with `source` within gdb / .gdbinit / macros / ...

import gdb

class NxpReg():
    def __init__(self, addr, name, nxp_type):
        self.addr = addr
        self.name = name
        self.nxp_type = nxp_type

_regs = [
    # ARM core registers
    NxpReg(0xe000e100, 'nvic', 'S32_NVIC_Type'),
    NxpReg(0xe000e000, 'scb', 'S32_SCB_Type'),
    # ADC
    NxpReg(0x4003b000, 'adc0', 'ADC_Type'),
    NxpReg(0x40027000, 'adc1', 'ADC_Type'),
    # timers
    NxpReg(0x40037000, 'lpit', 'LPIT_Type'),
    # watchdogs
    NxpReg(0x40270000, 'wdog', 'WDOG_Type'),
    # memory
    NxpReg(0x40020000, 'ftfc', 'FTFC_Type'), # flash
]

for reg in _regs:
    print(f'Debug access to 0x{reg.addr:04x} via ${reg.name:8} ', end='')
    try:
        sym = gdb.lookup_type(f'{reg.nxp_type}')
    except gdb.error:
        sym = None

    if sym is not None: # if symbol was found
        gdb.execute(f'set ${reg.name} = (({reg.nxp_type} *){reg.addr})')
        print('')
    else:
        gdb.execute(f'set ${reg.name} = {reg.addr}')
        print('(ADDRESS ONLY)')
